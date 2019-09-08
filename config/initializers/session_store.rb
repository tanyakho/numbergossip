# Be sure to restart your server when you modify this file.

# Using the session to enable the flash, though we don't really need
# it because we only use flash.now anyway.
Numbergossip::Application.config.session_store :cookie_store, :key => '_numbergossip_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Numbergossip::Application.config.session_store :active_record_store
