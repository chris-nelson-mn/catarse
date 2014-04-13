# Be sure to restart your server when you modify this file.
require 'securerandom'
# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
def find_secure_token
  ENV['SECRET_TOKEN']
end

def find_secure_key_base
  ENV['SECRET_KEY_BASE']
end

Catarse::Application.config.secret_token = find_secure_token
Catarse::Application.config.secret_key_base = find_secure_key_base
