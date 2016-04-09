class xen::host::bootloader {
  notify {'xen host bootloader class reporting in!':}
  case $operatingsystem {
    'Ubuntu': {
      notify {'This is Ubuntu': }
      case  $lsbdistcodename {
        'precise': {
          notify {'This is Precise': }
          #$pattern_no_slashes = slash_escape($pattern)
          exec {'set_default_grub_menuitem_to_xen_precise':
	     path => [ '/bin', '/usr/bin' ], 
             command => "sed -i 's/GRUB_DEFAULT=.*/GRUB_DEFAULT=\"Xen 4.1-amd64\"/' /etc/default/grub"
          }
          exec {'update_grub_precise':
	    path => [ '/bin', '/usr/bin', '/usr/sbin' ],
	    command => 'update-grub'
          }
          Exec['set_default_grub_menuitem_to_xen_precise']->Exec['update_grub_precise']
	}
        'trusty': {
          notify {'This is Trusty': }
          exec {'set_default_grub_menuitem_to_xen_trusty':
	     #path => [ '/bin', '/usr/bin', '/usr/sbin' ], 
             #command => "grub-set-default 'Ubuntu GNU/Linux, with Xen hypervisor'",
	     path => [ '/bin', '/usr/bin' ], 
             command => "sed -i 's/GRUB_DEFAULT=.*/GRUB_DEFAULT=\"Ubuntu GNU\\/Linux, with Xen hypervisor\"/' /etc/default/grub"
          }
          exec {'update_grub_trusty':
	    path => [ '/bin', '/usr/bin', '/usr/sbin' ],
	    command => 'update-grub'
          }
          Exec['set_default_grub_menuitem_to_xen_trusty']->Exec['update_grub_trusty']
        }

      }
    }
  }
}
