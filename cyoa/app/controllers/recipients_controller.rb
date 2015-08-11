class RecipientsController < ApplicationController
  respond_to :json

  def ensure
    recipient = find_or_initialize_recipient
    if recipient.valid?
      recipient.new_record? && recipient.save
      render(json: recipient)
    else
      errors = recipient.errors.full_messages
      flash[:error] = errors.first;
      render(json: errors, status: :unprocessable_entity)
    end
  end

  def destroy
    recipient = Recipient.find(params[:id])
    recipient.destroy
    head :no_content
  end

  def find_or_initialize_recipient
    find_by = { phone_number: recipient_params[:phone_number] }
    Recipient.find_or_initialize_by(find_by) do |recipient|
      recipient.name = recipient_params[:name]
      recipient.user = current_user
    end
  end

  def search
    results = Recipient.elastic_search(params[:query], current_user.id)
    render(json: results)
  end

  private

  def recipient_params
    params.require(:recipient).permit(:name, :phone_number)
  end
end
