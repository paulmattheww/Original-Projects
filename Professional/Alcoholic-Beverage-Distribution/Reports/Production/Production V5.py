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



print('Read in files.')
temp_location = 'C:\\Users\\pmwash\\Desktop\\Disposable Docs\\Production Data\\'
file_list = glob.glob(temp_location + '*.xls*')


str(file_list).punctuation


panel_data = {}

for i, file in enumerate(file_list):
    df = pd.read_excel(file, sheetname='Production')

    regex_criteria = re.compile(r'[0-9]+-[0-9]+')    
    dat = re.findall(regex_criteria, file)
    
    exclude = set(string.punctuation)
    dat = ''.join(d for d in dat if d not in exclude)
    
    this_year = str(dt.today().year)
    dat = str(dat + '-' + this_year)

    dat = dt.strptime(str(dat), "%m-%d-%Y").date()
        
    panel_data[dat] = df
    print(dat)




Production_Tab = pd.Panel(data=panel_data)








#test
regex_criteria = re.compile(r'[0-9]+-[0-9]+')
for i, file in enumerate(file_list):
    dat = re.findall(regex_criteria, file)
    dt.strptime(str(dat), "['%m-%d']")
















{f: pd.read_excel(f, sheetname='Production') for f in daily_reports}

Production_Tab = pd.Panel()



{f: pd.read_excel(f, sheetname='Production') for f in daily_reports}
master_df = DataFrame()

for file in daily_reports:
    df = pd.read_excel(file, sheetname='Production')
    df = df[df['RTE'] != np.NaN]
    master_df = master_df.append(df)

master_df.head(50)



daily_reports = os.listdir(temp_location)

daily_reports








# def move_files_to_neutral_location(): pass
#kc_base_dir = 'M:/Share/Daily Report KC/2016/October 2016/.'
#stl_base_dir = 'N:/Daily Report/2016/OCT/.'
#
#file_list = os.listdir(stl_base_dir)
#file_list = [f for f in file_list if f.startswith('~$') == False]
#destination = 'C:/Users/pmwash/Desktop/Disposable Docs/Production Data/'
#
#def copy_daily_reports(file_list, destination, stl_base_dir, kc_base_dir=None):    
#    
#    for file in file_list:
#        if not file.startswith('~'):
#            file_name = os.path.join(stl_base_dir, file)
#            print('Copying %s to %s' % (file_name, destination))
#            shutil.copyfile(file_name, destination)
#    os.system('cls')
#    print('Copying complete.')
#    
#       
#
##os.remove('C:/Users/pmwash/Desktop/Disposable Docs/Production Data/~$08-01.xlsx')
#
#copy_daily_reports(file_list, destination, stl_base_dir)
#os.listdir('C:\\Users\\pmwash\\Desktop\\Disposable Docs\\Production Data')
#
#
#_from = 'N:/Daily Report/2016/SEP'
#_to = 'C:/Users/pmwash/Desktop/Disposable Docs/Production Data'
#
#
#distutils.dir_util.copy_tree(_from, _to)
#
#
#src = os.path.join('N:/Daily Report/2016/SEP/',file_list[1])
#shutil.copyfile(src,destination)
#src









