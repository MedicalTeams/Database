USE [Clinic]
GO
/****** Object:  Table [dbo].[tmp_visit_to_proc]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tmp_visit_to_proc]') AND type in (N'U'))
DROP TABLE [dbo].[tmp_visit_to_proc]
GO
/****** Object:  Table [dbo].[tmp_visit_to_proc]    Script Date: 9/21/2016 2:52:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tmp_visit_to_proc]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tmp_visit_to_proc](
	[visit_uuid] [nvarchar](100) NOT NULL,
	[bnfcry_id] [numeric](15, 0) NOT NULL,
	[faclty_id] [numeric](15, 0) NOT NULL,
	[faclty_hw_invtry_id] [numeric](15, 0) NOT NULL,
	[gndr_id] [numeric](15, 0) NOT NULL,
	[splmtl_diag_cat_id] [numeric](15, 0) NULL,
	[rvisit_id] [numeric](15, 0) NOT NULL,
	[opd_id] [numeric](15, 0) NULL,
	[age_years_low] [numeric](6, 3) NOT NULL,
	[staff_mbr_name] [varchar](100) NOT NULL,
	[cntct_trmnt_cnt] [numeric](15, 0) NULL,
	[dt_of_visit] [datetime] NOT NULL,
	[diag_id] [numeric](15, 0) NOT NULL,
	[splmtl_diag_id] [numeric](15, 0) NULL,
	[oth_diag_descn] [varchar](100) NULL,
	[oth_splmtl_diag_descn] [varchar](100) NULL,
	[proc_stat] [varchar](1) NOT NULL DEFAULT ('N'),
	[err_cd] [int] NULL,
	[rec_creat_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_creat_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
	[rec_updt_dt] [datetime] NOT NULL DEFAULT (getutcdate()),
	[rec_updt_user_id_cd] [varchar](20) NOT NULL DEFAULT (suser_name()),
	[visit_to_proc_id] [numeric](15, 0) IDENTITY(1,1) NOT NULL,
	[age_years_high] [numeric](6, 3) NULL,
 CONSTRAINT [pk_visit_to_proc_id] PRIMARY KEY CLUSTERED 
(
	[visit_to_proc_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
SET ANSI_PADDING OFF
GO
