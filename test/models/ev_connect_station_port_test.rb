require 'test_helper'

class EvConnectStationPortTest < ActiveSupport::TestCase
  def test_validates_presence_of_qr_code
    port = EvConnectStationPort.new(port_status: 'AVAILABLE')
    assert_not_predicate port, :valid?

    port.qr_code = 'abc123'
    assert_predicate port, :valid?
  end

  def test_validates_presence_of_port_status
    port = EvConnectStationPort.new(qr_code: 'abc123')
    assert_not_predicate port, :valid?

    port.port_status = 'AVAILABLE'
    assert_predicate port, :valid?
  end

  def test_validates_uniqueness_of_qr_code
    EvConnectStationPort.create!(qr_code: 'abc123', port_status: 'AVAILABLE')

    port = EvConnectStationPort.new(qr_code: 'abc123', port_status: 'AVAILABLE')
    assert_not_predicate port, :valid?

    port.qr_code = 'abc456'
    assert_predicate port, :valid?
  end

  def test_status_changed?
    port = EvConnectStationPort.new(qr_code: 'abc123', port_status: 'AVAILABLE')
    refute port.status_changed?('AVAILABLE')
    assert port.status_changed?('CHARGING')
  end
end
