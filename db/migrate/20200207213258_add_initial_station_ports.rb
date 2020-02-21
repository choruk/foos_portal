class AddInitialStationPorts < ActiveRecord::Migration
  def up
    EvConnectStationPort.create!(qr_code: 'TBWS05', port_status: 'AVAILABLE')
    EvConnectStationPort.create!(qr_code: 'TBWS06', port_status: 'AVAILABLE')
    EvConnectStationPort.create!(qr_code: 'TBWS07', port_status: 'AVAILABLE')
    EvConnectStationPort.create!(qr_code: 'TBWS08', port_status: 'AVAILABLE')
  end

  def down
    EvConnectStationPort.find_by(qr_code: 'TWBS05').destroy
    EvConnectStationPort.find_by(qr_code: 'TWBS06').destroy
    EvConnectStationPort.find_by(qr_code: 'TWBS07').destroy
    EvConnectStationPort.find_by(qr_code: 'TWBS08').destroy
  end
end
