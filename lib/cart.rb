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
  end

  create_table :items, force: true do |table|
    table.string :name
    table.decimal :price
  end

  create_table :baskets, force: true do |table|
    table.references :customer
  end
end

class Customer < ActiveRecord::Base
  has_many :baskets
  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true
end

class Basket < ActiveRecord::Base
  belongs_to :customer
  validates :customer, presence: true
end