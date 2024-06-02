create or replace function grupy_upd_del()
returns trigger as
$grupy_update$
begin
return old;
end;
$grupy_update$ language plpgsql;
create or replace trigger grupy_upd_del
before delete or update on grupy
for each row execute procedure grupy_upd_del();
----------------------------------------------------
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
create or replace function lista_oczekujacych_tr()
returns trigger as
$lista_oczekujacych_tr$
declare
	id_grp int;
begin
	if exists(
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
$lista_oczekujacych_tr$ language plpgsql;
create or replace trigger lista_oczekujacych_tr before insert or update on lista_oczekujacych
for each row execute procedure lista_oczekujacych_tr();
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
$harmonogram_add$
create or replace trigger harmonogram_add before insert or update on harmonogram
for each row execute procedure harmonogram_add();
--------------------------------------------------------------------------------------

