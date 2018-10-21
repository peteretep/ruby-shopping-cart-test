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

*Prerequisites*
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