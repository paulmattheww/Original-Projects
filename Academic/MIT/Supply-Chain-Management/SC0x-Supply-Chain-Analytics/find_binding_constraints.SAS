proc optmodel;
	var xB;
	var xC;
	
	maximize z = 25 * xB + 30 * xC;
	
	con Time: xB/200 + xC/140 <= 40 ;
	con MacB: 0 <= xB/100 <= 60 ;
	con MacC: 0 <= xC/100 <= 40 ;
	
	solve;
	
	print z;
	print Time.status;
	print MacB.status;
	print MacC.status;
  
  quit;
