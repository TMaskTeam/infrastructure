# Как открыть сайт

## Запуск

Из корня проекта:

```bash
bun install
bun run dev -- --host 127.0.0.1
```

После запуска сайт доступен по адресу:

- `http://127.0.0.1:5173/`

## Запуск через Docker Compose

```bash
docker compose up --build
```

Внешняя точка входа:

- `http://localhost:3000/`

Порт берется из `.env`:

```env
FRONTEND_PORT=3000
```

Снаружи открыт только nginx. Frontend, QR microservice и Redis доступны только внутри docker network.

## Основные страницы

- Главная: `http://127.0.0.1:5173/`
- Вход клиента: `http://127.0.0.1:5173/auth/client/login`
- Вход партнера: `http://127.0.0.1:5173/auth/business/login`
- Вход кассира: `http://127.0.0.1:5173/auth/employee/login`
- Вход администратора: `http://127.0.0.1:5173/auth/admin/login`
- Кабинет клиента: `http://127.0.0.1:5173/client`
- Кабинет партнера: `http://127.0.0.1:5173/partner`
- Рабочее место кассира: `http://127.0.0.1:5173/cashier`
- Админ-панель: `http://127.0.0.1:5173/admin`

При docker-запуске используйте тот же путь на `http://localhost:3000`.

## Тестовый вход

| Роль          | Email                 | Пароль       |
| ------------- | --------------------- | ------------ |
| Клиент        | `client@example.com`  | `client123`  |
| Партнер       | `owner@example.com`   | `owner123`   |
| Кассир        | `cashier@example.com` | `cashier123` |
| Администратор | `admin@example.com`   | `admin123`   |

После успешного входа mock-авторизация сохраняет сессию в `localStorage` под ключом `loyalty.session`.
