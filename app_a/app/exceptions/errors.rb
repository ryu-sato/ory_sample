module Errors
  class BaseError < StandardError
    attr_reader :code

    def initialize(code: nil, message: nil)
      @code = code
      super(message)
    end
  end

  class AuthenticationFailed < BaseError
    def initialize(message = 'AuthenticationFailed failed.')
      super(code: 401, message: message)
    end
  end

  class AuthorizationFailed < BaseError
    def initialize(message = 'Authorization failed.')
      super(code: 403, message: message)
    end
  end
end
