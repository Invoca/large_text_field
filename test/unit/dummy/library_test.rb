# frozen_string_literal: true

require 'test_helper'

module LargeTextField
  class LibraryTest < ActiveSupport::TestCase
    should "be able to construct a library" do
      l = Library.new(name: "Alexandria Public Library")
      l.save!

      l.description = large_description
      l.save!

      assert_equal large_description, l.description

      l = Library.find(l.id)

      assert_equal large_description, l.description
    end

    should "be able to dup a class that has no current large text field" do
      l = Library.new(name: "Alexandria Public Library")
      l.dup
    end
  end
end
