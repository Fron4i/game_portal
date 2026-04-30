class Comment < ApplicationRecord
  include Likeable

  belongs_to :user
  belongs_to :post

  validates :body, presence: true, length: { in: 2..2000 }

  scope :chronological, -> { order(created_at: :asc) }
end
