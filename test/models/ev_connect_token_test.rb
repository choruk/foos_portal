require 'test_helper'

class EvConnectTokenTest < ActiveSupport::TestCase
  setup do
    travel_to(Time.now)
    @token = EvConnectToken.create(access_token: 'access_token', refresh_token: 'refresh_token', expires_at: Time.now + 30)
  end

  def test_validates_presence_of_access_token
    token = EvConnectToken.new(refresh_token: 'refresh_token', expires_at: Time.now)
    assert_not_predicate token, :valid?

    token.access_token = 'access_token'
    assert_predicate token, :valid?
  end

  def test_validates_presence_of_refresh_token
    token = EvConnectToken.new(access_token: 'access_token', expires_at: Time.now)
    assert_not_predicate token, :valid?

    token.refresh_token = 'refresh_token'
    assert_predicate token, :valid?
  end

  def test_validates_presence_of_expires_at
    token = EvConnectToken.new(access_token: 'access_token', refresh_token: 'refresh_token')
    assert_not_predicate token, :valid?

    token.expires_at = Time.now
    assert_predicate token, :valid?
  end

  def test_access_token_encryption
    query = <<-SQL
      SELECT t.access_token
      FROM ev_connect_tokens t
      WHERE t.id = #{@token.id}
    SQL
    access_token_db_value = ActiveRecord::Base.connection.execute(query).first.first

    refute @token.access_token == access_token_db_value
    assert_equal @token.access_token, 'access_token'
  end

  def test_refresh_token_encryption
    query = <<-SQL
      SELECT t.refresh_token
      FROM ev_connect_tokens t
      WHERE t.id = #{@token.id}
    SQL
    refresh_token_db_value = ActiveRecord::Base.connection.execute(query).first.first

    refute @token.refresh_token == refresh_token_db_value
    assert_equal @token.refresh_token, 'refresh_token'
  end

  def test_expired?
    refute @token.expired?

    expired_token = EvConnectToken.create(access_token: 'access_token', refresh_token: 'refresh_token', expires_at: Time.now - 30)
    assert expired_token.expired?
  end
end
