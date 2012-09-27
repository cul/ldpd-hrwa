class ServiceUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # HRWA Note: Removed :registerable because we don't want people to register new service users

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :password, :email, :password_confirmation, :remember_me
  # attr_accessible :title, :body
end
