# frozen_string_literal: true

require_relative 'application_record'

module LargeTextField
  class NamedTextValue < ApplicationRecord
    # Schema
     #   field_name :string, :limit => 255
     #   foo :string
    #   value      :text, :null=>true, :limit => MYSQL_MEDIUM_TEXT_UTF8_LIMIT
    #
    # index [ :owner_type, :owner_id, :field_name ], :name => 'large_text_field_by_owner_field', :unique=>true

    belongs_to :owner, polymorphic: true, inverse_of: :large_text_fields

    self.table_name = "large_text_fields"
  end
end