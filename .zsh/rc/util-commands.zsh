rubymine() {
  open -na "RubyMine.app" --args "$@"
}

rails-db-schema-regenerate() {
  bin/rails db:environment:set RAILS_ENV=test && RAILS_ENV=test bin/rails db:migrate:reset
}

kill-port() {
  kill -9 $(lsof -t -i:$1)
}

overmind-start() {
  dev-rails-release-processes
  rm ./.overmind.sock 2> /dev/null

  while (( $# > 0 ))
  do
    case $1 in
      -i | --install)
        local enabledInstall=1
        ;;
      -*)
        echo "invalid option: $1"
        ;;
    esac
    shift
  done

  if [ -v enabledInstall ]; then
    echo 'Run install'
    bundle install && yarn install --check-files
  fi

  if [ -e Procfile.local ]; then
    file="Procfile.local"
  elif [ -e Procfile.dev ]; then
    file="Procfile.dev"
  else
    file="Procfile"
  fi

  echo "overmind statrt -f ${file}"

  overmind start -f ${file} | tspin
}

release-port() {
  echo "releasing port $1 using process"
  lsof -i:$1
  lsof -i:$1 | sed -e '1d' | awk '{print $2}' | xargs kill -9
}

dev-rails-release-processes() {
  echo "dev-app-release-port"
  release-port $(dev-rails-app-port)
  release-port $(dev-rails-jsbuild-port)
  echo "releasing puma port ${RAILS_PORT} using"
  ps aux | grep 'puma' | grep ":${RAILS_PORT}" | awk '{print $2}' | xargs kill -9
  rm tmp/pids/server.pid 2> /dev/null
}

dev-rails-app-name() {
  basename `pwd`
}

dev-rails-app-port() {
  app_name=$(dev-rails-app-name)
  head -n1 ~/.puma-dev/$app_name
}

dev-rails-jsbuild-port() {
  expr $(dev-rails-app-port) + 10000
}

rails-credentials() {
  command=$1
  env=$2
  app=`basename $(pwd)`
  if [ -z $env ] || [ -z $app ] || [ -z $command ]; then
    echo "Invalid arguments. Please run rails-credentials [command] [app] [env]"
    return 1
  fi

  op whoami > /dev/null || eval $(op signin)
  op whoami > /dev/null 2> /dev/null

  if [ $? -ne 0 ]; then
    echo "Failed 1Password signin"
    return 1
  fi

  echo "run:"
  exec_command="RAILS_MASTER_KEY=\`op read op://dev/$app-rails-credentials/$env\` RAILS_ENV=$env bundle exec rails credentials:$command -e $env"
  echo "  $exec_command\n"

  eval $exec_command
}

gh-check-failure() {
  run_id=$1

  if [ -z $run_id ]; then
    current_branch_name=$(git symbolic-ref --short HEAD)
    run_id=$(gh run list --branch $current_branch_name --json databaseId,name,createdAt | jq -r '[.[] | select(.name | contains("rspec") or contains("Ruby"))] | sort_by(.createdAt) | last | .databaseId')
  fi

  gh run view --log-failed $run_id | grep "rspec ./spec" | grep -oE '\./spec/\S+' | sort -u
}

gh-wait() {
  gh run watch -i1 && afplay /System/Library/Sounds/Glass.aiff
}

dc-build() {
  docker build -t $(basename `pwd`) .
}

cc-worktree() {
  worktree_name=$1
  gwq add -b ${worktree_name} \
    && cd $(gwq get ${worktree_name}) \
    && claude
}

find-unused-app-port() {
  start_port="${1:-3130}"

  port=$start_port
  max_port=$((START_PORT + 100))
  while lsof -iTCP:"$port" -sTCP:LISTEN -t >/dev/null 2>&1; do
    port=$((port + 1))
    if [ "$port" -gt "$max_port" ]; then
      echo "Error: No available port found in range $START_PORT-$max_port" >&2
      exit 1
    fi
  done

  echo "$port"
}

find-app-port() {
  head -n1 ~/.puma-dev/$(basename `pwd`) 2> /dev/null | find-unused-app-port
}

git-warp() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Not in a git repository"
    return 1
  fi

  branch=$1
  if [ -z "$branch" ]; then
    if ! command -v fzf > /dev/null 2>&1; then
      echo "Usage: git-warp <branch>"
      return 1
    fi
    branch=$(git branch --format='%(refname:short)' | fzf --height=40% --reverse --prompt='branch> ')
    if [ -z "$branch" ]; then
      return 1
    fi
  fi

  if ! git show-ref --verify --quiet "refs/heads/$branch"; then
    echo "Branch '$branch' does not exist"
    return 1
  fi

  current_worktree=$(git rev-parse --path-format=absolute --show-toplevel)
  target_worktree=$(git worktree list --porcelain | awk -v b="refs/heads/$branch" '
    /^worktree / { wt = substr($0, 10) }
    /^branch / && $2 == b { print wt; exit }
  ')

  if [ -n "$target_worktree" ]; then
    if [ "$target_worktree" = "$current_worktree" ]; then
      echo "Already on '$branch'"
      return 0
    fi
    cd "$target_worktree"
  else
    git checkout "$branch"
  fi
}

git-deploy-staging() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Not in a git repository"
    return 1
  fi

  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Working tree is not clean. Commit or stash your changes first."
    return 1
  fi

  branch=$1
  if [ -z "$branch" ]; then
    if ! command -v fzf > /dev/null 2>&1; then
      echo "Usage: git-deploy-staging <branch>"
      return 1
    fi
    branch=$(git branch --format='%(refname:short)' | fzf --height=40% --reverse --prompt='deploy to staging> ')
    if [ -z "$branch" ]; then
      return 1
    fi
  fi

  if ! git show-ref --verify --quiet "refs/heads/$branch"; then
    echo "Branch '$branch' does not exist"
    return 1
  fi

  if [ "$branch" = "staging" ]; then
    echo "Cannot deploy 'staging' to itself"
    return 1
  fi

  original_branch=$(git symbolic-ref --short HEAD)

  echo "==> git fetch origin"
  git fetch origin || return 1

  echo "==> git checkout staging"
  git checkout staging || return 1

  echo "==> git merge --ff-only origin/staging"
  git merge --ff-only origin/staging || {
    git checkout "$original_branch"
    return 1
  }

  echo "==> git merge --no-ff $branch"
  if ! git merge --no-ff "$branch"; then
    echo "Merge failed. Resolve conflicts on 'staging' and push manually."
    return 1
  fi

  echo "==> git push origin staging"
  git push origin staging || {
    echo "Push failed. You are still on 'staging'."
    return 1
  }

  echo "==> git checkout $original_branch"
  git checkout "$original_branch"
}
