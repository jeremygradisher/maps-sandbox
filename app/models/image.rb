class Image < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :map
  validates_size_of :image, maximum: 2.megabytes, message: "Upload should be less than 2MB"
end
