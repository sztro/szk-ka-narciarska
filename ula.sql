drop function if exists wyswietl_harmonogram(dzien date);
create or replace function wyswietl_harmonogram(dzien date)
returns table ("Instrukor" varchar(100), "9" text, "10" text, "11" text, "12" text, "13" text,  
    "14" text,  "15" text, "16" text, "17" text, "18" text, "19" text) as 
$$
begin
    return query
    select cast(b.id_instruktora || '. ' || b.imie || ' ' || b.nazwisko as varchar(100)) as "Instruktor",
    	a."9", a."10", a."11", a."12", a."13", a."14", a."15", a."16", a."17", a."18", a."19"
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
	        end) as "19"
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
		group by i.id_instruktora ) b on b.id_instruktora = a.id_instruktora
	order by b.id_instruktora;
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
	returns varchar(100) as 
$$
declare 
	stopien_instruktora varchar(100);
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

drop index if exists klienci_idx;
drop index if exists instruktorzy_idx;
create index if not exists klienci_idx on klienci(imie, nazwisko); --include (id_klienta);
create index if not exists instruktorzy_idx on instruktorzy(imie); --include (nazwisko, id_instruktora);

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

create or replace function instruktor_grupa(grupa int)
	returns int as 
$$
declare 
	instruktor int;
begin 
	select h.id_instruktora  
	into instruktor
	from grupy g 
	join harmonogram h on h.id_grupy = g.id_grupy 
	where g.id_grupy = grupa 
	limit 1;
	return instruktor; 
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
	join instruktorzy i on i.id_instruktora = instruktor_grupa(g.id_grupy)
	where g.data_rozpoczecia > dzien;
end;
$$ language plpgsql;

------------------------------------------------------------------------------------------------------------------------------------

drop function if exists wyswietl_poczekalnie(id_odz int, dzien date);
create or replace function wyswietl_poczekalnie(id_odz int, dzien date) 
	returns table (klient text, data_rozpoczecia date, odznaka text) as 
$$
begin
	return query 
	select l.id_klienta || '. ' || k.imie || ' ' || k.nazwisko, l.data_rozpoczecia, o.opis || '(' || s.opis || ')'
	from lista_oczekujacych l
	join klienci k on l.id_klienta = k.id_klienta
	join odznaki o on o.id_odznaki = l.id_odznaki 
	join sporty s on s.id_sportu = o.id_sportu
	where l.id_odznaki = id_odz
	and l.data_rozpoczecia = dzien;
end;
$$ language plpgsql;

------------------------------------------------------------------------------------------------------------------------------------

drop function if exists wyswietl_poczekalnie();
create or replace function wyswietl_poczekalnie() 
	returns table (klient text, data_rozpoczecia date, odznaka text) as 
$$
begin
	return query 
	select l.id_klienta || '. ' || k.imie || ' ' || k.nazwisko, l.data_rozpoczecia, o.opis || '(' || s.opis || ')'
	from lista_oczekujacych l
	join klienci k on l.id_klienta = k.id_klienta
	join odznaki o on o.id_odznaki = l.id_odznaki 
	join sporty s on s.id_sportu = o.id_sportu
	order by l.data_rozpoczecia, l.id_odznaki;
end;
$$ language plpgsql;

------------------------------------------------------------------------------------------------------------------------------------

--TODO:
-- Dodanie dwa razy tej samej osoby na tą samo grupe
-- Wyświetlanie poczekalni z parametrami a nie bez po dodaniu do poczekalni 
-- Kolejność insertów względem funkcji i wyzwalaczy 
-- Redundancja w id_instruktora (grupy)
-- Czemu można dodać do harmonogramu mimo że nie mają stopnia snowboardowego 
-- zmniejszyć okienka wiadomości po dodaniu do grupy/poczekalni 
-- teraz grupy trwają 7 dni zamiast 5

insert into grupy(id_odznaki, data_rozpoczecia, maks_dzieci, min_dzieci) values
	(1, '2024-02-05', 10, 3),
	(2, '2024-02-05', 10, 3),
	(3, '2024-02-12', 10, 3),
	(4, '2024-02-12', 10, 3),
	(5, '2024-02-19', 10, 3),
	(6, '2024-02-19', 10, 3),
	(7, '2024-02-26', 10, 3),
	(8, '2024-02-26', 10, 3);

insert into dzieci_odznaki(id_klienta, id_odznaki, data_uzysk) values
	(300, 1, '2024-02-11'),
	(301, 1, '2024-02-11'),
	(302, 1, '2024-02-11'),
	(303, 1, '2024-02-11'),
	(304, 1, '2024-02-11'),
	(305, 1, '2024-02-11'),
	(306, 1, '2024-02-11'),
	(307, 1, '2024-02-11'),
	(308, 1, '2024-02-11'),
	(309, 1, '2024-02-11'),
	(310, 2, '2024-02-11'),
	(311, 2, '2024-02-11'),
	(312, 2, '2024-02-11'),
	(313, 2, '2024-02-11'),
	(314, 2, '2024-02-11'),
	(315, 2, '2024-02-11'),
	(316, 2, '2024-02-11'),
	(300, 3, '2024-02-17'),
	(301, 3, '2024-02-17'),
	(302, 3, '2024-02-17'),
	(303, 3, '2024-02-17'),
	(304, 3, '2024-02-17'),
	(305, 3, '2024-02-17'),
	(306, 3, '2024-02-17'),
	(307, 3, '2024-02-17'),
	(308, 3, '2024-02-17'),
	(309, 3, '2024-02-17'),
	(310, 4, '2024-02-17'),
	(311, 4, '2024-02-17'),
	(312, 4, '2024-02-17'),
	(313, 4, '2024-02-17'),
	(314, 4, '2024-02-17'),
	(315, 4, '2024-02-17'),
	(316, 4, '2024-02-17'),
	(300, 5, '2024-02-24'),
	(301, 5, '2024-02-24'),
	(302, 5, '2024-02-24'),
	(303, 5, '2024-02-24'),
	(304, 5, '2024-02-24'),
	(305, 5, '2024-02-24'),
	(306, 5, '2024-02-24'),
	(307, 5, '2024-02-24'),
	(308, 5, '2024-02-24'),
	(309, 5, '2024-02-24'),
	(310, 6, '2024-02-24'),
	(311, 6, '2024-02-24'),
	(312, 6, '2024-02-24'),
	(313, 6, '2024-02-24'),
	(314, 6, '2024-02-24'),
	(315, 6, '2024-02-24'),
	(316, 6, '2024-02-24'),
	(300, 7, '2024-03-02'),
	(301, 7, '2024-03-02'),
	(302, 7, '2024-03-02'),
	(303, 7, '2024-03-02'),
	(304, 7, '2024-03-02'),
	(305, 7, '2024-03-02'),
	(306, 7, '2024-03-02'),
	(307, 7, '2024-03-02'),
	(308, 7, '2024-03-02'),
	(309, 7, '2024-03-02'),
	(310, 7, '2024-03-02'),
	(311, 8, '2024-03-02'),
	(312, 8, '2024-03-02'),
	(313, 8, '2024-03-02'),
	(314, 8, '2024-03-02'),
	(315, 8, '2024-03-02'),
	(316, 8, '2024-03-02');

insert into dzieci_grupy(id_klienta, id_grupy) values
	(300, 11),
	(301, 11),
	(302, 11),
	(303, 11),
	(304, 11),
	(305, 11),
	(306, 11),
	(307, 11),
	(308, 11),
	(309, 11),
	(310, 12),
	(311, 12),
	(312, 12),
	(313, 12),
	(314, 12),
	(315, 12),
	(316, 12),
	(317, 12),
	(318, 12),
	(300, 13),
	(301, 13),
	(302, 13),
	(303, 13),
	(304, 13),
	(305, 13),
	(306, 13),
	(307, 13),
	(308, 13),
	(309, 13),
	(310, 14),
	(311, 14),
	(312, 14),
	(313, 14),
	(314, 14),
	(315, 14),
	(316, 14),
	(317, 14),
	(318, 14),
	(300, 14),
	(301, 15),
	(302, 15),
	(303, 15),
	(304, 15),
	(305, 15),
	(306, 15),
	(307, 15),
	(308, 15),
	(309, 15),
	(310, 16),
	(311, 16),
	(312, 16),
	(313, 16),
	(314, 16),
	(315, 16),
	(316, 16),
	(317, 16),
	(318, 16),
	(300, 17),
	(301, 17),
	(302, 17),
	(303, 17),
	(304, 17),
	(305, 17),
	(306, 17),
	(307, 17),
	(308, 17),
	(309, 17),
	(310, 18),
	(311, 18),
	(312, 18),
	(313, 18),
	(314, 18),
	(315, 18),
	(316, 18),
	(317, 18),
	(318, 18);

insert into harmonogram (id_instruktora, "data", godz_od, godz_do, id_klienta, id_grupy, czy_nieobecnosc, id_sportu) values
	(8, '2024-02-05', 9, 12, null, 11, false, 1),
    (8, '2024-02-06', 9, 12, null, 11, false, 1),
    (8, '2024-02-07', 9, 12, null, 11, false, 1),
    (8, '2024-02-08', 9, 12, null, 11, false, 1),
    (8, '2024-02-09', 9, 12, null, 11, false, 1),
    (32, '2024-02-05', 9, 12, null, 11, false, 2),
    (32, '2024-02-06', 9, 12, null, 11, false, 2),
    (32, '2024-02-07', 9, 12, null, 11, false, 2),
    (32, '2024-02-08', 9, 12, null, 11, false, 2),
    (32, '2024-02-09', 9, 12, null, 11, false, 2),
    (9, '2024-02-12', 9, 12, null, 11, false, 1),
    (9, '2024-02-13', 9, 12, null, 11, false, 1),
    (9, '2024-02-14', 9, 12, null, 11, false, 1),
    (9, '2024-02-15', 9, 12, null, 11, false, 1),
    (9, '2024-02-16', 9, 12, null, 11, false, 1),
    (33, '2024-02-12', 9, 12, null, 11, false, 2),
    (33, '2024-02-13', 9, 12, null, 11, false, 2),
    (33, '2024-02-14', 9, 12, null, 11, false, 2),
    (33, '2024-02-15', 9, 12, null, 11, false, 2),
    (33, '2024-02-16', 9, 12, null, 11, false, 2),
    (10, '2024-02-19', 9, 12, null, 11, false, 1),
    (10, '2024-02-20', 9, 12, null, 11, false, 1),
    (10, '2024-02-21', 9, 12, null, 11, false, 1),
    (10, '2024-02-22', 9, 12, null, 11, false, 1),
    (10, '2024-02-23', 9, 12, null, 11, false, 1),
    (34, '2024-02-19', 9, 12, null, 11, false, 2),
    (34, '2024-02-20', 9, 12, null, 11, false, 2),
    (34, '2024-02-21', 9, 12, null, 11, false, 2),
    (34, '2024-02-22', 9, 12, null, 11, false, 2),
    (34, '2024-02-23', 9, 12, null, 11, false, 2),
    (11, '2024-02-26', 9, 12, null, 11, false, 1),
    (11, '2024-02-27', 9, 12, null, 11, false, 1),
    (11, '2024-02-28', 9, 12, null, 11, false, 1),
    (11, '2024-02-29', 9, 12, null, 11, false, 1),
    (11, '2024-03-01', 9, 12, null, 11, false, 1),
    (35, '2024-02-26', 9, 12, null, 11, false, 2),
    (35, '2024-02-27', 9, 12, null, 11, false, 2),
    (35, '2024-02-28', 9, 12, null, 11, false, 2),
    (35, '2024-02-29', 9, 12, null, 11, false, 2),
    (35, '2024-03-01', 9, 12, null, 11, false, 2),  
    (27, '2024-01-02', 9, 11, 430, null, false, 2),
    (27, '2024-01-02', 11, 12, 420, null, false, 2),
    (27, '2024-01-02', 12, 13, 450, null, false, 2),
	(27, '2024-01-02', 14, 15, null, null, true, null),
	(27, '2024-01-02', 16, 17, 451, null, false, 2),
	(27, '2024-01-02', 17, 20, null, null, true, null),
	(8, '2024-01-02', 12, 13, 454, null, false, 2),
	(8, '2024-01-02', 13, 15, null, null, true, null),
	(8, '2024-01-02', 16, 18, 455, null, false, 2),
	(8, '2024-01-02', 19, 20, 405, null, false, 2),
	(9, '2024-01-02', 12, 13, 457, null, false, 2),
	(9, '2024-01-02', 13, 14, 458, null, false, 2),
	(9, '2024-01-02', 15, 16, null, null, true, null),
	(9, '2024-01-02', 16, 17, 459, null, false, 2),
	(9, '2024-01-02', 18, 20, null, null, true, null),
	(10, '2024-01-02', 12, 13, 462, null, false, 2),
	(10, '2024-01-02', 14, 16, null, null, true, null),
	(10, '2024-01-02', 16, 17, 463, null, false, 2),
	(10, '2024-01-02', 17, 20, null, null, true, null),
	(11, '2024-01-02', 9, 11, 464, null, false, 2),
	(11, '2024-01-02', 11, 12, 465, null, false, 2),
	(11, '2024-01-02', 12, 13, 466, null, false, 2),
	(11, '2024-01-02', 15, 17, 467, null, false, 2),
	(11, '2024-01-02', 17, 20, null, null, true, null),
	(12, '2024-01-02', 9, 10, 300, null, false, 1),
	(12, '2024-01-02', 11, 13, 302, null, false, 1),
	(12, '2024-01-02', 13, 14, null, null, true, null),
	(12, '2024-01-02', 16, 18, 303, null, false, 1),
	(12, '2024-01-02', 18, 20, null, null, true, null),
	(13, '2024-01-02', 9, 11, 304, null, false, 1),
	(13, '2024-01-02', 11, 12, 305, null, false, 1),
	(13, '2024-01-02', 12, 13, 306, null, false, 1),
	(13, '2024-01-02', 14, 15, null, null, true, null),
	(13, '2024-01-02', 15, 16, 207, null, false, 1),
	(13, '2024-01-02', 16, 17, 307, null, false, 1),
	(13, '2024-01-02', 17, 20, null, null, true, null),
	(14, '2024-01-02', 10, 11, 308, null, false, 1),
	(14, '2024-01-02', 11, 13, 309, null, false, 1),
	(14, '2024-01-02', 14, 15, null, null, true, null),
	(14, '2024-01-02', 16, 17, 311, null, false, 1),
	(14, '2024-01-02', 18, 20, null, null, true, null),
	(15, '2024-01-02', 9, 10, 400, null, false, 1),
	(15, '2024-01-02', 12, 13, 402, null, false, 1),
	(15, '2024-01-02', 13, 14, null, null, true, null),
	(15, '2024-01-02', 15, 18, 403, null, false, 1),
	(15, '2024-01-02', 18, 20, null, null, true, null),
	(16, '2024-01-02', 9, 11, 404, null, false, 1),
	(16, '2024-01-02', 11, 12, 405, null, false, 1),
	(16, '2024-01-02', 12, 13, 406, null, false, 1),
	(16, '2024-01-02', 14, 15, 300, null, false, 1),
	(16, '2024-01-02', 16, 17, 407, null, false, 1),
	(16, '2024-01-02', 18, 20, 403, null, false, 1),
	(17, '2024-01-02', 10, 11, 408, null, false, 1),
	(17, '2024-01-02', 11, 13, 409, null, false, 1),
	(17, '2024-01-02', 13, 14, 410, null, false, 1),
	(17, '2024-01-02', 15, 16, null, null, true, null),
	(17, '2024-01-02', 16, 17, 411, null, false, 1),
	(17, '2024-01-02', 18, 20, null, null, true, null),
	(18, '2024-01-02', 9, 11, 412, null, false, 1),
	(18, '2024-01-02', 11, 12, 413, null, false, 1),
	(18, '2024-01-02', 12, 13, 414, null, false, 1),
	(18, '2024-01-02', 14, 15, null, null, true, null),
	(18, '2024-01-02', 16, 17, 415, null, false, 1),
	(18, '2024-01-02', 17, 20, null, null, true, null),
	(19, '2024-01-02', 9, 10, 416, null, false, 1),
	(19, '2024-01-02', 10, 11, 417, null, false, 1),
	(19, '2024-01-02', 11, 13, 418, null, false, 1),
	(19, '2024-01-02', 13, 14, null, null, true, null),
	(19, '2024-01-02', 14, 16, 414, null, false, 1),
	(19, '2024-01-02', 16, 18, 419, null, false, 1),
	(19, '2024-01-02', 18, 20, null, null, true, null),
	(20, '2024-01-02', 10, 11, 420, null, false, 1),
	(20, '2024-01-02', 12, 13, 421, null, false, 1),
	(20, '2024-01-02', 13, 14, 422, null, false, 1),
	(20, '2024-01-02', 14, 15, null, null, true, null),
	(20, '2024-01-02', 15, 17, 423, null, false, 1),
	(20, '2024-01-02', 18, 20, null, null, true, null),
	(21, '2024-01-02', 9, 11, 424, null, false, 1),
	(21, '2024-01-02', 11, 12, 425, null, false, 1),
	(21, '2024-01-02', 12, 13, 426, null, false, 1),
	(21, '2024-01-02', 14, 15, null, null, true, null),
	(23, '2024-01-02', 15, 16, 110, null, false, 1),
	(21, '2024-01-02', 16, 17, 427, null, false, 1),
	(21, '2024-01-02', 17, 19, 417, null, false, 1),
	(22, '2024-01-02', 9, 10, 428, null, false, 1),
	(22, '2024-01-02', 11, 13, 430, null, false, 1),
	(22, '2024-01-02', 13, 14, null, null, true, null),
	(22, '2024-01-02', 15, 16, 120, null, false, 1),
	(22, '2024-01-02', 16, 18, 431, null, false, 1),
	(22, '2024-01-02', 18, 20, null, null, true, null),
	(23, '2024-01-02', 10, 11, 432, null, false, 1),
	(23, '2024-01-02', 11, 12, 433, null, false, 1),
	(23, '2024-01-02', 13, 14, 434, null, false, 1),
	(23, '2024-01-02', 14, 15, null, null, true, null),
	(23, '2024-01-02', 16, 17, 435, null, false, 1),
	(23, '2024-01-02', 18, 19, 100, null, false, 1),
	(24, '2024-01-02', 9, 11, 436, null, false, 1),
	(24, '2024-01-02', 11, 12, 437, null, false, 1),
	(24, '2024-01-02', 12, 13, 438, null, false, 1),
	(24, '2024-01-02', 14, 15, 323, null, false, 1),
	(24, '2024-01-02', 16, 17, 439, null, false, 1),
	(24, '2024-01-02', 17, 20, null, null, true, null),
	(25, '2024-01-02', 9, 10, 440, null, false, 1),
	(25, '2024-01-02', 10, 11, 441, null, false, 1),
	(25, '2024-01-02', 11, 13, 442, null, false, 1),
	(25, '2024-01-02', 13, 14, null, null, true, null),
	(25, '2024-01-02', 15, 17, 443, null, false, 1),
	(25, '2024-01-02', 17, 20, null, null, true, null),
	(26, '2024-01-02', 9, 11, 444, null, false, 1),
	(26, '2024-01-02', 11, 12, 445, null, false, 1),
	(26, '2024-01-02', 12, 13, 446, null, false, 1),
	(26, '2024-01-02', 14, 15, null, null, true, null),
	(26, '2024-01-02', 15, 16, 447, null, false, 1),
	(26, '2024-01-02', 17, 20, null, null, true, null),
	(32, '2024-01-02', 12, 13, 450, null, false, 2),
	(32, '2024-01-02', 13, 15, 448, null, false, 2),
	(32, '2024-01-02', 16, 17, 451, null, false, 2),
	(32, '2024-01-02', 17, 20, null, null, true, null),
	(33, '2024-01-02', 12, 13, 454, null, false, 2),
	(33, '2024-01-02', 13, 15, null, null, true, null),
	(33, '2024-01-02', 15, 16, 100, null, false, 2),
	(33, '2024-01-02', 16, 18, 455, null, false, 2),
	(33, '2024-01-02', 19, 20, 405, null, false, 2),
	(34, '2024-01-02', 13, 14, 458, null, false, 2),
	(34, '2024-01-02', 14, 15, null, null, true, null),
	(34, '2024-01-02', 15, 16, 100, null, false, 2),
	(34, '2024-01-02', 16, 17, 459, null, false, 2),
	(34, '2024-01-02', 18, 20, null, null, true, null),
	(35, '2024-01-02', 12, 13, 462, null, false, 2),
	(35, '2024-01-02', 14, 15, null, null, true, null),
	(35, '2024-01-02', 16, 17, 463, null, false, 2),
	(35, '2024-01-02', 17, 20, null, null, true, null),
	(36, '2024-01-02', 9, 11, 464, null, false, 2),
	(36, '2024-01-02', 11, 12, 465, null, false, 2),
	(36, '2024-01-02', 12, 14, 466, null, false, 2),
	(36, '2024-01-02', 15, 16, null, null, true, null),
	(36, '2024-01-02', 16, 17, 467, null, false, 2),
	(36, '2024-01-02', 17, 20, null, null, true, null),
	(37, '2024-01-02', 9, 10, 468, null, false, 2),
	(37, '2024-01-02', 10, 11, 469, null, false, 2),
	(37, '2024-01-02', 11, 13, 470, null, false, 2),
	(37, '2024-01-02', 13, 14, null, null, true, null),
	(37, '2024-01-02', 14, 16, 412, null, false, 2),
	(37, '2024-01-02', 16, 18, 471, null, false, 2),
	(37, '2024-01-02', 18, 20, null, null, true, null),
	(38, '2024-01-02', 10, 11, 472, null, false, 2),
	(38, '2024-01-02', 11, 13, 473, null, false, 2),
	(38, '2024-01-02', 14, 15, null, null, true, null),
	(38, '2024-01-02', 16, 17, 475, null, false, 2),
	(38, '2024-01-02', 18, 20, null, null, true, null),
	(39, '2024-01-02', 10, 11, 476, null, false, 2),
	(39, '2024-01-02', 11, 12, 477, null, false, 2),
	(39, '2024-01-02', 12, 13, 478, null, false, 2),
	(39, '2024-01-02', 14, 15, null, null, true, null),
	(39, '2024-01-02', 16, 17, 479, null, false, 2),
	(40, '2024-01-02', 9, 10, 480, null, false, 2),
	(40, '2024-01-02', 10, 11, 481, null, false, 2),
	(40, '2024-01-02', 11, 13, 482, null, false, 2),
	(40, '2024-01-02', 13, 14, null, null, true, null),
	(40, '2024-01-02', 15, 16, 483, null, false, 2),
	(40, '2024-01-02', 16, 20, null, null, true, null),
	(41, '2024-01-02', 9, 11, 484, null, false, 2),
	(41, '2024-01-02', 11, 12, 485, null, false, 2),
	(41, '2024-01-02', 12, 13, 486, null, false, 2),
	(41, '2024-01-02', 14, 16, null, null, true, null),
	(41, '2024-01-02', 15, 17, 487, null, false, 2),
	(41, '2024-01-02', 17, 20, null, null, true, null),
	(42, '2024-01-02', 9, 10, 488, null, false, 2),
	(42, '2024-01-02', 10, 11, 489, null, false, 2),
	(42, '2024-01-02', 11, 13, 490, null, false, 2),
	(42, '2024-01-02', 14, 15, null, null, true, null),
	(42, '2024-01-02', 16, 18, 491, null, false, 2),
	(42, '2024-01-02', 18, 19, 391, null, false, 2),
	(43, '2024-01-02', 10, 11, 492, null, false, 2),
	(43, '2024-01-02', 11, 13, 493, null, false, 2),
	(43, '2024-01-02', 13, 14, 494, null, false, 2),
	(43, '2024-01-02', 14, 15, null, null, true, null),
	(43, '2024-01-02', 15, 17, 495, null, false, 2),
	(43, '2024-01-02', 18, 20, null, null, true, null),
	(44, '2024-01-02', 9, 10, 496, null, false, 2),
	(44, '2024-01-02', 11, 12, 497, null, false, 2),
	(44, '2024-01-02', 12, 13, 498, null, false, 2),
	(44, '2024-01-02', 14, 15, null, null, true, null),
	(44, '2024-01-02', 16, 17, 499, null, false, 2),
	(44, '2024-01-02', 17, 20, null, null, true, null),
	(45, '2024-01-02', 9, 10, 500, null, false, 2),
	(45, '2024-01-02', 10, 11, 501, null, false, 2),
	(45, '2024-01-02', 11, 13, 502, null, false, 2),
	(45, '2024-01-02', 13, 14, null, null, true, null),
	(45, '2024-01-02', 16, 18, 503, null, false, 2),
	(45, '2024-01-02', 18, 20, null, null, true, null),
	(46, '2024-01-02', 9, 11, 204, null, false, 2),
	(46, '2024-01-02', 11, 12, 205, null, false, 2),
	(46, '2024-01-02', 12, 13, 206, null, false, 2),
	(46, '2024-01-02', 14, 15, null, null, true, null),
	(46, '2024-01-02', 16, 17, 207, null, false, 2),
	(27, '2024-01-04', 9, 11, 430, null, false, 2),
(27, '2024-01-04', 11, 12, 420, null, false, 2),
(27, '2024-01-04', 12, 13, 450, null, false, 2),
(27, '2024-01-04', 14, 15, null, null, true, null),
(27, '2024-01-04', 16, 17, 451, null, false, 2),
(27, '2024-01-04', 17, 20, null, null, true, null),
(8, '2024-01-04', 12, 13, 454, null, false, 2),
(8, '2024-01-04', 13, 15, null, null, true, null),
(8, '2024-01-04', 16, 18, 455, null, false, 2),
(8, '2024-01-04', 19, 20, 405, null, false, 2),
(9, '2024-01-04', 12, 13, 457, null, false, 2),
(9, '2024-01-04', 13, 14, 458, null, false, 2),
(9, '2024-01-04', 15, 16, null, null, true, null),
(9, '2024-01-04', 16, 17, 459, null, false, 2),
(9, '2024-01-04', 18, 20, null, null, true, null),
(10, '2024-01-04', 12, 13, 462, null, false, 2),
(10, '2024-01-04', 14, 16, null, null, true, null),
(10, '2024-01-04', 16, 17, 463, null, false, 2),
(10, '2024-01-04', 17, 20, null, null, true, null),
(11, '2024-01-04', 9, 11, 464, null, false, 2),
(11, '2024-01-04', 11, 12, 465, null, false, 2),
(11, '2024-01-04', 12, 13, 466, null, false, 2),
(11, '2024-01-04', 15, 17, 467, null, false, 2),
(11, '2024-01-04', 17, 20, null, null, true, null),
(12, '2024-01-04', 9, 10, 300, null, false, 1),
(12, '2024-01-04', 11, 13, 302, null, false, 1),
(12, '2024-01-04', 13, 14, null, null, true, null),
(12, '2024-01-04', 16, 18, 303, null, false, 1),
(12, '2024-01-04', 18, 20, null, null, true, null),
(13, '2024-01-04', 9, 11, 304, null, false, 1),
(13, '2024-01-04', 11, 12, 305, null, false, 1),
(13, '2024-01-04', 12, 13, 306, null, false, 1),
(13, '2024-01-04', 14, 15, null, null, true, null),
(13, '2024-01-04', 15, 16, 207, null, false, 1),
(13, '2024-01-04', 16, 17, 307, null, false, 1),
(13, '2024-01-04', 17, 20, null, null, true, null),
(14, '2024-01-04', 10, 11, 308, null, false, 1),
(14, '2024-01-04', 11, 13, 309, null, false, 1),
(14, '2024-01-04', 14, 15, null, null, true, null),
(14, '2024-01-04', 16, 17, 311, null, false, 1),
(14, '2024-01-04', 18, 20, null, null, true, null),
(15, '2024-01-04', 9, 10, 400, null, false, 1),
(15, '2024-01-04', 12, 13, 402, null, false, 1),
(15, '2024-01-04', 13, 14, null, null, true, null),
(15, '2024-01-04', 15, 18, 403, null, false, 1),
(15, '2024-01-04', 18, 20, null, null, true, null),
(16, '2024-01-04', 9, 11, 404, null, false, 1),
(16, '2024-01-04', 11, 12, 405, null, false, 1),
(16, '2024-01-04', 12, 13, 406, null, false, 1),
(16, '2024-01-04', 14, 15, 300, null, false, 1),
(16, '2024-01-04', 16, 17, 407, null, false, 1),
(16, '2024-01-04', 18, 20, 403, null, false, 1),
(17, '2024-01-04', 10, 11, 408, null, false, 1),
(17, '2024-01-04', 11, 13, 409, null, false, 1),
(17, '2024-01-04', 13, 14, 410, null, false, 1),
(17, '2024-01-04', 15, 16, null, null, true, null),
(17, '2024-01-04', 16, 17, 411, null, false, 1),
(17, '2024-01-04', 18, 20, null, null, true, null),
(18, '2024-01-04', 9, 11, 412, null, false, 1),
(18, '2024-01-04', 11, 12, 413, null, false, 1),
(18, '2024-01-04', 12, 13, 414, null, false, 1),
(18, '2024-01-04', 14, 15, null, null, true, null),
(18, '2024-01-04', 16, 17, 415, null, false, 1),
(18, '2024-01-04', 17, 20, null, null, true, null),
(19, '2024-01-04', 9, 10, 416, null, false, 1),
(19, '2024-01-04', 10, 11, 417, null, false, 1),
(19, '2024-01-04', 11, 13, 418, null, false, 1),
(19, '2024-01-04', 13, 14, null, null, true, null),
(19, '2024-01-04', 14, 16, 414, null, false, 1),
(19, '2024-01-04', 16, 18, 419, null, false, 1),
(19, '2024-01-04', 18, 20, null, null, true, null),
(20, '2024-01-04', 10, 11, 420, null, false, 1),
(20, '2024-01-04', 12, 13, 421, null, false, 1),
(20, '2024-01-04', 13, 14, 422, null, false, 1),
(20, '2024-01-04', 14, 15, null, null, true, null),
(20, '2024-01-04', 15, 17, 423, null, false, 1),
(20, '2024-01-04', 18, 20, null, null, true, null),
(21, '2024-01-04', 9, 11, 424, null, false, 1),
(21, '2024-01-04', 11, 12, 425, null, false, 1),
(21, '2024-01-04', 12, 13, 426, null, false, 1),
(21, '2024-01-04', 14, 15, null, null, true, null),
(23, '2024-01-04', 15, 16, 110, null, false, 1),
(21, '2024-01-04', 16, 17, 427, null, false, 1),
(21, '2024-01-04', 17, 19, 417, null, false, 1),
(22, '2024-01-04', 9, 10, 428, null, false, 1),
(22, '2024-01-04', 11, 13, 430, null, false, 1),
(22, '2024-01-04', 13, 14, null, null, true, null),
(22, '2024-01-04', 15, 16, 120, null, false, 1),
(22, '2024-01-04', 16, 18, 431, null, false, 1),
(22, '2024-01-04', 18, 20, null, null, true, null),
(23, '2024-01-04', 10, 11, 432, null, false, 1),
(23, '2024-01-04', 11, 12, 433, null, false, 1),
(23, '2024-01-04', 13, 14, 434, null, false, 1),
(23, '2024-01-04', 14, 15, null, null, true, null),
(23, '2024-01-04', 16, 17, 435, null, false, 1),
(23, '2024-01-04', 18, 19, 100, null, false, 1),
(24, '2024-01-04', 9, 11, 436, null, false, 1),
(24, '2024-01-04', 11, 12, 437, null, false, 1),
(24, '2024-01-04', 12, 13, 438, null, false, 1),
(24, '2024-01-04', 14, 15, 323, null, false, 1),
(24, '2024-01-04', 16, 17, 439, null, false, 1),
(24, '2024-01-04', 17, 20, null, null, true, null),
(25, '2024-01-04', 9, 10, 440, null, false, 1),
(25, '2024-01-04', 10, 11, 441, null, false, 1),
(25, '2024-01-04', 11, 13, 442, null, false, 1),
(25, '2024-01-04', 13, 14, null, null, true, null),
(25, '2024-01-04', 15, 17, 443, null, false, 1),
(25, '2024-01-04', 17, 20, null, null, true, null),
(26, '2024-01-04', 9, 11, 444, null, false, 1),
(26, '2024-01-04', 11, 12, 445, null, false, 1),
(26, '2024-01-04', 12, 13, 446, null, false, 1),
(26, '2024-01-04', 14, 15, null, null, true, null),
(26, '2024-01-04', 15, 16, 447, null, false, 1),
(26, '2024-01-04', 17, 20, null, null, true, null),
(32, '2024-01-04', 12, 13, 450, null, false, 2),
(32, '2024-01-04', 13, 15, 448, null, false, 2),
(32, '2024-01-04', 16, 17, 451, null, false, 2),
(32, '2024-01-04', 17, 20, null, null, true, null),
(33, '2024-01-04', 12, 13, 454, null, false, 2),
(33, '2024-01-04', 13, 15, null, null, true, null),
(33, '2024-01-04', 15, 16, 100, null, false, 2),
(33, '2024-01-04', 16, 18, 455, null, false, 2),
(33, '2024-01-04', 19, 20, 405, null, false, 2),
(34, '2024-01-04', 13, 14, 458, null, false, 2),
(34, '2024-01-04', 14, 15, null, null, true, null),
(34, '2024-01-04', 15, 16, 100, null, false, 2),
(34, '2024-01-04', 16, 17, 459, null, false, 2),
(34, '2024-01-04', 18, 20, null, null, true, null),
(35, '2024-01-04', 12, 13, 462, null, false, 2),
(35, '2024-01-04', 14, 15, null, null, true, null),
(35, '2024-01-04', 16, 17, 463, null, false, 2),
(35, '2024-01-04', 17, 20, null, null, true, null),
(36, '2024-01-04', 9, 11, 464, null, false, 2),
(36, '2024-01-04', 11, 12, 465, null, false, 2),
(36, '2024-01-04', 12, 14, 466, null, false, 2),
(36, '2024-01-04', 15, 16, null, null, true, null),
(36, '2024-01-04', 16, 17, 467, null, false, 2),
(36, '2024-01-04', 17, 20, null, null, true, null),
(37, '2024-01-04', 9, 10, 468, null, false, 2),
(37, '2024-01-04', 10, 11, 469, null, false, 2),
(37, '2024-01-04', 11, 13, 470, null, false, 2),
(37, '2024-01-04', 13, 14, null, null, true, null),
(37, '2024-01-04', 14, 16, 412, null, false, 2),
(37, '2024-01-04', 16, 18, 471, null, false, 2),
(37, '2024-01-04', 18, 20, null, null, true, null),
(38, '2024-01-04', 10, 11, 472, null, false, 2),
(38, '2024-01-04', 11, 13, 473, null, false, 2),
(38, '2024-01-04', 14, 15, null, null, true, null),
(38, '2024-01-04', 16, 17, 475, null, false, 2),
(38, '2024-01-04', 18, 20, null, null, true, null),
(39, '2024-01-04', 10, 11, 476, null, false, 2),
(39, '2024-01-04', 11, 12, 477, null, false, 2),
(39, '2024-01-04', 12, 13, 478, null, false, 2),
(39, '2024-01-04', 14, 15, null, null, true, null),
(39, '2024-01-04', 16, 17, 479, null, false, 2),
(40, '2024-01-04', 9, 10, 480, null, false, 2),
(40, '2024-01-04', 10, 11, 481, null, false, 2),
(40, '2024-01-04', 11, 13, 482, null, false, 2),
(40, '2024-01-04', 13, 14, null, null, true, null),
(40, '2024-01-04', 15, 16, 483, null, false, 2),
(40, '2024-01-04', 16, 20, null, null, true, null),
(41, '2024-01-04', 9, 11, 484, null, false, 2),
(41, '2024-01-04', 11, 12, 485, null, false, 2),
(41, '2024-01-04', 12, 13, 486, null, false, 2),
(41, '2024-01-04', 14, 16, null, null, true, null),
(41, '2024-01-04', 15, 17, 487, null, false, 2),
(41, '2024-01-04', 17, 20, null, null, true, null),
(42, '2024-01-04', 9, 10, 488, null, false, 2),
(42, '2024-01-04', 10, 11, 489, null, false, 2),
(42, '2024-01-04', 11, 13, 490, null, false, 2),
(42, '2024-01-04', 14, 15, null, null, true, null),
(42, '2024-01-04', 16, 18, 491, null, false, 2),
(42, '2024-01-04', 18, 19, 391, null, false, 2),
(43, '2024-01-04', 10, 11, 492, null, false, 2),
(43, '2024-01-04', 11, 13, 493, null, false, 2),
(43, '2024-01-04', 13, 14, 494, null, false, 2),
(43, '2024-01-04', 14, 15, null, null, true, null),
(43, '2024-01-04', 15, 17, 495, null, false, 2),
(43, '2024-01-04', 18, 20, null, null, true, null),
(44, '2024-01-04', 9, 10, 496, null, false, 2),
(44, '2024-01-04', 11, 12, 497, null, false, 2),
(44, '2024-01-04', 12, 13, 498, null, false, 2),
(44, '2024-01-04', 14, 15, null, null, true, null),
(44, '2024-01-04', 16, 17, 499, null, false, 2),
(44, '2024-01-04', 17, 20, null, null, true, null),
(45, '2024-01-04', 9, 10, 500, null, false, 2),
(45, '2024-01-04', 10, 11, 501, null, false, 2),
(45, '2024-01-04', 11, 13, 502, null, false, 2),
(45, '2024-01-04', 13, 14, null, null, true, null),
(45, '2024-01-04', 16, 18, 503, null, false, 2),
(45, '2024-01-04', 18, 20, null, null, true, null),
(46, '2024-01-04', 9, 11, 204, null, false, 2),
(46, '2024-01-04', 11, 12, 205, null, false, 2),
(46, '2024-01-04', 12, 13, 206, null, false, 2),
(46, '2024-01-04', 14, 15, null, null, true, null),
(46, '2024-01-04', 16, 17, 207, null, false, 2),
