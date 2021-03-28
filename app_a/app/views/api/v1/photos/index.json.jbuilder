json.array! @photos do |photo|
  json.extract! photo, :id, :created_at, :updated_at
  json.path photo_api_path(photo)
end
