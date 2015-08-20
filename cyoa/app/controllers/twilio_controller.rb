class TwilioController < ApplicationController
  skip_before_action :auth_user!

  def recieve_sms
    handler = TwilioResponseBuilder.createHandler(params[:From], params[:Body])
    handler.respond
    head :no_content
  end
end