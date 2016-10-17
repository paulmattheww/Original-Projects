'''
Unsaleables, returns & dumps
Re-Engineered September/October 2016
Takes two input queries
PWUNSALE queries MTC1
PWRCT1 queries RCT1
Adjust date ranges on queries
Do not add or remove columns in query
'''

import pandas as pd 
from pandas import Series,DataFrame
import numpy as np
from datetime import datetime as dt
from datetime import date
import datetime

pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 100)
pd.set_option('display.width', 100)


input_folder = 'C:/Users/pmwash/Desktop/R_files/Data Input/Input Files for Reports/Unsaleables/'


pwrct1 = pd.read_csv(input_folder + 'pwrct1.csv', header=0, encoding='ISO-8859-1')
pwunsale = pd.read_csv(input_folder + 'pwunsale.csv', header=0, encoding='ISO-8859-1')


print('Mapping column names.')
pwunsale_col_map = {'#MIVND':'Invoice', '#MINP#':'ProductId', '#MTRCD':'TransactionCode',
                    '#MIVDT':'Date', '#MCUS#':'CustomerId', '#MQTYS':'Quantity', 
                    '#MCOS$':'Cost', '#MEXT$':'ExtCost', '#MQPC':'QPC',
                    '#MCMP':'Warehouse', '#MQTY@':'QtyCode', '#MCMRC':'CreditReason',
                    '#MUSER':'Username', '#MGRP':'GroupNumber', '#MSIZ@':'Size'}
pwunsale.rename(columns=pwunsale_col_map, inplace=True)

pwrct1_col_map = {'#RCOMP':'Warehouse', '#RCODE':'ReasonCode', '#RTRC@':'TransactionCode',
                  'PSUPPL':'SupplierId', '#SSUNM':'Supplier', '#RPRD#':'ProductId',
                  '#RDESC':'Product', '#RSIZE':'Size', '#RCLA@':'Class', 
                  '#RFOB':'FOB', '#RQPC':'QPC', 'PQTYPC':'QPCx', '#RCASE':'Cases',
                  '#RBOTT':'Bottles', '#RDATE':'Date', '#RREC#':'ReceiptOrAdjust',
                  '#RWHSE':'Warehousex', 'PDESC':'Description', 'PEDESC':'ExtendedDescription',
                  'PBRAN#':'BrandId'}
pwrct1.rename(columns=pwrct1_col_map, inplace=True)

def as400_date(dat):
    '''Accepts list of dates as strings from theAS400'''
    return [dt.date(dt.strptime(d[-6:], '%y%m%d')) for d in dat]

print('Mapping dates, DOTW, DOTY, WOTY, and DOTM.')
dat = pwrct1['Date'].astype(str).tolist()
pwrct1['Date'] = dat = as400_date(dat)
pwrct1['Month'] = [d.strftime('%B') for d in dat]
pwrct1['Weekday'] = [d.strftime('%A') for d in dat]
pwrct1['DOTY'] = [d.strftime('%j') for d in dat]
pwrct1['WeekNumber'] = [d.strftime('%U') for d in dat]
pwrct1['DOTM'] = [d.strftime('%d') for d in dat]

dat = pwunsale['Date'].astype(str).tolist()
pwunsale['Date'] = dat = as400_date(dat)

print('Deriving case equivalents for RCT data.')
btls_as_cases = np.divide(pwrct1['Bottles'].astype(np.float64), pwrct1['QPC'].astype(np.float64))
pwrct1['CasesUnsaleable'] = pwrct1['Cases'] + btls_as_cases

print('Deriving EXT COST from RCT data.')
pwrct1['ExtCost'] = np.multiply(pwrct1.Cases, pwrct1.FOB) + np.multiply(np.divide(pwrct1.FOB, pwrct1.QPC), pwrct1.Bottles) 

print('Deriving cases returned for MTC data from FOB/QPC/BTLS/CASES.')
pwunsale['CasesReturned'] = round(np.divide(pwunsale.Quantity, pwunsale.QPC), 2)

print('Mapping class codes to semantic meaning to RTC data.')
class_codes = {10:'Liquor & Spirits', 25:'Liquor & Spirits', 50:'Wine',
               51:'Wine', 53:'Wine', 55:'Wine', 58:'Beer & Cider', 59:'Beer & Cider', 
               70:'Wine', 80:'Beer & Cider', 84:'Beer & Cider', 85:'Beer & Cider',
               86:'Beer & Cider', 87:'Beer & Cider', 88:'Beer & Cider', 90:'Non-Alcoholic',
               91:'Non-Alcoholic', 92:'Non-Alcoholic', 93:'Non-Alcoholic',
               94:'Non-Alcoholic', 95:'Non-Alcoholic', 96:'Non-Alcoholic', 
               97:'Non-Alcoholic', 98:'Non-Alcoholic', 99:'Non-Alcoholic'}
pwrct1['Class'] = pwrct1.Class.map(class_codes)

print('Reversing the sign of cases and dollars for user understandability')
flip_sign = lambda x: np.multiply(x, -1)
pwrct1[['CasesUnsaleable', 'ExtCost']] = pwrct1[['CasesUnsaleable', 'ExtCost']].apply(flip_sign)






pwrct1.head()
pwunsale.head()





































