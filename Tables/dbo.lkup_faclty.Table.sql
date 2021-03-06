USE [Clinic]
GO
/****** Object:  Trigger [trg_UpdateFaclty]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trg_UpdateFaclty]'))
DROP TRIGGER [dbo].[trg_UpdateFaclty]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_98]') AND parent_object_id = OBJECT_ID(N'[dbo].[lkup_faclty]'))
ALTER TABLE [dbo].[lkup_faclty] DROP CONSTRAINT [r_98]
GO
/****** Object:  Table [dbo].[lkup_faclty]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lkup_faclty]') AND type in (N'U'))
DROP TABLE [dbo].[lkup_faclty]
GO
/****** Object:  Table [dbo].[lkup_faclty]    Script Date: 9/21/2016 2:52:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lkup_faclty]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[lkup_faclty](
	[faclty_id] [numeric](15, 0) IDENTITY(1,1) NOT NULL,
	[hlth_care_faclty] [nvarchar](50) NOT NULL,
	[hlth_care_faclty_lvl] [varchar](5) NOT NULL,
	[hlth_coordtr] [nvarchar](50) NOT NULL,
	[setlmt] [nvarchar](50) NOT NULL,
	[cntry] [nvarchar](50) NOT NULL,
	[rgn] [nvarchar](50) NOT NULL,
	[orgzn_id] [numeric](15, 0) NOT NULL,
	[faclty_stat] [varchar](1) NOT NULL DEFAULT ('A'),
	[faclty_strt_eff_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[faclty_end_eff_dt] [datetime] NOT NULL DEFAULT ('12/31/9999'),
	[user_intrfc_sort_ord] [numeric](4, 0) NULL,
	[longtd] [numeric](10, 6) NULL,
	[lattd] [numeric](10, 6) NULL,
	[rec_creat_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_creat_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
	[rec_updt_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_updt_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
 CONSTRAINT [pk_LKUP_FACLTY] PRIMARY KEY NONCLUSTERED 
(
	[faclty_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_98]') AND parent_object_id = OBJECT_ID(N'[dbo].[lkup_faclty]'))
ALTER TABLE [dbo].[lkup_faclty]  WITH CHECK ADD  CONSTRAINT [r_98] FOREIGN KEY([orgzn_id])
REFERENCES [dbo].[lkup_orgzn] ([orgzn_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_98]') AND parent_object_id = OBJECT_ID(N'[dbo].[lkup_faclty]'))
ALTER TABLE [dbo].[lkup_faclty] CHECK CONSTRAINT [r_98]
GO
/****** Object:  Trigger [dbo].[trg_UpdateFaclty]    Script Date: 9/21/2016 2:52:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trg_UpdateFaclty]'))
EXEC dbo.sp_executesql @statement = N'
CREATE TRIGGER [dbo].[trg_UpdateFaclty]
ON [Clinic].[dbo].[lkup_faclty]
AFTER UPDATE
AS
UPDATE Clinic.dbo.lkup_faclty
set rec_updt_dt = getutcdate(),
rec_updt_user_id_cd = suser_name()
WHERE faclty_id IN (SELECT DISTINCT faclty_id FROM Inserted)

' 
GO
