USE [Clinic]
GO
/****** Object:  Trigger [trg_UpdateDiag]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trg_UpdateDiag]'))
DROP TRIGGER [dbo].[trg_UpdateDiag]
GO
/****** Object:  Table [dbo].[lkup_diag]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lkup_diag]') AND type in (N'U'))
DROP TABLE [dbo].[lkup_diag]
GO
/****** Object:  Table [dbo].[lkup_diag]    Script Date: 9/21/2016 2:52:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lkup_diag]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[lkup_diag](
	[diag_id] [numeric](15, 0) IDENTITY(1,1) NOT NULL,
	[diag_descn] [nvarchar](100) NOT NULL,
	[icd_cd] [nvarchar](10) NULL,
	[diag_abrvn] [nvarchar](10) NULL,
	[user_intrfc_sort_ord] [numeric](4, 0) NULL,
	[diag_stat] [varchar](1) NOT NULL DEFAULT ('A'),
	[diag_strt_eff_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[diag_end_eff_dt] [datetime] NOT NULL DEFAULT ('12/31/9999'),
	[rec_creat_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_creat_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
	[rec_updt_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_updt_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
 CONSTRAINT [pk_LKUP_DIAG] PRIMARY KEY NONCLUSTERED 
(
	[diag_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Trigger [dbo].[trg_UpdateDiag]    Script Date: 9/21/2016 2:52:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trg_UpdateDiag]'))
EXEC dbo.sp_executesql @statement = N'
CREATE TRIGGER [dbo].[trg_UpdateDiag]
ON [Clinic].[dbo].[lkup_diag]
AFTER UPDATE
AS
UPDATE Clinic.dbo.lkup_diag
set rec_updt_dt = getutcdate(),
rec_updt_user_id_cd = suser_name()
WHERE diag_id IN (SELECT DISTINCT diag_id FROM Inserted)

' 
GO
