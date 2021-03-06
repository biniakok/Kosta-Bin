/****** Skript für SelectTopNRows-Befehl aus SSMS ******/
with
teilgeliefert as
(
SELECT
distinct [No_] as AuftragsNr
,[External Document No_] as Ext_Belegnummer
,[Type] as Typ
,case
	when [Type]=0 then 'Meldung'
	when [Type]=1 then 'Rückmeldung'
	when [Type]=2 then 'Storno'
	when [Type]=3 then 'Reklamation'
	when [Type]=4 then 'Storno Rückmeldung' end as Beschreibung
,[Processing Status] as Prozess_Status
,[Status Fulfillment] as Status_Fulfillment
,max([Entry No_]) as Max_Eintrag	
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader]
  where [Location Code]='BER_FIEGE'
  --and max([Entry No_])
  --and [Processing Status]=0 /*Status Öffnen*/
  group by [No_],[External Document No_],[Type],[Processing Status],[Entry No_],[Status Fulfillment] 
)
Select 
teilgeliefert.AuftragsNr
,teilgeliefert.Ext_Belegnummer
from teilgeliefert
where teilgeliefert.Beschreibung='Rückmeldung'
--and teilgeliefert.Max_Eintrag>2
and teilgeliefert.Prozess_Status=0
and teilgeliefert.Status_Fulfillment=3
  
  
 