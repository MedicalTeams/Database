USE [Clinic]
GO
/****** Object:  Trigger [trg_UpdateOV]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trg_UpdateOV]'))
DROP TRIGGER [dbo].[trg_UpdateOV]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_78]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov]'))
ALTER TABLE [dbo].[ov] DROP CONSTRAINT [r_78]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_76]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov]'))
ALTER TABLE [dbo].[ov] DROP CONSTRAINT [r_76]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_75]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov]'))
ALTER TABLE [dbo].[ov] DROP CONSTRAINT [r_75]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_100]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov]'))
ALTER TABLE [dbo].[ov] DROP CONSTRAINT [r_100]
GO
/****** Object:  Table [dbo].[ov]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ov]') AND type in (N'U'))
DROP TABLE [dbo].[ov]
GO
/****** Object:  Table [dbo].[ov]    Script Date: 9/21/2016 2:52:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ov]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ov](
	[faclty_id] [numeric](15, 0) NOT NULL,
	[gndr_id] [numeric](15, 0) NOT NULL,
	[bnfcry_id] [numeric](15, 0) NOT NULL,
	[opd_id] [numeric](15, 0) NOT NULL,
	[ov_id] [numeric](15, 0) IDENTITY(1,1) NOT NULL,
	[faclty_hw_invtry_id] [numeric](15, 0) NOT NULL,
	[dt_of_visit] [datetime] NOT NULL,
	[staff_mbr_name] [nvarchar](100) NOT NULL,
	[refl_in_ind] [varchar](1) NULL DEFAULT ('N'),
	[refl_out_ind] [varchar](1) NULL DEFAULT ('N'),
	[age_years_low] [numeric](6, 3) NOT NULL,
	[rvisit_id] [numeric](15, 0) NOT NULL,
	[rec_creat_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_creat_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
	[rec_updt_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_updt_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
	[age_years_high] [numeric](6, 3) NULL,
 CONSTRAINT [pk_OV_ID] PRIMARY KEY NONCLUSTERED 
(
	[ov_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_100]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov]'))
ALTER TABLE [dbo].[ov]  WITH CHECK ADD  CONSTRAINT [r_100] FOREIGN KEY([faclty_hw_invtry_id])
REFERENCES [dbo].[faclty_hw_invtry] ([faclty_hw_invtry_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_100]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov]'))
ALTER TABLE [dbo].[ov] CHECK CONSTRAINT [r_100]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_75]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov]'))
ALTER TABLE [dbo].[ov]  WITH CHECK ADD  CONSTRAINT [r_75] FOREIGN KEY([faclty_id])
REFERENCES [dbo].[lkup_faclty] ([faclty_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_75]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov]'))
ALTER TABLE [dbo].[ov] CHECK CONSTRAINT [r_75]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_76]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov]'))
ALTER TABLE [dbo].[ov]  WITH CHECK ADD  CONSTRAINT [r_76] FOREIGN KEY([gndr_id])
REFERENCES [dbo].[lkup_gndr] ([gndr_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_76]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov]'))
ALTER TABLE [dbo].[ov] CHECK CONSTRAINT [r_76]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_78]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov]'))
ALTER TABLE [dbo].[ov]  WITH CHECK ADD  CONSTRAINT [r_78] FOREIGN KEY([bnfcry_id])
REFERENCES [dbo].[lkup_bnfcry] ([bnfcry_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_78]') AND parent_object_id = OBJECT_ID(N'[dbo].[ov]'))
ALTER TABLE [dbo].[ov] CHECK CONSTRAINT [r_78]
GO
/****** Object:  Trigger [dbo].[trg_UpdateOV]    Script Date: 9/21/2016 2:52:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trg_UpdateOV]'))
EXEC dbo.sp_executesql @statement = N'
CREATE TRIGGER [dbo].[trg_UpdateOV]
ON [Clinic].[dbo].[ov]
AFTER UPDATE
AS
UPDATE Clinic.dbo.ov
set rec_updt_dt = getutcdate(),
rec_updt_user_id_cd = suser_name()
WHERE ov_id IN (SELECT DISTINCT ov_id FROM Inserted)

' 
GO
