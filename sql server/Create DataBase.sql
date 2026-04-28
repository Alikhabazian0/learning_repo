CREATE DATABASE Store
ON
		( NAME = Store_Data,
		 FILENAME = 'D:\Databases\Store\Store_Data.mdf',
		 SIZE = 10MB,
		 MAXSIZE = Unlimited,
		 FILEGROWTH = 5MB )
		 LOG ON
		( NAME = Store_Log,
		 FILENAME = 'D:\Databases\Store\Store_Log.ldf',
		 SIZE = 5MB,
		 MAXSIZE = Unlimited,
		 FILEGROWTH = 5MB );

