class Map < ActiveRecord::Base
    has_many :images, dependent: :destroy
    accepts_nested_attributes_for :images
    has_many :areas, dependent: :destroy
    accepts_nested_attributes_for :areas
end
