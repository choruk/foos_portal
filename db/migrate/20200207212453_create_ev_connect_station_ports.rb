class CreateEvConnectStationPorts < ActiveRecord::Migration
  def change
    create_table :ev_connect_station_ports do |t|
      t.string :qr_code, null: false, unique: true
      t.string :port_status, null: false

      t.timestamps
    end
  end
end
