class User < ApplicationRecord
  self.primary_key = "user_id"
  before_create :assign_primary_key
  has_secure_password

  validates :email, presence: { message: "Email cannot be empty" }, uniqueness: true
  validates :user_name, presence: { message: "Username cannot be empty" }, uniqueness: true






  # assign primary key for newely inserted data self is needed if not it will be considered as local variable
  private
  def assign_primary_key
    if self.user_id.nil?
      self.user_id = SecureRandom.uuid
    end
  end
end
