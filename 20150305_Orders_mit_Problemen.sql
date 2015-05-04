SELECT count ( distinct No_)
FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Sales Header]
Where [Fulfillment Comment] != 'Bestandsproblem' 
AND [Reason Code] in ('WINDELN_DE','WINDELN_CH') 
AND [Payment Method Code] != 'VORKASSE' 
AND [Document Type] = 1


SELECT  distinct No_, [Order Date], [External Document No_]
FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Sales Header]
Where [Fulfillment Comment] <> 'Bestandsproblem' 
  AND [Reason Code] in ('WINDELN_DE','WINDELN_CH') 
  AND [Payment Method Code] <> 'VORKASSE' 
  AND [Document Type] = 1