# paul washburn st louis mo cofactor
from datetime import datetime as dt

def fetch_current_month_year():
    '''
    Fetches month & year based on current date.
    '''
    this_mo = dt.now().strftime('%B')
    this_yr = dt.now().year
    time_dict = {'this_yr': this_yr, 'this_mo': this_mo}
    
    return time_dict
