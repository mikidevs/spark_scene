update users
set full_name = $2, email = $3, password_hash = $4
where id = $1;