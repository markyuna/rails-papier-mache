class Product < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  belongs_to :user

  has_many :bookings, dependent: :destroy

  has_one_attached :photo
  has_many :reviews, through: :bookings

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :price, presence: true
  validates :status, presence: true
  validates :stock, presence: true
end
