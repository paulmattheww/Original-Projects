proc optmodel;
	set X={'High','Supreme'};
	set Additive={'A','B'};
	number Requirements{Additive,X}=[
	3 2
	1 3];
	
	number Available{Additive}=[300 280];
	number Profit{X}=[80 200];
	
	var Amount{X}>=0;
	
	maximize Z = sum{i in X}Profit[i]*Amount[i];
	
	con AdditiveConst{j in Additive}: sum{i in X}Amount[i]*Requirements[j,i]<=Available[j];
	con CapacityConst: sum{i in X}Amount[i]<=110;
	
	solve;
	print Amount Z;
quit;
