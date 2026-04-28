--=== Aggregate Functions

--=== 
Select ProductCode
	   ,Sum(Fee * Qty ) As SumPrice   --===   برای جمع مقادیر
	   ,Avg(Fee * Qty ) As AvgPrice   --===   برای میانگین مقادیر
	   ,Min(Fee * Qty ) As MinPrice   --===   برای کوچکترین مقادیر
	   ,Max(Fee * Qty ) As MaxPrice   --===   برای بزرگترین مقادیر
	   ,Count(*) As Count_Product     --===   برای تعداد مقادیر

	   From FCT.FactDetail 
	   Group By ProductCode 