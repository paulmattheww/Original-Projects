'''
Off Day and Additional Deliveries
Re-engineered September/October 2016
'''

from pandas import Series, DataFrame, read_csv
import numpy as np
import pandas as pd
from datetime import datetime as dt
import itertools




pw_offday = read_csv('C:/Users/pmwash/Desktop/R_files/Data Input/Input Files for Reports/Off-Day Deliveries/pw_offday.csv')
weeklookup = read_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Off Day Deliveries/pw_offday_weeklookup.csv')#change htese paths



def clean_pw_offday(pw_offday, weeklookup):
    '''
    Clean pw_offday query without filtering out non-off-days
    '''
deliveries = pw_offday

def as400_date(dat):
    '''Accepts date as formatted in AS400'''
    dat = str(dat)
    dat = dat[-6:]
    dat = str(dt.date(dt.strptime(dat, '%y%m%d')))
    return dat
    
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
deliveries.CustomerType = deliveries.CustomerType.astype(str).map(typ_map)    

whs_map = {1:'Kansas City',2:'Saint Louis',3:'Columbia',4:'Cape Girardeau', 5:'Springfield'}
deliveries.Warehouse = deliveries.Warehouse.map(whs_map)          

deliveries.Date = [as400_date(d) for d in deliveries.Date.astype(str).tolist()]    
deliveries = deliveries.merge(weeklookup, on='Date')

dat = Series(deliveries.Date.tolist())
dat_f = Series([dt.strptime(d, '%Y-%m-%d') for d in dat])
deliveries['Weekday'] = Series([dt.strftime(d, '%A') for d in dat_f])

week_plan = deliveries.ShipWeekPlan.tolist()
week_shipped = deliveries.ShipWeek.tolist()

month = deliveries.Month
year = deliveries.Year

deliveries.Ship = del_days = [str('%07d'% int(str(day).zfill(0))) for day in deliveries.Ship.astype(str).tolist()]

mon = Series([d[-7:][:1] for d in del_days]).map({'1':'M','0':'_'})
tue = Series([d[-6:][:1] for d in del_days]).map({'1':'T','0':'_'})
wed = Series([d[-5:][:1] for d in del_days]).map({'1':'W','0':'_'})
thu = Series([d[-4:][:1] for d in del_days]).map({'1':'R','0':'_'})
fri = Series([d[-3:][:1] for d in del_days]).map({'1':'F','0':'_'})
sat = Series([d[-2:][:1] for d in del_days]).map({'1':'S','0':'_'})
sun = Series([d[-1:][:1] for d in del_days]).map({'1':'U','0':'_'})

deliveries['DeliveryDays'] = del_days = list(itertools.chain.from_iterable([mon + tue + wed + thu + fri + sat + sun]))

weekday = deliveries.Weekday = [d[:3] for d in deliveries.Weekday.astype(str).tolist()]
_days = DataFrame(data={'Weekday':weekday, 'WeekPlanned':week_plan, 'WeekShipped':week_shipped, 'DelDays':del_days}) #'Monday':mon, 'Tuesday':tue, 'Wednesday':wed, 'Thursday':thu, 'Friday':fri, 'Saturday':sat, 'Sunday':sun,
day_list = _days['WeekPlanned'].tolist()
_days['WeekPlanned'] = [d if d in ['A','B'] else '' for d in day_list]

_week_actual = _days.WeekShipped.tolist()
_week_plan = _days['WeekPlanned'] = [ship_week if plan_week == '' else plan_week for ship_week, plan_week in zip(_week_actual,_days.WeekPlanned.tolist())]
_days['OffWeek'] = _off_week = [p != a for p, a in zip(_week_plan, _week_actual)]

off_mon = [str('M' not in d and w == 'Mon')[:1] for d, w in zip(del_days, weekday)]
off_tue = [str('T' not in d and w == 'Tue')[:1] for d, w in zip(del_days, weekday)]
off_wed = [str('W' not in d and w == 'Wed')[:1] for d, w in zip(del_days, weekday)]
off_thu = [str('R' not in d and w == 'Thu')[:1] for d, w in zip(del_days, weekday)]
off_fri = [str('F' not in d and w == 'Fri')[:1] for d, w in zip(del_days, weekday)]
off_sat = [str('S' not in d and w == 'Sat')[:1] for d, w in zip(del_days, weekday)]
off_sun = [str('U' not in d and w == 'Sun')[:1] for d, w in zip(del_days, weekday)]

_off_days = DataFrame({'Mon':off_mon, 'Tue':off_tue, 'Wed':off_wed, 'Thu':off_thu, 
                       'Fri':off_fri, 'Sat':off_sat, 'Sun':off_sun, 'OffWeek':_off_week, 'Weekday':weekday})
_off_days = _off_days[['Mon','Tue','Wed','Thu','Fri','Sat','Sun','Weekday','OffWeek']]                           
_off_days['OffDayDelivery'] = (_off_days['Mon'] == 'T') | (_off_days['Tue'] == 'T') | (_off_days['Wed'] == 'T') | (_off_days['Thu'] == 'T') | (_off_days['Fri'] == 'T') | (_off_days['Sat'] == 'T') | (_off_days['Sun'] == 'T') | (_off_days['OffWeek'] == True)                
                       
check_later = _off_days[_off_days['OffDayDelivery'] == True]

deliveries = pd.concat([deliveries,_off_days[['OffWeek','OffDayDelivery']]], axis=1)
deliveries.Call = deliveries.Call.map({1:'Customer Call', 2:'ROE/EDI', 3:'Salesperson Call', 4:'Telesales'})

setup_date = deliveries.CustomerSetup.astype(str).tolist()
setup_month = Series([d.zfill(4)[:2] for d in setup_date])
this_century = [int(d[-2:]) < 20 for d in setup_date]
setup_year = Series(["20" + s[-2:] if int(s[-2:]) < 20 else "19" + s[-2:] for s in setup_date])

deliveries['CustomerSetup'] = [str(mon) + '-' + str(yr) for mon, yr in zip(setup_month, setup_year)]

last_month = str(dt.now().month - 1).zfill(2)
this_year = str(dt.now().year)
m_y_cutoff = last_month + '-' + this_year

transaction_month = [d[5:7] for d in deliveries.Date.tolist()]
transaction_year = [d[:4] for d in deliveries.Date.tolist()]
m_y_transaction = [m + '-' + y for m, y in zip(transaction_month, transaction_year)]

deliveries.NewCustomer = ['Y' if m_y_cutoff == transaction else 'N' for transaction in m_y_transaction]

    return deliveries


clean_data = clean_pw_offday(pw_offday, weeklookup)

clean_data.head()




























