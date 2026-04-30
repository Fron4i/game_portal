class Post < ApplicationRecord
  extend FriendlyId
  include Likeable

  friendly_id :title, use: :slugged

  belongs_to :game
  belongs_to :author, class_name: "User", inverse_of: :posts, optional: true

  has_many :comments, dependent: :destroy

  has_rich_text :body

  enum :kind, { announcement: 0, update: 1 }, prefix: :kind

  validates :title, presence: true, length: { in: 3..140 }
  validates :body, presence: true

  scope :published, -> { where.not(published_at: nil).where(arel_table[:published_at].lteq(Time.current)) }
  scope :drafts, -> { where(published_at: nil) }
  scope :for_game, ->(game) { where(game: game) }
  scope :latest, -> { order(published_at: :desc) }

  def published?
    published_at.present? && published_at <= Time.current
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id title slug kind published_at game_id author_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[game author comments likes]
  end
end
