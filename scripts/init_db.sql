create table if not exists users (
    id serial primary key,
    full_name text not null,
    email text unique not null,
    password_hash text not null
);

create table if not exists sessions (
    session_id text primary key,
    user_id integer not null,
    expiration_time timestamp not null,
    constraint fk_user
        foreign key(user_id)
            references users(id)
);