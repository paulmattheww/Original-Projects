def generate_random_rgb():
    from numpy.random import randint
    return 'rgb({}, {}, {})'.format(randint(0, 255), randint(0, 255), randint(0, 255))
