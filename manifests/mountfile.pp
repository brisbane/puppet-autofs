# == Define: autofs::mountfile
#
# Provide custom map file containing mounts
#
define autofs::mountfile ($mountpoint, $file_source, $automountdir='') {

  $safe_target_name = regsubst($title, '[/:\n\s\*\(\)]', '_', 'GM')

  $mountfile = "/etc/$automountdir/auto.${safe_target_name}"
 if $automountdir {
     ensure_resource('file', "/etc/$automountdir", {'ensure' => directory })
 }
#  ensure_resorce 
  
  file { $mountfile:
    ensure  => 'present',
    owner   => $autofs::config_file_owner,
    group   => $autofs::config_file_group,
    mode    => $autofs::config_file_mode,
    source  => $file_source,
    notify  => Service[$autofs::service_name],
    require => [ Package[$autofs::package_name], File["/etc/$automountdir"] ]
  }

  autofs::mountentry { $mountfile:
    mountpoint => $mountpoint,
    mountfile  => $mountfile,
  }
}
