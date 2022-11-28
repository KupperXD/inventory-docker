# svk-inventory dev sandbox
Данный репозиторий является локальным окружением разработки проекта.

---

## Описание контейнеров
- **web** - контейнер с сервером приложения [Symfony]
- **admin** - контейнер с фронтом приложения
- **nginx** - контейнер для обработки пользовательских запросов
- **postgres** - контейнер с основной базой данной [PostgreSQL] проекта

---

## Установка
Для установки необходимо чётко соблюдать последовательность действий и структуру вложенности директорий.

### 1. Убедиться в наличии доступа ко всем репозиториям проекта
- https://gitlab.com/internet-design/svk_inventory_docker - репозиторий docker-песочницы
- https://gitlab.com/internet-design/svk_inventory - репозиторий приложения
- https://gitlab.com/internet-design/svk_inventory_frontend - репозиторий фронтенда

### 2. Создать директории для проекта
Внутри директории `/path/to/project` необходимо создать поддиректории:
- docker
- web
- admin

```bash
mkdir /path/to/project

cd /path/to/project

mkdir docker
mkdir web
mkdir admin
```

В итоге должна получиться следующая структура:
- **/path/to/project**
    - /path/to/project/**docker**
    - /path/to/project/**web**
    - /path/to/project/**admin**

### 3. Клонировать репозитории в соответствующие директории
```bash
cd /path/to/project

git clone git@gitlab.com:internet-design/svk_inventory_docker.git docker
git clone git@gitlab.com:internet-design/svk_inventory.git web
git clone git@gitlab.com:internet-design/svk_inventory_frontend.git admin
```

### 4. Конфигурации

### Докер:
#### 1. Скопировать файл конфигурации

```bash
cd /path/to/project/docker
cp .env.example .env
```

#### 2. Отредактировать файл конфигурации (опционально)
В файле `/path/to/project/docker/.env` можно отредактировать переменные:
- `USER_ID` - идентификатор вашего текущего локального пользователя (по умолчанию - *1000*)
- `GROUP_ID` - идентификатор группы вашего текущего локального пользователя (по умолчанию - *1000*)

Если локально порт 800 занят, можно отредактировать переменную `NGINX_PORT` на любой доступный порт.  
С помощью этого порта можно будет подключаться в браузере к проекту:
`http://localhost:NGINX_PORT`

### Web:
#### 1. Скопировать файл конфигурации
```bash
cd /path/to/project/web
cp .env.example .env

cd /path/to/project/admin
cp .env.example .env
```

#### 2. Отредактировать файл конфигурации (опционально)
Если на шаге *4.2* менялся порт `NGINX_PORT`, необходимо в файле `/path/to/project/web/.env` отредактировать переменную `APP_URL`, указав нужный порт.


### 5. Запустить окружение
Для запуска окружения требуется перейти в директорию `/path/to/project/docker` и запустить команду:
```bash
docker-compose up -d
```

Первый запуск будет долгим, так как требуется:
- установка всех требуемых контейнеров;
- установка баз данных;
- установка пакетов сторонних вендоров из сторонних окружений.

Для проверки статуса запуска каждого контейнера можно воспользоваться командой:
```bash
docker-compose logs <id_контейнера>
```

Для просмотра списка контейнеров можно воспользоваться командой:
```bash
docker container ls
```

### 6. Установить пакеты и выполнить миграции
Стянуть дамп с СВК. Выполнить команду:

```bash
 make import-dump path="/path/to/dump.sql"
```

Либо

```bash
docker exec -i postgres psql --username pg_username database_name < /path/on/your/machine/dump.sql
```

Где
- `pg_username` -  `POSTGRES_USER` из .env файла в докере
- `database_name` -  `POSTGRES_DB` из .env файла в докере

В дальнейшем миграции нужно выполнять с помощью команды: 
```bash
make migrate
```

### 7. Прописать хосты
```bash
127.0.0.1 api.svk-inventory.local
127.0.0.1 admin.svk-inventory.local
```

### 8. Приложение будет доступно в браузере:
`http://admin.svk-inventory.local:NGINX_PORT`
