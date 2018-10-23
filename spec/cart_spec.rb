require './lib/cart.rb'
require 'pry'

RSpec.describe Customer do
  describe '#new' do
    it 'requires a name' do
      customer = Customer.new
      customer.name = ''
      customer.valid?
      expect(customer.errors[:name]).to include("can't be blank")
      customer.name = 'Peter'
      customer.valid?
      expect(customer.errors[:name]).to_not include("can't be blank")
    end
    it 'requires a valid email' do
      customer = Customer.new
      customer.email = ''
      customer.valid?
      expect(customer.errors[:email]).to include("can't be blank")
      customer.email = 'pwer@'
      customer.valid?
      expect(customer.errors[:email]).to include('is invalid')
      customer.email = 'peter@peterarmstrong.ie'
      customer.valid?
      expect(customer.errors[:email]).to be_empty
    end
    it 'customer should not be a member by default' do
      customer = Customer.create!(name: 'Peter',
                                  email: 'peter@armstong.ie')
      expect(customer.member).to be false
    end
    it 'customer should be a member by if set to true' do
      customer = Customer.create!(name: 'Peter',
                                  email: 'peter@armstong.ie',
                                  member: true)
      expect(customer.member).to be true
    end
  end
end

RSpec.describe Item do
  describe '#new' do
    it 'requires name' do
      item = Item.new
      item.name = ''
      item.valid?
      expect(item.errors[:name]).to include("can't be blank")
      item.name = 'Coffee beans'
      item.valid?
      expect(item.errors[:name]).to_not include("can't be blank")
    end
    it 'requires price to be greater than or equal to 0' do
      item = Item.new
      item.price = ''
      item.valid?
      expect(item.errors[:price]).to include("can't be blank")
      item = Item.new
      item.price = 'string should not work'
      item.valid?
      expect(item.errors[:price]).to include('is not a number')
      item.price = -1.3
      item.valid?
      expect(item.errors[:price]).to include('must be greater than or equal to 0')
    end
  end
end

RSpec.describe Basket do
  let(:customer) do
    Customer.create!(name: 'Peter',
                     email: 'peter@armstong.ie')
  end
  let(:item1) { Item.create!(name: 'Tea', price: 310) }
  let(:item2) { Item.create!(name: 'Coffee', price: 340) }
  let(:expensive_item) { Item.create!(name: 'Bike', price: 200_00) }

  let(:testbasket) { Basket.create!(customer: customer) }
  describe '#new' do
    it 'requires a customer' do
      basket = Basket.new
      basket.valid?
      expect(basket.errors[:customer]).to include("can't be blank")
      basket.customer = customer
      basket.valid?
      expect(basket.errors).to be_empty
    end
  end
  describe 'items' do
    it 'can have many items' do
      testbasket.add_item(item1)
      testbasket.add_item(item2)
      expect(testbasket.items.size).to equal 2
    end
    it 'can have multiple of the same item', focus: true do
      testbasket.add_item(item1)
      testbasket.add_item(item1)
      testbasket.add_item(item1)
      expect(testbasket.items.size).to equal 3
    end
  end
  describe 'remove_item' do
    it 'should remove an item from the basket' do
      testbasket.add_item(item1)
      testbasket.add_item(item2)
      testbasket.remove_item(item1)
      expect(testbasket.items.size).to equal 1
    end
    describe 'when multiples of same item' do
      it 'should remove one item from the basket' do
        testbasket.add_item(item1)
        testbasket.add_item(item1)
        testbasket.add_item(item1)
        testbasket.remove_item(item1)
        expect(testbasket.items.size).to equal 2
      end
    end
  end

  describe 'empty_basket' do
    it 'should empty the basket' do
      testbasket.add_item(item1)
      testbasket.add_item(item1)
      testbasket.add_item(item2)
      testbasket.empty_basket
      expect(testbasket.items.size).to equal 0
    end
  end

  describe '#subtotal' do
    it 'should give the sum of the items in the basket' do
      testbasket.add_item(item1)
      expect(testbasket.subtotal).to equal 310
      testbasket.add_item(item2)
      expect(testbasket.subtotal).to equal 650
    end
  end
  describe '#buy_one_get_one_free_applied' do
    it 'should bogof it two of the same items' do
      testbasket.add_item(item1)
      testbasket.add_item(item1)
      testbasket.add_item(item2)
      expect(testbasket.buy_one_get_one_free_applied).to equal 650
    end

    it 'should bogof correctly if three of the same items' do
      testbasket.add_item(item1)
      testbasket.add_item(item1)
      testbasket.add_item(item1)
      testbasket.add_item(item2)
      expect(testbasket.buy_one_get_one_free_applied).to equal 960
    end
    it 'should bogof correctly if four of the same items' do
      testbasket.add_item(item1)
      testbasket.add_item(item1)
      testbasket.add_item(item1)
      testbasket.add_item(item1)
      testbasket.add_item(item2)
      expect(testbasket.buy_one_get_one_free_applied).to equal 960
    end
  end
  describe '#apply_ten_percent_discount' do
    it 'should give ten percent discount on total greater than 20' do
      testbasket.add_item(expensive_item)
      testbasket.apply_ten_percent_discount
      expect(testbasket.apply_ten_percent_discount).to equal 180_00
    end
    it 'should give ten percent discount on total greater than 20 after bogof' do
      testbasket.add_item(expensive_item)
      testbasket.add_item(expensive_item)
      expect(testbasket.apply_ten_percent_discount).to equal 180_00
    end
    it 'should not apply discount on totals less than 20' do
      testbasket.add_item(item1)
      expect(testbasket.apply_ten_percent_discount).to equal 310
    end
  end
  describe '#apply_loyalty_discount' do
    let(:non_member) do
      Customer.create!(name: 'Peter',
                       email: 'peter@armstong.ie')
    end
    let(:member) do
      Customer.create!(name: 'John',
                       email: 'john@armstong.ie',
                       member: true)
    end
    it 'should apply loyalty discount if customer is a member' do
      members_basket = Basket.create!(customer: member)
      members_basket.add_item(item1)
      members_basket.add_item(item2)


      expect(members_basket.apply_loyalty_card_discount).to equal 637
    end
    it 'should not apply loyalty discount if customer is not a member' do
      non_members_basket = Basket.create!(customer: non_member)
      non_members_basket.add_item(item1)
      non_members_basket.add_item(item2)

      expect(non_members_basket.apply_loyalty_card_discount).to equal 650
    end
  end
end
