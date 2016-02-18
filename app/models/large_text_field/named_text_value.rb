module LargeTextField
  class NamedTextValue < ActiveRecord::Base
    self.table_name = "large_text_fields"

    fields do
      field_name                  :string, :limit => 255
      value                       :text, :null=>true, :limit => MYSQL_MEDIUM_TEXT_UTF8_LIMIT
    end
    belongs_to :owner,            :null => false, :polymorphic => true, :index=>false, :inverse_of => :large_text_fields
    index [ :owner_type, :owner_id, :field_name ], :name => 'large_text_field_by_owner_field', :unique=>true

    # TODO - investigate, we are using strong parameters, but we don't want extra dependencies.
    attr_accessible :field_name, :value, :owner_type, :owner_id, :owner
  end
end
