class Photo
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :integer
  attribute :path, :string
  attribute :data, :binary

  def source
    "data:image/jpg;base64,#{Base64.encode64(data)}"
  end
end
