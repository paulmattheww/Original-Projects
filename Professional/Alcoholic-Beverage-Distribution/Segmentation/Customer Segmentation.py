import pandas as pd
import numpy as np
import glob
from IPython.display import display
from datetime import datetime as dt
import datetime
pd.set_option('display.max_columns', None)

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

def generate_newcust_cutoff():
    from datetime import datetime as dt
    if dt.now().month == 1:
        last_month = '12'
    else:
        last_month = str(dt.now().month - 1).zfill(2)
    if dt.now().month == 1:
            this_year = str(dt.now().year - 1)
    else:
        this_year = str(dt.now().year)
    m_y_cutoff = last_month + '-' + this_year
    return m_y_cutoff


def as400_date(dat):
    '''Accepts date as formatted in AS400'''
    dat = str(dat)
    dat = dat[-6:]
    dat = pd.to_datetime(dt.strptime(dat, '%y%m%d'))
    return dat


def get_production_days(year):
    T_F = ['Tuesday','Wednesday','Thursday','Friday']
    dayz = np.sum([int(str(format(dat, '%A')) in T_F) for dat in pd.date_range('1/1/'+str(year), periods=365, freq='d')])
    return dayz

def sum_digits_in_string(digit):
    return sum(int(x) for x in digit if x.isdigit())

def extract_customer_delivery_info(deliveries, year):
    '''Extract delivery information about customers'''
    import itertools
    from pandas import DataFrame, Series
    weeklookup = generate_calendar(year=year)
    deliveries = deliveries.merge(weeklookup, on='Date')
    
    week_plan, week_shipped = deliveries.ShipWeekPlan.tolist(), deliveries.ShipWeek.tolist()
    
    deliveries.Ship = del_days = [str('%07d'% int(str(day).zfill(0))) for day in deliveries.Ship.astype(str).tolist()]

    mon = Series([d[-7:][:1] for d in del_days]).map({'1':'M','0':'_'})
    tue = Series([d[-6:][:1] for d in del_days]).map({'1':'T','0':'_'})
    wed = Series([d[-5:][:1] for d in del_days]).map({'1':'W','0':'_'})
    thu = Series([d[-4:][:1] for d in del_days]).map({'1':'R','0':'_'})
    fri = Series([d[-3:][:1] for d in del_days]).map({'1':'F','0':'_'})
    sat = Series([d[-2:][:1] for d in del_days]).map({'1':'S','0':'_'})
    sun = Series([d[-1:][:1] for d in del_days]).map({'1':'U','0':'_'})
    
    deliveries['DeliveryDays'] = del_days = list(itertools.chain.from_iterable([mon + tue + wed + thu + fri + sat + sun]))
    
    weekday = deliveries.Weekday = [d[:3] for d in deliveries.Weekday.astype(str).tolist()]
    _days = pd.DataFrame(data={'Weekday':weekday, 'WeekPlanned':week_plan, 'WeekShipped':week_shipped, 'DelDays':del_days}) #'Monday':mon, 'Tuesday':tue, 'Wednesday':wed, 'Thursday':thu, 'Friday':fri, 'Saturday':sat, 'Sunday':sun,
    day_list = _days['WeekPlanned'].tolist()
    _days['WeekPlanned'] = _week_planned = [d if d in ['A','B'] else '' for d in day_list]
    
    _week_actual = _days.WeekShipped.tolist()
    _week_plan = _days['WeekPlanned'] = [ship_week if plan_week == '' else plan_week for ship_week, plan_week in zip(_week_actual, _week_planned)]
    _days['OffWeek'] = _off_week = [p != a for p, a in zip(_week_plan, _week_actual)]
    
    off_mon = [str('M' not in d and w == 'Mon')[:1] for d, w in zip(del_days, weekday)]
    off_tue = [str('T' not in d and w == 'Tue')[:1] for d, w in zip(del_days, weekday)]
    off_wed = [str('W' not in d and w == 'Wed')[:1] for d, w in zip(del_days, weekday)]
    off_thu = [str('R' not in d and w == 'Thu')[:1] for d, w in zip(del_days, weekday)]
    off_fri = [str('F' not in d and w == 'Fri')[:1] for d, w in zip(del_days, weekday)]
    off_sat = [str('S' not in d and w == 'Sat')[:1] for d, w in zip(del_days, weekday)]
    off_sun = [str('U' not in d and w == 'Sun')[:1] for d, w in zip(del_days, weekday)]
    
    _off_days = DataFrame({'Mon':off_mon, 'Tue':off_tue, 'Wed':off_wed, 'Thu':off_thu, 
                           'Fri':off_fri, 'Sat':off_sat, 'Sun':off_sun, 'OffWeek':_off_week, 'Weekday':weekday})
    _off_days = _off_days[['Mon','Tue','Wed','Thu','Fri','Sat','Sun','Weekday','OffWeek']]    
    _off_days['OffDayDelivery'] = (_off_days['Mon'] == 'T') | (_off_days['Tue'] == 'T') | (_off_days['Wed'] == 'T') | (_off_days['Thu'] == 'T') | (_off_days['Fri'] == 'T') | (_off_days['Sat'] == 'T') | (_off_days['Sun'] == 'T') | (_off_days['OffWeek'] == True)                

    setup_date = deliveries.CustomerSetup.astype(str).tolist()
    setup_month = Series([d.zfill(4)[:2] for d in setup_date])
    setup_year = Series(["20" + s[-2:] if int(s[-2:]) < 20 else "19" + s[-2:] for s in setup_date]) #this_century = [int(d[-2:]) < 20 for d in setup_date]
    deliveries['CustomerSetup'] = c_setup = [str(mon) + '-' + str(yr) for mon, yr in zip(setup_month, setup_year)]
    
    m_y_cutoff = generate_newcust_cutoff()
    deliveries['NewCustomer'] = [1 if m_y_cutoff == setup else 0 for setup in c_setup]
    deliveries['OffDayDeliveries'] =  _off_days.OffDayDelivery.astype(int)
    
    _n_days = deliveries.Ship.astype(str).tolist()
    deliveries['AllottedWeeklyDeliveryDays'] = [sum_digits_in_string(n) for n in _n_days]
    _allot = deliveries['AllottedWeeklyDeliveryDays'].tolist()
    _week_ind = deliveries['ShipWeekPlan'].tolist()
    deliveries['AllottedWeeklyDeliveryDays'] = [a if w not in ['A','B'] else 0.5 for a, w in zip(_allot, _week_ind)]

        ################################# 
        #### come back later and get addl deliveries
        #################################
#     _n_days = deliveries.set_index('CustomerId')['AllottedWeeklyDeliveryDays'].to_dict()
    
#     for_addl_days = ['CustomerId','Week','AllottedWeeklyDeliveryDays','OffDayDeliveries']
#     deliveries[for_addl_days].groupby(['CustomerId','Week'])
#     deliveries['AdditionalDeliveryDays'] = 
    
#     print('Aggregating by Day.')
#     len_unique = lambda x: len(pd.unique(x))
#     agg_funcs_day = {'OffDayDeliveries' : {'Count':max}, 
#                  'Date' : {'Count':len_unique},
#                  'Cases' : {'Sum':sum, 'Avg':np.mean},
#                  'Dollars' : {'Sum':sum, 'Avg':np.mean},
#                  'NewCustomer': lambda x: min(x)}
    
#     pass_through_cols = ['CustomerId','Customer','Week','Date']
#     _agg_byday = DataFrame(deliveries.groupby(pass_through_cols).agg(agg_funcs_day)).reset_index(drop=False)
#     _agg_byday = DataFrame(_agg_byday[['CustomerId','Customer','Week','Date','OffDayDeliveries','NewCustomer','Cases','Dollars']])
#     _agg_byday.columns = ['%s%s' % (a, '|%s' % b if b else '') for a, b in _agg_byday.columns]
#     _agg_byday.columns = ['CustomerId','Customer','Week','Date','Delivery','OffDayDelivery','NewCustomer','Cases|Sum','Cases|Avg','Dollars|Sum','Dollars|Avg']
#     _agg_byday['AllottedWeeklyDeliveryDays|Count'] = _agg_byday['CustomerId'].astype(int)
#     _agg_byday['AllottedWeeklyDeliveryDays|Count'] = _agg_byday['AllottedWeeklyDeliveryDays|Count'].map(_n_days)
    
    
#     print('Mapping number of deliveries to Customers.')
#     # Map number of total deliveries each week by customer
#     # to determine whether a customer with TWR deliveries 
#     # got TWF deliveries -- which is an off-day delivery
#     # but not an additional delivery. Use a dictionary {(cust#, week) : n_deliveries_total}
#     agg_funcs_week = {'OffDayDelivery' : {'Count':sum},
#                       'Delivery' : {'Count':sum},
#                       'NewCustomer' : lambda x: min(x)}
    
#     _agg_byweek = DataFrame(_agg_byday.groupby(['CustomerId','Week']).agg(agg_funcs_week)).reset_index(drop=False)
#     _agg_byweek.columns = ['%s%s' % (a, '|%s' % b if b else '') for a, b in _agg_byweek.columns]

#     _c = _agg_byweek['CustomerId'].astype(str).tolist()
#     _w = _agg_byweek['Week'].astype(str).tolist()
#     _agg_byweek['_X'] = [c + ',' + w for c,w in zip(_c,_w)]
#     by_week_map = _agg_byweek.set_index('_X')['Delivery|Count'].to_dict()
    
#     cid = _agg_byday['CustomerId'].astype(str).tolist()
#     wkk = _agg_byday['Week'].astype(str).tolist()
#     _agg_byday['N_DeliveriesThisWeek'] = [c + ',' + w for c, w in zip(cid, wkk)]
#     _agg_byday['N_DeliveriesThisWeek'] = _agg_byday['N_DeliveriesThisWeek'].map(Series(by_week_map))
    
    
#     print('Using custom logic to define Additional Delivery Days.')
#     addl_day_criteria_1 = ( _agg_byday.shift(1)['CustomerId'] == _agg_byday['CustomerId'] )
#     addl_day_criteria_2 = ( _agg_byday.shift(1)['Week'] == _agg_byday['Week'] )
#     addl_day_criteria_3 = ( _agg_byday['OffDayDelivery'] == 1 )
#     addl_day_criteria_4 = ( _agg_byday['NewCustomer'] != 1 )
#     addl_day_criteria_5 = ( _agg_byday['N_DeliveriesThisWeek'] > _agg_byday['AllottedWeeklyDeliveryDays|Count'] )
    
#     _agg_byday['AdditionalDeliveryDays'] = Series(addl_day_criteria_1 & addl_day_criteria_2 & addl_day_criteria_3 & addl_day_criteria_4 & addl_day_criteria_5).astype(int)
    
    
    
    return deliveries


path = 'C:\\Users\\pmwash\\Desktop\\Re-Engineered Reports\\Customer Segmentation\\Data\\*.csv'

def generate_customer_features(path, year):
    '''Reads query for customer segmentation for Roadnet'''
    all_files = glob.glob(path)
    
    DF_OUT = pd.DataFrame()
    for file in all_files:
        # Specify datatypes from start to avoid issues downstream
        print('Reading in file %s' %file)
        dtypes = col_names = {'#MCUS#':str,'#MIVDT':str,'#MIVND':str,'#MLIN#':str,'#MPRD#':str,'#MQTYS':np.int64,
                    'CSCRDT':str,'CCRLIM':np.float64,'CONPRM':str,'CUSPMC':str,'CDDAY':str,
                    '#MEXT$':np.float64,'CTERM@':str,'#MCOS$':np.float64,'CSTOR#':str,'#MCHN#':str,'#MCUSY':str,
                    '#MSLSP':str,'#MQPC':np.int64,'#MCLA@':str,'#MSIZ@':str,'#MBRND':str,'#MQTY@':str,
                    '#MCMP':str,'#MSUPL':str,'#MCALL':str,'#MPRIO':str,'#MINP#':str,
                    '#CSTDTE':str,'CUDSCC':str,'CSHP':str,'CADMBR':str}
        c = pd.read_csv(file, header=0, dtype=dtypes)

        ## Rename columns to make sense
        col_names = {'#MCUS#':'CustomerId','#MIVDT':'Date','#MIVND':'Invoice','#MLIN#':'Line','#MPRD#':'SupplierBrandSizeNumber','#MQTYS':'QuantitySold',
                    'CSCRDT':'SeasonCreditLimit','CCRLIM':'CreditLimit','CONPRM':'OnPremise','CUSPMC':'MerchandiseClass','CDDAY':'X2',
                    '#MEXT$':'Revenue','CTERM@':'TermsCode','#MCOS$':'Cost','CSTOR#':'BarChainCode','#MCHN#':'ChainId','#MCUSY':'CustomerType',
                    '#MSLSP':'SalespersonId','#MQPC':'QPC','#MCLA@':'ClassCode','#MSIZ@':'SizeCode','#MBRND':'BrandId','#MQTY@':'QtyCode',
                    '#MCMP':'Warehouse','#MSUPL':'SupplierId','#MCALL':'CallCode','#MPRIO':'Priority','#MINP#':'ProductId','#MPRM@':'X1',
                    'CSTDTE':'CustomerSetup','CUDSCC':'DisplayCaseClass','CSHP':'Ship','CADMBR':'ShipWeekPlan'}
        c.rename(columns=col_names, inplace=True)
        c.drop(labels=['X1','X2'], axis=1, inplace=True)

        ## Extract Invoice & Line
        c['InvoiceLine'] = [str(a)+'_'+str(b) for a,b in zip(c.Invoice, c.Line)]

        ## Extract proper dates and derivative data
        c.Date = dat = c.Date.apply(as400_date)
        
        ## Extract Cases 
        CS, QPC = c.loc[c['QtyCode'] == 'C', 'QuantitySold'].astype(np.float64), c.loc[c['QtyCode'] == 'B', 'QPC'].astype(np.float64)
        BTLS = c.loc[c.QtyCode == 'B', 'QuantitySold'].astype(np.float64)
        c.loc[c.QtyCode == 'C', 'Cases'] = CS
        c.loc[c.QtyCode == 'B', 'Cases'] = np.divide(BTLS, QPC)

        ## Extract Bottles
        QPC_tobtl = c.loc[c['QtyCode'] == 'C', 'QPC'].astype(np.float64)
        c.loc[c.QtyCode == 'C', 'Bottles'] = np.multiply(CS, QPC_tobtl)
        c.loc[c.QtyCode == 'B', 'Bottles'] = BTLS
        
        ## Get delivery info specified in function above
        c = extract_customer_delivery_info(deliveries=c, year=year)
        
        ## Extract features from data
        lastday = pd.DataFrame(c[c.LastSellingDayOfMonth == True][['CustomerId','Cases']].fillna(0).groupby('CustomerId').sum()).reset_index(drop=False)
        lastday_dict = dict(zip(lastday.CustomerId, lastday.Cases))
        c['CasesSoldOnLastSellingDayOfMonth'] = c.CustomerId.map(lastday_dict)
        
        holidayweek = pd.DataFrame(c[c.HolidayWeek == True][['CustomerId','Cases']].fillna(0).groupby('CustomerId').sum()).reset_index(drop=False)
        holidayweek_dict = dict(zip(holidayweek.CustomerId, holidayweek.Cases))
        c['CasesSoldOnHolidayWeeks'] = c.CustomerId.map(holidayweek_dict)
        
        ## Label customer types, call codes, class codes & warehouse
        type_map = {'A':'Bar/Tavern','C':'Country Club','E':'Transportation/Airline','G':'Gambling',\
                        'J':'Hotel/Motel','L':'Restaurant','M':'Military','N':'Fine Dining','O':'Internal',\
                        'P':'Country/Western','S':'Package Store','T':'Supermarket/Grocery','V':'Drug Store',\
                        'Y':'Convenience Store','Z':'Catering','3':'Night Club','5':'Adult Entertainment','6':'Sports Bar',\
                        'I':'Church','F':'Membership Club','B':'Mass Merchandiser','H':'Fraternal Organization',\
                        '7':'Sports Venue'}
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
        
        ## Append new data to a dataframe that compiles all of it
        DF_OUT = DF_OUT.append(c)
    
    print(DF_OUT.head(), '\n\n\n')
    
    ## Save customer attributes from raw data
    attr = ['CustomerId','DeliveryDays','CustomerType','SeasonCreditLimit','OnPremise','DisplayCaseClass']
    customer_attributes = DF_OUT[attr].drop_duplicates()
    
    ## Aggregate together
    print('\n\nAggregating by Customer\n\n')
    ## Aggregate data in-memory since files are too large to operate on in raw form
    agg_functions = {'Cases' : np.sum, 
                     'Bottles' : np.sum, 
                     'Invoice' : pd.Series.nunique, 
                     'InvoiceLine' : pd.Series.nunique,
                     'Revenue' : np.sum, 
                     'Cost' : np.sum,
                     'ProductId' : pd.Series.nunique,
                     'BrandId' : pd.Series.nunique,
                     'SupplierId' : pd.Series.nunique,
                     'SalespersonId' : pd.Series.nunique,
                     'TermsCode' : np.max,
                     'CreditLimit' : np.max,
                     'CasesSoldOnLastSellingDayOfMonth' : np.max,
                     'CasesSoldOnHolidayWeeks' : np.max,
                     'AllottedWeeklyDeliveryDays' : np.max,
                     'OffDayDeliveries' : np.sum
                     }
    
    DF_OUT = pd.DataFrame(DF_OUT.groupby(['Warehouse','CustomerId']).agg(agg_functions)).reset_index(drop=False)
    print(DF_OUT.head())
    
    ## Derive further attributes
    T_F = ['Tuesday','Wednesday','Thursday','Friday']
    PRODUCTION_DAYZ = np.sum(generate_calendar(year=year)['IsProductionDay']) 
    per_day_cols = ['Cases','Bottles','Invoice','InvoiceLine','Revenue']
    colnames_perday = ['CasesPerDay','BottlesPerDay','InvoicesPerDay','InvoiceLinesPerDay','RevenuePerDay']
    DF_OUT[colnames_perday] = np.divide(DF_OUT[per_day_cols], PRODUCTION_DAYZ)
    DF_OUT['AvgDaysBetweenInvoices'] = np.divide(1, DF_OUT['InvoicesPerDay'])
    DF_OUT['CasesSoldOnLastSellingDayOfMonth_PercentOfTotal'] = np.divide(DF_OUT['CasesSoldOnLastSellingDayOfMonth'], DF_OUT['Cases'])
    DF_OUT['CasesSoldOnLastSellingDayOfMonth_PercentOfTotal'] = DF_OUT['CasesSoldOnLastSellingDayOfMonth_PercentOfTotal'].fillna(0)
    DF_OUT['CasesSoldOnHolidayWeeks_PercentOfTotal'] = np.divide(DF_OUT['CasesSoldOnHolidayWeeks'], DF_OUT['Cases'])
    DF_OUT['CasesSoldOnHolidayWeeks_PercentOfTotal'] = DF_OUT['CasesSoldOnHolidayWeeks_PercentOfTotal'].fillna(0)
    DF_OUT['CasesPerUniqueBrand'] = np.divide(DF_OUT['Cases'], DF_OUT['BrandId'])
    DF_OUT['CasesPerUniqueSalesperson'] = np.divide(DF_OUT['Cases'], DF_OUT['SalespersonId'])
    DF_OUT['CasesPerInvoice'] = np.divide(DF_OUT['Cases'], DF_OUT['Invoice'])
    DF_OUT['CasesPerInvoiceLine'] = np.divide(DF_OUT['Cases'], DF_OUT['InvoiceLine'])
    DF_OUT['GP'] = np.divide(DF_OUT['Revenue'], DF_OUT['Cost'])
    DF_OUT['GPperBrand'] = np.divide(DF_OUT['GP'], DF_OUT['BrandId'])
    DF_OUT['GPperSalesperson'] = np.divide(DF_OUT['GP'], DF_OUT['SalespersonId'])
    DF_OUT['BrandsPerSalesperson'] = np.divide(DF_OUT['BrandId'], DF_OUT['SalespersonId'])
    
    DF_OUT = DF_OUT.merge(customer_attributes, on='CustomerId')
    
    ffill_cols = ['CasesSoldOnLastSellingDayOfMonth','CasesSoldOnHolidayWeeks',
                  'CasesSoldOnLastSellingDayOfMonth_PercentOfTotal','CasesSoldOnHolidayWeeks_PercentOfTotal']
    DF_OUT[ffill_cols] = DF_OUT[ffill_cols].fillna(0)
    DF_OUT[ffill_cols] = DF_OUT[ffill_cols].replace(np.inf, 0)
    DF_OUT['OnPremise'] = DF_OUT['OnPremise'].map({'Y':1,'N':0,'':0})
    
    DF_OUT.set_index(['Warehouse','CustomerId'], inplace=True)
    
    return DF_OUT

CUSTOMER_SUMMARY = generate_customer_features(path, year=2016)
print(CUSTOMER_SUMMARY.head())    
