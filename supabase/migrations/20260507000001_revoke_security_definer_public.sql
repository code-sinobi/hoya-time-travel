-- Revoke EXECUTE from PUBLIC (the default PostgreSQL grant) so that
-- anon / authenticated roles cannot invoke these trigger-only
-- SECURITY DEFINER functions via the REST RPC endpoint.
-- DB triggers run as postgres / service_role and remain unaffected.
REVOKE EXECUTE ON FUNCTION public.handle_new_user()     FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.initialize_user_data() FROM PUBLIC;
