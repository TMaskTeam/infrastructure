#!/usr/bin/env bash

set -e

PROJECT_NAME="loyalty"

show_help() {
  echo "Usage:"
  echo "  ./manage.sh [COMMAND]"
  echo
  echo "Commands:"
  echo "  up         Start all services"
  echo "  setup      Setup project cloning all repositories"
  echo "  down       Stop all services"
  echo "  restart    Restart all services"
  echo "  rebuild    Rebuild and start containers"
  echo "  logs       Show logs"
  echo "  clean      Remove containers, networks and volumes"
  echo "  ps         Show running containers"
  echo "  help       Show this help message"
}

setup() {
	echo "Setuping ${PROJECT_NAME}..."
	echo ""
	echo "Cloning repos"

	git clone -b main https://github.com/TMaskTeam/frontend.git
	git clone -b main https://github.com/TMaskTeam/backend.git
	git clone -b main https://github.com/TMaskTeam/qr-service.git
}

run_with_spinner() {
  local title="$1"
  shift

  local tmp_log
  tmp_log="$(mktemp)"

  "$@" >"$tmp_log" 2>&1 &
  local pid=$!

  local spin='|/-\'
  local i=0

  while kill -0 "$pid" 2>/dev/null; do
    printf '\r%s [%c]' "$title" "${spin:i++%${#spin}:1}"
    sleep 0.1
  done

  wait "$pid"
  local status=$?

  printf '\r%s ... done\n' "$title"
  sed '/^go: downloading /d' "$tmp_log"
  rm -f "$tmp_log"

  return "$status"
}

up() {
  echo "Starting ${PROJECT_NAME}..."
  docker compose up -d --wait --wait-timeout 60

  echo "Starting migration for ${PROJECT_NAME}..."

  run_with_spinner \
    "Installing goose" \
    docker exec loyalty-backend go install github.com/pressly/goose/v3/cmd/goose@latest

  run_with_spinner \
    "Applying migrations" \
    docker exec loyalty-backend sh ./src/scripts/migrations.test.sh --up

  docker exec loyalty-backend sh ./src/scripts/migrations.test.sh --status | grep "OK"
}

down() {
  echo "Stopping ${PROJECT_NAME}..."
  docker compose down
}

restart() {
  echo "Restarting ${PROJECT_NAME}..."
  docker compose restart
}

rebuild() {
  echo "Rebuilding ${PROJECT_NAME}..."
  docker compose down
  docker compose up --build -d
}

logs() {
	docker compose logs -f
}

clean() {
  echo "Removing all containers, networks and volumes..."
  docker compose down -v --rmi all --remove-orphans
}

ps_services() {
  docker compose ps
}

case "$1" in
  up)
    up
    ;;
  down)
    down
    ;;
	setup)
    setup
    ;;
  restart)
    restart
    ;;
  rebuild)
    rebuild
    ;;
  logs)
    logs
    ;;
  clean)
    clean
    ;;
  ps)
    ps_services
    ;;
  help|--help|-h|"")
    show_help
    ;;
  *)
    echo "Unknown command: $1"
    echo
    show_help
    exit 1
    ;;
esac