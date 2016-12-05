'''
Breakage Report
Re-Engineered November 2016

Queries have been combined for whole state 
'''


import pandas as pd
import numpy as np
from datetime import datetime as dt

folder = 'C:/Users/pmwash/Desktop/Re-Engineered Reports/Breakage/'
dtypes = {'#RDATE':str, 'PBRAN#':np.int64, '#RPRD#':np.int64, '#RDESC':str, 
            '#RCLA@':np.int64, '#RCODE':np.int64, '#RSIZE':str, '#RCASE':np.float64,
            '#RBOTT':np.float64, 'LAID_IN':np.float64, 'EXT_COST':np.float64,
            '#RCOMP':np.int64, '#RQPC':np.int64, 'PTYPE':np.int64, 'PONHD':np.int64 }

pw_break = pd.read_csv(folder + 'pw_break.csv', header=0, encoding='ISO-8859-1', dtype=dtypes)
pw_ytdprod = pd.read_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Generalized Lookup Data/pw_ytdprod.csv', header=0, encoding='ISO-8859-1')


def process_breakage_data(pw_break, pw_ytdprod):
    '''
    Pre-processes AS400 data on breakage for reporting
    '''

    col_names = {'#RDATE':'Date', 'PBRAN#':'BrandId', '#RPRD#':'ProductId', '#RDESC':'Product', 
                '#RCLA@':'ProductClass', '#RCODE':'ReasonCode', '#RSIZE':'Size', '#RCASE':'CasesOnly',
                '#RBOTT':'BottlesOnly', 'LAID_IN':'LaidIn', 'EXT_COST':'Breakage|Dollars',
                '#RCOMP':'Warehouse', '#RQPC':'QPC', 'PTYPE':'ProductType', 'PONHD':'OnHand'}
    pw_break.rename(columns=col_names, inplace=True)
    
    pw_ytdprod.rename(columns={'BREAKLVL':'x1', 'OVERFLOW':'x2', '#MINP#':'ProductId', '#MEXT$01':'Sales|Dollars'}, inplace=True)
    pw_ytdprod.drop(pw_ytdprod[['x1','x2']], axis=1, inplace=True)
    
    
    brk_data = pw_break.merge(pw_ytdprod, on='ProductId', how='left')
    
    brk_data['Breakage|Dollars'] = np.multiply(brk_data['Breakage|Dollars'],-1)
    
    brk_data.Warehouse = brk_data.Warehouse.map({1:'Kansas City', 2:'Saint Louis', 3:'Columbia', 4:'Cape', 5:'Springfield'})
    brk_data.ReasonCode = brk_data.ReasonCode.map({2:'Sales Breakage & Unsaleables', 3:'Warehouse Breakage', 4:'Driver Breakage', 5:'Cross-Dock Breakage', 7:'Supplier Breakage'}) 
    brk_data.ProductType = brk_data.ProductType.map({1:'Liquor & Spirits', 2:'Wine', 3:'Beer & Cider', 4:'Non-Alcoholic'})
    
    product_class_map = {10:'Liquor', 25:'Spirit Coolers', 50:'Wine', 51:'Fine Wine', 53:'Keg Wine',
                        55:'Sparkling Wine & Champagne', 58:'Package Cider', 59:'Keg Cider', 70:'Wine Coolers',
                        80:'Malt Coolers/3.2 Beer', 84:'High-Alcohol Malt', 85:'Beer', 86:'Keg Beer', 
                        87:'Keg Beer w/ Deposit', 88:'High Alcohol Kegs', 90:'Water/Soda', 91:'Other Non-Alcoholic',
                        92:'Red Bull', 95:'Taxable Items - On Premise', 99:'Miscellaneous'}
    brk_data.ProductClass = brk_data.ProductClass.map(product_class_map)
    
    def as400_date(dat):
        '''Accepts list of dates as strings from theAS400'''
        return [dt.date(dt.strptime(d[-6:], '%y%m%d')) for d in dat]
    
    dat = brk_data.Date = as400_date(brk_data.Date.astype(str).tolist())
    
    brk_data['Year'] = [d.strftime('%Y') for d in dat]
    brk_data['Month'] = [d.strftime('%B') for d in dat]
    brk_data['Weekday'] = [d.strftime('%A') for d in dat]
    brk_data['DOTY'] = [d.strftime('%j') for d in dat]
    brk_data['WeekNumber'] = [d.strftime('%U') for d in dat]
    brk_data['DOTM'] = [d.strftime('%d') for d in dat]
    
    cases, btls, qpc = brk_data.CasesOnly, brk_data.BottlesOnly, brk_data.QPC
    
    def calculate_breakage(cases, btls, qpc):
        'Calculates from cases/btls separate using QPC - all vectors'
        cases = np.multiply(cases, -1)
        btls = np.multiply(btls, -1)
        total_cases = cases + np.divide(btls, qpc)
        return total_cases
        
    brk_data['Breakage|Cases'] = calculate_breakage(cases,btls,qpc)
    brk_data['CasesOnHand'] = np.divide(brk_data['OnHand'], brk_data['QPC'])
    
    brk_data['Breakage|% Sales'] = np.divide(brk_data['Breakage|Dollars'], brk_data['Sales|Dollars'])
    
    return brk_data
    
    
clean_breakage_data = process_breakage_data(pw_break, pw_ytdprod)
    
    
def prepare_breakage_summary(brk_data):
    '''
    Takes in clean data and gets it ready for consumption
    '''
    agg_funcs = { 'Breakage|Dollars' : np.sum,
                'Breakage|Cases' : np.sum }
    grp_cols = ['Warehouse','ReasonCode','Year']
    SUMMARY = DataFrame(brk_data.groupby(grp_cols).agg(agg_funcs).reset_index(drop=False))
    SUMMARY = pd.DataFrame(SUMMARY.pivot_table(values=['Breakage|Cases','Breakage|Dollars'], index=['Warehouse','ReasonCode'], columns=['Year']))
    SUMMARY.columns = ['%s%s' % (a, '|%s' % b if b else '') for a, b in SUMMARY.columns]  
    SUMMARY.sort_index(inplace=True, ascending=False)
    
    def yoy_delta(now, then): return np.divide(np.subtract(now,then), then)
    
    SUMMARY['Breakage|Dollars|% Change'] = round(yoy_delta(SUMMARY['Breakage|Dollars|2016'], SUMMARY['Breakage|Dollars|2015']),4)
    SUMMARY['Breakage|Cases|% Change'] = round(yoy_delta(SUMMARY['Breakage|Cases|2016'], SUMMARY['Breakage|Cases|2015']),4)
    SUMMARY = SUMMARY.reindex(columns=['Breakage|Dollars|2015', 'Breakage|Dollars|2016', 'Breakage|Dollars|% Change', 'Breakage|Cases|2015', 'Breakage|Cases|2016', 'Breakage|Cases|% Change'])
    SUMMARY = SUMMARY.reindex(index=['Warehouse Breakage','Cross-Dock Breakage','Driver Breakage','Supplier Breakage','Sales Breakage & Unsaleables'], level='ReasonCode')

    return SUMMARY
    

summary = prepare_breakage_summary(clean_breakage_data)
summary

clean_breakage_data.head()





























