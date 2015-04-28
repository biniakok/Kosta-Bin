with
 trans_nav as 
 (
 select
 cdh.[Order Created at] as Webshop_Auftrag
 , BI_Data.dbo.ToUTCDate(nvws.[Sales Document rendered at]) as Verkaufsbeleg_erstellt
, nvws.[No_] as Verkaufsrechnung
, nvws.[Sales Document No_] as AuftragsNr
, cdh.[ExternalDocumentNo] as Externe_BelegNr
, cdh.[FraudInfo] as Betrugsfall
,cdh.[Wait] as Warteliste
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$CreateDocumentHeader] cdh with (nolock)                                
	left join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesHeader] nvws with (nolock)
	 on cdh.[ExternalDocumentNo]=nvws.[External Document No_] collate Latin1_General_CI_AS
  where  nvws.[Shop Code]='WINDELN_DE'

  and nvws.[Sales Document rendered at] between '2014-10-01' and '2014-12-31' 
 
  ),
  trans_fiege as 
  (
    Select 
   BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) as Übergabe_Fiege
   ,ffsh.[No_] as AuftragsNr
   ,ffsl.[No_] as ArtikelNr
   ,ffsh.[External Document No_]
   ,ffsh.[Payment Method Code] as Zahlungsmethode
   ,ffsh.[Ship-to Country_Region Code] as LänderCode
   ,cr.[Name]as Name
   ,ffsh.[Ship-to Post Code] as PLZ
   FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] ffsh with (nolock)
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFProtocol] ffp with (nolock)
		on ffsh.[File No_]=ffp.[File No_] collate Latin1_General_CI_AS
		join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesLine] ffsl  
	    on (ffsh.[No_]=ffsl.[Document No_]
		and ffsh.[Entry No_]=ffsl.[Document Entry No_]) 
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Country_Region] cr with (nolock)
		on cr.[Code]=ffsh.[Ship-to Country_Region Code]
	where ffsh.[Location Code]='BER_FIEGE'
	and BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) between '2014-10-01' and '2014-12-31' 
	and ffsh.[Type]=0
	and ffsh.[Entry No_]=1
	and ffsl.[Type]=2
	),
	empfang_fiege as
	(
	 Select 
   BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) as Rückmeldung_Fiege
   , ffsh.[No_] as AuftragsNr
   , ffsh.[External Document No_]
     FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] ffsh with (nolock)
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFProtocol] ffp with (nolock)
		on ffsh.[File No_]=ffp.[File No_] collate Latin1_General_CI_AS
	where ffsh.[Location Code]='BER_FIEGE'
	and BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) between '2014-10-01' and '2014-12-31' 
	and ffsh.[Type]=1
	),
	
	DHL_Kunde as
(
select pst.[TrackingID] as Sendungsnummer
		, pst.[OrderID] as AuftragsNr
		, pst.[OrderTimestamp] 
		, case 
			when (pst.[KnownToPostalServiceTimestamp] > pst.[PostalServiceTimestamp] or pst.[KnownToPostalServiceTimestamp] is Null)  then pst.[PostalServiceTimestamp]
			else pst.[KnownToPostalServiceTimestamp] end as DHL_Eingang
 , pst.[DeliveryTimestamp] as Auftrag_Kunde
 FROM [BI_Data].[dbo].[PostalServiceTracking] pst  with (nolock)
 where pst.[OrderTimestamp] between '2014-10-01' and '2014-12-31' 
 and pst.[DeliveryTimestamp] between '2014-10-01' and '2014-12-31' 
)

	Select
	tn.Externe_BelegNr 
	,tf.[AuftragsNr]
	
	,DHL_Kunde.Sendungsnummer
	,tf.[ArtikelNr]
	,case
		when tf.[ArtikelNr]  in (
							 Select 
								distinct [EAN] collate Latin1_General_CI_AS as ArtikelNr 
								 FROM [BI_Data].[dbo].[OPS_Fiege_Morphologie]
								 where (([Hoehe]>1200 or ([Laenge]>600 and [Breite]>600)) or [Volumen_L]>128)
								) then 1 else 0 end as Big_Item_oder_Sperrgut
	,tf.[Zahlungsmethode]
	,tn.[Betrugsfall]
	,tn.[Warteliste]
	,tf.[LänderCode]
	,tf.[Name]
	,tf.[PLZ]
	,tn.[Webshop_Auftrag]
	,tf.[Übergabe_Fiege]
	,ef.[Rückmeldung_Fiege]
	,DHL_Kunde.[DHL_Eingang]
	,DHL_Kunde.[Auftrag_Kunde]
    ,cast(datediff(hour, tn.[Webshop_Auftrag],tf.[Übergabe_Fiege] ) as Numeric)/24 Gesamtzeit_Webshop_Fiege_Tag
	,cast(datediff(hour, tf.[Übergabe_Fiege], DHL_Kunde.[DHL_Eingang]) as Numeric)/24 as Gesamtzeit_Fiege_DHL_Tag
	,cast(datediff(hour, DHL_Kunde.[DHL_Eingang], DHL_Kunde.[Auftrag_Kunde]) as Numeric)/24 as Gesamtzeit_DHL_Kunde_Tag
	,cast(datediff(hour, tn.[Webshop_Auftrag], DHL_Kunde.[Auftrag_Kunde]) as Numeric)/24 Gesamtzeit_Webshop_Kunde_Tag
	

	from trans_nav tn with (nolock)
	left join trans_fiege tf with (nolock)
		on tn.[Externe_BelegNr]=tf.[External Document No_] collate Latin1_General_CI_AS
	join empfang_fiege ef with (nolock)
		on  tf.[AuftragsNr]=ef.[AuftragsNr] collate Latin1_General_CI_AS
	join DHL_Kunde DHL_Kunde with (nolock)
		on DHL_Kunde.[AuftragsNr]=ef.[AuftragsNr] collate Latin1_General_CI_AS
	
	where tn.[Webshop_Auftrag] between '2014-10-01' and '2014-12-31'
	 
 -- group by tn.Externe_BelegNr 
	--,tf.[AuftragsNr]
	--,DHL_Kunde.Sendungsnummer
	--,tf.[Zahlungsmethode]
	--,tf.[LänderCode]
	--,tf.[Name]
	--,tf.[PLZ]
	--,tn.[Webshop_Auftrag]
	--,tf.[Übergabe_Fiege]
	--,ef.[Rückmeldung_Fiege]
	--,DHL_Kunde.[DHL_Eingang]
	--,DHL_Kunde.[Auftrag_Kunde]
	--,tn.[Betrugsfall]
	----,tf.[ArtikelNr]