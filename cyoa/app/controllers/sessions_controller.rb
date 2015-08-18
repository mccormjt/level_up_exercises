class SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :auth_user!
end
