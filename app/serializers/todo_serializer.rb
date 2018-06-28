class TodoSerializer < ActiveModel::Serializer
  attributes :id, :title, :text, :created_at
end
