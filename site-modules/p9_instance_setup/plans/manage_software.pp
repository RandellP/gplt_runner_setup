# Applies all the software based manifests that are used in all cases
#
plan p9_instance_setup::manage_software (
    TargetSpec $nodes,
  ) {

  # Install the puppet-agent package if Puppet is not detected.
  # Copy over custom facts from the Bolt modulepath.
  # Run the `facter` command line tool to gather node information.
  $nodes.apply_prep

  # Compile the manifest block into a catalog
  apply($nodes) {
    include p9_instance_setup::core
    include p9_instance_setup::dashboard
  }
}
