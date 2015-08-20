class TwilioResponseBuilder

  RESPONSE_KEY_CLASSES =
  {
    options:   :options_response_handler,
    upcoming:  :upcoming_response_handler,
    status:    :status_response_handler,
    show:      :show_response_handler,
  }

  class << self
    def createHandler(from_phone_number, body)
      key = extract_resonse_key(body)
      handler = createResponseHandler(key)
      handler.new(from_phone_number, body)
    end

    private

    def createResponseHandler(key)
      classSymbol = RESPONSE_KEY_CLASSES[key]
      classSymbol = :unrecognized_response_handler unless classSymbol
      symbol_to_class(classSymbol)
    end

    def extract_resonse_key(body)
      key = body.split(' ').first
      normalize_resonse_key(key)
    end

    def normalize_resonse_key(key)
      key.strip.downcase.to_sym
    end

    def symbol_to_class(symbol)
      symbol.to_s.classify.constantize
    end
  end
end
