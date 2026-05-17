# Как запустить

> **Перед началом склонируйте в текущую папку все сервисы**. Для удобства добавил отдельную команду для клонирования всего сразу

```bash
sh ./manage.sh setup
```

---

## Удобный запуск

Для запуска был написан специальный скрипт с которым можно ознакомится с помощью команды

```bash
sh ./manage.sh --help
```

---

### Обычный запуск

1. Настраиваем `.env`

> `VITE_DEV` отвечает за Mock-окружение. На данный момент реализован не весь функционал на Go-Backend. Поэтому можете запустить и протестировать сначала на Mock-окружении визуал. Все доступно и удобно.

- `VITE_DEV=true` - это dev
- `VITE_DEV=false` - это prod

Необходимо создать `.env` и заполнить данными из примера. 

```bash
VITE_DEV=true

FRONTEND_PORT=80
FRONTEND_INTERNAL_PORT=80
QR_SERVICE_PORT=3001
REDIS_URL=redis://redis:6379
VITE_QR_API_URL=/qr-api
QR_TOKEN_MAX_ATTEMPTS=10

DATABASE_USER=user
DATABASE_PASSWORD=123
DATABASE_DBNAME=db

DATABASE_HOST=db
DATABASE_PORT=5432

SERVER_PORT=80
```

2. Запуск

```bash
sh ./manage.sh up
```

3. Заходим на `https://localhost` так как на 443 порте, то не нужно указывать порт. Далее подтверждаем сертификаты, сертификаты генерируются при запуске приложения

### Остановка и удаление всего приложения

```bash
sh ./manage.sh clean
```

---

## Запуск через Docker Compose

```bash
docker compose up --build
```

Внешняя точка входа:

- `https://localhost/`

Снаружи открыт только nginx. Frontend, QR microservice, Redis и Backend доступны только внутри docker network.

## Основные страницы

- Главная: `https://localhost/`
- Вход: `https://localhost/auth/login`
- Кабинет клиента: `https://localhost/client`
- Кабинет партнера: `https://localhost/partner`
- Рабочее место кассира: `https://localhost/cashier`
- Админ-панель: `https://localhost/admin`

При docker-запуске используйте тот же путь на `https://localhost`.

## Тестовый вход

| Роль          | Email                 | Пароль       |
| ------------- | --------------------- | ------------ |
| Клиент        | `client@example.com`  | `client123`  |
| Партнер       | `owner@example.com`   | `owner123`   |
| Кассир        | `cashier@example.com` | `cashier123` |
| Администратор | `admin@example.com`   | `admin123`   |

После успешного входа mock-авторизация сохраняет и удаляет сессию в `localStorage` под ключом `loyalty.session`.
