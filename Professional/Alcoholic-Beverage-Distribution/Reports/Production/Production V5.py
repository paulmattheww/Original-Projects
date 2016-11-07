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































# testing
extract_stl_night_hours_tab(file_list[1])


file = '10-02.xlsx'

senior = pd.read_excel(temp_location + file, sheetname='Night hours', skiprows=6, skip_footer=1, na_values=['NaN',np.nan,np.NaN,np.NAN], header=0)
casual = pd.read_excel(temp_location + file, sheetname='Night hours', skiprows=34, skip_footer=1, na_values=['NaN',np.nan,np.NaN,np.NAN], header=0)

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
        
df.head(50)

















Production_Panel = pd.Panel(data=panel_data)

Production_Panel.groupby(axis=1, function=np.sum)

Production_Panel['2016-10-06'].tail(50)


Production_Panel['2016-10-03'].columns















