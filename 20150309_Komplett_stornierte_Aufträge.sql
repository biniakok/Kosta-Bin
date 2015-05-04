With inSystem as
(	Select [External Document No_]
from [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Sales Header] with (nolock)
	Union
	Select [External Document No_] 
	from [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Sales Invoice Header] with (nolock)
)
/****** Komplett Storniert ******/
Select  
COUNT(distinct esh.[External Document No_]) as StornierteAuftrage, 
sum (esl.Quantity * esl.[Unit Price Gross Amount]) as WertStornierung,
ch.FraudInfo,
ch.Wait,
ch.CouponInformation_CouponCode,
esh.[Shop Payment Method Code]

From [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesHeader] as esh with (nolock)

Left Join inSystem 
on esh.[External Document No_] = inSystem.[External Document No_]
Left join [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesLine] as esl with (nolock) 
on esh.No_ = esl.[Document No_]
left Join [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$CreateDocumentHeader] as ch with (nolock) 
on ch.ExternalDocumentNo = esh.[External Document No_]

Where inSystem.[External Document No_] IS NULL 
AND /* month(esh.[Order Date]) = 9 and */ year(esh.[Order Date]) = 2014
AND esh.[Shop Code] = 'WINDELN_DE'

group by esh.[Shop Code],ch.FraudInfo , esh.[Shop Payment Method Code],ch.Wait, ch.CouponInformation_CouponCode
order by sum (esl.Quantity * esl.[Unit Price Gross Amount]) desc




/* Übersicht*/

With inWait as
(Select csh.[External Document No_] as Auftrag	FROM  [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesHeader] as csh with (NOLOCK) Where csh.Status = '0'),
inSales as
(Select sh.[External Document No_] as Auftrag FROM  [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Sales Header] as sh with (NOLOCK) Where sh.[Document Type] = '1'),
inLog as
(Select sh2.[External Document No_] as Auftrag FROM  [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Sales Header] as sh2 with (NOLOCK) Where sh2.[Document Type] = '11'),
inSent as
(Select si.[External Document No_] as Auftrag FROM  [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Sales Invoice Header] as si with (NOLOCK)),
cancelled as
(
Select esh.[External Document No_]
From [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesHeader] as esh with (nolock)
Left Join (	Select [External Document No_]from [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Sales Header] with (nolock) 
Union
	Select [External Document No_] from [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Sales Invoice Header] with (nolock)
	)as uni 
	on esh.[External Document No_] = uni.[External Document No_]
Where uni.[External Document No_] IS NULL
)

Select ch.[Shop Code] 
,COUNT(ch.ExternalDocumentNo)as OI
,count(inWait.Auftrag) as Warten
,count(inSales.Auftrag) as WartenWare
,count(inLog.Auftrag) as Logistik
,count(inSent.Auftrag) as Versendet
,count(cancelled.[External Document No_]) as Storniert
From [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$CreateDocumentHeader] as ch with (NOLOCK)
Left Join inWait 
on inWait.Auftrag = ch.ExternalDocumentNo
Left Join inSales 
on inSales.Auftrag = ch.ExternalDocumentNo
Left Join inLog 
on inLog.Auftrag = ch.ExternalDocumentNo
Left Join inSent 
on inSent.Auftrag = ch.ExternalDocumentNo
left Join cancelled 
on cancelled.[External Document No_] = ch.ExternalDocumentNo
Where  ch.OrderDate between '2015-01-01' and '2015-01-31'
Group by ch.[Shop Code]