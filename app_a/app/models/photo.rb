class Photo < ApplicationRecord
  has_one_attached :attachment
end
