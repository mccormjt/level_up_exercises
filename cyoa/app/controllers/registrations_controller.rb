class RegistrationsController < Devise::RegistrationsController
  clear_respond_to 
  respond_to :json
  
  use_growlyflash

  after_action :authentication_flash

  def authentication_flash
    flash[:error] = resource.errors.full_messages.first if resource.errors.any?
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :phone_number, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :phone_number, :password, :password_confirmation, :current_password)
  end
end
