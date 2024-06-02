drop function wyswietl_harmonogram(dzien date);

create or replace function wyswietl_harmonogram(dzien date)
returns table (Instrukor varchar(61), "9" text, "10" text, "11" text, "12" text, "13" text,  
    "14" text,  "15" text, "16" text, "17" text, "18" text, "19" text, "20" text
) as $$
begin
    return query
    select 
        cast(i.imie || ' ' || i.nazwisko AS varchar(61)) as "Instruktor",
        max(case when h.godz_od <= 9 and h.godz_do > 9 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then substring(s.opis, 1, 1) || ' ' || k.imie
                when h.id_grupy is not null then substring(s.opis, 1, 1) || ' ' || 'grupa' 
            end 
        end) as "9",
        max(case when h.godz_od <= 10 and h.godz_do > 10 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then substring(s.opis, 1, 1) || ' ' || k.imie
                when h.id_grupy is not null then substring(s.opis, 1, 1) || ' ' || 'grupa'  
            end 
        end) as "10",
        max(case when h.godz_od <= 11 and h.godz_do > 11 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then substring(s.opis, 1, 1) || ' ' || k.imie
                when h.id_grupy is not null then substring(s.opis, 1, 1) || ' ' || 'grupa'  
            end 
        end) as "11",
        max(case when h.godz_od <= 12 and h.godz_do > 12 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then substring(s.opis, 1, 1) || ' ' || k.imie
                when h.id_grupy is not null then substring(s.opis, 1, 1) || ' ' || 'grupa' 
            end 
        end) as "12",
        max(case when h.godz_od <= 13 and h.godz_do > 13 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then substring(s.opis, 1, 1) || ' ' || k.imie
                when h.id_grupy is not null then substring(s.opis, 1, 1) || ' ' || 'grupa'  
            end 
        end) as "13",
        max(case when h.godz_od <= 14 and h.godz_do > 14 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then substring(s.opis, 1, 1) || ' ' || k.imie
                when h.id_grupy is not null then substring(s.opis, 1, 1) || ' ' || 'grupa'  
            end 
        end) as "14",
        max(case when h.godz_od <= 15 and h.godz_do > 15 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then substring(s.opis, 1, 1) || ' ' || k.imie
                when h.id_grupy is not null then substring(s.opis, 1, 1) || ' ' || 'grupa'  
            end 
        end) as "15",
        max(case when h.godz_od <= 16 and h.godz_do > 16 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then substring(s.opis, 1, 1) || ' ' || k.imie
                when h.id_grupy is not null then substring(s.opis, 1, 1) || ' ' || 'grupa' 
            end 
        end) as "16",
        max(case when h.godz_od <= 17 and h.godz_do > 17 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then substring(s.opis, 1, 1) || ' ' || k.imie
                when h.id_grupy is not null then substring(s.opis, 1, 1) || ' ' || 'grupa'  
            end 
        end) as "17",
        max(case when h.godz_od <= 18 and h.godz_do > 18 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then substring(s.opis, 1, 1) || ' ' || k.imie
                when h.id_grupy is not null then substring(s.opis, 1, 1) || ' ' || 'grupa' 
            end 
        end) as "18",
        max(case when h.godz_od <= 19 and h.godz_do > 19 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then substring(s.opis, 1, 1) || ' ' || k.imie
                when h.id_grupy is not null then substring(s.opis, 1, 1) || ' ' || 'grupa' 
            end 
        end) as "19",
        max(case when h.godz_od <= 20 and h.godz_do > 20 then 
            case 
                when h.czy_nieobecnosc then 'nieobecność'
                when h.id_klienta is not null then substring(s.opis, 1, 1) || ' ' || k.imie
                when h.id_grupy is not null then substring(s.opis, 1, 1) || ' ' || 'grupa' 
            end 
        end) as "20"
    from harmonogram h
    join instruktorzy i on h.id_instruktora = i.id_instruktora 
    left join sporty s on h.id_sportu = s.id_sportu 
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
	stawka_narty int;
	stawka_deska int;
	l_godzin_narty int;
	l_godzin_deska int;
begin 	
	select s.stawka_godzinowa
	into stawka_narty 
	from instruktorzy i 
		join instruktorzy_stopnie si on si.id_instruktora = i.id_instruktora  
		join stawki_stopnie s on s.id_stopnia = si.id_stopnia 
		join stopnie st on s.id_stopnia = st.id_stopnia 
	where i.id_instruktora = instruktor
		and st.id_sportu = 1
	order by si.data_od desc
	limit 1;
	select s.stawka_godzinowa
	into stawka_deska 
	from instruktorzy i 
		join instruktorzy_stopnie si on si.id_instruktora = i.id_instruktora  
		join stawki_stopnie s on s.id_stopnia = si.id_stopnia 
		join stopnie st on s.id_stopnia = st.id_stopnia 
	where i.id_instruktora = instruktor
		and st.id_sportu = 2
	order by si.data_od desc
	limit 1;
	select count(*)  
	into l_godzin_narty
	from harmonogram h 
	where h.id_instruktora = instruktor
		and "data" = dzien
		and czy_nieobecnosc is false
		and id_sportu = 1;
	select count(*)  
	into l_godzin_deska
	from harmonogram h 
	where h.id_instruktora = instruktor
		and "data" = dzien
		and czy_nieobecnosc is false
		and id_sportu = 2;
	return coalesce(l_godzin_narty * stawka_narty, 0) + coalesce(l_godzin_deska * stawka_deska, 0);
end;
$$ language plpgsql;


drop function umow_dowolny(int, date, int, int, int); 
create or replace function umow_dowolny(klient int, dzien date, h_od int, h_do int, sport int)
	returns varchar(30) as 
$$
declare
	id integer;
	imie varchar(30);
begin
	select h.id_instruktora into id
	from harmonogram h 
	join dostepnosc_sezon ds on h.id_instruktora = ds.id_instruktora 
	join instruktorzy_stopnie ins on ins.id_instruktora = h.id_instruktora 
	join stopnie s on s.id_stopnia = ins.id_stopnia
	where s.id_sportu = sport
		and h.id_instruktora not in (
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
	if id is null then return 'Brak instruktora'; end if;
	insert into harmonogram (id_instruktora, "data", godz_od, godz_do, id_klienta, id_grupy, czy_nieobecnosc, id_sportu) values
	(id, dzien, h_od, h_do, klient, null, false, sport);
	select i.imie into imie
	from instruktorzy i 
	where i.id_instruktora = id;
	return imie;
end;
$$ language plpgsql;

select umow_dowolny(2, '2024-01-02', 18, 19, 1);







