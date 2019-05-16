class Library < ActiveRecord::Base
  include LargeTextField::Owner

  # Schema
  #   name :string, :limit => 255
  attr_accessible  :name, :description, :catalog, :notes
  attr_reader :large_text_field_destroyed, :before_destroy_description, :before_destroy_catalog, :before_destroy_notes

  large_text_field :description, singularize_errors: true
  large_text_field :catalog, maximum: 500, singularize_errors: true
  large_text_field :notes

  cattr_accessor :default_notes

  set_callback(:large_text_field_save, :before, :save_preprocess)
  set_callback(:large_text_field_destroy, :before, :load_large_text_fields)

  def save_preprocess
    if self.class.default_notes
      self.notes = self.class.default_notes == :nil ? nil : self.class.default_notes
    end
  end

  def load_large_text_fields
    @large_text_field_destroyed = true
    @before_destroy_description = description
    @before_destroy_catalog = catalog
    @before_destroy_notes = notes
  end
end
