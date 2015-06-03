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
end