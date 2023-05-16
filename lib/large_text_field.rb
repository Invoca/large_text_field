# frozen_string_literal: true

require "rails"

require "large_text_field/engine"
require "large_text_field/named_text_value"
require "large_text_field/owner"
require "large_text_field/version"

module LargeTextField
  MAX_LENGTH = 5_000_000
end
