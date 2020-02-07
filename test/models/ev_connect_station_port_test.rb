require 'test_helper'

class EvConnectStationPortTest < ActiveSupport::TestCase
  def test_status_changed?
    port = EvConnectStationPort.new(qr_code: 'abc123', port_status: 'AVAILABLE')
    refute port.status_changed?('AVAILABLE')
    assert port.status_changed?('CHARGING')
  end
end
