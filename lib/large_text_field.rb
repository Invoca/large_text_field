# These need moved to a junk drawer gem.
require "large_text_field/rails_helpers"
require "large_text_field/real_reload"

require "large_text_field/engine"
require "large_text_field/owner"


module LargeTextField
  MAX_LENGTH = 5_000_000 unless defined?(MAX_LENGTH)

  # TODO - move to constants
  MYSQL_BYTES_PER_UTF8_CHARACTER = 3

  MYSQL_TINY_TEXT_UTF8_LIMIT   = 0x0000_00FF / MYSQL_BYTES_PER_UTF8_CHARACTER #            85 characters
  MYSQL_TEXT_UTF8_LIMIT        = 0x0000_FFFF / MYSQL_BYTES_PER_UTF8_CHARACTER #        21,845 characters
  MYSQL_MEDIUM_TEXT_UTF8_LIMIT = 0x00FF_FFFF / MYSQL_BYTES_PER_UTF8_CHARACTER #     5,592,405 characters
  MYSQL_LONG_TEXT_UTF8_LIMIT   = 0xFFFF_FFFF / MYSQL_BYTES_PER_UTF8_CHARACTER # 1,431,655,765 characters
end
