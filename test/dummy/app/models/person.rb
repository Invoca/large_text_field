# frozen_string_literal: true

class Person < ApplicationRecord
  include ::LargeTextField::Owner

  # Schema
  #   name :string, :limit => 255

  large_text_field_class_name_override "DummyLargeTextValue"
  large_text_field_deprecated_class_name_override "LargeTextField::NamedTextValue"

  large_text_field :story
  large_text_field :resume
end
