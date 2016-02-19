class Library < ActiveRecord::Base
  include LargeTextField::Owner

  # We are making this a public library, so we are removing hobo fields as a dependency.
  # fields do
  #   name                  :string, :limit => 255
  # end

  large_text_field :description, singularize_errors: true
  large_text_field :catalog, maximum: 500, singularize_errors: true
  large_text_field :notes

  attr_accessible  :name, :description, :catalog, :notes

  cattr_accessor :default_notes

  set_callback(:large_text_field_save, :before, :save_preprocess)

  def save_preprocess
    if self.class.default_notes
      self.notes = self.class.default_notes == :nil ? nil :self.class.default_notes
    end
  end

end
