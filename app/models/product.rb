class Product < ActiveRecord::Base
  attr_accessible :title, :photo
  has_attached_file :photo
end
