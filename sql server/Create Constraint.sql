


Alter Table HR.Personels ADD Constraint  Check_Gender  CHECK (Gender IN (0, 1))
Alter Table HR.Personels ADD Constraint  Check_BDate   CHECK (Len(BDate) = 10 )



Alter Table PRD.Products ADD Constraint  Check_MinStock Check (MinStock > 0)


Alter Table PRD.Products ADD Constraint  FK_Products_ProductCategory  Foreign Key (CatCode)      References PRD.ProductCategory(CatCode)
Alter Table PRD.Products ADD Constraint  FK_Products_Suppliers        Foreign Key (SupplierCode) References ORD.Suppliers(SupplierCode)
Alter Table PRD.Products ADD Constraint  FK_Products_ProductUnit      Foreign Key (UnitCode)     References PRD.ProductUnit(UnitCode)
Alter Table PRD.Products ADD Constraint  FK_Products_Personels		  Foreign Key (UserId)		 References HR.Personels(PersonelCode)
Alter Table PRD.Products ADD DEFAULT (1) FOR [Active]

Alter Table ORD.Suppliers ADD Constraint FK_Suppliers_Titles		  Foreign Key (TitleCode)	References HR.Titles(TitleCode)
Alter Table ORD.Suppliers ADD Constraint FK_Suppliers_Country		  Foreign Key (CountryCode)	References GEO.Country(CountryCode)
Alter Table ORD.Suppliers ADD Constraint FK_Suppliers_City			  Foreign Key (CityCode)	References GEO.City(CityCode)


Alter Table ORD.Customers ADD Constraint FK_Customers_Titles		  Foreign Key (TitleCode)	References HR.Titles(TitleCode)
Alter Table ORD.Customers ADD Constraint FK_Customers_Country		  Foreign Key (CountryCode)	References GEO.Country(CountryCode)
Alter Table ORD.Customers ADD Constraint FK_Customers_City			  Foreign Key (CityCode)	References GEO.City(CityCode)
Alter Table ORD.Customers ADD Constraint Unique_Phone                 Unique (Phone)   


Alter Table FCT.FactHeader ADD Constraint  Check_FactDate          CHECK (Len(FactDate)     = 10 )
Alter Table FCT.FactHeader ADD Constraint  Check_RequiredDate      CHECK (Len(RequiredDate) = 10 )
Alter Table FCT.FactHeader ADD Constraint  FK_FactHeader_Customers Foreign Key (CustomerCode)	References ORD.Customers(CustomerCode)
Alter Table FCT.FactHeader ADD Constraint  FK_FactHeader_Personels Foreign Key (UserId)			References HR.Personels(PersonelCode)


Alter Table FCT.FactDetail ADD Constraint  FK_FactDetail_FactHeader Foreign Key (FactNo)	    References FCT.FactHeader(FactNo)
Alter Table FCT.FactDetail ADD Constraint  FK_FactDetail_Products	Foreign Key (ProductCode)	References PRD.Products(ProductCode)