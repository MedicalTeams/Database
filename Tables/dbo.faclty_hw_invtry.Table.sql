USE [Clinic]
GO
/****** Object:  Trigger [trg_UpdateFacHW]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trg_UpdateFacHW]'))
DROP TRIGGER [dbo].[trg_UpdateFacHW]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_83]') AND parent_object_id = OBJECT_ID(N'[dbo].[faclty_hw_invtry]'))
ALTER TABLE [dbo].[faclty_hw_invtry] DROP CONSTRAINT [r_83]
GO
/****** Object:  Table [dbo].[faclty_hw_invtry]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[faclty_hw_invtry]') AND type in (N'U'))
DROP TABLE [dbo].[faclty_hw_invtry]
GO
/****** Object:  Table [dbo].[faclty_hw_invtry]    Script Date: 9/21/2016 2:52:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[faclty_hw_invtry]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[faclty_hw_invtry](
	[faclty_hw_invtry_id] [numeric](15, 0) IDENTITY(1,1) NOT NULL,
	[faclty_id] [numeric](15, 0) NOT NULL,
	[itm_descn] [varchar](100) NOT NULL,
	[mac_addr] [varchar](100) NULL,
	[aplctn_vrsn] [varchar](25) NULL,
	[hw_stat] [varchar](1) NULL CONSTRAINT [hw_stat_const]  DEFAULT ('A'),
	[rec_creat_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_creat_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
	[rec_updt_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_updt_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
 CONSTRAINT [pk_FACLTY_HW_INVTRY] PRIMARY KEY NONCLUSTERED 
(
	[faclty_hw_invtry_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_83]') AND parent_object_id = OBJECT_ID(N'[dbo].[faclty_hw_invtry]'))
ALTER TABLE [dbo].[faclty_hw_invtry]  WITH CHECK ADD  CONSTRAINT [r_83] FOREIGN KEY([faclty_id])
REFERENCES [dbo].[lkup_faclty] ([faclty_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[r_83]') AND parent_object_id = OBJECT_ID(N'[dbo].[faclty_hw_invtry]'))
ALTER TABLE [dbo].[faclty_hw_invtry] CHECK CONSTRAINT [r_83]
GO
/****** Object:  Trigger [dbo].[trg_UpdateFacHW]    Script Date: 9/21/2016 2:52:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trg_UpdateFacHW]'))
EXEC dbo.sp_executesql @statement = N'
CREATE TRIGGER [dbo].[trg_UpdateFacHW]
ON [Clinic].[dbo].[faclty_hw_invtry]
AFTER UPDATE
AS
UPDATE Clinic.dbo.faclty_hw_invtry
set rec_updt_dt = getutcdate(),
rec_updt_user_id_cd = suser_name()
WHERE faclty_hw_invtry_id IN (SELECT DISTINCT faclty_hw_invtry_id FROM Inserted)

' 
GO
