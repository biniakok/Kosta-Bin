


  SELECT
  it.[No_] as EAN
  ,it.[Description] as Beschreibung
  ,it.[Description 2] as Beschreibung2
  ,cast(it.[Unit Price] as decimal(10,2)) as VK_Preis
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item] it
  left join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$BOM Component] bc 
  on (it.[No_]=bc.[Parent Item No_] or it.[No_]=bc.[No_])
  where (it.[Unit Price] like '' or it.[Unit Price]=0)
  --and bc.[Parent Item No_] is null
  and it.[No_]<>''
  and bc.[No_] is null  
  
  
