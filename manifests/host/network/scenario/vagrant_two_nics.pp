class xen::host::network::scenario::vagrant_two_nics {
  file {'setup_tmp_dir':
    ensure => directory,
    path => '/tmp/puppet_xen_module_tmp.d',
  }
  exec {'rm_tmp_dir':
    cwd => '/tmp',
    command => 'rm -rf puppet_xen_module_tmp.d',
  }
  file {'setup_functions_bash':
    source => 'puppet:///xen/functions.bash',
    path => '/tmp/puppet_xen_module_tmp.d/functions.bash',
  }
  exec {'rm_functions_bash':
    cwd => '/tmp/puppet_xen_module_tmp.d',
    command => 'rm functions.bash',
  }
  exec {'replace_eth_to_xenbr_in_interfaces_file':
    path => ['/bin', '/usr/bin'],
    command => "sed -i 's/eth/xenbr/g' /etc/network/interfaces",
  }
  exec {'replace_eth_to_xenbr_in_interfaces_d':
    path => ['/bin', '/usr/bin'],
    command => "find /etc/network/interfaces.d -type f | xargs -I {} sed -i 's/eth/xenbr/g' {}",
  }
  exec {'add_auto_manual_to_interfaces':
    path => ['/bin', '/usr/bin'],
    cwd => '/tmp/puppet_xen_module_tmp.d',
    command => "bash functions.bash aamifd",
  }
  Exec['rm_tmp_dir']->File['setup_tmp_dir']->File['setup_functions_bash']->
    Exec['replace_eth_to_xenbr_in_interfaces_file']->
    Exec['replace_etc_to_xenbr_in_interfaces_d']->
    Exec['add_auto_manual_to_interfaces']->
    Exec['rm_functions_bash']->Exec['rm_tmp_dir']
}
