# game_portal

Сайт-портал гейм-студии iWebix.

## Setup

```
sudo apt install postgresql redis-server
sudo -u postgres psql -c "CREATE ROLE game_portal LOGIN CREATEDB PASSWORD 'CHANGE_ME';"
cp .env.example .env
```

`.env` — заполнить значения.

`bin/rails db:seed` — демо-данные (admin@iwebix.local / password123, 2 user, 3 игры, 10 постов, комменты, лайки, подписки). Идемпотентно.
