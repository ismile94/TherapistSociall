-- RPC function to set profile location from WKT string
CREATE OR REPLACE FUNCTION set_profile_location(
  p_profile_id UUID,
  p_location TEXT
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE profiles
  SET location = ST_GeomFromText(p_location, 4326)::geography
  WHERE id = p_profile_id;
END;
$$;

