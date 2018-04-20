import pandas as pd
import matplotlib.pyplot as plt
%matplotlib inline

def plot_tseries(df, xcol, ycol, grpcol, title_prepend='{}', labs=None, x_angle=0):
    '''
    Function for plotting time series df[ycol] over datetime range df[xcol]
    using the unique_grp_vals contained in df[grpcol].unique().  
    
     - df: pd.DataFrame containing datetime and series to plot
     - xcol: str of column name in df for datetime series
     - ycol: str of column name in df for tseries 
     - grpcol: str of column name in df of group over which to plot
    '''
    unique_grp_vals = df[grpcol].unique()
    fig, axes = plt.subplots(1, len(unique_group_values), figsize=(17, 6))
    for i, grp in enumerate(unique_group_values):
        _df = df.loc[df[grpcol] == grp]
        ax = axes[i]
        ax.plot(_df[xcol], _df[ycol])
        ax.set_title(title_prepend.format(grp))
        if labs is not None:
            ax.set_xlabel(labs['xlab'])
            ax.set_ylabel(labs['ylab'])
        ax.grid(alpha=.4)
        if x_angle != 0:
            for tick in ax.get_xticklabels():
                tick.set_rotation(x_angle)
    plt.show()
    
unique_grp_vals = ['STL', 'COL']
title_prepend = 'Routes per Day for {}'
xcol = 'date'
ycol = 'rte'
grpcol = 'loc'
labs = dict(xlab='Date', ylab='Number of Market Routes')
    
plot_tseries(stl_daily, xcol, ycol, grpcol, title_prepend, labs, x_angle=90)


def plot_tseries_histograms_over_group(df, xcol, grpcol, labs=None, title_prepend='{}'):
    unique_grp_vals = df[grpcol].unique()
    fig, axes = plt.subplots(1, 2, figsize=(17, 6))
    for i, grp in enumerate(unique_grp_vals):
        _df = df.loc[df[grpcol] == grp]
        ax = axes[i]
        ax.hist(_df[xcol], bins=_df['rte'].max()-_df['rte'].min())
        ax.axvline(_df[xcol].mean(), linestyle='--', color='r')
        ax.axvline(_df[xcol].mean()-_df[xcol].std(), linestyle='-.', color='y')
        ax.axvline(_df[xcol].mean()+_df[xcol].std(), linestyle='-.', color='y')
        ax.set_title(title_prepend.format(loc))
        if labs is not None:
            ax.set_xlabel(labs['xlab'])
            ax.set_ylabel(labs['ylab'])
        ax.grid(alpha=.4)
    plt.show()

xcol = 'rte'
title_prepend = 'Histogram of Routes per Day for {}'
labs = dict(xlab='Count of Routes per Day', ylab='Number of Observations')
plot_tseries_histograms_over_group(stl_daily, xcol, grpcol, labs, title_prepend)
