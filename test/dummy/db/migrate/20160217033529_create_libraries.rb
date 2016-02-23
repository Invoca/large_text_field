class CreateLibraries < ActiveRecord::Migration
  def self.up
    create_table :libraries do |t|
      t.string :name, null: false
    end
  end

  def self.down
    drop_table :libraries
  end
end
