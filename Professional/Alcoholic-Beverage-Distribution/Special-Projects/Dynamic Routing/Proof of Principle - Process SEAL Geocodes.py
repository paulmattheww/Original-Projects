'''
Process Geocode Data from SEAL Device
Proof of Principle - December 2016


'''

import pandas as pd
import numpy as np
import datetime as dt
from datetime import datetime
from geopy.geocoders import Nominatim
from geopy import distance, Point
import re
import difflib
import pprint

print('Reading in geocode data from SEAL device.')
f_name = '12062016-12092016 SEAL Geocode Data.csv'
f_path = 'C:/Users/pmwash/Desktop/Re-Engineered Reports/Projects/Dynamic Routing/'
d_types = {'DateTime':str, 'MPH':np.float64, 'Heading':np.int64, 
            'Elevation(ft.)':np.int64, 'Latitude':np.float64, 'Longitude':np.float64}
geo_data = pd.read_csv(f_path + f_name, header=0, dtype=d_types)

geo_data.DateTime = dat =  [datetime.strptime(d, '%m/%d/%Y %H:%M') for d in geo_data.DateTime]
geo_data['Date'] = [d.date() for d in dat]

print('Selecting for dates where routes were executed.')
day1 = dt.date(year=2016, month=12, day=9)
day2 = None #dt.date(year=2016, month=12, day=9)
day3 = None #dt.date(year=2016, month=12, day=9)
day4 = None #dt.date(year=2016, month=12, day=9)

rte_date = [day1, day2, day3, day4]
geo_data['IsRteDay'] = [d in rte_date for d in geo_data.Date]

print('Selecting only days where routes were executed.')
geo_data = geo_data[ geo_data.IsRteDay == True ]
geo_data.reset_index(drop=True, inplace=True)

print('Identifying gaps in readings.')
velocity = geo_data.MPH
geo_data['LastReading'] = last_time_reading = geo_data.shift(periods=1)['DateTime']
current_time_reading = geo_data.DateTime

geo_data['TimeElapsed'] = [current - last for last, current in zip(last_time_reading, current_time_reading)]
geo_data['SlowMoving'] = velocity <= 10

print('Define breakpoints where the previous record is more than 3 minutes ago.')
geo_data['BreakPoint'] = (geo_data.TimeElapsed > dt.timedelta(minutes=2)) & (geo_data.TimeElapsed < dt.timedelta(hours=3)) 

print('Renaming columns.')
geo_data = geo_data[['LastReading','DateTime','TimeElapsed','MPH','SlowMoving','BreakPoint','Latitude','Longitude','Date']]
geo_data.rename(columns={'DateTime':'CurrentReading'}, inplace=True)

print('Selecting only lines that could be stops.')
stop_candidates = geo_data[geo_data['BreakPoint'] == True]
stop_candidates.reset_index(drop=True, inplace=True)

print('Reverse looking up Address from Geocodes.')
#latlon address
lat_lon = []
for lat, lon in zip(stop_candidates.Latitude.astype(str), stop_candidates.Longitude.astype(str).tolist()):
    lat_lon.append(lat + ' ,' + lon)
stop_candidates['LatLon'] = lat_lon

reverse_lookup = []
for ll in lat_lon:
    geolocator = Nominatim()
    reverse_lookup.append(geolocator.reverse(ll))

address_list = []
for r in reverse_lookup:
    a = str(r.address)
    address_list.append(a.upper())

address_list = [re.sub('UNITED STATES OF AMERICA', 'USA', a) for a in address_list]
address_list = [re.sub('MISSOURI', 'MO', a) for a in address_list]

stop_candidates['Street'] = [a.split(',')[1] for a in address_list] #[a.split(',')[0]+a.split(',')[1]+a.split(',')[2] for a in address_list]
stop_candidates['Address'] = address_list



print('Read in Roadnet data and "fuzzy match" to address.')
roadnet_data = pd.read_excel(f_path + 'Dec 9 2016 Roadnet Export Route 24 STL for comparison.xlsx', header=0, sheetname='Sheet')

LOC,ADD,CITY,STATE,ZIP = roadnet_data['Location'].astype(str), roadnet_data['Address Line 1'].astype(str), roadnet_data['City'].astype(str), 'MO', roadnet_data['Postal Code'].astype(str)
roadnet_data['Street'] = ADD
roadnet_data['ExtendedAddress'] = LOC +', '+ ADD +', '+ CITY +', '+ STATE +', '+ ZIP +', '+ 'USA'

roadnet_coordinates = roadnet_data['Coordinate'].astype(str)
lat = [r.split(',')[0] for r in roadnet_coordinates]
roadnet_data['Latitude'] = lat = [re.sub('[(]', '', l.strip()) for l in lat]

lon = [r.split(',')[-1] for r in roadnet_coordinates]
roadnet_data['Longitude'] = lon = [re.sub('[)]', '', l.strip()) for l in lon]


print('Create distance matrix between both dataframes.')
[distance(re.sub('[,()]',' ',r), re.sub('[,()]',' ',r))  for r in roadnet_coordinates]



stop_candidates.merge(roadnet_data, on='Latitude')







print('Conduct fuzzy match.')
FUZZY = difflib.Differ()
matches = list(FUZZY.compare(stop_candidates.Street, roadnet_data.Street))
pp = pprint.PrettyPrinter(indent=4)
pp.pprint(matches)



roadnet_data = roadnet_data[roadnet_data['Arrival Time'] != 'NaN']


stop_candidates
roadnet_data.head()


datetime.timestamp(dat)




geo_data.head()
geo_data.tail()



dt.time()

