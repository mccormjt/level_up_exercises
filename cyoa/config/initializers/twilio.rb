Twilio.configure do |config|
  config.account_sid = Cyoa.config.twilio['account_sid']
  config.auth_token = Cyoa.config.twilio['auth_token']
  Twilio.extend(TwilioSms)
end
