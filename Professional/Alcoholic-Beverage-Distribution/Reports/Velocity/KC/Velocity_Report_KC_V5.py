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
from pandas import read_excel, Series, DataFrame
import numpy as np
import re
from datetime import datetime as dt


ttl_cs = np.float64(input('Enter total cases expected from Compleo export: '))#202084
ttl_btl = np.float64(input('Enter total bottles expected from Compleo export: '))#6167.42


last_mon = dt.now().month - 1
report_month = dt.now().replace(month=last_mon).strftime('%B')
report_year = dt.now().year
report_month_year = str(report_month) + ' ' + str(report_year)


print('''


Expecting cases to be %.2f and bottles to be %.2f


''' % (ttl_cs,ttl_btl))

raw = read_excel('C:/Users/pmwash/Desktop/Re-Engineered Reports/Velocity/Data/velocity_kc.xlsx',header=0)

def pre_process_kc(raw):
    '''Accepts a .xls output from Compleo'''
    print('-'*100)
    print('Pre-processing output from Compleo/AS400.')
    print('-'*100)
    
    print('\n\n\nRemoving whitespace from column names.')
    raw.columns = [x.strip().replace(' ','') for x in raw.columns]
    
    print('Locating case/bottle split in document.') 
    find_btl_split = Series(raw['SIZE'].astype(str).tolist())
    find_btl_split = Series([x.strip().replace(' ','') for x in find_btl_split])
    
    find_case_split = Series(raw['BOTTLESALES'].astype(str).tolist())
    find_case_split = Series([x.strip().replace(' ','') for x in find_case_split])
    
    btl_end_ix = min(find_btl_split[find_btl_split == 'OTAL'].index)
    case_start_ix = min(find_case_split[find_case_split == 'CASESALES'].index)
    
    print('Splitting cases from bottles.')
    btls = raw.loc[0:btl_end_ix-1]
    cases = raw.loc[case_start_ix+1:].reset_index(drop=True)
    
    print('Formatting column names.')
    cases.columns = ['PRODUCT#', 'SIZE', 'ANDDESCRIPTION', 'CASESALES', 'PICKFREQUENCY', 'CSE.LOC.',
       'BTL.LOC.', 'BULK1', 'BOTTLESONHAND']
    
    print('Removing invalid data.')
    remove_rows_cases = cases['PRODUCT#'].astype(str).apply(lambda x: str.isnumeric(x) )
    cases = cases[remove_rows_cases == True].reset_index(drop=True)
    
    remove_rows_btls = btls['PRODUCT#'].astype(str).apply(lambda x: str.isnumeric(x) )
    btls = btls[remove_rows_btls == True].reset_index(drop=True)
    
    
    def replace_last(source_string, replace_what, replace_with):
        '''Replaces last occurrence of replace_what'''
        head, sep, tail = source_string.rpartition(replace_what)
        return head + replace_with + tail

    print('Formatting negative numbers.')
    btl_sales = btls['BOTTLESALES'].astype(str).tolist()
    btl_sales = [b.strip().replace(' ','') for b in btl_sales]
    btl_sales = [b.strip().replace(',','') for b in btl_sales]    
    btl_sales = ['-' + replace_last(b,'-','')  if b.endswith('-') == True else b for b in btl_sales]
    btl_sales = Series(btl_sales)
    btls['BOTTLESALES'] = btl_sales.astype(float)
    
    case_sales = cases['CASESALES'].astype(str).tolist()
    case_sales = [c.strip().replace(' ','') for c in case_sales]
    case_sales = [c.strip().replace(',','') for c in case_sales]    
    case_sales = ['-' + replace_last(c,'-','')  if c.endswith('-') == True else c for c in case_sales]
    case_sales = Series(case_sales)
    cases['CASESALES'] = case_sales.astype(float)
    
    check_btls = np.sum(btls['BOTTLESALES'])
    check_cses = np.sum(cases['CASESALES'])
    
    print('Total bottles: ', check_btls, '\nTotal cases: ', check_cses, '\n\n\n')
    
    cases.columns = ['PRODUCT#','SIZE','DESCRIPTION','CASESALES','PICKFREQUENCY','CSE.LOC.','BTL.LOC.','BULK1','BOTTLESONHAND']
    btls.columns = ['PRODUCT#','SIZE','DESCRIPTION','BOTTLESALES','PICKFREQUENCY','CSE.LOC.','BTL.LOC.','BULK1','BOTTLESONHAND']
    
    print('-'*100)
    print('Finished pre-processing data.')
    print('-'*100, '\n\n\n')
    
    return btls, cases



BTLS,CASES = pre_process_kc(raw)




def map_kc_lines(BTLS,CASES):
    '''Map KC Lines to locations'''
    print('-'*100)
    print('Mapping lines to product locations.')
    print('-'*100, '\n\n\n')
    
    CASES['CASELINE'] = CASES['CSE.LOC.'].astype(str).str[:2]
    c_lines = list()
    
    for i, c in enumerate(CASES['CASELINE']):
        if c == 'C1':
            c_lines.append('C100')
        elif c == 'C2':
            c_lines.append('C200')
        elif c == 'C3':
            c_lines.append('C300')
        elif c == 'C4':
            c_lines.append('C400')
        elif c[:1] in ['W','5']:
            c_lines.append('WineRoom')
        else:
            c_lines.append('OddBall')
    
    CASES['CASELINE'] = c_lines

    btl_loc = BTLS['BTL.LOC.'].astype(str)
    BTLS['BTL.LOC.'] = [re.sub(' ','',x) for x in btl_loc]
    btl_line_indicator = Series(BTLS['BTL.LOC.'].str[:1].tolist())
    bottle_lines = []
    
    for b in btl_line_indicator:
        if b == 'A':
            bottle_lines.append('A Line')
        elif b == 'B':
            bottle_lines.append('B Line')
        else:
            bottle_lines.append('OddBall')
    
    BTLS['BOTTLELINE'] = bottle_lines

    return CASES, BTLS



CASES,BTLS = map_kc_lines(BTLS,CASES)




def extract_features(CASES, BTLS, production_days=18):
    '''Extracts features from the data'''
    print('-'*100)
    print('Extracting features from data.')
    print('-'*100, '\n\n\n')
    
    CASES['CASE.SALES.PER.DAY'] = round(CASES.CASESALES / production_days,4)
    BTLS['BTL.SALES.PER.DAY'] = round(BTLS.BOTTLESALES / production_days,4)
    
    return CASES, BTLS



CASES, BTLS = extract_features(CASES, BTLS)




def create_summary(CASES, BTLS, production_days=18):
    '''Summarize case lines for KC'''
    print('-'*100)
    print('Creating summary.')
    print('-'*100, '\n\n\n')    
    
    cs_count_items_on_line = CASES[['CASELINE','CASESALES']].groupby('CASELINE').count()
    cs_count_items_on_line.columns = ['N_SKUS']
    cs_volume_on_line = CASES[['CASELINE','CASESALES']].groupby('CASELINE').sum()
    cs_volume_on_line.columns = ['CASE_VOLUME']
    
    cs_summary = cs_count_items_on_line.join(cs_volume_on_line)
    cs_summary['VOLUME_PER_SKU'] = round(cs_summary.CASE_VOLUME / cs_summary.N_SKUS, 2)
    cs_summary['VOLUME_PER_DAY'] = round(cs_summary.CASE_VOLUME / production_days, 0)
    total_case_volume = cs_summary['CASE_VOLUME'].sum()
    cs_summary['PERCENT_TOTAL_VOLUME'] = round(cs_summary.CASE_VOLUME / total_case_volume, 4)
    
    btl_count_items_on_line = BTLS[['BOTTLELINE','BOTTLESALES']].groupby('BOTTLELINE').count()
    btl_count_items_on_line.columns = ['N_SKUS']
    btl_volume_on_line = BTLS[['BOTTLELINE','BOTTLESALES']].groupby('BOTTLELINE').sum()
    btl_volume_on_line.columns = ['BOTTLE_VOLUME']
    
    btl_summary = btl_count_items_on_line.join(btl_volume_on_line)
    btl_summary['VOLUME_PER_SKU'] = round(btl_summary.BOTTLE_VOLUME / btl_summary.N_SKUS, 2)
    btl_summary['VOLUME_PER_DAY'] = round(btl_summary.BOTTLE_VOLUME / production_days, 0)
    total_bottle_volume = btl_summary['BOTTLE_VOLUME'].sum()
    btl_summary['PERCENT_TOTAL_VOLUME'] = round(btl_summary.BOTTLE_VOLUME / total_bottle_volume, 4)
    
    return cs_summary, btl_summary




def write_kc_to_xlsx(CASES, BTLS, month):
    '''Write the output to file'''
    print('-'*100)
    print('Writing output to Excel file on the KC common drive.')
    print('-'*100, '\n\n\n')    
    
    file_out = pd.ExcelWriter('M:/Operations Intelligence/Monthly Reports/Velocity/Velocity-'+month+'.xlsx', engine='xlsxwriter')
    workbook = file_out.book
      
    format_percent = workbook.add_format({'num_format': '0%'})
    
    cs_summary, btl_summary = create_summary(CASES, BTLS)
    cs_summary.to_excel(file_out, sheet_name='Summary', index=True)
    btl_summary.to_excel(file_out, sheet_name='Summary', startrow=12, index=True)
    
    summary_tab = file_out.sheets['Summary']
    summary_tab.set_column('A:A',11)
    summary_tab.set_column('B:B',9)
    summary_tab.set_column('C:C',16)
    summary_tab.set_column('D:E',19)
    summary_tab.set_column('F:F',24, format_percent)
    
    cs_lines = ['C100','C200','C300','C400','OddBall','WineRoom']
    btl_lines = ['A Line', 'B Line', 'OddBall']
    
    for i, line in enumerate(cs_lines):
        new_df = DataFrame(CASES[CASES.CASELINE == line])
        new_df.reset_index(drop=True, inplace=True)
        print('Inputting %s as its own tab in the velocity report.' % line)
        tab_name = str(line + '-C')
        new_df.to_excel(file_out, sheet_name=tab_name,index=False)
        sheet = file_out.sheets[tab_name]
        sheet.set_column('A:B',10)
        sheet.set_column('C:C',48)
        sheet.set_column('D:D',12)
        sheet.set_column('E:E',15.2)
        sheet.set_column('F:H',8.5)
        sheet.set_column('I:I',16)
        sheet.set_column('J:J',9)
        sheet.set_column('K:K',19)
    
    for i, line in enumerate(btl_lines):
        new_df = DataFrame(BTLS[BTLS.BOTTLELINE == line])
        new_df.reset_index(drop=True, inplace=True)
        print('Inputting %s as its own tab in the velocity report.' % line)
        tab_name = str(line + '-B')
        new_df.to_excel(file_out, sheet_name=tab_name,index=False)
        sheet = file_out.sheets[tab_name]
        sheet.set_column('A:B',10)
        sheet.set_column('C:C',48)
        sheet.set_column('D:D',12)
        sheet.set_column('E:E',15.2)
        sheet.set_column('F:H',8.5)
        sheet.set_column('I:I',16)
        sheet.set_column('J:J',11)
        sheet.set_column('K:K',19)
    
    file_out.save()
    print('\n\n\n')
    print('-'*100)
    print('Finished writing data to file.')
    print('-'*100, '\n\n\n') 
    



write_kc_to_xlsx(CASES, BTLS, month=report_month_year)
  




