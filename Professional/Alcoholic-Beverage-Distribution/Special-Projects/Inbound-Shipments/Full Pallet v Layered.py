'''
Analysis of A and B Products
Before and after switch from layered to full pallet
Jan 1 - Dec 27 2016

Input data for A/B products from Steve L.
Inbound shipment data from pw_polines AS400
YTD Sales data from ytd_prod
'''

import pandas as pd
import numpy as np
from datetime import datetime as dt
import datetime

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

pw_ytdpwar = pd.read_csv(path + 'pw_ytdpwar Jan - Dec 2016.csv', header=0, usecols=['#MCMP','#MINP#','#MEXT$01'])
pw_ytdpwar.rename(columns={'#MCMP':'Warehouse','#MINP#':'ProductId','#MEXT$01':'Sales|Dollars'}, inplace=True)
pw_ytdpwar.Warehouse = pw_ytdpwar.Warehouse.map({1:'Kansas City', 2:'Saint Louis', 3:'Saint Louis', 5:'Kansas City'})

def summarize_po_lines(pw_polines):
    '''Cleans raw query pw_polines for merge'''

    def as400_date(dat):
        '''Accepts list of dates as strings from theAS400'''
        try:
            dat = dt.date(dt.strptime(dat[-6:], '%y%m%d'))
        except:
            if dt.date(dt.strptime(dat[-6:], '%y%m%d')) == '1090001':
                dat = None
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


def merge_datasets(pw_polines, pw_ytdpwar, ab_items):
    '''Merges inbound shipment data with sales by product/whse and Steve's experimental data'''
    inbound_shipments = summarize_po_lines(pw_polines)
    inbound_shipments = inbound_shipments.merge(pw_ytdpwar, on=['Warehouse','ProductId'], how='left')
    inbound_shipments = inbound_shipments.merge(ab_items, on='ProductId', how='right')
    
    inbound_shipments.loc[inbound_shipments.Date_Received < datetime.date(year=2016, month=8, day=1), 'FullPalletIncrease'] = ''
    
    inbound_shipments['PurchasingPolicy'] = ''
    inbound_shipments.loc[inbound_shipments.Date_Received < datetime.date(year=2016, month=8, day=1), 'PurchasingPolicy'] = 'Layered'
    inbound_shipments.loc[inbound_shipments.Date_Received >= datetime.date(year=2016, month=8, day=1), 'PurchasingPolicy'] = 'Pallet'
    inbound_shipments.FullPalletIncrease.fillna('', inplace=True)
    
    return inbound_shipments


inbound_ab_items = merge_datasets(pw_polines, pw_ytdpwar, ab_items)
inbound_ab_items.tail()


def prepare_ab_summary(inbound_ab_items):
    '''Prepares daily summary of items in question'''
    
    grp_cols = ['Warehouse','FullPalletIncrease','AB','SupplierId','ProductId','Product','Date_Received','Year','Month','Weekday']
    agg_funcs = {'PO_&_Line_Number' : lambda x: len(pd.unique(x)),
                'Ext_Cost' : np.sum,
                'Cases_Received' : np.sum,
                'Weight' : np.sum }
    
    ab_item_summary = pd.DataFrame(inbound_ab_items.groupby(grp_cols).agg(agg_funcs)).reset_index(drop=False)
    ab_item_summary['CasesPerPOLine'] = np.divide(ab_item_summary['Cases_Received'], ab_item_summary['PO_&_Line_Number'])
    
    dat = ab_item_summary.Date_Received
    ab_item_summary['DOTY'], ab_item_summary['DOTM'] = [d.strftime('%j') for d in dat],  [d.strftime('%d') for d in dat]
    
    ab_item_summary.loc[ab_item_summary.ProductId == ab_item_summary.ProductId.shift(1), 'DaysSinceLastReceipt'] = ab_item_summary.Date_Received - ab_item_summary.Date_Received.shift(1)
    ab_item_summary.Month = ab_item_summary.Month.astype('category')
    ab_item_summary.Month.cat.reorder_categories(['January','February','March','April','May','June','July','August','September','October','November','December'])
    
    ab_item_summary.to_excel('C:/Users/pmwash/Desktop/Disposable Docs/AB Items by Date.xlsx', sheet_name='Daily Data')
    
    return ab_item_summary


ab_item_summary = prepare_ab_summary(inbound_ab_items)
ab_item_summary = ab_item_summary[ab_item_summary.Date_Received > datetime.date(year=2016, month=2, day=28)]

ab_item_summary.DaysSinceLastReceipt.mean()
ab_item_summary.head()

new_grp_cols = ['Warehouse','SupplierId','AB','ProductId','Product','FullPalletIncrease']
len_unique = lambda x: len(pd.unique(x))
agg_funcs2 = {'Cases_Received': {np.sum, np.mean, np.count_nonzero}, 'ProductId': len_unique }
##################lunchtime
ab_item_highlevel = pd.DataFrame(ab_item_summary.groupby(new_grp_cols).agg(agg_funcs2))
ab_item_highlevel.columns = ['%s%s' % (a, '|%s' % b if b else '') for a, b in ab_item_highlevel.columns]    


#ab_item_highlevel = ab_item_summary.groupby(new_grp_cols).mean()

ab_item_highlevel.to_excel('C:/Users/pmwash/Desktop/Disposable Docs/AB Items by Date.xlsx', sheet_name='High Level Summary')
ab_item_highlevel.head()



#ab_item_summary.DaysSinceLastReceipt.dtype
# Count up days and cases of last 30 days of purchases grouped by product
#ab_item_summary.groupby(['Warehouse','ProductId','Product']).Cases_Received.rolling(3).count().plot()




ab_item_summary.tail(10)



































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
