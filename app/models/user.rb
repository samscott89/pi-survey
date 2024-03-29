class User < ActiveRecord::Base
  acts_as_paranoid
    
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save { self.email = email.downcase unless self.temporary 
                self.is_creator = true if !self.email.nil? and  self.email.ends_with? "psychinsight.co.uk"}

  before_destroy {self.surveys.destroy_all}

  has_many :answers, dependent: :destroy
  has_many :active_surveys, dependent: :destroy # surveys in progress/completed
  has_many :surveys, foreign_key: :owner_id # surveys owned by this user
  has_many :campaigns, foreign_key: :owner_id

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  with_options unless: :temporary do |user|
    user.validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false }
    user.validates :name, presence: true
  end

end
