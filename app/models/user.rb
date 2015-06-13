class User < ActiveRecord::Base
  include NotDeleteable
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save { self.email = email.downcase unless self.temporary }

  before_destroy {self.surveys.destroy_all}

  has_many :answers, dependent: :destroy
  has_many :active_surveys, dependent: :destroy # surveys in progress/completed
  has_many :surveys, foreign_key: :owner_id # surveys owned by this user

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  with_options unless: :temporary do |user|
    user.validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false }
    user.validates :name, presence: true
  end

end
