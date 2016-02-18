# Provides static access to rails helpers methods.  ( Methods that should have been static anyway. )

module LargeTextField
  module RailsHelpers
    class << self
      include ActionView::Helpers::NumberHelper
      include ActionView::Helpers::UrlHelper
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::AssetTagHelper
      include ActionView::Helpers::TextHelper
    end
  end
end

