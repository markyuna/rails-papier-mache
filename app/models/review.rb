class Review < ApplicationRecord
  belongs_to :booking

  validates :rating, :content, presence: true
  validates :content, length: { minimum: 10 }
end
