require 'hobo_fields'

# TODO - this is a quick patch for hobo fields to get it working with sqlite3....

_ = HoboFields::Model::IndexSpec
_ = HoboFields::Model::ForeignKeySpec
module HoboFields
  module Model
    class ForeignKeySpec
      def self.for_model(model, old_table_name)
        puts model.connection.class.name
        query =
          if model.connection.class.name =~ /SQLite3Adapter/
            "SELECT sql FROM sqlite_master WHERE name = #{model.connection.quote_table_name(old_table_name)}"
          else
            "show create table #{model.connection.quote_table_name(old_table_name)}"
          end
        show_create_table = model.connection.select_rows(query).first.last
        constraints = show_create_table.split("\n").map { |line| line.strip if line['CONSTRAINT'] }.compact

        constraints.map do |fkc|
          options = {}
          name, foreign_key, parent_table = fkc.match(/CONSTRAINT `([^`]*)` FOREIGN KEY \(`([^`]*)`\) REFERENCES `([^`]*)`/).captures
          options[:constraint_name] = name
          options[:parent_table] = parent_table
          options[:foreign_key] = foreign_key
          options[:dependent] = :delete if fkc['ON DELETE CASCADE']

          self.new(model, foreign_key, options)
        end
      end
    end
  end
end
