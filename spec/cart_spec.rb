require './lib/cart.rb'

RSpec.describe Customer do
    describe '#new' do
        it "requires a name" do
            customer = Customer.new
            customer.name = ""
            customer.valid?
            expect(customer.errors[:name]).to include("can't be blank")
            customer.name = "Peter"
            customer.valid?
            expect(customer.errors[:name]).to_not include("can't be blank")
        end
        it "requires a valid email" do
            customer = Customer.new
            customer.email = ""
            customer.valid?
            expect(customer.errors[:email]).to include("can't be blank")
            customer.email = "pwer@"
            customer.valid?
            expect(customer.errors[:email]).to include("is invalid")
            customer.email = "peter@peterarmstrong.ie"
            customer.valid?
            expect(customer.errors[:email]).to be_empty
        end
    end
end

RSpec.describe Basket do
    describe '#new' do
        it "requires customer" do
            basket = Basket.new
            basket.valid?
            expect(basket.errors[:customer]).to include("can't be blank")
            customer1 = Customer.create!(name: "Peter", email: "peter@peterarmstrong.ie")
            basket.customer = customer1
            basket.valid?
            expect(basket.errors).to be_empty
        end
    end
end