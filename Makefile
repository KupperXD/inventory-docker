API_SH=docker-compose exec api sh -c
ADMIN_SH=docker-compose exec admin sh -c
API_PATH=/var/www/api
ADMIN_PATH=/var/www/admin

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

create-migrations: ## Создать миграции
	$(API_SH) 'cd $(API_PATH) && npm run migrate:dev:create'

migrate: ## Выполнить миграции
	$(API_SH) 'cd $(API_PATH) && npm run migrate:deploy'

create-prisma-client: ## Создать клиент призмы
	$(API_SH) 'cd $(API_PATH) && npm run prisma:generate'

create-user: ## Создать пользователя (make create-user email="email" password="password")
	$(API_SH) 'cd $(API_PATH) && npm run build && node ./dist/commander.js create-user -e $(email) -p $(password)'

import-dump: ## Иипорт дампа БД (path="путь до дампа". Пример make import-dump path="/tmp/dump.sql"
	docker exec -i svk-inventory_postgres psql --username svk-inventory svk-inventory < "$(path)"

up: ## Запуск докер-контейнеров
	docker-compose up -d  --build

down: ## Остановка докер-контейнеров
	docker-compose down

run: ## Запуск кастомной команды (make run command="команда")
	$(API_SH) "$(command)"

npm: ## Запуск кастомной команды npm (make run command="команда")
	$(ADMIN_SH) "cd $(ADMIN_PATH) && npm $(command)"
