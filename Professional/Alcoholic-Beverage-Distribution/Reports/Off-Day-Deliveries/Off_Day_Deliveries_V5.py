'''
Off Day and Additional Deliveries
Re-engineered September/October 2016
'''

from pandas import Series, DataFrame, read_csv
import numpy as np
import pandas as pd
from datetime import datetime as dt
import itertools

pd.set_option('display.height', 100)
pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 100)
pd.set_option('display.width', 100)


pw_offday = read_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Off Day Deliveries/pw_offday.csv')
weeklookup = read_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Off Day Deliveries/pw_offday_weeklookup.csv')#change htese paths



#def clean_pw_offday(pw_offday, weeklookup):
#    '''
#    Clean pw_offday query without filtering out non-off-days
#    '''
deliveries = pw_offday

def as400_date(dat):
    '''Accepts date as formatted in AS400'''
    dat = str(dat)
    dat = dat[-6:]
    dat = str(dt.date(dt.strptime(dat, '%y%m%d')))
    return dat
    
deliveries.columns = ['Date', 'Division', 'Invoice', 'CustomerId', 'Call', 'Priority', 
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

deliveries['CustomerSetup'] = c_setup = [str(mon) + '-' + str(yr) for mon, yr in zip(setup_month, setup_year)]

last_month = str(dt.now().month - 1).zfill(2)
this_year = str(dt.now().year)
m_y_cutoff = last_month + '-' + this_year

transaction_month = [d[5:7] for d in deliveries.Date.tolist()]
transaction_year = [d[:4] for d in deliveries.Date.tolist()]
m_y_transaction = [m + '-' + y for m, y in zip(transaction_month, transaction_year)]

deliveries['NewCustomer'] = _new_cust = [1 if m_y_cutoff == setup else 0 for setup in c_setup]
deliveries['OffDayDeliveries'] =  deliveries.OffDayDelivery.astype(int)
    
print(deliveries.head(),'\n\n\n\n',deliveries.tail())
    
len_unique = lambda x: len(pd.unique(x))
agg_funcs = {'OffDayDeliveries' : {'Count':max}, 
             'Date' : {'Count':len_unique},
             'Cases' : {'Sum':sum, 'Avg':np.mean},
             'NewCustomer': lambda x: min(x)}

_agg_byday = DataFrame(deliveries.groupby(['CustomerId','Customer','Week','Date']).agg(agg_funcs)).reset_index(drop=False)
_agg_byday = DataFrame(_agg_byday[['CustomerId','Week','Date','OffDayDeliveries','NewCustomer']])
_agg_byday.columns = ['%s%s' % (a, '|%s' % b if b else '') for a, b in _agg_byday.columns]
_agg_byday.columns = ['CustomerId','Week','Date','Delivery','OffDayDelivery','NewCustomer']
_agg_byday.head(50)


agg_funcs_week = {'OffDayDelivery' : {'Count':sum},
                  'Delivery' : {'Count':sum},
                  'NewCustomer' : lambda x: min(x)}

_agg_byweek = DataFrame(_agg_byday.groupby(['CustomerId','Week']).agg(agg_funcs_week)).reset_index(drop=False)
_agg_byweek.columns = ['%s%s' % (a, '|%s' % b if b else '') for a, b in _agg_byweek.columns]

def sum_digits_in_string(digit):
    return sum(int(x) for x in digit if x.isdigit())

_n_days = deliveries.Ship.astype(str).tolist()
deliveries['AllottedWeeklyDeliveryDays'] = [sum_digits_in_string(n) for n in _n_days]
_agg_byweek['AlottedWeeklyDeliveryDays|Count'] = _agg_byweek['CustomerId'] 
_agg_byweek.columns = ['CustomerId','Week','Delivery|Count','OffDayDelivery|Count','NewCustomer','AllottedWeeklyDeliveryDays|Count']

_allot = deliveries['AllottedWeeklyDeliveryDays'].tolist()
_week_ind = deliveries['ShipWeekPlan'].tolist()
deliveries['AllottedWeeklyDeliveryDays'] = [a if w not in ['A','B'] else 0.5 for a, w in zip(_allot, _week_ind)]
_n_days = deliveries.set_index('CustomerId')['AllottedWeeklyDeliveryDays'].to_dict()
_agg_byweek['AllottedWeeklyDeliveryDays|Count'] = _agg_byweek['AllottedWeeklyDeliveryDays|Count'].map(_n_days)

check_later3 = _agg_byweek[(_agg_byweek['OffDayDelivery|Count']>0) & (_agg_byweek['Delivery|Count'] > _agg_byweek['AllottedWeeklyDeliveryDays|Count']) & (_agg_byweek['NewCustomer'] != 1)]
addl_day_indicator = (_agg_byweek['OffDayDelivery|Count']>0) & (_agg_byweek['Delivery|Count'] > _agg_byweek['AllottedWeeklyDeliveryDays|Count']) & (_agg_byweek['NewCustomer'] != 1)
off_ct = _agg_byweek['OffDayDelivery|Count'].tolist()
_agg_byweek['AdditionalDelivery|Count'] = [off if ind == True else 0 for off,ind in zip(off_ct, addl_day_indicator)]






_agg_byweek[_agg_byweek['AdditionalDelivery|Count'] > 0].head(50)


x = _agg_byweek[(_agg_byweek['OffDayDelivery|Count']>0) & (_agg_byweek['Delivery|Count'] > _agg_byweek['AlottedWeeklyDeliveryDays|Count'])]

x[x['AdditionalDelivery|Count'] > 0].head(50)

x.head(50)







_allotted_ct = _agg_byweek['AlottedWeeklyDeliveryDays|Count'].astype(int).tolist()
_deliv_ct = _agg_byweek['Delivery|Count'].astype(int).tolist()



_agg_byweek['AdditionalDelivery|Count'] = [_actual - _allotted if _actual > _allotted else 0 for _actual,_allotted in zip(_allotted_ct, _deliv_ct)]


_agg_byweek.head(50)


{deliveries[['CustomerId']],deliveries[['AllottedWeeklyDeliveryDays']]}

_agg_byweek['AlottedWeeklyDeliveryDays|Count'] = [sum_digits_in_string(n) for n in _n_days]

s = '111111111100000000000'
u = '111111111100000000000'
test = [s, u]












_agg_byweek.head(100)
_agg_byweek[_agg_byweek['AdditionalDelivery|Count'] > 1].head(50)


{k:sum(t) for k,t in test.items()}



accumulator = list()

for i, _ in enumerate(test):
    s = test[i]
    while len(s) > 0:
        for j, _ in enumerate(s):    
            _sum = 0
            _sum += int(s[j])
        accumulator.append(_sum)
    
#for i, _ in enumerate(s):
#    _sum += np.float64(s[i])
#    print(int(s[i]))
        

_agg_byweek['AdditionalDayDelivery|Count'] = 




n_days_week = deliveries.Ship.astype(str).tolist()



_agg_byweek['OffDayDelivery|Count'] / _agg_byweek['Delivery|Count']

_agg_byweek.head(50)

check_later2 = _agg_byweek[_agg_byweek['OffDayDelivery|Count'] > 0]





    return deliveries


clean_data = clean_pw_offday(pw_offday, weeklookup)

clean_data.head()




















