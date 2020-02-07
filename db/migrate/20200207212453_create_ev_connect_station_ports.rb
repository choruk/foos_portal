class CreateEvConnectStationPorts < ActiveRecord::Migration
  def change
    create_table :ev_connect_station_ports do |t|
      t.string :qr_code
      t.string :port_status

      t.timestamps
    end
  end
end
