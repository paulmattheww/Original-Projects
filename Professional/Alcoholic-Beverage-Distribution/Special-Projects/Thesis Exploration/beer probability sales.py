'''
Playing w/ Probability
'''
import pandas as pd
import numpy as np

path = 'C:/Users/pmwash/Desktop/Re-Engineered Reports/R&D/Product Demand Probability/4HANDS - WEEKLY SALES 2016 - BY PRODUCT.csv'
four_hands = pd.read_csv(path, header=0)
four_hands.fillna(0, inplace=True)

four_hands.head()

def make_pmf(data, fields):
    '''Accepts DataFrame & List of Field(s)'''
    import pandas as pd
    import numpy as np
    pmf_list = []
    for field in fields:
        col_name = str(field)
        qty = pd.Series(np.sort(pd.unique(data[field])))
        count = data[field].value_counts().sort_index() 
        prob_ix = data[field].value_counts().sort_index() / len(data)
        pmf_df = pd.DataFrame({'Qty':qty, 'Probability_'+field:prob_ix, 'Count_'+field:count})
        pmf_df['Cumulative_Probability_'+field] = pmf_df['Probability_'+field].cumsum()
        pmf_list.append(pmf_df)
    
    DF_OUT = pd.DataFrame()
    
    for i, df in enumerate(pmf_list):
        if i==0:
            DF_OUT = DF_OUT.append(pmf_list[0])
        elif i==len(pmf_list):
            pass
        else:
            DF_OUT = DF_OUT.merge(df, on='Qty', how='outer')
    
    DF_OUT.reindex(DF_OUT.Qty)   
    DF_OUT.drop(labels='Qty', axis=1, inplace=True)
    DF_OUT.fillna(0.0, inplace=True)

    return DF_OUT


beers_of_interest = ['4 HANDS CHOC MILK STOUT 4/6 CANS - 12Z (4290206)','4 HANDS CITY WIDE AMERICAN PALE ALE - 16Z (4291567)',
                    '4 HANDS CONTACT HIGH 4/6 PK CANS - 12Z (4290146)']

four_hands_pmf = make_pmf(four_hands, beers_of_interest)

to_plot = ['Probability_4 HANDS CONTACT HIGH 4/6 PK CANS - 12Z (4290146)']
four_hands_pmf[to_plot].plot(kind='bar', figsize=(25,15))
four_hands_pmf.head()


from bokeh.plotting import figure, output_file, show

p = figure(title="simple line example", x_axis_label='x', y_axis_label='y')

# add a line renderer with legend and line thickness
p.line(x=four_hands_pmf.index.names, y=four_hands_pmf[to_plot], legend="Temp.", line_width=2)

# show the results
show(p)












        

ALL_PRODUCTS = make_pmf(data=Z, fields=['XP219','Floss','Whitener'])
