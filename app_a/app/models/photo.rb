class Photo < ApplicationRecord
  has_one_attached :attachment
  belongs_to :user
end
