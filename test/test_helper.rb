# TODO - This is a mess - do not commit.

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require "invoca/utils"
require 'rr'
require 'shoulda'
require 'minitest/unit'

def require_test_helper(helper_path)
  require_relative File.expand_path(File.dirname(__FILE__) + '/helpers/' + helper_path)
end


require_test_helper 'test_unit_assertions_overrides'

require "pry"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

def large_description
   <<-EOF
      The Royal Library of Alexandria or Ancient Library of Alexandria in Alexandria, Egypt, was one of the
      largest and most significant libraries of the ancient world. It was dedicated to the Muses, the nine
      goddesses of the arts.[1] It flourished under the patronage of the Ptolemaic dynasty and functioned
      as a major center of scholarship from its construction in the 3rd century BCE until the Roman conquest
      of Egypt in 30 BCE, with collections of works, lecture halls, meeting rooms, and gardens. The library
      was part of a larger research institution called the Musaeum of Alexandria, where many of the most
      famous thinkers of the ancient world studied.

      The library was created by Ptolemy I Soter, who was a Macedonian general and the successor of Alexander
      the Great.[2] Most of the books were kept as papyrus scrolls. It is unknown how many such scrolls were
      housed at any given time.

      The library is famous for having been burned down, resulting in the loss of many scrolls and books; its
      destruction has become a symbol for the loss of cultural knowledge. A few sources differ on who is
      responsible for the destruction and when it occurred. There is mythology regarding this main burning
      but the library may in truth have suffered several fires or other acts of destruction over many years.
      Possible occasions for the partial or complete destruction of the Library of Alexandria include a fire
      set by Julius Caesar in 48 BCE and an attack by Aurelian in the CE 270s.

      After the main library was fully destroyed, ancient scholars used a "daughter library" in a temple known
      as the Serapeum, located in another part of the city. According to Socrates of Constantinople, Coptic Pope
      Theophilus destroyed the Serapeum in AD 391, although it's not certain that it still contained an offshoot
      of the library then.
  EOF
end

# This is lame - fix
Library.default_notes = ""

# Move to invoca / rails_utils
module AssertionHelpers
  def assert_equal_with_diff arg1, arg2, msg = ''
    if arg1 == arg2
      assert true # To keep the assertion count accurate
    else
      assert_equal arg1, arg2, "#{msg}\n#{Diff.compare(arg1, arg2)}"
    end
  end

  def assert_equal_with_diff_unordered(expected, actual, message = '')
    assert_equal_with_diff expected.sort, actual.sort, message
  end

  def assert_equal_with_diff_short arg1, arg2, msg = ''
    if arg1 != arg2
      raise Test::Unit::AssertionFailedError.new( "#{msg}\n#{Diff.compare(arg1, arg2)}" )
    else
      assert true
    end
  end

  def assert_equal_with_diff_html arg1, arg2, msg=""
    assert( arg1 == arg2, "#{msg}\n#{Diff.compare(arg1.split("\n"), arg2.split("\n"), :short_description=>true)}" )
  end

  def assert_selected_equal_with_diff arg1, arg2, msg = ''
    if Hash === arg1 && Hash === arg2
      selected_arg2 = arg2.reject { |key,value| !arg1.has_key?(key) }
      msg = "#{msg}\n (Note: comparision ignored hash keys from results that did not exist in the expected result)"
    elsif Array === arg1 && Hash === arg1.first && Array === arg2 && Hash === arg2.first
      all_keys = arg1.map { |r| r.keys }.flatten.uniq
      selected_arg2 = arg2.map { |r| r.reject {|key, value| !all_keys.include?(key) } }
      msg = "#{msg}\n (Note: comparision ignored hash keys from result rows that did not exist in the expected result)"
    else
      selected_arg2 = arg2
      msg = "#{msg}\n (Selected comparison not run becaus arg2 was not a hash or a list of hashes.)"
    end

    if arg1 != selected_arg2
      assert_equal arg1, arg2, "#{msg}\n#{Diff.compare(arg1, selected_arg2)}"
    else
      assert true
    end
  end
end
