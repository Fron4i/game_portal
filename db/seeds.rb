srand(42)

password = ENV.fetch("SEED_ADMIN_PASSWORD", "password123")

admin = User.find_or_initialize_by(email: "admin@iwebix.local")
admin.assign_attributes(
  name: "Админ",
  role: :admin,
  password: password,
  password_confirmation: password,
  confirmed_at: Time.current,
  blocked: false
)
admin.save!

users = [
  { email: "alex@iwebix.local",  name: "Алекс" },
  { email: "maria@iwebix.local", name: "Мария" }
].map do |attrs|
  u = User.find_or_initialize_by(email: attrs[:email])
  u.assign_attributes(
    name: attrs[:name],
    role: :user,
    password: password,
    password_confirmation: password,
    confirmed_at: Time.current,
    blocked: false
  )
  u.save!
  u
end

games_data = [
  { title: "Звёздный путь",  description: "Космическая RPG студии iWebix о капитане без права на ошибку.", released_at: 8.months.ago, cover: "star_path.png" },
  { title: "Тёмная гавань",  description: "Атмосферный survival-horror в заброшенном портовом городе.", released_at: 3.months.ago, cover: "dark_harbor.png" },
  { title: "Каменное эхо",   description: "Тактическая стратегия с управлением небольшим отрядом разведчиков.", released_at: 1.month.from_now, cover: "stone_echo.png" }
]

games = games_data.map do |attrs|
  g = Game.find_or_initialize_by(title: attrs[:title])
  g.description = attrs[:description]
  g.released_at = attrs[:released_at]
  g.save!
  cover_path = Rails.root.join("db/seeds/covers", attrs[:cover])
  if cover_path.file? && !g.cover.attached?
    g.cover.attach(io: cover_path.open, filename: attrs[:cover], content_type: "image/png")
  end
  g
end

post_titles = {
  announcement: [
    "Анонс: открытый бета-тест уже на этой неделе",
    "Запуск нового сезона: что внутри",
    "Глобальное обновление: новые регионы и фракции"
  ],
  update: [
    "Балансные правки и фиксы экономики",
    "Патч 1.4: новые квесты и улучшения интерфейса",
    "Серверная стабильность: что мы починили",
    "Сезонное событие: возвращение старых героев"
  ]
}

post_bodies = [
  "<p>Команда работает над тем, чтобы каждый патч приносил ощутимые изменения. В этом обновлении — баланс способностей, исправление багов и новый ивент на выходные.</p>",
  "<p>Мы пересмотрели систему наград и ввели понятную прогрессию. Подробности и сравнительные таблицы — в видео-разборе на канале студии.</p>",
  "<p>Новый регион уже доступен. Ожидайте уникальных квестов, новой фракции и редких трофеев. Игроки, прошедшие основную кампанию, получат бонусы при входе.</p>",
  "<p>Серверы получили крупный апдейт инфраструктуры. Это сократит лаги в пиковые часы и повысит надёжность матчей.</p>"
]

games.each_with_index do |game, idx|
  announcement_title = post_titles[:announcement][idx % post_titles[:announcement].size]
  Post.find_or_initialize_by(title: announcement_title, game: game).tap do |p|
    p.author = admin
    p.kind = :announcement
    p.published_at = (game.released_at || 1.week.ago) - 2.weeks
    p.body = post_bodies.sample
    p.save!
  end

  rand(2..3).times do |i|
    update_title = post_titles[:update][(idx * 2 + i) % post_titles[:update].size] + " ##{idx + 1}.#{i + 1}"
    Post.find_or_initialize_by(title: update_title, game: game).tap do |p|
      p.author = admin
      p.kind = :update
      p.published_at = (i + 1).weeks.ago
      p.body = post_bodies.sample
      p.save!
    end
  end
end

comment_bodies = [
  "Отличное обновление, спасибо!",
  "Жду новый рейд, в трейлере выглядит мощно.",
  "Можно подробнее про баланс лучников?",
  "Сервер вечером лагал, теперь стабильно.",
  "Этот патч сильно изменил мету.",
  "Хочется ещё событий с лором, очень атмосферно.",
  "Иконки в инвентаре стали понятнее, удобно."
]

Post.find_each do |post|
  next if post.comments.exists?

  rand(2..4).times do
    Comment.create!(
      post: post,
      user: users.sample,
      body: comment_bodies.sample
    )
  end
end

Post.find_each do |post|
  next if post.likes.exists?

  ([admin] + users).sample(rand(1..3)).each do |u|
    Like.find_or_create_by(user: u, likeable: post)
  end
end

Comment.find_each do |comment|
  next if comment.likes.exists?

  Like.find_or_create_by(user: users.sample, likeable: comment)
end

users.each_with_index do |u, i|
  Subscription.find_or_create_by(user: u, game: games[i % games.size])
end
Subscription.find_or_create_by(user: users.first, game: games.last)

puts "Seeded: #{User.count} users, #{Game.count} games, #{Post.count} posts, #{Comment.count} comments, #{Like.count} likes, #{Subscription.count} subscriptions"
