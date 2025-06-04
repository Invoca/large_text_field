# frozen_string_literal: true

class DummyLargeTextValue < ApplicationRecord
  belongs_to :owner, polymorphic: true, inverse_of: :large_text_fields
  self.table_name = "dummy_large_text_fields"
end
