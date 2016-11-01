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
from pandas import DataFrame
import numpy as np
from datetime import datetime as dt

pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 100)
pd.set_option('display.width', 100)

input_folder = 'C:/Users/pmwash/Desktop/Re-Engineered Reports/Unsaleables/'


print('''
The following queries should all be run using the same teimframe

Raw query is ready to use in this report
------------------------------------------------------------
pwrct1
pwunsale

Delete first two columns before using
------------------------------------------------------------
pw_ytdcust 
pw_ytdsupp 

''')
pwrct1 = pd.read_csv(input_folder + 'pwrct1.csv', header=0, encoding='ISO-8859-1')
pwunsale = pd.read_csv(input_folder + 'pwunsale.csv', header=0, encoding='ISO-8859-1')
pw_ytdcust = pd.read_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Generalized Lookup Data/pw_ytdcust.csv', 
                        header=0, encoding='ISO-8859-1', names=['CustomerId','DollarSales|bycustomer'])
pw_ytdsupp = pd.read_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Generalized Lookup Data/pw_ytdsupp.csv', 
                        header=0, encoding='ISO-8859-1', names=['SupplierId','DollarSales|bysupplier'])
pw_ytdprod = pd.read_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Generalized Lookup Data/pw_ytdprod.csv', 
                        header=0, encoding='ISO-8859-1', names=['ProductId','DollarSales|byproduct'])
                        
print('''
Reading in supplier/product lookup table. The query is pw_supprod in the AS400. Last updated 10/31/2016.
------------------------------------------------------------

Reading in director lookup table from Diver. Last updated 11/01/2016. 
------------------------------------------------------------

Reading in customer attribute lookup table. The query is pw_cusattr. Last updated 10/31/2016.
------------------------------------------------------------

''')
pw_supprod = pd.read_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Generalized Lookup Data/pw_supprod.csv', 
                        header=0, encoding='ISO-8859-1', names=['ProductId','Product','SupplierId','Supplier']) 
directors = pd.read_csv(input_folder + 'supplier_director_lookup_table.csv', 
                        header=0, encoding='ISO-8859-1')
pw_cusattr = pd.read_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Generalized Lookup Data/pw_cusattr.csv', 
                        header=0, encoding='ISO-8859-1', names=['CustomerId','Customer','OnPremise','Latitude','Longitude'])


def pre_process_unsaleables_returns_dumps(pwunsale, pwrct1, pw_supprod, directors):
    '''
    Pre-processes raw queries and lookup tables
    to get them into a format conducive for intelligence.
    '''
    print('*'*100)
    print('Pre-processing data.')
    print('*'*100)
    
    print('\n\n\nMapping column names.')
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
    
    print('Mapping warehouse names.')
    whs_map = {1:'Kansas City', 2:'Saint Louis', 3:'Columbia', 4:'Cape Girardeau', 5:'Springfield'}
    pwrct1['Warehouse'] = pwrct1['Warehouse'].map(whs_map)
    pwunsale['Warehouse'] = pwunsale['Warehouse'].map(whs_map)
    
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
    pwunsale[['ExtCost','CasesReturned']] = pwunsale[['ExtCost','CasesReturned']].apply(flip_sign)
    
    print('Merge in standardized supplier names and product names to both queries.')
    merge_cols = ['SupplierId','ProductId']
    pwunsale = pwunsale.merge(pw_supprod, on='ProductId', how='left')
    pwrct1 = pwrct1.drop(labels=['Supplier','Product'], axis=1).merge(pw_supprod, on=merge_cols, how='left')
    
    print('Merging in standard Customer attributes.')
    pwunsale = pwunsale.merge(pw_cusattr, on='CustomerId', how='left')
    
    print('*'*100)
    print('Finished pre-processing the queries.\n\n\n')
    print('*'*100)
    
    return pwunsale, pwrct1


pwunsale_tidy, pwrct1_tidy = pre_process_unsaleables_returns_dumps(pwunsale, pwrct1, pw_supprod, directors)





def aggregate_unsaleables_by_product(pwunsale_tidy, pwrct1_tidy, pw_ytdprod, pw_ytdsupp):
    '''
    Aggregates unsaleables returns & dumps by product.
    
    Takes tidy data as input (previous function).
    '''
    pwunsale = pwunsale_tidy
    pwrct1 = pwrct1_tidy    
    
    print('Expect to see the following. \n\n\n')
    tot_unsaleable = np.sum(pwrct1_tidy['ExtCost'])
    returned = np.sum(pwunsale_tidy['ExtCost'])
    
    print('Total unsaleables expected:  $%.2f' % tot_unsaleable) 
    print('Total returns expected:  $%.2f' % returned)
    
    print('\n\n\nAggregating RCT1 data by Product.')
    agg_funcs_product_rct = {'CasesUnsaleable': {'avg':np.mean, 'sum':np.sum},
                             'ExtCost': {'avg':np.mean, 'sum':np.sum}}
    
    grp_cols = ['SupplierId','Supplier','ProductId','Product']
    _agg_byproduct_rct = DataFrame(pwrct1.groupby(grp_cols).agg(agg_funcs_product_rct).reset_index(drop=False))
    _agg_byproduct_rct.columns = ['%s%s' % (a, '|%s' % b if b else '') for a, b in _agg_byproduct_rct.columns]                  
    _agg_byproduct_rct = _agg_byproduct_rct.reindex_axis(sorted(_agg_byproduct_rct.columns), axis=1)
    _agg_byproduct_rct.columns = ['CasesUnsaleable|avg', 'CasesUnsaleable|sum', 
                                  'DollarsUnsaleable|avg', 'DollarsUnsaleable|sum',
                                  'Product', 'ProductId', 
                                  'Supplier', 'SupplierId']
                                  
    print('\nUpdated unsaleables: $%.2f \n' % np.sum(_agg_byproduct_rct['DollarsUnsaleable|sum']))
    
    print('Aggregating MTC data by Product.')
    agg_funcs_product_mtc = {'CasesReturned': {'avg':np.mean, 'sum':np.sum},
                         'ExtCost': {'avg':np.mean, 'sum':np.sum}}
    
    _agg_byproduct_mtc = DataFrame(pwunsale.groupby(grp_cols).agg(agg_funcs_product_mtc).reset_index(drop=False))
    _agg_byproduct_mtc.columns = ['%s%s' % (a, '|%s' % b if b else '') for a, b in _agg_byproduct_mtc.columns]                  
    _agg_byproduct_mtc = _agg_byproduct_mtc.reindex_axis(sorted(_agg_byproduct_mtc.columns), axis=1)
    _agg_byproduct_mtc.columns = ['CasesReturned|avg', 'CasesReturned|sum', 
                                  'DollarsReturned|avg', 'DollarsReturned|sum',
                                  'Product', 'ProductId', 
                                  'Supplier', 'SupplierId']
                                  
    print('\nUpdated returns: $%.2f \n' % np.sum(_agg_byproduct_mtc['DollarsReturned|sum']))
    
    print('Combining RCT and MTC data.')
    _agg_byproduct_combined = _agg_byproduct_rct.merge(_agg_byproduct_mtc.drop(labels=['Supplier','Product'], axis=1), on=['SupplierId','ProductId'], how='outer')
    _agg_byproduct_combined[['ProductId','SupplierId']] = _agg_byproduct_combined[['ProductId','SupplierId']].astype(np.int)
    
    print('Merging in Directors on the SupplierId field.')
    _agg_byproduct_combined = _agg_byproduct_combined.merge(directors[['SupplierId','Director']], on='SupplierId',how='left')
    
    print('\nUpdated Unsaleables: $%.2f' % np.sum(_agg_byproduct_combined['DollarsUnsaleable|sum']))
    print('Updated Returns: $%.2f \n' % np.sum(_agg_byproduct_combined['DollarsReturned|sum']))
    
    print('Reordering columns.')
    reorder_cols = ['Director', 'SupplierId', 'Supplier', 
                    'ProductId', 'Product',
                    'DollarsUnsaleable|sum', 'CasesUnsaleable|sum',
                    'DollarsUnsaleable|avg', 'CasesUnsaleable|avg',
                    'DollarsReturned|sum', 'CasesReturned|sum',
                    'DollarsReturned|avg', 'CasesReturned|avg']
    _agg_byproduct_combined = _agg_byproduct_combined[reorder_cols]
    
    print('Mapping in attribute columns.')
    _attrs = ['ProductId', 'Size', 'Class', 'QPC']
    _attributes = pwrct1[_attrs].drop_duplicates(subset='ProductId')
    _agg_byproduct_combined = _agg_byproduct_combined.merge(_attributes, on='ProductId', how='left')
    
    print('Mapping in YTD sales by Product.')
    _agg_byproduct_combined = _agg_byproduct_combined.merge(pw_ytdprod, on='ProductId', how='left')
    
    print('Mapping in YTD sales by Supplier.')
    _agg_byproduct_combined = _agg_byproduct_combined.merge(pw_ytdsupp, on='SupplierId', how='left')
    
    print('Deriving percenteage of sales by Product.')
    _agg_byproduct_combined['PercentSales|byproduct'] = np.divide(_agg_byproduct_combined['DollarsUnsaleable|sum'], _agg_byproduct_combined['DollarSales|byproduct'])
    
    print('Deriving percenteage of sales by Suppplier.')
    _agg_byproduct_combined['PercentSales|bysupplier'] = np.divide(_agg_byproduct_combined['DollarsUnsaleable|sum'], _agg_byproduct_combined['DollarSales|bysupplier'])    
        
    print('\nUpdated Unsaleables: $%.2f' % np.sum(_agg_byproduct_combined['DollarsUnsaleable|sum']))
    print('Updated Returns: $%.2f \n' % np.sum(_agg_byproduct_combined['DollarsReturned|sum']))
    
    print('Checking for and dropping Duplicates.')
    _agg_byproduct_combined.drop_duplicates(inplace=True)
    
    print('Replacing NaN values with zeros for readability.')
    _agg_byproduct_combined.fillna(0, inplace=True)
    
    print('Sorting in descending order on total unsaleables.\n\n\n')
    _agg_byproduct_combined.sort_values('DollarsUnsaleable|sum', ascending=False, inplace=True)

    print('Resetting index.')
    _agg_byproduct_combined.reset_index(inplace=True)    
    
    print('Compare values below to originals. \n\n\n')
    new_tot_unsaleable = np.sum(_agg_byproduct_combined['DollarsUnsaleable|sum'])
    new_returned = np.sum(_agg_byproduct_combined['DollarsReturned|sum'])
    
    print('Original Unsaleables:  $%.2f \nPost-Processing Unsaleables:  $%.2f \n' % (tot_unsaleable, new_tot_unsaleable)) 
    print('Original Returns:  $%.2f \nPost-Processing Returns:  $%.2f \n\n\n' % (returned, new_returned)) 
    
    print('*'*100)
    print('If the numbers above do not match then there is a bug in the program.')
    print('*'*100)
    
    return _agg_byproduct_combined


unsaleables_by_product = aggregate_unsaleables_by_product(pwunsale_tidy, pwrct1_tidy, pw_ytdprod, pw_ytdsupp)

unsaleables_by_product.head()



def create_summaries(unsaleables_by_product, pw_ytdsupp):
    '''
    Creates useful one-look summaries for management.
    '''
    print('*'*100)
    print('Creating summaries.')
    summary_cols = ['DollarsUnsaleable|sum', 'DollarsReturned|sum', 
                    'CasesUnsaleable|sum', 'CasesReturned|sum']
    
    print('\n\n\nSummarizing Directors.')
    by_director = DataFrame(unsaleables_by_product.groupby('Director')[summary_cols].sum()).sort_values('DollarsUnsaleable|sum', ascending=False)
    
    print('Summarizing Suppliers.')
    by_supplier = DataFrame(unsaleables_by_product.groupby(['Director','SupplierId','Supplier'])[summary_cols].sum()).sort_values('DollarsUnsaleable|sum', ascending=False).reset_index(level=['Director','SupplierId','Supplier'], drop=False)

    print('Merging in YTD sales by supplier and deriving percent of sales.')    
    by_supplier = by_supplier.merge(pw_ytdsupp, on='SupplierId', how='left')
    by_supplier['PercentSales'] = np.divide(by_supplier['DollarsUnsaleable|sum'], by_supplier['DollarSales|bysupplier'])
    
    print('Summarizing by Class.\n\n\n')
    by_class = DataFrame(unsaleables_by_product.groupby(['Class'])[summary_cols].sum()).sort_values('DollarsUnsaleable|sum', ascending=False)

    print('*'*100)
    print('Finished creating summaries.')   
    print('*'*100)
    
    return by_supplier, by_director, by_class
    

supplier_summary, director_summary, class_summary = create_summaries(unsaleables_by_product, pw_ytdsupp)

supplier_summary.head(25)
director_summary
class_summary




def customer_return_summary(pw_cusattr, pwunsale_tidy, pw_ytdcust):
    '''
    Derives intelligence out of MTC1 data 
    on customer returns. 
    '''
    print('*'*100)
    print('Creating summary of returns.')
    print('*'*100)
    
    len_unique = lambda x: len(pd.unique(x))
    agg_funcs_returns = {'ExtCost': {'DollarsReturned|avg':np.mean, 'DollarsReturned|sum':np.sum},
                         'CasesReturned': {'CasesReturned|avg':np.mean, 'CasesReturned|sum':np.sum},
                         'Invoice':len_unique }
    
    print('\n\n\nAggregating tidy dataset.')
    customer_returns = DataFrame(pwunsale_tidy.groupby(['CustomerId','Customer'])[['ExtCost','CasesReturned']].agg(agg_funcs_returns)).reset_index(drop=False)
    customer_returns.rename(columns={'<lambda>':'Returns|count'}, inplace=True) 
    customer_returns.drop('Customer', inplace=True, axis=1)
    
    print('Merging in YTD sales by Customer')
    customer_returns = customer_returns.merge(pw_ytdcust, on='CustomerId', how='left')
    
    print('Deriving returns as a percent of sales for each Customer.')
    customer_returns['PercentSales'] = np.divide(customer_returns['DollarsReturned|sum'], customer_returns['DollarSales|bycustomer'])
    
    print('Merge in customer attributes.')
    customer_returns = customer_returns.merge(pw_cusattr, on='CustomerId', how='left')
    
    print('Sorting in descending order on Dollars returned.\n\n\n')
    customer_returns.sort_values('DollarsReturned|sum', ascending=False, inplace=True)
    
    print('Reorder columns for readability.')
    reorder_cols = ['CustomerId','Customer','Returns|count',
                    'PercentSales','DollarSales|bycustomer',
                    'DollarsReturned|sum','DollarsReturned|avg',
                    'CasesReturned|sum','CasesReturned|avg',
                    'OnPremise','Latitude','Longitude']
    customer_returns = customer_returns[reorder_cols]
    
    print('*'*100)
    print('Finished summarizing returns.')
    print('*'*100)
    
    return customer_returns


customer_returns = customer_return_summary(pw_cusattr, pwunsale_tidy, pw_ytdcust)

customer_returns.head()




def create_visualizations():
    '''
    '''
    pass


























