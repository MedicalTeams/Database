USE [Clinic]
GO
/****** Object:  Table [dbo].[curr_sys_info]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[curr_sys_info]') AND type in (N'U'))
DROP TABLE [dbo].[curr_sys_info]
GO
/****** Object:  Table [dbo].[curr_sys_info]    Script Date: 9/21/2016 2:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[curr_sys_info]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[curr_sys_info](
	[curr_sys_id] [numeric](15, 0) IDENTITY(1,1) NOT NULL,
	[itm_descn] [varchar](50) NULL,
	[itm_vrsn] [varchar](10) NULL,
	[dt_of_rlse] [datetime] NULL DEFAULT (getutcdate()),
	[last_exception_rpt] [datetime] NULL,
	[last_constant_update] [datetime] NULL
)
END
GO
SET ANSI_PADDING OFF
GO
