class StaticPagesController < ApplicationController
  skip_authorization_check

  def home
  end

  def help
  end

  def about
  end

  def contact
  end

  def tour
  	if !current_user.nil?
  		sign_out current_user
  	end
  	@user = User.find_by(email: "guest@example.com")
  	@user ||= User.create(name: "Guest", email: "guest@example.com", password: "password");
  	sign_in @user
  end
end
