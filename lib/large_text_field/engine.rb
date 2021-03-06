# frozen_string_literal: true

require 'rails/engine'

module LargeTextField
  class Engine < ::Rails::Engine
    isolate_namespace LargeTextField

    paths["app/models"] = "lib/large_text_field"

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s + File::SEPARATOR
        app.config.paths["db/migrate"].concat config.paths["db/migrate"].expanded
      end
    end
  end
end
