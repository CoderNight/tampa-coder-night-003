# Rabble

A utility to map out network connections of twitter-like users

A mention is one user addressing another.  Mutual respective mentions by 
two users comprise a connection between them.

First-order connections consist of two people who have a direct
connection. Second-order connections for a given user are the set of 
people connected to their first-order connections, not including the 
user theirself and the first-order connections, since those take primacy 
over higher-order connections and for brevity.

N-order connections extrapolate from the first-order connections of
the n-1 (prior) circle of connections.

## Naming origin

We informally refer to the users as "social butterflies".  There isn't a 
universally-accepted term for a group of butterflies, but they are 
sometimes referred to as swarms, kaleidescopes, leks or rabbles.  The 
name rabble seemed to stick out for it's typability as well as the 
connotations of noisiness you might associate with twitter users.

## Target platform

This project was developed targeting Ruby 1.9.3.

## Usage

In order to use the class, `require` or `require\_relative` the 
rabble.rb file.  Create an instance of the class Rabble and use either 
the `#add` method to add a single mention to the rabble, or the `#union` 
method to add a group of mentions all at once.

Mentions are simple pairs in the form `['from', 'to']` where from and to
are usernames from the feed.  Order is important.  Here's an example of
adding Joe's mention of Mary, presuming that we've instantiated an 
object called `rabble`:

    >>> rabble.add ['Joe', 'Mary']

Here's an example of adding a set of mentions to a rabble

    >>> rabble.union [['Joe', 'Mary'], ['Mary', 'Joe']]

Once the rabble is populated, there is one method that gives any order 
of connections: `#n_order(name, order)`.  `Name` is the name of the user
whose connections you'd like to map, and `order` is the cardinality of 
the connections.  1 would be first-order (direct mentions), 2 is 
second-order and so on.  It returns a Ruby set of the users' names.

Here's an example of getting the results of a user's first-order 
connections:

    >>> rabble.n_order('Joe', 1)
    =>{Set: ['Mary']}

## Other Attributes and Methods

- `rabble.users` is the set of users in the network
- `rabble.mentions` is the set of mentions between users
- `rabble.cxns` is the set of connections between users
- `rabble.include?` checks whether a mention is included in the object 
(specifically the mentions attribute)

## Sample implementation

There is an implementation that outputs the network for all users in an 
input file.  The implementation is in `src/run.rb`.  Run it with the 
command `ruby run.rb`.

The sample implementation includes the routines to parse the format 
depicted in the original puzzle definition on puzzlenode.

## Tests

There are tests for the `Rabble` class (but not the sample 
implementation).  You can run them from the root directory with the 
command `rake test`.

The tests are written with the spec form of the Ruby-standard minitest 
module.

## Additional Info

For contrast in coding, there is also a Python implementation of the
Rabble class, using the same approaches.  If you are using Paver, you
can run the Nose test suite and doctests with the command `paver test`.
There is no sample implementation to parse the input file at this time.
