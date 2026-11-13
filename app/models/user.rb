class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  audited

  has_many :characters, dependent: :destroy

  validates :name, :email, presence: true

  has_many :characters, dependent: :destroy
end
