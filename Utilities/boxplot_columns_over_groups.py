cols_to_boxplot = ['routes_per_day', 'split_cases_delivered_per_day', 'stops_per_day']
unique_groups = stl_daily_prdday['loc'].unique()
grpcol_name = 'loc'
treatment_col = 'schlafly'

def boxplot_columns_over_groups(df, cols_to_boxplot, unique_groups, grpcol_name, treatment_col):
    plt.clf()
    ncols_to_plot, ngroups = len(cols_to_boxplot), len(unique_groups)
    fig, axes = plt.subplots(ncols_to_plot, ngroups, figsize=(ngroups*7, ncols_to_plot*6))
    for i, col in enumerate(cols_to_boxplot):
        for j, grp in enumerate(unique_groups):
            in_group = df[grpcol_name] == grp
            _df = df.loc[in_group, [grpcol_name, col]]
            ax = axes[i, j]
            ax.boxplot(_df.loc[_df[treatment_col]==0, col], label='treatment = 0')
            ax.boxplot(_df.loc[_df[treatment_col]==1, col], label='treatment = 1')
            ax.set_title(str(col) + ' for ' + grp)
    plt.show()
    
boxplot_columns_over_groups(stl_daily_prdday, cols_to_boxplot, unique_groups, grpcol_name, treatment_col)
