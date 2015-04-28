/*Teilgelieferte Auftr�ge V_2*/

with 
meldung as
(
 Select 
 distinct ffsh.[No_] as AuftragsNr
 ,count(distinct ffsl.[No_]) as Anzahl_EAN
 ,ffsh.[External Document No_] as Ext_Belegnummer
 ,ffsh.[Entry No_] as Eintrag
 --,ffsh.[Entry No_] as Eintrag

 FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] ffsh
 join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesLine] ffsl
  on (ffsh.[No_]=ffsl.[Document No_] and ffsh.[Entry No_]=ffsl.[Document Entry No_])
  where ffsh.[Location Code]='BER_FIEGE'
  and ffsh.[Type]=0 /*Meldung*/
  and ffsl.[Type]=2 /*Artikel*/
  and ffsh.[Entry No_]=1
  group by ffsh.[No_],ffsh.[External Document No_],ffsh.[Entry No_]
  --and ffsh.[Order Date]>='2014-01-01'
  --and ffsh.[Order Date]<=getdate()
  ),
  r�ckmeldung as
  (
  Select 
  distinct ffsh.[No_] as AuftragsNr
 ,count(distinct ffsl.[No_]) as Anzahl_EAN
 ,ffsh.[External Document No_] as Ext_Belegnummer
 ,ffsl.[Document Entry No_] as Eintrag
 --,ffsl.[Document Entry No_] as Eintrag


 FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] ffsh
 join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesLine] ffsl
  on (ffsh.[No_]=ffsl.[Document No_] and ffsh.[Entry No_]=ffsl.[Document Entry No_])
  where ffsh.[Location Code]='BER_FIEGE'
  and ffsh.[Type]=1 /*R�ckmeldung*/
  and ffsl.[Type]=2 /*Artikel*/
  --and ffsh.[Entry No_]>=2
  group by ffsh.[No_],ffsh.[External Document No_],ffsl.[Document Entry No_] 
 
)
Select
meldung.AuftragsNr
,meldung.Ext_Belegnummer
,meldung.Anzahl_EAN
,r�ckmeldung.Anzahl_EAN


from meldung
join r�ckmeldung
on meldung.AuftragsNr=r�ckmeldung.AuftragsNr
where r�ckmeldung.Anzahl_EAN<>meldung.Anzahl_EAN



