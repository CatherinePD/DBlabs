use SoftLicenseManagement;
exec sp_configure 'clr_enabled', 1
reconfigure

create assembly GetLicenses
	from 'D:\3rd course\2nd sem\ÁÄ\Ëàáû\lab3\lab3\bin\Debug\lab3.dll'
	with permission_set = safe;

drop assembly GetLicenses
go
create procedure GetLicensesFromC (@dateStart datetime, @dateEnd datetime)
	as external name GetLicenses.StoredProcedures.GetLicenses
go

exec GetLicensesFromC '20-01-2020','25-02-2020';

CREATE TABLE LicensesTest
(
Record dbo.License
)
