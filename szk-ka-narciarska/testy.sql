select 
	dg.id_klienta,
	dg.id_grupy,
	k.data_urodz 
from 
	dzieci_grupy dg 
	join klienci k on k.id_klienta = dg.id_klienta 
order by 
	dg.id_grupy,
	k.data_urodz ;

select 
	*
from 
	grupy g 
	natural join dzieci_grupy dg 
	natural join klienci k 
	natural left join dzieci_odznaki do2
where 
	g.id_grupy = 6;


select 
	g.id_grupy,
	concat(count(do2.data_uzysk), ' / ', count(*)) as "ukończyło"
from 
	grupy g 
	natural join dzieci_grupy dg 
	natural join klienci k 
	natural left join dzieci_odznaki do2
group by 
	g.id_grupy
order by 
	g.id_grupy ;