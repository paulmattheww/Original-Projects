# -*- coding: utf-8 -*-
"""
Created on Mon May  2 10:14:44 2016

@author: pmwash
"""

# Unsaleable pivot tables 


import pandas as pd
import numpy as np
import datetime as dt

pd.set_option('display.max_rows', 1000)
pd.set_option('display.max_columns', 500)
pd.set_option('display.width', 1000)


unsale = pd.read_csv('C:/Users/pmwash/Desktop/Python/Reports/Data/042016_unsaleables.csv')
unsale = unsale[unsale['CLASS'] != 'XXXXXXXXXXXXX']
unsale = unsale[unsale['DIRECTOR'] != 'MB UNASSIGNED DISCONTINUED']
#unsale = unsale.sort(['COST.UNSALEABLE'], ascending=True)


print(unsale.head(n=5))


pivot = unsale.pivot_table(['COST.UNSALEABLE', 'COST.DUMPED', 'COST.RETURNED', 'NUMBER.INCIDENTS'], 
                           index=['DIRECTOR', 'SUPPLIER', 'DESCRIPTION'],
                           aggfunc=np.sum, margins=True,
                           fill_value='')


#pivot = pivot.sort_values(by=('COST.UNSALEABLE'), ascending=False, inplace=True)

print(pivot)
print(pivot.head(n=25))


#pivot.to_csv('C:/Users/pmwash/Desktop/Python/Reports/Output/unsaleable_pivot_april2016.csv', encoding='utf-8')




#pivot2 = unsale.pivot_table(['COST.UNSALEABLE', 'CASES.UNSALEABLE'], 
#                           index=['DIRECTOR'],
#                           aggfunc=np.sum, margins=True,
#                           fill_value='')
#
#print(pivot2)









p = pd.read_csv('C:/Users/pmwash/Desktop/Python/Reports/Data/daily_production.csv')

#sort_order = {"Monday": 0, "Tuesday": 1, "Wednesday": 2, "Thursday": 3,
#              "Friday": 4, "Saturday": 5, "Sunday": 6}
#weekdays = p['WEEKDAY']              
#              
#weekdays = sorted(weekdays, key=sort_order)

p = p[p['WEEKDAY'] != 'Friday']
p = p[p['WEEKDAY'] != 'Saturday']
p = p[p['WEEKDAY'] != 'Sunday']


p['WEEKDAY'] = pd.Categorical(p['WEEKDAY'], ['Monday', 'Tuesday', 'Wednesday', 'Thursday'])
p['YEAR'] = pd.Categorical(p['YEAR'], [2016, 2015])
p['SEASON'] = pd.Categorical(p['SEASON'], ['Winter', 'Spring', 'Summer', 'Fall'])
p['FIRST.OR.LAST.DOTM'] = pd.Categorical(p['FIRST.OR.LAST.DOTM'], ['Y', 'N'])

#d = dt.datetime(p['DATE'])
#p['WOTM'] = p['DATE'].apply(lambda d: pd.datetools.WeekOfMonth(weekday=d, week=p['WEEK.NUMBER']))

print(p.head(n=10))
print(list(p.columns.values))


def rounded_mean(value):
    z = round(np.mean(value), 2)
    return z


p_means = p.pivot_table(values = ['CPMH', 'CASES.TOTAL', 'KEGS.TOTAL.REGION', 'TOTAL.HOURS', 
                       'TRUCKS.TOTAL', 'STOPS.TOTAL',
                       'TOTAL.HOURS', 'OT.HOURS', 'TOTAL.ODD.BALL'
                       ], 
                       columns=['YEAR'],
                       index=['WEEK.NUMBER'], aggfunc=[rounded_mean], margins=True, fill_value='')
print(p_means)






p_dotw = p.pivot_table(values = ['CPMH', 'CASES.TOTAL', 'KEGS.TOTAL.REGION', 'TOTAL.HOURS', 
                       'TRUCKS.TOTAL', 'STOPS.TOTAL',
                       'TOTAL.HOURS', 'OT.HOURS', 'TOTAL.ODD.BALL'
                       ], 
                       columns=['FIRST.OR.LAST.DOTM'],
                       index=['WEEKDAY'], aggfunc=[rounded_mean], margins=True, fill_value='')



print(p_dotw)







# unsaleable

p = pd.read_csv('C:/Users/pmwash/Desktop/Python/Reports/Unsaleables/ytd_unsaleables_05032016.csv')
ytd = pd.read_csv('C:/Users/pmwash/Desktop/Python/Reports/Data/ytd_sales_by_product_052016.csv)

p = p[(p['Director'] == 'STL SITES, JILL') | (p['Director'] == 'STL TURNER, MITCH')]
p = p[p['Unsaleable Cost'] > 0]


print(p.head(n=10))


p_cat = p.pivot_table(values=['Unsaleable Cost'],
                      #columns='Director',
                      index=['Director', 'Supplier Name', '﻿Product Description'], aggfunc=[sum], margins=True, fill_value='', dropna=True)


pct_unsale_dir = p_cat.groupby(level=0).apply(lambda x: x / float(x.sum()))



print(pct_unsale_dir.head(n=500))


pct_unsale_tot = p_cat.apply(lambda x: x / float(x.sum()))

#print(pct_unsale_tot)


#ck = p[p['Unsaleable Cost'] < 0]
#
#print(ck.head(n=50))





print("from 'C:\Users\pmwash\Desktop\Python\Reports\Summaries\By Product'")

















