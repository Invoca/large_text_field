module LargeTextField
  class NamedTextValue < ActiveRecord::Base

    self.table_name = "large_text_fields"

    # We are making this a public library, so we are removing hobo fields as a dependency.
    # fields do
    #   field_name                  :string, :limit => 255
    #   value                       :text, :null=>true, :limit => MYSQL_MEDIUM_TEXT_UTF8_LIMIT
    # end
    # index [ :owner_type, :owner_id, :field_name ], :name => 'large_text_field_by_owner_field', :unique=>true

    belongs_to :owner, polymorphic: true, inverse_of: :large_text_fields # index: false, null: false,

    attr_accessible :field_name, :value, :owner_type, :owner_id, :owner
  end
end
