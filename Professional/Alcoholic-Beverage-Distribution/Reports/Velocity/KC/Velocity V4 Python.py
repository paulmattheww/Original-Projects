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
from pandas import read_excel, Series
import numpy as np
import re

raw = read_excel('C:/Users/pmwash/Desktop/Re-Engineered Reports/Velocity/Data/velocity_kc.xlsx',header=0)

def pre_process_kc(raw):
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
    
    return btls, cases


# Preprocess the information 
BTLS,CASES = pre_process_kc(raw)
print('\n\n\nBOTTLES HEADER \n\n\n',BTLS.head(),'\n\n\nCASES HEADER \n',CASES.head())

# Categorize case & bottle locations

def map_kc_lines(btls,cases):
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


# all_sizes = raw['SIZEANDDESCRIPTION'].tolist()
# keg_sizes = ["\\<1/6BL\\>","\\<1/2BL\\>","\\<1/4BL\\>","\\<20L\\>","\\<10.8G\\>","\\<15.5G\\>","\\<15L\\>",
# "\\<2.6G\\>","\\<19L\\>","\\<3.3G\\>","\\<4.9G\\>","\\<5.16G\\>","\\<5.2G\\>","\\<5.4G\\>","\\<19.5L\\>",
# "\\<50L\\>","\\<30L\\>","\\<5G\\>","\\<25L\\>"]
# keg_sizes = '(' + ')|('.join(keg_sizes) + ')'

# [re.match(k,a) for k,a in zip(keg_sizes,all_sizes)]

# re.match(keg_sizes,'1/6BL')

CASES.head()

cs_count_items_on_line = CASES[['CASELINE','CASESALES']].groupby('CASELINE').count()
cs_sum_items_on_line = CASES[['CASELINE','CASESALES']].groupby('CASELINE').sum()

volume_per_sku = cs_sum_items_on_line / cs_count_items_on_line








