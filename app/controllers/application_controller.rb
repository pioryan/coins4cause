class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_admin_user!
    redirect_to user_login_path unless current_user
  end

  def access_denied(exception)
    redirect_to root_path, :alert => exception.message
  end
end