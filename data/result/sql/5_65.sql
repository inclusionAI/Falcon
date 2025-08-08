with valuation_converted as(
select industry, company, cast(regexp_replace(valuation, '\\\$', '') as double) as valuation_num
  from ant_icube_dev.di_unicorn_startups
 where valuation is not null
   and valuation!= ''),
         industry_avg as(
select industry, avg(valuation_num) as avg_valuation
  from valuation_converted
 group by industry),
         filtered_companies as(
select v.industry, v.company, v.valuation_num
  from valuation_converted v
  inner join industry_avg a on v.industry= a.industry
 where v.valuation_num> a.avg_valuation),
       ranked_companies as(
select industry, company, valuation_num, row_number() over(partition by industry
 order by valuation_num desc) as rn
  from filtered_companies) 
select industry as `industry`,
       company as `company`,
       valuation_num as `valuation`
  from ranked_companies
 where rn<= 5;