class Rabble(object):
    '''
    A network of twitter-style users

    Represents the users and the connections between them for a network
    of users.  The primary interface is to add mentions.  From mentions,
    users and connections between them are tracked automatically.

    Users are tracked in the users attribute, mentions in the mention
    attribute and connections in the cxns attribute.  Users is a 
    set (the python type set) of strings.  Mentions and cxns are sets
    of pairs (tuples).  Mentions go in the order (from, to), and
    connections are sorted alphabetically since they are symmetric.

    To get the n_order connections for a user, use the method of the
    same name.

    '''
    def __init__(self):
        '''
        Initialize the rabble

        Adds empty copies of the attributes.

        Example usage:

        rabble = Rabble()

        '''
        self.users = set()
        self.mentions = set()
        self.cxns = set()

    def add(self, mention):
        '''
        Add a mention to the rabble

        A mention is a pair of the form ['from', 'to'].  Adding a
        mention updates the users and connections as well.

        Example usage:

        >>> rabble = Rabble()
        >>> rabble.add(('ted', 'colleen'))
        >>> rabble.mentions
        set([('ted', 'colleen')])

        '''
        self.users |= set(mention)
        self.mentions |= set([mention])
        self._check_reflexive_mentions()

    def _check_reflexive_mentions(self):
        '''
        Check whether a new connection has been made

        An additional mention creates a new connection if the reverse
        mention also exists in the rabble.

        '''
        for mention in self.mentions:
            l_mention = list(mention)
            l_mention.reverse()
            if tuple(l_mention) in self.mentions:
                l_mention.sort()
                self.cxns.add(tuple(l_mention))

    def union(self, other_set):
        '''
        Union a set of mentions with the existing mentions

        Take a set of mentions and perform a union operation with the
        existing ones, then check for reflexive mentions to add
        connections.
        
        '''
        self.mentions |= other_set
        for item in other_set:
            self.users |= set(item)
        self._check_reflexive_mentions()
    
    def n_order(self, name, n):
        '''
        Calculate the nth-order connections of a given user

        A recursive function which provides first-order connections
        as the base case.  Uses set operations.

        First-order connections are calculated as the set of other users
        in all connections which include the named user.

        Higher-order connections are calculated as the set of other
        users in connections with the users who are in first-order
        connections with the previous-order group, less any users who
        have been in previous-order groups as well as the named user
        themself.  This is a mouthful.

        In practice, it means look at, for example, the second-order
        connections to a named user.  You can find them by expanding out
        one level from the first-order connection users.  That is, you
        look at the users directly connected to the named user, then
        you go out one more level of connections from them.  Finally,
        you make sure there aren't any repeats of names from lower-order
        connections.  You also take out the named user since they will
        show up in each of the other users' first-order connections by
        definition.

        Example usage:

        >>> rabble = Rabble()
        >>> rabble.union(set([('colleen', 'ted'), ('ted', 'colleen')]))
        >>> rabble.n_order('colleen', 1)
        set(['ted'])
        >>> rabble.union(set([('colleen', 'kimberly'), ('kimberly', 'colleen')]))
        >>> rabble.n_order('kimberly', 2)
        set(['ted'])

        '''
        if n == 1:
            return set([(set(cxn) - set([name])).pop() for cxn in self.cxns if name in cxn])
        return set([new_item for item in self.n_order(name, n - 1) for new_item in self.n_order(item, 1)]) - set([item for i in range(1, n) for item in self.n_order(name, i)]) - set([name])
