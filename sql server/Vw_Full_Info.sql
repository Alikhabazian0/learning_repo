
Create View [dbo].[Vw_Full_Info]
As
Select FH.FactNo , FactDate , FH.CustomerCode , C.CompanyName
	  ,FH.UserId , CONCAT(PR.FirstName , LastName) As FullName
	  ,P.CatCode , PG.CatDesc ,P.ProductCode , P.ProductDesc , P.UnitCode , PU.UnitDesc , Fee , Qty 
	  ,P.SupplierCode ,S.CompanyName As SupplierCompany, S.CountryCode , CT.CountryDesc
	  ,S.CityCode , CY.CityDesc

	  From FCT.FactHeader FH 
	  Inner Join
	  FCT.FactDetail FD
	  On FH.FactNo   =   FD.FactNo 
	  Inner Join
	  ORD.Customers C 
	  On FH.CustomerCode  =  C.CustomerCode
	  Inner Join
	  HR.Personels  PR 
	  On PR.PersonelCode   =   FH.UserId
	  Inner Join
	  PRD.Products P 
	  On FD.ProductCode    =   P.ProductCode
	  Inner Join
	  PRD.ProductCategory PG
	  On P.CatCode         =   PG.CatCode
	  Inner Join
	  PRD.ProductUnit PU
	  On PU.UnitCode       =     P.UnitCode
	  Inner Join
	  ORD.Suppliers S
	  On S.SupplierCode    =   P.SupplierCode
	  Inner Join
	  GEO.Country CT 
	  On CT.CountryCode   =     S.CountryCode
	  Inner Join
	  GEO.City CY
	  On CY.CityCode	  =     S.CityCode
	
	 
GO


