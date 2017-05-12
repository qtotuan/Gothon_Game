class User < ActiveRecord::Base
  # validates_presence_of :name, :email, :password
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
end
