class Area < ApplicationRecord
  validates :area_id, uniqueness: true, presence: true
  validates :area_name, presence: true
end
