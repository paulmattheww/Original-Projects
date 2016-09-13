"""
Collect daily reports from KC/STL
Copy to local disk
Extract data for each house and combine into one dataframe
Combine the two houses' daily reports
Combine all houses Roadnet data
Merge Roadnet data with daily report data
"""

import pandas as pd
pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 50)

from pandas import read_excel
import numpy as np
import os
import shutil
import re
from datetime import datetime as dt



def copy_production_files(src_folder,tmp_folder):
    '''
    Copies files from common drive to local disk
    to prevent mistakes and messing up their files
    '''
    src_files = os.listdir(src_folder)
    
    for file in src_files:
        file_name = os.path.join(src_folder,file)
        if (os.path.isfile(file_name)):
            shutil.copy(file_name,tmp_folder)
            print('File %s copied to local disk.' %file_name)
    print('''
    All files have been transferred to local disk. \n\n
    Check to be sure there are no duplicates.\n
    ''')
    
    


src_folder_stl = 'N:/Daily Report/2016/SEP/'
src_folder_kc = 'M:/Share/Daily Report KC/2016/September 2016/'
tmp_folder_stl = 'C:/Users/pmwash/desktop/disposable docs/production data/stl/'
tmp_folder_kc = 'C:/Users/pmwash/desktop/disposable docs/production data/kc/'



#print('Copying STL files to local disk at %s.' % tmp_folder_stl)
#copy_production_files(src_folder_stl,tmp_folder_stl)          
#
#print('Copying KC files to local disk at %s.' % tmp_folder_kc)
#copy_production_files(src_folder_kc,tmp_folder_kc)



def gather_production_tab_stl(tmp_folder):
    '''
    This function takes the daily report files
    that were copied in the step above,
    reads them in, binds the newest one to the 
    last row of the previous file
    '''
    os.chdir(tmp_folder)
    file_list = os.listdir(tmp_folder)
    file_list = [f for f in file_list if f[-4:]=='xlsx' and f[:2] != '~$']
    file_list = [f for f in file_list if bool(re.search('Template',f))==False]
    
    df = read_excel(file_list[0],sheetname='Production',
                            parse_cols='C:S',header=0)  
    dat = re.sub(r'.xlsx','',file_list[0]) + '-2016'
    df['Date'] = dt.strptime(dat,'%m-%d-%Y')
    file_list.pop(0)
    
    _list = [df]
    
    for file in file_list:
        wb = read_excel(file,sheetname='Production', #bool(re.search('Production', 'Production (1)')) #difflib.get_close_matches('Production'),
                            parse_cols='C:S',header=0)
        dis = re.sub(r'.xlsx','',file) + '-2016'
        wb['Date'] = dt.strptime(dis,'%m-%d-%Y')
            
        _list.append(wb)
    
    frame = pd.concat(_list)
    frame = frame[['Date','LOC','RTE','Stops','TTL Cs/splt',
                 'Start Mi','End Mi','Ttl Mi',
                 'Start Hr','End Hr','Ttl Hrs',
                 'Cs','Btls','Driver','Driver#']]
    frame.columns = ['Date','Warehouse','Route','Stops','CasesSplit',
                    'StartMi','EndMi','TotMi','StartHr','EndHr','TotHr',
                    'Cases','Bottles','Driver','DriverId']
    frame = frame[frame['Warehouse'] != '-']
    frame = frame[frame['Driver'] != 'Totals:']
    
    # Shifted by 1 due to the fact we route today for tomorrow
    dotw = {6:'Monday', 0:'Tuesday', 1:'Wednesday', 2:'Thursday', 3:'Friday', 4:'Saturday', 5:'Sunday'}
    frame['Weekday'] = frame['Date'].dt.dayofweek.map(dotw)
    first_letter = [w[:1] for w in frame['Weekday']]
    
    frame['RoadnetRoute'] = first_letter + frame['Route'].astype(str).apply(lambda x: x.zfill(5))
    frame.reset_index(0,inplace=True,drop=True)
    frame.sort(inplace=True)
    
    return frame




print('Extracting & combining STL Daily Report data from local disk. \n\n')
pre_compiled_stl = gather_production_tab_stl(tmp_folder_stl)
print(pre_compiled_stl.head(),pre_compiled_stl.tail())





def gather_production_tab_kc(tmp_folder_kc):
    '''
    This function takes the daily report files for KC
    that were copied in the step above,
    reads them in, binds the newest one to the 
    last row of the previous file
    '''
    os.chdir(tmp_folder_kc)
    file_list = os.listdir(tmp_folder_kc)
    file_list = [f for f in file_list if f[-3:]=='xls' and f[:2] != '~$']
    file_list = [f for f in file_list if bool(re.search('Template',f))==False]
    
    df = read_excel(file_list[0],sheetname='Production',
                            parse_cols='C:S',header=0)  
    dat = re.sub(r'Daily Report '.lower(),'',file_list[0].lower())
    dat = re.sub(r'.xls','',dat) + '-2016'
    df['Date'] = dt.strptime(dat,'%m-%d-%Y')
    file_list.pop(0)
    
    _list = [df]
    
    for file in file_list:
        wb = read_excel(file,sheetname='Production',
                            parse_cols='C:S',header=0)
        dis = re.sub(r'Daily Report '.lower(),'',file.lower())
        dis = re.sub(r'.xls','',dis) + '-2016'
        wb['Date'] = dt.strptime(dis,'%m-%d-%Y')
            
        _list.append(wb)
    
    frame = pd.concat(_list)
    frame = frame[['Date','LOC','RTE','Stops','TTL Cs/splt',
                 'Start Mi','End Mi','Ttl Mi',
                 'Start Hr','End Hr','Ttl Hrs',
                 'Cs','Btls','Driver','Driver#']]
    frame.columns = ['Date','Warehouse','Route','Stops','CasesSplit',
                    'StartMi','EndMi','TotMi','StartHr','EndHr','TotHr',
                    'Cases','Bottles','Driver','DriverId']
    frame = frame[frame['Warehouse'] != '-']
    frame = frame[frame['Driver'] != 'Totals:']
    
    # Shifted by 1 due to the fact we route today for tomorrow
    dotw = {6:'Monday', 0:'Tuesday', 1:'Wednesday', 2:'Thursday', 3:'Friday', 4:'Saturday', 5:'Sunday'}
    frame['Weekday'] = frame['Date'].dt.dayofweek.map(dotw)
    first_letter = [w[:1] for w in frame['Weekday']]
    
    frame['RoadnetRoute'] = first_letter + frame['Route'].astype(str).apply(lambda x: x.zfill(5))
    frame.reset_index(0,inplace=True,drop=True)
    frame.sort('Date',inplace=True)
    
    return frame


print('Extracting & combining KC Daily Report data from local disk. \n\n')
pre_compiled_kc = gather_production_tab_kc(tmp_folder_kc)
print(pre_compiled_kc.head(), pre_compiled_kc.tail())






export_path = 'n:/operations intelligence/roadnet routing operations/exports/'
stl_file = export_path + 'stl_built_routes.xlsx'
kc_file = export_path + 'kc_built_routes.xlsx'
col_file = export_path + 'col_built_routes.xlsx'
spfd_file = export_path + 'spfd_built_routes.xlsx'

export_list = [stl_file,kc_file,col_file,spfd_file]

def combine_roadnet_exports(export_list):
    '''
    This function wlil take raw exports from Roadnet,
    Read them into memory,
    Select, format and rename specific columns,
    Combine all of them into one dataframe,
    Then save it so they can be mapped to daily report data
    '''
    export_df = pd.DataFrame()
    
    for house in export_list:
        df = read_excel(house,sheetname='Sheet')
        if house is stl_file:
            df['Warehouse'], df['WarehouseAS400'] = 'STL', '2'
            df['WarehouseRoute'] = df['Warehouse'].astype(str)+'_'+ df['ID'].astype(str)
        elif house is kc_file:
            df['Warehouse'], df['WarehouseAS400'] = 'KC', '1'
            df['WarehouseRoute'] = df['Warehouse'].astype(str)+'_'+ df['ID'].astype(str) 
        elif house is col_file:
            df['Warehouse'], df['WarehouseAS400'] = 'COL', '3'
            df['WarehouseRoute'] = df['Warehouse'].astype(str)+'_'+ df['ID'].astype(str)     
        elif house is spfd_file:
            df['Warehouse'], df['WarehouseAS400'] = 'SPFLD', '5'
            df['WarehouseRoute'] = df['Warehouse'].astype(str)+'_'+ df['ID'].astype(str)
        else:
            df['Warehouse'], df['WarehouseAS400'] = 'UNDEFINED', 'UNDEFINED'
            df['WarehouseRoute'] = df['Warehouse'].astype(str)+'_'+ df['ID'].astype(str)
            
        df = df[['ID','Description','Total Run Time','Total Equipment Distance Cost',
                         'Total Equipment Fixed Cost', 'Total Fixed Service Time',
                         'Net Revenue', 'Total Worker Stop Cost','Warehouse',
                         'WarehouseAS400','WarehouseRoute']]
        df.columns = ['RoadnetRoute','Description','RoadnetRunTime','EquipmentDistanceCost',
                         'EquipmentFixedCost', 'RoadnetServiceTime',
                         'Revenue', 'WorkerStopCost','Warehouse','WarehouseAS400',
                         'WarehouseRoute']
        export_df = export_df.append(df)
        
    return export_df
    
roadnet_clean_exports = combine_roadnet_exports(export_list)

print(roadnet_clean_exports.head(),'\n\n\n',roadnet_clean_exports.tail())








#stl

#
#print('STL Data\n', stl_export.head(),
#      '\nKC Data\n', kc_export.head(),'\nCOL Data\n', col_export.head(), '\nSPFD Data\n', spfd_export.head())
#
#
#stl_data = pre_compiled_stl.merge(stl_export,left_on='RoadnetRoute',right_on='ID')
#

#
#
#def combine_all_houses_roadnet_data(path):
#    '''
#    Meant to combine exports from Roadnet
#    All houses export
#    This function combines them for merging with daily report
#    '''
#    ## CODE HERE
#    pass 
#
#
#
#
#def merge_roadnet_data(pre_combined_daily_report,pre_combined_roadnet):
#    pass










