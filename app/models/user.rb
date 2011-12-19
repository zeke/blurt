class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_many :guesses
  
  def self.active
    users = Game.current.guesses.map(&:user)
    users << Game.over.first.guesses.map(&:user) unless Game.over.count.zero?
    users.flatten.uniq
  end
  
  def as_json(options={})
    {
      email: self.email,
      score: self.score
    }
  end
  
end
