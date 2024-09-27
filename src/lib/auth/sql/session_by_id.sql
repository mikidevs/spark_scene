select session_id, user_id, expiration_time
from sessions
where session_id = $1;