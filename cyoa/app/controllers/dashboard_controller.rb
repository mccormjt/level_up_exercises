class DashboardController < ApplicationController
  before_action :auth_user!

  def index
  end

  def auth_user!
    redirect_to login_path unless user_signed_in?
  end
end
