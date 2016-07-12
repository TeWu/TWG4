class User < ApplicationRecord
  has_many :owned_albums, dependent: :nullify, class_name: 'Album', foreign_key: :owner_id, inverse_of: :owner
  has_many :comments, dependent: :nullify, foreign_key: :author_id, inverse_of: :author
end
