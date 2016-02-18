module LargeTextField
  class Engine < ::Rails::Engine
    isolate_namespace LargeTextField

    initializer :append_migrations do |app|
      app.config.paths["db/migrate"].concat config.paths["db/migrate"].expanded
    end
  end
end
