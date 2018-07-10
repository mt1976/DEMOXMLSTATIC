USE [ReportingDb-demo-sys-3]
GO

/****** Object:  View [dbo].[vwDealTypeGroupHelper]    Script Date: 10/07/2018 09:36:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwDealTypeGroupHelper]
AS
SELECT        RG.DealTypeGroup.DealTypeGroupKeyDealType, RG.DealTypeGroup.DealTypeGroupKeyDealTypeGroupId, RG.Deals.*
FROM            RG.Deals LEFT OUTER JOIN
                         RG.DealTypeGroup ON RG.Deals.FullDealType = RG.DealTypeGroup.DealTypeGroupKeyDealType
GO
