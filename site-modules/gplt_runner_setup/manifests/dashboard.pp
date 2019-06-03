# Install and configure the puppet metrics dashboard
#
# @summary Install and configure the puppet metrics dashboard
#
# @example
#   include gplt_runner_setup::dashboard
class gplt_runner_setup::dashboard {

  class { "puppet_metrics_dashboard":
    add_dashboard_examples => true,
    influxdb_database_name => ["puppet_metrics"],
    configure_telegraf     => false,
    enable_telegraf        => false
  }

  Exec <| title == "Create Systemd Temp Files" |> {
    noop => true,
  }

}
