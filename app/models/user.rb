class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save { self.email = email.downcase unless self.temporary }
  before_create :create_remember_token

  has_many :answers
  has_many :active_surveys # surveys in progress/completed
  has_many :surveys, foreign_key: :owner_id # surveys owned by this user

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  with_options unless: :temporary do |user|
    user.validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false }, unless: :temporary
    user.validates :name, presence: true
  end

  def User.new_remember_token
  	SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
  	Digest::SHA1.hexdigest(token.to_s)
  end

  private 

	  def create_remember_token
	  	self.remember_token = User.encrypt(User.new_remember_token)
	  end
end
