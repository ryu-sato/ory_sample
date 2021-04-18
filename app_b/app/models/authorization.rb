class Authorization < ApplicationRecord
  validates :subject, uniqueness: true
end
