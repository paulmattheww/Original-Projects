'''
Off Day & Additional Deliveries
Re-engineered September/October 2016
'''

from pandas import Series, DataFrame, read_csv
import numpy as np
import pandas as pd
from datetime import datetime as dt

def clean_pw_offday(pw_offday, weeklookup):
    '''
    Clean pw_offday query without filtering out non-off-days
    '''
deliveries = pw_offday
    
def as400_date(dat):
    '''Accepts date as formatted in AS400'''
    dat = str(dat)
    dat = dat[-6:]
    dat = dt.strptime(dat, '%y%m%d')
    
deliveries.columns = ['Date', 'Division', 'Invoice', 'CustomerID', 'Call', 'Priority', 
           'Warehouse', 'Cases', 'Dollars', 'Ship', 'Salesperson', 
           'ShipWeekPlan', 'Merchandising', 'OnPremise', 
           'CustomerSetup', 'CustomerType', 'Customer']

typ = deliveries.CustomerType
typ_map = {'A':'Bar/Tavern','C':'Country Club','E':'Transportation/Airline','G':'Gambling',\
            'J':'Hotel/Motel','L':'Restaurant','M':'Military','N':'Fine Dining','O':'Internal',\
            'P':'Country/Western','S':'Package Store','T':'Supermarket/Grocery','V':'Drug Store',\
            'Y':'Convenience Store','Z':'Catering','3':'Night Club','5':'Adult Entertainment','6':'Sports Bar',\
            'I':'Church','F':'Membership Club','B':'Mass Merchandiser','H':'Fraternal Organization',\
            '7':'Sports Venue'}
deliveries.CustomerType = deliveries.CustomerType.map(typ_map)    
          
deliveries.Date = [as400_date(deliveries.Date.astype(str)) for d in deliveries.Date.astype(str).tolist()]       



pw_offday = read_csv('C:/Users/pmwash/Desktop/R_files/Data Input/Input Files for Reports/Off-Day Deliveries/pw_offday.csv')
weeklookup = read_csv('N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/pw_offday_weeklookup.csv')





















