require "hobo_support"

require "rails"

require "large_text_field/engine"
require "large_text_field/owner"
require "large_text_field/named_text_value"

module LargeTextField
  MAX_LENGTH = 5_000_000 unless defined?(MAX_LENGTH)
end
