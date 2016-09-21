USE [Clinic]
GO
/****** Object:  Table [dbo].[tmp_jsonvisit]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tmp_jsonvisit]') AND type in (N'U'))
DROP TABLE [dbo].[tmp_jsonvisit]
GO
/****** Object:  Table [dbo].[tmp_jsonvisit]    Script Date: 9/21/2016 2:52:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tmp_jsonvisit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tmp_jsonvisit](
	[element_id] [int] NOT NULL,
	[sequenceNo] [int] NULL,
	[parent_ID] [int] NULL,
	[Object_ID] [int] NULL,
	[Name] [varchar](2000) NULL,
	[StringValue] [nvarchar](max) NOT NULL,
	[ValueType] [varchar](10) NOT NULL,
	[visit_uuid] [nvarchar](100) NOT NULL
)
END
GO
SET ANSI_PADDING OFF
GO
