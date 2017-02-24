
# coding: utf-8

# In[1]:

'''
Analysis of A and B Products
Ad Hoc Request Steve Lewis
Before and after switch from layered to full pallet
Jan 1 - Dec 27 2016

Input data for A/B products from Steve L.
Inbound shipment data from pw_polines AS400
YTD Sales data from ytd_prod

Data transferred into a CSV
from Transfer Add In, outside of Excel
'''
get_ipython().magic('matplotlib inline')
import pandas as pd
import numpy as np
from datetime import datetime as dt
import datetime
import re

pd.set_option('display.float_format', lambda x: '%.3f' % x)

path = 'C:/Users/pmwash/Desktop/Re-Engineered Reports/Ad Hoc/Purchasing/Full Pallet v Layered/'

## Daily Sales by Product for Aggregating up to Weekly
def generate_pw_ytdpwar(path):
    '''This is a huge file, so this function makes it manageable '''
    def as400_date(dat):
        try:
            d = dt.date(dt.strptime(dat[-6:], '%y%m%d'))
        except ValueError:
            d = dt.date(dt.strptime('1990909', '%y%m%d'))
        return d
    ## Generate the dataframe from messy data
    pw_ytdpwar = pd.read_csv(path + 'pw_ytdpwar Jan - Dec 2016.csv', header=None)
    l = [re.sub(' +',',',STRING) for STRING in pw_ytdpwar[0].astype(str)]
    pw_ytdpwar = pd.DataFrame([sub.split(',') for sub in l]); del l
    pw_ytdpwar.rename(columns={0:'X',1:'Date',2:'ProductId',3:'Sales',4:'SalesCount',5:'SalesCases'}, inplace=True)
    
    ## Clean up data, get rid of break points
    pw_ytdpwar = pw_ytdpwar[pw_ytdpwar['Date'].astype(str).str.len() == 7]
    pw_ytdpwar['Warehouse'] = [P[-1:] for P in pw_ytdpwar.ProductId.astype(str)]
    pw_ytdpwar = pw_ytdpwar[['Date','Warehouse','ProductId','Sales','SalesCases','SalesCount']]
    coerce_numeric = lambda x: pd.to_numeric(x, errors='coerce')
    pw_ytdpwar.Sales = pw_ytdpwar.Sales.apply(coerce_numeric)
    pw_ytdpwar.SalesCases = pw_ytdpwar.SalesCases.apply(coerce_numeric)
    pw_ytdpwar.SalesCount = pw_ytdpwar.SalesCount.apply(coerce_numeric)
    pw_ytdpwar.Warehouse = pw_ytdpwar.Warehouse.astype(str)    
    pw_ytdpwar.Warehouse = pw_ytdpwar.Warehouse.map({'1':'Kansas City','2':'Saint Louis','3':'Saint Louis','5':'Kansas City'})
    pw_ytdpwar.ProductId = [P[:-1] for P in pw_ytdpwar.ProductId.apply(coerce_numeric).astype(str)]
    
    ## Extract date and related features
    pw_ytdpwar.Date = [as400_date(dat) for dat in pw_ytdpwar.Date.astype(str).tolist()]
    dat = pw_ytdpwar.Date 
    pw_ytdpwar['Year'] = [d.strftime('%Y') for d in dat]
    pw_ytdpwar['Month'] = [d.strftime('%B') for d in dat]
    pw_ytdpwar['Weekday'] = [d.strftime('%A') for d in dat]
    pw_ytdpwar['DOTY'] = [d.strftime('%j') for d in dat]
    pw_ytdpwar['WeekNumber'] = [d.strftime('%U') for d in dat]
    pw_ytdpwar['DOTM'] = [d.strftime('%d') for d in dat]
    
    ## Filter
    pw_ytdpwar = pw_ytdpwar[pw_ytdpwar.ProductId != '']
    print(pw_ytdpwar.head(20))
    
    return pw_ytdpwar


grp_cols = ['Warehouse','ProductId','WeekNumber']
weekly_sales_sku_whse = generate_pw_ytdpwar(path).groupby(grp_cols).agg({'Sales':np.sum,'SalesCases':np.sum,'SalesCount':np.sum})
weekly_sales_sku_whse = weekly_sales_sku_whse.reset_index(drop=False)
weekly_sales_sku_whse.head()
#weekly_sales_sku_whse.to_csv('C:/Users/pmwash/Desktop/Disposable Docs/CHECK SKUS.csv')


# In[2]:

def read_pw_polines():
    path = 'C:/Users/pmwash/Desktop/Re-Engineered Reports/Ad Hoc/Purchasing/Full Pallet v Layered/'
    pw_polines = pd.read_csv(path + 'pw_polines 01012016 through 12272016.csv', 
                header=0, 
                dtype={'UDPO#':np.int64, 'UDLIN#':np.int64, 'UDDRC1':str, 'UDPRD#':np.int64,
                        'UDSUPP':np.int64, 'QTYREC':np.float64, 'UDFOB':np.float64, 'UDTOQ':str,
                        'EXT_COST':np.float64, 'UDCOMP':np.int64, 'UDSCC':str, 'Cases_Received':np.float64,
                        'UDWHSE':str, 'UDWGT':np.float64, 'UDBRAN':np.int64, 'UDQPC':np.int64})
    pw_polines.rename(columns={'UDPO#':'PO_Number', 'UDLIN#':'Line_Number', 'UDDRC1':'Date_Received', 'UDPRD#':'ProductId',
                        'UDSUPP':'SupplierId','QTYREC':'Qty_Received', 'EXT_COST':'Ext_Cost', 'UDCOMP':'Warehouse', 
                        'UDSCC':'Ship_Container_Code', 'UDWGT':'Weight', 'UDFOB':'FOB', 'UDTOQ':'Case_or_Btl',
                        'UDQPC':'QPC', 'UDBRAN':'BrandId', 'Cases_Received':'Cases_Received'}, inplace=True)
    return pw_polines

def read_pw_palsize():
    path = 'C:/Users/pmwash/Desktop/Re-Engineered Reports/Ad Hoc/Purchasing/Full Pallet v Layered/'
    pw_palsize = pd.read_csv(path + 'pw_palsize.csv', 
                             header=0)# dtype={'PPROD#':np.int64, 'PPALSZ':np.int64, 'PTIE':np.int64,'PTIER':np.int64, 'PSIZE@':str, 'PCLAS@':str})
    pw_palsize.rename(columns={'PPROD#':'ProductId', 'PPALSZ':'Cases_per_Pallet', 'PTIE':'Ties', 
                               'PTIER':'Tiers', 'PSIZE@':'Size_Code', 'PCLAS@':'Class_Code',
                               '#SSUNM':'Supplier_Name', '#STATE':'Supplier_State'}, inplace=True)
    pw_palsize.ProductId = pw_palsize.ProductId.astype(str) 
    return pw_palsize

def summarize_po_lines_byweek():
    '''Cleans raw query pw_polines for merge'''
    pw_polines = read_pw_polines()

    def as400_date(dat):
        '''Accepts list of dates as strings from theAS400'''
        try:
            dat = dt.date(dt.strptime(dat[-6:], '%y%m%d'))
        except ValueError:
            dat = dt.date(dt.strptime('1990909', '%y%m%d'))
        return dat
    
    ## Get dates in order
    pw_polines.Warehouse = pw_polines.Warehouse.map({1:'Kansas City', 2:'Saint Louis'})
    pw_polines.Date_Received = dat = [as400_date(d) for d in pw_polines.Date_Received.astype(str)]
    pw_polines['Year'] = [d.strftime('%Y') for d in dat]
    pw_polines['WeekNumber'] = [d.strftime('%W') for d in dat]
    
    ## Distinguishing between cases and bottles - setting their values
    CS, BTL, QPC = pw_polines.loc[pw_polines['Case_or_Btl'] == 'C', 'Qty_Received'].astype(np.float64), pw_polines.loc[pw_polines['Case_or_Btl'] == 'B', 'Qty_Received'].astype(np.float64), pw_polines.loc[pw_polines['Case_or_Btl'] == 'B', 'QPC'].astype(np.float64)
    pw_polines.loc[pw_polines['Case_or_Btl'] == 'C', 'Cases_Received'] = CS
    pw_polines.loc[pw_polines['Case_or_Btl'] == 'B', 'Cases_Received'] = np.divide(BTL, QPC)
    
    ## Pallet merge 
    PALLETS = read_pw_palsize()
    pw_polines = pw_polines.merge(PALLETS, on='ProductId', how='left')

    ## Concatenate line to po number for counting unique values
    pw_polines['PO_&_Line_Number'] = pw_polines.PO_Number.astype(str) +'.'+ pw_polines.Line_Number.astype(str)
    pw_polines['PO_&_Line_Number'] = pw_polines['PO_&_Line_Number'].apply(pd.to_numeric)
    
    ## Group by week number for merge
    grp_cols = ['Warehouse','ProductId','WeekNumber']
    byweek = pw_polines.groupby(grp_cols)['PO_&_Line_Number'].nunique()
    byweek = pd.DataFrame(byweek).reset_index(drop=False)
    byweek = byweek.merge(pd.DataFrame(pw_polines.groupby(grp_cols)['PO_Number'].nunique()).reset_index(drop=False), on=grp_cols)
    byweek = byweek.merge(pd.DataFrame(pw_polines.groupby(grp_cols)['Cases_Received'].sum()).reset_index(drop=False), on=grp_cols)

    byweek.ProductId = byweek.ProductId.astype(str) 
    byweek = byweek.merge(PALLETS, on='ProductId', how='left')
    byweek.loc[byweek['Cases_per_Pallet'] > 0, 'Full_Pallets'] = np.divide(byweek['Cases_Received'], byweek['Cases_per_Pallet'])
    byweek.loc[byweek['Cases_per_Pallet'] == 0, 'Full_Pallets'] = np.divide(byweek['Cases_Received'], byweek['Cases_per_Pallet'].mean())
    byweek.loc[byweek['Tiers'] > 0, 'Pallet_Levels'] = np.divide(byweek['Cases_Received'], byweek['Tiers'])
    byweek.loc[byweek['Tiers'] == 0, 'Pallet_Levels'] = np.divide(byweek['Cases_Received'], byweek['Tiers'].mean())
    
    ## Set index & prepare for output
    byweek = byweek[byweek['Cases_per_Pallet'] > 0]
    byweek.set_index(['Warehouse','Supplier_Name','ProductId','WeekNumber'], inplace=True)
    byweek.sort_index(inplace=True)
    byweek.reset_index(inplace=True, drop=False)
    
    return byweek


weekly_inbound = summarize_po_lines_byweek()
print(weekly_inbound.head())


# In[3]:

def read_abitems():
    path = 'C:/Users/pmwash/Desktop/Re-Engineered Reports/Ad Hoc/Purchasing/Full Pallet v Layered/'
    ab_items = pd.read_csv(path + 'AB Items.csv', header=0)
    ab_items.rename(columns={'PPROD#':'ProductId', 'PDESC':'Product', '#SRNAM':'Supplier', 'PMONI':'AB', 'Increases':'FullPalletIncrease'}, inplace=True)
    ab_items.FullPalletIncrease = ab_items.FullPalletIncrease.map({'XX':'Both Warehouses', 'X':'One Warehouse'})
    ab_items.ProductId = ab_items.ProductId.astype(str)
    return ab_items

def generate_weeks():
    DAT = pd.date_range('1/1/2016', periods=366, freq='D')
    WK = [d.strftime('%U') for d in DAT]
    MO = [d.strftime('%B') for d in DAT]

    DAYZ = pd.DataFrame({'Date':DAT, 'WeekNumber':WK, 'Month':MO})
    DAYZ.loc[DAYZ.Month.isin(['May','June','July']), 'Pre-Post Policy Chg'] = 'Split Pallet'
    DAYZ.loc[DAYZ.Month.isin(['September','October','November']), 'Pre-Post Policy Chg'] = 'Full Pallet'
    DAYZ.loc[DAYZ.WeekNumber.isin(['31','32','33','34','35']), 'Pre-Post Policy Chg'] = 'TRANSITION PERIOD'

    DAYZ.loc[DAYZ.WeekNumber.isin(['00','01','02','03','04','05','06','07','08','09','50','51','52','53']), 'Season'] = 'Winter'
    DAYZ.loc[DAYZ.WeekNumber.isin(['10','11','12','13','14','15','16','17','18','19','20','21','22']), 'Season'] = 'Spring'
    DAYZ.loc[DAYZ.WeekNumber.isin(['23','24','25','26','27','28','29','30','31','32','33','34','35']), 'Season'] = 'Summer'
    DAYZ.loc[DAYZ.WeekNumber.isin(['36','37','38','39','40','41','42','43','44','45','46','47','48','49']), 'Season'] = 'Autumn'

    DAYZ.drop_duplicates(['WeekNumber','Pre-Post Policy Chg'], inplace=True)
    DAYZ.drop(labels='Date', axis=1, inplace=True)
    DAYZ.reset_index(drop=True, inplace=True)
    
    return DAYZ


# In[4]:

print('Weeks\n', generate_weeks().head(), '\n\n')
print('AB Items\n', read_abitems().head(), '\n\n')
print('Weekly Inbound\n', weekly_inbound.head(), '\n\n')
print('Weekly Sales\n', weekly_sales_sku_whse.head())


# In[5]:

def merge_datasets(weekly_sales, weeks, weekly_inbound, ab_items):
    
    WKLY = weekly_inbound.copy()
    
    ## Extract features before imputing weeks w/o data
    WKLY['ReceivedThisWeek'] = WKLY['Cases_Received'] > 0
    grp_cols = ['Warehouse','ProductId']
    WKLY['WeeksThisYearReceived'] = WKLY.groupby(grp_cols)['ReceivedThisWeek'].apply(pd.rolling_sum, 52, min_periods=1)
    WKLY['WeeksSinceLastReceipt'] = np.subtract(WKLY.WeekNumber.astype(int), WKLY.WeekNumber.astype(int).shift())
    WKLY['WeeksSinceLastReceipt'] = [val if val >=0 else week for val,week 
                                     in zip(WKLY['WeeksSinceLastReceipt'], WKLY['WeekNumber'].astype(int)) ]
    #WKLY.WeekNumber = WKLY.WeekNumber.astype(str)
    
    ## Sort before imputing weeks for subtracting last item
    WKLY.sort_values(['Warehouse','Supplier_Name','ProductId','WeekNumber'], inplace=True)
    WKLY.set_index(['Warehouse','Supplier_Name','ProductId','WeekNumber'], inplace=True)
    
    def impute_weeks(WKLY):
        TO_STACK = ['Size_Code','Class_Code','Supplier_State']
        W_strings = WKLY[TO_STACK].unstack('WeekNumber').fillna(method='bfill')
        W_strings = W_strings.stack('WeekNumber')
        
        QCOLS = ['Cases_Received','Full_Pallets','Pallet_Levels','PO_&_Line_Number','PO_Number',
                'ReceivedThisWeek','WeeksThisYearReceived','WeeksSinceLastReceipt']
        W_quants = WKLY[QCOLS].unstack('WeekNumber').fillna(0)
        W_quants = W_quants.stack('WeekNumber')

        W = W_quants.join(W_strings)
        W.reset_index(drop=False, inplace=True)

        return W
    
    WKLY = impute_weeks(WKLY)
    
    ## Map values form Steve & select B only items
    AB = read_abitems()
    ab_dict, pal_dict = dict(zip(AB.ProductId, AB.AB)), dict(zip(AB.ProductId, AB.FullPalletIncrease)) 
    pro_dict = dict(zip(AB.ProductId, AB.Product))
    WKLY['AB'] = WKLY.ProductId.map(ab_dict)
    WKLY['FullPalletIncrease'] = WKLY.ProductId.map(pal_dict)
    WKLY['Product'] = WKLY.ProductId.map(pro_dict)
    WKLY = WKLY[WKLY['AB'].isin(['A','B'])]

    WKLY = WKLY.merge(weekly_sales, how='left', 
                      right_on=['Warehouse','ProductId','WeekNumber'],
                      left_on=['Warehouse','ProductId','WeekNumber'])
    WKLY = WKLY.merge(weeks, on='WeekNumber', how='outer')
    ordered_cols = ['Warehouse','WeekNumber','Supplier_Name','ProductId','Product','AB',
                   'Sales','SalesCases','Cases_Received','SalesCount','Full_Pallets','Pallet_Levels',
                   'Month','Season','Pre-Post Policy Chg','FullPalletIncrease','PO_&_Line_Number','PO_Number',
                   'ReceivedThisWeek','WeeksThisYearReceived','WeeksSinceLastReceipt','Class_Code','Size_Code']
    WKLY = WKLY[ordered_cols]
    WKLY.sort_values(['Warehouse','ProductId','WeekNumber'], inplace=True)
    WKLY.reset_index(drop=True, inplace=True)
    
    WKLY['CasesPerSale'] = np.divide(WKLY['SalesCases'], WKLY['SalesCount'])
    WKLY['WeeksBetweenReceipts'] = [val if val >=0 else 0 for val in WKLY['WeeksSinceLastReceipt']]
    WKLY = WKLY[WKLY.Supplier_Name.astype(str) != 'NaN']
    
    
    WKLY.sort_values(['Warehouse','ProductId','WeekNumber'], inplace=True)
    WKLY.set_index(['Warehouse','Supplier_Name','ProductId','Product','WeekNumber'], inplace=True)
    WKLY.reset_index(drop=False, inplace=True)
    WKLY.fillna(0, inplace=True)
    
    return WKLY


WEEKLY = merge_datasets(weekly_sales=weekly_sales_sku_whse, weeks=generate_weeks(), 
               weekly_inbound=weekly_inbound, ab_items=read_abitems())
print(WEEKLY.tail())
print(WEEKLY.columns)


#WEEKLY.reset_index(drop=False).to_excel('C:/Users/pmwash/Desktop/Disposable Docs/CHECK MERGED DATASET.xlsx', sheet_name='CHECK')


# In[6]:

def enrich_dataset(WEEKLY):
    GRP_COLS = ['Warehouse','ProductId']
    grouped_dfs = WEEKLY.groupby(GRP_COLS)
    grouped_dfs = [grouped_dfs.get_group(df) for df in grouped_dfs.groups]
    
    cols = ['Cases_Received','SalesCases','SalesCount','WeeksBetweenReceipts']
    for df in grouped_dfs:
        df[[c+'_YTD' for c in cols]] = df[cols].cumsum()
        df[[c+'_ZScore' for c in cols]] = (df[cols] - df[cols].mean()) / df[cols].std(ddof=0)
        df[[c+'_4WeekAvg' for c in cols]] = df[cols].apply(pd.rolling_mean, window=4, min_periods=1)
        df[[c+'_8WeekAvg' for c in cols]] = df[cols].apply(pd.rolling_mean, window=8, min_periods=1)
        df[[c+'_4WeekSum' for c in cols]] = df[cols].apply(pd.rolling_sum, window=4, min_periods=1)
        df[[c+'_8WeekSum' for c in cols]] = df[cols].apply(pd.rolling_sum, window=8, min_periods=1)
        df[[c+'_4WeekStdDev' for c in cols]] = df[cols].apply(pd.rolling_std, window=4, min_periods=1)
        df[[c+'_8WeekStdDev' for c in cols]] = df[cols].apply(pd.rolling_std, window=8, min_periods=1)
    
    WEEKLY = pd.concat(grouped_dfs)
    
    product_class_map = {10:'Liquor', 25:'Spirit Coolers', 50:'Wine', 51:'Fine Wine', 53:'Keg Wine',
                        55:'Sparkling Wine & Champagne', 58:'Package Cider', 59:'Keg Cider', 70:'Wine Coolers',
                        80:'Malt Coolers/3.2 Beer', 84:'High-Alcohol Malt', 85:'Beer', 86:'Keg Beer', 
                        87:'Keg Beer w/ Deposit', 88:'High Alcohol Kegs', 90:'Water/Soda', 91:'Other Non-Alcoholic',
                        92:'Red Bull', 95:'Taxable Items - On Premise', 99:'Miscellaneous'}

    WEEKLY.Class_Code = WEEKLY.Class_Code.map(product_class_map)
    WEEKLY['YTD_CasesReceived_over_CasesSold'] = np.divide(WEEKLY.Cases_Received_YTD, WEEKLY.SalesCases_YTD)
    WEEKLY['ReceivedThisWeek'] = WEEKLY['ReceivedThisWeek'].astype(int) 
    
    return WEEKLY

WEEKLY = enrich_dataset(WEEKLY)
#WEEKLY.reset_index(drop=False).to_excel('C:/Users/pmwash/Desktop/Disposable Docs/CHECK MERGED DATASET.xlsx', sheet_name='CHECK')
print(WEEKLY.head())


# In[7]:

## WRITE TO FILE
WEEKLY.reset_index(drop=False).to_excel('C:/Users/pmwash/Desktop/Disposable Docs/NEWEST MERGED DATASET.xlsx', sheet_name='CHECK')


# In[8]:

from bokeh.charts import Histogram, output_file, show
h2 = Histogram(WEEKLY, values='CasesPerSale', label='Class_Code', color='Class_Code', title='Test Histogram', 
               plot_width=1100, plot_height=900)
show(h2)


# In[9]:

from ggplot import *

ggplot(WEEKLY, aes(x='WeekNumber', y='Cases_Received')) + geom_line()


# In[10]:

from bokeh.charts import BoxPlot

B1 = BoxPlot(WEEKLY, values='Cases_Received', label='Pre-Post Policy Chg',
            title='Daily Cases Received Measured at SKU Level, Grouped by Supplier', 
            plot_width=1300, plot_height=900)
show(B1)
output_file('V:\\Washburn\\Operations Research\\Inbound Shipments\\Plots\\Daily Cases Received by Supplier.html')


# In[ ]:

import seaborn as sns
import matplotlib.pyplot as plt
sns.set(style='white')
sns.set()

g = sns.pairplot(WEEKLY[['SalesCases_8WeekAvg','SalesCount_8WeekAvg','Cases_Received_8WeekAvg','CasesPerSale_8WeekAvg']])
g.map_lower(sns.kdeplot, cmap='Blues_d')
g.map_upper(plt.scatter)
g.map_diag(sns.kdeplot, lw=3)


# In[ ]:

grp_cols = ['Warehouse','Supplier_Name','Product','ProductId']
temp = pd.DataFrame(WEEKLY.groupby(grp_cols).agg({np.sum, np.mean, np.std})).reset_index(drop=False)
print(temp.head())
#temp.to_csv('C:/Users/pmwash/Desktop/Disposable Docs/AGGREGATED.csv'); del temp


# In[ ]:

from sklearn import linear_model
from sklearn.metrics import r2_score
from sklearn.dummy import DummyClassifier
from matplotlib import pyplot as plt

the_sums = pd.DataFrame(WEEKLY.groupby(grp_cols).agg({np.mean})).reset_index(drop=False)

model = linear_model.LinearRegression()
X = the_sums[['SalesCases','WeeksBetweenReceipts']] #'SalesCount','Supplier_Name'
Y = the_sums[['Cases_Received']]
model.fit(X, Y)
Y_predict = model.predict(X)

print('Coefficients: \n', model.coef_)

print("Mean squared error: %.2f"
      % np.mean((model.predict(X) - Y) ** 2))

print('Variance score: %.2f' % model.score(X, Y))

print(the_sums.head())
print('R-squared = %.3f' % r2_score(Y, Y_predict))

plt.yscale('log')
plt.scatter(the_sums.WeeksBetweenReceipts, the_sums.SalesCases, color='black')

