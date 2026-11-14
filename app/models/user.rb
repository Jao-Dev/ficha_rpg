class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  audited

  has_many :characters, dependent: :destroy

  validates :name, :email, presence: true

  enum :role, { jogador: 0, mestre: 1, admin: 2 }

  def to_s = name
end
