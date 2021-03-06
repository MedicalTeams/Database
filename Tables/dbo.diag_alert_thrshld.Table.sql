USE [Clinic]
GO
/****** Object:  Table [dbo].[diag_alert_thrshld]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[diag_alert_thrshld]') AND type in (N'U'))
DROP TABLE [dbo].[diag_alert_thrshld]
GO
/****** Object:  Table [dbo].[diag_alert_thrshld]    Script Date: 9/21/2016 2:52:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[diag_alert_thrshld]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[diag_alert_thrshld](
	[diag_alert_thrshld_id] [numeric](15, 0) IDENTITY(1,1) NOT NULL,
	[diag_id] [numeric](15, 0) NOT NULL,
	[case_cnt] [numeric](4, 0) NOT NULL,
	[baseln_multr] [decimal](6, 3) NOT NULL,
	[rec_creat_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_creat_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
	[rec_updt_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_updt_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
 CONSTRAINT [pk_DIAG_ALERT_THRSHLD] PRIMARY KEY NONCLUSTERED 
(
	[diag_alert_thrshld_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_PADDING OFF
GO
