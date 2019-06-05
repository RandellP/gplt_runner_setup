# library plan for resolving the username to a calcuated default or the name passed in.
# 
plan gplt_runner_setup::determine_username (
    TargetSpec $nodes,
    String $instance_username = "",
  ) {

  if $instance_username == "" {
    $results = run_task(gplt_runner_setup::get_running_username,"localhost")
    $username = $results.first.value[_output].strip
  } else {
    $username = $instance_username
  }
  return $username
}
