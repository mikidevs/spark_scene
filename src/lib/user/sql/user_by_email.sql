select id, full_name, email, password_hash
from users
where email = $1;