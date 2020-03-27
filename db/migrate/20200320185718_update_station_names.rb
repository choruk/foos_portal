class UpdateStationNames < ActiveRecord::Migration
  def up
    EvConnectStationPort.find_by(qr_code: 'TBWS05').update!(qr_code: 'TWBS05')
    EvConnectStationPort.find_by(qr_code: 'TBWS06').update!(qr_code: 'TWBS06')
    EvConnectStationPort.find_by(qr_code: 'TBWS07').update!(qr_code: 'TWBS07')
    EvConnectStationPort.find_by(qr_code: 'TBWS08').update!(qr_code: 'TWBS08')
  end

  def down
    EvConnectStationPort.find_by(qr_code: 'TWBS05').update!(qr_code: 'TBWS05')
    EvConnectStationPort.find_by(qr_code: 'TWBS06').update!(qr_code: 'TBWS06')
    EvConnectStationPort.find_by(qr_code: 'TWBS07').update!(qr_code: 'TBWS07')
    EvConnectStationPort.find_by(qr_code: 'TWBS08').update!(qr_code: 'TBWS08')
  end
end
