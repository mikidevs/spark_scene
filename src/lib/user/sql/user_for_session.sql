select u.full_name, u.email, s.expiration_time
from users u
join sessions s on u.id = s.user_id
where s.session_id = $1;
