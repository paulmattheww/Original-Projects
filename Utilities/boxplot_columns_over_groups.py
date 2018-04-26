# paul m washburn

cols_to_boxplot = ['routes_per_day', 'split_cases_delivered_per_day', 'stops_per_day']
unique_groups = stl_daily_prdday['loc'].unique()
grpcol_name = 'loc'
treatment_col = 'schlafly'

def boxplot_columns_over_groups(df, cols_to_boxplot, unique_groups, 
                                grpcol_name, treatment_col,
                                savefig=False, fname='fig.png'):
    plt.clf()
    positions = np.arange(1, df[treatment_col].unique().shape[0]+1)
    ncols_to_plot, ngroups = len(cols_to_boxplot), len(unique_groups)
    fig, axes = plt.subplots(ncols_to_plot, ngroups, figsize=(ngroups*7, ncols_to_plot*6))
    for i, col in enumerate(cols_to_boxplot):
        for j, grp in enumerate(unique_groups):
            in_group = df[grpcol_name] == grp
            _df = df.loc[in_group, [treatment_col, grpcol_name, col]]
            treated = _df[treatment_col]==0
            ax = axes[i, j]
            _df.boxplot(col, by=treatment_col, ax=ax)
            ax.set_title(str(col).replace('_', ' ').title() + ' for ' + str(grp))
            ax.grid(alpha=.3)
            ax.set_xlabel(treatment_col)
            ax.set_ylabel(col)
    sns.despine()
    plt.savefig(fname)
    plt.show()
    
boxplot_columns_over_groups(stl_daily_prdday, cols_to_boxplot, unique_groups, grpcol_name, treatment_col,
                           savefig=True, fname='./figs/boxplots_schlafly_comparison.png')
