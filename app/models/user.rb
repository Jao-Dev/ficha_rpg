class User < ApplicationRecord
  audited

  validates :name, :email, presence: true
end
