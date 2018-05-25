# paul washburn st louis mo cofactor
import matplotlib.pyplot as plt
import seaborn as sns
%matplotlib inline

fig, axes = plt.subplots(1, 2, figsize=(16, 6))
i = 0
colors = ['green', 'blue', 'orange']
for swap, df in rte_swaps_byday.groupby('rte_swap'):
    ax = axes[i]; j = 0
    for rte, _df in df.groupby('rte_identifier'):
        ax.hist(_df.Cases, label=rte, color=colors[j], alpha=.5, bins=10)
        ax.set_title('Histogram of Cases\n' + str(swap))
        ax.legend(loc='best')
        ax.set_xlabel('Cases Delivered')
        ax.set_ylabel('Number of Observations')
        ax.set_xlim(100, 500)
        sns.despine()
        j += 1
    i += 1
