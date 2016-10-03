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

setup_date = deliveries.CustomerSetup.astype(str).tolist()
setup_month = Series([d.zfill(4)[:2] for d in setup_date])
this_century = [int(d[-2:]) < 20 for d in setup_date]
setup_year = Series(["20" + s[-2:] if int(s[-2:]) < 20 else "19" + s[-2:] for s in setup_date])
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
_week_plan = [ship_week if plan_week == '' else plan_week for ship_week, plan_week in zip(_week_actual,_days.WeekPlanned.tolist())]

['T' in d and w == 'Tue' for d, w in zip(_days['DelDays'].tolist(), _days['Weekday'].tolist())]


[day.WeekPlanned == day.WeekShipped for day in _days[['WeekPlanned','WeekShipped']]]
_del_days = _days.DelDays.tolist()
_weekdays = _days.Weekday.tolist()


_off_day = list()


for day, wday in zip(_del_days, _weekdays):
    for plan, actual in zip(_plan, _actual):
        if plan != '':
            if plan != actual:
                _off_day.append('Y')
                    
            elif plan == actual:
                if 'M' in day and wday == 'Mon':
                    _off_day.append('N')
                elif 'T' in day and wday == 'Tue':
                    _off_day.append('N')
                elif 'W' in day and wday == 'Wed':
                    _off_day.append('N')
                elif 'R' in day and wday == 'Thu':
                    _off_day.append('N')    
                elif 'F' in day and wday == 'Fri':
                    _off_day.append('N')
                elif 'S' in day and wday == 'Sat':
                    _off_day.append('N')
                elif 'U' in day and wday == 'Sun':
                    _off_day.append('N')
            else:
                _off_day.append('Y')
                
        elif plan == '':
            if 'M' in day and wday == 'Mon':
                    _off_day.append('N')
            elif 'T' in day and wday == 'Tue':
                _off_day.append('N')
            elif 'W' in day and wday == 'Wed':
                _off_day.append('N')
            elif 'R' in day and wday == 'Thu':
                _off_day.append('N')    
            elif 'F' in day and wday == 'Fri':
                _off_day.append('N')
            elif 'S' in day and wday == 'Sat':
                _off_day.append('N')
            elif 'U' in day and wday == 'Sun':
                _off_day.append('N')
            else:
                _off_day.append('Y')

        else:
            _off_day.append('N')

_off_day








deliveries.head()




pw_offday = read_csv('C:/Users/pmwash/Desktop/R_files/Data Input/Input Files for Reports/Off-Day Deliveries/pw_offday.csv')
weeklookup = read_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Off Day Deliveries/pw_offday_weeklookup.csv')#change htese paths





















