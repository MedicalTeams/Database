USE [Clinic]
GO
/****** Object:  Trigger [trg_UpdateOVDiag]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trg_UpdateOVDiag]'))
DROP TRIGGER [dbo].[trg_UpdateOVDiag]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_92]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov_diag]'))
ALTER TABLE [dbo].[ov_diag] DROP CONSTRAINT [r_92]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_91]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov_diag]'))
ALTER TABLE [dbo].[ov_diag] DROP CONSTRAINT [r_91]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_79]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov_diag]'))
ALTER TABLE [dbo].[ov_diag] DROP CONSTRAINT [r_79]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_101]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov_diag]'))
ALTER TABLE [dbo].[ov_diag] DROP CONSTRAINT [r_101]
GO
/****** Object:  Table [dbo].[ov_diag]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ov_diag]') AND type in (N'U'))
DROP TABLE [dbo].[ov_diag]
GO
/****** Object:  Table [dbo].[ov_diag]    Script Date: 9/21/2016 2:52:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ov_diag]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ov_diag](
	[ov_diag_id] [numeric](15, 0) IDENTITY(1,1) NOT NULL,
	[ov_id] [numeric](15, 0) NOT NULL,
	[splmtl_diag_id] [numeric](15, 0) NULL,
	[diag_id] [numeric](15, 0) NOT NULL,
	[cntct_trmnt_cnt] [numeric](4, 0) NULL,
	[splmtl_diag_cat_id] [numeric](15, 0) NULL,
	[oth_diag_descn] [nvarchar](100) NULL,
	[oth_splmtl_diag_descn] [nvarchar](100) NULL,
	[rec_creat_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_creat_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
	[rec_updt_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_updt_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
 CONSTRAINT [pk_OV_DIAG_ID] PRIMARY KEY NONCLUSTERED 
(
	[ov_diag_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
 CONSTRAINT [xak1office_visit_diagnosis] UNIQUE NONCLUSTERED 
(
	[diag_id] ASC,
	[ov_diag_id] ASC,
	[ov_id] ASC,
	[splmtl_diag_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_101]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov_diag]'))
ALTER TABLE [dbo].[ov_diag]  WITH CHECK ADD  CONSTRAINT [r_101] FOREIGN KEY([splmtl_diag_cat_id])
REFERENCES [dbo].[lkup_splmtl_diag_cat] ([splmtl_diag_cat_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_101]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov_diag]'))
ALTER TABLE [dbo].[ov_diag] CHECK CONSTRAINT [r_101]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_79]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov_diag]'))
ALTER TABLE [dbo].[ov_diag]  WITH CHECK ADD  CONSTRAINT [r_79] FOREIGN KEY([ov_id])
REFERENCES [dbo].[ov] ([ov_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_79]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov_diag]'))
ALTER TABLE [dbo].[ov_diag] CHECK CONSTRAINT [r_79]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_91]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov_diag]'))
ALTER TABLE [dbo].[ov_diag]  WITH CHECK ADD  CONSTRAINT [r_91] FOREIGN KEY([splmtl_diag_id])
REFERENCES [dbo].[lkup_splmtl_diag] ([splmtl_diag_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_91]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov_diag]'))
ALTER TABLE [dbo].[ov_diag] CHECK CONSTRAINT [r_91]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_92]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov_diag]'))
ALTER TABLE [dbo].[ov_diag]  WITH CHECK ADD  CONSTRAINT [r_92] FOREIGN KEY([diag_id])
REFERENCES [dbo].[lkup_diag] ([diag_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_92]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov_diag]'))
ALTER TABLE [dbo].[ov_diag] CHECK CONSTRAINT [r_92]
GO
/****** Object:  Trigger [dbo].[trg_UpdateOVDiag]    Script Date: 9/21/2016 2:52:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trg_UpdateOVDiag]'))
EXEC dbo.sp_executesql @statement = N'

CREATE TRIGGER [dbo].[trg_UpdateOVDiag]
ON [Clinic].[dbo].[ov_diag]
AFTER UPDATE
AS
UPDATE Clinic.dbo.ov_diag
set rec_updt_dt = getutcdate(),
rec_updt_user_id_cd = suser_name()
WHERE ov_diag_id IN (SELECT DISTINCT ov_diag_id FROM Inserted)

' 
GO
