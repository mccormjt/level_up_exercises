class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery
  before_action :auth_user! 
  use_growlyflash

  def auth_user!
    redirect_to login_path unless user_signed_in?
  end
end
