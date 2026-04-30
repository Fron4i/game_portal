class Comment < ApplicationRecord
  include Likeable

  belongs_to :user
  belongs_to :post

  validates :body, presence: true, length: { in: 2..2000 }

  scope :recent, -> { order(created_at: :desc) }

  def self.ransackable_attributes(auth_object = nil)
    %w[id body user_id post_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user post likes]
  end
end
