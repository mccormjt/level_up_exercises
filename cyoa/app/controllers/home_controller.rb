class HomeController < ApplicationController
  skip_before_action :auth_user!
  helper_method :resource_name, :resource, :devise_mapping

  def index
    render :index
  end

  def login
    render_login_signup_state true
  end

  def signup
    render_login_signup_state false
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  private

  def render_login_signup_state(is_login)
    @login_class = is_login ? 'active' : 'inactive';
    @signup_class = is_login ?  'inactive' : 'active';
    @close_container_class = 'active'
    render action: :index
  end
end
