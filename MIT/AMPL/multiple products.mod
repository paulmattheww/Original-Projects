reset;

set factory ;
set crossdock ;
set dc ;
set type ;

param transport_in {factory, crossdock, type} ;
param transport_out {crossdock, dc, type} ;
param demand {dc, type} ;
#param capacity_product {factory, type} ;
param capacity {factory} ;

var inflow {factory, crossdock, type} integer >= 0 ;
var outflow {crossdock, dc, type} integer >= 0 ;

minimize total_cost:
       sum{i in factory, j in crossdock, p in type} inflow[i,j,p]*transport_in[i,j,p] +
       sum{j in crossdock, k in dc, p in type} outflow[j,k,p]*transport_out[j,k,p] 
;

s.t. meet_demand {k in dc, p in type}:
       sum{j in crossdock} outflow[j,k,p] >= demand[k,p] 
;
       
s.t. flowthrough {j in crossdock, p in type}:
       sum{i in factory} inflow[i,j,p] -
       sum{k in dc} outflow[j,k,p] = 0
;

#s.t. obey_product_capacity {i in factory, p in type}:
#      sum{j in crossdock} inflow[i,j,p] <= capacity_product[i,p]
#;

s.t. obey_combined_capacity {i in factory}:
       sum{j in crossdock, p in type} inflow[i,j,p] <= capacity[i]
;

s.t. make_10_eachkind {i in factory, p in type}:
       sum{j in crossdock} inflow[i,j,p] >= 10 
;

data;
set factory := Factory1   Factory2 Factory3 Factory4 Factory5 ;
set crossdock := crossdock1      crossdock2 ;
set dc := DC1 DC2 DC3 DC4 DC5 ;
set type := stylish leisure ;

param transport_in :=

       [Factory1,*,*]:     stylish      leisure :=
              crossdock1          30                  33
              crossdock2          50                  55
       [Factory2,*,*]:     stylish      leisure :=
              crossdock1          23                  25
              crossdock2          66                  73
       [Factory3,*,*]:     stylish      leisure :=
              crossdock1          35                  39
              crossdock2          14                  15
       [Factory4,*,*]:     stylish      leisure :=
              crossdock1          70                  77
              crossdock2          12                  13
       [Factory5,*,*]:     stylish      leisure :=
              crossdock1          65                  13
              crossdock2          70                  14 
;

param transport_out :=
       [crossdock1,*,*]:  stylish leisure :=
              DC1                        12            13     
              DC2                        25            28
              DC3                        22            24
              DC4                        40            44
              DC5                        41            45
       [crossdock2,*,*]:  stylish leisure :=
              DC1                        65            72
              DC2                        22            24
              DC3                        23            25
              DC4                        12            13
              DC5                        15            17
;


## If use combine capacity, don't use per product
#param capacity_product :
#                    stylish             leisure :=
#Factory1    150                 200
#Factory2    300                 300
#Factory3    90                  70
#Factory4    140                 30
#Factory5    220                 220
#;

param: capacity :=
Factory1     200
Factory2     300
Factory3     100#1e+9#100
Factory4     150#1e+9#150
Factory5     220#1e+9#220
;

param demand :
                   	stylish 	  leisure :=
DC1                 130           15
DC2                 45            45
DC3                 70            40
DC4                 100           100
DC5                 15            175
;


option solver cplex;
solve;
option display_1col 1 ;
#display {i in factory, j in crossdock, p in type} inflow[i,j,p] ;
display inflow ;
display outflow ;
display total_cost;




















