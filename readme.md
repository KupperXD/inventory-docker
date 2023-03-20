# svk-inventory dev sandbox
Данный репозиторий является локальным окружением разработки проекта.
VERSION 0.1.0
---

## Описание контейнеров
- **api** - контейнер с сервером приложения [Nest]
- **admin** - контейнер с фронтом приложения
- **nginx** - контейнер для обработки пользовательских запросов
- **postgres** - контейнер с основной базой данной [PostgreSQL] проекта

---

## Установка
Для установки необходимо чётко соблюдать последовательность действий и структуру вложенности директорий.

### 1. Убедиться в наличии доступа ко всем репозиториям проекта
- https://github.com/KupperXD/inventory-docker - репозиторий docker-песочницы
- https://github.com/KupperXD/inventory-api - репозиторий api
- https://github.com/KupperXD/inventory-admin - репозиторий фронтенда

### 2. Создать директории для проекта
Внутри директории `/path/to/project` необходимо создать поддиректории:
- docker
- api
- admin

```bash
mkdir /path/to/project

cd /path/to/project

mkdir docker
mkdir api
mkdir admin
```

В итоге должна получиться следующая структура:
- **/path/to/project**
    - /path/to/project/**docker**
    - /path/to/project/**api**
    - /path/to/project/**admin**

### 3. Клонировать репозитории в соответствующие директории
```bash
cd /path/to/project

git clone git@github.com:KupperXD/inventory-docker.git docker
git clone git@github.com:KupperXD/inventory-api.git api
git clone git@github.com:KupperXD/inventory-admin.git admin
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

### Api:
#### 1. Скопировать файл конфигурации
```bash
cd /path/to/project/api
cp .env.example .env

cd /path/to/project/admin
cp .env.example .env
```

#### 2. Отредактировать файл конфигурации (опционально)

### 5. Запустить окружение
Для запуска окружения требуется перейти в директорию `/path/to/project/docker` и запустить команду:
```bash
make up
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

### 6. Выполнить миграции

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
