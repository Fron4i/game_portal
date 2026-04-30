# game_portal

Сайт-портал гейм-студии iWebix.

## Setup

```
sudo apt install postgresql redis-server
sudo -u postgres psql -c "CREATE ROLE game_portal LOGIN CREATEDB PASSWORD 'CHANGE_ME';"
cp .env.example .env
```

`.env` — заполнить значения.
