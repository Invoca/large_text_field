# frozen_string_literal: true

require 'test_helper'

module LargeTextField
  class OwnerTest < ActiveSupport::TestCase
    context "updating in large_text_field_save hook" do
      { 'empty string' => '', 'non empty string' => 'this is some text' }.each do |name, value|
        should "be able to assign #{name}" do
          Library.default_notes = value
          @library = Library.create!(name: "Smithsonian")

          assert_equal value, @library.notes
          assert_equal value, @library.reload.notes
        ensure
          Library.default_notes = "none_set"
        end
      end

      should "raise error on saving nil value" do
        Library.default_notes = :nil
        assert_raises RuntimeError do
          @library = Library.create!(name: "Smithsonian")
        end
      ensure
        Library.default_notes = "none_set"
      end
    end

    context "a large text field" do
      setup do
        @library = Library.create!(name: "Smithsonian")

        assert_equal "", @library.description
      end

      should "declare the association when it is first described and other meta data when it is first defined" do
        assert_equal :has_many, Library.reflections['large_text_fields'].macro

        assert_equal({ maximum: nil, singularize_errors: true }, Library.large_text_field_options['description'])
      end

      should "read from a file" do
        @library = Library.create!(name: "Smithsonian")
        tmp_file = nil
        begin
          tmp_file = Tempfile.new('large_text_field_test')
          tmp_file.write("this is a string from the file")
          tmp_file.close

          test_file = File.open(tmp_file.path)

          @library.description = test_file

          assert_equal 'this is a string from the file', @library.description

          @library.save!

          assert_equal 'this is a string from the file', @library.reload.description
        ensure
          tmp_file.unlink
        end
      end

      should "allow get and set with saves and deletes" do
        @library.description = "badger " * 200

        assert_equal "badger " * 200, @library.description

        @library.save!
        @library.reload

        assert_equal "badger " * 200, @library.description

        @library.description = "mushroom " * 200

        assert_equal "mushroom " * 200, @library.description

        @library.save!
        @library.reload

        assert_equal "mushroom " * 200, @library.description

        @library.description = ''

        assert_equal '', @library.description

        @library.save!
        @library.reload

        assert_equal '', @library.description
      end

      should "allow for concurrent sets and deletes" do
        @library.description = "first"
        @library.catalog = "second"

        assert_equal "first",  @library.description
        assert_equal "second", @library.catalog

        @library.save!
        @library.reload

        assert_equal "first",  @library.description
        assert_equal "second", @library.catalog

        @library.description = "third"
        @library.catalog = ''

        assert_equal "third",  @library.description
        assert_equal '',       @library.catalog

        @library.save!

        assert_equal "third",  @library.description
        assert_equal '',       @library.catalog
      end

      should "forget about changes if they are not saved" do
        @library.description = "first"
        @library.reload

        assert_equal '', @library.description

        @library.description = "first"
        @library.save!
        @library.reload

        @library.description = ''
        @library.reload

        assert_equal "first",  @library.description
      end

      should "validate the maximum length" do
        @library.notes = "a" * (LargeTextField::MAX_LENGTH + 1)

        assert_not @library.valid?
        assert_equal(["Notes are too long (maximum is 5,000,000 characters)"], @library.errors.full_messages)
      end

      should "singularize the errors if requested" do
        @library.description = "a" * (LargeTextField::MAX_LENGTH + 1)

        assert_not @library.valid?
        assert_equal(["Description is too long (maximum is 5,000,000 characters)"], @library.errors.full_messages)
      end

      should "allow a custom maximum length to be provided" do
        @library.catalog = "1" * 501

        assert_not @library.valid?
        assert_equal ["Catalog is too long (maximum is 500 characters)"], @library.errors.full_messages
      end

      should "prevent a non-Integer to be provided for a custom maximum" do
        assert_raise(ArgumentError) do
          Library.large_text_field :not_number_maximum, maximum: "i am not a number"
        end
      end

      should "prevent a custom maximum length to be provided that is not in the allowable range" do
        assert_raise ArgumentError do
          Library.large_text_field :bigger_than_allowed, maximum: LargeTextField::MAX_LENGTH + 1
        end

        assert_raise ArgumentError do
          Library.large_text_field :smaller_than_allowed, maximum: -1
        end
      end

      should "not save fields that are set to blank" do
        @library = Library.new(name: 'Millie')

        assert_equal 0, @library.large_text_fields.count

        @library.description = "first"
        @library.notes = ""

        @library.save!
        @library.reload

        assert_equal "first", @library.description
        assert_equal "", @library.notes

        assert_equal 1, @library.large_text_fields.count
      end

      should "delete fields when they are set to blank" do
        assert_equal 0, @library.large_text_fields.count

        @library.description = "first"

        @library.save!
        @library.reload

        assert_equal "first", @library.description

        assert_equal 1, @library.large_text_fields.count

        @library.description = ""
        @library.save!
        @library.reload

        assert_equal "", @library.description

        assert_equal 0, @library.large_text_fields.count
      end

      should "be able to update deleted fields" do
        assert_equal 0, @library.large_text_fields.count

        @library.description = "first"

        @library.save!

        assert_equal "first", @library.description

        assert_equal 1, @library.large_text_fields.count

        @library.description = ""
        @library.save!

        assert_equal "", @library.description

        assert_equal 0, @library.large_text_fields.count
        @library.description = "first"

        @library.save!

        assert_equal "first",  @library.description
      end

      should "be cloned with the rest of the record" do
        @library.description = "first"
        @library.catalog = "second"
        @library.save!

        @clone = @library.dup

        assert_equal "first",  @clone.description
        assert_equal "second", @clone.catalog
        @clone.save!

        assert_equal "first",  @clone.description
        assert_equal "second", @clone.catalog

        # Should not have stolen from the owner...
        @library.save!
        @library.reload

        assert_equal "first",  @library.description
        assert_equal "second", @library.catalog

        # should be destroyed when destroyed
        text_field_ids = @clone.large_text_fields.*.id
        @clone.destroy

        text_field_ids.each { |id| assert_not LargeTextField::NamedTextValue.find_by(id: id) }
      end

      should "be able to be eager loaded" do
        @library.description = "first"
        @library.catalog = "second"
        @library.save!

        new_value = Library.includes(:large_text_fields).find(@library.id)

        expect(Library.connection).not_to receive(:select)

        assert_equal "first",  new_value.description
        assert_equal "second", new_value.catalog
      end

      should "support strings or symbols for get/set methods" do
        @library.set_text_field(:description, "first")

        assert_equal "first",  @library.description
        assert_equal "first",  @library.get_text_field(:description)
        assert_equal "first",  @library.get_text_field('description')

        @library.set_text_field('description', "second")

        assert_equal "second",  @library.description
        assert_equal "second",  @library.get_text_field(:description)
        assert_equal "second",  @library.get_text_field('description')
      end

      should "detect changes when @text_field_hash hash is/not empty" do
        @library = Library.new(name: "Smithsonian")

        assert_not @library.instance_variable_defined?("@text_field_hash")
        assert_not @library.description_changed?
        @library.description = "a new note"

        assert_predicate @library, :description_changed?
        @library.save!
        @library.reload

        assert_not @library.description_changed?
        @library.description = "a new note"

        assert_not @library.description_changed?
        @library.description = "now with more chicken taste"

        assert_predicate @library, :description_changed?
      end

      should "only validate_large_text_fields if loaded" do
        @library = Library.new

        assert_not @library.instance_variable_defined?("@text_field_hash")
        assert_predicate @library, :valid?
        assert_not @library.instance_variable_defined?("@text_field_hash")
      end

      should "reload changes when they come from a different model" do
        @library = Library.create!(name: "Cambridge University Library", description: "in england")
        @second_version = Library.find(@library.id)

        @second_version.update!(description: "The main research library of the University of Cambridge in England")

        assert_equal "The main research library of the University of Cambridge in England", @library.reload.description
      end

      should "allow a single argument to be passed into reload" do
        Library.create!(name: "Cambridge University Library", description: "in england").reload(lock: true)
      end

      should "delete large text fields when the owner is destroyed" do
        assert_equal 0, LargeTextField::NamedTextValue.count

        @library = Library.create!(name: "Cambridge University Library", description: "in england")

        assert_equal 1, LargeTextField::NamedTextValue.count

        @library.destroy

        assert_equal 0, LargeTextField::NamedTextValue.count
      end
    end

  end
end
