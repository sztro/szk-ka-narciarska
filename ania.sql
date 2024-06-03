create or replace function wstaw_klienta (imiee varchar(30), nazwiskoo varchar(30), kontaktt numeric(9), dataa date) 
returns bool 
as $$
declare 
    c int;
begin
    select into c count(*) 
    from klienci 
    where imie = imiee and nazwisko = nazwiskoo and kontakt = kontaktt and data_urodz = dataa;

    if c != 0 then return false;
    end if;
    if c = 0 then
    insert into klienci (imie, nazwisko, kontakt, data_urodz) values
        (imiee, nazwiskoo, kontaktt, dataa);
    return true;
    end if;
end;
$$ language plpgsql;

------------------------------------------------------------------------------------------------------------------------------------

create or replace function wstaw_nieobecnosci (id int, dataa date, godzina_od numeric(2), godzina_do numeric(2))
returns bool
as $$
begin 
    insert into harmonogram (id_instruktora, "data", godz_od, godz_do, id_klienta, id_grupy, czy_nieobecnosc) values
        (id, dataa, godzina_od, godzina_do, null, null, true, null);
    return true;

    exception 
    when others then return false;
end;
$$ language plpgsql;

-----------------------------------------------------------------------------------------------------------------------------------

create or replace function umow_konkretny(id_in int, dataa date, godzina_od int, godzina_do int, id_kli int, id_sportu int)
returns bool
as $$
begin
   insert into harmonogram (id_instruktora, "data", godz_od, godz_do, id_klienta, id_grupy, czy_nieobecnosc, id_sportu) values
        (id_in, dataa, godzina_od, godzina_do, id_kli, null, false, id_sportu);
        return true;
        exception
            when others then return false;
end;
$$ language plpgsql;

------------------------------------------------------------------------------------------------------------------------------------

drop function if exists id_klienta (i varchar(30), n varchar(30));
create or replace function id_klienta (i varchar(30), n varchar(30))
returns table (id_klienta int, imie varchar(30), nazwisko varchar(30), kontakt numeric(9), data_urodz date, "Odznaka (narty)" varchar(20), "Odznaka (snnowboard)" varchar(20))
as $$
begin
    return query
    select *, 
    	(select o.opis from odznaki o where o.id_odznaki = max_odznaka(k.id_klienta, 1)) as "Odznaka (narty)",
    	(select o.opis from odznaki o where o.id_odznaki = max_odznaka(k.id_klienta, 2)) as "Odznaka (snnowboard)"
	from klienci k
	where k.imie = i
    and k.nazwisko = n;
end;
$$ language plpgsql;

------------------------------------------------------------------------------------------------------------------------------------
