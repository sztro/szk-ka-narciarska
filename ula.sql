create or replace function wyswietl_harmonogram(dzien date)
returns table (id_instruktora int, "9" varchar, "10" varchar, "11" varchar, "12" varchar, "13" varchar,  
    "14" varchar,  "15" varchar, "16" varchar, "17" varchar, "18" varchar, "19" varchar, "20" varchar
) as $$
begin
    return query
    select 
        i.imie || ' ' || i.nazwisko as "Instruktor",
        max(case when h.godz_od <= 8 and h.godz_do > 8 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then k.imie
                when h.id_grupy is not null then 'grupa ' 
            end 
        end) as "8",
        max(case when h.godz_od <= 9 and h.godz_do > 9 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then k.imie
                when h.id_grupy is not null then 'grupa ' 
            end 
        end) as "9",
        max(case when h.godz_od <= 10 and h.godz_do > 10 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then k.imie
                when h.id_grupy is not null then 'grupa ' 
            end 
        end) as "10",
        max(case when h.godz_od <= 11 and h.godz_do > 11 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then k.imie
                when h.id_grupy is not null then 'grupa ' 
            end 
        end) as "11",
        max(case when h.godz_od <= 12 and h.godz_do > 12 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then k.imie
                when h.id_grupy is not null then 'grupa '
            end 
        end) as "12",
        max(case when h.godz_od <= 13 and h.godz_do > 13 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then k.imie
                when h.id_grupy is not null then 'grupa ' 
            end 
        end) as "13",
        max(case when h.godz_od <= 14 and h.godz_do > 14 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then k.imie
                when h.id_grupy is not null then 'grupa ' 
            end 
        end) as "14",
        max(case when h.godz_od <= 15 and h.godz_do > 15 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then k.imie
                when h.id_grupy is not null then 'grupa ' 
            end 
        end) as "15",
        max(case when h.godz_od <= 16 and h.godz_do > 16 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then k.imie
                when h.id_grupy is not null then 'grupa ' 
            end 
        end) as "16",
        max(case when h.godz_od <= 17 and h.godz_do > 17 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then k.imie
                when h.id_grupy is not null then 'grupa ' 
            end 
        end) as "17",
        max(case when h.godz_od <= 18 and h.godz_do > 18 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then k.imie
                when h.id_grupy is not null then 'grupa ' 
            end 
        end) as "18",
        max(case when h.godz_od <= 19 and h.godz_do > 19 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then k.imie
                when h.id_grupy is not null then 'grupa ' 
            end 
        end) as "19",
        max(case when h.godz_od <= 20 and h.godz_do > 20 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then k.imie
                when h.id_grupy is not null then 'grupa '
            end 
        end) as "20"
    from harmonogram h
    join instruktorzy i on h.id_instruktora = i.id_instruktora 
    left join klienci k on k.id_klienta = h.id_klienta 
    where h."data" = dzien
    group by i.id_instruktora
    order by i.id_instruktora; 
end;
$$ language plpgsql;


create or replace function wyplata(instruktor int, dzien date)
	returns int as 
$$
declare 
	stawka int;
	l_godzin int;
begin 
	select max(s.stawka_godzinowa)
	into stawka 
	from instruktorzy i 
		join instruktorzy_stopnie si on si.id_instruktora = i.id_instruktora 
		join stopnie s on s.id_stopnia = si.id_stopnia 
	where i.id_instruktora = instruktor
	group by i.id_instruktora;
	select count(*)  
	into l_godzin
	from harmonogram h 
	where h.id_instruktora = instrukor
		and "data" = dzien
		and czy_nieobecnosc is false;
	return l_godzin * stawka;
end;
$$ language plpgsql;

create or replace function umow_dowolny(klient int, dzien date, h_od int, h_do int)
	returns bool as 
$$
declare
	id integer;
begin
	select h.id_instruktora into id
	from harmonogram h 
	join dostepnosc_sezon ds on h.id_instruktora = ds.id_instruktora 
	where h.id_instruktora not in (
		select id_instruktora 
		from harmonogram h 
		where "data" = dzien
			and h.godz_od <= h_od
			and h.godz_do >= h_do	
		)
		and ds.data_od <= dzien
		and ds.data_do >= dzien
		and h."data" = dzien
	group by h.id_instruktora 
	order by count(*)
	limit 1;
	if id is null then return false; end if;
	insert into harmonogram(pesel, lekarz) values
	(id, dzien, h_od, h_do, klient, NULL, false);
	return true;
end;
$$ language plpgsql;








