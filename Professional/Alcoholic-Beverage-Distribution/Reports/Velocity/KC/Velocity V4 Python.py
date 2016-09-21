'''
Velocity Report, KC
Re-Done September 2016
Ensure saved as Excel document UTF8
Do NOT pre-sort the data
Save to same place each time
Read in the xlsx file exported from Compleo
Separate out cases and bottles
Run velocity separation process
Print to file
Send to group
'''

import pandas as pd
from pandas import read_excel, Series, Panel, DataFrame
import numpy as np
import re

raw = read_excel('C:/Users/pmwash/Desktop/Re-Engineered Reports/Velocity/Data/velocity_kc.xlsx',header=0)

def pre_process_kc(raw):
    '''Accepts a .xls output from Compleo'''
    # Remove whitespace from column names
    raw.columns = [x.strip().replace(' ','') for x in raw.columns]
    
    # Locate first row where the dataframe begins referring to cases 
    find_case_split = Series(raw['BOTTLESALES'].astype(str).tolist())
    find_case_split = Series([x.strip().replace(' ','') for x in find_case_split])
    case_start_ix = min(find_case_split[find_case_split == 'CASESALES'].index)
    
    # Split out bottles and cases by finding first case instance
    btls = raw.loc[0:case_start_ix-1]
    cases = raw.loc[case_start_ix:].reset_index(drop=True)
    
    # Format columns for cases 
    case_cols = cases.iloc[0].astype(str).reset_index(drop=True).tolist()
    cases.columns = Series([x.strip().replace(' ','') for x in case_cols])
    
    # Remove invalid data from cases and btls
    remove_rows_cases = cases['PRODUCT#'].astype(str).apply(lambda x: str.isnumeric(x) )
    cases = cases[remove_rows_cases == True]
    
    remove_rows_btls = btls['PRODUCT#'].astype(str).apply(lambda x: str.isnumeric(x) )
    btls = btls[remove_rows_btls == True]
    
    
    def replace_last(source_string, replace_what, replace_with):
        '''Replaces last occurrence of replace_what'''
        head, sep, tail = source_string.rpartition(replace_what)
        return head + replace_with + tail


    btl_sales = btls['BOTTLESALES'].astype(str).tolist()
    btl_sales = [b.strip().replace(' ','') for b in btl_sales]
    btl_sales = ['-' + replace_last(b,'-','')  if b.endswith('-') == True else b for b in btl_sales]
    btl_sales = Series(btl_sales)
    btls['BOTTLESALES'] = btl_sales.astype(float)
    
    case_sales = cases['CASESALES'].astype(str).tolist()
    case_sales = [c.strip().replace(' ','') for c in case_sales]
    case_sales = ['-' + replace_last(c,'-','')  if c.endswith('-') == True else c for c in case_sales]
    case_sales = Series(case_sales)
    cases['CASESALES'] = case_sales.astype(float)

    
    return btls, cases



BTLS,CASES = pre_process_kc(raw)
#print('\n\n\nBOTTLES HEADER \n\n\n',BTLS.head(),'\n\n\nCASES HEADER \n',CASES.head())




def map_kc_lines(btls,cases):
    '''Map KC Lines to locations'''
    cs_loc = cases['CSE.LOC.'].astype(str)
    cases['CSE.LOC.'] = [re.sub(' ','',x) for x in cs_loc]
    case_line_indicator = Series(cases['CSE.LOC.'].str[:2].tolist())
    case_lines = []
    
    for c in case_line_indicator:
        if c in ['C1','C2','C3','C4']:
            if c == 'C1':
                case_lines.append('C100')
            elif c == 'C2':
                case_lines.append('C200')
            elif c == 'C3':
                case_lines.append('C300')
            else:
                case_lines.append('C400')
        elif c[:1] in ['W','5']:
            case_lines.append('WineRoom')
        else:
            case_lines.append('OddBall')

    case_lines = Series(case_lines)
    
    btl_loc = btls['BTL.LOC.'].astype(str)
    btls['BTL.LOC.'] = [re.sub(' ','',x) for x in btl_loc]
    btl_line_indicator = Series(btls['BTL.LOC.'].str[:1].tolist())
    bottle_lines = []
    
    for b in btl_line_indicator:
        if b == 'A':
            bottle_lines.append('A Line')
        elif b == 'B':
            bottle_lines.append('B Line')
        else:
            bottle_lines.append('OddBall')
    
    return case_lines, bottle_lines

CASES['CASELINE'],BTLS['BOTTLELINE'] = map_kc_lines(BTLS,CASES)





def extract_features(CASES, BTLS, production_days=18):
    '''Extracts features from the data'''
    CASES['CASE.SALES.PER.DAY'] = round(CASES.CASESALES / production_days,0)
    BTLS['BTL.SALES.PER.DAY'] = round(BTLS.BOTTLESALES / production_days,0)
    
    cs_desc = CASES['SIZEANDDESCRIPTION'].astype(str).tolist()
    CASES['SIZE'] = [re.split('  ', c)[1] for c in cs_desc]
    
    btl_desc = BTLS['SIZEANDDESCRIPTION'].astype(str).tolist()
    BTLS['SIZE'] = [re.split('  ', b)[1] for b in btl_desc]
    
    return CASES, BTLS



CASES, BTLS = extract_features(CASES, BTLS)


CASES.head()
BTLS.head()





def create_summary(CASES, BTLS, production_days=18):
    '''Summarize case lines for KC'''
    cs_count_items_on_line = CASES[['CASELINE','CASESALES']].groupby('CASELINE').count()
    cs_count_items_on_line.columns = ['N_SKUS']
    cs_volume_on_line = CASES[['CASELINE','CASESALES']].groupby('CASELINE').sum()
    cs_volume_on_line.columns = ['CASE_VOLUME']
    
    cs_summary = cs_count_items_on_line.join(cs_volume_on_line)
    cs_summary['VOLUME_PER_SKU'] = round(cs_summary.CASE_VOLUME / cs_summary.N_SKUS, 0)
    cs_summary['VOLUME_PER_DAY'] = round(cs_summary.CASE_VOLUME / production_days, 0)
    total_case_volume = cs_summary['CASE_VOLUME'].sum()
    cs_summary['PERCENT_TOTAL_VOLUME'] = round(cs_summary.CASE_VOLUME / total_case_volume, 4)
    
    btl_count_items_on_line = BTLS[['BOTTLELINE','BOTTLESALES']].groupby('BOTTLELINE').count()
    btl_count_items_on_line.columns = ['N_SKUS']
    btl_volume_on_line = BTLS[['BOTTLELINE','BOTTLESALES']].groupby('BOTTLELINE').sum()
    btl_volume_on_line.columns = ['BOTTLE_VOLUME']
    
    btl_summary = btl_count_items_on_line.join(btl_volume_on_line)
    btl_summary['VOLUME_PER_SKU'] = round(btl_summary.BOTTLE_VOLUME / btl_summary.N_SKUS, 0)
    btl_summary['VOLUME_PER_DAY'] = round(btl_summary.BOTTLE_VOLUME / production_days, 0)
    total_bottle_volume = btl_summary['BOTTLE_VOLUME'].sum()
    btl_summary['PERCENT_TOTAL_VOLUME'] = round(btl_summary.BOTTLE_VOLUME / total_bottle_volume, 4)
    
    return cs_summary, btl_summary


cs_summary, btl_summary = create_summary(CASES, BTLS)




cs_lines = ['C100','C200','C300','C400','OddBall','WineRoom']

file_out = pd.ExcelWriter('M:/Operations Intelligence/Monthly Reports/Velocity/Velocity Report.xlsx', engine='xlsxwriter')

for i, line in enumerate(cs_lines):
    new_df = DataFrame(CASES[CASES.CASELINE == line])
    new_df.reset_index(drop=True, inplace=True)
    print('Inputting %s as its own tab in the velocity report.' % line)
    new_df.to_excel(file_out, sheet_name=str(line + '-C'),index=False)
file_out.save()
    
    

    
df_list


CASES[CASES.CASELINE == line]

_blines = BTLS.BOTTLELINE 
_clines = CASES.CASELINE











# all_sizes = raw['SIZEANDDESCRIPTION'].tolist()
# keg_sizes = ["\\<1/6BL\\>","\\<1/2BL\\>","\\<1/4BL\\>","\\<20L\\>","\\<10.8G\\>","\\<15.5G\\>","\\<15L\\>",
# "\\<2.6G\\>","\\<19L\\>","\\<3.3G\\>","\\<4.9G\\>","\\<5.16G\\>","\\<5.2G\\>","\\<5.4G\\>","\\<19.5L\\>",
# "\\<50L\\>","\\<30L\\>","\\<5G\\>","\\<25L\\>"]
# keg_sizes = '(' + ')|('.join(keg_sizes) + ')'

# [re.match(k,a) for k,a in zip(keg_sizes,all_sizes)]

# re.match(keg_sizes,'1/6BL')


