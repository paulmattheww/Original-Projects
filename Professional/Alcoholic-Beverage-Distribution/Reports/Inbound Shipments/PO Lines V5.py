'''
Analysis of Inbound Shipments
PO Lines, Cases, POs, etc. 
This analysis is configurable and modular
'''

import pandas as pd
import numpy as np
from datetime import datetime as dt
import matplotlib.pyplot as plt
import seaborn as sns
sns.set(style='whitegrid')

pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 100)
pd.set_option('display.width', 100)

input_folder = 'C:/Users/pmwash/Desktop/Re-Engineered Reports/PO Lines/'
dtypes = {'UDPO#':np.int64, 'UDLIN#':np.int64, 'UDDRC1':str, 'UDPRD#':np.int64,
            'UDSUPP':np.int64, 'QTYREC':np.float64, 'UDFOB':np.float64, 'UDTOQ':str,
            'EXT_COST':np.float64, 'UDCOMP':np.int64, 'UDSCC':str, 'Cases_Received':np.float64,
            'UDWHSE':str, 'UDWGT':np.float64, 'UDBRAN':np.int64, 'UDQPC':np.int64}
pw_polines = pd.read_excel(input_folder + 'pw_polines.xlsx', sheetname='pw_polines', header=0)

    
    
def summarize_po_lines(pw_polines):
    '''
    Takes in query pw_polines
    and summarizes it for consumption
    '''

    def as400_date(dat):
        '''Accepts list of dates as strings from theAS400'''
        try:
            dat = dt.date(dt.strptime(dat[-6:], '%y%m%d'))
        except:
            if dt.date(dt.strptime(dat[-6:], '%y%m%d')) == '1090001':
                dat = None
        return dat

    pw_polines.Warehouse = pw_polines.Warehouse.map({1:'Kansas City', 2:'Saint Louis'})
    pw_polines.Date_Received = dat = [as400_date(d) for d in pw_polines.Date_Received.astype(str)]
    pw_polines['Month'] = [d.strftime('%B') for d in dat]
    pw_polines['Year'] = [d.strftime('%Y') for d in dat]
    pw_polines['Weekday'] = [d.strftime('%A') for d in dat]
    pw_polines['Week'] = [d.strftime('%W') for d in dat]
    pw_polines['DOTM'] = [d.strftime('%d') for d in dat]
    pw_polines['DOTY'] = [d.strftime('%j') for d in dat]
    
    ## Distinguishing between cases and bottles - setting their values
    pw_polines['Cases_Received'] = None
    CS, BTL, QPC = pw_polines.loc[pw_polines['Case_or_Btl'] == 'C', 'Qty_Received'].astype(np.float64), pw_polines.loc[pw_polines['Case_or_Btl'] == 'B', 'Qty_Received'].astype(np.float64), pw_polines.loc[pw_polines['Case_or_Btl'] == 'B', 'QPC'].astype(np.float64)
    pw_polines.loc[pw_polines['Case_or_Btl'] == 'C', 'Cases_Received'] = CS
    pw_polines.loc[pw_polines['Case_or_Btl'] == 'B', 'Cases_Received'] = np.divide(BTL, QPC)
    
    pw_polines['PO_&_Line_Number'] = pw_polines.PO_Number.astype(str) +'_'+ pw_polines.Line_Number.astype(str)
    
    agg_funcs = {'PO_&_Line_Number' : lambda x: len(pd.unique(x)),
                'Ext_Cost' : np.sum,
                'Cases_Received' : np.sum,
                'Weight' : np.sum }
    summary = pd.DataFrame(pw_polines.groupby(['Warehouse','Date_Received','Year','Month','Weekday']).agg(agg_funcs)).reset_index(drop=False)
    summary['CasesPerPOLine'] = np.divide(summary['Cases_Received'], summary['PO_&_Line_Number'])
    
    dat = summary.Date_Received
    summary['DOTY'], summary['DOTM'] = [d.strftime('%j') for d in dat],  [d.strftime('%d') for d in dat]
    
    return summary



summary = summarize_po_lines()
#summary.to_csv('C:/Users/pmwash/Desktop/R_files/Data Input/SUMMARY INBOUND SHIPMENTS.csv', rownames=False)
summary['PO_&_Line_Number'].plot(subplots=True)
#summary.plot(x='Date_Received',y='Cases_Received', kind='line')
#summary.head()
























sns.barplot(x='Weekday', y='Cases_Received', data=weekday_summary, x_order=['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'])



sns.factorplot(x='Weekday', y='Cases_Received', 
    col='Warehouse', data=weekday_summary, 
    x_order=['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'],
    size=12, kind='bar')




plt.subplots_adjust(top=0.9)
# CASES RECEIVED BOXPLOTS
sns.factorplot(x='Weekday', y='Cases_Received', 
    col='Warehouse', data=summary, 
    x_order=['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'],
    size=12, kind='box')

sns.factorplot(x='Month', y='Cases_Received', 
    col='Warehouse', data=summary, 
    size=12, kind='box')



# PO LINES RECEIVED BOXPLOTS
g = sns.factorplot(x='Weekday', y='PO_&_Line_Number', 
    col='Warehouse', data=summary, 
    x_order=['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'],
    size=12, kind='box')
g.fig.suptitle('Daily Receipts of PO Lines, Grouped by Weekday Received')

g = sns.factorplot(x='Month', y='PO_&_Line_Number', 
    col='Warehouse', data=summary, 
    size=12, kind='box')
g.fig.suptitle('Daily Receipts of PO Lines, Grouped by Month Received')




# CASES PER PO LINE RECEIVED BOXPLOTS
g = sns.factorplot(x='Weekday', y='CasesPerPOLine', 
    col='Warehouse', data=summary, 
    x_order=['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'],
    size=12, kind='box')
g.fig.suptitle('Daily Receipts (Cases per PO Line), Grouped by Weekday Received')
g.fig.get_axes()[0].set_yscale('log')

g = sns.factorplot(x='Month', y='CasesPerPOLine', 
    col='Warehouse', data=summary, 
    size=12, kind='box')
g.fig.suptitle('Daily Receipts (Cases per PO Line), Grouped by Month Received')



# look at relationships
sns.pairplot(summary[['Warehouse','Month','PO_&_Line_Number','Cases_Ordered','Weight','Ext_Cost','Cases_Received','CasesPerPOLine']], hue='Warehouse', size=1)



weekday_summary.head()
summary.head()





g = sns.FacetGrid(weekday_summary, col='Weekday', row='Warehouse')
g = g.map(sns.barplot,'Cases_Received')



sns.factorplot(x='Weekday', y='PO_&_Line_Number', kind='bar',
    hue='Weekday', col='Warehouse', size=8, aspect=0.8, data=weekday_summary)

summary.head()
weekday_summary.plot(kind='bar', by=['Warehouse', 'Weekday'], subplots=True, figsize=(10,15))


weekday_summary.dtypes








summary.to_excel('C:/Users/pmwash/Desktop/Re-Engineered Reports/PO Lines/Summary By Month & Warehouse.xlsx', sheet_name='Summary')
