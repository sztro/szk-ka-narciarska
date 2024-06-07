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
create or replace function currentdate() returns date
as $$
begin
    return '2024-01-09'::DATE;
end;
$$ language plpgsql;
-------------------------------------------------------------------------------------------------------------------------------------
create or replace function har() returns trigger
as $$
begin
    if(new.data < currentdate()) then  return null;
    end if;
    return new;
end;
$$ language plpgsql;

create or replace function dell() returns trigger
as $$
begin
    if(old.data < currentdate()) then  return null;
    end if;
    return new;
end;
$$ language plpgsql;


create trigger harmonogram_upd
before insert or update on harmonogram
for each row
execute function har();

create trigger harmonogram_del
before delete on harmonogram
for each row
execute function dell();

create or replace function deactivate_and_delete()
returns void
as $$
begin
    alter table harmonogram disable trigger harmonogram_del;
    delete from harmonogram
    where "data" < currentdate() - interval '1 year';
    alter table harmonogram enable trigger harmonogram_del;
    return;
end;
$$ language plpgsql;
--INSERT INTO grupy (id_odznaki, data_rozpoczecia, maks_dzieci, min_dzieci) VALUES
--    (1, '2024-01-01', 7, 3),
--    (3, '2024-01-08', 7, 3),
--    (5, '2024-01-15', 7, 3),
--    (7, '2024-01-22', 7, 3),
--    (9, '2023-01-29', 7, 3),
--    (2, '2024-01-01', 7, 3),
--    (4, '2024-01-08', 7, 3),
--    (6, '2024-01-15', 7, 3),
--    (8, '2024-01-22', 7, 3),
--    (10, '2023-01-29', 7, 3);
--7 - 26 narty
--32 - 46 snnowboard
--120 - 220 klienci
insert into harmonogram (id_instruktora, "data", godz_od, godz_do, id_klienta, id_grupy, czy_nieobecnosc, id_sportu) values
	(8, '2024-01-01', 9, 12, null, 1, false, 1),
	(8, '2024-01-02', 9, 12, null, 1, false, 1),
	(8, '2024-01-03', 9, 12, null, 1, false, 1),
	(8, '2024-01-04', 9, 12, null, 1, false, 1),
	(8, '2024-01-05', 9, 12, null, 1, false, 1),
	(33, '2024-01-01', 9, 12, null, 6, false, 2),
	(33, '2024-01-02', 9, 12, null, 6, false, 2),
	(33, '2024-01-03', 9, 12, null, 6, false, 2),
	(33, '2024-01-04', 9, 12, null, 6, false, 2),
	(33, '2024-01-05', 9, 12, null, 6, false, 2),
	(8, '2024-01-08', 9, 12, null, 2, false, 1),
	(8, '2024-01-09', 9, 12, null, 2, false, 1),
	(8, '2024-01-10', 9, 12, null, 2, false, 1),
	(8, '2024-01-11', 9, 12, null, 2, false, 1),
	(8, '2024-01-12', 9, 12, null, 2, false, 1),
	(34, '2024-01-08', 9, 12, null, 7, false, 2),
	(34, '2024-01-09', 9, 12, null, 7, false, 2),
	(34, '2024-01-10', 9, 12, null, 7, false, 2),
	(34, '2024-01-11', 9, 12, null, 7, false, 2),
	(34, '2024-01-12', 9, 12, null, 7, false, 2),
	(9, '2024-01-15', 9, 12, null, 3, false, 1),
	(9, '2024-01-16', 9, 12, null, 3, false, 1),
	(9, '2024-01-17', 9, 12, null, 3, false, 1),
	(9, '2024-01-18', 9, 12, null, 3, false, 1),
	(9, '2024-01-19', 9, 12, null, 3, false, 1),
	(35, '2024-01-15', 9, 12, null, 8, false, 2),
	(35, '2024-01-16', 9, 12, null, 8, false, 2),
	(35, '2024-01-17', 9, 12, null, 8, false, 2),
	(35, '2024-01-18', 9, 12, null, 8, false, 2),
	(35, '2024-01-19', 9, 12, null, 8, false, 2),
	(10, '2024-01-22', 9, 12, null, 4, false, 1),
	(10, '2024-01-23', 9, 12, null, 4, false, 1),
	(10, '2024-01-24', 9, 12, null, 4, false, 1),
	(10, '2024-01-25', 9, 12, null, 4, false, 1),
	(10, '2024-01-26', 9, 12, null, 4, false, 1),
	(33, '2024-01-22', 9, 12, null, 9, false, 2),
	(33, '2024-01-23', 9, 12, null, 9, false, 2),
	(33, '2024-01-24', 9, 12, null, 9, false, 2),
	(33, '2024-01-25', 9, 12, null, 9, false, 2),
	(33, '2024-01-26', 9, 12, null, 9, false, 2),
	(11, '2024-01-29', 9, 12, null, 5, false, 1),
	(11, '2024-01-30', 9, 12, null, 5, false, 1),
	(11, '2024-01-31', 9, 12, null, 5, false, 1),
	(11, '2024-02-01', 9, 12, null, 5, false, 1),
	(11, '2024-02-02', 9, 12, null, 5, false, 1),
	(32, '2024-01-29', 9, 12, null, 10, false, 2),
	(32, '2024-01-30', 9, 12, null, 10, false, 2),
	(32, '2024-01-31', 9, 12, null, 10, false, 2),
	(32, '2024-02-01', 9, 12, null, 10, false, 2),
	(32, '2024-02-02', 9, 12, null, 10, false, 2),
	(8, '2024-01-01', 12, 14, 260, null, false, 1),
	(8, '2024-01-01', 14, 15, null, null, true, null),
	(8, '2024-01-01', 15, 17, 261, null, false, 1),
	(8, '2024-01-01', 18, 20, 262, null, false, 1),
	(9, '2024-01-01', 12, 13, 263, null, false, 1),
	(9, '2024-01-01', 13, 14, null, null, true, null),
	(9, '2024-01-01', 15, 17, 264, null, false, 1),
	(9, '2024-01-01', 17, 19, 265, null, false, 1),
	(10, '2024-01-01', 12, 15, 266, null, false, 1),
	(10, '2024-01-01', 15, 16, null, null, true, null),
	(10, '2024-01-01', 16, 18, 267, null, false, 1),
	(10, '2024-01-01', 18, 20, 268, null, false, 1),
	(11, '2024-01-01', 13, 14, 269, null, false, 1),
	(11, '2024-01-01', 14, 15, null, null, true, null),
	(11, '2024-01-01', 15, 17, 270, null, false, 1),
	(11, '2024-01-01', 17, 19, 271, null, false, 1),
	(33, '2024-01-01', 12, 13, 272, null, false, 2),
	(33, '2024-01-01', 13, 14, null, null, true, null),
	(33, '2024-01-01', 14, 16, 273, null, false, 2),
	(33, '2024-01-01', 17, 20, 274, null, false, 2),
	(34, '2024-01-01', 12, 14, 275, null, false, 2),
	(34, '2024-01-01', 14, 15, null, null, true, null),
	(34, '2024-01-01', 15, 17, 276, null, false, 2),
	(34, '2024-01-01', 18, 20, 277, null, false, 2),
	(35, '2024-01-01', 12, 15, 281, null, false, 2),
	(35, '2024-01-01', 15, 16, null, null, true, null),
	(35, '2024-01-01', 16, 18, 282, null, false, 2),
	(35, '2024-01-01', 18, 20, 283, null, false, 2),
	(36, '2024-01-01', 13, 14, 284, null, false, 2),
	(36, '2024-01-01', 14, 15, null, null, true, null),
	(36, '2024-01-01', 15, 17, 285, null, false, 2),
	(36, '2024-01-01', 17, 19, 286, null, false, 2),
	(37, '2024-01-01', 12, 14, 287, null, false, 2),
	(37, '2024-01-01', 14, 15, null, null, true, null),
	(37, '2024-01-01', 15, 18, 288, null, false, 2),
	(37, '2024-01-01', 18, 20, 289, null, false, 2),
	(12, '2024-01-01', 9, 11, 150, null, false, 1),
	(12, '2024-01-01', 12, 14, 151, null, false, 1),
	(12, '2024-01-01', 15, 16, null, null, true, null),
	(12, '2024-01-01', 16, 17, 152, null, false, 1),
	(12, '2024-01-01', 18, 20, 153, null, false, 1),
	(13, '2024-01-01', 9, 11, 154, null, false, 1),
	(13, '2024-01-01', 12, 14, 155, null, false, 1),
	(13, '2024-01-01', 15, 16, null, null, true, null),
	(13, '2024-01-01', 16, 18, 156, null, false, 1),
	(13, '2024-01-01', 18, 19, 157, null, false, 1),
	(14, '2024-01-01', 10, 12, 158, null, false, 1),
	(14, '2024-01-01', 12, 13, 159, null, false, 1),
	(14, '2024-01-01', 14, 15, null, null, true, null),
	(14, '2024-01-01', 15, 17, 160, null, false, 1),
	(14, '2024-01-01', 17, 20, 161, null, false, 1),
	(15, '2024-01-01', 11, 12, 162, null, false, 1),
	(15, '2024-01-01', 12, 14, 163, null, false, 1),
	(15, '2024-01-01', 15, 16, null, null, true, null),
	(15, '2024-01-01', 16, 17, 164, null, false, 1),
	(15, '2024-01-01', 18, 20, 165, null, false, 1),
	(15, '2024-01-01', 9, 11, 166, null, false, 1),
	(16, '2024-01-01', 12, 14, 167, null, false, 1),
	(16, '2024-01-01', 15, 16, null, null, true, null),
	(16, '2024-01-01', 16, 18, 168, null, false, 1),
	(16, '2024-01-01', 18, 19, 169, null, false, 1),
	(17, '2024-01-01', 9, 11, 170, null, false, 1),
	(17, '2024-01-01', 12, 13, 171, null, false, 1),
	(17, '2024-01-01', 14, 15, null, null, true, null),
	(17, '2024-01-01', 15, 17, 172, null, false, 1),
	(17, '2024-01-01', 17, 20, 173, null, false, 1),
	(18, '2024-01-01', 9, 11, 174, null, false, 1),
	(18, '2024-01-01', 12, 14, 175, null, false, 1),
	(18, '2024-01-01', 15, 16, null, null, true, null),
	(18, '2024-01-01', 16, 17, 176, null, false, 1),
	(18, '2024-01-01', 18, 20, 177, null, false, 1),
	(19, '2024-01-01', 9, 11, 178, null, false, 1),
	(19, '2024-01-01', 12, 13, 179, null, false, 1),
	(19, '2024-01-01', 14, 15, null, null, true, null),
	(19, '2024-01-01', 15, 17, 180, null, false, 1),
	(19, '2024-01-01', 18, 19, 181, null, false, 1),
	(20, '2024-01-01', 9, 11, 182, null, false, 1),
	(20, '2024-01-01', 12, 13, 183, null, false, 1),
	(20, '2024-01-01', 14, 15, null, null, true, null),
	(20, '2024-01-01', 15, 17, 184, null, false, 1),
	(20, '2024-01-01', 17, 20, 185, null, false, 1),
	(21, '2024-01-01', 9, 11, 186, null, false, 1),
	(21, '2024-01-01', 12, 14, 187, null, false, 1),
	(21, '2024-01-01', 15, 16, null, null, true, null),
	(21, '2024-01-01', 16, 17, 188, null, false, 1),
	(21, '2024-01-01', 18, 20, 189, null, false, 1),
	(22, '2024-01-01', 9, 11, 190, null, false, 1),
	(22, '2024-01-01', 12, 14, 191, null, false, 1),
	(22, '2024-01-01', 15, 16, null, null, true, null),
	(22, '2024-01-01', 16, 18, 192, null, false, 1),
	(22, '2024-01-01', 18, 19, 193, null, false, 1),
	(23, '2024-01-01', 9, 11, 194, null, false, 1),
	(23, '2024-01-01', 12, 13, 195, null, false, 1),
	(23, '2024-01-01', 14, 15, null, null, true, null),
	(23, '2024-01-01', 15, 17, 196, null, false, 1),
	(23, '2024-01-01', 17, 20, 197, null, false, 1),
	(24, '2024-01-01', 9, 11, 198, null, false, 1),
	(24, '2024-01-01', 12, 14, 199, null, false, 1),
	(24, '2024-01-01', 15, 16, null, null, true, null),
	(24, '2024-01-01', 16, 17, 200, null, false, 1),
	(24, '2024-01-01', 18, 20, 201, null, false, 1),
	(25, '2024-01-01', 9, 12, 202, null, false, 1),
	(25, '2024-01-01', 12, 14, 203, null, false, 1),
	(25, '2024-01-01', 15, 16, null, null, true, null),
	(25, '2024-01-01', 16, 18, 204, null, false, 1),
	(25, '2024-01-01', 18, 19, 205, null, false, 1),
	(26, '2024-01-01', 9, 11, 206, null, false, 1),
	(26, '2024-01-01', 12, 13, 207, null, false, 1),
	(26, '2024-01-01', 14, 15, null, null, true, null),
	(26, '2024-01-01', 15, 17, 208, null, false, 1),
	(26, '2024-01-01', 17, 20, 209, null, false, 1),
	(37, '2024-01-01', 9, 11, 210, null, false, 2),
	(32, '2024-01-01', 12, 14, 211, null, false, 2),
	(32, '2024-01-01', 15, 16, null, null, true, null),
	(32, '2024-01-01', 16, 17, 212, null, false, 2),
	(32, '2024-01-01', 18, 20, 213, null, false, 2),
	(38, '2024-01-01', 9, 10, 234, null, false, 2),
	(38, '2024-01-01', 11, 14, 235, null, false, 2),
	(38, '2024-01-01', 14, 15, null, null, true, null),
	(38, '2024-01-01', 15, 17, 236, null, false, 2),
	(38, '2024-01-01', 17, 19, 237, null, false, 2),
	(39, '2024-01-01', 9, 11, 238, null, false, 2),
	(39, '2024-01-01', 12, 13, 239, null, false, 2),
	(39, '2024-01-01', 14, 16, null, null, true, null),
	(39, '2024-01-01', 17, 18, 240, null, false, 2),
	(39, '2024-01-01', 18, 19, 241, null, false, 2),
	(40, '2024-01-01', 9, 11, 242, null, false, 2),
	(40, '2024-01-01', 12, 13, 243, null, false, 2),
	(40, '2024-01-01', 14, 15, null, null, true, null),
	(40, '2024-01-01', 15, 17, 244, null, false, 2),
	(40, '2024-01-01', 17, 20, 245, null, false, 2),
	(41, '2024-01-01', 9, 11, 246, null, false, 2),
	(41, '2024-01-01', 12, 13, 247, null, false, 2),
	(41, '2024-01-01', 14, 15, null, null, true, null),
	(41, '2024-01-01', 15, 17, 248, null, false, 2),
	(41, '2024-01-01', 17, 20, 249, null, false, 2),
	(42, '2024-01-01', 9, 11, 250, null, false, 2),
	(42, '2024-01-01', 12, 13, 251, null, false, 2),
	(42, '2024-01-01', 13, 14, null, null, true, null),
	(42, '2024-01-01', 14, 16, 252, null, false, 2),
	(42, '2024-01-01', 17, 19, 253, null, false, 2),
	(43, '2024-01-01', 9, 11, 254, null, false, 2),
	(43, '2024-01-01', 12, 13, 255, null, false, 2),
	(43, '2024-01-01', 14, 15, null, null, true, null),
	(43, '2024-01-01', 15, 17, 256, null, false, 2),
	(43, '2024-01-01', 17, 18, 257, null, false, 2),
	(44, '2024-01-01', 9, 11, 258, null, false, 2),
	(44, '2024-01-01', 12, 13, 259, null, false, 2),
	(44, '2024-01-01', 14, 15, null, null, true, null),
	(44, '2024-01-01', 15, 16, 260, null, false, 2),
	(44, '2024-01-01', 17, 20, 261, null, false, 2),
	(45, '2024-01-01', 9, 10, 262, null, false, 2),
	(45, '2024-01-01', 12, 13, 263, null, false, 2),
	(45, '2024-01-01', 14, 15, null, null, true, null),
	(45, '2024-01-01', 15, 17, 264, null, false, 2),
	(45, '2024-01-01', 17, 20, 265, null, false, 2),
	(46, '2024-01-01', 9, 12, 262, null, false, 2),
	(46, '2024-01-01', 12, 13, 263, null, false, 2),
	(46, '2024-01-01', 14, 15, null, null, true, null),
	(46, '2024-01-01', 15, 17, 264, null, false, 2),
	(46, '2024-01-01', 17, 19, 265, null, false, 2),
	(27, '2024-01-01', 9, 11, 430, null, false, 2),
	(27, '2024-01-01', 11, 12, 420, null, false, 2),
	(27, '2024-01-01', 12, 13, 450, null, false, 2),
	(27, '2024-01-01', 14, 15, null, null, true, null),
	(27, '2024-01-01', 16, 17, 451, null, false, 2),
	(27, '2024-01-01', 17, 20, null, null, true, null),
	(8, '2024-01-04', 12, 14, 260, null, false, 1),
	(8, '2024-01-04', 14, 15, null, null, true, null),
	(8, '2024-01-04', 15, 17, 261, null, false, 1),
	(8, '2024-01-04', 18, 20, 262, null, false, 1),
	(9, '2024-01-04', 12, 13, 263, null, false, 1),
	(9, '2024-01-04', 13, 14, null, null, true, null),
	(9, '2024-01-04', 15, 17, 264, null, false, 1),
	(9, '2024-01-04', 17, 19, 265, null, false, 1),
	(10, '2024-01-04', 12, 15, 266, null, false, 1),
	(10, '2024-01-04', 15, 16, null, null, true, null),
	(10, '2024-01-04', 16, 18, 267, null, false, 1),
	(10, '2024-01-04', 18, 20, 268, null, false, 1),
	(11, '2024-01-04', 13, 14, 269, null, false, 1),
	(11, '2024-01-04', 14, 15, null, null, true, null),
	(11, '2024-01-04', 15, 17, 270, null, false, 1),
	(11, '2024-01-04', 17, 19, 271, null, false, 1),
	(33, '2024-01-04', 12, 13, 272, null, false, 2),
	(33, '2024-01-04', 13, 14, null, null, true, null),
	(33, '2024-01-04', 14, 16, 273, null, false, 2),
	(33, '2024-01-04', 17, 20, 274, null, false, 2),
	(34, '2024-01-04', 12, 13, 278, null, false, 2),
	(34, '2024-01-04', 13, 14, null, null, true, null),
	(34, '2024-01-04', 15, 17, 279, null, false, 2),
	(34, '2024-01-04', 17, 19, 280, null, false, 2),
	(35, '2024-01-04', 12, 15, 281, null, false, 2),
	(35, '2024-01-04', 15, 16, null, null, true, null),
	(35, '2024-01-04', 16, 18, 282, null, false, 2),
	(35, '2024-01-04', 18, 20, 283, null, false, 2),
	(36, '2024-01-04', 13, 14, 284, null, false, 2),
	(36, '2024-01-04', 14, 15, null, null, true, null),
	(36, '2024-01-04', 15, 17, 289, null, false, 2),
	(36, '2024-01-04', 17, 19, 290, null, false, 2),
	(37, '2024-01-04', 12, 14, 285, null, false, 2),
	(37, '2024-01-04', 14, 15, null, null, true, null),
	(37, '2024-01-04', 15, 18, 286, null, false, 2),
	(37, '2024-01-04', 18, 20, 287, null, false, 2),
	(12, '2024-01-04', 9, 11, 150, null, false, 1),
	(12, '2024-01-04', 12, 14, 151, null, false, 1),
	(12, '2024-01-04', 15, 16, null, null, true, null),
	(12, '2024-01-04', 16, 17, 152, null, false, 1),
	(12, '2024-01-04', 18, 20, 153, null, false, 1),
	(13, '2024-01-04', 9, 11, 154, null, false, 1),
	(13, '2024-01-04', 12, 14, 155, null, false, 1),
	(13, '2024-01-04', 15, 16, null, null, true, null),
	(13, '2024-01-04', 16, 18, 156, null, false, 1),
	(13, '2024-01-04', 18, 19, 157, null, false, 1),
	(14, '2024-01-04', 10, 12, 158, null, false, 1),
	(14, '2024-01-04', 12, 13, 159, null, false, 1),
	(14, '2024-01-04', 14, 15, null, null, true, null),
	(14, '2024-01-04', 15, 17, 160, null, false, 1),
	(14, '2024-01-04', 17, 20, 161, null, false, 1),
	(15, '2024-01-04', 11, 12, 162, null, false, 1),
	(15, '2024-01-04', 12, 14, 163, null, false, 1),
	(15, '2024-01-04', 15, 16, null, null, true, null),
	(15, '2024-01-04', 16, 17, 164, null, false, 1),
	(15, '2024-01-04', 18, 20, 165, null, false, 1),
	(15, '2024-01-04', 9, 11, 166, null, false, 1),
	(16, '2024-01-04', 12, 14, 167, null, false, 1),
	(16, '2024-01-04', 15, 16, null, null, true, null),
	(16, '2024-01-04', 16, 18, 168, null, false, 1),
	(16, '2024-01-04', 18, 19, 169, null, false, 1),
	(17, '2024-01-04', 9, 11, 170, null, false, 1),
	(17, '2024-01-04', 12, 13, 171, null, false, 1),
	(17, '2024-01-04', 14, 15, null, null, true, null),
	(17, '2024-01-04', 15, 17, 172, null, false, 1),
	(17, '2024-01-04', 17, 20, 173, null, false, 1),
	(18, '2024-01-04', 9, 11, 174, null, false, 1),
	(18, '2024-01-04', 12, 14, 175, null, false, 1),
	(18, '2024-01-04', 15, 16, null, null, true, null),
	(18, '2024-01-04', 16, 17, 176, null, false, 1),
	(18, '2024-01-04', 18, 20, 177, null, false, 1),
	(19, '2024-01-04', 9, 11, 178, null, false, 1),
	(19, '2024-01-04', 12, 13, 179, null, false, 1),
	(19, '2024-01-04', 14, 15, null, null, true, null),
	(19, '2024-01-04', 15, 17, 180, null, false, 1),
	(19, '2024-01-04', 18, 19, 181, null, false, 1),
	(20, '2024-01-04', 9, 11, 182, null, false, 1),
	(20, '2024-01-04', 12, 13, 183, null, false, 1),
	(20, '2024-01-04', 14, 15, null, null, true, null),
	(20, '2024-01-04', 15, 17, 184, null, false, 1),
	(20, '2024-01-04', 17, 20, 185, null, false, 1),
	(21, '2024-01-04', 9, 11, 186, null, false, 1),
	(21, '2024-01-04', 12, 14, 187, null, false, 1),
	(21, '2024-01-04', 15, 16, null, null, true, null),
	(21, '2024-01-04', 16, 17, 188, null, false, 1),
	(21, '2024-01-04', 18, 20, 189, null, false, 1),
	(22, '2024-01-04', 9, 11, 190, null, false, 1),
	(22, '2024-01-04', 12, 14, 191, null, false, 1),
	(22, '2024-01-04', 15, 16, null, null, true, null),
	(22, '2024-01-04', 16, 18, 192, null, false, 1),
	(22, '2024-01-04', 18, 19, 193, null, false, 1),
	(23, '2024-01-04', 9, 11, 194, null, false, 1),
	(23, '2024-01-04', 12, 13, 195, null, false, 1),
	(23, '2024-01-04', 14, 15, null, null, true, null),
	(23, '2024-01-04', 15, 17, 196, null, false, 1),
	(23, '2024-01-04', 17, 20, 197, null, false, 1),
	(24, '2024-01-04', 9, 11, 198, null, false, 1),
	(24, '2024-01-04', 12, 14, 199, null, false, 1),
	(24, '2024-01-04', 15, 16, null, null, true, null),
	(24, '2024-01-04', 16, 17, 200, null, false, 1),
	(24, '2024-01-04', 18, 20, 201, null, false, 1),
	(25, '2024-01-04', 9, 12, 202, null, false, 1),
	(25, '2024-01-04', 12, 14, 203, null, false, 1),
	(25, '2024-01-04', 15, 16, null, null, true, null),
	(25, '2024-01-04', 16, 18, 204, null, false, 1),
	(25, '2024-01-04', 18, 19, 205, null, false, 1),
	(26, '2024-01-04', 9, 11, 206, null, false, 1),
	(26, '2024-01-04', 12, 13, 207, null, false, 1),
	(26, '2024-01-04', 14, 15, null, null, true, null),
	(26, '2024-01-04', 15, 17, 208, null, false, 1),
	(26, '2024-01-04', 17, 20, 209, null, false, 1),
	(37, '2024-01-04', 9, 11, 210, null, false, 2),
	(32, '2024-01-04', 12, 14, 211, null, false, 2),
	(32, '2024-01-04', 15, 16, null, null, true, null),
	(32, '2024-01-04', 16, 17, 212, null, false, 2),
	(32, '2024-01-04', 18, 20, 213, null, false, 2),
	(38, '2024-01-04', 9, 10, 234, null, false, 2),
	(38, '2024-01-04', 11, 14, 235, null, false, 2),
	(38, '2024-01-04', 14, 15, null, null, true, null),
	(38, '2024-01-04', 15, 17, 236, null, false, 2),
	(38, '2024-01-04', 17, 19, 237, null, false, 2),
	(39, '2024-01-04', 9, 11, 238, null, false, 2),
	(39, '2024-01-04', 12, 13, 239, null, false, 2),
	(39, '2024-01-04', 14, 16, null, null, true, null),
	(39, '2024-01-04', 17, 18, 240, null, false, 2),
	(39, '2024-01-04', 18, 19, 241, null, false, 2),
	(40, '2024-01-04', 9, 11, 242, null, false, 2),
	(40, '2024-01-04', 12, 13, 243, null, false, 2),
	(40, '2024-01-04', 14, 15, null, null, true, null),
	(40, '2024-01-04', 15, 17, 244, null, false, 2),
	(40, '2024-01-04', 17, 20, 245, null, false, 2),
	(41, '2024-01-04', 9, 11, 246, null, false, 2),
	(41, '2024-01-04', 12, 13, 247, null, false, 2),
	(41, '2024-01-04', 14, 15, null, null, true, null),
	(41, '2024-01-04', 15, 17, 248, null, false, 2),
	(41, '2024-01-04', 17, 20, 249, null, false, 2),
	(42, '2024-01-04', 9, 11, 250, null, false, 2),
	(42, '2024-01-04', 12, 13, 251, null, false, 2),
	(42, '2024-01-04', 13, 14, null, null, true, null),
	(42, '2024-01-04', 14, 16, 252, null, false, 2),
	(42, '2024-01-04', 17, 19, 253, null, false, 2),
	(43, '2024-01-04', 9, 11, 254, null, false, 2),
	(43, '2024-01-04', 12, 13, 255, null, false, 2),
	(43, '2024-01-04', 14, 15, null, null, true, null),
	(43, '2024-01-04', 15, 17, 256, null, false, 2),
	(43, '2024-01-04', 17, 18, 257, null, false, 2),
	(44, '2024-01-04', 9, 11, 258, null, false, 2),
	(44, '2024-01-04', 12, 13, 259, null, false, 2),
	(44, '2024-01-04', 14, 15, null, null, true, null),
	(44, '2024-01-04', 15, 16, 260, null, false, 2),
	(44, '2024-01-04', 17, 20, 261, null, false, 2),
	(45, '2024-01-04', 9, 10, 262, null, false, 2),
	(45, '2024-01-04', 12, 13, 263, null, false, 2),
	(45, '2024-01-04', 14, 15, null, null, true, null),
	(45, '2024-01-04', 15, 17, 264, null, false, 2),
	(45, '2024-01-04', 17, 20, 265, null, false, 2),
	(46, '2024-01-04', 9, 12, 262, null, false, 2),
	(46, '2024-01-04', 12, 13, 263, null, false, 2),
	(46, '2024-01-04', 14, 15, null, null, true, null),
	(46, '2024-01-04', 15, 17, 264, null, false, 2),
	(46, '2024-01-04', 17, 19, 265, null, false, 2),
	(27, '2024-01-04', 9, 11, 430, null, false, 2),
	(27, '2024-01-04', 11, 12, 420, null, false, 2),
	(27, '2024-01-04', 12, 13, 450, null, false, 2),
	(27, '2024-01-04', 14, 15, null, null, true, null),
	(27, '2024-01-04', 16, 17, 451, null, false, 2),
	(27, '2024-01-04', 17, 20, null, null, true, null);

INSERT INTO dzieci_odznaki(id_klienta, id_odznaki, data_uzysk) VALUES
    (120, 1,'2024-01-06'),
    (121, 1,'2024-01-06'),
    (122, 1,'2024-01-06'),
    (135, 2,'2024-01-06'),
    (136, 2,'2024-01-06'),
    (137, 2,'2024-01-06'),
    (123, 3,'2024-01-13'),
    (124, 3,'2024-01-13'),
    (125, 3,'2024-01-13'),
    (138, 4,'2024-01-13'),
    (139, 4,'2024-01-13'),
    (140, 4,'2024-01-13'),
    (126, 5,'2024-01-20'),
    (127, 5,'2024-01-20'),
    (128, 5,'2024-01-20'),
    (141, 6,'2024-01-20'),
    (142, 6,'2024-01-20'),
    (143, 6,'2024-01-20'),
    (129, 7,'2024-01-27'),
    (130, 7,'2024-01-27'),
    (131, 7,'2024-01-27'),
    (144, 8,'2024-01-27'),
    (145, 8,'2024-01-27'),
    (146, 8,'2024-01-27'),
    (132, 9,'2024-02-03'),
    (133, 9,'2024-02-03'),
    (134, 9,'2024-02-03'),
    (147, 10,'2024-02-03'),
    (148, 10,'2024-02-03'),
    (149, 10,'2024-02-03');
   
INSERT INTO dzieci_grupy (id_klienta, id_grupy) VALUES
    (120,1),
    (121,1),
    (122,1),
    (123,2),
    (124,2),
    (125,2),
    (126,3),
    (127,3),
    (128,3),
    (129,4),
    (130,4),
    (131,4),
    (132,5),
    (133,5),
    (134,5),
    (135,6),
    (136,6),
    (137,6),
    (138,7),
    (139,7),
    (140,7),
    (141,8),
    (142,8),
    (143,8),
    (144,9),
    (145,9),
    (146,9),
    (147,10),
    (148,10),
    (149,10);



