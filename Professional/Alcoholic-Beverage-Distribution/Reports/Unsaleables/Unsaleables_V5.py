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
Run time-sensitive queries for the same timeframe.

After running them in the AS400, use the Excel add-in to 
extract the data and overwrite the existing files in the
input folder.

All queries can be accessed from files in the AS400 by
the same name.

Contextual lookup queries need to be updated periodically.

THESE QUERIES MUST BE RUN FOR THE SAME TIMEFRAME.
------------------------------------------------------------
pwrct1, pwunsale, pw_ytdcust, pw_ytdsupp, pw_ytdprod


Main Queries for Report.
------------------------------------------------------------
pwrct1 - Queries RCT1 for unsaleables
pwunsale - Queries MTC1 for returns


Supplemental/Contextual Queries.
------------------------------------------------------------
pw_supprod : Supplier-Product relationships for lookup
pw_cusattr : Customer attributes for lookup
directors : DIVER-Director-Supplier relationships for lookup


Delete the first two columns after running all these queries.
These queries are sum sales by {Customer, Supplier, Product}.
If you choose a long timeframe for these then you should expect
a long query-time. YTD queries are best run at lunch or EOTD.
------------------------------------------------------------
pw_ytdcust - Sales over timeframe X-Y by Customer
pw_ytdsupp - Sales over timeframe X-Y by Supplier
pw_ytdprod - Sales over timeframe X-Y by Product

''')
pwrct1 = pd.read_csv(input_folder + 'pwrct1.csv', header=0, encoding='ISO-8859-1')
pwunsale = pd.read_csv(input_folder + 'pwunsale.csv', header=0, encoding='ISO-8859-1')
pw_ytdcust = pd.read_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Generalized Lookup Data/pw_ytdcust.csv', 
                        header=0, encoding='ISO-8859-1', names=['CustomerId','DollarSales|bycustomer'])
pw_ytdsupp = pd.read_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Generalized Lookup Data/pw_ytdsupp.csv', 
                        header=0, encoding='ISO-8859-1', names=['SupplierId','DollarSales|bysupplier'])
pw_ytdprod = pd.read_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Generalized Lookup Data/pw_ytdprod.csv', 
                        header=0, encoding='ISO-8859-1', names=['ProductId','DollarSales|byproduct'])
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
    
    print('Merging in standard Customer attributes.\n\n\n')
    pwunsale = pwunsale.merge(pw_cusattr, on='CustomerId', how='left')
    
    print('*'*100)
    print('Finished pre-processing the queries.')
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
    _agg_byproduct_combined.reset_index(inplace=True, drop=True)    
    
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

unsaleables_by_product.head(50)



def create_summaries(unsaleables_by_product, pw_ytdsupp):
    '''
    Creates useful one-look summaries for management.
    '''
    print('*'*100)
    print('Creating summaries.')
    print('*'*100)    
    
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
    
    print('Sorting in descending order on Dollars returned.')
    customer_returns.sort_values('DollarsReturned|sum', ascending=False, inplace=True)
    
    print('Reorder columns for readability.\n\n\n')
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




def returns_customer_product_time(pwunsale_tidy, pw_ytdcust, pw_cusattr):
    '''
    Meant to feed into a Pivot requested by Mitch Turner.
    
    Aggregates the same as above but includes time and product data.
    '''
    dat = pwunsale_tidy['Date'].tolist()
    pwunsale_tidy['Month'] = [d.strftime('%B') for d in dat]    
    
    print('Aggregating custom pivot for Mitch.')
    len_unique = lambda x: len(pd.unique(x))
    agg_funcs_returns = {'ExtCost': {'DollarsReturned|avg':np.mean, 'DollarsReturned|sum':np.sum},
                         'CasesReturned': {'CasesReturned|avg':np.mean, 'CasesReturned|sum':np.sum},
                         'Invoice':len_unique }
    
    custom_cols = ['Month','CustomerId','Customer','ProductId','Product']    
    
    customer_returns = DataFrame(pwunsale_tidy.groupby(custom_cols)[['ExtCost','CasesReturned']].agg(agg_funcs_returns)).reset_index(drop=False)
    customer_returns.rename(columns={'<lambda>':'Returns|count'}, inplace=True) 
    customer_returns.drop('Customer', inplace=True, axis=1)
    
    print('Merging in YTD sales by Customer')
    customer_returns = customer_returns.merge(pw_ytdcust, on='CustomerId', how='left')
    
    print('Deriving returns as a percent of sales for each Customer.')
    customer_returns['PercentSales'] = np.divide(customer_returns['DollarsReturned|sum'], customer_returns['DollarSales|bycustomer'])
    
    print('Merge in customer attributes.')
    customer_returns = customer_returns.merge(pw_cusattr, on='CustomerId', how='left')
    
    print('Sorting in descending order on Dollars returned.')
    customer_returns.sort_values('DollarsReturned|sum', ascending=False, inplace=True)

    return customer_returns


for_mitch = returns_customer_product_time(pwunsale_tidy, pw_ytdcust, pw_cusattr)

for_mitch.reset_index(drop=True).to_excel('C:/Users/pmwash/Desktop/Disposable Docs/YTD Returns as of 10-31 by Customer-Product-Month.xlsx', sheet_name='Raw Data')



supplier_summary.head(25)
director_summary
class_summary
customer_returns.head(25)
unsaleables_by_product.head()



def write_unsaleables_to_excel(class_summary, director_summary, supplier_summary, customer_returns, unsaleables_by_product, month='YOU FORGOT TO SPECIFY THE MONTH'):
    '''
    Write report to Excel with formatting.
    '''
    file_out = pd.ExcelWriter('N:/Operations Intelligence/Monthly Reports/Unsaleables/Unsaleables & Returns  -  '+month+'.xlsx', engine='xlsxwriter')
    workbook = file_out.book
    
    print('*'*100)
    print('Writing finished product to the STL Common Drive.')
    print('*'*100)
    
    print('\n\n\nWriting Class summary to file.')
    class_summary.to_excel(file_out, sheet_name='Summary', index=True)
    
    print('Writing Director summary to file.')
    director_summary.to_excel(file_out, sheet_name='Summary', index=True, startrow=9)

    print('Writing Customer Returns summary to file.')
    customer_returns.to_excel(file_out, sheet_name='Customers', index=False)    
    
    print('Writing Supplier summary to file.')
    supplier_summary.to_excel(file_out, sheet_name='Suppliers', index=False)

    print('Writing Product summary to file.')
    unsaleables_by_product.to_excel(file_out, sheet_name='Products', index=False)
    
    print('Saving number formats for re-use.')
    format_thousands = workbook.add_format({'num_format': '#,##0'})
    format_dollars = workbook.add_format({'num_format': '$#,##0'})
    format_float = workbook.add_format({'num_format': '###0.#0'})    
    format_percent = workbook.add_format({'num_format': '0%'})
    
    print('Formatting Summary tab for visual purposes.')
    summary_tab = file_out.sheets['Summary']
    summary_tab.set_column('A:A',30)
    summary_tab.set_column('D:E',25, format_thousands)
    summary_tab.set_column('B:C',25, format_dollars)
    
    print('Formatting Customers tab for visual purposes.')
    customers_tab = file_out.sheets['Customers']
    customers_tab.set_column('A:A',11)
    customers_tab.set_column('B:B',35)
    customers_tab.set_column('C:C',13.3)
    customers_tab.set_column('D:D',12, format_percent)
    customers_tab.set_column('E:G',22.5, format_dollars)
    customers_tab.set_column('H:I',19, format_float) 
    customers_tab.set_column('J:L',10.3)
    
    print('Formatting Suppliers tab for visual purposes.')
    suppliers_tab = file_out.sheets['Suppliers']
    suppliers_tab.set_column('A:A',30)
    suppliers_tab.set_column('B:B',9.5)
    suppliers_tab.set_column('C:C',36)
    suppliers_tab.set_column('D:E',21.6, format_dollars) 
    suppliers_tab.set_column('F:G',20.3, format_float)
    suppliers_tab.set_column('H:H',21, format_dollars)
    suppliers_tab.set_column('I:I',12, format_percent)    

    print('Formatting Products tab for visual purposes.')
    products_tab = file_out.sheets['Products']
    products_tab.set_column('A:A',30)
    products_tab.set_column('B:B',9.5)
    products_tab.set_column('C:C',36)
    products_tab.set_column('D:D',9.3)    
    products_tab.set_column('E:E',43)
    products_tab.set_column('F:F',21.6, format_dollars) 
    products_tab.set_column('G:G',20.3, format_float)
    products_tab.set_column('H:H',21.6, format_dollars) 
    products_tab.set_column('I:I',20.3, format_float)    
    products_tab.set_column('J:J',21.6, format_dollars) 
    products_tab.set_column('K:K',20.3, format_float)    
    products_tab.set_column('L:L',21.6, format_dollars) 
    products_tab.set_column('M:M',20.3, format_float) 
    products_tab.set_column('N:N',7)
    products_tab.set_column('O:O',14)
    products_tab.set_column('P:P',4)
    products_tab.set_column('Q:R',20.5, format_dollars)
    products_tab.set_column('S:T',22.4, format_percent)
        
    print('Saving File on the STL Common drive.\n\n\n')
    file_out.save()    
    
    print('*'*100)
    print('Finished writing file to common drive.')
    print('*'*100)
    


last_mon = dt.now().month - 1
report_month = dt.now().replace(month=last_mon).strftime('%B')
report_year = dt.now().year
report_month_year = str(report_month) + ' ' + str(report_year) + ' Year to Date'

write_unsaleables_to_excel(class_summary, director_summary, supplier_summary, customer_returns, unsaleables_by_product, month=report_month_year)






















def create_visualizations():
    '''
    '''
    pass


























