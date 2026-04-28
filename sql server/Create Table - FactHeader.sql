Use Store 

	  Create Table FCT.FactHeader ( FactNo Int Primary Key , 
								    FactDate     Char(10),
									RequiredDate Char(10),
									CustomerCode Varchar(5) ,
									UserId Int  , 
									Description Nvarchar(2000) ,
									InsertDate As Getdate() )


	  