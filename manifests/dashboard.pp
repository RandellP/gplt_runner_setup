# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include p9_instance_setup::dashboard
class p9_instance_setup::dashboard {

  class { 'puppet_metrics_dashboard': 
    add_dashboard_examples => true,
    influxdb_database_name => ['puppet_metrics'],
    configure_telegraf => false,
    enable_telegraf => false 
  }

  Exec <| title == 'Create Systemd Temp Files' |> {
    noop => true,
  }

}
