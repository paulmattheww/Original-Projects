import math
fig, axes = plt.subplots(2, 2, figsize=(15, 10))
colors = ['blue', 'red', 'green', 'orange']

for i, loc in enumerate(hogan_daily.hogan_loc.unique()):
    if i < 2: ax = axes[0, i]
    else: ax = axes[1, i-2]
    n_invoices = hogan_daily.loc[hogan_daily.hogan_loc == loc, 'invoice_number']
    ax.hist(n_invoices, bins=int(n_invoices.max()), label='Number of Invoices',
           alpha=.7, color=colors[i])
    ax.set_xlabel('Bins of Number of Invoices')
    ax.set_ylabel('Observations in Bins')
    ax.set_title(str(loc))
    ax.grid(alpha=.2)
    xint = range(0, math.ceil(max(n_invoices)+1))
    ax.set_xticks(xint)
    sns.despine()
sns.set_style('whitegrid')
plt.show()   

#hogan_daily.groupby('hogan_loc')['invoice_number'].hist(figsize=(13, 5))
