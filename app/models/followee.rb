class Followee < ApplicationRecord
  belongs_to :user
  validates :username, uniqueness: { scope: [:user_id]}, presence: true
end
