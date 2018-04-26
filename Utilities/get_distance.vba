Public Function getDistance(latitude1, longitude1, latitude2, longitude2)  
earth_radius = 6371  
Pi = 3.14159265  
deg2rad = Pi / 180  

dLat = deg2rad * (latitude2 - latitude1)  
dLon = deg2rad * (longitude2 - longitude1)  

a = Sin(dLat / 2) * Sin(dLat / 2) + Cos(deg2rad * latitude1) * Cos(deg2rad * latitude2) * Sin(dLon / 2) * Sin(dLon / 2)  
c = 2 * WorksheetFunction.Asin(Sqr(a))  

d = earth_radius * c  

getDistance = d  

End Function
