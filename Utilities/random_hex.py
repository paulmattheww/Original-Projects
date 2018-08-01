import random

def random_hex():
    r = lambda: random.randint(0, 255)
    return '#%02X%02X%02X' % (r(),r(),r())
