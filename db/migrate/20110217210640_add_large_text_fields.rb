# frozen_string_literal: true

class AddLargeTextFields < (Rails::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[4.2] : ActiveRecord::Migration)
  def self.up
    create_table :large_text_fields do |t|
      t.string  :field_name, null: false
      t.text    :value, char_limit: 5_592_405, limit: 16_777_215
      t.integer :owner_id, null: false
      t.string  :owner_type, null: false
    end
    add_index :large_text_fields, %i[owner_type owner_id field_name], unique: true, name: 'large_text_field_by_owner_field'
  end

  def self.down
    drop_table :large_text_fields
  end
end
