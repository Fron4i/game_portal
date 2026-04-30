class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  enum :role, { user: 0, admin: 1 }

  validates :name, presence: true, length: { in: 2..40 }

  has_many :posts, foreign_key: :author_id, dependent: :nullify, inverse_of: :author
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_games, through: :subscriptions, source: :game

  def active_for_authentication?
    super && !blocked
  end

  def inactive_message
    blocked ? :blocked : super
  end
end
