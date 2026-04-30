class Game < ApplicationRecord
  extend FriendlyId

  COVER_CONTENT_TYPES = %w[image/png image/jpeg image/webp].freeze
  COVER_MAX_SIZE = 5.megabytes

  friendly_id :title, use: :slugged

  has_one_attached :cover

  has_many :posts, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  validates :title, presence: true, uniqueness: { case_sensitive: false }, length: { in: 2..80 }
  validates :description, length: { maximum: 4000 }, allow_blank: true
  validate :acceptable_cover

  scope :released, -> { where(arel_table[:released_at].lteq(Time.current)) }
  scope :latest, -> { order(released_at: :desc) }

  def subscribed_by?(user)
    return false if user.blank?

    subscriptions.exists?(user_id: user.id)
  end

  private

  def acceptable_cover
    return unless cover.attached?

    unless COVER_CONTENT_TYPES.include?(cover.blob.content_type)
      errors.add(:cover, :invalid_content_type)
    end

    if cover.blob.byte_size > COVER_MAX_SIZE
      errors.add(:cover, :too_big)
    end
  end
end
