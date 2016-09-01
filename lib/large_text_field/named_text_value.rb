module LargeTextField
  class NamedTextValue < ActiveRecord::Base
    # Schema
    #   field_name :string, :limit => 255
    #   value      :text, :null=>true, :limit => MYSQL_MEDIUM_TEXT_UTF8_LIMIT
    #
    # index [ :owner_type, :owner_id, :field_name ], :name => 'large_text_field_by_owner_field', :unique=>true

    belongs_to :owner, polymorphic: true, inverse_of: :large_text_fields

    self.table_name = "large_text_fields"
  end
end
