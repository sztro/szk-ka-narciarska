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
create or replace function grupy_insert()
returns trigger as
$grupy_insert$
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
        raise exception 'za mało dzieci by utworzyć grupę';
        return null;
    end if;
    open chetni;
    insert into grupy(id_grupy, id_instuktora, id_odznaki, data_rozpoczecia, maks_dzieci, min_dzieci) values (new.id_grupy, new.id_instuktora, new.id_odznaki, new.data_rozpoczecia, new.maks_dzieci, new.min_dzieci);
    while wskaźnik < new.maks_dzieci and wskaźnik < licznik loop
        fetch from chetni into rekord;
        insert into dzieci_grupy (id_klienta, id_grupy) values (rekord.id_klienta, new.id_grupy);
        delete from lista_oczekujacych where current of chetni;
        wskaznik := wskaznik + 1;
    end loop;
    return null;
end;
$grupy_insert$ language plpgsql;
create or replace trigger grupy_insert before insert on grupy
for each row execute procedure grupy_insert();
