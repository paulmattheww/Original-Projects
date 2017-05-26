## Generate calendar for pending shipments template


def generate_cal_for_pending_shipments(year):
    from pandas.tseries.offsets import YearEnd
    from pandas.tseries.holiday import USFederalHolidayCalendar
    
    start_date = pd.to_datetime('1/1/'+str(year))
    end_date = start_date + YearEnd()
    DAT = pd.date_range(str(start_date), str(end_date), freq='30min')
    WK = [d.strftime('%U') for d in DAT]
    MO = [d.strftime('%B') for d in DAT]
    holidays = USFederalHolidayCalendar().holidays(start=start_date, end=end_date)

    CAL = pd.DataFrame({'Dock Time':DAT, 'WeekNumber':WK, 'Month':MO})
    
    CAL['Date'] = [format(d, '%Y-%m-%d') for d in DAT]
    CAL['Hour'] = [format(d, '%H') for d in DAT]
    CAL['Year'] = [format(d, '%Y') for d in DAT]
    CAL['Weekday'] = [format(d, '%A') for d in DAT]
    CAL['DOTM'] = [format(d, '%d') for d in DAT]
    CAL['IsWeekday'] = CAL.Weekday.isin(['Monday','Tuesday','Wednesday','Thursday','Friday'])
    CAL['IsProductionDay'] = CAL.Weekday.isin(['Tuesday','Wednesday','Thursday','Friday'])
    last_biz_day = [str(format(dat, '%Y-%m-%d')) for dat in pd.date_range(start_date, end_date, freq='BM')]
    CAL['LastSellingDayOfMonth'] = [dat in last_biz_day for dat in CAL['Date'].astype(str)]

    CAL.loc[CAL.WeekNumber.isin(['00','01','02','03','04','05','06','07','08','09','50','51','52','53']), 'Season'] = 'Winter'
    CAL.loc[CAL.WeekNumber.isin(['10','11','12','13','14','15','16','17','18','19','20','21','22']), 'Season'] = 'Spring'
    CAL.loc[CAL.WeekNumber.isin(['23','24','25','26','27','28','29','30','31','32','33','34','35']), 'Season'] = 'Summer'
    CAL.loc[CAL.WeekNumber.isin(['36','37','38','39','40','41','42','43','44','45','46','47','48','49']), 'Season'] = 'Autumn'
    CAL['Holiday'] = CAL.Date.isin(holidays)
    CAL['HolidayWeek'] = CAL['Holiday'].rolling(window=7,center=True,min_periods=1).sum()
    CAL['ShipWeek'] = ['A' if int(wk) % 2 == 0 else 'B' for wk in WK]
    
    day_hourz = ['04','05','06','07','08','09','10','11','12','13','14','15','16','17','18']
    CAL = CAL[CAL.Hour.isin(day_hourz)]

    CAL.reset_index(drop=True, inplace=True)
    
    return CAL

generate_cal_for_pending_shipments(year=2016).head()

through_2025 = [2017,2018,2019,2020,2021,2022,2023,2024,2025]

calendar_template = pd.DataFrame()
for yr in through_2025:
    df = generate_cal_for_pending_shipments(year=yr)
    calendar_template = calendar_template.append(df)
    
calendar_template.head(20)

calendar_template.to_excel('N:/Operations Intelligence/Daily Operations Report/Pending Shipments Template 2.0.xlsx', index=False)


