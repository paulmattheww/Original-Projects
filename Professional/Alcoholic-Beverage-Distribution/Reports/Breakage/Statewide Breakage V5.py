'''
Breakage 

pw_break query encompasses the whole state
Update monthly sales lookup table before running
'''

print('*'*100)
print('Commencing Breakage Report.')
print('*'*100)


import pandas as pd
import numpy as np
from datetime import datetime as dt
from pandas import DataFrame

pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 100)
pd.set_option('display.width', 200)


def getMonthYear(yearToDate=False):
    if dt.now().month == 1:
        lastMonth = 12
    else:
        lastMonth = dt.now().month - 1
    reportMonth = dt.now().replace(month=lastMonth).strftime('%B')
    
    if dt.now().month == 1:
        reportYear = dt.now().year - 1
    else:
        reportYear = dt.now().year
    reportMonthYear = str(reportMonth) + ' ' + str(reportYear)
    
    if yearToDate:
        reportMonthYear = reportMonthYear + ' YTD'
    else:
        pass
    
    lastYear = reportYear - 1
    
    return lastMonth, lastYear, reportYear, reportMonth, reportMonthYear


lastMonth, lastYear, reportYear, reportMonth, reportMonthYear = getMonthYear()

folder = 'C:/Users/pmwash/Desktop/Re-Engineered Reports/Breakage/'
dtypes = {'#RDATE':str, 'PBRAN#':np.int64, '#RPRD#':np.int64, '#RDESC':str, 
            '#RCLA@':np.int64, '#RCODE':np.int64, '#RSIZE':str, '#RCASE':np.float64,
            '#RBOTT':np.float64, 'LAID_IN':np.float64, 'EXT_COST':np.float64,
            '#RCOMP':np.int64, '#RQPC':np.int64, 'PTYPE':np.int64, 'PONHD':np.int64 }

pw_break = pd.read_csv(folder + 'pw_break.csv', header=0, encoding='ISO-8859-1', dtype=dtypes)
pw_ytdprod = pd.read_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Generalized Lookup Data/pw_ytdprod.csv', 
                         header=0, encoding='ISO-8859-1', usecols=['#MINP#','#MEXT$01'], dtype={'#MINP#':np.int64,'#MEXT$01':np.float64})
monthlySalesLookup = pd.read_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Generalized Lookup Data/monthly_sales_by_house.csv', 
                                   header=0, encoding='ISO-8859-1')
                                   
print('-'*75)
print('Raw Data:\n')                                   
print(pw_break.head())                          
print('-'*75)

                                  
stlSalesSamePeriod = monthlySalesLookup[(monthlySalesLookup['Month'] == lastMonth) & (monthlySalesLookup['Year'] == reportYear)  & (monthlySalesLookup['House'] == 'Saint Louis')]
kcSalesSamePeriod = monthlySalesLookup[(monthlySalesLookup['Month'] == lastMonth) & (monthlySalesLookup['Year'] == reportYear)  & (monthlySalesLookup['House'] == 'Kansas City')]
stlSalesSamePeriod, kcSalesSamePeriod = np.float64(stlSalesSamePeriod['Dollars']), np.float64(kcSalesSamePeriod['Dollars'])


#print(reportMonthYear)
#print(stlSalesSamePeriod)
#print(kcSalesSamePeriod)

def as400Date(dat):
    '''Accepts list of dates as strings from theAS400'''
    return [dt.date(dt.strptime(d[-6:], '%y%m%d')) for d in dat]

    
def calculate_breakage(cases, btls, qpc):
    'Calculates from cases/btls separate using QPC - all vectors'
    cases = np.multiply(cases, -1)
    btls = np.multiply(btls, -1)
    total_cases = cases + np.divide(btls, qpc)
    return total_cases
    


def processRawBreakageData(pw_break, pw_ytdprod):
    '''
    Pre-processes AS400 data on breakage for reporting
    '''
    ## Rename columns
    columnNames = {'#RDATE':'Date', 'PBRAN#':'BrandId', '#RPRD#':'ProductId', '#RDESC':'Product', 
                '#RCLA@':'ProductClass', '#RCODE':'ReasonCode', '#RSIZE':'Size', '#RCASE':'CasesOnly',
                '#RBOTT':'BottlesOnly', 'LAID_IN':'LaidIn', 'EXT_COST':'Breakage|Dollars',
                '#RCOMP':'Warehouse', '#RQPC':'QPC', 'PTYPE':'ProductType', 'PONHD':'OnHand'}
    pw_break.rename(columns=columnNames, inplace=True)
    pw_ytdprod.rename(columns={'BREAKLVL':'x1', 'OVERFLOW':'x2', '#MINP#':'ProductId', '#MEXT$01':'Sales|Dollars'}, inplace=True)
    
    ## Merge pw_break with pw_ytdprod
    breakageData = pw_break.merge(pw_ytdprod, on='ProductId', how='left')
    
    ## Process & clean data    
    breakageData['Breakage|Dollars'] = np.multiply(breakageData['Breakage|Dollars'],-1)
    breakageData.Warehouse = breakageData.Warehouse.map({1:'Kansas City', 2:'Saint Louis', 3:'Columbia', 4:'Cape', 5:'Springfield'})
    breakageData.ReasonCode = breakageData.ReasonCode.map({2:'Sales Breakage & Unsaleables', 3:'Warehouse Breakage', 4:'Driver Breakage', 5:'Cross-Dock Breakage', 7:'Supplier Breakage'}) 
    breakageData.ProductType = breakageData.ProductType.map({1:'Liquor & Spirits', 2:'Wine', 3:'Beer & Cider', 4:'Non-Alcoholic'})
    
    productClassMap = {10:'Liquor', 25:'Spirit Coolers', 50:'Wine', 51:'Fine Wine', 53:'Keg Wine',
                        55:'Sparkling Wine & Champagne', 58:'Package Cider', 59:'Keg Cider', 70:'Wine Coolers',
                        80:'Malt Coolers/3.2 Beer', 84:'High-Alcohol Malt', 85:'Beer', 86:'Keg Beer', 
                        87:'Keg Beer w/ Deposit', 88:'High Alcohol Kegs', 90:'Water/Soda', 91:'Other Non-Alcoholic',
                        92:'Red Bull', 95:'Taxable Items - On Premise', 99:'Miscellaneous'}
    breakageData.ProductClass = breakageData.ProductClass.map(productClassMap)
    
    dat = breakageData.Date = as400Date(breakageData.Date.astype(str).tolist())
    
    breakageData['Year'] = [d.strftime('%Y') for d in dat]
    breakageData['Month'] = [d.strftime('%B') for d in dat]
    breakageData['Weekday'] = [d.strftime('%A') for d in dat]
    breakageData['DOTY'] = [d.strftime('%j') for d in dat]
    breakageData['WeekNumber'] = [d.strftime('%U') for d in dat]
    breakageData['DOTM'] = [d.strftime('%d') for d in dat]
    
    cases, btls, qpc = breakageData.CasesOnly, breakageData.BottlesOnly, breakageData.QPC
        
    breakageData['Breakage|Cases'] = calculate_breakage(cases,btls,qpc)
    breakageData['CasesOnHand'] = np.divide(breakageData['OnHand'], breakageData['QPC'])
    breakageData['Breakage|% Sales'] = np.divide(breakageData['Breakage|Dollars'], breakageData['Sales|Dollars'])
    
    breakageData.sort_values('Date').reset_index(drop=True)
    
    return breakageData
    
    
breakageClean = processRawBreakageData(pw_break, pw_ytdprod)

print('-'*75)
print('Clean Breakage Data')
print(breakageClean.head())
print('-'*75)



    
def prepareBreakagebreakageSummary(breakageData, stlSalesSamePeriod, kcSalesSamePeriod, reportYear, lastYear):
    '''
    Takes in clean data and gets it ready for consumption
    '''
    aggFuncs = { 'Breakage|Dollars' : np.sum,
                'Breakage|Cases' : np.sum }
    groupCols = ['Warehouse','ReasonCode','Year']
    breakageSummary = DataFrame(breakageData.groupby(groupCols).agg(aggFuncs).reset_index(drop=False))
    breakageSummary = pd.DataFrame(breakageSummary.pivot_table(values=['Breakage|Cases','Breakage|Dollars'], index=['Warehouse','ReasonCode'], columns=['Year']))
    breakageSummary.columns = ['%s%s' % (a, '|%s' % b if b else '') for a, b in breakageSummary.columns]  
    breakageSummary.sort_index(inplace=True, ascending=False)
    
    breakageSummary['Breakage|% Sales'] = breakageSummary.index.get_level_values(0)
    breakageSummary['Breakage|% Sales'] = breakageSummary['Breakage|% Sales'].map({'Kansas City':kcSalesSamePeriod, 'Saint Louis':stlSalesSamePeriod})
    breakageSummary['Breakage|% Sales'] = np.divide(breakageSummary['Breakage|Dollars|2016'], breakageSummary['Breakage|% Sales'])
    
    def yoy_delta(now, then): return np.divide(np.subtract(now,then), then)
    
    breakageSummary['Breakage|Dollars|% Change'] = round(yoy_delta(breakageSummary['Breakage|Dollars|'+str(reportYear)], breakageSummary['Breakage|Dollars|'+str(lastYear)]),4)
    breakageSummary['Breakage|Cases|% Change'] = round(yoy_delta(breakageSummary['Breakage|Cases|'+str(reportYear)], breakageSummary['Breakage|Cases|'+str(lastYear)]),4)
    breakageSummary = breakageSummary.reindex(columns=['Breakage|Dollars|'+str(lastYear), 'Breakage|Dollars|'+str(reportYear), 'Breakage|Dollars|% Change', 'Breakage|% Sales',
                                        'Breakage|Cases|'+str(lastYear), 'Breakage|Cases|'+str(reportYear), 'Breakage|Cases|% Change'])
    breakageSummary = breakageSummary.reindex(index=['Warehouse Breakage','Cross-Dock Breakage','Driver Breakage','Supplier Breakage','Sales Breakage & Unsaleables'], level='ReasonCode')

    return breakageSummary
    

breakageSummary = prepareBreakagebreakageSummary(breakageClean, stlSalesSamePeriod, kcSalesSamePeriod, reportYear, lastYear)
print('-'*75)
print('Summary of breakage')
print(breakageSummary)
print('-'*75)


def percentChange(old, new): 
    try:
        pctChg = round((new - old) / old, 5)
    except ValueError:
        pctChg = np.nan
    return pctChg


def getDriverAndWarehouseItemsBroken(breakageClean, lastYear, reportYear):
    driverItems = breakageClean[breakageClean['ReasonCode'] == 'Driver Breakage']
    driverItems = pd.DataFrame(driverItems.groupby(['Warehouse','Year','ProductId','Product'])['Breakage|Dollars'].sum()).reset_index(drop=False)
    driverItems = pd.pivot_table(driverItems, values='Breakage|Dollars', index=['Warehouse','ProductId','Product'], columns=['Year'])
    driverItems['PercentChange'] = [percentChange(old,new) for old,new in zip(driverItems[str(lastYear)], driverItems[str(reportYear)])]
    driverItems.sort_values(str(reportYear), ascending=False, inplace=True)
    driverItems.reset_index(drop=False, inplace=True)
    
    warehouseItems = breakageClean[breakageClean['ReasonCode'] == 'Warehouse Breakage']
    warehouseItems = pd.DataFrame(warehouseItems.groupby(['Warehouse','Year','ProductId','Product'])['Breakage|Dollars'].sum()).reset_index(drop=False)
    warehouseItems = pd.pivot_table(warehouseItems, values='Breakage|Dollars', index=['Warehouse','ProductId','Product'], columns=['Year'])
    warehouseItems['PercentChange'] = [percentChange(old,new) for old,new in zip(warehouseItems[str(lastYear)], warehouseItems[str(reportYear)])]
    warehouseItems.sort_values(str(reportYear), ascending=False, inplace=True)
    warehouseItems.reset_index(drop=False, inplace=True)    
    
    return driverItems, warehouseItems

driverItems, warehouseItems = getDriverAndWarehouseItemsBroken(breakageClean, lastYear, reportYear)



def writeBreakageReportToExcel(breakageSummary, driverItems, warehouseItems, month='YOU FORGOT TO SPECIFY THE MONTH'):
    '''
    Write report to Excel with formatting.
    '''

    fileOut = pd.ExcelWriter('N:/Operations Intelligence/Monthly Reports/Breakage/Breakage Report  -  '+month+'.xlsx', engine='xlsxwriter')
    workbook = fileOut.book
    
    print('Writing data to file.')
    breakageSummary.to_excel(fileOut, sheet_name='Breakage Summary', index=True)
    warehouseItems.to_excel(fileOut, sheet_name='Warehouse Items', index=False)
    driverItems.to_excel(fileOut, sheet_name='Driver Items', index=False)

    print('Saving number formats for re-use.')
    format_thousands = workbook.add_format({'num_format': '#,##0.0'})
    format_dollars = workbook.add_format({'num_format': '$#,##0'})  
    format_percent = workbook.add_format({'num_format': '0.0%'})
    format_percent_precise = workbook.add_format({'num_format': '0.##0%'})
    
    print('Formatting breakageSummary tab for visual purposes.')
    breakageSummary_tab = fileOut.sheets['Breakage Summary']
    breakageSummary_tab.set_column('A:A',15)
    breakageSummary_tab.set_column('B:B',28)
    breakageSummary_tab.set_column('C:D',21, format_dollars)
    breakageSummary_tab.set_column('E:E',26, format_percent)
    breakageSummary_tab.set_column('F:F',17, format_percent_precise)
    breakageSummary_tab.set_column('G:H',21, format_thousands)
    breakageSummary_tab.set_column('I:I',25, format_percent)
    
    print('Formatting Warehouse tab.')
    warehouse_tab = fileOut.sheets['Warehouse Items']
    warehouse_tab.set_column('A:A',15)
    warehouse_tab.set_column('B:B',12)
    warehouse_tab.set_column('C:C',42)
    warehouse_tab.set_column('D:E',15, format_dollars)
    
    print('Formatting Driver tab.')
    driver_tab = fileOut.sheets['Driver Items']
    driver_tab.set_column('A:A',15)
    driver_tab.set_column('B:B',12)
    driver_tab.set_column('C:C',42)
    driver_tab.set_column('D:E',15, format_dollars)
        
    print('Saving File on the STL Common drive.\n\n\n')
    fileOut.save()    
    
    print('*'*100)
    print('Finished writing file to common drive.')
    print('*'*100)
    
    return None
    




writeBreakageReportToExcel(breakageSummary, driverItems, warehouseItems, month='YTD through 08-07-2017')#reportMonthYear)


























def generateCalendar(year):
    from pandas.tseries.offsets import YearEnd
    from pandas.tseries.holiday import USFederalHolidayCalendar
    
    start_date = pd.to_datetime('1/1/'+str(year))
    end_date = start_date + YearEnd()
    DAT = pd.date_range(str(start_date), str(end_date), freq='D')
    WK = [d.strftime('%U') for d in DAT]
    MO = [d.strftime('%B') for d in DAT]
    holidays = USFederalHolidayCalendar().holidays(start=start_date, end=end_date)

    DAYZ = pd.DataFrame({'Date':DAT, 'WeekNumber':WK, 'Month':MO})
    
    DAYZ['Year'] = [format(d, '%Y') for d in DAT]
    DAYZ['Weekday'] = [format(d, '%A') for d in DAT]
    DAYZ['DOTM'] = [format(d, '%d') for d in DAT]
    DAYZ['IsWeekday'] = DAYZ.Weekday.isin(['Monday','Tuesday','Wednesday','Thursday','Friday'])
    DAYZ['IsProductionDay'] = DAYZ.Weekday.isin(['Tuesday','Wednesday','Thursday','Friday'])
    last_biz_day = [str(format(dat, '%Y-%m-%d')) for dat in pd.date_range(start_date, end_date, freq='BM')]
    DAYZ['LastSellingDayOfMonth'] = [dat in last_biz_day for dat in DAYZ['Date'].astype(str)]

    DAYZ.loc[DAYZ.WeekNumber.isin(['00','01','02','03','04','05','06','07','08','09','50','51','52','53']), 'Season'] = 'Winter'
    DAYZ.loc[DAYZ.WeekNumber.isin(['10','11','12','13','14','15','16','17','18','19','20','21','22']), 'Season'] = 'Spring'
    DAYZ.loc[DAYZ.WeekNumber.isin(['23','24','25','26','27','28','29','30','31','32','33','34','35']), 'Season'] = 'Summer'
    DAYZ.loc[DAYZ.WeekNumber.isin(['36','37','38','39','40','41','42','43','44','45','46','47','48','49']), 'Season'] = 'Autumn'
    DAYZ['Holiday'] = DAYZ.Date.isin(holidays)
    DAYZ['HolidayWeek'] = DAYZ['Holiday'].rolling(window=7,center=True,min_periods=1).sum()
    DAYZ['ShipWeek'] = ['A' if int(wk) % 2 == 0 else 'B' for wk in WK]

    DAYZ.reset_index(drop=True, inplace=True)
    
    return DAYZ

#yrz = [lastYear, reportYear]
#dfCalendar = pd.DataFrame()
#for yr in yrz:
#    dfCalendar = dfCalendar.append(generateCalendar(year=yr))
#
#dfCalendar.to_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Breakage/Calendar 2016-2017.csv', index=False)
#
#print('Writing clean data to disk for R report on Breakage Causes')
##breakageClean.merge(dfCalendar, on='Date', how='inner')
#breakageClean.to_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Breakage/Clean Breakage Data.csv', index=False)


### KC INVESTIGATE
### AFTER LUNCH SEND TO KURTIS
#groupCols = ['Year','Warehouse','ProductType','BrandId','Size','ProductId','Product','ReasonCode']
#aggFuncs = {'Breakage|Dollars':np.sum,
#             'Breakage|Cases':np.sum,
#             'Sales|Dollars':np.max}
#agg_cols = ['Breakage|Dollars','Breakage|Cases','Sales|Dollars']
#
##y_sku = breakageClean.copy()
##y_sku['Year'] = by_sku.Date.apply(lambda x: format(x, '%Y'))
#
#by_sku = pd.DataFrame(breakageClean.groupby(groupCols)[agg_cols].agg(aggFuncs)).reset_index(drop=False)
#by_sku.sort_values('Breakage|Cases', ascending=False, inplace=True)
#
#ISKC = (by_sku.Warehouse == 'Kansas City')
#NOTSLS = (by_sku.ReasonCode != 'Sales Breakage & Unsaleables')
#by_sku = by_sku[ISKC & NOTSLS].reset_index(drop=True)
##by_sku.to_excel('C:/Users/pmwash/Desktop/Disposable Docs/June Breakage KC - By Item.xlsx', sheet_name='KC June 2017')
#by_sku.head()




#print(breakageClean.head())
#
#breakageClean = breakageClean[breakageClean.ReasonCode != 'Sales Breakage & Unsaleables']
#
#print('This goes to an R Qtrly Ops Report')
#groupCols = ['Warehouse','Year','Month','ReasonCode'] #'ProductId','Product',
#val_cols = ['Sales|Dollars','Breakage|Dollars','Breakage|Cases']
#agg_fns = {'Sales|Dollars' : np.max, 'Breakage|Dollars':np.sum, 'Breakage|Cases':np.sum}
#
#QTRLY = pd.DataFrame(breakageClean.groupby(groupCols)[val_cols].agg(agg_fns)).reset_index(drop=False)
#QTRLY.to_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Quarterly Reports/Data/Breakage Clean Q1.csv')
#print(QTRLY.head())
#
#groupCols = ['Warehouse','Year','WeekNumber','ReasonCode'] #'ProductId','Product',
#val_cols = ['Sales|Dollars','Breakage|Dollars','Breakage|Cases']
#agg_fns = {'Sales|Dollars' : np.max, 'Breakage|Dollars':np.sum,  'Breakage|Cases':np.sum}
#
#TSERIES = pd.DataFrame(breakageClean.groupby(groupCols)[val_cols].agg(agg_fns)).reset_index(drop=False)
#TSERIES.to_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Quarterly Reports/Data/TS Breakage Q1.csv')
#print(TSERIES.head())
#
#
#groupCols = ['ProductId','Product','ProductClass','ReasonCode'] #'ProductId','Product',
#val_cols = ['Sales|Dollars','Breakage|Dollars','Breakage|Cases']
#agg_fns = {'Sales|Dollars' : np.max, 'Breakage|Dollars':np.sum,  'Breakage|Cases':np.sum}
#
#PRODDIVE = pd.DataFrame(breakageClean.groupby(groupCols)[val_cols].agg(agg_fns)).reset_index(drop=False)
#PRODDIVE.to_csv('C:/Users/pmwash/Desktop/Re-Engineered Reports/Quarterly Reports/Data/ProductDive Breakage Q1.csv')
#print(PRODDIVE.head())





