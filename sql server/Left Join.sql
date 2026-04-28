
--=== Left Join


Select Distinct C.CustomerCode , C.CompanyName , F.CustomerCode
	   From ORD.Customers C 
	   Left Join
	   FCT.FactHeader F
	   On C.CustomerCode   =  F.CustomerCode

	   Where F.CustomerCode Is Null 


	   --======================== پیدا کردن مشتریانی که خرید نداشتند به روش دیگر

	   Select C.*
		      From ORD.Customers C
			  Where CustomerCode Not In ( Select CustomerCode From FCT.FactHeader )