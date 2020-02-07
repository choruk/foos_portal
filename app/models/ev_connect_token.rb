class EvConnectToken < ActiveRecord::Base
  def access_token
    decrypt(super)
  end

  def access_token=(value)
    super(encrypt(value))
  end

  def refresh_token
    decrypt(super)
  end

  def refresh_token=(value)
    super(encrypt(value))
  end

  def expired?
    expires_at < Time.now
  end

  private

  def encryptor
    ActiveSupport::MessageEncryptor.new(Base64.decode64(ENV['ATTR_ENCRYPTION_KEY']))
  end

  def encrypt(value)
    encryptor.encrypt_and_sign(value)
  end

  def decrypt(value)
    encryptor.decrypt_and_verify(value)
  end
end
