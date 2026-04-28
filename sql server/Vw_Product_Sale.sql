Create View [dbo].[Vw_Product_Sale] 
As 

	 Select P.ProductCode , P.ProductDesc , Sum( Fee * Qty ) As ProductPrice
			,PTotal 
			,Cast ( Cast ( Sum( Fee * Qty ) As Numeric(18,2)) / PTotal * 100 As Numeric(18,2)) As PercentProductPrice

		    From PRD.Products P 
		    Inner Join
		    FCT.FactDetail F 
		    On P.ProductCode   =   F.ProductCode
			Inner Join
			( Select  Sum( Fee * Qty ) As PTotal
				     From FCT.FactDetail )ProductTotal

			On  1 =  1 

			Group By P.ProductCode , P.ProductDesc , PTotal
			Order By Sum( Fee * Qty ) Desc Offset 0 Rows 
GO


