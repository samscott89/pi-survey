class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  check_authorization unless: :devise_controller? # Uses CanCanCan to check all permissions

  before_action :configure_permitted_parameters, if: :devise_controller?

  # Insert custom layouts here
  layout :layout_by_resource

  protected

  # Used by CanCanCan to find user authorisation. 
  def current_ability
    @current_ability ||= Ability.new(view_context.current_or_guest_user)
  end

  # Add name to the parameters used as sign up information.
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  # Go to the user page on log in.
  def after_sign_in_path_for(resource)
    #puts "Current session: #{session} with guest_user_id: #{session[:guest_user_id]}"
    if session[:guest_user_id].nil? or User.find(session[:guest_user_id]).active_surveys.empty?
      stored_location_for(resource) || user_surveys_path
    else
      review_surveys_path
    end
  end

  def layout_by_resource
    if devise_controller?
      "small_form"
    else
      "application"
    end
  end

  def set_cache_buster
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
