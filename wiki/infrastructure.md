# Инфраструктура

## Расположение

Основные файлы:

- `docker-compose.yml`;
- `.env`;
- `.env.example`;
- `nginx/default.nginx`;
- `frontend/Dockerfile`;
- `qr-service/Dockerfile`.
- `backend/Dockerfile`.

## Docker Compose

Compose поднимает:

- `nginx` - единственная внешняя точка входа;
- `frontend` - собранное React/Vite-приложение, закрыто снаружи;
- `qr-service` - NestJS microservice для QR-кодов, закрыт снаружи;
- `redis` - хранилище QR token, закрыто снаружи.

## Переменные окружения

Файл `.env`:

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

## Nginx

Nginx слушает внешний `${FRONTEND_PORT}` и проксирует:

- `/` в `frontend`;
- `/qr-api/` в `qr-service`.
- `/api/` в `backend` на Go.

Redis не публикует порт наружу. QR service обращается к Redis по docker network через `REDIS_URL=redis://redis:6379`.

Postgresql не публикует порт наружу. Backend обращается к Postgresql по docker network через `DATABASE_*` настройки в `.env`.
