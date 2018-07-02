# paul washburn
from functools import wraps
import time

def timing_function(some_function):
    '''
    Decorator function.  Outputs the time a function takes to execute.
    '''
    @wraps(some_function)
    def wrapper(*args, **kwargs):
        t1 = time.time()
        result = some_function(*args, **kwargs)
        t2 = time.time()
        time_elapsed = round((t2 - t1), 2)
        print('Runtime: ' + str(time_elapsed) + ' seconds')
        return result
    
    return wrapper
