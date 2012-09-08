class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  authenticates_with_sorcery!

  has_many :assignments
  has_many :roles, :through => :assignments
  
  has_many :events

  validates_length_of :password, :minimum => 3, :message => "password must be at least 3 characters long", :if => :password
  validates_confirmation_of :password, :message => "should match confirmation", :if => :password

  #----------------------------------------------------------------------------
  # methods
  #----------------------------------------------------------------------------
  
  def has_role?(role_symbol)
    roles.any? { |r| r.name.underscore.to_sym == role_symbol }
  end
end
