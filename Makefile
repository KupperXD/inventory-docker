WEB_SH=docker-compose exec -u www-data web sh -c
ADMIN_SH=docker-compose exec admin sh -c
WEB_PATH=/var/www/web
ADMIN_PATH=/var/www/admin

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

create_migrations: ## Создать миграции
	$(WEB_SH) 'cd $(WEB_PATH) && ./bin/console make:migration'

migrate: ## Выполнить миграции
	$(WEB_SH) 'cd $(WEB_PATH) && ./bin/console doctrine:migrations:migrate'

create_user: ## Создать пользователя (Пример make create_user credentials="email password")
	$(WEB_SH) 'cd $(WEB_PATH) && ./bin/console app:create-user $(credentials)'

import-dump: ## Иипорт дампа БД (path="путь до дампа". Пример make import-dump path="/tmp/dump.sql"
	docker exec -i svk-inventory_postgres psql --username svk_inventory svk_inventory < "$(path)"

up: ## Запуск докер-контейнеров
	docker-compose up -d  --build

down: ## Остановка докер-контейнеров
	docker-compose down

run: ## Запуск кастомной команды (make run command="команда")
	$(WEB_SH) "$(command)"

npm: ## Запуск кастомной команды npm (make run command="команда")
	$(ADMIN_SH) "cd $(ADMIN_PATH) && npm $(command)"
