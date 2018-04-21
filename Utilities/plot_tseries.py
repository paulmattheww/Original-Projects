import pandas as pd
import matplotlib.pyplot as plt
%matplotlib inline

def plot_tseries_over_group(df, xcol, ycol, grpcol, title_prepend='{}', labs=None, x_angle=0):
    '''
    Function for plotting time series df[ycol] over datetime range df[xcol]
    using the unique_grp_vals contained in df[grpcol].unique().  
    
     - df: pd.DataFrame containing datetime and series to plot
     - xcol: str of column name in df for datetime series
     - ycol: str of column name in df for tseries 
     - grpcol: str of column name in df of group over which to plot
     - labs: dict of xlab, ylab
     - title_prepend: str containing "{}" that prepends group names in title
    '''
    unique_grp_vals = df[grpcol].unique()
    fig, axes = plt.subplots(1, len(unique_grp_vals), figsize=(17, 6))
    for i, grp in enumerate(unique_grp_vals):
        _df = df.loc[df[grpcol] == grp]
        ax = axes[i]
        ax.plot(_df[xcol], _df[ycol])
        ax.set_title(title_prepend.format(grp))
        if labs is not None:
            ax.set_xlabel(labs['xlab'], labelpad=60)
            ax.set_ylabel(labs['ylab'])
        ax.grid(alpha=.1)
        if x_angle != 0:
            for tick in ax.get_xticklabels():
                tick.set_rotation(x_angle)
    sns.set_style("whitegrid")
    sns.despine()
    plt.show()
    
title_prepend = 'Daily Value of {} $USD'
xcol = 'date'
ycol = 'value'
grpcol = 'variable'
labs = dict(xlab='Date', ylab='Value')
    
plot_tseries_over_group(df_eda_melt, xcol, ycol, grpcol, title_prepend, labs, x_angle=90)


def plot_tseries_histograms_over_group(df, xcol, grpcol, labs=None, title_prepend='{}', minimize_bins=False):
    '''
    Function for plotting histogream of time series df[ycol] over datetime 
    range df[xcol] using the unique_grp_vals contained in df[grpcol].unique().  
    
     - df: pd.DataFrame containing datetime and series to plot
     - xcol: str of column name in df for datetime series
     - grpcol: str of column name in df of group over which to plot
     - labs: dict of xlab, ylab
     - title_prepend: str containing "{}" that prepends group names in title
    '''
    unique_grp_vals = df[grpcol].unique()
    fig, axes = plt.subplots(1, len(unique_grp_vals), figsize=(17, 6))
    for i, grp in enumerate(unique_grp_vals):
        _df = df.loc[df[grpcol] == grp]
        ax = axes[i]
        if minimize_bins:
            ax.hist(_df[xcol], bins=int(_df[xcol].max()-_df[xcol].min()))
        else:
            ax.hist(_df[xcol])
        mu, sigma = _df[xcol].mean(), _df[xcol].std()
        ax.axvline(mu, linestyle='--', color='r')
        ax.axvline(mu - sigma, linestyle='-.', color='y')
        ax.axvline(mu + sigma, linestyle='-.', color='y')
        ax.set_title(title_prepend.format(grp))
        if labs is not None:
            ax.set_xlabel(labs['xlab'])
            ax.set_ylabel(labs['ylab'])
        ax.grid(alpha=.1)
    sns.set_style("whitegrid")
    sns.despine()
    plt.show()

xcol = 'value'
title_prepend = 'Histogram of Daily Value $USD of Cryptocurrency:  {}'
labs = dict(xlab='Bins', ylab='Count of Observations')
plot_tseries_histograms_over_group(df_eda_melt, xcol, grpcol, labs, title_prepend)



import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
%matplotlib inline

years = mdates.YearLocator()   # every year
months = mdates.MonthLocator()  # every month
yearsFmt = mdates.DateFormatter('%Y')


def plot_tseries_over_group_with_histograms(df, xcol, ycol, grpcol, title_prepend='{}', 
                            labs=None, x_angle=0, labelpad=60):
    '''
    Function for plotting time series df[ycol] over datetime range df[xcol]
    using the unique_grp_vals contained in df[grpcol].unique().  
    
     - df: pd.DataFrame containing datetime and series to plot
     - xcol: str of column name in df for datetime series
     - ycol: str of column name in df for tseries 
     - grpcol: str of column name in df of group over which to plot
     - labs: dict of xlab, ylab
     - title_prepend: str containing "{}" that prepends group names in title
    '''
    unique_grp_vals = df[grpcol].unique()
    figsize = (15, 5 * len(unique_grp_vals))
    fig, axes = plt.subplots(len(unique_grp_vals), 2, figsize=figsize)
    j = 0
    for i, grp in enumerate(unique_grp_vals):
        _df = df.loc[df[grpcol] == grp]
        ax = axes[i, j]
        ax.plot(_df[xcol], _df[ycol])
        mu, sigma = _df[ycol].mean(), _df[ycol].std()
        ax.axhline(mu, linestyle='--', color='r')
        ax.axhline(mu - sigma, linestyle='-.', color='y')
        ax.axhline(mu + sigma, linestyle='-.', color='y')
        ax.set_title(title_prepend.format(grp))
        if labs is not None:
            ax.set_xlabel(labs['xlab'])
            ax.set_ylabel(labs['ylab'])
        ax.xaxis.labelpad = labelpad
        ax.xaxis.set_major_locator(years)
        #ax.xaxis.set_major_formatter(yearsFmt)
        ax.xaxis.set_minor_locator(months)
        ax.grid(alpha=.1)
        if x_angle != 0:
            for tick in ax.get_xticklabels():
                tick.set_rotation(x_angle)
        
        j += 1
        title_prepend = 'Histogram of ' + str(title_prepend)
        
        ax = axes[i, j]
        ax.hist(_df[ycol], orientation="horizontal")
        ax.axhline(mu, linestyle='--', color='r')
        ax.axhline(mu - sigma, linestyle='-.', color='y')
        ax.axhline(mu + sigma, linestyle='-.', color='y')
        ax.set_title(title_prepend.format(grp))
        if labs is not None:
            ax.set_ylabel('Bins')
            ax.set_xlabel('Count of Observations')
        ax.grid(alpha=.1)
        
        j -= 1
                
    sns.set_style("whitegrid")
    sns.despine()
    plt.show()
    
title_prepend = 'Daily Value of {}'
xcol = 'date'
ycol = 'value'
grpcol = 'variable'
labs = dict(xlab='Date', ylab='Value')
    
plot_tseries_over_group_with_histograms(df_eda_melt, xcol, ycol, grpcol, title_prepend, labs, x_angle=90)


