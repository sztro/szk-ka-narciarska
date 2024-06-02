
create or replace function b_grupy_insert()
returns trigger as
$b_grupy_insert$
declare
    licznik int;
    chetni cursor for select l.id_klienta from lista_oczekujacych l
where l.data_rozpoczecia = new.data_rozpoczecia and l.id_odznaki = new.id_odznaki;
    rekord record;
    wskaźnik int := 0;
begin
    select count(*) from lista_oczekujacych into licznik
	where new.data_rozpoczecia = data_rozpoczecia and new.id_odznaki = id_odznaki;
   if licznik < new.min_dzieci then
        raise exception using
        	errcode = 'ERRDZ',
        	message = 'Nie ma wystarczająco chętnych by utworzyć grupe',
        	hint = 'Spróbuj  stworzyć grupe w innym terminie, o innym stopniu, lub poczekaj aż zapisze się wiecej osób';
        return null;
    end if;
	return new;
end;
$b_grupy_insert$ language plpgsql;
create or replace trigger grupy_insert before insert on grupy
for each row execute procedure b_grupy_insert();
---------------------------------------------------------------------------------------
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
-----------------------------------------------------------
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
create or replace function lista_oczekujacych_ins()
returns trigger as
$lista_oczekujacych_ins$
declare
	id_grp int;
begin
	if new.id_klienta in (
		select id_klienta from grupy right join dzieci_grupy using(id_grupy)
		where data_rozpoczecia = new.data_rozpoczecia and id_odznaki = new.id_odznaki)
	then return null;
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
declare
	dzieci cursor for select * from dzieci_grupy where new.id_grupy = id_grupy;
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
			errcode = 'INZAJ',
			message = 'Instruktor o id : ' || new.id_instruktora::text || ' ma inne zajęcia w tym terminie',
			hint = 'Wybierz inny termin';
		return old;
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
	licznik := licznik + liczba_osob;	
	if liczba_osob < maks_dzieci then 
		open chetni;
		while liczba_osob < maks_osob and liczba_osob < licznik loop
			fetch from chetni into rekord;
        		insert into dzieci_grupy (id_klienta, id_grupy) values (rekord.id_klienta, old.id_grupy);
        		delete from lista_oczekujacych where current of chetni;
        		liczba_osob := liczba_osob + 1;
		end loop;
	end if;
	if liczba_osob = 0 then
		delete from grupy where id_grupy = old.id_grupy;
	end if;
end;
$dzieci_grupy_del$ language plpgsql;
create or replace trigger dzieci_grupy_del after delete or update on dzieci_grupy
for each row execute procedure dzieci_grupy_del();
-------------------------------------
create or replace rule grupy_update as
on update to grupy
do instead nothing
----------------------------------------------------------------------
