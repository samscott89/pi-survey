class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :index, :destroy]

#  before_action :signed_in_user, only: [:edit, :update, :index, :destroy]
#  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy


  def show
  	@user = User.find(params[:id])
  end

  def index
    @users = User.order(:name).page params[:page]
  end
  
  private
      def admin_user
        redirect_to(root_url) unless current_user.admin?
      end
end
