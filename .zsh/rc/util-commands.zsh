rubymine() {
  open -na "RubyMine.app" --args "$@"
}

rails-db-schema-regenerate() {
  RAILS_ENV=test bin/rake db:migrate:reset
}

foreman-start() {
  foreman-release-port

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

  echo "foreman statrt -f ${file}"

  foreman start -f ${file}
}

release-port() {
  echo "releasing $1 port using process"
  lsof -i:$1
  lsof -i:$1 | sed -e '1d' | awk '{print $2}' | xargs kill -9
}

foreman-release-port() {
  echo "foreman-release-port"
  release-port ${RAILS_PORT}
  release-port ${WEBPACKER_DEV_SERVER_PORT}
  kill -9 `ps aux | grep 'puma' | grep ":${RAILS_PORT}" | awk '{print $2}'`
  rm tmp/pids/server.pid
}

