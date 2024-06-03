drop function if exists wyswietl_harmonogram(dzien date);
create or replace function wyswietl_harmonogram(dzien date)
returns table ("Instrukor" varchar(61), "9" text, "10" text, "11" text, "12" text, "13" text,  
    "14" text,  "15" text, "16" text, "17" text, "18" text, "19" text, "20" text) as 
$$
begin
    return query
    select cast(b.imie || ' ' || b.nazwisko as varchar(61)) as "Instruktor",
    	a."9", a."10", a."11", a."12", a."13", a."14", a."15", a."16", a."17", a."18", a."19", a."20"
    from (    
	    select 
	    	i.id_instruktora,
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
	    order by i.id_instruktora ) a
    right join (
    	select i.id_instruktora, i.imie, i.nazwisko
		from instruktorzy i 
		join dostepnosc_sezon d on d.id_instruktora = i.id_instruktora 
		where dzien between d.data_od and d.data_do 
		group by i.id_instruktora ) b on b.id_instruktora = a.id_instruktora; 
end;
$$ language plpgsql;

------------------------------------------------------------------------------------------------------------------------------------

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
	select sum(h.godz_do - h.godz_od)  
	into l_godzin_narty
	from harmonogram h 
	where h.id_instruktora = instruktor
		and "data" = dzien
		and czy_nieobecnosc is false
		and id_sportu = 1;
	select sum(h.godz_do - h.godz_od)    
	into l_godzin_deska
	from harmonogram h 
	where h.id_instruktora = instruktor
		and "data" = dzien
		and czy_nieobecnosc is false
		and id_sportu = 2;
	return coalesce(l_godzin_narty * stawka_narty, 0) + coalesce(l_godzin_deska * stawka_deska, 0);
end;
$$ language plpgsql;

------------------------------------------------------------------------------------------------------------------------------------

drop function if exists umow_dowolny(int, date, int, int, int); 
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

------------------------------------------------------------------------------------------------------------------------------------

create or replace function max_stopien(instruktor int, sport int) 
	returns varchar(20) as 
$$
declare 
	stopien_instruktora varchar(20);
begin 
	select s.nazwa
	into stopien_instruktora
	from instruktorzy_stopnie i 
	left join stopnie s on s.id_stopnia = i.id_stopnia
	where id_sportu = sport
		and i.id_instruktora = instruktor
	order by i.id_stopnia desc
	limit 1;
	return stopien_instruktora;
end;
$$ language plpgsql; 

------------------------------------------------------------------------------------------------------------------------------------

drop function if exists znajdz_instruktora(im varchar(30));
create or replace function znajdz_instruktora(im varchar(30)) 
	returns table (id_instruktora int, imie varchar(30), nazwisko varchar(30), "stopień(narty)" varchar(20), "stopień(snowboard)" varchar(20)) as
$$
begin
    return query
    select i.id_instruktora, i.imie, i.nazwisko, max_stopien(i.id_instruktora, 1), max_stopien(i.id_instruktora, 2)
    from instruktorzy i 
    where i.imie = im;
end;
$$ language plpgsql; 

------------------------------------------------------------------------------------------------------------------------------------

create or replace function dodaj_nieobecnosc(instruktor int, dzien date, h_od numeric(2), h_do numeric(2)) 
	returns bool as
$$
begin
    insert into harmonogram(id_instruktora, "data", godz_od, godz_do, id_klienta, id_grupy, czy_nieobecnosc, id_sportu) values
		(instruktor, dzien, h_od, h_do, null, null, true, null);
	return true;
	exception
	when others then return false;
end;
$$ language plpgsql;

------------------------------------------------------------------------------------------------------------------------------------

create unique index if not exists klienci_idx on klienci(imie, nazwisko) include (id_klienta);
create unique index if not exists instruktorzy_idx on instruktorzy(imie) include (nazwisko, id_instruktora);

------------------------------------------------------------------------------------------------------------------------------------

create or replace function ile_dzieci(grupa int) 
	returns int as
$$ 
declare 
	suma int;
begin
	select count(*)
	into suma
	from dzieci_grupy d
	where d.id_grupy = grupa;
	return suma;
end;
$$ language plpgsql;

------------------------------------------------------------------------------------------------------------------------------------

create or replace function wyswietl_grupy(dzien date)
	returns table (odznaka varchar(30), sport varchar(30), instruktor text, data_rozpoczecia date, dzieci int) as 
$$ 
begin 
	return query
	select 
		o.opis,
		s.opis,
		i.imie || ' ' || substring(i.nazwisko, 1, 1),
		g.data_rozpoczecia,
		ile_dzieci(g.id_grupy)
	from grupy g
	join odznaki o on o.id_odznaki = g.id_odznaki 
	join sporty s on s.id_sportu = o.id_sportu  
	join instruktorzy i on i.id_instruktora = g.id_instruktora 
	where g.data_rozpoczecia > dzien;
end;
$$ language plpgsql;

------------------------------------------------------------------------------------------------------------------------------------

drop function if exists wyswietl_poczekalnie(id_odz int, dzien date);
create or replace function wyswietl_poczekalnie(id_odz int, dzien date) 
	returns table (klient int, data_rozpoczecia date, odznaka varchar(9)) as 
$$
begin
	return query 
	select l.id_klienta, l.data_rozpoczecia, o.opis 
	from lista_oczekujacych l
	join odznaki o on o.id_odznaki = l.id_odznaki 
	join sporty s on s.id_sportu = o.id_sportu
	where l.id_odznaki = id_odz
	and l.data_rozpoczecia = dzien;
end;
$$ language plpgsql;

------------------------------------------------------------------------------------------------------------------------------------

drop function if exists wyswietl_poczekalnie();
create or replace function wyswietl_poczekalnie() 
	returns table (klient int, data_rozpoczecia date, odznaka varchar(9)) as 
$$
begin
	return query 
	select l.id_klienta, l.data_rozpoczecia, o.opis 
	from lista_oczekujacych l
	join odznaki o on o.id_odznaki = l.id_odznaki 
	join sporty s on s.id_sportu = o.id_sportu
	order by l.data_rozpoczecia, l.id_odznaki;
end;
$$ language plpgsql;

------------------------------------------------------------------------------------------------------------------------------------



