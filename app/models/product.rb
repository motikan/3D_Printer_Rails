class Product < ActiveRecord::Base
  attr_accessible :title, :editkey, :deleteflag ,:photo
  has_attached_file :photo
  
  validates_attachment_content_type :photo, 
    :content_type => ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png'],
    :message => "Please, Upload PNG only."

end
