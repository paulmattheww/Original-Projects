
# coding: utf-8

# In[1]:

import pandas as pd
import numpy as np
import glob
import string
import re
from datetime import datetime as dt
import datetime
get_ipython().magic('matplotlib inline')


# In[2]:

path = 'C:\\Users\\pmwash\\Desktop\\Wal Mart\\Out of Stocks\\Raw Data\\*csv'

def integrate_walmart_data(path):
    '''
    Accepts a list of files containing spirits data from Walmart
    Returns all the files cleaned up and ready for combining
    Save input files for the MONDAY AFTER the week the data was gathered
    '''
    all_files = glob.glob(path)
    spirits = [file for file in all_files if 'Spirits' in file]
    wine = [file for file in all_files if 'Wine' in file]
    
    spirit_ls, spirits_df = [], pd.DataFrame()
    colnames = ['Store','City','State','Store Type','Buyer','Region','UPC','Item Description','Brand',
               'Size','Supplier','Distributor','Sat','Sun','Mon','Tue','Wed','Thu','Fri','Total OOS',
               'OOS $ Impact']
    no_punct = lambda x: ''.join([i for i in x if i not in string.punctuation])

    for file in spirits:
        print('Reading in file %s' %file)
        df = pd.read_csv(file, header=0, names=colnames)
        df.Brand = df.Brand.apply(no_punct)
        df.Store = df.Store.astype(str)
        df.UPC = df.UPC.astype(str)
        
        ## Get date from file name
        get_date = lambda dat: re.split(r'OOS ',re.split(r'.csv', dat)[0])[1]
        df['Date Sent'] = dat = dt.strptime(get_date(file), '%m%d%Y')
        df['Weekday Sent'] = format(dat, '%A')
        
        ## Clean up inconsistently specified store type data
        df['Store Type'] = [re.sub('BASE STR', '', s.upper()) for s in df['Store Type'].astype(str).tolist()]
        df['Store Type'] = [re.sub('-', '', s) for s in df['Store Type'].astype(str).tolist()]
        df['Store Type'] = [re.sub(' ','',s) for s in df['Store Type']]
        df['Store Type'] = [re.sub('NGHBRHDMKT','NEIGHBORHOODMARKET',s) for s in df['Store Type']]
        
        ## Unstack the weekdays so they are rows not cols
        identifiers = ['Date Sent','Weekday Sent','Store','City','State','Store Type','Buyer',
                       'Region','UPC','Item Description','Brand','Size','Supplier','Distributor',
                       'Total OOS','OOS $ Impact']
        df.set_index(identifiers, inplace=True)
        df = pd.DataFrame(df.stack()).reset_index(drop=False)
        df.rename(columns={'level_16':'Weekday', 0:'OOS'}, inplace=True)
        
        ## Get date of observation (not same as file) 
        wday_sent = int(format(dat, '%w'))
        df.loc[df.Weekday == 'Mon', 'Date'] = dat - pd.offsets.Day(7)
        df.loc[df.Weekday == 'Tue', 'Date'] = dat - pd.offsets.Day(6)
        df.loc[df.Weekday == 'Wed', 'Date'] = dat - pd.offsets.Day(5)
        df.loc[df.Weekday == 'Thu', 'Date'] = dat - pd.offsets.Day(4)
        df.loc[df.Weekday == 'Fri', 'Date'] = dat - pd.offsets.Day(3)
        df.loc[df.Weekday == 'Sat', 'Date'] = dat - pd.offsets.Day(2)
        df.loc[df.Weekday == 'Sun', 'Date'] = dat - pd.offsets.Day(1)
        df['Weekday'] = [format(dat, '%A') for dat in df.Date]
        df['DOTM'] = [format(dat, '%d') for dat in df.Date]
        df['Week'] = [format(dat, '%U') for dat in df.Date]
        
        ## Make it more readable
        df.drop(['Date Sent','Weekday Sent','Total OOS','OOS $ Impact','Distributor','State'], axis=1, inplace=True)
        keep_cols = ['Date','Weekday','Week','DOTM','Region','Store','OOS',
                     'Supplier','Brand','Item Description','Size','UPC','City',
                     'Store Type']
        df = df[keep_cols]
        df.sort_values(['Date','Store'], inplace=True)
        df.reset_index(drop=True, inplace=True)

        spirits_df = spirits_df.append(df)
        
    return spirits_df

walmart_clean = integrate_walmart_data(path)
print(walmart_clean.tail())


# In[3]:

def aggregate_walmart_data(walmart_clean):
    grp_cols = ['Store','UPC','Supplier','Brand','Item Description','Size']
    walmart_oos_sums = pd.DataFrame(walmart_clean.groupby(grp_cols)['OOS'].sum()).reset_index(drop=False)
    return walmart_oos_sums

print(aggregate_walmart_data(walmart_clean).head())


# In[4]:

def munge_walmart_dive():
    walmart_dive = pd.read_csv('C:\\Users\\pmwash\\Desktop\\Wal Mart\\Out of Stocks\\Raw Data\\Wal Mart Dive YTD Sales.csv', 
                            header=0)
    no_punct = lambda x: ''.join([i for i in x if i not in string.punctuation])
    
    ## Keep only positive dollar days
    walmart_dive = walmart_dive[walmart_dive.Dollars > 0]
    
    ## Format dates & get frequencies
    walmart_dive['Invoice Date'] = dat = [dt.strptime(dat,'%m/%d/%Y') for dat in walmart_dive['Invoice Date'].astype(str)]
    first_day = dt.strptime(str(min(walmart_dive['Invoice Date'])), '%Y-%m-%d %H:%M:%S')
    same_cust = walmart_dive['Customer ID']==walmart_dive['Customer ID'].shift()
    same_prod = walmart_dive['Product ID']==walmart_dive['Product ID'].shift()
    diff_cust = walmart_dive['Customer ID']!=walmart_dive['Customer ID'].shift()
    diff_prod = walmart_dive['Product ID']!=walmart_dive['Product ID'].shift()
    walmart_dive.loc[same_cust & same_prod,'Days Since Order'] = np.subtract(walmart_dive['Invoice Date'], walmart_dive['Invoice Date'].shift())
    walmart_dive.loc[diff_cust | diff_prod,'Days Since Order'] = walmart_dive['Invoice Date'] - first_day
    walmart_dive['Days Since Order'] = [days if days > datetime.timedelta(days=0) else 'NaT' for days in walmart_dive['Days Since Order']]
    
    ## Feature Engineering
    walmart_dive['GP $'] = np.subtract(walmart_dive['Dollars'], walmart_dive['Costs'])
    walmart_dive['Mark Up'] = np.divide(walmart_dive['GP $'], walmart_dive['Costs'])
    
    ## Extract Wal Mart's store number (not ours) from name of wal mart
    walmart_dive['Wal Mart Store Number'] = [re.findall(r'#\d+', s) for s in walmart_dive['Customer']]
    walmart_dive['Wal Mart Store Number'] = walmart_dive['Wal Mart Store Number'].apply(lambda x: [re.sub('#','',s) for s in x])
    walmart_dive['Wal Mart Store Number'] = walmart_dive['Wal Mart Store Number'].apply(no_punct)
    walmart_dive['Wal Mart Store Number'] = walmart_dive['Wal Mart Store Number'].astype(int)
    walmart_dive['Wal Mart Store Number'] = walmart_dive['Wal Mart Store Number'].astype(str)
    
    ## Get all dates not just those shown
    str_cols = ['Customer','Customer ID','Customer Address','Customer Zipcode','Product','Product Type',
               'Invoice Date', 'Product ID','Wal Mart Store Number']
    walmart_dive.set_index(str_cols, inplace=True)
    numcols = ['Days Since Order','Dollars','Costs','NonStd Cases','GP $','Mark Up']
    walmart_dive = walmart_dive[numcols].unstack('Invoice Date').fillna(0)
    walmart_dive = walmart_dive.stack('Invoice Date')
    walmart_dive.reset_index(drop=False, inplace=True)
    walmart_dive.set_index(['Customer ID','Invoice Date','Product ID'], inplace=True)
    walmart_dive.sortlevel(axis=0, inplace=True)
    walmart_dive = walmart_dive[walmart_dive['Days Since Order'] > datetime.timedelta(days=0)]
    walmart_dive.reset_index(drop=False, inplace=True)
    
    return walmart_dive

walmart_receipts = munge_walmart_dive()
print(walmart_receipts.head())


# In[5]:

def aggregate_walmart(walmart_receipts):
    ## Extract some knowledge
    grp_cols = ['Customer ID','Wal Mart Store Number','Customer','Product ID']
    aggregated_walmart = pd.DataFrame(walmart_receipts.groupby(grp_cols)['Invoice Date'].nunique()).reset_index(drop=False)

    ## Split, aggregate, apply, combine
    quant_cols = ['Dollars','Costs','NonStd Cases','GP $']
    agg_quant_wm = pd.DataFrame(walmart_receipts.groupby(grp_cols)[quant_cols].sum()).reset_index(drop=False)
    aggregated_walmart = aggregated_walmart.merge(agg_quant_wm, on=grp_cols, how='outer')
    aggregated_walmart.rename(columns={'Invoice Date':'Number of Orders'}, inplace=True)
    agg_mean = pd.DataFrame(walmart_receipts.groupby(grp_cols)[['Mark Up']].mean()).reset_index(drop=False)
    aggregated_walmart = aggregated_walmart.merge(agg_mean, on=grp_cols, how='outer')

    ## Finesse timedelta object to int then back again 
    df = walmart_receipts.copy()
    df['Days Since Order'] = df['Days Since Order'].astype('int64')
    df = df[['Customer ID','Wal Mart Store Number','Customer','Product ID','Days Since Order']]
    agg_td_mean = pd.DataFrame(df.groupby(grp_cols).mean()).reset_index(drop=False)
    agg_td_mean['Days Since Order'] = pd.to_timedelta(agg_td_mean['Days Since Order'], unit='ns') 
    aggregated_walmart = aggregated_walmart.merge(agg_td_mean, on=grp_cols, how='outer')
    aggregated_walmart.rename(columns={'Days Since Order':'Avg Days Between Orders'}, inplace=True)
    
    #aggregated_walmart.set_index(grp_cols, inplace=True)
    
    return aggregated_walmart

agg_walmart_receipts = aggregate_walmart(walmart_receipts)
print(agg_walmart_receipts.head())


# In[6]:

def merge_walmart_diver_upc(agg_walmart_receipts, walmart_clean):
    botupc = pd.read_csv('C:\\Users\\pmwash\\Desktop\\Wal Mart\\Out of Stocks\\Raw Data\\botupc.csv', 
                     header=0, 
                     names=['ProductId','UPC'],
                     dtype={'ProductId':int,'UPC':str})
    botupc['UPC'] = botupc.UPC.str.strip()
    botupc['UPC'] = [s[:-1] for s in botupc['UPC']]

    oos_from_walmart = aggregate_walmart_data(walmart_clean)
    oos_from_walmart.UPC = oos_from_walmart.UPC.astype(str)
    oos_from_walmart['UPC'] = oos_from_walmart.UPC.str.strip()

    upc_dict = dict(zip(botupc['ProductId'], botupc['UPC']))
    agg_walmart_receipts['UPC'] = agg_walmart_receipts['Product ID'].map(upc_dict)
    agg_walmart_receipts['Customer ID'] = agg_walmart_receipts['Customer ID'].astype(int)
    agg_walmart_receipts['Customer ID'] = agg_walmart_receipts['Customer ID'].astype(str)
    
    ## Merge data sets
    combined = oos_from_walmart.merge(agg_walmart_receipts, 
                                      left_on=['Store','UPC'], 
                                      right_on=['Wal Mart Store Number','UPC'],
                                      how='inner')
    combined.set_index(['Customer','Customer ID','Store','Supplier','UPC','Product ID','Brand','Item Description'], inplace=True)
    combined.drop(labels=['Wal Mart Store Number'], axis=1, inplace=True)
    combined.Size = [re.sub('[^0-9]','',s) for s in combined.Size]
    combined.reset_index(drop=False, inplace=True)
    
    return combined

MAIN_DF = merge_walmart_diver_upc(agg_walmart_receipts, walmart_clean)
print(MAIN_DF.tail())


# In[7]:

def engineer_features(MAIN_DF):
    '''Uses existing data to enrich the combined dataset'''
    MAIN_DF['Avg Cases per Order'] = np.divide(MAIN_DF['NonStd Cases'], MAIN_DF['Number of Orders'])
    MAIN_DF['Avg GP$ per Order'] = np.divide(MAIN_DF['GP $'], MAIN_DF['Number of Orders'])
    MAIN_DF['Avg OOS per Order'] = np.divide(MAIN_DF['OOS'], MAIN_DF['Number of Orders'])
    MAIN_DF['Avg Days Between Orders - Numeric'] = MAIN_DF['Avg Days Between Orders'].astype(str)
    MAIN_DF['Avg Days Between Orders - Numeric'] = [int(s[:2]) for s in MAIN_DF['Avg Days Between Orders - Numeric']]
    
    return MAIN_DF

print(engineer_features(MAIN_DF).head())


# In[22]:

import matplotlib.pyplot as plt
get_ipython().magic('matplotlib inline')
fsz = (12,6)

oos_by_store = np.divide(MAIN_DF.groupby('Store')['OOS'].sum(), MAIN_DF.groupby('Store')['Dollars'].sum())
oos_by_store.sort_values(ascending=False, inplace=True)
oos_by_store.plot(x='Store', y='OOS', 
                  kind='bar', 
                  figsize=(17,6), 
                  title='Out of Stocks per Dollar Sold @ Store Level',
                 )

MAIN_DF.plot(x='Avg Days Between Orders - Numeric', y='Avg Cases per Order', kind='scatter', figsize=fsz)
MAIN_DF.plot(x='Avg Days Between Orders - Numeric', y='OOS', kind='scatter', figsize=fsz)
MAIN_DF.plot(x='Number of Orders', y='OOS', kind='scatter', figsize=fsz)
MAIN_DF.plot(x='Avg Cases per Order', y='Number of Orders', kind='scatter', figsize=fsz)
MAIN_DF.hist('OOS', figsize=fsz, bins=35)
MAIN_DF.hist('Avg Cases per Order', figsize=fsz, bins=25)
MAIN_DF.hist('Avg Days Between Orders - Numeric', figsize=fsz, bins=25)
pd.DataFrame(MAIN_DF.groupby('Store')['Avg Days Between Orders - Numeric'].min()).hist(figsize=fsz, bins=25)
pd.DataFrame(MAIN_DF.groupby('Store')['Avg Days Between Orders - Numeric'].mean()).hist(figsize=fsz, bins=25)


# In[23]:

#MAIN_DF.hist('OOS', figsize=(12,9), bins=35)
print(MAIN_DF.head())
plt.figure(num=None, figsize=(15, 9))
plt.scatter(MAIN_DF['Avg Days Between Orders - Numeric'], MAIN_DF['Avg Cases per Order'],
           s=MAIN_DF['Dollars'],
           c=MAIN_DF['Store'],
           alpha=.5)
plt.xlabel('Avg Days betwen Orders @ SKU Level')
plt.ylabel('Avg Cases per Order @ SKU Level')
plt.show()


# In[27]:

import seaborn as sns
print(MAIN_DF.head())

pplot_cols = ['Customer','OOS','Dollars', 'Costs', 'NonStd Cases', 'GP $', 'Mark Up',
                      'Avg Cases per Order', 'Avg GP$ per Order',
                      'Avg OOS per Order', 'Avg Days Between Orders - Numeric']
g = sns.pairplot(MAIN_DF[pplot_cols], #hue='Customer', 
             dropna=True, 
             diag_kind='kde',
             kind='reg')
g.map_upper(sns.residplot)


# In[25]:

def generate_weeks():
    DAT = pd.date_range('1/1/2017', periods=366, freq='D')
    WK = [d.strftime('%U') for d in DAT]
    MO = [d.strftime('%B') for d in DAT]

    DAYZ = pd.DataFrame({'Date':DAT, 'WeekNumber':WK, 'Month':MO})

    DAYZ.loc[DAYZ.WeekNumber.isin(['00','01','02','03','04','05','06','07','08','09','50','51','52','53']), 'Season'] = 'Winter'
    DAYZ.loc[DAYZ.WeekNumber.isin(['10','11','12','13','14','15','16','17','18','19','20','21','22']), 'Season'] = 'Spring'
    DAYZ.loc[DAYZ.WeekNumber.isin(['23','24','25','26','27','28','29','30','31','32','33','34','35']), 'Season'] = 'Summer'
    DAYZ.loc[DAYZ.WeekNumber.isin(['36','37','38','39','40','41','42','43','44','45','46','47','48','49']), 'Season'] = 'Autumn'

    DAYZ.reset_index(drop=True, inplace=True)
    
    return DAYZ

print(generate_weeks())


# In[26]:

wine = [file for file in all_files if 'Wine' in file]
print(wine)

