SELECT count(pl.No_),st.Klasse,ph.[Purchaser Code]
  FROM [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Purchase Line] as pl with (NOLOCK)
  Left join [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Purchase Header] as ph with (NOLOCK)
  on ph.[Buy-from Vendor No_]  = pl.[Buy-from Vendor No_]
  left Join  [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Stockkeeping Unit] as st with (NOLOCK)
  on pl.No_ = st.[Item No_] and pl.[Location Code] = st.[Location Code]

  Where pl.[Posting Group] = 'HANDEL' and ph.[Vendor Posting Group] <> 'INTERN'
  and pl.[Expected Receipt Date] < GETDATE() - 5 and left(pl.[Document No_],4) = 'BEST'
  and pl.[Outstanding Quantity] <> 0
  group by st.Klasse,ph.[Purchaser Code]
  Order by ph.[Purchaser Code]


  SELECT pl.No_, pl.[Document No_],ph.[Buy-from Vendor Name], ph.[Purchaser Code],pl.[Location Code],pl.[Buy-from Vendor No_], cast(pl.[Expected Receipt Date] as Date) , 
 cast(pl.Quantity as int), cast(pl.[Quantity Received] as int), cast(pl.[Outstanding Quantity] as int), datediff(day,pl.[Expected Receipt Date] ,Getdate()) as TageOverdue,
 st.Klasse
  FROM [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Purchase Line] as pl with (NOLOCK)
  Left join [urban_NAV600_Sl].[dbo].[Urban-Brand GmbH$Purchase Header] as ph with (NOLOCK)
  on ph.[Buy-from Vendor No_]  = pl.[Buy-from Vendor No_]
  Left Join [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Stockkeeping Unit] as st with (NOLOCK)
  on st.[Item No_] = pl.No_ and st.[Location Code] = pl.[Location Code]

  Where pl.[Posting Group] = 'HANDEL' and ph.[Vendor Posting Group] <> 'INTERN'
  and pl.[Expected Receipt Date] < GETDATE() - 5 and left(pl.[Document No_],4) = 'BEST'
  and pl.[Outstanding Quantity] <> 0
  and ph.[Purchaser Code] = 'FK'
and st.Klasse = 'C'
  order by datediff(day,pl.[Expected Receipt Date] ,Getdate()) desc