require 'rubygems'
require 'RMagick'

module ProductsHelper

	def convertPng (photo_name)
		# ベース画像
		image = Magick::Image.read(photo_name).first
        x = image.columns
        y = image.rows

        image = image.change_geometry("#{x}x#{y}") do |cols, rows, img|
          img.resize!(cols, rows)
          img.background_color = 'white'

          img.extent(x * (y.to_f / x.to_f) * 3.5, y, 0, 0)
        end

		#png変換
        image.format = 'PNG'
        @base_image_path = (photo_name).gsub('.jpg', '.png')
        image.write(@base_image_path)
	end
end
