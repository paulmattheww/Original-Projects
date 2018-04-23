import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
%matplotlib inline
from mpl_toolkits.axes_grid1 import make_axes_locatable

years = mdates.YearLocator()   # every year
months = mdates.MonthLocator()  # every month
yearsFmt = mdates.DateFormatter('%Y')


def plot_tseries_over_group_with_histograms(df, xcol, ycol, grpcol, title_prepend='{}', 
                            labs=None, x_angle=0, labelpad=60, window=10):
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
    nrows = len(unique_grp_vals) // 2
    figsize = (12, 12 * nrows)
    fig, axes = plt.subplots(len(unique_grp_vals), 1, figsize=figsize)
    title_prepend_hist = 'Histogram of ' + str(title_prepend)
    j = 0
    for i, grp in enumerate(unique_grp_vals):
        _df = df.loc[df[grpcol] == grp]
        ax = axes[i]
        ax.plot(_df[xcol], _df[ycol], alpha=.5, color='black')
        ax.plot(_df[xcol], _df[ycol].rolling(window=window).mean(), 
                alpha=.8, color='r', label='{} period rolling avg'.format(window))
        mu, sigma = _df[ycol].mean(), _df[ycol].std()
        ax.axhline(mu, linestyle='--', color='r', alpha=.3)
        ax.axhline(mu - sigma, linestyle='-.', color='y', alpha=.3)
        ax.axhline(mu + sigma, linestyle='-.', color='y', alpha=.3)
        ax.set_title(title_prepend.format(grp))
        ax.legend(loc='best')
        if labs is not None:
            ax.set_xlabel(labs['xlab'])
            ax.set_ylabel(labs['ylab'])
        ax.xaxis.labelpad = labelpad
        #ax.xaxis.set_major_locator(years)
        #ax.xaxis.set_major_formatter(yearsFmt)
        ax.xaxis.set_minor_locator(months)
        ax.grid(alpha=.1)
        if x_angle != 0:
            for tick in ax.get_xticklabels():
                tick.set_rotation(x_angle)

        divider = make_axes_locatable(ax)
        axHisty = divider.append_axes('right', 1.2, pad=0.1, sharey=ax)
        axHisty.grid(alpha=.1)
        axHisty.hist(_df[ycol].dropna(), orientation='horizontal', alpha=.5, color='lightgreen', bins=25)
        axHisty.axhline(mu, linestyle='--', color='r', label='mu', alpha=.3)
        axHisty.axhline(mu - sigma, linestyle='-.', color='y', label='+/- two sigma', alpha=.3)
        axHisty.axhline(mu + sigma, linestyle='-.', color='y', alpha=.3)
        axHisty.legend(loc='best')
        
        j += 1
                
    sns.set_style("whitegrid")
    sns.despine()
    plt.show()

title_prepend = 'Number of Trucks to Market for {}'
xcol = 'date'
ycol = 'rte'
grpcol = 'loc'
labs = dict(xlab='', ylab='Number of Trucks')
    
plot_tseries_over_group_with_histograms(stl_daily, xcol, ycol, grpcol, title_prepend, labs, x_angle=90)
