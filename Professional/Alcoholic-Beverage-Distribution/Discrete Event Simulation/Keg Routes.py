"""
KEGROUTE example.

Covers:

- Waiting for other processes
- Resources: Resource

Scenario:
  A KEGROUTE has a limited number of  KEGTRUCKS and defines
  a  processes that takes some (random) time.

  KEG processes arrive at the KEGROUTE at a random time. If one 
  KEGTRUCK is available, they start the  process and wait for it
  to finish. If not, they wait until they an use one.

"""
import random
import simpy
import numpy as np
from numpy import random
import datetime as dt
import pandas as pd

RANDOM_SEED = 42
NUM_KEGS = lambda: int(random.normal(221.87, 48.32) / random.normal(65, 15))

KEGTRUCKS_AVAILABLE = 4  # STL 
RTE_EXECUTE_TIME = lambda: random.normal(5, 1.25)     # Hours to execute route

T_INTER = 1       # Create a KEG every ~7 days
SIM_TIME = 50000     # Simulation time in days


class KEGROUTE(object):
    """A KEGROUTE has a limited number of KEGTRUCKS (``KEGTRUCKS_AVAILABLE``) to
    deliver KEGs in parallel.

    KEGs have to request one of the KEGTRUCKS. When they got one, they
    can start the  processes and wait for it to finish (which
    takes ``RTE_EXECUTE_TIME`` hours).

    """
    def __init__(self, env, KEGTRUCKS_AVAILABLE, RTE_EXECUTE_TIME, NUM_KEGS):
        self.name = 1
        self.name += 1 
        self.env = env
        self.KEGTRUCK = simpy.Resource(env, KEGTRUCKS_AVAILABLE)
        self.RTE_EXECUTE_TIME = RTE_EXECUTE_TIME
        self.NUM_KEGS = NUM_KEGS

    def deliver_kegs(self, KEG, RTE_EXECUTE_TIME):
        """The  processes. It takes a ``KEG`` processes and tries
        to deliver it."""
        yield self.env.timeout(RTE_EXECUTE_TIME)
        print("%s removed from route after %.2f." %(KEG, self.RTE_EXECUTE_TIME))
        
    def gather_statistics(self):
        _stats = pd.DataFrame()
        



def KEG(env, name, KEGROUTE):
    """
    The KEG process (each KEG has a ``name``) arrives at the KEGROUTE
    (``KEGROUTE``) and requests a  KEGTRUCK. It then starts the route and then 
    is delivered to customer.
    """
    
    print('%s arrives at the KEGROUTE at %.2f.' % (name, env.now))
    with KEGROUTE.KEGTRUCK.request() as request:
        yield request

        print('%s enters the KEGROUTE %s.' % (name, KEGROUTE.name))
        yield env.process(KEGROUTE.deliver_kegs(name, KEGROUTE.RTE_EXECUTE_TIME))

        print('%s leaves the KEGROUTE %s.' % (name, KEGROUTE.name))


def setup(env, KEGTRUCKS_AVAILABLE, RTE_EXECUTE_TIME, NUM_KEGS, t_inter):
    """Create a KEGROUTE, a number of initial KEGs and keep creating KEGs
    approx. every ``t_inter`` days."""
    # Create the KEGROUTE
    KR = KEGROUTE(env, KEGTRUCKS_AVAILABLE, RTE_EXECUTE_TIME, NUM_KEGS)

    # Create 4 initial KEGs
    for i in range(4):
        env.process(KEG(env, 'KEG %s' % i, KR))

    # Create more KEGs while the simulation is running
    while True:
        yield env.timeout(RTE_EXECUTE_TIME)
        i += 1
        env.process(KEG(env, 'KEG %s' % i, KR))


# Setup and start the simulation
print('KEGROUTE')
print('Check out http://youtu.be/fXXmeP9TvBg while simulating ... ;-)')
random.seed(RANDOM_SEED)  # This helps reproducing the results



# x = KEGROUTE(env, KEGTRUCKS_AVAILABLE, RTE_EXECUTE_TIME(), NUM_KEGS())
# x.RTE_EXECUTE_TIME


# Create an environment and start the setup process
env = simpy.Environment()
env.process(setup(env, KEGTRUCKS_AVAILABLE, RTE_EXECUTE_TIME(), NUM_KEGS(), T_INTER))

# Execute!
env.run(until=SIM_TIME)






































