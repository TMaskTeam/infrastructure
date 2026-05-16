# Инфраструктура

## Расположение

Основные файлы:

- `docker-compose.yml`;
- `.env`;
- `.env.example`;
- `nginx/default.conf.template`;
- `frontend/Dockerfile`;
- `qr-service/Dockerfile`.

## Docker Compose

Compose поднимает:

- `nginx` - единственная внешняя точка входа;
- `frontend` - собранное React/Vite-приложение, закрыто снаружи;
- `qr-service` - NestJS microservice для QR-кодов, закрыт снаружи;
- `redis` - хранилище QR token, закрыто снаружи.

## Переменные окружения

Файл `.env`:

```env
FRONTEND_PORT=3000
FRONTEND_INTERNAL_PORT=80
QR_SERVICE_PORT=3001
REDIS_URL=redis://redis:6379
VITE_QR_API_URL=/qr-api
QR_TOKEN_MAX_ATTEMPTS=10
```

## Nginx

Nginx слушает внешний `${FRONTEND_PORT}` и проксирует:

- `/` в `frontend`;
- `/qr-api/` в `qr-service`.

Redis не публикует порт наружу. QR service обращается к Redis по docker network через `REDIS_URL=redis://redis:6379`.
