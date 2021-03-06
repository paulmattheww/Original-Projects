'''
Chain Report V2
Process Roadnet Driver Manifest
Process Merchandising Schedules
Combine the two
Highlight overlaps of times
Distribute
'''


import pandas as pd
import numpy as np
import glob
from datetime import datetime as dt
import csv
from dateutil.parser import parse
import re

pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 50)
pd.set_option('display.width', 100)

# path = 'N:\\Operations Intelligence\\Operations Research\\Merchandising vs Operations\\*.csv'
# files = glob.glob(path)

def get_date_warehouse(file):
    print(file)
    mfst = pd.read_csv(file, usecols=np.arange(0,25), names=["C"+str(i) for i in np.arange(1,26)])
    
    ## Exctract date from first column
    rte_date = re.search(r'[0-9]{8}', str(file))
    rte_date = dt.strptime(rte_date.group(), '%m%d%Y').date()
    print(rte_date)
    
    mfst['Date'] = rte_date
    if re.search("STL", file).group(0) == 'STL':
        mfst['Warehouse'] = 'STL'
    elif re.search("KC", file).group(0) == 'KC':
        mfst['Warehouse'] = 'KC'
    elif re.search("COL", file).group(0) == 'COL':
        mfst['Warehouse'] = 'COL'
    else:
        mfst['Warehouse'] = 'SPFD'
        
    return mfst, rte_date

# mfst, rte_date = get_date_warehouse(files)
# mfst.head()




def get_routeIDs(mfst):
    ## Extract RTE IDs
    raw_rtes = todays_rtes = mfst.loc[mfst.C1.astype(str).str.contains('Route Id: '), 'C1']
    raw_rtes = pd.DataFrame({'RouteId':raw_rtes}).reset_index(drop=False)
    
    ## String manipulations
    todays_rtes = [rte.replace('Route Id: ','') for rte in todays_rtes]
    todays_rtes = raw_rtes.RouteId = [rte.replace(' ', '') for rte in todays_rtes]
    todays_rtes = pd.unique(todays_rtes)
    
    print('Raw route values : \n', raw_rtes.head(10))
    print('Processed route values: \n', todays_rtes)
    return raw_rtes, todays_rtes

# raw_rtes, todays_rtes = get_routeIDs(mfst)


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
    print(df_temp.head(), '\n\n', df_temp.tail())
    
    mfst = mfst.join(df_temp)
    mfst.RouteId.fillna(method='ffill', inplace=True)
    
    expected_rtes = pd.unique(mfst['RouteId'])
    print(expected_rtes)
    
    return mfst, expected_rtes



# mfst, expected_rtes = get_index_of_routes(mfst, raw_rtes)



## for future, SPFD has 3 cust who have colons
spfd_colon_custs = [5007745,5007746,5007747]


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
    
    print(minmax.head())
    def make_windows(winz):
        if ',' not in str(winz):
            try:
                w1 = str(winz).split('-')[0]
                w2 = str(winz).split('-')[1]
                w3 = np.nan
                w4 = np.nan
            except IndexError:
                w1 = w2 = w3 = w4 = np.nan
        else:
            try:
                w1 = str(winz).split('-')[0]
                w2 = str(winz).split('-')[1]
                new_winz = str(winz).split(',') 
                new_winz = new_winz[1]
                w3 = str(winz).split('-')[0]
                w4 = str(winz).split('-')[1]
            except IndexError:
                w1 = w2 = w3 = w4 = np.nan
                
        return w1, w2, w3, w4
    
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
    
    ## Set new index w/o dropping
    mfst.set_index(keys=['Date','Warehouse','RouteId','CustomerId'], inplace=True, drop=False)
    
    return mfst


# mfst = get_customer_features(mfst)




## Create datetime objects 
def make_datetime(rte_date, dat):
    try:
        DAT = dt.strptime(str(str(rte_date) + ' ' + str(dat)), '%Y-%m-%d %H:%M')
    except ValueError:
        DAT = pd.NaT
    return DAT
    
def customer_hours_available(hrs_raw):
    try:
        HRS = np.float64(hrs_raw.split(':')[0].split('days ')[1])
    except IndexError:
        HRS = 0
    except ValueError:
        HRS = 0
    return HRS

def format_datetimes(mfst, rte_date):
    ## Format as Datetime for operations
    mfst.BeginWindow1 = [make_datetime(rte_date, d) for d in mfst.BeginWindow1]
    mfst.EndWindow1 = [make_datetime(rte_date, d) for d in mfst.EndWindow1]
    mfst.BeginWindow2 = [make_datetime(rte_date, d) for d in mfst.BeginWindow1]
    mfst.EndWindow2 = [make_datetime(rte_date, d) for d in mfst.EndWindow1]
    
    ## Get N hours available in AM and PM
    mfst['HoursAvailableWin1'] = mfst.EndWindow1 - mfst.BeginWindow1
    mfst['HoursAvailableWin2'] = mfst.EndWindow2 - mfst.BeginWindow2
    
    ## Make duration into a floating point & add up total hours available
    mfst['HoursAvailableWin1'] = [customer_hours_available(hrs_raw) for hrs_raw in mfst['HoursAvailableWin1'].astype(str).tolist()] 
    mfst['HoursAvailableWin2'] = [customer_hours_available(hrs_raw) for hrs_raw in mfst['HoursAvailableWin2'].astype(str).tolist()] 
    mfst['TotalHoursAvailable'] = mfst['HoursAvailableWin1'] + mfst['HoursAvailableWin2']
    
    return mfst


# mfst = format_datetimes(mfst, rte_date)
# print(mfst.head())
# missing_rtes = sum([item not in expected_rtes for item in pd.unique(mfst.RouteId).tolist()])
# print('There are %i missing routes after processing the data' %missing_rtes)




def process_driver_manifest(file):
    '''
    Combines all functions above
    to process Roadnet driver manifest
    '''
    mfst, rte_date = get_date_warehouse(file)
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




## Execute for all manifests in folder
path = 'N:\\Operations Intelligence\\Operations Research\\Merchandising vs Operations\\*.csv'
files = glob.glob(path)

MASTER_MANIFEST = pd.DataFrame()

for file in files:
    df = process_driver_manifest(file)
    MASTER_MANIFEST = MASTER_MANIFEST.append(df) 

print(MASTER_MANIFEST.head())
#MASTER_MANIFEST.groupby(['RouteId'])['TotalHoursAvailable'].mean()



print('''
Check which accounts are merchandised
''')
merch_path = 'N:/Operations Intelligence/Operations Research/Merchandising vs Operations/Merchandising Data/ALL MERCHANDISED ACCOUNT SCHEDULES.csv'
USE_THESE = ['Store ID','Store','Address','City','Phone','Mon','Tue','Wed','Thu','Fri','Sat','Sun','Total Merchandising Visits per Week',
            'T','W','R','F','Total Deliveries per Week']
merch_accts = pd.read_csv(merch_path, header=0, usecols=USE_THESE)
merch_accts['Store ID'].fillna(0, inplace=True)
merch_accts['Store ID'] = merch_accts['Store ID'].astype(int) 
merch_accts.head()



## Merge accounts with driver manifest
MASTER_MANIFEST.CustomerId = MASTER_MANIFEST.CustomerId.astype(int)
MASTER_MANIFEST = MASTER_MANIFEST.merge(merch_accts, how='left', left_on='CustomerId', right_on='Store ID')
MASTER_MANIFEST['Store ID'] = MASTER_MANIFEST['Store ID'].isnull() == False
MASTER_MANIFEST.rename(columns={'Store ID':'Merchandised Account'}, inplace=True)
MASTER_MANIFEST.head(10)



MERCH_MANIFEST = MASTER_MANIFEST[MASTER_MANIFEST['Merchandised Account'] == True]
keep_cols = ['RouteId','CustomerId','Customer','Stop','Cases','Bottles','ServiceWindows','TotalHoursAvailable']
MERCH_MANIFEST = MERCH_MANIFEST[keep_cols]
MERCH_MANIFEST.set_index(keys=['RouteId','CustomerId'], drop=True, inplace=True)
MERCH_MANIFEST.head(20)


import time
today_date = str(time.strftime('%A %B %d-%Y'))
MERCH_MANIFEST.to_html("N:/Operations Intelligence/Merchandising/Chain Reports/" + today_date + " Saint Louis Chain Report.html")






# ## Test pdf generator
# import fpdf as pyfpdf
 
# pdf = pyfpdf.FPDF(format='letter')
# pdf.add_page()
# pdf.set_font("Arial", size=12)
# pdf.cell(200, 10, txt="Welcome to Python!", align="C")
# pdf.output("C:/Users/pmwash/Desktop/Disposable Docs/tutorial.pdf")






