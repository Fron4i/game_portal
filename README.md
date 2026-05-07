# game_portal

Сайт-портал гейм-студии iWebix. Rails 8.1 + Postgres + Redis + Sidekiq + Hotwire + Tailwind.

## Первый запуск с нуля

```
sudo apt install -y build-essential libpq-dev libssl-dev libyaml-dev postgresql redis-server imagemagick chromium-browser
rbenv install 3.3.6 && rbenv global 3.3.6
gem install bundler -v 4.0.11
sudo service postgresql start && sudo service redis-server start
sudo -u postgres psql -c "CREATE ROLE game_portal LOGIN CREATEDB PASSWORD 'localdev';"

cat > .env <<'EOF'
DATABASE_URL=postgres://game_portal:localdev@localhost:5432/game_portal_development
REDIS_URL=redis://localhost:6379/0
EOF

rm -f config/master.key config/credentials.yml.enc
EDITOR=true bin/rails credentials:edit
echo "RAILS_MASTER_KEY=$(cat config/master.key)" >> .env

bundle install
bin/rails db:prepare db:seed
bin/dev
```

Открыть `http://localhost:3000`. Админ: `admin@iwebix.local` / `password123`.

Если переносишь проект с другой машины и есть старый `RAILS_MASTER_KEY` — пропусти блок `rm + credentials:edit`, просто положи ключ в `.env` сам.

## Каждый день

```
sudo service postgresql start && sudo service redis-server start
bin/dev
```

## Тесты

```
bundle exec rspec
```
