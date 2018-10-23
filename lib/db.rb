require 'sqlite3'
require 'active_record'
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Schema.define do
  create_table :customers, force: true do |table|
    table.string :name
    table.string :email
    table.boolean :member
  end

  create_table :items, force: true do |table|
    table.string :name
    table.integer :price
  end

  create_table :baskets, force: true do |table|
    table.references :customer
  end

  create_table :baskets_items, force: true do |table|
    table.belongs_to :basket
    table.belongs_to :item
    table.integer :count
  end
end
