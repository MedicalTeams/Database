USE [Clinic]
GO
/****** Object:  Table [dbo].[lkup_exceptions]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lkup_exceptions]') AND type in (N'U'))
DROP TABLE [dbo].[lkup_exceptions]
GO
/****** Object:  Table [dbo].[lkup_exceptions]    Script Date: 9/21/2016 2:52:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lkup_exceptions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[lkup_exceptions](
	[err_cd] [numeric](15, 0) NOT NULL,
	[exception_descn] [varchar](25) NOT NULL,
	[exception_comment] [varchar](400) NULL,
	[user_intrfc_sort_ord] [numeric](4, 0) NULL,
	[rec_creat_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_creat_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
	[rec_updt_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_updt_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
 CONSTRAINT [pk_LKUP_EXCEPTIONS] PRIMARY KEY CLUSTERED 
(
	[err_cd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_PADDING OFF
GO
