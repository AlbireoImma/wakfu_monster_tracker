class User < ApplicationRecord
  has_many :tracked_monsters, dependent: :destroy
  has_many :monsters, through: :tracked_monsters
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
