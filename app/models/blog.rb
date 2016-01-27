class Blog < ActiveRecord::Base
	mount_uploader :image, BlogUploader
end
