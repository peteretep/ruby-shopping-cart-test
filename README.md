# Challenge details

You have been asked to model a shopping basket.  We must be able to:

* Add items to the shopping basket
* Remove items from the shopping basket
* Empty the shopping basket

Additionally, we must be able to calculate the total of the shopping basket accounting for:

* Buy-one-get-one-free discounts on items
* 10% off on totals greater than £20 (after bogof)
* 2% off on total (after all other discounts) for customers with loyalty cards.

There is no requirement to create a GUI but we must be able to see the code running or tests passing.

# Implementation details

**Prerequisites**

This code was written with Ruby 2.5.3

This implementation uses an sqlite database. You will need to have that installed.
On Ubuntu:

    sudo apt install libsqlite3-dev

Clone the repository with:

    git@github.com:peteretep/ruby-shopping-cart-test.git

Install the required gems:

    cd ruby-shopping-cart-test
    bundle install --binstubs

Run the tests with:

    rspec

Test code is in the `spec/cart_spec.rb` file. RSpec is used.

Database connection / creation code is in the `lib/db.rb` file. Sqlite is used and the database is be created in memory for development purposes.

There are four tables created, for customers, items, baskets and a basket_item relationship table.

Main code lives in the `lib/cart.rb` file.
Activerecord ORM is used.

### Known issues

* Items with the same name / price can be created
* If more than one of the same item is added to a basket, the `remove_item` method will remove all of them. This behaviour is captured in a test, which is currently failing.
