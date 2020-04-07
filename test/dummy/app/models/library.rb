# frozen_string_literal: true

class Library < ActiveRecord::Base
  include LargeTextField::Owner

  # Schema
  #   name :string, :limit => 255
  attr_accessible  :name, :description, :catalog, :notes

  large_text_field :description, singularize_errors: true
  large_text_field :catalog, maximum: 500, singularize_errors: true
  large_text_field :notes

  cattr_accessor :default_notes

  set_callback(:large_text_field_save, :before, :save_preprocess)

  def save_preprocess
    if self.class.default_notes
      self.notes = self.class.default_notes == :nil ? nil : self.class.default_notes
    end
  end

end
