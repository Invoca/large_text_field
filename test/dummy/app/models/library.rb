class Library < ActiveRecord::Base
  include LargeTextField::Owner

  cattr_accessor :default_notes

  # We are making this a public library, so we are removing hobo fields as a dependency.
  # fields do
  #   name                  :string, :limit => 255
  # end

  large_text_field :description
  large_text_field :catalog, maximum: 500
  large_text_field :notes

  attr_accessible :name

  set_callback(:large_text_field_save, :before, :save_preprocess)

  def save_preprocess
    self.notes = self.class.default_notes
  end

end
