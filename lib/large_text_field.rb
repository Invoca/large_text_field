require "hobo_support"
require "protected_attributes"

require "rails"

module LargeTextField
  MAX_LENGTH = 5_000_000
end

require "large_text_field/engine"
require "large_text_field/owner"
require "large_text_field/named_text_value"
