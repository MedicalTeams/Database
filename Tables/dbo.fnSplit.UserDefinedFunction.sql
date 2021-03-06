USE [Clinic]
GO
/****** Object:  UserDefinedFunction [dbo].[fnSplit]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnSplit]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnSplit]
GO
/****** Object:  UserDefinedFunction [dbo].[fnSplit]    Script Date: 9/21/2016 2:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnSplit]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[fnSplit]

	(
		@List nvarchar(2000)
		,@SplitOn nvarchar(5)
	)  

RETURNS @RtnValue table 

	(

	Id INT IDENTITY (1,1)
	,Value NVARCHAR (100)
) 

AS  

BEGIN

WHILE (CHARINDEX(@SplitOn,@List)>0)

BEGIN

INSERT INTO @RtnValue (Value)

	SELECT
		Value = LTRIM(RTRIM(SUBSTRING(@List,1,CHARINDEX(@SplitOn,@List)-1))) 
	SET @List = SUBSTRING(@List,CHARINDEX(@SplitOn,@List)+LEN(@SplitOn),LEN(@List))

END 

INSERT INTO @RtnValue (Value)

	SELECT
		Value =LTRIM(RTRIM(@List))
RETURN

END' 
END

GO
