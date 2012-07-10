from rabble import Rabble

def setup():
    global rabble
    rabble = Rabble()


def teardown():
    global rabble
    del rabble


def test_add_mention():
    rabble.add(('ted', 'colleen'))
    assert rabble.users == set(('ted', 'colleen'))
    assert rabble.mentions == set([('ted', 'colleen')])
    assert rabble.cxns == set()


def test_add_cxn():
    rabble.add(('ted', 'colleen'))
    rabble.add(('colleen', 'ted'))
    assert rabble.users == set(('ted', 'colleen'))
    assert rabble.mentions == set([('ted', 'colleen'), ('colleen', 'ted')])
    assert rabble.cxns == set([('colleen', 'ted')])


def test_union():
    rabble.union(set([('ted', 'colleen'), ('colleen', 'ted')]))
    assert rabble.users == set(('ted', 'colleen'))
    assert rabble.mentions == set([('ted', 'colleen'), ('colleen', 'ted')])
    assert rabble.cxns == set([('colleen', 'ted')])


def test_n_order_when_1():
    rabble.union(set([('ted', 'colleen'), ('colleen', 'ted')]))
    assert rabble.n_order('ted', 1) == set(['colleen'])
    assert rabble.n_order('colleen', 1) == set(['ted'])


def test_n_order_when_2():
    rabble.union(set([('ted', 'colleen'), ('colleen', 'ted'), ('colleen', 'kimberly'), ('kimberly', 'colleen')]))
    assert rabble.n_order('ted', 2) == set(['kimberly'])
    assert rabble.n_order('kimberly', 2) == set(['ted'])
