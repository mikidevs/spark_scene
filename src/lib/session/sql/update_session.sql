update sessions
  set expiration_time = $2
  where session_id = $1;
