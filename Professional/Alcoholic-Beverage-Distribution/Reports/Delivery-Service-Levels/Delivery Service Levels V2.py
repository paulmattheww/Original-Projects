'''
Delivery Service Level Report

This report will display a weighted service level metric based on the delivery execution of a given route.
Data is exported from Roadnet's Driver Manifest; one spreadsheet per day (saved as a CSV).
'''
import pandas as pd
import numpy as np
import glob
from datetime import datetime as dt
import re
from datetime import timedelta, time

pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 100)
pd.set_option('display.width', 200)


#WHSE = 'KC'
WHSE = input('Choose Warehouse\n\Enter 1 for KC, 2 for STL, 3 for COL, 5 for SPFD: ')
WHSE = map(WHSE, {1:'KC',2:'STL',3:'COL',5:'SPFD'})
print('''
Setting warehouse to %s
'''%WHSE)


#path = 'N:\\Operations Intelligence\\Operations Research\\Merchandising vs Operations\\*.csv'
#path = 'E:\\Driver Manifests\\'+str(WHSE)+'\\*.csv'
path = 'N:\\Operations Intelligence\\Routing\\Exports\\Roadnet Driver Manifest\\*.csv'

print('Specifying files in path:  %s' %path)
files = glob.glob(path)

def get_date_warehouse(file, warehouse):
    print('''
    Extracting Date from file:    %s
    '''%file)
    mfst = pd.read_csv(file, usecols=np.arange(0,25), names=["C"+str(i) for i in np.arange(1,26)])
    
    ## Exctract date from first column
    rte_date = re.search(r'[0-9]{8}', str(file))
    rte_date = dt.strptime(rte_date.group(), '%m%d%Y').date()
    print(rte_date)
    
    mfst['Date'] = rte_date
    mfst['Warehouse'] = warehouse
        
    return mfst, rte_date


def get_routeIDs(mfst):
    ## Extract RTE IDs
    raw_rtes = todays_rtes = mfst.loc[mfst.C1.astype(str).str.contains('Route Id: '), 'C1']
    raw_rtes = pd.DataFrame({'RouteId':raw_rtes}).reset_index(drop=False)
    
    ## String manipulations
    todays_rtes = [rte.replace('Route Id: ','') for rte in todays_rtes]
    todays_rtes = raw_rtes.RouteId = [rte.replace(' ', '') for rte in todays_rtes]
    todays_rtes = pd.unique(todays_rtes)

    return raw_rtes, todays_rtes



def get_index_of_routes(mfst, raw_rtes):
    ## Get start and end of route ID by using index from above
    minmax = pd.DataFrame(raw_rtes.groupby('RouteId')['index'].agg({'RouteId':{'min':np.min, 'max':np.max}}))
    minmax.columns = ['%s%s' % (a, '|%s' % b if b else '') for a, b in minmax.columns]
    
    df_temp = pd.DataFrame()
    for i, mm_row in minmax.iterrows():
        rte_id = str(mm_row.name)
        min_ix = int(mm_row[0])
        max_ix = int(mm_row[1])
        new_rows = {min_ix: rte_id, max_ix: rte_id}
        df = pd.DataFrame.from_dict(new_rows, orient='index')
        df.rename(columns={0:'RouteId'}, inplace=True)
        df_temp = df_temp.append(df)
        
    new_ix = pd.Index(np.arange(np.min(df_temp.index.values), np.max(df_temp.index.values)))
    df_temp = df_temp.reindex(new_ix)
    df_temp.RouteId.fillna(method='ffill', inplace=True)
    
    mfst = mfst.join(df_temp)
    mfst.RouteId.fillna(method='ffill', inplace=True)
    
    expected_rtes = pd.unique(mfst['RouteId'])
    print(expected_rtes)
    
    return mfst, expected_rtes

def make_windows(winz):
    if ',' not in str(winz):
        try:
            w1 = str(winz).split('-')[0]
            w2 = str(winz).split('-')[1]
            w3 = ''
            w4 = ''
        except IndexError:
            w1 = w2 = w3 = w4 = ''
    else:
        try:
            win1 = str(winz).split(', ')[0]
            w1 = str(win1).split('-')[0]
            w2 = str(win1).split('-')[1]
            
            win2 = str(winz).split(', ')[1]
            w3 = str(win2).split('-')[0]
            w4 = str(win2).split('-')[1]
        except IndexError:
            w1 = w2 = w3 = w4 = ''
            
    return w1, w2, w3, w4


def get_customer_features(mfst):
    ## Extract Customers -- maintain index
    raw_cust = mfst.loc[~mfst.C5.astype(str).str.contains(':'), 'C5']
    raw_cust = pd.DataFrame({'Customer':raw_cust}).reset_index(drop=False)
    
    ## String manipulations -- drop index for values
    customers = mfst.loc[~mfst.C5.astype(str).str.contains(':'), 'C5']
    customers = [c for c in customers if 'Service Windows' not in str(c) and 'na' not in str(c) 
                 and 'Location Name' not in str(c) and 'Odometer Out:' not in str(c)]
    customers = pd.unique(customers)
    
    ## Get start and end of route ID by using index from above
    minmax = pd.DataFrame(raw_cust.groupby('Customer')['index'].agg({'Customer':{'min':np.min, 'max':np.max}}))
    minmax.columns = ['%s%s' % (a, '|%s' % b if b else '') for a, b in minmax.columns]
    
    new_df = pd.DataFrame()
    for i, mm_row in minmax.iterrows():
        cust_name = mm_row.name
        IX = mm_row[1]
        winz = mfst.loc[IX+4, 'C5']
        
        w1, w2, w3, w4 = make_windows(winz)   
        new_row = {IX: {'Customer':cust_name, 'CustomerId': mfst.loc[IX, 'C3'],
                       'Stop': mfst.loc[IX, 'C2'], 'Cases': mfst.loc[IX, 'C22'],
                       'Bottles':  mfst.loc[IX, 'C25'], 'ServiceWindows': mfst.loc[IX+4, 'C5'],
                       'BeginWindow1':w1, 'EndWindow1':w2, 'BeginWindow2':w3, 'EndWindow2':w4
                       }}
        df = pd.DataFrame.from_dict(new_row, orient='index')
        new_df = new_df.append(df)
    
    print(new_df.head())
    
    mfst = mfst.join(new_df)
    
    ## Fill forward
    mfst[['Customer']].fillna(method='ffill', inplace=True)
    
    cols_for_output = ['Warehouse','Date','RouteId','Customer','CustomerId','Stop','Cases','Bottles',
                       'ServiceWindows','BeginWindow1','EndWindow1','BeginWindow2','EndWindow2']
    print(mfst[cols_for_output].head())
    
    ## Filter out some nonsense
    ISNAN = mfst['Stop'].isnull()
    mfst = mfst.loc[ISNAN == False, cols_for_output]
    BADVALS = ['Location Name']
    mfst = mfst[~mfst.Customer.isin(BADVALS)]
    
    ## Replace commas past 1000
    mfst.Cases = [s.replace(',','') for s in mfst.Cases.astype(str)]
    mfst.Bottles = [s.replace(',','') for s in mfst.Bottles.astype(str)]
    
    ## Set new index w/o dropping
    mfst.set_index(keys=['Date','Warehouse','RouteId','CustomerId'], inplace=True, drop=False)
    
    return mfst

def make_datetime(rte_date, dat):
    try:
        DAT = dt.strptime(str(str(rte_date) + ' ' + str(dat)), '%Y-%m-%d %H:%M')
    except ValueError:
        DAT = pd.NaT
    return DAT



def customer_hours_available(hrs_raw):
    hrs_raw = str(hrs_raw)
    try:
        HRS = np.float64(hrs_raw.split(':')[0]) #.split('days ')[1]
    except IndexError:
        HRS = 0
    except ValueError:
        HRS = 0
    return HRS


to_minz = lambda x: timedelta(minutes=x)


def format_datetimes(mfst, rte_date):
    ## Format as Datetime for operations
    mfst.BeginWindow1 = [make_datetime(rte_date, d) for d in mfst.BeginWindow1]
    mfst.EndWindow1 = [make_datetime(rte_date, d) for d in mfst.EndWindow1]
    mfst.BeginWindow2 = [make_datetime(rte_date, d) for d in mfst.BeginWindow2]
    mfst.EndWindow2 = [make_datetime(rte_date, d) for d in mfst.EndWindow2]
    
    ## Impute same windows if NaT
    start2 = []
    end2 = []
    for i, row in mfst.iterrows():
        if row['BeginWindow2'] == pd.NaT:
            start2.append(row['BeginWindow1'])
            end2.append(row['EndWindow1'])
        else:
            pass

    mfst.loc[mfst.BeginWindow2==pd.NaT, 'BeginWindow2'] = start2
    mfst.loc[mfst.BeginWindow2==pd.NaT, 'EndWindow2'] = end2
    
    ## Get N hours available in AM and PM
    mfst['HoursAvailableWin1'] = mfst.EndWindow1 - mfst.BeginWindow1
    mfst['HoursAvailableWin2'] = [end-begin for end,begin in zip(mfst.EndWindow2, mfst.BeginWindow2) if end != pd.NaT]
    mfst['HoursAvailableWin2'] = mfst['HoursAvailableWin2'].fillna(to_minz(0))
    
    ## Make duration into a floating point & add up total hours available
    mfst['TotalHoursAvailable'] = mfst['HoursAvailableWin1'] + mfst['HoursAvailableWin2']
    mfst['TotalHoursAvailable_Numeric'] = round(mfst.TotalHoursAvailable.dt.total_seconds() / 60 /60, 1)
    
    return mfst


def process_driver_manifest(file, WHSE=WHSE):
    '''
    Combines all functions above
    to process Roadnet driver manifest
    '''
    mfst, rte_date = get_date_warehouse(file, warehouse=WHSE)
    raw_rtes, todays_rtes = get_routeIDs(mfst)
    mfst, expected_rtes = get_index_of_routes(mfst, raw_rtes)
    mfst = get_customer_features(mfst)
    mfst = format_datetimes(mfst, rte_date)
    
    ## Check missing routes
    missing_rtes = sum([item not in expected_rtes for item in pd.unique(mfst.RouteId).tolist()])
    print('Expecting the following routes: \n')
    print(expected_rtes, '\n')
    print('There are %i missing routes after processing the data' %missing_rtes)
    
    return mfst


## Empty dataframe
MASTER_MANIFEST = pd.DataFrame()

## Call the master function on all files to get clean data
for file in files:
    df = process_driver_manifest(file)
    MASTER_MANIFEST = MASTER_MANIFEST.append(df) 

MASTER_MANIFEST.reset_index(drop=True, inplace=True)
MASTER_MANIFEST.CustomerId = MASTER_MANIFEST.CustomerId.astype(str)

## Check if processed times correctly
print('Manifest records:')
print(MASTER_MANIFEST.head())
print('-'*75)



## Get distance from DC to first stop, each stop to next stop, last stop to DC
## Start with STL, then do KC, COL, SPFD
def haversine(lon1, lat1, lon2, lat2):
    """
    Calculate the great circle distance between two points 
    on the earth (specified in decimal degrees)
    """
    from math import radians, cos, sin, asin, sqrt
    # convert decimal degrees to radians 
    lon1, lat1, lon2, lat2 = map(radians, [lon1, lat1, lon2, lat2])
    
    # haversine formula 
    dlon = lon2 - lon1 
    dlat = lat2 - lat1 
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * asin(sqrt(a)) 
    r = 3956 # Radius of earth in MILES. Use 6371 for KM
    return round(c * r, 4)
    

def roadnet_servicelocation_details(customerPath):
    '''
    Reads data from Roadnet for latlon/priority, etc.
    To be used by combining with manifest data.
    '''
    colz = ['ID','Coordinate','Service Window Importance']    
    df = pd.read_csv(customerPath, header=0, usecols=colz)  
    
    ## Process coordinates as string to derive values for geospatial
    df.Coordinate = [s.replace('(','') for s in df.Coordinate.astype(str)]
    df.Coordinate = [s.replace(')','') for s in df.Coordinate.astype(str)]
    df.Coordinate = [s.replace(' ','') for s in df.Coordinate.astype(str)]
    
    df['Latitude'] = [s.split(',')[0] for s in df.Coordinate.astype(str)]
    df['Longitude'] = [s.split(',')[1] if len(s.split(','))==2 else 0 for s in df.Coordinate.astype(str)]
    df.drop(labels='Coordinate', axis=1, inplace=True)
    
    df['ID'] = df.ID.astype(str)

    return df


## Merge with customer data
customerPath = 'N:\\Operations Intelligence\\Routing\\Exports\\Roadnet Customer Locations\\Service Locations from Roadnet '+str(WHSE)+'.csv'  
cust_data = roadnet_servicelocation_details(customerPath)
MASTER_MANIFEST = MASTER_MANIFEST.merge(cust_data, how='left', left_on='CustomerId', right_on='ID')


## Ensure latlon are floats
MASTER_MANIFEST.Latitude = MASTER_MANIFEST.Latitude.astype(np.float64)
MASTER_MANIFEST.Longitude = MASTER_MANIFEST.Longitude.astype(np.float64)

if WHSE=='STL':
    warehouseLatitude = 38.614632 
    warehouseLongitude = -90.302092
elif WHSE=='KC':
    warehouseLatitude = 39.1324261
    warehouseLongitude = -94.5739862
elif WHSE=='COL':
    warehouseLatitude = 38.9667752 
    warehouseLongitude = -92.3606889
else:
    warehouseLatitude = 37.212023  
    warehouseLongitude = -93.234867


## Split apply combine to get the distance to next stop
## handle exceptions for first and last stops
print('Calculating distance to next stop for each stop in all routes')
grp_dfs = MASTER_MANIFEST.groupby('RouteId')

dist_next = pd.DataFrame()

for rte, df in grp_dfs:
    print('''
    Operating on Route ID %s    
    ''' %(str(rte)))
    df.Stop = df.Stop.astype(int)
    df.sort_values(['Date','Stop'], inplace=True)
    print(df.head())
    
    for i, row in df.iterrows():
        try:
            dist_next.loc[i, 'Date'] = row.Date
            dist_next.loc[i, 'Rte'] = rte
            dist_next.loc[i, 'Stop'] = row.Stop
            dist_next.loc[i, 'Lon'] = row.Longitude            
            dist_next.loc[i, 'Lat'] = row.Latitude
            
            if row.Stop < df.loc[i+1, 'Stop']:
                mi = haversine(lon1=row.Longitude, lat1=row.Latitude,
                               lon2=df.loc[i+1, 'Longitude'], lat2=df.loc[i+1, 'Latitude'])
                print(row)
            else:
                mi = haversine(lon1=row.Longitude, lat1=row.Latitude, 
                               lon2=warehouseLongitude, lat2=warehouseLatitude) 
                
            dist_next.loc[i, 'AirMilesNextStop'] = mi
        except KeyError:
            dist_next.loc[i, 'Date'] = row.Date 
            dist_next.loc[i, 'Rte'] = rte
            dist_next.loc[i, 'Stop'] = row.Stop
            dist_next.loc[i, 'Lon'] = row.Longitude            
            dist_next.loc[i, 'Lat'] = row.Latitude
            dist_next.loc[i, 'AirMilesNextStop'] = np.nan
            pass
            
MISSING_DISTANCES = dist_next.AirMilesNextStop.isnull()==True
dist_next.loc[MISSING_DISTANCES, 'AirMilesNextStop'] = [haversine(lon, lat, warehouseLongitude, warehouseLatitude) for lon,lat in zip(dist_next.loc[MISSING_DISTANCES, 'Lon'], dist_next.loc[MISSING_DISTANCES, 'Lat'])]

   
dist_next.Stop.fillna(0, inplace=True)
dist_next.Stop = dist_next.Stop.astype(int)
dist_next['ix'] = dist_next.Date.astype(str) + ' ' + dist_next.Rte.astype(str) + ' ' + dist_next.Stop.astype(str)
distance_map = dict(zip(dist_next['ix'], dist_next.AirMilesNextStop))

MASTER_MANIFEST['AirMilesNextStop'] = MASTER_MANIFEST.Date.astype(str) + ' ' + MASTER_MANIFEST.RouteId.astype(str) + ' ' + MASTER_MANIFEST.Stop.astype(str)
MASTER_MANIFEST['AirMilesNextStop'] = MASTER_MANIFEST['AirMilesNextStop'].map(distance_map)

miles_per_hr = 35
hrs_per_mile = 1/miles_per_hr
min_per_mile = hrs_per_mile*60


print('-'*75)
print('''

ASSUMING %i MPH AVERAGE SPEED

'''%miles_per_hr)
print('-'*75)

## Getting route start times from first stop
print('Getting Route start times from first stop, distance to first stop, and time to travel there')
RTE_START_TIMES = MASTER_MANIFEST.loc[MASTER_MANIFEST.Stop == '1', ['Date','RouteId','BeginWindow1']]
RTE_START_TIMES.rename(columns={'BeginWindow1':'RouteStartTime'}, inplace=True)

FIRSTSTOP_LATLON = MASTER_MANIFEST.loc[MASTER_MANIFEST.Stop == '1', ['Date','RouteId','Latitude','Longitude']]
FIRSTSTOP_LATLON.rename(columns={'Latitude':'Lat_Stop1','Longitude':'Lon_Stop1'}, inplace=True)

MASTER_MANIFEST = MASTER_MANIFEST.merge(RTE_START_TIMES, on=['Date','RouteId'], how='left')
MASTER_MANIFEST = MASTER_MANIFEST.merge(FIRSTSTOP_LATLON, on=['Date','RouteId'], how='left')

## Calculate time to next stop i+1 from i
to_minz = lambda x: timedelta(minutes=x)
to_hrz = lambda x: timedelta(hours=x)
MASTER_MANIFEST['MinutesNextStop'] = np.multiply(MASTER_MANIFEST.AirMilesNextStop, min_per_mile)
MASTER_MANIFEST['MinutesNextStop'].fillna(0, inplace=True)
MASTER_MANIFEST['MinutesNextStop'] = MASTER_MANIFEST['MinutesNextStop'].apply(to_minz) + to_minz(2) #2 min to startup/shutoff


## Get heuristic of cases per minute by route
## Then use it by route  -- doesnt exist before this point so think it through bro
curr_minpercase = 1/3

print('-'*75)
print('''
CONVERTING BOTTLES TO CASES USING 
    Bottles per Case  =  %i
    
ASSUMING MINUTES PER CASE DELIVERED
    Minutes per Case  =  %.2f
'''%(12,curr_minpercase))
print('-'*75)

## Calculate time at each stop
def duration_at_stop(cases, btls, baseline_minutes=8, min_per_case=curr_minpercase):
    '''Calculates time at a stop'''
    cases, btls = str(cases).replace(',',''), str(btls).replace(',','')
    fulls = np.float64(cases) + (np.float64(btls)/12)
    duration_estimate = baseline_minutes + fulls*min_per_case
    duration_estimate = to_minz(duration_estimate)
    return duration_estimate


def processStopTimes(MASTER_MANIFEST):
    MASTER_MANIFEST['MinutesServiceStop'] = [duration_at_stop(cs,btl) for cs,btl in zip(MASTER_MANIFEST.Cases, MASTER_MANIFEST.Bottles)]
    MASTER_MANIFEST['Splits'] = MASTER_MANIFEST.Cases.astype(np.float64) + MASTER_MANIFEST.Bottles.astype(np.float64)/12
    
    ## Calculate distance from warehouse for first stops only
    FIRSTSTOPS = zip(MASTER_MANIFEST.loc[MASTER_MANIFEST.Stop=='1', 'Lon_Stop1'], MASTER_MANIFEST.loc[MASTER_MANIFEST.Stop=='1', 'Lat_Stop1'])
    MASTER_MANIFEST.loc[MASTER_MANIFEST.Stop=='1', 'DistanceFromWarehouse_Stop1'] = [haversine(stop1_lon, stop1_lat, warehouseLongitude, warehouseLatitude) for stop1_lon, stop1_lat in FIRSTSTOPS]
    
    def get_minutes_permile(mph):
        hpm = 1/mph
        mpm = hpm*60
        return mpm
    
    PREROUTE_TIME = 5
    
    print('-'*75)
    print('''
    Adding %i minutes of pre-route time to first stop.
    ''' %PREROUTE_TIME)
    print('-'*75)
    
    print('Getting time to first stop')
    MASTER_MANIFEST['MinutesToFirstStop'] = np.multiply(MASTER_MANIFEST.DistanceFromWarehouse_Stop1, get_minutes_permile(mph=40)) 
    MASTER_MANIFEST['MinutesToFirstStop'].fillna(0, inplace=True)
    MASTER_MANIFEST['MinutesToFirstStop'] = MASTER_MANIFEST['MinutesToFirstStop'].apply(to_minz) + to_minz(PREROUTE_TIME)
    
    ## Add up by rows using all times relevant
    MASTER_MANIFEST['MinutesTotal'] = MASTER_MANIFEST[['MinutesServiceStop','MinutesNextStop','MinutesToFirstStop']].sum(axis=1)
    MASTER_MANIFEST['MinutesTotalNumeric'] = round(MASTER_MANIFEST['MinutesTotal'].dt.total_seconds() / 60,1)
    MASTER_MANIFEST['MinutesCumulativeRoute'] = pd.Series(MASTER_MANIFEST.groupby(['Date','RouteId'])['MinutesTotalNumeric'].cumsum())
    MASTER_MANIFEST['HoursCumulativeRoute'] = round(np.divide(MASTER_MANIFEST['MinutesCumulativeRoute'],60),2)
    
    ## Mark if service window was met or not
    MASTER_MANIFEST.MinutesToFirstStop.fillna(method='ffill', inplace=True)
    MASTER_MANIFEST.RouteStartTime = UNADJUSTED_START = np.subtract(MASTER_MANIFEST.RouteStartTime, MASTER_MANIFEST.MinutesToFirstStop)
    MASTER_MANIFEST.RouteStartTime = [TIME if TIME.hour >= 4 else TIME.replace(hour=4,minute=0) for TIME in UNADJUSTED_START]
    
    #min([TIME if TIME.hour >= 4 else TIME.replace(hour=4,minute=0) for TIME in UNADJUSTED_START])
    
    MASTER_MANIFEST.loc[MASTER_MANIFEST.Stop!='1', 'RouteStartTime'] = pd.NaT
    MASTER_MANIFEST.loc[MASTER_MANIFEST.Stop!='1', 'MinutesToFirstStop'] = to_minz(0)
    
    ## Get estimated arrival time
    START_FIRSTSTOP = zip(MASTER_MANIFEST.RouteStartTime, MASTER_MANIFEST.MinutesToFirstStop)
    MASTER_MANIFEST['ExpectedArrival'] = [start+firststop for start,firststop in START_FIRSTSTOP]
    
    i = int(0)
    while i < int(MASTER_MANIFEST.shape[0]-1):
        if MASTER_MANIFEST.loc[i+1, 'Stop'] == '1':
            MASTER_MANIFEST.loc[i+1, 'ExpectedArrival'] = MASTER_MANIFEST.loc[i+1, 'BeginWindow1']
            i += 1
        else:
            MASTER_MANIFEST.loc[i+1, 'ExpectedArrival'] = MASTER_MANIFEST.loc[i, 'ExpectedArrival'] + MASTER_MANIFEST.loc[i, 'MinutesTotal']
            i += 1
    
    return MASTER_MANIFEST

MASTER_MANIFEST = processStopTimes(MASTER_MANIFEST)

print('-'*75)
print('Break Point -- Come back to line 472 to restore without running whole program.')
PLACEHOLDER = MASTER_MANIFEST.copy()
print('-'*75)


def emptyTravelTime(MASTER_MANIFEST):
    ## Get empty distance (going back to warehouse)
    print('Changing Stop to Integer from String')
    MASTER_MANIFEST.Stop = MASTER_MANIFEST.Stop.astype(np.int64)
    LAST = MASTER_MANIFEST.Stop > MASTER_MANIFEST.Stop.shift()
    NEXT = MASTER_MANIFEST.Stop > MASTER_MANIFEST.Stop.shift(-1)
    MASTER_MANIFEST['LastStop'] = ISLAST = LAST & NEXT
    last_lon, last_lat = MASTER_MANIFEST.loc[ISLAST, 'Longitude'], MASTER_MANIFEST.loc[ISLAST, 'Latitude']
    
    
    MASTER_MANIFEST.loc[ISLAST, 'DistanceToWarehouse_LastStop'] = [haversine(LON,LAT,warehouseLongitude,warehouseLatitude) for LON,LAT in zip(last_lon, last_lat)]
    MASTER_MANIFEST.loc[ISLAST, 'MinutesReturnToWarehouse'] = np.multiply(MASTER_MANIFEST.loc[ISLAST, 'DistanceToWarehouse_LastStop'], get_minutes_permile(mph=40)) 
    MASTER_MANIFEST['MinutesReturnToWarehouse'].fillna(0, inplace=True)
    MASTER_MANIFEST['MinutesReturnToWarehouse'] = MASTER_MANIFEST['MinutesReturnToWarehouse'].apply(to_minz)
    
    ## Get expected arrival back to whse
    last_stops = MASTER_MANIFEST.loc[ISLAST, ['MinutesTotal','MinutesReturnToWarehouse','ExpectedArrival']]#.sum(axis=1)
    last_stops.MinutesReturnToWarehouse.fillna(to_minz(0), inplace=True)
    last_stops.ExpectedArrival.fillna(last_stops.ExpectedArrival.shift(-1)+to_minz(20), inplace=True)
    last_stops.MinutesTotal = MASTER_MANIFEST.loc[ISLAST, 'MinutesTotal'] = last_stops[['MinutesTotal','MinutesReturnToWarehouse']].sum(axis=1)
    
    ## Empty travel time
    FINAL_STOP = zip(MASTER_MANIFEST['ExpectedArrival'], MASTER_MANIFEST['MinutesTotal'])
    MASTER_MANIFEST['ExpectedFinishTime'] = [laststop_arrival+total_min for laststop_arrival,total_min in FINAL_STOP]
    MASTER_MANIFEST.loc[ISLAST==False, 'ExpectedFinishTime'] = pd.NaT
    MASTER_MANIFEST.ExpectedFinishTime = MASTER_MANIFEST.groupby(['Date','RouteId']).ExpectedFinishTime.fillna(method='bfill')
    
    ## Tidy up data
    zero_out_microseconds = lambda dtobject: dtobject.replace(microsecond=0, second=0)
    MASTER_MANIFEST.ExpectedArrival = MASTER_MANIFEST.ExpectedArrival.apply(zero_out_microseconds)
    MASTER_MANIFEST.RouteStartTime = MASTER_MANIFEST.RouteStartTime.apply(zero_out_microseconds)
    MASTER_MANIFEST.ExpectedFinishTime = MASTER_MANIFEST.ExpectedFinishTime.apply(zero_out_microseconds)

    return MASTER_MANIFEST

MASTER_MANIFEST = emptyTravelTime(MASTER_MANIFEST)



def get_stops(MASTER_MANIFEST):
    ## Number of stops on route    
    NSTOPS = pd.DataFrame(MASTER_MANIFEST.groupby(['Date','RouteId'])['Stop'].max()).reset_index(drop=False)
    NSTOPS['x'] = [str(a) + str(b) for a,b in zip(NSTOPS.Date, NSTOPS.RouteId)]
    NSTOPS.rename(columns={'Stop':'Stops'}, inplace=True)
    NSTOPS = dict(zip(NSTOPS.x, NSTOPS.Stops))
    MASTER_MANIFEST['Stops'] = [str(a) + str(b) for a,b in zip(MASTER_MANIFEST.Date, MASTER_MANIFEST.RouteId)]
    MASTER_MANIFEST['Stops'] = MASTER_MANIFEST['Stops'].map(NSTOPS)
    return MASTER_MANIFEST

MASTER_MANIFEST = get_stops(MASTER_MANIFEST)



def get_splits(MASTER_MANIFEST):
    NSPLITS = pd.DataFrame(MASTER_MANIFEST.groupby(['Date','RouteId'])['Splits'].sum()).reset_index(drop=False)
    NSPLITS['x'] = [str(a) + str(b) for a,b in zip(NSPLITS.Date, NSPLITS.RouteId)]
    NSPLITS.rename(columns={'Splits':'TotalSplits'}, inplace=True)
    NSPLITS = dict(zip(NSPLITS.x, NSPLITS.TotalSplits))
    MASTER_MANIFEST['TotalSplits'] = [str(a) + str(b) for a,b in zip(MASTER_MANIFEST.Date, MASTER_MANIFEST.RouteId)]
    MASTER_MANIFEST['TotalSplits'] = MASTER_MANIFEST['TotalSplits'].map(NSPLITS)
    return MASTER_MANIFEST

MASTER_MANIFEST = get_splits(MASTER_MANIFEST)



def get_time(MASTER_MANIFEST):
    MM = MASTER_MANIFEST.copy()
    SERVICE_T = pd.DataFrame(MM.groupby(['Date','RouteId'])['MinutesServiceStop'].sum()).reset_index(drop=False)
    SERVICE_T['x'] = [str(a) + str(b) for a,b in zip(SERVICE_T.Date, SERVICE_T.RouteId)]
    SERVICE_T.rename(columns={'MinutesServiceStop':'TotalServiceTime'}, inplace=True)
    SERVICE_T = dict(zip(SERVICE_T.x, SERVICE_T.TotalServiceTime))
    MM['TotalServiceTime'] = [str(a) + str(b) for a,b in zip(MM.Date, MM.RouteId)]
    MM['TotalServiceTime'] = MM['TotalServiceTime'].map(SERVICE_T)
    
    TRAVEL_T = pd.DataFrame(MM.groupby(['Date','RouteId'])['MinutesNextStop'].sum()).reset_index(drop=False)
    TRAVEL_T['x'] = [str(a) + str(b) for a,b in zip(TRAVEL_T.Date, TRAVEL_T.RouteId)]
    TRAVEL_T.rename(columns={'MinutesNextStop':'TotalTravelTime'}, inplace=True)
    TRAVEL_T = dict(zip(TRAVEL_T.x, TRAVEL_T.TotalTravelTime))
    MM['TotalTravelTime'] = [str(a) + str(b) for a,b in zip(MM.Date, MM.RouteId)]
    MM['TotalTravelTime'] = MM['TotalTravelTime'].map(TRAVEL_T)
    return MM

MASTER_MANIFEST = get_time(MASTER_MANIFEST)




## Mark if a given stop was made on time
def made_time_windows(MASTER_MANIFEST):
    MM = MASTER_MANIFEST.copy()
    
    made_either_window = []
    made_window1 = []
    made_window2 = []    
    for i, ARRIVE in enumerate(MM.ExpectedArrival):
        madeit1 = (ARRIVE >= MM.loc[i, 'BeginWindow1']) & (ARRIVE <= MM.loc[i, 'EndWindow1'])
        made_window1.append(madeit1)
        try:
            madeit2 = (ARRIVE >= MM.loc[i, 'BeginWindow2']) & (ARRIVE <= MM.loc[i, 'EndWindow2'])
            made_window2.append(madeit2)
        except ValueError:
            made_window2.append(False)
        
        made_either_window.append(madeit1 | madeit2)
    return pd.Series(made_either_window)


print('Checking to see if time windows were made')        
MASTER_MANIFEST['OnTime'] = made_time_windows(MASTER_MANIFEST)




## Derive percent each stop takes of total route by various measures
def percent_of_route(MASTER_MANIFEST):
    MM = MASTER_MANIFEST.copy()
    MM['Pct_Splits'] = np.divide(MM.Splits, MM.TotalSplits)
    MM['Pct_Service'] = np.divide(MM.MinutesServiceStop, MM.TotalServiceTime)
    MM['Pct_Stops'] = np.divide(1, MM.Stops.fillna(method='ffill'))
    return MM


print('Deriving Service Levels')
MASTER_MANIFEST = percent_of_route(MASTER_MANIFEST)
MASTER_MANIFEST['OnTime_Weighted'] = np.multiply(MASTER_MANIFEST['OnTime'].astype(np.int64), MASTER_MANIFEST['Pct_Splits'])


## Break out city name from route ID
first_element = lambda x: str(x).split('-')[0]

MASTER_MANIFEST['RouteIdentifier'] = MASTER_MANIFEST.RouteId.apply(first_element)


def get_service_levels(MASTER_MANIFEST):
    ontime_weighted = pd.DataFrame(MASTER_MANIFEST.groupby(['Date','RouteId']).OnTime_Weighted.sum())
    ontime_raw = pd.DataFrame(np.divide(MASTER_MANIFEST.groupby(['Date','RouteId']).OnTime.sum(), MASTER_MANIFEST.groupby(['Date','RouteId']).OnTime.count()))
    ontime_summary = ontime_weighted.join(ontime_raw)
    ontime_summary.reset_index(drop=False, inplace=True)
    ontime_summary.rename(columns={'OnTime_Weighted':'OnTime_Weighted_RteDate', 'OnTime':'OnTime_RteDate'}, inplace=True)
    
    MASTER_MANIFEST = MASTER_MANIFEST.merge(ontime_summary, on=['Date','RouteId'])
    return MASTER_MANIFEST

MASTER_MANIFEST = get_service_levels(MASTER_MANIFEST)





def generate_calendar(year):
    from pandas.tseries.offsets import YearEnd
    from pandas.tseries.holiday import USFederalHolidayCalendar
    
    start_date = pd.to_datetime('1/1/'+str(year))
    end_date = start_date + YearEnd()
    DAT = pd.date_range(str(start_date), str(end_date), freq='D')
    WK = [d.strftime('%U') for d in DAT]
    MO = [d.strftime('%B') for d in DAT]
    holidays = USFederalHolidayCalendar().holidays(start=start_date, end=end_date)

    DAYZ = pd.DataFrame({'Date':DAT, 'WeekNumber':WK, 'Month':MO})
    
    DAYZ['Year'] = [format(d, '%Y') for d in DAT]
    DAYZ['Weekday'] = [format(d, '%A') for d in DAT]
    DAYZ['DOTM'] = [format(d, '%d') for d in DAT]
    DAYZ['IsWeekday'] = DAYZ.Weekday.isin(['Monday','Tuesday','Wednesday','Thursday','Friday'])
    DAYZ['IsProductionDay'] = DAYZ.Weekday.isin(['Tuesday','Wednesday','Thursday','Friday'])
    last_biz_day = [str(format(dat, '%Y-%m-%d')) for dat in pd.date_range(start_date, end_date, freq='BM')]
    DAYZ['LastSellingDayOfMonth'] = [dat in last_biz_day for dat in DAYZ['Date'].astype(str)]

    DAYZ.loc[DAYZ.WeekNumber.isin(['00','01','02','03','04','05','06','07','08','09','50','51','52','53']), 'Season'] = 'Winter'
    DAYZ.loc[DAYZ.WeekNumber.isin(['10','11','12','13','14','15','16','17','18','19','20','21','22']), 'Season'] = 'Spring'
    DAYZ.loc[DAYZ.WeekNumber.isin(['23','24','25','26','27','28','29','30','31','32','33','34','35']), 'Season'] = 'Summer'
    DAYZ.loc[DAYZ.WeekNumber.isin(['36','37','38','39','40','41','42','43','44','45','46','47','48','49']), 'Season'] = 'Autumn'
    DAYZ['Holiday'] = DAYZ.Date.isin(holidays)
    DAYZ['HolidayWeek'] = DAYZ['Holiday'].rolling(window=7,center=True,min_periods=1).sum()
    DAYZ['ShipWeek'] = ['A' if int(wk) % 2 == 0 else 'B' for wk in WK]

    DAYZ.reset_index(drop=True, inplace=True)
    
    return DAYZ

if dt.now().month == 1:
    last_mon = 12
else:
    last_mon = dt.now().month
report_month = dt.now().replace(month=last_mon).strftime('%B')
if dt.now().month == 1:
    report_year = dt.now().year - 1
else:
    report_year = dt.now().year

CALENDAR = generate_calendar(year=report_year)
MASTER_MANIFEST.Date = MASTER_MANIFEST.Date.apply(pd.to_datetime)
print('Merging in calendar with dates and holidays, etc.')
MASTER_MANIFEST = MASTER_MANIFEST.merge(CALENDAR, on='Date', how='left')


mpg = 6.6
cost_per_gallon = 2.171


print('-'*75)
print('''
Deriving cost per stop for:
    - Labor
    - Vehicle

Assuming MPG .............................. %.2f
Assuming $/gallon .............................. %.2f

Data acquired from US DOE.

NOTE THAT FIXED COSTS, OR THE COST OF TRUCK LEASES, WERE NOT INCLUDED IN THIS COST EQUATION
''' %(mpg, cost_per_gallon) )
print('-'*75)


def laborcost_bystop(cases, costperstop=0.70, paypercase=0.2288):
    stop_cost = costperstop + paypercase * cases
    return stop_cost
    
def travelcost_bystop(miles_nextstop, mpg=mpg, cpg=cost_per_gallon):
    cost_per_mile = (1/mpg)*cost_per_gallon
    travel_cost_nextstop = miles_nextstop*cost_per_mile
    return travel_cost_nextstop


print('Deriving travel cost based on distance and MPG')
MASTER_MANIFEST['Stop_TotalDistance'] = MASTER_MANIFEST[['AirMilesNextStop','DistanceFromWarehouse_Stop1','DistanceToWarehouse_LastStop']].sum(axis=1)
MASTER_MANIFEST['CostStop_Labor'] = MASTER_MANIFEST.Splits.apply(laborcost_bystop)
MASTER_MANIFEST['CostStop_Travel'] = MASTER_MANIFEST.Stop_TotalDistance.apply(travelcost_bystop)
MASTER_MANIFEST['CostStop_Total'] = MASTER_MANIFEST[['CostStop_Labor','CostStop_Travel']].sum(axis=1)


print('-'*75)
print('''
Deriving total cost of the route. 

Note that fixed costs are NOT included as they are not relevant 
to decisions in the short-term (they are leases already signed).
''')
print('-'*75)




def get_route_totalcost(MASTER_MANIFEST):
    MM = MASTER_MANIFEST.copy()
    TOT_COST = pd.DataFrame(MM.groupby(['Date','RouteId'])['CostStop_Total'].sum()).reset_index(drop=False)
    TOT_COST['x'] = [str(a) + str(b) for a,b in zip(TOT_COST.Date, TOT_COST.RouteId)]
    TOT_COST.rename(columns={'CostStop_Total':'TotalCostRoute'}, inplace=True)
    TOT_COST = dict(zip(TOT_COST.x, TOT_COST.TotalCostRoute))
    MM['TotalCostRoute'] = [str(a) + str(b) for a,b in zip(MM.Date, MM.RouteId)]
    MM['TotalCostRoute'] = MM['TotalCostRoute'].map(TOT_COST)
    return MM


print('Deriving Route total cost')
MASTER_MANIFEST = get_route_totalcost(MASTER_MANIFEST)

MASTER_MANIFEST['RouteIdentifierWeekdayAgnostic'] = MASTER_MANIFEST.RouteIdentifier.apply(lambda x: str(x)[-3:])
MASTER_MANIFEST['ShagRoute'] = MASTER_MANIFEST.RouteIdentifier.apply(lambda x: str(x)[:1] == 'X')

if WHSE in ['STL','COL']:
    MASTER_MANIFEST['CrossdockRoute'] = MASTER_MANIFEST['RouteIdentifierWeekdayAgnostic'].apply(lambda x: str(x).startswith('4'))
else:
    MASTER_MANIFEST['CrossdockRoute'] = MASTER_MANIFEST['RouteIdentifierWeekdayAgnostic'].apply(lambda x: str(x).startswith('5'))



## Write to csv for R report
print('-'*75)
print('Data being written to CSV for pick-back-up with R report in RMarkdown')
MASTER_MANIFEST.to_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Delivery Service Level/Roadnet Driver Manifest - Processed and Enriched.csv', index=False)
print('-'*75)





MASTER_MANIFEST.head(3)
agg_funcs = {'OnTime_Weighted_RteDate':np.max, 
             'OnTime_RteDate':np.max, 
             'Stops':len,
             'TotalSplits':np.max,
             'HoursCumulativeRoute':np.max,
             'OnTime':np.sum,
             'CostStop_Total':np.sum,
             'Stop_TotalDistance':np.sum}

BYDAY_BYRTE = pd.DataFrame(MASTER_MANIFEST.groupby(['Date','RouteIdentifier','RouteId','RouteIdentifierWeekdayAgnostic','ShagRoute','CrossdockRoute']).agg(agg_funcs)).reset_index(drop=False)
BYDAY_BYRTE.head(50)





## Get Route start times for next day
def get_route_starts(MASTER_MANIFEST):
    colz_for_display = ['Date','RouteId','Customer','ServiceWindows','RouteStartTime','MinutesToFirstStop','TotalSplits','Stops','ExpectedFinishTime']
    rte_starttimes = MASTER_MANIFEST[colz_for_display].drop_duplicates(subset=['Date','RouteId'])
    rte_starttimes.RouteStartTime = rte_starttimes.RouteStartTime.dt.strftime('%H:%M %p')
    rte_starttimes.ExpectedFinishTime = rte_starttimes.ExpectedFinishTime.dt.strftime('%I:%M %p')    
    rte_starttimes.set_index(['Date','RouteId'], inplace=True, drop=True)
    rte_starttimes.MinutesToFirstStop = round(rte_starttimes.MinutesToFirstStop.dt.total_seconds()/60,1)
    rte_starttimes.drop('MinutesToFirstStop', axis=1, inplace=True)
    rte_starttimes.TotalSplits = rte_starttimes.TotalSplits.apply(lambda x: round(x, 2))
    rte_starttimes['ExpectedHours'] = [pd.to_datetime(end) - pd.to_datetime(start) for end,start in zip(rte_starttimes.ExpectedFinishTime, rte_starttimes.RouteStartTime)]
    return rte_starttimes


print('Deriving route start times')
rte_starttimes = get_route_starts(MASTER_MANIFEST)
rte_starttimes.head(20)

print('Writing driver start times to file for distribution')
import time
chainReportColumns = ['RouteId','Customer','Stop','Splits','TotalSplits','TotalTravelTime','TotalServiceTime','ServiceWindows']
today_date = str(time.strftime('%A %B %d-%Y'))
rte_starttimes.to_html("N:/Operations Intelligence/Merchandising/Chain Reports/Driver Start Times " + today_date + ' ' + WHSE + ".html")
MASTER_MANIFEST[chainReportColumns].to_html("N:/Operations Intelligence/Merchandising/Chain Reports/Chain Report" + today_date + ' ' + WHSE + ' ' +  ".html")


print('GET MERCHANDISED ACCOUNTS, MERGE IN THEN FILTER OUT OTHERS, CREATE NEW CHAIN REPORT')
#MASTER_MANIFEST.to_excel("N:/Operations Intelligence/Merchandising/Chain Reports/" + today_date + " Saint Louis Chain Report.xlsx", sheet_name='Routes')

















#####################  #######################  #####################  #######################
#####################  #######################  #####################  #######################
#####################  ####################### KNOWN BUGS  #####################  #######################
#####################  #######################  #####################  #######################
#####################  #######################  #####################  #######################

# 1 Customers that have two time windows (4 times) are not processed correctly




## works for saving in case fuck up
#for rte, df in grp_dfs:
#    print('''
#    Operating on Route ID %s    
#    ''' %(str(rte)))
#    df.Stop = df.Stop.astype(int)
#    df.sort_values(['Date','Stop'], inplace=True)
#    print(df.head())
#    
#    NEXT_STOP = 2
#    for i, row in df.iterrows():
#        try:
#            dist_next.loc[i, 'Date'] = row.Date
#            dist_next.loc[i, 'Rte'] = rte
#            dist_next.loc[i, 'Stop'] = row.Stop
#            
#            if i < max(df.index.values) :
#                mi = haversine(lon1=row.Longitude, lat1=row.Latitude,
#                               lon2=df.loc[i+1, 'Longitude'], lat2=df.loc[i+1, 'Latitude'])
#                print(row)
#                print('\n\n', df[df.Stop == NEXT_STOP])
#                NEXT_STOP += 1
#            elif row.Stop > df.loc[i+1, 'Stop']:
#                mi = haversine(lon1=row.Longitude, lat1=row.Latitude, 
#                               lon2=warehouseLongitude, lat2=warehouseLatitude)
#                NEXT_STOP = 1
#            else:
#                ## multiply by two to get dist first dist last
#                mi = haversine(lon1=row.Longitude, lat1=row.Latitude, 
#                               lon2=warehouseLongitude, lat2=warehouseLatitude) * 2 
#                NEXT_STOP = 1
#                
#            dist_next.loc[i, 'AirMilesNextStop'] = mi
#        except KeyError:
#            dist_next.loc[i, 'Date'] = row.Date 
#            dist_next.loc[i, 'Rte'] = rte
#            dist_next.loc[i, 'Stop'] = np.nan
#            dist_next.loc[i, 'AirMilesNextStop'] = np.nan
#            pass

#####################  #######################  #####################  #######################
#####################  #######################  #####################  #######################
#####################  ####################### KNOWN BUGS  #####################  #######################
#####################  #######################  #####################  #######################
#####################  #######################  #####################  #######################

# print('''
# Check which accounts are merchandised
# ''')
# merch_path = 'N:/Operations Intelligence/Operations Research/Merchandising vs Operations/Merchandising Data/ALL MERCHANDISED ACCOUNT SCHEDULES.csv'
# USE_THESE = ['Store ID','Store','Address','City','Phone','Mon','Tue','Wed','Thu','Fri','Sat','Sun','Total Merchandising Visits per Week',
#             'T','W','R','F','Total Deliveries per Week']
# merch_accts = pd.read_csv(merch_path, header=0, usecols=USE_THESE)
# merch_accts['Store ID'].fillna(0, inplace=True)
# merch_accts['Store ID'] = merch_accts['Store ID'].astype(int) 
# merch_accts.head()



### Merge accounts with driver manifest
#MASTER_MANIFEST.CustomerId = MASTER_MANIFEST.CustomerId.astype(int)
#MASTER_MANIFEST = MASTER_MANIFEST.merge(merch_accts, how='left', left_on='CustomerId', right_on='Store ID')
##MASTER_MANIFEST['Store ID'] = MASTER_MANIFEST['Store ID'].isnull() == False
#MASTER_MANIFEST.rename(columns={'Store ID':'Merchandised Account'}, inplace=True)
#MASTER_MANIFEST.head(10)
#
#
#
##MERCH_MANIFEST = MASTER_MANIFEST[MASTER_MANIFEST['Merchandised Account'] == True]
#MERCH_MANIFEST.reset_index(drop=False, inplace=True)
#keep_cols = ['RouteId','CustomerId','Customer','Stop','Cases','Bottles','ServiceWindows','TotalHoursAvailable']
#MERCH_MANIFEST = MERCH_MANIFEST[keep_cols]
#MERCH_MANIFEST.set_index(keys=['RouteId','CustomerId'], drop=True, inplace=True)
#MERCH_MANIFEST.head(20)
#
#
#import time
#today_date = str(time.strftime('%A %B %d-%Y'))
#MERCH_MANIFEST.to_html("N:/Operations Intelligence/Merchandising/Chain Reports/" + today_date + " Saint Louis Chain Report.html")
#MERCH_MANIFEST.to_excel("N:/Operations Intelligence/Merchandising/Chain Reports/" + today_date + " Saint Louis Chain Report.xlsx", sheet_name='Routes')





# ## Test pdf generator
# import fpdf as pyfpdf
 
# pdf = pyfpdf.FPDF(format='letter')
# pdf.add_page()
# pdf.set_font("Arial", size=12)
# pdf.cell(200, 10, txt="Welcome to Python!", align="C")
# pdf.output("C:/Users/pmwash/Desktop/Disposable Docs/tutorial.pdf")








