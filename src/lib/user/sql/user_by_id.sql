select id, full_name, email, password_hash
from users
where id = $1;