import random

def random_hex(seed):
    np.random.set_state(seed)
    r = lambda: random.randint(0, 255)
    return '#%02X%02X%02X' % (r(),r(),r())
