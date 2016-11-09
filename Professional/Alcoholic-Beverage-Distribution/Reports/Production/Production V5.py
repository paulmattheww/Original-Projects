'''
Production Report
Re-Engineered November 2016
'''

import pandas as pd
from pandas import DataFrame
import numpy as np
import glob
import re
from datetime import datetime as dt
import datetime
import string


pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 100)
pd.set_option('display.width', 200)


temp_location = 'C:\\Users\\pmwash\\Desktop\\Disposable Docs\\Production Data\\'
file_list = glob.glob(temp_location + '*.xls*')



def extract_date_stl(file):
        '''Takes date from file name'''
        regex_criteria = re.compile(r'[0-9]+-[0-9]+')    
        dat = re.findall(regex_criteria, file)
        
        exclude = set(string.punctuation)
        dat = ''.join(d for d in dat if d not in exclude)
        
        this_year = str(dt.today().year)
        dat = str(dat + '-' + this_year)
        dat = dt.strptime(str(dat), "%m-%d-%Y").date()
        return dat


def extract_stl_production_tab(file, df):
        '''
        Takes in and formats Production Tab from Daily Report. 
        Extracts date from filename and creates index.
        Puts into a dictionary of dataframes 
        for input into a pandas DataFrame.
        '''
        dtypes = {'Date':dt.date, 'Warehouse':str,'LOC':str,'RTE':str,'Driver':str,'Truck#':str,
                'Stops':np.float64,'TTL Cs/splt':np.float64,'Cs':np.float64,'Btls':np.float64,
                'Start Hr':str, 'End Hr':str,'Ttl Hrs':str,'Ttl Mi':np.float64 }
        df = pd.read_excel(file, sheetname='Production', converters=dtypes)
    
        dat = extract_date_stl(file)
        
        df['Date'] = dat 
        df['Month'] = dat.strftime('%B')
        df['Weekday'] = dat.strftime('%A')
        df['WeekNumber'] = dat.strftime('%U')
        df['DOTM'] = dat.strftime('%d')
        df['Warehouse'] = 'STL'
        
        keep_cols = ['Date','Warehouse','LOC','RTE','Driver','Truck#','Stops',
                     'TTL Cs/splt','Cs','Btls','Start Hr',
                     'End Hr','Ttl Hrs','Ttl Mi','Month','Weekday','WeekNumber',
                     'DOTM']
        df = df[keep_cols].drop_duplicates()
        
        WAREHOUSE, ROUTE = df.Warehouse.astype(str), df.RTE.astype(str)
        new_index = WAREHOUSE + '_' + ROUTE 
        
        df.set_index(new_index, inplace=True)
        
        df = df[df['Driver'] != 'Totals:']        
        df = df.sort_values(['Stops','TTL Cs/splt'], ascending=False).reset_index(drop=False)
        
        df['Date'] = df['Date'].replace(to_replace='NaN', value='')
        df = df[df['Date'].isnull() == False]
        
        return df, dat


Production_Tab = pd.DataFrame()        

for i, file in enumerate(file_list):
    df, dat = extract_stl_production_tab(file, df)
    Production_Tab = Production_Tab.append(df)
    print('Adding production tab data for %s' % dat)


Production_Tab.head(100)
cols = ['Stops','TTL Cs/splt', 'Ttl Mi']
Production_Tab.groupby(['LOC'])[cols].sum()





def extract_stl_night_hours_tab(file):
        '''
        Takes in and formats Night Hours tab from Daily Report. 
        Extracts date from filename and creates index.
        Puts into a dictionary of dataframes 
        for input into a pandas DataFrame.
        '''
        senior = pd.read_excel(file, sheetname='Night hours', skiprows=6, skip_footer=1, na_values=['NaN',np.nan,np.NaN,np.NAN], header=0)
        casual = pd.read_excel(file, sheetname='Night hours', skiprows=34, skip_footer=1, na_values=['NaN',np.nan,np.NaN,np.NAN], header=0)
        
        dat = extract_date_stl(file)
        
        senior['Date'] = casual['Date'] = dat 
        senior['Month'] = casual['Month']  = dat.strftime('%B')
        senior['Weekday'] = casual['Weekday']  = dat.strftime('%A')
        senior['WeekNumber'] = casual['WeekNumber'] = dat.strftime('%U')
        senior['DOTM'] = casual['DOTM'] = dat.strftime('%d')
        senior['Warehouse'] = casual['Warehouse'] = 'STL'
        
        keep_cols = ['Date','NAME','HRS WORKED','REG TIME','O.T HOURS',
                    'Month','Weekday','WeekNumber','DOTM','Warehouse']
            
        senior = senior[keep_cols].drop_duplicates()
        casual = casual[keep_cols].drop_duplicates()
        
        senior['Type'] = 'Senior'
        casual['Type'] = 'Casual'
        
        senior = senior[senior['NAME'].isnull() == False]
        casual = casual[casual['NAME'].isnull() == False]
        
        df = senior.append(casual)
        df.reset_index(drop=True, inplace=True)
        
        return df
        
        
        
NightlyHours_Tab = pd.DataFrame()        

for i, file in enumerate(file_list):
    df = extract_stl_night_hours_tab(file)
    
    NightlyHours_Tab = NightlyHours_Tab.append(df)


NightlyHours_Tab.head(100)

















def extract_stl_over_short_tabs(file):
        '''
        Takes in and formats BOTH O/S tabs from Daily Report. 
        Extracts date from filename and creates index.
        Puts into a dictionary of dataframes 
        for input into a pandas DataFrame.
        '''
        dtypes = {'Driver #':np.int,'Customer #':np.int,'RTE':np.int,'Item #':int,'CS':np.float64,'BTL':np.float64}
        stl_os = pd.read_excel(file, sheetname='Over-Short', skip_footer=1, na_values=['NaN',np.nan,np.NaN,np.NAN], header=0, dtypes=col_dtypes)
        col_os = pd.read_excel(file, sheetname='Col. Over - Short', skip_footer=1, na_values=['NaN',np.nan,np.NaN,np.NAN], header=0, col_dtypes=dtypes)
        
        dat = extract_date_stl(file)
        
        stl_os['Date'] = col_os['Date'] = dat 
        stl_os['Month'] = col_os['Month']  = dat.strftime('%B')
        stl_os['Weekday'] = col_os['Weekday']  = dat.strftime('%A')
        stl_os['WeekNumber'] = col_os['WeekNumber'] = dat.strftime('%U')
        stl_os['DOTM'] = col_os['DOTM'] = dat.strftime('%d')
        stl_os['Warehouse'] = col_os['Warehouse'] = 'STL'
        
        keep_cols = ['Date','Driver #','Customer #','RTE','Item #',
                    'CS','BTL','Month','Weekday','WeekNumber','DOTM','Warehouse']
            
        stl_os = stl_os[keep_cols].reset_index(drop=True)
        col_os = col_os[keep_cols].reset_index(drop=True)
        
        stl_os['Type'] = 'STL'
        col_os['Type'] = 'COL'
        
        stl_os = stl_os[stl_os['RTE'].isnull() == False]
        col_os = col_os[col_os['RTE'].isnull() == False]
        
        df = stl_os.append(col_os)
        
        non_decimal = re.compile(r'[^\d.]+')
        drv_no, cus_no, itm_no = df['Driver #'].astype(str).tolist(), df['Customer #'].astype(str).tolist(), df['Item #'].astype(str).tolist()
        df['Driver #'] = [non_decimal.sub('', d) for d in drv_no]
        df['Customer #'] = [non_decimal.sub('', c) for c in cus_no]
        df['Item #'] = [non_decimal.sub('', i) for i in itm_no]
        
        df['Driver #'] = pd.to_numeric(df['Driver #'], errors='coerce')
        df['Customer #'] = pd.to_numeric(df['Customer #'], errors='coerce')
        df['Item #'] = pd.to_numeric(df['Item #'], errors='coerce')
        df.fillna(0, inplace=True)
        
        df[['Driver #','Customer #','Item #']] = df[['Driver #','Customer #','Item #']].astype(int)
        
        df.reset_index(drop=True, inplace=True)
        
        return df
        
        
        
OverShort_Tab = pd.DataFrame()        

for i, file in enumerate(file_list):
    df = extract_stl_over_short_tabs(file)
    OverShort_Tab = OverShort_Tab.append(df)
    OverShort_Tab.reset_index(drop=True, inplace=True)
    


OverShort_Tab.head(50)












def extract_stl_returns_tab(file):
        '''
        Takes in and formats the Returns tab from Daily Report. 
        Extracts date from filename and creates index.
        Puts into a dictionary of dataframes 
        for input into a pandas DataFrame.
        '''
        dtypes = {'Driver #':np.int,'Inv#':np.int64,'Customer':str,'Cust#':np.int64,
            'Driver #':np.int64,'Driver':str,'Reason':str,'Cases':np.float64,
            'Bottles':np.float64,'Pick up Cases':np.float64,'Empty Boxes':np.float64,
            'PLLTS':np.int64,'Kegs':np.int64,'POS':np.int64,'Bonus':np.float64,'Inv Amt':np.float64,
            'Driver Return or Customer Return':str,'Inv#':np.int64
        }
        returns = pd.read_excel(file, sheetname='Returns', skip_footer=1, na_values=['NaN',np.nan,np.NaN,np.NAN], header=0, col_dtypes=dtypes, skiprows=2)
        
        returns.fillna(0, inplace=True)
        dat = extract_date_stl(file)
        
        returns['Date'] =  dat 
        returns['Month'] = dat.strftime('%B')
        returns['Weekday'] = dat.strftime('%A')
        returns['WeekNumber'] = dat.strftime('%U')
        returns['DOTM'] = dat.strftime('%d')
        returns['Warehouse'] = 'STL'
        
        keep_cols = ['Date','Driver Return or Customer Return','Inv#',
                    'Cust#','Customer','Driver #','Driver','Reason','Cases','Bottles',
                    'Pick up Cases','Empty Boxes','PLLTS','Kegs','Empty Kegs',
                    'POS','Bonus','Inv Amt','Sales Person',
                    'Month','Weekday','WeekNumber','DOTM','Warehouse']
            
        returns = returns[keep_cols].reset_index(drop=True)

        returns = returns[returns['Driver Return or Customer Return'] != 0]
        
        returns.reset_index(drop=True, inplace=True)
        
        return returns
        
        
        
Returns_Tab = pd.DataFrame()        

for i, file in enumerate(file_list):
    df = extract_stl_returns_tab(file)
    Returns_Tab = Returns_Tab.append(df)
    Returns_Tab.reset_index(drop=True, inplace=True)
    
    
Returns_Tab.head(20)
    
    
    
    
    
    
    












def extract_stl_summary_tab(file):
    '''
    Extracts summary tab by cell.
    '''
    summary_tab = pd.read_excel(file, sheetname='Summary', skip_footer=1, na_values=['NaN',np.nan,np.NaN,np.NAN], header=0, skiprows=1, names=np.arange(1,14))
    keep_cols = [1,2,4,5,9,10,12,13]
    summary_tab = summary_tab[keep_cols]
    summary_tab.head(25)
    
    cases_returned = summary_tab.loc[2,2]#
    btls_returned = summary_tab.loc[3,2]
    dollars_returned = summary_tab.loc[5,2]
    overs = summary_tab.loc[8,2]
    shorts = summary_tab.loc[9,2]
    mispicks = summary_tab.loc[12,2]
    total_errors = summary_tab.loc[17,2]
    
    total_cases = summary_tab.loc[2,5]#
    total_cases_contech = summary_tab.loc[48,10]
    cases_stl = summary_tab.loc[3,5]
    kegs = summary_tab.loc[20,10] #from Contech
    kc_transfer = summary_tab.loc[5,5]
    cases_col = summary_tab.loc[6,5]
    cases_cape = summary_tab.loc[7,5]
    
    total_bottles = summary_tab.loc[9,5]#
    stl_btls = summary_tab.loc[10,5]
    col_btls = summary_tab.loc[11,5]
    cap_btls = summary_tab.loc[12,5]
    
    total_stops = summary_tab.loc[13,5]#
    stops_stl = summary_tab.loc[14,5]
    stops_cape = summary_tab.loc[15,5]
    stops_col = summary_tab.loc[16,5]
    total_trucks = summary_tab.loc[17,5] 
    trucks_package = summary_tab.loc[18,5]
    trucks_keg = summary_tab.loc[19,5]
    
    total_hours = summary_tab.loc[31,5]
    loading_hours = summary_tab.loc[26,10]
    senior_hours = summary_tab.loc[32,5]
    casual_hours = summary_tab.loc[33,5]
    total_reg_hours = summary_tab.loc[34,5]
    senior_reg_hours = summary_tab.loc[35,5]
    casual_reg_hours = summary_tab.loc[36,5]
    total_ot_hours = summary_tab.loc[37,5]
    senior_ot_hours = summary_tab.loc[38,5]
    casual_ot_hours = summary_tab.loc[39,5]
    temp_hours = summary_tab.loc[40,5]
    total_absent_employees = summary_tab.loc[42,5]
    senior_absent = summary_tab.loc[43,5]
    casual_absent = summary_tab.loc[44,5]
    total_employees_on_hand = summary_tab.loc[47,5]
    completion_time = summary_tab.loc[48,5]
    
    number_of_waves = summary_tab.loc[49,10]
    non_conveyable = summary_tab.loc[24,10]
    pallet_picks = summary_tab.loc[25,10]
    sorter_run_time = summary_tab.loc[27,10]
    loading_hours = summary_tab.loc[26,10]
    jackpot_cases = summary_tab.loc[30,10]
    
    cpmh = summary_tab.loc[49,5]
    cpmh_adjusted = summary_tab.loc[50,5]
    cases_per_hour = summary_tab.loc[20,5]
    cpmh_c = summary_tab.loc[24,5]
    cpmh_d = summary_tab.loc[25,5]
    cpmh_e = summary_tab.loc[26,5]
    cpmh_f = summary_tab.loc[27,5]
    cpmh_g = summary_tab.loc[28,5]
    cases_c = summary_tab.loc[4,10]
    cases_d = summary_tab.loc[6,10]
    cases_e = summary_tab.loc[8,10]
    cases_f = summary_tab.loc[10,10]
    cases_g = summary_tab.loc[12,10]
    cases_w = summary_tab.loc[14,10]
    hours_w = summary_tab.loc[15,10]
    cpmh_w = cases_w / hours_w
    cases_oddball = summary_tab.loc[16,10]
    hours_oddball = summary_tab.loc[17,10]
    cpmh_oddball = cases_oddball / hours_oddball
    
    dat = extract_date_stl(file)
    
    the_row = {'Date':dat, 
                'CPMH':cpmh, 'CPMH|adjusted':cpmh_adjusted, 
                'Cases|total':total_cases, 'Cases|contech':total_cases_contech, 'Cases|perhour':cases_per_hour,
                'Cases|stl':cases_stl, 'Cases|col':cases_col, 'Cases|cape':cases_cape,
                'Kegs':kegs, 'Cases|kctransfer':kc_transfer, 
                'Bottles|total':total_bottles, 'Bottles|stl':stl_btls, 'Bottles|col':col_btls, 
                'Bottles|cape':cap_btls,
                'Returns|cases':cases_returned, 'Returns|btls':btls_returned, 'Returns|dollars':dollars_returned,
                'Overs':overs, 'Shorts':shorts, 'Mispicks':mispicks, 'TotalErrors':total_errors,
                'Stops|total':total_stops, 'Stops|stl':stops_stl, 'Stops|cape':stops_cape,
                'Stops|col':stops_col,
                'Trucks|total':total_trucks, 'Trucks|package':trucks_package, 'Trucks|keg':trucks_keg,
                'Hours|loading':loading_hours,
                'Hours|total':total_hours, 'Hours|senior':senior_hours, 'Hours|casual':casual_hours,
                'Hours|regular':total_reg_hours, 'Hours|regular|senior':senior_reg_hours, 'Hours|regular|casual':casual_reg_hours,
                'Hours|overtime':total_ot_hours, 'Hours|overtime|senior':senior_ot_hours, 'Hours|overtime|casual':casual_ot_hours,
                'Hours|temp':temp_hours, 'Hours|loading':loading_hours, 'Hours|oddball':hours_oddball,
                'Employees|absent':total_absent_employees, 'Employees|absent|senior':senior_absent, 'Employees|absent|casual':casual_absent,
                'Employees|total':total_employees_on_hand, 
                'CPMH|cline':cpmh_c, 'CPMH|dline':cpmh_d, 'CPMH|eline':cpmh_e, 'CPMH|fline':cpmh_f, 
                'CPMH|gline':cpmh_g, 'CPMH|wine':cpmh_w, 'CPMH|oddball':cpmh_oddball, 
                'Cases|cline':cases_c, 'Cases|dline':cases_d, 'Cases|eline':cases_e, 'Cases|fline':cases_f, 
                'Cases|gline':cases_g, 'Cases|wine':cases_w, 'Cases|oddball':cases_oddball, 
                'CompletionTime':completion_time,
                'Waves':number_of_waves, 'NonConveyable':non_conveyable, 'PalletPicks':pallet_picks,
                 'SorterRunTime':sorter_run_time, 'JackpotCases':jackpot_cases
    }
               
            
    summary_dataframe = pd.DataFrame()
    summary_dataframe = summary_dataframe.append(the_row, ignore_index=True)
    
    summary_dataframe['Date'] =  dat 
    summary_dataframe['Month'] = dat.strftime('%B')
    summary_dataframe['Weekday'] = dat.strftime('%A')
    summary_dataframe['WeekNumber'] = dat.strftime('%U')
    summary_dataframe['DOTM'] = dat.strftime('%d')
    summary_dataframe['Warehouse'] = 'STL'
    
    summary_dataframe.reset_index(drop=True, inplace=True)
    
    return summary_dataframe




Summary_Tab = pd.DataFrame()        

for i, file in enumerate(file_list):
    df = extract_stl_summary_tab(file)
    Summary_Tab = Summary_Tab.append(df)
    Summary_Tab.reset_index(drop=True, inplace=True)
    
    
Summary_Tab.head(20)































# TESTING
summary_tab = pd.read_excel(file, sheetname='Summary', skip_footer=1, na_values=['NaN',np.nan,np.NaN,np.NAN], header=0, skiprows=1, names=np.arange(1,14))
keep_cols = [1,2,4,5,9,10,12,13]
summary_tab = summary_tab[keep_cols]
summary_tab.head(25)

cases_returned = summary_tab.loc[2,2]#
btls_returned = summary_tab.loc[3,2]
dollars_returned = summary_tab.loc[5,2]
overs = summary_tab.loc[8,2]
shorts = summary_tab.loc[9,2]
mispicks = summary_tab.loc[12,2]
total_errors = summary_tab.loc[17,2]

total_cases = summary_tab.loc[2,5]#
total_cases_contech = summary_tab.loc[48,10]
cases_stl = summary_tab.loc[3,5]
kegs = summary_tab.loc[20,10] #from Contech
kc_transfer = summary_tab.loc[5,5]
cases_col = summary_tab.loc[6,5]
cases_cape = summary_tab.loc[7,5]

total_bottles = summary_tab.loc[9,5]#
stl_btls = summary_tab.loc[10,5]
col_btls = summary_tab.loc[11,5]
cap_btls = summary_tab.loc[12,5]

total_stops = summary_tab.loc[13,5]#
stops_stl = summary_tab.loc[14,5]
stops_cape = summary_tab.loc[15,5]
stops_col = summary_tab.loc[16,5]
total_trucks = summary_tab.loc[17,5] 
trucks_package = summary_tab.loc[18,5]
trucks_keg = summary_tab.loc[19,5]

total_hours = summary_tab.loc[31,5]
loading_hours = summary_tab.loc[26,10]
senior_hours = summary_tab.loc[32,5]
casual_hours = summary_tab.loc[33,5]
total_reg_hours = summary_tab.loc[34,5]
senior_reg_hours = summary_tab.loc[35,5]
casual_reg_hours = summary_tab.loc[36,5]
total_ot_hours = summary_tab.loc[37,5]
senior_ot_hours = summary_tab.loc[38,5]
casual_ot_hours = summary_tab.loc[39,5]
temp_hours = summary_tab.loc[40,5]
total_absent_employees = summary_tab.loc[42,5]
senior_absent = summary_tab.loc[43,5]
casual_absent = summary_tab.loc[44,5]
total_employees_on_hand = summary_tab.loc[47,5]
completion_time = summary_tab.loc[48,5]

number_of_waves = summary_tab.loc[49,10]
non_conveyable = summary_tab.loc[24,10]
pallet_picks = summary_tab.loc[25,10]
sorter_run_time = summary_tab.loc[27,10]
loading_hours = summary_tab.loc[26,10]
jackpot_cases = summary_tab.loc[30,10]

cpmh = summary_tab.loc[49,5]
cpmh_adjusted = summary_tab.loc[50,5]
cases_per_hour = summary_tab.loc[20,5]
cpmh_c = summary_tab.loc[24,5]
cpmh_d = summary_tab.loc[25,5]
cpmh_e = summary_tab.loc[26,5]
cpmh_f = summary_tab.loc[27,5]
cpmh_g = summary_tab.loc[28,5]
cases_c = summary_tab.loc[4,10]
cases_d = summary_tab.loc[6,10]
cases_e = summary_tab.loc[8,10]
cases_f = summary_tab.loc[10,10]
cases_g = summary_tab.loc[12,10]
cases_w = summary_tab.loc[14,10]
hours_w = summary_tab.loc[15,10]
cpmh_w = cases_w / hours_w
cases_oddball = summary_tab.loc[16,10]
hours_oddball = summary_tab.loc[17,10]
cpmh_oddball = cases_oddball / hours_oddball

dat = extract_date_stl(file)

the_row = {'Date':dat, 
            'CPMH':cpmh, 'CPMH|adjusted':cpmh_adjusted, 
            'Cases|total':total_cases, 'Cases|contech':total_cases_contech, 'Cases|perhour':cases_per_hour,
            'Cases|stl':cases_stl, 'Cases|col':cases_col, 'Cases|cape':cases_cape,
            'Kegs':kegs, 'Cases|kctransfer':kc_transfer, 
            'Bottles|total':total_bottles, 'Bottles|stl':stl_btls, 'Bottles|col':col_btls, 
            'Bottles|cape':cap_btls,
            'Returns|cases':cases_returned, 'Returns|btls':btls_returned, 'Returns|dollars':dollars_returned,
            'Overs':overs, 'Shorts':shorts, 'Mispicks':mispicks, 'TotalErrors':total_errors,
            'Stops|total':total_stops, 'Stops|stl':stops_stl, 'Stops|cape':stops_cape,
            'Stops|col':stops_col,
            'Trucks|total':total_trucks, 'Trucks|package':trucks_package, 'Trucks|keg':trucks_keg,
            'Hours|loading':loading_hours,
            'Hours|total':total_hours, 'Hours|senior':senior_hours, 'Hours|casual':casual_hours,
            'Hours|regular':total_reg_hours, 'Hours|regular|senior':senior_reg_hours, 'Hours|regular|casual':casual_reg_hours,
            'Hours|overtime':total_ot_hours, 'Hours|overtime|senior':senior_ot_hours, 'Hours|overtime|casual':casual_ot_hours,
            'Hours|temp':temp_hours, 'Hours|loading':loading_hours, 'Hours|oddball':hours_oddball,
            'Employees|absent':total_absent_employees, 'Employees|absent|senior':senior_absent, 'Employees|absent|casual':casual_absent,
            'Employees|total':total_employees_on_hand, 
            'CPMH|cline':cpmh_c, 'CPMH|dline':cpmh_d, 'CPMH|eline':cpmh_e, 'CPMH|fline':cpmh_f, 
            'CPMH|gline':cpmh_g, 'CPMH|wine':cpmh_w, 'CPMH|oddball':cpmh_oddball, 
            'Cases|cline':cases_c, 'Cases|dline':cases_d, 'Cases|eline':cases_e, 'Cases|fline':cases_f, 
            'Cases|gline':cases_g, 'Cases|wine':cases_w, 'Cases|oddball':cases_oddball, 
            'CompletionTime':completion_time,
            'Waves':number_of_waves, 'NonConveyable':non_conveyable, 'PalletPicks':pallet_picks,
             'SorterRunTime':sorter_run_time, 'JackpotCases':jackpot_cases
}
           
        
summary_dataframe = pd.DataFrame()
summary_dataframe = summary_dataframe.append(the_row, ignore_index=True)

summary_dataframe['Date'] =  dat 
summary_dataframe['Month'] = dat.strftime('%B')
summary_dataframe['Weekday'] = dat.strftime('%A')
summary_dataframe['WeekNumber'] = dat.strftime('%U')
summary_dataframe['DOTM'] = dat.strftime('%d')
summary_dataframe['Warehouse'] = 'STL'

summary_dataframe.reset_index(drop=True, inplace=True)

return summary_dataframe


summary_dataframe.head()






