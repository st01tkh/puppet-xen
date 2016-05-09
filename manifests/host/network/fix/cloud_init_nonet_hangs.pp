class xen::host::network::fix::cloud_init_nonet_hangs {
    notify {'cloud_init_nonet_hangs started': }
    file {'place_cloud_init_nonet_hangs_fix_sh':
      source => 'puppet:///modules/xen/cloud_init_nonet_hangs_fix.sh',
      path => '/etc/network/cloud_init_nonet_hangs_fix.sh',
      owner => 'root',
      group => 'root',
      mode => '0755',
    } ->
    exec {'add_to_rc_local_place_cloud_init_nonet_hangs_fix_sh':
      path => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'],
      command => "grep -q -F 'cloud_init_nonet_hangs_fix.sh' /etc/rc.local || sed -i -r '/^exit 0/i /etc/network/cloud_init_nonet_hangs_fix.sh' /etc/rc.local"
    }
    exec {'reduce_dowait_in_cloud_init_nonet_conf':
      path => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'],
      command => "sed -i 's/dowait 120/dowait 2/' /etc/init/cloud-init-nonet.conf; sed -i 's/dowait 10/dowait 1/' /etc/init/cloud-init-nonet.conf"
    }
}
