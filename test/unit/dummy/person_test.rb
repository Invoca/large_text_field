# frozen_string_literal: true

require 'test_helper'

module LargeTextField
  class PersonTest < ActiveSupport::TestCase
    should "be able to construct a Person" do
      p = Person.new(name: "Obama")
      p.save!

      resume_text = "Obama's resume is very long and detailed, covering his early life, education, political career, and achievements. It includes numerous accomplishments and accolades that highlight his leadership skills and public service."
      p.resume = resume_text
      p.save!

      assert_equal resume_text, p.resume

      p = Person.find(p.id)

      assert_equal resume_text, p.resume
    end

    should "find fields from deprecated large text field table" do
      p = Person.new(name: "Obama")
      p.story = "Story about Obama"
      p.save!
      NamedTextValue.create!(field_name: "resume", value: "Old value", owner: p)
      p = Person.find(p.id)

      assert_equal "Old value", p.resume
      assert_equal "Story about Obama", p.story

      # Ensure that the story was saved in the new table
      assert_not_predicate DummyLargeTextValue.where(owner: p, field_name: "resume"), :exists?
      assert_predicate DummyLargeTextValue.where(owner: p, field_name: "story"), :exists?

      p.resume = "New resume value"
      p.save!

      # Ensure that the updated resume was saved in the new table
      assert_predicate DummyLargeTextValue.where(owner: p, field_name: "resume"), :exists?
    end

    should "find fields from deprecated large text field table, updates are written to default table" do
      p = Person.new(name: "Obama")
      NamedTextValue.create!(field_name: "resume", value: "Old value", owner: p)
      p = Person.find(p.id)

      p.resume = "Retired"
      p.save!

      # Ensure that the resume was saved in the new table
      assert_predicate DummyLargeTextValue.where(owner: p, field_name: "resume"), :exists?

      # Does not currently delete the old value
      assert_predicate NamedTextValue.where(owner: p, field_name: "resume"), :exists?
    end
  end
end
