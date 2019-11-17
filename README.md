# Number Gossip

Number Gossip is a web site explaining properties of integers.  For
example, [6](http://numbergossip.com/6) is the only
[even](http://numbergossip.com/list#even_numbers)
[evil](http://numbergossip.com/list#evil_numbers)
[perfect](http://numbergossip.com/list#perfect_numbers) number; it's
also a [factorial](http://numbergossip.com/list#factorials), a
[palindrome](http://numbergossip.com/list#palindromes), and many other
things besides.

As a matter of technology stack, it's a Ruby on Rails application,
using SQLite to store the property definitions.  Which numbers have
which properties is either computed online for the fast ones, or also
stored in the database (up to 10,000).
