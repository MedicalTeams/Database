USE [Clinic]
GO
/****** Object:  Table [dbo].[raw_visit]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[raw_visit]') AND type in (N'U'))
DROP TABLE [dbo].[raw_visit]
GO
/****** Object:  Table [dbo].[raw_visit]    Script Date: 9/21/2016 2:52:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[raw_visit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[raw_visit](
	[visit_uuid] [nvarchar](100) NOT NULL,
	[visit_json] [nvarchar](max) NOT NULL,
	[rec_creat_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_creat_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
	[rec_updt_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_updt_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
	[visit_stat] [varchar](1) NOT NULL DEFAULT ('N'),
	[err_cd] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[visit_uuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_PADDING OFF
GO
