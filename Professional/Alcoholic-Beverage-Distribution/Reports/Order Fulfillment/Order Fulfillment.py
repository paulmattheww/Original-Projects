
# coding: utf-8
# for executive cheat sheet

# In[1]:

import pandas as pd
import numpy as np
import glob
from datetime import datetime as dt
import datetime
pd.set_option('display.max_columns', None)
pd.set_option('display.float_format', lambda x: '%.3f' % x)

path = 'C:\\Users\\pmwash\\Desktop\\Re-Engineered Reports\\Customer Segmentation\\Data\\*.csv'

def generate_calendar(year):
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


def as400_date(dat):
    '''Accepts list of dates as strings from theAS400'''
    return [pd.to_datetime(dt.date(dt.strptime(d[-6:], '%y%m%d'))) for d in dat]
    

def order_fulfillment_rate(path, year=2017):
    '''Reads MTC1 files stored on local machine to extract order fulfillment rate'''
    all_files = glob.glob(path)
    
    DF_OUT = pd.DataFrame()
    for file in all_files:
        # Specify datatypes from start to avoid issues downstream
        print('Reading file:\n %s' %file)
        dtypes = col_names = {'#MCUS#':str,'#MIVDT':str,'#MIVND':str,'#MLIN#':str,'#MPRD#':str,'#MQTYS':np.int64,
                    'CSCRDT':str,'CCRLIM':np.float64,'CONPRM':str,'CUSPMC':str,'CDDAY':str,
                    '#MEXT$':np.float64,'CTERM@':str,'#MCOS$':np.float64,'CSTOR#':str,'#MCHN#':str,'#MCUSY':str,
                    '#MSLSP':str,'#MQPC':np.int64,'#MCLA@':str,'#MSIZ@':str,'#MBRND':str,'#MQTY@':str,
                    '#MCMP':str,'#MSUPL':str,'#MCALL':str,'#MPRIO':str,'#MINP#':str,
                    '#CSTDTE':str,'CUDSCC':str,'CSHP':str,'CADMBR':str,'#MQTYO':np.float64,'#MTRCD':str,'#MCMRC':str}
        c = pd.read_csv(file, header=0, dtype=dtypes)

        ## Rename columns to make sense
        col_names = {'#MCUS#':'CustomerId','#MIVDT':'Date','#MIVND':'Invoice','#MLIN#':'Line','#MPRD#':'SupplierBrandSizeNumber','#MQTYS':'QuantitySold',
                    'CSCRDT':'SeasonCreditLimit','CCRLIM':'CreditLimit','CONPRM':'OnPremise','CUSPMC':'MerchandiseClass','CDDAY':'X2',
                    '#MEXT$':'Revenue','CTERM@':'TermsCode','#MCOS$':'Cost','CSTOR#':'BarChainCode','#MCHN#':'ChainId','#MCUSY':'CustomerType',
                    '#MSLSP':'SalespersonId','#MQPC':'QPC','#MCLA@':'ClassCode','#MSIZ@':'SizeCode','#MBRND':'BrandId','#MQTY@':'QtyCode',
                    '#MCMP':'Warehouse','#MSUPL':'SupplierId','#MCALL':'CallCode','#MPRIO':'Priority','#MINP#':'ProductId','#MPRM@':'X1',
                    'CSTDTE':'CustomerSetup','CUDSCC':'DisplayCaseClass','CSHP':'Ship','CADMBR':'ShipWeekPlan','#MQTYO':'QuantityOrdered',
                    '#MTRCD':'TransactionCode','#MCMRC':'CreditReasonCode'}
        c.rename(columns=col_names, inplace=True)
        c.drop(labels=['X1','X2'], axis=1, inplace=True)

        ## Extract Invoice & Line
        c['InvoiceLine'] = [str(a)+'_'+str(b) for a,b in zip(c.Invoice, c.Line)]

        ## Extract proper dates and derivative data
        c.Date = as400_date(c.Date)
        
        ## Extract Cases 
        CS, QPC = c['QuantitySold'].astype(np.float64), c['QPC'].astype(np.float64)
        BTLS = c['QuantitySold'].astype(np.float64)
        c['Cases'] = np.divide(CS, QPC)
        c['Bottles'] = BTLS
        
        ## Cases short
        c['OutOfStock'] = np.int64(c['QuantitySold'].astype(np.float64) == 0)
        OOS_CR_REASON = c['CreditReasonCode'] == '17'
        TRC_A = c['TransactionCode'] == 'A'
        c.loc[OOS_CR_REASON & TRC_A, 'OutOfStock'] = 1
        Q_ORDERED = c['QuantityOrdered'].astype(np.float64)
        c['CasesOrdered'] = np.divide(Q_ORDERED, QPC)
        c.loc[c['OutOfStock']==1, 'CasesShort'] = np.subtract(c.loc[c['OutOfStock']==1, 'CasesOrdered'].astype(np.float64), c.loc[c['OutOfStock']==1, 'Cases']).astype(np.float64)## OOS mark
         
        ## Label customer types, call codes, class codes & warehouse
        type_map = {'A':'Bar/Tavern','C':'Country Club','E':'Transportation/Airline','G':'Gambling',                        'J':'Hotel/Motel','L':'Restaurant','M':'Military','N':'Fine Dining','O':'Internal',                        'P':'Country/Western','S':'Package Store','T':'Supermarket/Grocery','V':'Drug Store',                        'Y':'Convenience Store','Z':'Catering','3':'Night Club','5':'Adult Entertainment','6':'Sports Bar',                        'I':'Church','F':'Membership Club','B':'Mass Merchandiser','H':'Fraternal Organization',                        '7':'Sports Venue'}
        c.CustomerType = c.CustomerType.map(type_map)
        call_codes = {'01':'Customer Call','02':'ROE/EDI','03':'Salesperson Call','04':'Telesales','BH':'Bill & Hold',
                     'BR':'Breakage','CP':'Customer Pickup','FS':'Floor Stock','HJ':'High Jump','KR':'Keg Route',
                     'NH':'Non-Highjump','NR':'Non-Roadnet','PL':'Pallets','PR':'Personal','RB':'Redbull',
                     'SA':'Sample','SP':'Special','WD':'Withdrawal'}
        c.CallCode = c.CallCode.map(call_codes)
        product_class_map = {'10':'Liquor', '25':'Spirit Coolers', '50':'Wine', '51':'Fine Wine', '53':'Keg Wine',
                                '55':'Sparkling Wine & Champagne', '58':'Package Cider', '59':'Keg Cider', '70':'Wine Coolers',
                                '80':'Malt Coolers/3.2 Beer', '84':'High-Alcohol Malt', '85':'Beer', '86':'Keg Beer', 
                                '87':'Keg Beer w/ Deposit', '88':'High Alcohol Kegs', '90':'Water/Soda', '91':'Other Non-Alcoholic',
                                '92':'Red Bull', '95':'Taxable Items - On Premise', '99':'Miscellaneous'}
        c.ClassCode = c.ClassCode.map(product_class_map)
        whse_map = {'1':'Kansas City','2':'Saint Louis','3':'Columbia','5':'Springfield'}
        c.Warehouse = c.Warehouse.map(whse_map)
        
        ## Merge with calendar
        c = c.merge(generate_calendar(year=2017), on='Date', how='left')
        #c.drop_duplicates(inplace=True)
        
        ## Append new data to a dataframe that compiles all of it
        DF_OUT = DF_OUT.append(c)
        print('-'*100)

    
    return DF_OUT
                            
RAW_COMPILED = order_fulfillment_rate(path)

print(RAW_COMPILED.tail(3))


# In[2]:

## Aggregate together

## Aggregate data in-memory since files are too large to operate on in raw form
agg_functions = {'Invoice' : pd.Series.nunique, 
                 'InvoiceLine' : pd.Series.nunique, 
                 'OutOfStock' : np.sum,
                 'CasesShort' : np.sum,
                 'Cases' : np.sum}

GRP_COLS = ['Warehouse','Weekday','Date'] # ['Warehouse','Date']
SUMMARY = pd.DataFrame(RAW_COMPILED.groupby(GRP_COLS).agg(agg_functions)).reset_index(drop=False)
SUMMARY.drop_duplicates(inplace=True)

SUMMARY.head()


# In[3]:

## Get Order Fulfillment Rate
oosDf = SUMMARY.groupby('Warehouse')[['Cases','CasesShort','OutOfStock','InvoiceLine','Invoice']].sum()

oosDf['OOSbyCase'] = np.divide(oosDf.CasesShort, oosDf.Cases)
oosDf['OOSbyEvent'] = np.divide(oosDf.OutOfStock, oosDf.InvoiceLine)
oosDf['InStockByCase'] = 1 - oosDf.OOSbyCase
oosDf['InStockByEvent'] = 1 - oosDf.OOSbyEvent 
oosDf['PercentCases'] = np.divide(oosDf.Cases, oosDf.Cases.sum())
print(oosDf)

wtdAvgOrderFulfillment = oosDf.InStockByEvent.dot(oosDf.PercentCases)
print('''
Average Order Fulfillment = %.3f percent
''' %(wtdAvgOrderFulfillment*100))


# In[14]:

nonShipDf = RAW_COMPILED[RAW_COMPILED.Ship.astype(str) != '0']

aggFunctions = {'CustomerId' : pd.Series.nunique, 'Cases' : np.sum}
groupCols = ['Warehouse','Month','WeekNumber','Weekday','Date'] 

nonShpByDay = pd.DataFrame(nonShipDf.groupby(groupCols).agg(aggFunctions)).reset_index(drop=False)
print(nonShpByDay.head(),'\n\n')

nonShpByWhse = pd.DataFrame(nonShpByDay.groupby('Warehouse')[['Cases','CustomerId']].sum())
print(nonShpByWhse)

totalDeliveries = nonShpByWhse.CustomerId.sum()
avgMonthlyDeliveries = nonShpByDay.groupby('Month')['CustomerId'].sum().mean()
avgWeeklyDeliveries = nonShpByDay.groupby('WeekNumber')['CustomerId'].sum().mean()
avgDailyDeliveries = nonShpByDay.groupby('Date')['CustomerId'].sum().mean()

print('''
Total Deliveries = %i
Average Monthly Deliveries = %i
Average Weekly Deliveries = %i
Average Daily Deliveries = %i
''' %(totalDeliveries, avgMonthlyDeliveries, avgWeeklyDeliveries, avgDailyDeliveries))


# In[57]:

## Next day accounts, categorized as customers with 4 delivery days
nextDayAccounts = ['111100','1111100','1111101','1111111','111110']
nextDayDf = RAW_COMPILED[RAW_COMPILED.Ship.str.contains('1111')]
nextDayDf = pd.DataFrame(nextDayDf.groupby(['ChainId','CustomerId','CustomerType','Warehouse','Ship'])['Cases'].sum()).reset_index(drop=False)
nextDayDf.CustomerId = nextDayDf.CustomerId.astype(str)

path = 'C:\\Users\\pmwash\\Desktop\\Re-Engineered Reports\\Generalized Lookup Data\\pw_cusattr.csv'
pw_cusattr = pd.read_csv(path, header=0, 
                        dtype={'CCUST#':str,'CCUSTN':str,'CONPRM':str,'CPO#BR':str,'CPO#NA':str})
renameColumns = {'CCUST#':'CustomerId','CCUSTN':'Customer','CONPRM':'OnPremise','CPO#BR':'Latitude','CPO#NA':'Longitude'}
pw_cusattr.rename(columns=renameColumns, inplace=True)
#print(pw_cusattr.head())
#print(nextDayDf.head())
nextDayDf = nextDayDf.merge(pw_cusattr, on='CustomerId', how='inner')
nextDayDf = nextDayDf[nextDayDf.Cases > 0]
nextDayDf = nextDayDf[~nextDayDf.Customer.str.contains('OOB')]
nextDayDf = nextDayDf[~nextDayDf.Customer.str.contains('MAJOR BRANDS')]
nextDayDf = nextDayDf[~nextDayDf.Customer.str.contains('SAMPLES')]
nextDayDf = nextDayDf[~nextDayDf.Customer.str.contains('CORP DONATIONS')]
nextDayDf = nextDayDf[~nextDayDf.Customer.str.contains('DISCREPANCY')]
nextDayDf = nextDayDf[~nextDayDf.Customer.str.contains('FLOOR STOCK')]
nextDayDf = nextDayDf[~nextDayDf.Customer.str.contains('BREAKAGE')]
nextDayDf = nextDayDf[~nextDayDf.Customer.str.contains('DELETED ACCOUNTS')]
nextDayDf = nextDayDf[~nextDayDf.Customer.str.contains('EMPLOYEE PURCHASE')]
nextDayDf.sort_values('Cases', ascending=False, inplace=True)
nextDayDf.reset_index(inplace=True, drop=True)

displayCols = ['Customer','Warehouse','Cases','Ship']
print(nextDayDf[displayCols].head(50),'\n\n',nextDayDf[displayCols].tail(50))
nextDayDf.to_csv('C:/Users/pmwash/Desktop/Disposable Docs/Check Next Day Accounts')


# In[ ]:




# In[ ]:




# In[5]:

grp_cols = ['Warehouse','Weekday']

print('Summary of all houses = \n\n', SUMMARY.groupby('Warehouse')[['CasesShort','OutOfStock','InvoiceLine']].mean() )

ratio_wkday = SUMMARY.groupby(grp_cols)['Invoice'].mean() /  SUMMARY.groupby('Warehouse').Invoice.mean()
print(ratio_wkday)
# print('Average number of invoices by warehouse = \n\n', SUMMARY.groupby('Warehouse').Invoice.mean())


# In[ ]:



