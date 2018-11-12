class Fire < ApplicationRecord
  validates :identifier, uniqueness: true
end
