create or replace function wstaw_do_klienci (imiee varchar(30), nazwiskoo varchar(30), kontaktt numeric(9), dataa date) 
returns bool 
as $$
begin
    insert into klienci (imie, nazwisko, kontakt, data_urodz) values
        (imiee, nazwiskoo, kontaktt, dataa);
    return true;

    exception 
    when others then return false;
end;
$$ language plpgsql;

create or replace function wstaw_do_harmonogram_nieobecnosci (id int, dataa date, godzina_od numeric(2), godzina_do numeric(2))
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