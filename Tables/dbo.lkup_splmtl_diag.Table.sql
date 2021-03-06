USE [Clinic]
GO
/****** Object:  Trigger [trg_UpdateSplmtlDiag]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trg_UpdateSplmtlDiag]'))
DROP TRIGGER [dbo].[trg_UpdateSplmtlDiag]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_65]') AND parent_object_id = OBJECT_ID(N'[dbo].[lkup_splmtl_diag]'))
ALTER TABLE [dbo].[lkup_splmtl_diag] DROP CONSTRAINT [r_65]
GO
/****** Object:  Table [dbo].[lkup_splmtl_diag]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lkup_splmtl_diag]') AND type in (N'U'))
DROP TABLE [dbo].[lkup_splmtl_diag]
GO
/****** Object:  Table [dbo].[lkup_splmtl_diag]    Script Date: 9/21/2016 2:52:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lkup_splmtl_diag]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[lkup_splmtl_diag](
	[splmtl_diag_id] [numeric](15, 0) IDENTITY(1,1) NOT NULL,
	[splmtl_diag_descn] [varchar](100) NOT NULL,
	[diag_id] [numeric](15, 0) NOT NULL,
	[user_intrfc_sort_ord] [numeric](4, 0) NULL,
	[splmtl_diag_stat] [varchar](1) NOT NULL DEFAULT ('A'),
	[splmtl_diag_strt_eff_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[splmtl_diag_end_eff_dt] [datetime] NOT NULL DEFAULT ('12/31/9999'),
	[rec_creat_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_creat_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
	[rec_updt_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_updt_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
 CONSTRAINT [pk_LKUP_SPLMTL_DIAG] PRIMARY KEY NONCLUSTERED 
(
	[splmtl_diag_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
 CONSTRAINT [xak1lookup_supplemental_diagnosis] UNIQUE NONCLUSTERED 
(
	[splmtl_diag_descn] ASC,
	[diag_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_65]') AND parent_object_id = OBJECT_ID(N'[dbo].[lkup_splmtl_diag]'))
ALTER TABLE [dbo].[lkup_splmtl_diag]  WITH CHECK ADD  CONSTRAINT [r_65] FOREIGN KEY([diag_id])
REFERENCES [dbo].[lkup_diag] ([diag_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_65]') AND parent_object_id = OBJECT_ID(N'[dbo].[lkup_splmtl_diag]'))
ALTER TABLE [dbo].[lkup_splmtl_diag] CHECK CONSTRAINT [r_65]
GO
/****** Object:  Trigger [dbo].[trg_UpdateSplmtlDiag]    Script Date: 9/21/2016 2:52:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trg_UpdateSplmtlDiag]'))
EXEC dbo.sp_executesql @statement = N'

CREATE TRIGGER [dbo].[trg_UpdateSplmtlDiag]
ON [Clinic].[dbo].[lkup_splmtl_diag]
AFTER UPDATE
AS
UPDATE Clinic.dbo.lkup_splmtl_diag
set rec_updt_dt = getutcdate(),
rec_updt_user_id_cd = suser_name()
WHERE splmtl_diag_id IN (SELECT DISTINCT splmtl_diag_id FROM Inserted)

' 
GO
