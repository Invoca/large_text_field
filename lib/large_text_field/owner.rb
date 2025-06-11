# frozen_string_literal: true

require "invoca/utils"
require_relative "base"

module LargeTextField
  module Owner
    extend ActiveSupport::Concern
    include ActiveSupport::Callbacks
    include LargeTextField::Base

    included do
      initialize_large_text_field
    end
  end
end
