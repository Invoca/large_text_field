# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"

require 'warning'
Warning.ignore(/.*/, %r{.*lib/shoulda/matchers/active_model/allow_value_matcher/attribute_setter.rb})
Warning.ignore(/.*/, %r{.*lib/shoulda/context/context.rb})
Warning.ignore(/.*/, %r{.*lib/mail/parsers.*})
Warning.ignore(/.*/, %r{.*net/protocol.*})

require File.expand_path('dummy/config/environment.rb', __dir__)

require "minitest"
require "minitest/autorun"
require "minitest/unit"
require "pry"
require "rails/test_help"
require 'rspec/mocks/minitest_integration'
require 'rspec/expectations/minitest_integration'
require "shoulda"
require 'minitest/reporters'

unless ENV['RM_INFO']
  junit_output_dir = ENV['JUNIT_OUTPUT'].presence || "test/reports"
  Minitest::Reporters.use! [
    Minitest::Reporters::DefaultReporter.new,
    Minitest::Reporters::JUnitReporter.new(junit_output_dir)
  ]
end

def large_description
  <<-EOF
    The Royal Library of Alexandria or Ancient Library of Alexandria in Alexandria, Egypt, was one of the
    largest and most significant libraries of the ancient world. It was dedicated to the Muses, the nine
    goddesses of the arts.[1] It flourished under the patronage of the Ptolemaic dynasty and functioned
    as a major center of scholarship from its construction in the 3rd century BCE until the Roman conquest
    of Egypt in 30 BCE, with collections of works, lecture halls, meeting rooms, and gardens. The library
    was part of a larger research institution called the Museum of Alexandria, where many of the most
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

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :minitest
    with.library :rails
  end
end
