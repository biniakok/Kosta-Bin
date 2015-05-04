with
warteliste as
 ( Select
  cast(cdh.[OrderDate] as date) as Datum
 --,cdh.[Payment_AccountNo] as KundenNr
 --, cdh.[ExternalDocumentNo] as Ext_Belegnummer
  --,cdh.[Wait] as Warteliste
 ,case when cua.[TypeId]=4 then 1 else 0 end as Kundengruppe4
 ,case when cua.[TypeId]=1 then 1 else 0 end as Kundengruppe1
  from [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$CreateDocumentHeader] cdh
  left join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Create_UpdateAccount] cua
	on cdh.[Account Entry No_]=cua.[Entry No_] 
  where cast(cdh.[OrderDate] as date)>='2014-11-01'
  and cast(cdh.[OrderDate] as date)<='2015-02-28'
  and cdh.[Wait]=1
  and cdh.[Shop Code]='WINDELN_DE'
  --and cdh.[FraudInfo]<>''
  group by cast(cdh.[OrderDate] as date), cua.[TypeId],cdh.[Payment_AccountNo], cdh.[ExternalDocumentNo]
    )
  Select warteliste.Datum
  ,sum(warteliste.Kundengruppe1) as Summe_Kundengruppe1
  ,sum(warteliste.Kundengruppe4) as Summe_Kundengruppe4
  ,sum(warteliste.Kundengruppe1)+sum(warteliste.Kundengruppe4) as Gesamt
  ,cast(1.00*sum(warteliste.Kundengruppe1)/(sum(warteliste.Kundengruppe1)+sum(warteliste.Kundengruppe4))*100 as decimal (10,2)) as proz_KG1
  ,cast(1.00*sum(warteliste.Kundengruppe4)/(sum(warteliste.Kundengruppe1)+sum(warteliste.Kundengruppe4))*100 as decimal(10,2)) as proz_KG4
  from warteliste
 group by warteliste.Datum
  order by warteliste.Datum