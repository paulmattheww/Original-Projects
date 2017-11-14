## W8 PP5 Cash to Cash Cycle
def days_payable_outstanding(AP, COGS):
    '''Avg AP & COGS'''
    return (AP/COGS)*365

def days_inventory_outstanding(avg_inventory, COGS):
    '''Avg Inventory & COGS'''
    return (avg_inventory/COGS)*365

def days_sales_outstanding(AR, sales):
    '''Avg AR & COGS'''
    return (AR/sales)*365

def cash_conversion_cycle(DIO, DSO, DPO):
    '''Number of days cash tied up in Biz'''
    return DIO + DSO - DPO

df = pd.DataFrame({'Company':['UNI','P&G','KC'],
                  'AvgInventory':[4053,6834,2063],
                  'AvgAR':[4930,6447,2384],
                  'AvgAP':[12171,8619,2607], 
                  'COGS':[40446,42460,13041],
                  'Sales':[48436,83062,19724]})

for i, row in df.iterrows():
    DIO = days_inventory_outstanding(row['AvgInventory'], row['COGS'])
    DSO = days_sales_outstanding(row['AvgAR'], row['Sales'])
    DPO = days_payable_outstanding(row['AvgAP'], row['COGS'])
    CO = row['Company']
    CCC = cash_conversion_cycle(DIO, DSO, DPO)
    print('''
    Company .......................... %s
    Days Inventory Outstanding .......................... %.2f
    Days Sales Outstanding .......................... %.2f
    Days Payables Outstanding .......................... %.2f
    Cash Conversion Cycle .......................... %.2f
    ''' %(CO, DIO, DSO, DPO, CCC))
