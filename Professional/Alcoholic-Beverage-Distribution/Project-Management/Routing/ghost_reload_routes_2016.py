## Roadnet - Gather Routes from Daily Report Production Tab
## Look for "ghost" routes, keg routes, and reloads

import pandas as pd
import numpy as np
import datetime as dt

rtes2016 = pd.read_csv('C:/Users/pmwash/Desktop/Python/Projects/Roadnet/production_tab_daily_report.csv')
rtes2016.columns = ['Driver', 'Extra', 'Stops', 'RouteId', 'TruckId', 'LoadingDoor', 'Warehouse', 
                    'CasesSplit', 'CaseOnly', 'BtlsOnly', 'DriverId', 'StartHr', 'EndHr', 'TotHours', 'StartMi', 
                    'EndMi', 'Date', 'Index']
rtes2016['Date'] = rtes2016['Date'].str.replace('.xlsx', '') + '-2016'
rtes2016['Date'] = pd.to_datetime(rtes2016['Date'], infer_datetime_format = True) 
 
#strt = rtes2016['StartMi']
#end = rtes2016['EndMi']
#rtes2016['Miles'] = [end - strt for i in end]
#rtes2016['StartMi'] - rtes2016['EndMi']
 
#lst = list(rtes2016['StartMi'])
 

#for i in len(lst):    
#    if rtes2016['StartMi'][i] != 'NaN':
#        rtes2016['Miles'][i] = rtes2016['StartMi'][i] - rtes2016['EndMi'][i] 
#    else:
#        rtes2016['Miles'][i] = 0





class routes:

    def __init__(self, routeId, warehouse):
        self.routeId = routeId
        self.warehouse = warehouse
        
    def name(self):
        return self.routeId +'_'+ self.warehouse
        


Routes = rtes2016[['Warehouse','RouteId']]
Routes = Routes.drop_duplicates()
Routes = routes(Routes['RouteId'], Routes['Warehouse'])


print(Routes.name())



class drivers:
    
    def __init__(self, driverId, driver, warehouse):
        self.driverId = driverId
        self.driver = driver
        self.warehouse = warehouse
        
    def name(self):
        return self.driverId + '_' + self.driver + '_' + self.warehouse

        
        
        
Drivers = rtes2016[['Driver','DriverId','Warehouse']]
Drivers = Drivers.drop_duplicates()
Drivers = drivers(Drivers['DriverId'],Drivers['Driver'], Drivers['Warehouse'])


print(Drivers.name())


class trucks:
    
    def __init__(self, truckId): # LATER capacity, miles, age, cost/mpg, repairs, etc.
        self.truckId = truckId
        #self.truck = truck
        
    def name(self):
        return self.truckId
        
    def count(self):
        return self.truckId.count()
        

Trucks = rtes2016['TruckId']
Trucks = Trucks.drop_duplicates()
Trucks = trucks(Trucks)


print(Trucks.name())









print(rtes2016.head())




class daily_routes(routes):
    
    def __init__(self, date, 
                 trucks, 
                 drivers, 
                 routes, #warehouse,
                 stops, #startTime, endTime,
                 hours, #startMi, endMi, #miles, 
                 cases,
                 warehouse
                 ):
        self.date = date
        self.trucks = trucks
        self.drivers = drivers
        self.routes = routes
        self.hours = hours
        self.stops = stops
        self.cases = cases
        self.warehouse = warehouse
        #self.miles = miles
        #add off day count
    
    def summary(self):
        df = pd.DataFrame({'Total Hours' : self.hours, 
                             'Total Stops' : self.stops, 
                             'Number of trucks' : self.trucks,
                             'Total Cases' : self.cases,
                             'Driver' : self.drivers.name()
                             })
        return df.groupby('Driver').sum()
   
    def df(self): 
       df = pd.DataFrame({'Date' : self.date, 
       'Route' : self.routes.name(),
       'Stops' : self.stops, 
       'Hours' : self.hours, 
       'Cases' : self.cases, 
       'Truck' : self.trucks.name(),
       'Driver' : self.drivers.name(),
       'Warehouse' : self.warehouse})
       df = df[['Date', 'Warehouse', 'Route', 'Truck', 'Driver', 'Stops', 'Cases', 'Hours']]
       return df
        
    def daily_summary(self):
        df_dat = self.df().groupby(['Warehouse', 'Date'])
        return df_dat['Cases', 'Stops', 'Hours'].sum()






dat = rtes2016['Date']
trucks_daily = trucks(truckId = rtes2016['TruckId'])

drivers_daily = drivers(driverId = rtes2016['DriverId'],
                        driver = rtes2016['Driver'],
                        warehouse = rtes2016['Warehouse'])
routes_daily = routes(routeId = rtes2016['RouteId'],
                      warehouse = rtes2016['Warehouse'])
stops_daily = rtes2016['Stops']
hours_daily = rtes2016['TotHours'] 
cases_daily = rtes2016['CasesSplit']
warehouse_daily = rtes2016['Warehouse']
#miles_daily = rtes2016['Hours']                 

rte_summary_2016 = daily_routes(date = dat,
                               trucks = trucks_daily,
                               routes = routes_daily,
                               stops = stops_daily, 
                               hours = hours_daily, 
                               drivers = drivers_daily,
                               cases = cases_daily,
                               warehouse = warehouse_daily)
                               
print(rte_summary_2016.summary())
print(rte_summary_2016.df())
print(rte_summary_2016.daily_summary())


