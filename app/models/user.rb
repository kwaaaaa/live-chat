class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable

  has_many :messages, dependent: :destroy

  scope :all_except, ->(user) { where.not(id: user.id) }

  broadcasts
end
