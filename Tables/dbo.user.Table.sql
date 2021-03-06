USE [Clinic]
GO
/****** Object:  Table [dbo].[user]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[user]') AND type in (N'U'))
DROP TABLE [dbo].[user]
GO
/****** Object:  Table [dbo].[user]    Script Date: 9/21/2016 2:52:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[user]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[user](
	[userId] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[firstname] [varchar](100) NOT NULL,
	[lastname] [varchar](100) NOT NULL,
	[email] [varchar](100) NOT NULL,
	[password] [varchar](100) NOT NULL,
	[createDate] [datetime] NULL DEFAULT (getutcdate()),
	[createdBy] [uniqueidentifier] NULL
)
END
GO
SET ANSI_PADDING OFF
GO
