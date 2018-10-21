require 'sqlite3'
require 'active_record'
require 'pry'
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
  end
end

# Customer class to represent customers using our shopping cart
class Customer < ActiveRecord::Base
  has_many :baskets
  attribute :member, default: false
  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true
end

# Basket class to represent shopping baskets
class Basket < ActiveRecord::Base
  belongs_to :customer
  has_and_belongs_to_many :items
  validates :customer, presence: true

  def subtotal
    subtotal = items.sum { |item| item[:price] }
    subtotal
  end

  def buy_one_get_one_free_applied
    bogof_items = []
    items.group(:id).each do |item|
      number_of_this_item = items.group(:id).count[item.id]
      bogof_number_of_item = (number_of_this_item.to_f / 2).ceil
      bogof_number_of_item.times do
        bogof_items.push(item)
      end
    end
    bogof_items.sum { |item| item[:price] }
  end

  def apply_ten_percent_discount
    return buy_one_get_one_free_applied if buy_one_get_one_free_applied < 20_00

    discount = buy_one_get_one_free_applied * 0.1
    total = buy_one_get_one_free_applied - discount
    total.round
  end

  def apply_loyalty_card_discount
    return buy_one_get_one_free_applied unless customer.member?

    discount = buy_one_get_one_free_applied * 0.02
    total = buy_one_get_one_free_applied - discount
    total.round
  end

  def total_in_major_unit
    apply_loyalty_card_discount / 100
  end
end

# Item class - a product that can go in a basket
# Prices are in minor unit - pence or cents etc
class Item < ActiveRecord::Base
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  has_and_belongs_to_many :baskets

  def price_in_major_unit
    price / 100
  end
end
