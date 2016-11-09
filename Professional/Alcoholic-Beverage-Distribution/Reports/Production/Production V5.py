'''
Production Report
Re-Engineered November 2016
'''

import pandas as pd
from pandas import DataFrame
import numpy as np
import glob
import re
from datetime import datetime as dt
import datetime
import string


pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 100)
pd.set_option('display.width', 200)


temp_location = 'C:\\Users\\pmwash\\Desktop\\Disposable Docs\\Production Data\\'
file_list = glob.glob(temp_location + '*.xls*')



def extract_date_stl(file):
        '''Takes date from file name'''
        regex_criteria = re.compile(r'[0-9]+-[0-9]+')    
        dat = re.findall(regex_criteria, file)
        
        exclude = set(string.punctuation)
        dat = ''.join(d for d in dat if d not in exclude)
        
        this_year = str(dt.today().year)
        dat = str(dat + '-' + this_year)
        dat = dt.strptime(str(dat), "%m-%d-%Y").date()
        return dat


def extract_stl_production_tab(file, df):
        '''
        Takes in and formats Production Tab from Daily Report. 
        Extracts date from filename and creates index.
        Puts into a dictionary of dataframes 
        for input into a pandas DataFrame.
        '''
        dtypes = {'Date':dt.date, 'Warehouse':str,'LOC':str,'RTE':str,'Driver':str,'Truck#':str,
                'Stops':np.float64,'TTL Cs/splt':np.float64,'Cs':np.float64,'Btls':np.float64,
                'Start Hr':str, 'End Hr':str,'Ttl Hrs':str,'Ttl Mi':np.float64 }
        df = pd.read_excel(file, sheetname='Production', converters=dtypes)
    
        dat = extract_date_stl(file)
        
        df['Date'] = dat 
        df['Month'] = dat.strftime('%B')
        df['Weekday'] = dat.strftime('%A')
        df['WeekNumber'] = dat.strftime('%U')
        df['DOTM'] = dat.strftime('%d')
        df['Warehouse'] = 'STL'
        
        keep_cols = ['Date','Warehouse','LOC','RTE','Driver','Truck#','Stops',
                     'TTL Cs/splt','Cs','Btls','Start Hr',
                     'End Hr','Ttl Hrs','Ttl Mi','Month','Weekday','WeekNumber',
                     'DOTM']
        df = df[keep_cols].drop_duplicates()
        
        WAREHOUSE, ROUTE = df.Warehouse.astype(str), df.RTE.astype(str)
        new_index = WAREHOUSE + '_' + ROUTE 
        
        df.set_index(new_index, inplace=True)
        
        df = df[df['Driver'] != 'Totals:']        
        df = df.sort_values(['Stops','TTL Cs/splt'], ascending=False).reset_index(drop=False)
        
        df['Date'] = df['Date'].replace(to_replace='NaN', value='')
        df = df[df['Date'].isnull() == False]
        
        return df, dat


Production_Tab = pd.DataFrame()        

for i, file in enumerate(file_list):
    df, dat = extract_stl_production_tab(file, df)
    Production_Tab = Production_Tab.append(df)
    print('Adding production tab data for %s' % dat)


Production_Tab.head(100)
cols = ['Stops','TTL Cs/splt', 'Ttl Mi']
Production_Tab.groupby(['LOC'])[cols].sum()





def extract_stl_night_hours_tab(file):
        '''
        Takes in and formats Night Hours tab from Daily Report. 
        Extracts date from filename and creates index.
        Puts into a dictionary of dataframes 
        for input into a pandas DataFrame.
        '''
        senior = pd.read_excel(file, sheetname='Night hours', skiprows=6, skip_footer=1, na_values=['NaN',np.nan,np.NaN,np.NAN], header=0)
        casual = pd.read_excel(file, sheetname='Night hours', skiprows=34, skip_footer=1, na_values=['NaN',np.nan,np.NaN,np.NAN], header=0)
        
        dat = extract_date_stl(file)
        
        senior['Date'] = casual['Date'] = dat 
        senior['Month'] = casual['Month']  = dat.strftime('%B')
        senior['Weekday'] = casual['Weekday']  = dat.strftime('%A')
        senior['WeekNumber'] = casual['WeekNumber'] = dat.strftime('%U')
        senior['DOTM'] = casual['DOTM'] = dat.strftime('%d')
        senior['Warehouse'] = casual['Warehouse'] = 'STL'
        
        keep_cols = ['Date','NAME','HRS WORKED','REG TIME','O.T HOURS',
                    'Month','Weekday','WeekNumber','DOTM','Warehouse']
            
        senior = senior[keep_cols].drop_duplicates()
        casual = casual[keep_cols].drop_duplicates()
        
        senior['Type'] = 'Senior'
        casual['Type'] = 'Casual'
        
        senior = senior[senior['NAME'].isnull() == False]
        casual = casual[casual['NAME'].isnull() == False]
        
        df = senior.append(casual)
        df.reset_index(drop=True, inplace=True)
        
        return df
        
        
        
NightlyHours_Tab = pd.DataFrame()        

for i, file in enumerate(file_list):
    df = extract_stl_night_hours_tab(file)
    
    NightlyHours_Tab = NightlyHours_Tab.append(df)


NightlyHours_Tab.head(100)

















def extract_stl_over_short_tabs(file):
        '''
        Takes in and formats BOTH O/S tabs from Daily Report. 
        Extracts date from filename and creates index.
        Puts into a dictionary of dataframes 
        for input into a pandas DataFrame.
        '''
        dtypes = {'Driver #':np.int,'Customer #':np.int,'RTE':np.int,'Item #':int,'CS':np.float64,'BTL':np.float64}
        stl_os = pd.read_excel(file, sheetname='Over-Short', skip_footer=1, na_values=['NaN',np.nan,np.NaN,np.NAN], header=0, dtypes=col_dtypes)
        col_os = pd.read_excel(file, sheetname='Col. Over - Short', skip_footer=1, na_values=['NaN',np.nan,np.NaN,np.NAN], header=0, col_dtypes=dtypes)
        
        dat = extract_date_stl(file)
        
        stl_os['Date'] = col_os['Date'] = dat 
        stl_os['Month'] = col_os['Month']  = dat.strftime('%B')
        stl_os['Weekday'] = col_os['Weekday']  = dat.strftime('%A')
        stl_os['WeekNumber'] = col_os['WeekNumber'] = dat.strftime('%U')
        stl_os['DOTM'] = col_os['DOTM'] = dat.strftime('%d')
        stl_os['Warehouse'] = col_os['Warehouse'] = 'STL'
        
        keep_cols = ['Date','Driver #','Customer #','RTE','Item #',
                    'CS','BTL','Month','Weekday','WeekNumber','DOTM','Warehouse']
            
        stl_os = stl_os[keep_cols].reset_index(drop=True)
        col_os = col_os[keep_cols].reset_index(drop=True)
        
        stl_os['Type'] = 'STL'
        col_os['Type'] = 'COL'
        
        stl_os = stl_os[stl_os['RTE'].isnull() == False]
        col_os = col_os[col_os['RTE'].isnull() == False]
        
        df = stl_os.append(col_os)
        
        non_decimal = re.compile(r'[^\d.]+')
        drv_no, cus_no, itm_no = df['Driver #'].astype(str).tolist(), df['Customer #'].astype(str).tolist(), df['Item #'].astype(str).tolist()
        df['Driver #'] = [non_decimal.sub('', d) for d in drv_no]
        df['Customer #'] = [non_decimal.sub('', c) for c in cus_no]
        df['Item #'] = [non_decimal.sub('', i) for i in itm_no]
        
        df['Driver #'] = pd.to_numeric(df['Driver #'], errors='coerce')
        df['Customer #'] = pd.to_numeric(df['Customer #'], errors='coerce')
        df['Item #'] = pd.to_numeric(df['Item #'], errors='coerce')
        df.fillna(0, inplace=True)
        
        df[['Driver #','Customer #','Item #']] = df[['Driver #','Customer #','Item #']].astype(int)
        
        df.reset_index(drop=True, inplace=True)
        
        return df
        
        
        
OverShort_Tab = pd.DataFrame()        

for i, file in enumerate(file_list):
    df = extract_stl_over_short_tabs(file)
    OverShort_Tab = OverShort_Tab.append(df)
    OverShort_Tab.reset_index(drop=True, inplace=True)
    


OverShort_Tab.head(50)












def extract_stl_returns_tab(file):
        '''
        Takes in and formats the Returns tab from Daily Report. 
        Extracts date from filename and creates index.
        Puts into a dictionary of dataframes 
        for input into a pandas DataFrame.
        '''
        dtypes = {'Driver #':np.int,'Inv#':np.int64,'Customer':str,'Cust#':np.int64,
            'Driver #':np.int64,'Driver':str,'Reason':str,'Cases':np.float64,
            'Bottles':np.float64,'Pick up Cases':np.float64,'Empty Boxes':np.float64,
            'PLLTS':np.int64,'Kegs':np.int64,'POS':np.int64,'Bonus':np.float64,'Inv Amt':np.float64,
            'Driver Return or Customer Return':str,'Inv#':np.int64
        }
        returns = pd.read_excel(file, sheetname='Returns', skip_footer=1, na_values=['NaN',np.nan,np.NaN,np.NAN], header=0, col_dtypes=dtypes, skiprows=2)
        
        returns.fillna(0, inplace=True)
        dat = extract_date_stl(file)
        
        returns['Date'] =  dat 
        returns['Month'] = dat.strftime('%B')
        returns['Weekday'] = dat.strftime('%A')
        returns['WeekNumber'] = dat.strftime('%U')
        returns['DOTM'] = dat.strftime('%d')
        returns['Warehouse'] = 'STL'
        
        keep_cols = ['Date','Driver Return or Customer Return','Inv#',
                    'Cust#','Customer','Driver #','Driver','Reason','Cases','Bottles',
                    'Pick up Cases','Empty Boxes','PLLTS','Kegs','Empty Kegs',
                    'POS','Bonus','Inv Amt','Sales Person',
                    'Month','Weekday','WeekNumber','DOTM','Warehouse']
            
        returns = returns[keep_cols].reset_index(drop=True)

        returns = returns[returns['Driver Return or Customer Return'] != 0]
        
        returns.reset_index(drop=True, inplace=True)
        
        return returns
        
        
        
Returns_Tab = pd.DataFrame()        

for i, file in enumerate(file_list):
    df = extract_stl_returns_tab(file)
    Returns_Tab = Returns_Tab.append(df)
    Returns_Tab.reset_index(drop=True, inplace=True)
    
    
Returns_Tab.head(20)
    
    
    
    
    
    
    







# TESTING
dtypes = {'Driver #':np.int,'Customer #':np.int,'RTE':np.int,'Item #':int,'CS':np.float64,'BTL':np.float64}
summary_tab = pd.read_excel(file, sheetname='Summary', skip_footer=1, na_values=['NaN',np.nan,np.NaN,np.NAN], header=0, skiprows=1, names=np.arange(1,14))
keep_cols = [1,2,4,5,9,10,12,13]
summary_tab = summary_tab[keep_cols]
summary_tab.head(25)

#[row,col]
cases_returned = summary_tab.loc[2,2]
btls_returned = summary_tab.loc[3,2]
stop_return_count = summary_tab.loc[4,2]
dollars_returned = summary_tab.loc[5,2]
overs = summary_tab.loc[8,2]
shorts = summary_tab.loc[9,2]
mispicks = summary_tab.loc[12,2]
total_errors = summary_tab.loc[17,2]

total_cases = summary_tab.loc[2,5]
cases_stl = summary_tab.loc[3,5]
kegs = summary_tab.loc[4,5]
kc_transfer = summary_tab.loc[5,5]
cases_col = summary_tab.loc[6,5]
cases_cape = summary_tab.loc[7,5]

total_bottles = summary_tab.loc[9,5]
stl_btls = summary_tab.loc[10,5]
col_btls = summary_tab.loc[11,5]
cap_btls = summary_tab.loc[12,5]

total_stops = summary_tab.loc[13,5]
stops_stl = summary_tab.loc[14,5]
stops_cape = summary_tab.loc[15,5]
stops_col = summary_tab.loc[16,5]
total_trucks = summary_tab.loc[17,5] 
trucks_package = summary_tab.loc[18,5]
trucks_keg = summary_tab.loc[19,5]

cases_per_hour = summary_tab.loc[20,5]
cpmh_c = summary_tab.loc[24,5]
cpmh_d = summary_tab.loc[25,5]
cpmh_e = summary_tab.loc[26,5]
cpmh_f = summary_tab.loc[27,5]
cpmh_g = summary_tab.loc[28,5]
cases_c = summary_tab.loc[4,10]
cases_d = summary_tab.loc[6,10]
cases_e = summary_tab.loc[8,10]
cases_f = summary_tab.loc[27,10]
cases_g = summary_tab.loc[28,10]


dat = extract_date_stl(file)

summary_tab['Date'] =  dat 
summary_tab['Month'] = dat.strftime('%B')
summary_tab['Weekday'] = dat.strftime('%A')
summary_tab['WeekNumber'] = dat.strftime('%U')
summary_tab['DOTM'] = dat.strftime('%d')
summary_tab['Warehouse'] = 'STL'

keep_cols = ['Date','Driver #','Customer #','RTE','Item #',
            'CS','BTL','Month','Weekday','WeekNumber','DOTM','Warehouse']
    
summary_tab = summary_tab[keep_cols].reset_index(drop=True)

summary_tab['Type'] = 'STL'

summary_tab = summary_tab[summary_tab['RTE'].isnull() == False]

summary_tab.reset_index(drop=True, inplace=True)




summary_tab.head()






