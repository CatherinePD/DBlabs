USE Lab4db
GO
CREATE FUNCTION [dbo].[getSetDistance] (@firstRectangle NUMERIC(10,0), @secondRectangle NUMERIC(10,0))  
RETURNS FLOAT
AS  
BEGIN
	DECLARE @geog1 geography;  
	DECLARE @geog2 geography;  
	DECLARE @result FLOAT; 

	SELECT @geog1 = ogr_geometry FROM relief_map1 WHERE id = @firstRectangle;  
	SELECT @geog2 = ogr_geometry FROM relief_map1 WHERE id = @secondRectangle;  
	SELECT @result = @geog1.STDistance(@geog2);  
	RETURN @result;  
END 

GO
CREATE FUNCTION [dbo].[getSetException] (@firstRectangle NUMERIC(10,0), @secondRectangle NUMERIC(10,0))  
RETURNS NVARCHAR(4000)
AS  
BEGIN
	DECLARE @geog1 geography;  
	DECLARE @geog2 geography;  
	DECLARE @result geography; 
	DECLARE @ans NVARCHAR(500); 

	SELECT @geog1 = ogr_geometry FROM relief_map1 WHERE id = @firstRectangle;  
	SELECT @geog2 = ogr_geometry FROM relief_map1 WHERE id = @secondRectangle;  
	SELECT @result = @geog1.STDifference(@geog2);  
	SELECT @ans = @result.ToString();
	RETURN @ans;  
END 

GO
CREATE FUNCTION [dbo].[getSetIntersection] (@firstRectangle INT, @secondRectangle INT)  
RETURNS NVARCHAR(500)
AS  
BEGIN
	DECLARE @geog1 geography;  
	DECLARE @geog2 geography;  
	DECLARE @result geography; 
	DECLARE @ans NVARCHAR(500); 

	SELECT @geog1 = ogr_geometry FROM relief_map1 WHERE id = @firstRectangle;  
	SELECT @geog2 = ogr_geometry FROM relief_map1 WHERE id = @secondRectangle;  
	SELECT @result = @geog1.STIntersection(@geog2);  
	SELECT @ans = @result.ToString();
	RETURN @ans;  
END

GO
CREATE FUNCTION [dbo].[getSetUnion] (@firstRectangle NUMERIC(10,0), @secondRectangle NUMERIC(10,0))  
RETURNS NVARCHAR(4000)
AS  
BEGIN
	DECLARE @geog1 geography;  
	DECLARE @geog2 geography;  
	DECLARE @result geography;
	DECLARE @ans NVARCHAR(500);  

	SELECT @geog1 = ogr_geometry FROM relief_map1 WHERE id = @firstRectangle;  
	SELECT @geog2 = ogr_geometry FROM relief_map1 WHERE id = @secondRectangle;  
	SELECT @result = @geog1.STUnion(@geog2);  
	SELECT @ans = @result.ToString();
	RETURN @ans;  
END
GO 