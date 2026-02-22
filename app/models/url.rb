class Url < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, primary_key: :user_id
  validates :url, presence: { message: "Url cannot be empty" }
end
