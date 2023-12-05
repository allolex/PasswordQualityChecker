class Token
  ENVIRONMENT_KEY = "API_TOKEN".freeze
  EXPECTED_TYPE = "Bearer".freeze
  BEARER_MISSING = "Must use Bearer authentication".freeze
  HEADER_MISSING = "Token header value is missing".freeze

  def initialize(authorization_header_value)
    raise ArgumentError, HEADER_MISSING unless authorization_header_value.present?
    # Split on spaces to get the type and the value
    type, @value = authorization_header_value.split /[ ]+/
    raise ArgumentError, BEARER_MISSING unless type == EXPECTED_TYPE
  end

  def valid?
    @value == ENV.fetch(ENVIRONMENT_KEY)
  end
end
