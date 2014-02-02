class Product < ActiveRecord::Base
  attr_accessible :title, :photo
  has_attached_file :photo
  
  validates_attachment_content_type :photo, 
    :content_type => ['image/png', 'image/x-png'], 
    :message => "Please, Upload PNG only."

end
