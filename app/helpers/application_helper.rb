module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "PsychInsight"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title} "
    end
  end

  def current_or_guest_user
  	  @user = current_user

  	  if @user.nil? and !session[:guest_user_id].nil?
  	      @user = User.find(session[:guest_user_id])
  	  end

  	  @user
  end

  def creator_user?
    !current_or_guest_user.nil? and current_or_guest_user.is_creator?
  end 

  def bootstrap_alert(type)
    case type
    when :success
      "success"
    when :notice, :info 
      "info"
    when :alert, :warning
      "warning"
    when :error, :danger
      "danger"
    else
      "info"
    end
  end
end