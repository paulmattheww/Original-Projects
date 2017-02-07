
# coding: utf-8

# In[1]:

'''
Census Reporting 
Due Dates 
2/7 for 1/15-1/21, 
5/9 for 4/16-4/22, 
8/8 for 7/16-7/22, 
11/7 for 10/15-10/21

Run pw_census1 and pw_census2 for the date ranges specified by the document
'''
import pandas as pd
import numpy as np
from datetime import datetime as dt

path = 'C:\\Users\\pmwash\\Desktop\\Re-Engineered Reports\\Census\\'

def read_combine_source(path):
    prd1 = pd.read_csv(path+'pw_census1.csv', header=0, dtype={'PPROD#':int,'PCLAS@':int,'PQTYPC':int,'PWEIGH':np.float64})
    prd1.rename(columns={'PPROD#':'ProductId','PCLAS@':'x','PQTYPC':'xx','PWEIGH':'WeightPerCase'}, inplace=True)
    prd1.drop(['x','xx'], axis=1, inplace=True)
    
    mtc1 = pd.read_csv(path+'pw_census2.csv', header=0, 
                       dtype={'#MCMP':int,'#MIVDT':str,'#MIVND':str,
                              '#MLIN#':str,'#MCUS#':int,'#MINP#':int,
                              '#MCLA@':int,'#MEXT$':np.float64,'NONSTDCASE':np.float64,
                              'CCITY':str,'CSTATE':str,'CZIP@':str})
    new_namz = {'#MCMP':'Company','#MIVDT':'Date','#MIVND':'Invoice','#MLIN#':'Line','#MCUS#':'CustomerId','#MINP#':'ProductId',
               '#MCLA@':'Class','#MEXT$':'ExtCost','NONSTDCASE':'NonStdCases','CCITY':'City','CSTATE':'State','CZIP@':'Zip'}
    mtc1.rename(columns=new_namz, inplace=True)
    
    combined = mtc1.merge(prd1, on='ProductId', how='outer')
    combined = combined[[len(dat) == 7 for dat in combined.Date.astype(str)]]
    combined.dropna(axis=0, how='all', thresh=len(combined.columns), inplace=True)
    
    combined.Company = combined.Company.map({1:'Kansas City',2:'Saint Louis',3:'Columbia',5:'Springfield'})
    combined['InvoiceLine'] = [str(i)+'_'+str(l) for i,l in zip(combined.Invoice, combined.Line)]
    combined['Weight'] = np.multiply(combined.NonStdCases, combined.WeightPerCase)
    
    combined['RefrigeratedDelivery'] = ['Y' if p_clas in [86,87,88] else 'N' for p_clas in combined.Class.tolist()]
    
    product_class_map = {10:'08320', 25:'08320', 50:'08200', 51:'08200', 53:'08200',
                        55:'08200', 58:'08200', 59:'08200', 70:'08320',
                        80:'08100', 84:'08100', 85:'08100', 86:'08100', 
                        87:'08100', 88:'08100', 90:'07899', 91:'07899',
                        92:'07811', 95:'08320', 99:'08320'}
    combined.Class = combined.Class.map(product_class_map)
    
    def as400_date(dat):
        try:
            d = dt.date(dt.strptime(dat[-6:], '%y%m%d'))
        except ValueError:
            d = dt.date(dt.strptime('1990909', '%y%m%d'))
        return d
    
    combined.Date = [as400_date(dat) for dat in combined.Date.astype(str).tolist()]
    combined.sort_values(['Company','Date'], inplace=True)
    combined.drop(['WeightPerCase','Line'], axis=1, inplace=True)
    combined = combined[combined.ExtCost > 0]

    return combined


# In[2]:

def process_combined(combo, company):
    combo = combo[combo.Company == company]
    combo['CommodityCode'] = combo.loc[combo.groupby(['Invoice'])['Weight'].transform(max) == combo.Weight, 'Class']
    combo.sort_values(['Invoice','CommodityCode'], inplace=True)
    combo.CommodityCode.fillna(method='ffill', inplace=True)
    comm_desc = {'07891':'Ice & Other Non-Alcoholic','08100':'Beer','08200':'Wine & Other Fermented Beverages',
                '08320':'Spirits, Liqueurs, & Other Spirituous Beverages (<80% ABV)'}
    combo['CommodityDescription'] = combo.CommodityCode.map(comm_desc)
    combo['Month'] = [format(dat, '%m') for dat in combo.Date]
    combo['Day'] = [format(dat, '%d') for dat in combo.Date]
    
    combo.sort_values(['Company','Invoice','InvoiceLine'], inplace=True)
    combo.reset_index(inplace=True, drop=True)
    
    grp_cols = ['Invoice','Month','Day','CommodityCode','CommodityDescription','RefrigeratedDelivery','City','State','Zip']
    combo_agg = pd.DataFrame(combo.groupby(grp_cols)[['ExtCost','Weight']].sum()).reset_index(drop=False)
    combo_agg['Hazardous'] = 'N'
    combo_agg['ModeOfTransport'] = '2'
    combo_agg['Export'] = 'N'
    reordered = ['Invoice','Month','Day','ExtCost','Weight','CommodityCode','CommodityDescription',
                 'RefrigeratedDelivery','Hazardous','City','State','Zip','ModeOfTransport','Export']
    combo_agg = combo_agg[reordered]

    return combo_agg


# In[3]:

def export_census_data(combo, path, quarter_year, report_every):
    locations_to_generate = ['Saint Louis','Springfield','Columbia']
    out_path = 'N:/Operations Intelligence/Census/'
    for loc in locations_to_generate:
        f_name = out_path + str(quarter_year) + '_' + str(loc) + '_Census Survey.xlsx' 
        data = process_combined(combo, company=loc)
        print(f_name, ' successfully written to file.')
        print('''
        Total Count of Shipments for %s = %i
        
        Total Dollars of Shipments for %s = %.2f 
        ''' %(loc, len(data.Invoice), loc, data.ExtCost.sum()))
        data = data[data.index % report_every == 0]
        data.to_excel(f_name, sheet_name=str(loc))
    return None
        
export_census_data(read_combine_source(path), path, quarter_year='Q1_2017', report_every=1)

