class xen::host::network::type::bridged {
  case $operatingsystem {
    'Ubuntu': {
      case $lsbdistcodename {
        'trusty', 'precise': {
          file {'setup_tmp_dir':
            ensure => directory,
            path => '/tmp/puppet_xen_module_tmp.d',
          }
          exec {'rm_tmp_dir':
            path => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'],
            cwd => '/tmp',
            command => 'rm -rf /tmp/puppet_xen_module_tmp.d',
          }
          exec {'rm_tmp_dir_final':
            path => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'],
            cwd => '/tmp',
            command => 'rm -rf /tmp/puppet_xen_module_tmp.d',
          }
          file {'setup_functions_bash':
            source => 'puppet:///modules/xen/functions.bash',
            path => '/tmp/puppet_xen_module_tmp.d/functions.bash',
          }
          exec {'rm_functions_bash':
            path => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'],
            cwd => '/tmp/puppet_xen_module_tmp.d',
            command => 'rm functions.bash',
          }
          exec {'replace_eth_to_xenbr_in_interfaces_file':
            path => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'],
            cwd => '/tmp/puppet_xen_module_tmp.d',
            command => "bash functions.bash rexif",
          }
          exec {'replace_eth_to_xenbr_in_interfaces_d':
            path => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'],
            cwd => '/tmp/puppet_xen_module_tmp.d',
            command => "bash functions.bash rexid",
          }
          exec {'add_auto_manual_to_interfaces':
            path => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'],
            cwd => '/tmp/puppet_xen_module_tmp.d',
            command => "bash functions.bash aamifd",
          }
          exec {'add_bridge_ports_to_interfaces':
            path => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'],
            cwd => '/tmp/puppet_xen_module_tmp.d',
            command => "bash functions.bash abpifd",
          }
          Exec['rm_tmp_dir']->File['setup_tmp_dir']->File['setup_functions_bash']->
            Exec['replace_eth_to_xenbr_in_interfaces_file']->
            Exec['replace_eth_to_xenbr_in_interfaces_d']->
            Exec['add_auto_manual_to_interfaces']->
            Exec['add_bridge_ports_to_interfaces']->
            Exec['rm_functions_bash']->Exec['rm_tmp_dir_final']
        }
      }
    }
  }
}
