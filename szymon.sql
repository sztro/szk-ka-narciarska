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

