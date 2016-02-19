# These need moved to a junk drawer gem.
require "large_text_field/real_reload"

require "large_text_field/engine"
require "large_text_field/owner"


module LargeTextField
  MAX_LENGTH = 5_000_000 unless defined?(MAX_LENGTH)
end
