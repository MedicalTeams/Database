USE [Clinic]
GO
/****** Object:  Table [dbo].[userrole]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[userrole]') AND type in (N'U'))
DROP TABLE [dbo].[userrole]
GO
/****** Object:  Table [dbo].[userrole]    Script Date: 9/21/2016 2:52:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[userrole]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[userrole](
	[id] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[userId] [uniqueidentifier] NOT NULL,
	[roleId] [uniqueidentifier] NOT NULL,
	[createDate] [datetime] NULL DEFAULT (getutcdate()),
	[createdBy] [uniqueidentifier] NULL
)
END
GO
