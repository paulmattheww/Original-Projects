import plotly.offline as py
import plotly.graph_objs as go
import plotly.figure_factory as ff
py.init_notebook_mode(connected=True)

def plot_by_month(df, y, title, 
               seperate_y_axis=False, 
               x_axis_label='', y_axis_label='', 
               scale='linear', initial_hide=False,
               barmode='group'):
    '''
    Plot variables by month
    '''
    df = df.loc[:, y + ['month']].groupby('month')[y].sum()
    
    label_arr = list(df)
    series_arr = list(map(lambda col: df[col], label_arr))
    
    for col in df.columns:
        df[col] = df[col].apply(lambda x: round(x, 2))
    print(title); print('-' * 100); print(df.T)
    
    
    layout = go.Layout(
        barmode = barmode,
        title = title,
        legend = dict(orientation="h"),
        xaxis = dict(type='month',
                  title='Month'),
        yaxis=dict(
            title = y_axis_label,
            showticklabels = not seperate_y_axis,
            type = scale
        ),
        bargap=0.2
    )
    
    y_axis_config = dict(
        overlaying = 'y',
        showticklabels = False,
        type = scale )
    
    visibility = 'visible'
    if initial_hide:  visibility = 'legendonly'
        
    # make a trace for each series
    trace_arr = []
    for index, series in enumerate(series_arr):
        trace = go.Bar( #go.Scatter
            x=series.index, 
            y=series, 
            text=title, 
            name=label_arr[index],
            visible=visibility,
            opacity=0.7
        )
        # Add seperate axis for the series
        if seperate_y_axis:
            trace['yaxis'] = 'y{}'.format(index + 1)
            layout['yaxis{}'.format(index + 1)] = y_axis_config    
        trace_arr.append(trace)
    fig = go.Figure(data=trace_arr, layout=layout)
    py.iplot(fig)
    print('\n')

    
def interactive_bar_plot(ops_df, y_list, subgroup, y_axis_label='Total Wages ($)'):
    for grp, df in ops_df.groupby(['warehouse', subgroup]):
        title = str(grp).replace('(', '').replace(')', '').replace('\'', '')
        plot_by_month(df, 
                      y=y_list, 
                      title=title, 
                      seperate_y_axis=False, 
                      y_axis_label=y_axis_label, 
                      scale='linear',
                      initial_hide=False)
