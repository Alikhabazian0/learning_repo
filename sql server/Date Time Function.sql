-- Date & Time Function 

---====== 

Select GetDate()   ---=== زمان جاری 

Select Day(Miladi_FactDate)  ,DatePart ( Day ,Miladi_FactDate )  --=== روز را برمیگرداند
	  ,Month(Miladi_FactDate),DatePart ( Month ,Miladi_FactDate )  --=== ماه را برمیگرداند
	  ,Year(Miladi_FactDate) , DatePart ( Year ,Miladi_FactDate )  --=== سال را برمیگرداند
	  ,DateAdd ( Day , 10 ,Miladi_FactDate ) --=== اضافه کردن به تاریخ
	  ,DateDiff (Day , Miladi_FactDate , Miladi_RequiredDate )  --=== بدست آوردن اختلاف بین دو تاریخ
	  ,DateName ( Month ,Miladi_FactDate )  --==== عنوان ماه میلادی را نمایش میدهد
	  ,EOMONTH(Miladi_FactDate) --====آخرین  روز ماه تاریخ انتخاب شده را نمایش میدهد 
      From FCT.FactHeader