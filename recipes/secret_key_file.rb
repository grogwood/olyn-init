# Setup Chef directory permissions
directory node[:olyn_init][:chef][:config][:dir] do
  owner 'root'
  group 'root'
  mode 0700
end

# Load the secret key file data bag item
secret_key_file = data_bag_item('chef_configs', node[:olyn_init][:secret_key_file][:data_bag_item])

# The full path to the secret key file
secret_key_file_path = "#{Chef::Config[:olyn_provision_path]}/#{secret_key_file[:source]}"

# Install the secret key file
remote_file node[:olyn_init][:secret_key_file][:path] do
  source "file://#{secret_key_file_path}"
  owner 'root'
  group 'root'
  mode 0600
  sensitive true
  only_if { File.exist?(secret_key_file_path) }
end

# Remove the secret key file original source
file secret_key_file_path do
  action :delete
  not_if { secret_key_file[:source].nil? }
  only_if { File.exist?(secret_key_file_path) }
end
