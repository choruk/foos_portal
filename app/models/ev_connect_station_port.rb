class EvConnectStationPort < ActiveRecord::Base
  def status_changed?(new_status)
    port_status != new_status
  end
end
