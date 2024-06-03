create or replace function b_grupy_insert()
returns trigger as
$b_grupy_insert$
declare
    licznik int;
	godz_start int := 9;
	godz_koniec int := 12;
	stopnie_pomocnicze int[] = '{1,5}';
	stopien_instruktora int;
begin
    select count(*) from lista_oczekujacych into licznik
	where new.data_rozpoczecia = data_rozpoczecia and new.id_odznaki = id_odznaki;
	
	select max(s.id_stopnia) from instruktorzy_stopnie s into stopien_instruktora
		left join stopnie st using(id_stopnia)
		where id_instruktora = new.id_instruktora
		and id_sportu = (select id_sportu from odznaki where id_odznaki = new.id_odznaki);
   if licznik < new.min_dzieci then
        raise exception using
        	errcode = 'ERRDZ',
        	message = 'Nie ma wystarczająco chętnych by utworzyć grupe',
        	hint = 'Spróbuj  stworzyć grupe w innym terminie, o innym stopniu, lub poczekaj aż zapisze się wiecej osób';
        return null;
    elsif exists(
		select * from harmonogram 
		where "data" between new.data_rozpoczecia and new.data_rozpoczecia + interval '5 days'
		and id_instruktora = new.id_instruktora
		and	(
			(godz_od >= godz_start and godz_od < godz_koniec)
			or (godz_do > godz_start and godz_do <= godz_koniec)
			or (godz_od <= godz_start and godz_do >= godz_koniec)
		)
	) then
		raise exception using
			errcode = 'TAKEN', 
			message = 'Instruktor ma inne zajecia  w tym terminie ';
		return null;
	elsif  (
		select id_sportu from odznaki 
		where id_odznaki = new.id_odznaki) NOT IN 
		(select id_sportu from instruktorzy_stopnie 
		left join stopnie using(id_stopnia) 
		where id_instruktora = new.id_instruktora)
		then
			raise exception using
				errcode = 'STERR',
				message = 'Instruktor nie uczy tego sportu';
		return null;
	elsif not exists(
		select * from dostepnosc_sezon 
		where id_instruktora = new.id_instruktora 
		and new.data_rozpoczecia between data_od and data_do
	) then 
		raise exception using
			errcode = 'NDOST',
			message = 'Instruktor o id: '|| new.id_instruktora::text || ' niedostępny w tym czasie',
			hint = 'Spróbuj dodać w innym terminie';
		return null;
	elsif stopien_instruktora = ANY(stopnie_pomocnicze) then
		raise exception using
			errcode = 'STERR',
			message = 'Instruktor niewykwalifikowany do nauki tych zajec';
		return null;
	end if;
	return new;
end;
$b_grupy_insert$ language plpgsql;
create or replace trigger grupy_insert before insert on grupy
for each row execute procedure b_grupy_insert();
------------------------------------------------------------------------------
create or replace function aft_grupy_insert()
returns trigger as
$aft_grupy_insert$
declare
	licznik int;
    chetni cursor for select l.id_klienta from lista_oczekujacych l
where l.data_rozpoczecia = new.data_rozpoczecia and l.id_odznaki = new.id_odznaki;
    rekord record;
    wskaźnik int := 0;
begin
	select count(*) from lista_oczekujacych into licznik
	where new.data_rozpoczecia = data_rozpoczecia and new.id_odznaki = id_odznaki;
	open chetni;
    	while wskaźnik < new.maks_dzieci and wskaźnik < licznik loop
        	fetch from chetni into rekord;
        	insert into dzieci_grupy (id_klienta, id_grupy) values (rekord.id_klienta, new.id_grupy);
       		delete from lista_oczekujacych where current of chetni;
        	wskaźnik := wskaźnik + 1;
    end loop;
    return new;
end;
$aft_grupy_insert$ language plpgsql;
create or replace trigger aft_grupy_insert after insert on grupy
for each row execute procedure aft_grupy_insert();
-----------------------------------------------------------------------------------------------------
create or replace function licznosc_grupy(id_grp int)
returns int as
$$
declare
a int;
begin
	select count(*) from dzieci_grupy d into a where d.id_grupy = id_grp;
	return a;
end;
$$ language plpgsql;
-----------------------------------------
create or replace function max_odznaka(id_k int, id_s int)
returns integer as
$$
declare
	a int;
begin
	select coalesce(max(id_odznaki),0) from dzieci_odznaki
	left join odznaki using(id_odznaki) into a
	where id_klienta = id_k and id_sportu = id_s;
	return a;
end;
$$ language plpgsql;
-------------------------------------------------------
create or replace function lista_oczekujacych_ins()
returns trigger as
$lista_oczekujacych_ins$
declare
	id_grp int;
begin
	if new.id_klienta in (
		select id_klienta from grupy right join dzieci_grupy using(id_grupy)
		where data_rozpoczecia = new.data_rozpoczecia and id_odznaki = new.id_odznaki)
	then raise exception using
		errcode = 'REDUN',
		message = 'dziecko jest juz w grupie o tych parametrach';
	elsif max_odznaka(new.id_klienta, ( select id_sportu from odznaki where id_odznaki = new.id_odznaki))+ 2 < new.id_odznaki
		then raise exception using
			errcode = 'ODERR',
			message = 'Dziecko nie ma odpowiedniej odznaki by wpisano je do grupy';
		return null;
	elsif exists(
		select * from grupy 
		where data_rozpoczecia = new.data_rozpoczecia and id_odznaki = new.id_odznaki 
		and licznosc_grupy(id_grupy) < maks_dzieci
	)then	
		select id_grupy from grupy into id_grp
		where data_rozpoczecia = new.data_rozpoczecia and id_odznaki = new.id_odznaki 
		and licznosc_grupy(id_grupy) < maks_dzieci
		limit 1;
		
		insert into dzieci_grupy (id_klienta, id_grupy) VALUES (new.id_klienta, id_grp);
		return null;
	end if;
	return new;
end;
$lista_oczekujacych_ins$ language plpgsql;
create or replace trigger lista_oczekujacych_ins before insert or update on lista_oczekujacych
for each row execute procedure lista_oczekujacych_ins();
	
--------------------------------------
create or replace function harmonogram_add()
returns trigger as
$harmonogram_add$
begin
	if not exists(
		select * from dostepnosc_sezon 
		where id_instruktora = new.id_instruktora 
		and new.data between data_od and data_do
	) then 
		raise exception using
			errcode = 'NDOST',
			message = 'Instruktor o id: '|| new.id_instruktora::text || ' niedostępny w tym czasie',
			hint = 'Spróbuj dodać w innym terminie';
		return old;
	elsif exists (
		select * from harmonogram
		where "data" = new.data 
		and id_instruktora = new.id_instruktora
		and	(
			(godz_od >= new.godz_od and godz_od < new.godz_do)
			or (godz_do > new.godz_od and godz_do <= new.godz_do)
			or (godz_od <= new.godz_od and godz_do >= new.godz_do)
		)	
	) then 
		raise exception using
			errcode = 'TAKEN',
			message = 'Instruktor o id : ' || new.id_instruktora::text || ' ma inne zajęcia w tym terminie',
			hint = 'Wybierz inny termin';
		return old;
	elsif new.id_sportu is not null and new.id_sportu NOT IN 
		(select id_sportu from instruktorzy_stopnie 
		left join stopnie using(id_stopnia) 
		where id_instruktora = new.id_instruktora)
		then
			raise exception using
				errcode = 'STERR',
				message = 'Instruktor nie uczy tego sportu';
		return null;
	end if;
	return new;
end;
$harmonogram_add$ language plpgsql;
create or replace trigger harmonogram_add before insert or update on harmonogram
for each row execute procedure harmonogram_add();
--------------------------------------------------------------------------------------
create or replace  rule instruktorzy_delete as
on delete to instruktorzy
do instead nothing;
---------------------------------------------------------------------------------------
create or replace function dzieci_grupy_del()
returns trigger as
$dzieci_grupy_del$
declare
	liczba_osob int;
	licznik int;
	maks_osob int;
	wskaznik int := 0;
	chetni cursor for select * from lista_oczekujacych
	where (data_rozpoczecia, id_odznaki) = (
		select data_rozpoczecia, id_odznaki from grupy
		where id_grupy = old.id_grupy
	);
	rekord record;
begin
	liczba_osob := licznosc_grupy(old.id_grupy);
	select maks_dzieci from grupy into maks_osob where id_grupy = old.id_grupy;
	select count(*) from lista_oczekujacych into licznik
	where (data_rozpoczecia, id_odznaki) = (
		select data_rozpoczecia, id_odznaki from grupy
		where id_grupy = old.id_grupy);
	licznik := licznik;	
	if liczba_osob < maks_osob then 
		open chetni;
		while liczba_osob < maks_osob and wskaznik < licznik loop
			fetch from chetni into rekord;
			wskaznik := wskaznik + 1;
			if rekord.id_klienta in (select id_klienta from dzieci_grupy where id_grupy = old.id_grupy) then
				delete from lista_oczekujacych where current of chetni;
				continue;
			end if;
        	insert into dzieci_grupy (id_klienta, id_grupy) values (rekord.id_klienta, old.id_grupy);
        	delete from lista_oczekujacych where current of chetni;
        	liczba_osob := liczba_osob + 1;
		end loop;
		return new;
	end if;
	if liczba_osob = 0 then
		delete from grupy where id_grupy = old.id_grupy;
	end if;
	return new;
end;
$dzieci_grupy_del$ language plpgsql;
create or replace trigger dzieci_grupy_del after update or delete on dzieci_grupy
for each row execute procedure dzieci_grupy_del();
------------------------------------------------------------------------------------------
create or replace rule grupy_update as
on update to grupy
do instead nothing;
--------------------------------------------------------------------------------------------------------
create or replace function dostepnosc_sezon_tr()
returns trigger as
$dostepnosc_sezon_tr$
declare
	data_licznik date;
begin
	data_licznik := new.data_od;
	while data_licznik <= data_do loop
		if not exists(
			select * from ubezpieczenia 
			where data_licznik between data_od and data_do
			and id_instruktora = new.id_instruktora )
		then return null;
		end if;
		data_licznik := data_licznik + interval '1 day' ;
	end loop;
	return new;
end;
$dostepnosc_sezon_tr$ language plpgsql;
create or replace trigger dostepnosc_sezon_tr before update or insert on dostepnosc_sezon
for each row execute procedure dostepnosc_sezon_tr();
-----------------------------------------------------------------------------------------
create or replace function odznaki_immutability()
returns trigger as
$$
begin
	return null;
end;
$$ language plpgsql;
create or replace trigger odznaki_immutability
before insert or update or delete on odznaki
for each row execute procedure odznaki_immutability();
--------------------------------------------------------
--TODO: trigger na dodawanie dogrup, ktory sprawdza czy dziecko ma odpowiednia odznake
--sprawdzanie czy instruktor ma odpowiedni sport by prowadzic te zajecia uwu
-- kupa
---------------------------------------------------------------------
create or replace function dzieci_grupy_insert()
returns trigger as 
$dzieci_grupy_insert$
declare
	odznaka int;
begin
	select id_odznaki from grupy g into odznaka 
	where g.id_grupy = new.id_grupy;
	if max_odznaka(new.id_klienta, ( select id_sportu from odznaki where id_odznaki = odznaka  ) )+ 2 < odznaka
		then raise exception using
			errcode = 'ODERR',
			message = 'Dziecko nie ma odpowiedniej odznaki by wpisano je do grupy';
		return old;
	end if;
	return new;
end;
$dzieci_grupy_insert$ language plpgsql;
create or replace trigger dzieci_grupy_insert before insert or update on dzieci_grupy
for each row execute procedure dzieci_grupy_insert();
-----------------------------------------------------------
create or replace rule klienci_delete as
on delete to klienci
do instead nothing;
----------------------------------------------------------
 create or replace function dodaj_do_grupy(id_klienta int, id_odznaki int, data_rozpoczecia date)
returns text as
$$
declare
	ilosc_czekajacych int;
begin
	select count(*) from lista_oczekujacych into ilosc_czekajacych;
	insert into lista_oczekujacych(id_klienta, id_odznaki, data_rozpoczecia) values (id_klienta, id_odznaki, data_rozpoczecia);
	if (select count(*) from lista_oczekujacych) = ilosc_czekajacych then 
		return 'Dodano do grupy';
	else 
		return 'Dodano do poczekani';
	end if;
exception 
	when sqlstate 'ODERR' then
		return 'Dziecko nie ma odpowiedniej odznaki';
	when sqlstate 'REDUN' then
		return 'Dziecko jest juz w grupie o tych parametrach';
end;
$$ language plpgsql;
	
----------
create or replace function dodaj_grupe
	(id_instruktora int, id_odznaki int, data_rozpoczecia date, maks_dzieci int, min_dzieci int)
returns text as
$$
begin
	insert into grupy
		(id_instruktora, id_odznaki,data_rozpoczecia, maks_dzieci, min_dzieci) 
	values
		(id_instruktora, id_odznaki, data_rozpoczecia, maks_dzieci, min_dzieci);
	return 'Grupe utworzono pomyślnie';
exception
	when sqlstate 'ERRDZ' then
		return 'Za mało dzieci by utworzyć grupe';
	when sqlstate 'NDOST' then
		return 'Instruktor nie ma dostępności w tym czasie';
	when sqlstate 'STERR' then
		return 'Instruktor nie ma kwalifikacji by prowadzić tą grupe';
	when sqlstate 'TAKEN' then
		return 'Instruktor ma inne zajęcia w tym terminie';
end;
$$ language plpgsql;
-----------------------------------------------------------
create or replace rule dostepnosc_sezon_rule1 as
on  update to dostepnosc_sezon
do instead nothing;
create or replace rule dostepnosc_sezon_rule2 as
on delete to dostepnosc_sezon
do instead nothing;
----------------------------------------------------------
create or replace function nadaj_odznake(id_klienta int, id_odznaki int, data_uzysk date )
returns bool as
$$
begin
	insert into dzieci_odznaki(id_klienta, id_odznaki, data_uzysk) values
	(id_klienta, id_odznaki, data_uzysk);
	return true;
	exception
    	when others then
    		return false;
end;
$$ language plpgsql;
----------------------------------------------------------------------
