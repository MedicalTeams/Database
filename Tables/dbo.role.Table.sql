USE [Clinic]
GO
/****** Object:  Table [dbo].[role]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[role]') AND type in (N'U'))
DROP TABLE [dbo].[role]
GO
/****** Object:  Table [dbo].[role]    Script Date: 9/21/2016 2:52:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[role]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[role](
	[roleId] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[roleName] [varchar](100) NULL,
	[accessType] [varchar](100) NULL,
	[createDate] [datetime] NULL DEFAULT (getutcdate()),
	[createdBy] [uniqueidentifier] NULL
)
END
GO
SET ANSI_PADDING OFF
GO
