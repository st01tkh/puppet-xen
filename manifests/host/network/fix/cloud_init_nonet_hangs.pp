class xen::host::network::fix::cloud_init_nonet_hangs {
    notify {'cloud_init_nonet_hangs started': }
    file {'place_cloud_init_nonet_hangs_fix_sh':
      source => 'puppet:///modules/xen/cloud_init_nonet_hangs_fix.sh',
      path => '/etc/network/cloud_init_nonet_hangs_fix.sh',
    } ->
    exec {'add_to_rc_local_place_cloud_init_nonet_hangs_fix_sh':
      path => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'],
      command => "grep -q -F 'cloud_init_nonet_hangs_fix.sh' /etc/rc.local || sed -i -r '/^exit 0/i /etc/network/cloud_init_nonet_hangs_fix.sh' /etc/rc.local"
    }
}
