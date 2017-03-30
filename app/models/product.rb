class Product < ActiveRecord::Base
  mount_uploader :image, PhotoUploader

  validates :title, presence: true
  validates :image, presence: true
end
