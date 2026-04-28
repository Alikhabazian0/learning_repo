
--==== Case & IIF 

Select *, Case When Substring(FactDate,6,2) In ('01' , '02' , '03' ) Then 'فصل بهار'
			When Substring(FactDate,6,2) In ('04' , '05' , '06' ) Then 'فصل تابستان'
			When Substring(FactDate,6,2) In ('07' , '08' , '09' ) Then 'فصل پاییز'
			Else 'فصل زمستان' END As Season
			,IIF ( Substring(FactDate,6,2) In ('01' , '02' , '03','04' , '05' , '06' ) , 'شش ماهه اول' , 'شش ماهه دوم' )As Part
	   From FCT.FactHeader