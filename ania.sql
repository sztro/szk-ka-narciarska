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

create or replace function wstaw_nieobecnosci (id int, dataa date, godzina_od numeric(2), godzina_do numeric(2))
returns bool
as $$
begin 
    insert into harmonogram (id_instruktora, "data", godz_od, godz_do, id_klienta, id_grupy, czy_nieobecnosc) VALUES
        (id, dataa, godzina_od, godzina_do, null, null, true);
    return true;

    exception 
    when others then return false;
end;
$$ language plpgsql;

create or replace function umow_konkretny(id_in int, dataa date, godzina_od int, godzina_do int, id_kli int) 
returns bool
as $$
declare
    t int;
    c int;
begin
    select into t count(*) 
    from dostepnosc_sezon
    where id_instruktora = id_in and dataa <= data_do and dataa >= data_od;
    if t != 0 then
        select into c count(*) 
        from harmonogram h 
        where id_instruktora = id_in and h.data = dataa and h.godz_od < godzina_do AND h.godz_do > godzina_od;
        
        if c != 0 then return false;
        end if;
    
        if godzina_od >= godzina_do then return false;
        end if;

        if ((godzina_od < 9) or (godzina_do > 20)) then return false;
        end if;
 
        insert into harmonogram (id_instruktora, "data", godz_od, godz_do, id_klienta, id_grupy, czy_nieobecnosc) values
            (id_in, dataa, godzina_od, godzina_do, id_kli, null, false);
        return true;
    end if;
    return false;
end;
$$ language plpgsql;

create or replace function id_klienta (i varchar(30), n varchar(30))
returns table ( id_klienta int, imie varchar(30), nazwisko varchar(30), kontakt numeric(9), data_urodz date)
as $$
begin
    return query
        select * from klienci where klienci.imie = i and klienci.nazwisko = n;
end;
$$ language plpgsql;