# -*- coding: utf-8 -*-
"""
Created on Thu May  5 12:03:23 2016

@author: pmwash
"""


import pandas as pd
import numpy as np
#import datetime as dt

pd.set_option('display.max_rows', 1000)
pd.set_option('display.max_columns', 500)
pd.set_option('display.width', 1000)
pd.set_option('display.float_format', lambda x: '%.0f' % x)



p = pd.read_csv('C:/Users/pmwash/Desktop/Python/Reports/Summaries/By Product/MASTER PRODUCT SUMMARY.csv')

#['YTD Sales', 'YTD COGS', 'YTD Returns', 'YTD Breakage']
#print(type(p.columns))
#p[8] = p.fillna(value=0, inplace=True)

p = p.fillna(0)

p['Gross Margin'] = (p['YTD Sales'] - p['YTD COGS']) / p['YTD COGS']
p['Seasonal'] = p['Product Category'].str.contains('SEASONAL', regex=True)
p['YTD Gross Profit'] = p['YTD Sales'] - p['YTD COGS']
#p['YTD Adj Gross Profit'] = 0

#p['YTD Adj Gross Profit'] = p['Gross Margin'] - (['YTD Unsaleable'] + ['YTD Returns'] + ['YTD Breakage'])


#l = list(p['YTD Adj Gross Profit'])



#


#print([row+1 for row in range(p['YTD Unsaleable']) if row.isnull])
    

p = p[p['Director'] != 'MB UNASSIGNED DISCONTINUED']



print(p.head(n=100))

print(p[p['Seasonal'] == True].head(n=30))



def rounded_sum(x):
    y = round(np.sum(x))
    return y 
    




p_piv = p.pivot_table(values=['YTD Gross Profit', 'YTD Sales', 'YTD COGS', 'YTD Unsaleable', 'YTD Returns', 'YTD Breakage'],
                      columns='Seasonal',
                      index=['Director', 'Supplier Name', 'Product Type', 'Product Description'], aggfunc=[rounded_sum], margins=False, fill_value='', dropna=True)



def rounded_percent(x):
    pct = x / x.sum()
    return pct
#
#p_pct = p_piv.groupby(level=0).apply(lambda x: x / x.sum())
#p_pct = p_piv.groupby(level=1).apply(rounded_percent)



print(p_piv.tail(n=100))
#print(p_pct)

loss_leaders = p[p['YTD Gross Profit'] < 0]
#loss_leaders = loss_leaders.sort(['YTD Gross Profit'], ascending=True)

loss_leaders = loss_leaders.fillna(0)
print(loss_leaders)

##print(pd.isnull(loss_leaders['YTD Unsaleable']))





#import rpy2 










