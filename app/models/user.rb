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

  def subscribed_to?(game)
    return false if game.blank?

    subscriptions.exists?(game_id: game.id)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id email name role blocked confirmed_at created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[posts comments likes subscriptions subscribed_games]
  end
end
