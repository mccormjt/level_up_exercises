class SendSmsWorker
  include Sidekiq::Worker

  def perform(phone_number, message)
    TwilioSms.send_sms_to(phone_number, message)
  end
end
