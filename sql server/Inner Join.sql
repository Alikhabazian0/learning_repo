
--==== Inner Join  

Select P.ProductCode , P.ProductDesc , P.CatCode , PG.CatDesc
	   From PRD.Products P 
	   Inner Join
	   PRD.ProductCategory PG 
	   On P.CatCode  = PG.CatCode

