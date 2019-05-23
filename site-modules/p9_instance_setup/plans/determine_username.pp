# library plan for resolving the username to a calcuated default or the name passed in.
# 
plan p9_instance_setup::determine_username (
    TargetSpec $nodes,
    String $instance_username = "",
  ) {

  if $instance_username == "" {
    $results = run_task(p9_instance_setup::get_running_username,"localhost")
    $username = $results.first.value[_output].strip
  } else {
    $username = $instance_username
  }
  return $username
}
