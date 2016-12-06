'''
Breakage Report
Re-Engineered October 2016

pw_break query encompasses the whole state
Update monthly sales lookup table before running
'''


import pandas as pd
import numpy as np
from datetime import datetime as dt

last_mon = dt.now().month - 1
report_month = dt.now().replace(month=last_mon).strftime('%B')
if dt.now().month == 1:
    report_year = dt.now().year - 1
else:
    report_year = dt.now().year
report_month_year = str(report_month) + ' ' + str(report_year)# + ' Year to Date'

folder = 'C:/Users/pmwash/Desktop/Re-Engineered Reports/Breakage/'
dtypes = {'#RDATE':str, 'PBRAN#':np.int64, '#RPRD#':np.int64, '#RDESC':str, 
            '#RCLA@':np.int64, '#RCODE':np.int64, '#RSIZE':str, '#RCASE':np.float64,
            '#RBOTT':np.float64, 'LAID_IN':np.float64, 'EXT_COST':np.float64,
            '#RCOMP':np.int64, '#RQPC':np.int64, 'PTYPE':np.int64, 'PONHD':np.int64 }

pw_break = pd.read_csv(folder + 'pw_break.csv', header=0, encoding='ISO-8859-1', dtype=dtypes)
pw_ytdprod = pd.read_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Generalized Lookup Data/pw_ytdprod.csv', header=0, encoding='ISO-8859-1')
monthly_sales_lookup = pd.read_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Generalized Lookup Data/monthly_sales_by_house.csv', header=0, encoding='ISO-8859-1')
stl_sales_same_period = monthly_sales_lookup[(monthly_sales_lookup['Month'] == last_mon) & (monthly_sales_lookup['Year'] == report_year)  & (monthly_sales_lookup['House'] == 'Saint Louis')]
kc_sales_same_period = monthly_sales_lookup[(monthly_sales_lookup['Month'] == last_mon) & (monthly_sales_lookup['Year'] == report_year)  & (monthly_sales_lookup['House'] == 'Kansas City')]
stl_sales_same_period, kc_sales_same_period = np.float64(stl_sales_same_period['Dollars']), np.float64(kc_sales_same_period['Dollars'])


print(report_month_year)
print(stl_sales_same_period)
print(kc_sales_same_period)

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
    
    brk_data.sort_values('Date').reset_index(drop=True)
    
    return brk_data
    
    
clean_breakage_data = process_breakage_data(pw_break, pw_ytdprod)
clean_breakage_data.head()




    
def prepare_breakage_summary(brk_data, stl_sales_same_period, kc_sales_same_period):
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
    
    SUMMARY['Breakage|% Sales'] = SUMMARY.index.get_level_values(0)
    SUMMARY['Breakage|% Sales'] = SUMMARY['Breakage|% Sales'].map({'Kansas City':kc_sales_same_period, 'Saint Louis':stl_sales_same_period})
    SUMMARY['Breakage|% Sales'] = np.divide(SUMMARY['Breakage|Dollars|2016'], SUMMARY['Breakage|% Sales'])
    
    def yoy_delta(now, then): return np.divide(np.subtract(now,then), then)
    
    SUMMARY['Breakage|Dollars|% Change'] = round(yoy_delta(SUMMARY['Breakage|Dollars|2016'], SUMMARY['Breakage|Dollars|2015']),4)
    SUMMARY['Breakage|Cases|% Change'] = round(yoy_delta(SUMMARY['Breakage|Cases|2016'], SUMMARY['Breakage|Cases|2015']),4)
    SUMMARY = SUMMARY.reindex(columns=['Breakage|Dollars|2015', 'Breakage|Dollars|2016', 'Breakage|Dollars|% Change', 'Breakage|% Sales',
                                        'Breakage|Cases|2015', 'Breakage|Cases|2016', 'Breakage|Cases|% Change'])
    SUMMARY = SUMMARY.reindex(index=['Warehouse Breakage','Cross-Dock Breakage','Driver Breakage','Supplier Breakage','Sales Breakage & Unsaleables'], level='ReasonCode')

    return SUMMARY
    

summary = prepare_breakage_summary(clean_breakage_data, stl_sales_same_period, kc_sales_same_period)
summary

clean_breakage_data.head(50)













def write_breakage_to_excel(summary, clean_breakage_data, month='YOU FORGOT TO SPECIFY THE MONTH'):
    '''
    Write report to Excel with formatting.
    '''
    driver_items = clean_breakage_data[clean_breakage_data['ReasonCode'] == 'Driver Breakage']
    driver_items = pd.DataFrame(pd.pivot_table(driver_items, values='Breakage|Dollars', index=['Warehouse','ProductId','Product'], columns=['Year'])).reset_index(drop=False)
    driver_items.sort_values(['Warehouse','2016','2015'], ascending=False, inplace=True)
    driver_items.reset_index(level='Year', drop=True, inplace=True)
    
    warehouse_items = clean_breakage_data[clean_breakage_data['ReasonCode'] == 'Warehouse Breakage']
    warehouse_items = pd.DataFrame(pd.pivot_table(warehouse_items, values='Breakage|Dollars', index=['Warehouse','ProductId','Product'], columns=['Year'])).reset_index(drop=False)
    warehouse_items.sort_values(['Warehouse','2016','2015'], ascending=False, inplace=True)
    warehouse_items.reset_index(level='Year', drop=True, inplace=True)

    file_out = pd.ExcelWriter('N:/Operations Intelligence/Monthly Reports/Breakage/Breakage Report  -  '+month+'.xlsx', engine='xlsxwriter')
    workbook = file_out.book
    
    print('Writing data to file.')
    summary.to_excel(file_out, sheet_name='Summary', index=True)
    warehouse_items.to_excel(file_out, sheet_name='Warehouse Items', index=False)
    driver_items.to_excel(file_out, sheet_name='Driver Items', index=False)

    print('Saving number formats for re-use.')
    format_thousands = workbook.add_format({'num_format': '#,##0.0'})
    format_dollars = workbook.add_format({'num_format': '$#,##0'})
    format_float = workbook.add_format({'num_format': '###0.#0'})    
    format_percent = workbook.add_format({'num_format': '0%'})
    
    print('Formatting Summary tab for visual purposes.')
    summary_tab = file_out.sheets['Summary']
    summary_tab.set_column('A:A',15)
    summary_tab.set_column('B:B',28)
    summary_tab.set_column('C:D',25, format_dollars)
    summary_tab.set_column('E:E',25, format_percent)
    summary_tab.set_column('F:F',25, format_percent)
    summary_tab.set_column('G:H',25, format_thousands)
    summary_tab.set_column('I:I',25, format_percent)
    
    print('Formatting Warehouse tab.')
    warehouse_tab = file_out.sheets['Warehouse Items']
    warehouse_tab.set_column('A:A',15)
    warehouse_tab.set_column('B:B',12)
    warehouse_tab.set_column('C:C',42)
    warehouse_tab.set_column('D:E',15, format_dollars)
    
    print('Formatting Driver tab.')
    driver_tab = file_out.sheets['Driver Items']
    driver_tab.set_column('A:A',15)
    driver_tab.set_column('B:B',12)
    driver_tab.set_column('C:C',42)
    driver_tab.set_column('D:E',15, format_dollars)
        
    print('Saving File on the STL Common drive.\n\n\n')
    file_out.save()    
    
    print('*'*100)
    print('Finished writing file to common drive.')
    print('*'*100)
    




write_breakage_to_excel(summary, clean_breakage_data, month=report_month_year)


























