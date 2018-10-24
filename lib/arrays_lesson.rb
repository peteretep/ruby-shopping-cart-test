# collections / groups of things
# arrays

# Arrays are indexed
# arrays are like lockers

# with numbers on them

# Terminal - shortcut
# irb

band = ['trumpet', 'sax', 'sax', 'drums']
# square brackets
band
# keys to arrays are integers
# in ruby we don't need to say how big the array is, it grows automatically


band[1]

# zero indexed
band[0]

band[-1]

# out of bounds?
band[4] # nil

band.first
band.last(2)

# What are arrays useful for?
members = ['rich', 'liv', 'gemma', 'simon']

# What are arrays not useful for?
member_details = ['pete', 'sax']
name = member_details[0]
instrument = member_details[1]
# We'll come back to that idea in another class


# Creating an empty array
brass = []
woodwind = Array.new(2)


## Adding and removing stuff

brass.push('trumpet')
brass.push('trombone')
# What order are they going in?
brass.push('clarinet')

# We can also use the << shovel operator
brass << 'guitar'
# wait a minute, guitar isn't brass, lets get it out
brass.pop
# Neither is clarinet! Change it to a cornet
brass[2] = 'cornet'

# We can also add and remove things to the _start_ of an array
woodwind[0] = 'flute'
woodwind[1] = 'bagpipes'
woodwind.unshift('saxophone')
woodwind.shift
woodwinf.unshift('sax')

# Array elements can be anything, or even a mix
even_numbers = [2, 4, 6, 8]
float_numbers = [2.0, 4.0, 6.0, 8.0]

# We can mix the kind of things we put into an array:
ones = []
ones << 1
ones.push(1.0)
# can even put an array into an array
ones.push(['1', '1.0'])
ones = [1, 1.0, 'one', ['1', '1.0']]
# How many elements are in this array?
ones.size
# How do we get, the string value 'one'
# How do we get, the string value '1.0'


## Array Operators
# + concatenation
band + woodwind
# - removal
band - brass
# What about 
band - 'sax'
# Nope!

# & union
band & woodwind
band & brass
brass & woodwind
# | (pipe) intersection 
brass | woodwind
band | brass
woodwind | band
# Concatenation != shovelling

# !! Important
# Each time we use one of these operators, we're not changing the original arrays
# Ruby is returning a new array for us.
# We could save that to a new variable name

betterband = band + woodwind

# Array methods
# How many are in the band?
# size, count, length
# How many could be in the whole band?

# We can ask an array lots of things
# For example, if we had a new band, with space for four members
# any? none? all?
newband = Array.new(4)
newband.any?
newband.none?

newband[0] = 'piano'
newband[1] = 'guitar'
newband.all?

newband.include? 'guitar'
newband.include? 'bass'
newband[2] = 'bass'

# change of mind, three is enough
trioband = newband.compact
# if we want to keep the name of the band, we can do
newband.compact!

newband.all?

# max and min
[2,4,5,6].max
# max and min on a string array?

# Manipulating arrays
# .concat
band.concat woodwind
band
# oh look band has changed

band << newband
band.flatten

# just return the different types of instrument once
band.uniq

# Join - transform to a string
# join with a delimiter

# changing the seats in the band, for one time only
band.shuffle
# keep things changed
band.shuffle!

# pick a solist for the night
band.sample


# Documentation
# Google ruby-doc
# ruby-doc.com > core > Array





