rubymine() {
  open -na "RubyMine.app" --args "$@"
}

rails-db-schema-regenerate() {
  bin/rails db:environment:set RAILS_ENV=test && RAILS_ENV=test bin/rails db:migrate:reset
}

overmind-start() {
  dev-rails-release-port
  rm ./.overmind.sock

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
  echo "releasing $1 port using process"
  lsof -i:$1
  lsof -i:$1 | sed -e '1d' | awk '{print $2}' | xargs kill -9
}

dev-rails-release-port() {
  echo "dev-app-release-port"
  release-port $(dev-rails-app-port)
  release-port $(dev-rails-jsbuild-port)
  kill -9 `ps aux | grep 'puma' | grep ":${RAILS_PORT}" | awk '{print $2}'`
  rm tmp/pids/server.pid
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

kill-port() {
 kill -9 $(lsof -t -i:$1)
}
