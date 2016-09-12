# -*- coding: utf-8 -*-
"""
This script is meant to collect data from the daily report in both 
KC and STL.
"""

import pandas as pd
pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 50)

from pandas import DataFrame,read_excel
import numpy as np
import os
import shutil
import re
from datetime import datetime as dt

src_folder = 'N:/Daily Report/2016/AUG/'
tmp_folder = 'C:/Users/pmwash/desktop/disposable docs/production data/'

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
            
#copy_production_files(src_folder,tmp_folder)          


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
    
    df = read_excel(file_list[0],sheetname='Production',
                            parse_cols='C:S',header=0)  
    dat = re.sub(r'.xlsx','',file_list[0]) + '-2016'
    df['Date'] = dt.strptime(dat,'%m-%d-%Y')
    file_list.pop(0)
    
    _list = [df]
    
    for file in file_list:
        wb = read_excel(file,sheetname='Production',
                            parse_cols='C:S',header=0)
        dis = re.sub(r'.xlsx','',file) + '-2016'
        wb['Date'] = dt.strptime(dis,'%m-%d-%Y')
            
        _list.append(wb)
    
    frame = pd.concat(_list)
    frame = frame[['Date','LOC','RTE','Stops','TTL Cs/splt',
                 'Start Mi','End Mi','Ttl Mi',
                 'Start Hr','End Hr','Ttl Hrs',
                 'Cs','Btls','Driver','Driver#','Xtra']]
    frame.columns = ['Date','Warehouse','Route','Stops','CasesSplit',
                    'StartMi','EndMi','TotMi','StartHr','EndHr','TotHr',
                    'Cases','Bottles','Driver','DriverId','ExtraDriver']
    frame = frame[frame['Warehouse'] != '-']
    frame = frame[frame['Driver'] != 'Totals:']
    
    # Shifted by 1 due to the fact we route today for tomorrow
    dotw = {6:'Monday', 0:'Tuesday', 1:'Wednesday', 2:'Thursday', 3:'Friday', 4:'Saturday', 5:'Sunday'}
    frame['Weekday'] = frame['Date'].dt.dayofweek.map(dotw)
    first_letter = [w[:1] for w in frame['Weekday']]
    
    frame['Route'] = first_letter + frame['Route'].astype(str).apply(lambda x: x.zfill(5))
    frame.reset_index(0,inplace=True,drop=True)
    
    return frame



x = gather_production_tab_stl(tmp_folder)
print(x.head(20))




def combine_all_houses_roadnet_data(path):
    '''
    Meant to combine exports from Roadnet
    All houses export
    This function combines them for merging with daily report
    '''
    ## CODE HERE
    pass 



























