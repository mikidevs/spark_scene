create table if not exists users (
    id serial primary key,
    full_name text not null,
    email text unique not null,
    password_hash text not null
);

create table if not exists sessions (
    session_id text primary key,
    user_email text,
    expiration_time timestamp
);