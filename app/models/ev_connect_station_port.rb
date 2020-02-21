class EvConnectStationPort < ActiveRecord::Base
  validates_presence_of :qr_code, :port_status
  validates_uniqueness_of :qr_code

  def status_changed?(new_status)
    port_status != new_status
  end
end
