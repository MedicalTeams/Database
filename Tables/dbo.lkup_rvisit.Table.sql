USE [Clinic]
GO
/****** Object:  Table [dbo].[lkup_rvisit]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lkup_rvisit]') AND type in (N'U'))
DROP TABLE [dbo].[lkup_rvisit]
GO
/****** Object:  Table [dbo].[lkup_rvisit]    Script Date: 9/21/2016 2:52:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lkup_rvisit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[lkup_rvisit](
	[rvisit_id] [numeric](15, 0) IDENTITY(1,1) NOT NULL,
	[rvisit_descn] [nvarchar](10) NOT NULL,
	[rvisit_ind] [varchar](1) NOT NULL,
	[user_intrfc_sort_ord] [numeric](4, 0) NULL,
	[rec_creat_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_creat_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
	[rec_updt_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_updt_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
 CONSTRAINT [pk_LKUP_RVISIT] PRIMARY KEY CLUSTERED 
(
	[rvisit_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_PADDING OFF
GO
