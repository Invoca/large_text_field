# frozen_string_literal: true

module LargeTextField
  class NamedTextValueTest < ActiveSupport::TestCase
    should belong_to(:owner)

    should "use large_text_fields as the table name" do
      assert_equal "large_text_fields", LargeTextField::NamedTextValue.table_name
    end

    should "have field name and value attributes" do
      library = Library.create!(name: "Smithsonian")
      ntv = LargeTextField::NamedTextValue.new(field_name: "puppy", value: "Millie", owner: library)
      assert_equal "puppy", ntv.field_name
      assert_equal "Millie", ntv.value
      assert_equal "Smithsonian", ntv.owner.name
      ntv.save!

      # Attributes survive persistance
      ntv = LargeTextField::NamedTextValue.find(ntv.id)
      assert_equal "puppy", ntv.field_name
      assert_equal "Millie", ntv.value
      assert_equal "Smithsonian", ntv.owner.name
    end

    context "unique index" do
      should "raise a unique constraint failure on the same owner, and field name" do
        library = Library.create!(name: "Smithsonian")
        LargeTextField::NamedTextValue.create!(field_name: "puppy", value: "Millie", owner: library)

        assert_raise(ActiveRecord::RecordNotUnique) do
          LargeTextField::NamedTextValue.create!(field_name: "puppy", value: "Wiki", owner: library)
        end
      end

      should "allow different owners and field names" do
        library = Library.create!(name: "Smithsonian")
        library2 = Library.create!(name: "Alexandria")
        LargeTextField::NamedTextValue.create!(field_name: "puppy", value: "Millie", owner: library)

        # Different field name
        LargeTextField::NamedTextValue.create!(field_name: "dog", value: "Wiki", owner: library)

        # Different owner instance
        LargeTextField::NamedTextValue.create!(field_name: "puppy", value: "Millie", owner: library2)
      end
    end
  end
end
