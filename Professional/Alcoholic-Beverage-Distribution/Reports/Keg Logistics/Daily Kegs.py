'''
Ad Hoc Request - Carrie Ward
Keg trucks this year 
Kegs | Stops | n_KegTrucks
'''
import pandas as pd
from pandas import DataFrame
import numpy as np
import glob
import re
from datetime import datetime as dt
import datetime
import string
import shutil
import os

pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 100)
pd.set_option('display.width', 150)


def copy_daily_reports_local(source, destination):
    '''Copies (not moves) files local machine'''
    for dir, _, files in os.walk(source):
        for file in files:
            if 'Template' not in file:
                src_file = dir + '/' + file
                shutil.copy(src_file, destination)
                print('Copying %s \nto %s' % (src_file, destination))
    print('Finished copying Daily Reports')

destination = os.path.dirname('C:\\Users\\pmwash\\Desktop\\Disposable Docs\\Production Data\\This Year\\')    

folder_stl = source = 'N:/Daily Report/2016/'
copy_daily_reports_local(source=folder_stl, destination=destination)

folder_kc =  'M:/Share/Daily Report KC/2016/'
copy_daily_reports_local(folder_kc, destination)




def extract_date_stl(file, this_year=True):
        '''Takes date from file name'''
        regex_criteria = re.compile(r'[0-9]+-[0-9]+')    
        dat = re.findall(regex_criteria, file)
        
        exclude = set(string.punctuation)
        dat = ''.join(d for d in dat if d not in exclude)
        
        if this_year == True:
            this_year = str(dt.today().year)
        else:
            this_year = str(pd.to_numeric(dt.today().year) - 1)
        
        dat = str(dat + '-' + this_year)
        dat = dt.strptime(str(dat), "%m-%d-%Y").date()
        
        return dat

def extract_date_kc(file, this_year=True):
        '''Takes date from file name'''
        regex_criteria = re.compile(r'[0-9]+-[0-9]+')    
        dat = re.findall(regex_criteria, file)
        
        exclude = set(string.punctuation)
        dat = ''.join(d for d in dat if d not in exclude)
        
        if this_year == True:
            this_year = str(dt.today().year)
        else:
            this_year = str(pd.to_numeric(dt.today().year) - 1)
        
        dat = str(dat + '-' + this_year)
        dat = dt.strptime(str(dat), "%m-%d-%Y").date()

        return dat



def extract_stl_production_tab(file):
        '''
        Takes in and formats Production Tab from Daily Report. 
        Extracts date from filename and creates index.
        Puts into a dictionary of dataframes 
        for input into a pandas DataFrame.
        '''
        
        df = pd.read_excel(file, sheetname='Production')
    
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
        
        return df



def extract_kc_production_tab(file):
        '''
        Takes in and formats Production Tab from Daily Report. 
        Extracts date from filename and creates index.
        Puts into a dictionary of dataframes 
        for input into a pandas DataFrame.
        '''
        df = pd.read_excel(file, sheetname='Production')
    
        dat = extract_date_kc(file)
        
        df['Date'] = dat 
        df['Month'] = dat.strftime('%B')
        df['Weekday'] = dat.strftime('%A')
        df['WeekNumber'] = dat.strftime('%U')
        df['DOTM'] = dat.strftime('%d')
        df['Warehouse'] = 'KC'
        
        keep_cols = ['Date','Warehouse','LOC','RTE','Driver','Truck #','Stops',
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
        
        return df
        
        
        
temp_location = 'C:\\Users\\pmwash\\Desktop\\Disposable Docs\\Production Data\\This Year\\'
file_list = glob.glob(temp_location + '*.xls*')

Production_Tab_STL = pd.DataFrame()        

for i, file in enumerate(file_list):
    df  = extract_stl_production_tab(file)
    try:
        Production_Tab_STL = Production_Tab_STL.append(df)
        print('Adding %s to data frame.' %file)
    except ValueError:
        pass
    

print('Clear & replace files from temp folder before doing again with KC data.')

temp_location = 'C:\\Users\\pmwash\\Desktop\\Disposable Docs\\Production Data\\This Year\\'
file_list = glob.glob(temp_location + '*.xls*')

Production_Tab_KC = pd.DataFrame()        

for i, file in enumerate(file_list):
    df  = extract_kc_production_tab(file)
    try:
        Production_Tab_KC = Production_Tab_KC.append(df)
        print('Adding %s to data frame.' %file)
    except ValueError:
        pass




Production_Tab_STL.tail()
Production_Tab_KC.tail()


def prepare_keg_summary(Production_Tab_STL, Production_Tab_KC):
    MO_Kegs = pd.concat([Production_Tab_STL, Production_Tab_KC], axis=0, ignore_index=False)
    MO_Kegs = MO_Kegs.sort_values(['Date','Warehouse'])
    MO_Kegs = MO_Kegs[['Date','TTL Cs/splt','Truck #','Stops','Ttl Mi','Warehouse','Month','WeekNumber','RTE','index',]]
    
    keg_rtes = ['STL_66','STL_67','STL_68','STL_69','KC_75'] #STL_366'
    MO_Kegs = MO_Kegs[MO_Kegs['index'].isin(keg_rtes)].reset_index(drop=True)
    MO_Kegs.rename(columns={'TTL Cs/splt':'Kegs','Truck #':'Truck','Ttl Mi':'Miles','WeekNumber':'Week','RTE':'Route'}, inplace=True)
    
    MO_Kegs[['Kegs','Stops','Miles']] = MO_Kegs[['Kegs','Stops','Miles']].convert_objects(convert_numeric=True)
    MO_Kegs = MO_Kegs[MO_Kegs['Stops'] > 0]
    
    len_unique = lambda x: len(pd.unique(x))
    group_cols = ['Warehouse','Month','Week','Date']
    agg_funcs = {'Kegs': {np.mean, np.sum},
                    'Stops': {np.mean, np.sum},
                    'index': len_unique,
                    'Miles': {np.mean, np.sum} }
    Daily_Summary_Kegs = pd.DataFrame(MO_Kegs.groupby(group_cols).agg(agg_funcs)).reset_index(drop=False)
    Daily_Summary_Kegs.columns = ['%s%s' % (a, '|%s' % b if b else '') for a, b in Daily_Summary_Kegs.columns]  
    Daily_Summary_Kegs.rename(columns={'index|index':'KegTrucks|count'}, inplace=True)
    Daily_Summary_Kegs.sort_values('Date', inplace=True)
    Daily_Summary_Kegs.reset_index(drop=True, inplace=True)
    
    return Daily_Summary_Kegs, MO_Kegs


Daily_Summary_Kegs, MO_Kegs = prepare_keg_summary(Production_Tab_STL, Production_Tab_KC)

Daily_Summary_Kegs.tail()
MO_Kegs.head()


def export_to_excel(Daily_Summary_Kegs, MO_Kegs):
    '''Writes to Excel'''
    output_path = 'N:\\Operations Intelligence\\Operations Research\\Keg Routes\\'
    output_file_name = output_path + 'Daily Keg Routes 2016.xlsx'
    
    file_out = pd.ExcelWriter(output_file_name, engine='xlsxwriter')
    workbook = file_out.book
        
    Daily_Summary_Kegs.to_excel(file_out, sheet_name='Daily Summary', index=False)
    MO_Kegs.to_excel(file_out, sheet_name='Raw Data', index=False)
    
    format_float = workbook.add_format({'num_format': '#,##0.#0'})   
    
    summary_tab = file_out.sheets['Daily Summary']
    summary_tab.set_column('A:A',31)
    summary_tab.set_column('B:B',20)
    summary_tab.set_column('C:C',15)
    summary_tab.set_column('D:D',25)
    summary_tab.set_column('E:K',30,format_float)
    
    raw_data_tab = file_out.sheets['Raw Data']
    raw_data_tab.set_column('A:A',31)
    raw_data_tab.set_column('B:B',20,format_float)
    raw_data_tab.set_column('C:D',25,format_float)
    raw_data_tab.set_column('E:I',25)
    raw_data_tab.set_column('E:K',30,format_float)

    file_out.save()    
    print('Finished writing analysis to file.')




export_to_excel(Daily_Summary_Kegs, MO_Kegs)



Daily_Summary_Kegs['Kegs|sum'].plot()
Daily_Summary_Kegs.groupby('Warehouse')['KegTrucks|count'].plot(subplots=True, kind='line')






