class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates_associated :room
end
