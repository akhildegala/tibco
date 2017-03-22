# tibco Cookbook

TODO: To monitor the tibco analytics application


### Platforms

- RHEL (>= 6.5)

### Chef

- Chef 12.0 or later

### Cookbooks

tibco
handler

## Attributes

default[:conf_file] = '/tmp/tibemsd.conf'
default[:checksum_file] = "#{Chef::Config['file_cache_path']}/tibemsd.sha1"
default[:checksum] = ''

## Parameters to monitor
default[:params][:max_msg_memory] = '2048MB'
default[:params][:ft_heartbeat] = 6
default[:params][:ft_activation] = 20
default[:params][:ft_reconnect_timeout] = 60
default[:params][:client_heartbeat_server] = 60

default[:mail][:to_address] = "akhildegala9@gmail.com"
default[:modified] = false

## Recipes

tibco::default
tibco::monitor
handler::my_own_handler

## License and Authors

Authors: Akhil Degala (<akhildegala9@gmail.com>)

