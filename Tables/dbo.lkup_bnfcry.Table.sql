USE [Clinic]
GO
/****** Object:  Trigger [trg_UpdateBnfcry]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trg_UpdateBnfcry]'))
DROP TRIGGER [dbo].[trg_UpdateBnfcry]
GO
/****** Object:  Table [dbo].[lkup_bnfcry]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lkup_bnfcry]') AND type in (N'U'))
DROP TABLE [dbo].[lkup_bnfcry]
GO
/****** Object:  Table [dbo].[lkup_bnfcry]    Script Date: 9/21/2016 2:52:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lkup_bnfcry]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[lkup_bnfcry](
	[bnfcry_id] [numeric](15, 0) IDENTITY(1,1) NOT NULL,
	[bnfcry] [varchar](10) NOT NULL,
	[user_intrfc_sort_ord] [numeric](4, 0) NULL,
	[rec_creat_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_creat_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
	[rec_updt_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_updt_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
 CONSTRAINT [pk_LKUP_BNFCRY] PRIMARY KEY NONCLUSTERED 
(
	[bnfcry_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Trigger [dbo].[trg_UpdateBnfcry]    Script Date: 9/21/2016 2:52:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trg_UpdateBnfcry]'))
EXEC dbo.sp_executesql @statement = N'
CREATE TRIGGER [dbo].[trg_UpdateBnfcry]
ON [Clinic].[dbo].[lkup_bnfcry]
AFTER UPDATE
AS
UPDATE Clinic.dbo.lkpup_bnfcry
set rec_updt_dt = getutcdate(),
rec_updt_user_id_cd = suser_name()
WHERE bnfcry_id IN (SELECT DISTINCT bnfcry_id FROM Inserted)

' 
GO
