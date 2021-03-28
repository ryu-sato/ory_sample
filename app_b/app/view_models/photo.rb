class Photo
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :integer
  attribute :path, :string
end
