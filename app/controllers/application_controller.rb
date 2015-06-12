class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Add name to the parameters used as sign up information.
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  # Go to the user page on log in.
  def after_sign_in_path_for(resource)
    puts "Current session: #{session} with guest_user_id: #{session[:guest_user_id]}"
    if session[:guest_user_id].nil? or User.find(session[:guest_user_id]).active_surveys.empty?
      stored_location_for(resource) || user_surveys_path
    else
      review_surveys_path
    end
  end
end
