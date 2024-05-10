class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :users, through: :participants

  validates_length_of :participants, maximum: 2
  validates :name, presence: true, uniqueness: true

  scope :public_rooms, -> { where(is_private: false) }

  after_create_commit { broadcast_if_public }

  private

  def broadcast_if_public
    broadcast_append_to 'rooms' unless is_private
  end
end
