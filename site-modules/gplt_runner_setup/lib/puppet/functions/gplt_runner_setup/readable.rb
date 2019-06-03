# frozen_string_literal: true

# This function is in bolt 1.21 and later.  Can be removed when we are able to move to the latest bolt

# check if a file is readable 
Puppet::Functions.create_function(:'gplt_runner_setup::readable', Puppet::Functions::InternalFunction) do
  # @param filename Absolute path or Puppet file path.
  # @example Check a file on disk
  #   file::readable('/tmp/i_dumped_this_here')
  # @example check a file from the modulepath
  #   file::readable('example/files/VERSION')
  dispatch :readable do
    scope_param
    required_param 'String', :filename
    return_type 'Boolean'
  end

  def readable(scope, filename)
    found = Puppet::Parser::Files.find_file(filename, scope.compiler.environment)
    unless found && File.readable?(found)
      return false
    end
    return true
  end
end
