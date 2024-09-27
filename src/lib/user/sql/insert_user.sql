insert into users (full_name, email, password_hash)
values ($1, $2, $3)
returning id, full_name, email;