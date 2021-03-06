USE [Clinic]
GO
/****** Object:  Trigger [trg_UpdateSplmtlDiagCat]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trg_UpdateSplmtlDiagCat]'))
DROP TRIGGER [dbo].[trg_UpdateSplmtlDiagCat]
GO
/****** Object:  Table [dbo].[lkup_splmtl_diag_cat]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lkup_splmtl_diag_cat]') AND type in (N'U'))
DROP TABLE [dbo].[lkup_splmtl_diag_cat]
GO
/****** Object:  Table [dbo].[lkup_splmtl_diag_cat]    Script Date: 9/21/2016 2:52:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lkup_splmtl_diag_cat]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[lkup_splmtl_diag_cat](
	[splmtl_diag_cat_id] [numeric](15, 0) IDENTITY(1,1) NOT NULL,
	[splmtl_diag_cat] [nvarchar](25) NOT NULL,
	[user_intrfc_sort_ord] [numeric](4, 0) NULL,
	[splmtl_diag_cat_stat] [varchar](1) NOT NULL DEFAULT ('A'),
	[splmtl_diag_cat_strt_eff_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[splmtl_diag_cat_end_eff_dt] [datetime] NOT NULL DEFAULT ('12/31/9999'),
	[rec_creat_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_creat_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
	[rec_updt_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_updt_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
 CONSTRAINT [pk_LKUP_SPLMTL_DIAG_CAT] PRIMARY KEY NONCLUSTERED 
(
	[splmtl_diag_cat_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Trigger [dbo].[trg_UpdateSplmtlDiagCat]    Script Date: 9/21/2016 2:52:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trg_UpdateSplmtlDiagCat]'))
EXEC dbo.sp_executesql @statement = N'
CREATE TRIGGER [dbo].[trg_UpdateSplmtlDiagCat]
ON [Clinic].[dbo].[lkup_splmtl_diag_cat]
AFTER UPDATE
AS
UPDATE Clinic.dbo.lkup_splmtl_diag_cat
set rec_updt_dt = getutcdate(),
rec_updt_user_id_cd = suser_name()
WHERE splmtl_diag_cat_id IN (SELECT DISTINCT splmtl_diag_cat_id FROM Inserted)

' 
GO
