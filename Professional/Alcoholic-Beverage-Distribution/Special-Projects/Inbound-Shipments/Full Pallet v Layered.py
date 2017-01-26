'''
Analysis of A and B Products
Ad Hoc Request Steve Lewis
Before and after switch from layered to full pallet
Jan 1 - Dec 27 2016

Input data for A/B products from Steve L.
Inbound shipment data from pw_polines AS400
YTD Sales data from ytd_prod

Data transferred into a CSV
from Transfer Add In, outside of Excel
Open with Notepad++ and
replace all white space [.+(\s)+.+] or (\[.*)\s(.*\])
with commas
'''

import pandas as pd
import numpy as np
from datetime import datetime as dt
import datetime
import re

path = 'C:/Users/pmwash/Desktop/Re-Engineered Reports/Ad Hoc/Purchasing/Full Pallet v Layered/'
pw_polines = pd.read_csv(path + 'pw_polines 01012016 through 12272016.csv', 
                header=0, 
                dtype={'UDPO#':np.int64, 'UDLIN#':np.int64, 'UDDRC1':str, 'UDPRD#':np.int64,
                        'UDSUPP':np.int64, 'QTYREC':np.float64, 'UDFOB':np.float64, 'UDTOQ':str,
                        'EXT_COST':np.float64, 'UDCOMP':np.int64, 'UDSCC':str, 'Cases_Received':np.float64,
                        'UDWHSE':str, 'UDWGT':np.float64, 'UDBRAN':np.int64, 'UDQPC':np.int64})
pw_polines.rename(columns={'UDPO#':'PO_Number', 'UDLIN#':'Line_Number', 'UDDRC1':'Date_Received', 'UDPRD#':'ProductId',
                        'UDSUPP':'SupplierId','QTYREC':'Qty_Received', 'EXT_COST':'Ext_Cost', 'UDCOMP':'Warehouse', 
                        'UDSCC':'Ship_Container_Code', 'UDWGT':'Weight', 'UDFOB':'FOB', 'UDTOQ':'Case_or_Btl',
                        'UDQPC':'QPC', 'UDBRAN':'BrandId', 'Cases_Received':'Cases_Received'}, inplace=True)

ab_items = pd.read_csv(path + 'AB Items.csv', header=0)
ab_items.rename(columns={'PPROD#':'ProductId', 'PDESC':'Product', '#SRNAM':'Supplier', 'PMONI':'AB', 'Increases':'FullPalletIncrease'}, inplace=True)
ab_items.FullPalletIncrease = ab_items.FullPalletIncrease.map({'XX':'Both Warehouses', 'X':'One Warehouse'})


## Daily Sales by Product for Aggregating up to Weekly
def generate_pw_ytdpwar(path):
    '''
    This is a huge file, so this function makes it manageable 
    '''
    import pandas as pd
    
    def as400_date(dat):
        try:
            d = dt.date(dt.strptime(dat[-6:], '%y%m%d'))
        except ValueError:
            d = dt.date(dt.strptime('1990909', '%y%m%d'))
        return d
    pw_ytdpwar = pd.read_csv(path + 'pw_ytdpwar Jan - Dec 2016.csv', header=None)
    l = [re.sub(' +',',',STRING) for STRING in pw_ytdpwar[0].astype(str)]
    pw_ytdpwar = pd.DataFrame([sub.split(',') for sub in l])
    del l
    pw_ytdpwar.rename(columns={0:'Warehouse',1:'Date',2:'ProductId',3:'Sales'}, inplace=True)
    
    pw_ytdpwar.Date = [as400_date(dat) for dat in pw_ytdpwar.Date.astype(str).tolist()]
    dat = pw_ytdpwar.Date 
    pw_ytdpwar['Year'] = [d.strftime('%Y') for d in dat]
    pw_ytdpwar['Month'] = [d.strftime('%B') for d in dat]
    pw_ytdpwar['Weekday'] = [d.strftime('%A') for d in dat]
    pw_ytdpwar['DOTY'] = [d.strftime('%j') for d in dat]
    pw_ytdpwar['WeekNumber'] = [d.strftime('%U') for d in dat]
    pw_ytdpwar['DOTM'] = [d.strftime('%d') for d in dat]
    
    pw_ytdpwar = pw_ytdpwar.groupby(['Warehouse','ProductId','Week','Year'])
    
    return pw_ytdpwar

generate_pw_ytdpwar(path).groupby(['Year','WeekNumber','Warehouse'])['Sales'].sum()










pw_ytdpwar.index.names[0] = ['Date','ProductId']

new_names = ['Warehouse','Date','ProductId','Sales|Dollars']

pw_ytdpwar.rename(columns={'#MCMP':'Warehouse','#MINP#':'ProductId','#MEXT$01':'Sales|Dollars'}, inplace=True)
pw_ytdpwar.Warehouse = pw_ytdpwar.Warehouse.map({1:'Kansas City', 2:'Saint Louis', 3:'Saint Louis', 5:'Kansas City'})

def summarize_po_lines(pw_polines):
    '''Cleans raw query pw_polines for merge'''

    def as400_date(dat):
        '''Accepts list of dates as strings from theAS400'''
        try:
            dat = dt.date(dt.strptime(dat[-6:], '%y%m%d'))
        except ValueError:
            dat = dt.date(dt.strptime('160101', '%y%m%d'))
        return dat

    pw_polines.Warehouse = pw_polines.Warehouse.map({1:'Kansas City', 2:'Saint Louis'})
    pw_polines.Date_Received = dat = [as400_date(d) for d in pw_polines.Date_Received.astype(str)]
    pw_polines['Month'] = [d.strftime('%B') for d in dat]
    pw_polines['Year'] = [d.strftime('%Y') for d in dat]
    pw_polines['Weekday'] = [d.strftime('%A') for d in dat]
    pw_polines['Week'] = [d.strftime('%W') for d in dat]
    pw_polines['DOTM'] = [d.strftime('%d') for d in dat]
    pw_polines['DOTY'] = [d.strftime('%j') for d in dat]
    
    ## Distinguishing between cases and bottles - setting their values
    pw_polines['Cases_Received'] = None
    CS, BTL, QPC = pw_polines.loc[pw_polines['Case_or_Btl'] == 'C', 'Qty_Received'].astype(np.float64), pw_polines.loc[pw_polines['Case_or_Btl'] == 'B', 'Qty_Received'].astype(np.float64), pw_polines.loc[pw_polines['Case_or_Btl'] == 'B', 'QPC'].astype(np.float64)
    pw_polines.loc[pw_polines['Case_or_Btl'] == 'C', 'Cases_Received'] = CS
    pw_polines.loc[pw_polines['Case_or_Btl'] == 'B', 'Cases_Received'] = np.divide(BTL, QPC)
    
    pw_polines['PO_&_Line_Number'] = pw_polines.PO_Number.astype(str) +'_'+ pw_polines.Line_Number.astype(str)
    
    return pw_polines


pw_polines_clean = summarize_po_lines(pw_polines)
pw_polines_clean.head()



def merge_datasets(pw_polines_clean, pw_ytdpwar, ab_items):
    '''Merges inbound shipment data with sales by product/whse and Steve's experimental data'''
    inbound_shipments = summarize_po_lines(pw_polines_clean)
    inbound_shipments = inbound_shipments.merge(pw_ytdpwar, on=['Warehouse','ProductId'], how='left')
    inbound_shipments = inbound_shipments.merge(ab_items, on='ProductId', how='right')
    
    inbound_shipments.loc[inbound_shipments.Date_Received < datetime.date(year=2016, month=8, day=1), 'FullPalletIncrease'] = ''
    
    inbound_shipments['PurchasingPolicy'] = ''
    inbound_shipments.loc[inbound_shipments.Date_Received < datetime.date(year=2016, month=8, day=1), 'PurchasingPolicy'] = 'Layered'
    inbound_shipments.loc[inbound_shipments.Date_Received >= datetime.date(year=2016, month=8, day=1), 'PurchasingPolicy'] = 'Pallet'
    inbound_shipments.loc[(inbound_shipments.Date_Received < datetime.date(year=2016, month=8, day=1)) & (inbound_shipments.FullPalletIncrease == ''), 'PurchasingPolicy'] = ''
    
    inbound_shipments.FullPalletIncrease.fillna('', inplace=True)
    
    return inbound_shipments


inbound_ab_items = merge_datasets(pw_polines_clean, pw_ytdpwar, ab_items)
inbound_ab_items.tail()

#########################################################################
################################################ <###> ##################
#########################################################################
def prepare_ab_summary(inbound_ab_items):
    '''Prepares daily summary of items in question'''
    len_unique = lambda x: len(pd.unique(x))
    grp_cols = ['Warehouse','PurchasingPolicy','FullPalletIncrease','AB','SupplierId','ProductId','Product','Date_Received','Year','Month','Weekday']
    agg_funcs = {'PO_&_Line_Number' : len_unique,
                'Ext_Cost' : np.sum,
                'Cases_Received' : np.sum,
                'Sales|Dollars' : np.sum}
    
    ab_item_summary = pd.DataFrame(inbound_ab_items.groupby(grp_cols).agg(agg_funcs)).reset_index(drop=False)
    ab_item_summary['CasesPerPOLine'] = np.divide(ab_item_summary['Cases_Received'], ab_item_summary['PO_&_Line_Number'])
    
    dat = ab_item_summary.Date_Received
    ab_item_summary['DOTY'], ab_item_summary['DOTM'] = [d.strftime('%j') for d in dat],  [d.strftime('%d') for d in dat]
    
    ab_item_summary.loc[ab_item_summary.ProductId == ab_item_summary.ProductId.shift(1), 'DaysSinceLastReceipt'] = ab_item_summary.Date_Received - ab_item_summary.Date_Received.shift(1)
    #ab_item_summary.Month = ab_item_summary.Month.astype('category')
    #ab_item_summary.Month.cat.reorder_categories(['January','February','March','April','May','June','July','August','September','October','November','December'])
    
    ab_item_summary.drop_duplicates(inplace=True)
    #ab_item_summary.to_excel('C:/Users/pmwash/Desktop/Disposable Docs/AB Items by Date.xlsx', sheet_name='Daily Data')
    
    return ab_item_summary


ab_item_summary = prepare_ab_summary(inbound_ab_items)
ab_item_summary = ab_item_summary[ab_item_summary.Date_Received > datetime.date(year=2016, month=2, day=28)]
ab_item_summary.tail()

print('''
Omit August

Bs only

Just XX (both warehouses)

Quantify sales by week side by side
''')



new_grp_cols = ['Warehouse','FullPalletIncrease','Product','PurchasingPolicy']
inquiry_cols = ['DaysSinceLastReceipt']

frequency_by_product = pd.DataFrame(np.divide(pd.DataFrame(ab_item_summary.groupby(new_grp_cols)[inquiry_cols].sum()), pd.DataFrame(ab_item_summary.groupby(new_grp_cols)[inquiry_cols].count())))
frequency_by_product.columns = ['%s%s' % (a, '|%s' % b if b else '') for a, b in frequency_by_product.columns]    
frequency_by_product.head(20)

#ab_item_highlevel = ab_item_summary.groupby(new_grp_cols).mean()
#ab_item_summary.to_excel('C:/Users/pmwash/Desktop/Disposable Docs/AB Items by Date.xlsx', sheet_name='Daily Summary')
#ab_item_highlevel.to_excel('C:/Users/pmwash/Desktop/Disposable Docs/AB Items Before & After.xlsx', sheet_name='High Level Summary')
frequency_by_product.to_excel('C:/Users/pmwash/Desktop/Disposable Docs/AB Items Before & After.xlsx', sheet_name='Frequency by Product')

ab_item_highlevel.head()















def write_to_excel(details, summary):
    '''
    Write report to Excel with formatting.
    '''
    file_out = pd.ExcelWriter('N:/Operations Intelligence/Monthly Reports/Unsaleables/Unsaleables & Returns  -  '+month+'.xlsx', engine='xlsxwriter')
    workbook = file_out.book
    
    print('*'*100)
    print('Writing finished product to the STL Common Drive.')
    print('*'*100)
    
    print('\n\n\nWriting Class summary to file.')
    class_summary.to_excel(file_out, sheet_name='Summary', index=True)
    
    print('Writing Director summary to file.')
    director_summary.to_excel(file_out, sheet_name='Summary', index=True, startrow=9)

    print('Writing Customer Returns summary to file.')
    customer_returns.to_excel(file_out, sheet_name='Customers', index=False)    
    
    print('Writing Supplier summary to file.')
    supplier_summary.to_excel(file_out, sheet_name='Suppliers', index=False)

    print('Writing Product summary to file.')
    unsaleables_by_product.to_excel(file_out, sheet_name='Products', index=False)
    
    print('Saving number formats for re-use.')
    format_thousands = workbook.add_format({'num_format': '#,##0'})
    format_dollars = workbook.add_format({'num_format': '$#,##0'})
    format_float = workbook.add_format({'num_format': '###0.#0'})    
    format_percent = workbook.add_format({'num_format': '0%'})
    
    print('Formatting Summary tab for visual purposes.')
    summary_tab = file_out.sheets['Summary']
    summary_tab.set_column('A:A',30)
    summary_tab.set_column('D:E',25, format_thousands)
    summary_tab.set_column('B:C',25, format_dollars)
    
    print('Formatting Customers tab for visual purposes.')
    customers_tab = file_out.sheets['Customers']
    customers_tab.set_column('A:A',11)
    customers_tab.set_column('B:B',35)
    customers_tab.set_column('C:C',13.3)
    customers_tab.set_column('D:D',12, format_percent)
   
    file_out.save()    
    
    print('*'*100)
    print('Finished writing file to common drive.')
    print('*'*100)
    


last_mon = dt.now().month - 1
report_month = dt.now().replace(month=last_mon).strftime('%B')
report_year = dt.now().year
report_month_year = str(report_month) + ' ' + str(report_year)# + ' Year to Date'

write_unsaleables_to_excel(class_summary, director_summary, supplier_summary, customer_returns, unsaleables_by_product, month=report_month_year)



































import matplotlib.pyplot as plt

def make_hist(ax, x, bins=None, binlabels=None, width=0.85, extra_x=1, extra_y=4, 
              text_offset=0.3, title=r"Frequency diagram", 
              xlabel="Values", ylabel="Frequency"):
    if bins is None:
        xmax = max(x)+extra_x
        bins = range(xmax+1)
    if binlabels is None:
        if np.issubdtype(np.asarray(x).dtype, np.integer):
            binlabels = [str(bins[i]) if bins[i+1]-bins[i] == 1 else 
                         '{}-{}'.format(bins[i], bins[i+1]-1)
                         for i in range(len(bins)-1)]
        else:
            binlabels = [str(bins[i]) if bins[i+1]-bins[i] == 1 else 
                         '{}-{}'.format(*bins[i:i+2])
                         for i in range(len(bins)-1)]
        if bins[-1] == np.inf:
            binlabels[-1] = '{}+'.format(bins[-2])
    n, bins = np.histogram(x, bins=bins)
    patches = ax.bar(range(len(n)), n, align='center', width=width)
    ymax = max(n)+extra_y

    ax.set_xticks(range(len(binlabels)))
    ax.set_xticklabels(binlabels)

    ax.set_title(title)
    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    ax.set_ylim(0, ymax)
    ax.grid(True, axis='y')
    # http://stackoverflow.com/a/28720127/190597 (peeol)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.spines['bottom'].set_visible(False)
    ax.spines['left'].set_visible(False)
    # http://stackoverflow.com/a/11417222/190597 (gcalmettes)
    ax.xaxis.set_ticks_position('none')
    ax.yaxis.set_ticks_position('none')
    autolabel(patches, text_offset)

def autolabel(rects, shift=0.3):
    """
    http://matplotlib.org/1.2.1/examples/pylab_examples/barchart_demo.html
    """
    # attach some text labels
    for rect in rects:
        height = rect.get_height()
        if height > 0:
            plt.text(rect.get_x()+rect.get_width()/2., height+shift, '%d'%int(height),
                     ha='center', va='bottom')

fig, ax = plt.subplots(figsize=(14,5))
# make_hist(ax, x)
# make_hist(ax, [1,1,1,0,0,0], extra_y=1, text_offset=0.1)
make_hist(ax, x, bins=list(range(10))+list(range(10,41,5))+[np.inf], extra_y=6)
plt.show()
