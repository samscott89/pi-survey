class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :index, :destroy]

#  before_action :signed_in_user, only: [:edit, :update, :index, :destroy]
#  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def show
    @user = current_user

    if @user.nil?
      if !session[:guest_user_id].nil?
        @user = User.find(session[:guest_user_id])
      else
        flash[:alert] = "You need to be signed in to view surveys."
        redirect_to new_user_session_path
      end
    end
  end

  def index
    @users = User.order(:name).page params[:page]
  end

  def review_surveys
    @user = current_user
    @guest_user = User.find(session[:guest_user_id])
  end

  def save_surveys
    # Logic to move surveys to new user
    @guest_user = User.find(session[:guest_user_id])
    @guest_user.active_surveys.each do |survey|
      if params[:survey][survey.id.to_s] == "1"
        survey.update(user_id: current_user.id)
      end
    end

    session[:guest_user_id] = nil
    @guest_user.destroy
    
    redirect_to user_surveys_path
  end
  
  private
      def admin_user
        redirect_to(root_url) unless current_user.admin?
      end
end
