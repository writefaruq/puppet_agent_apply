# == Class: sssd
# Manage SSSD authentication on RHEL-based systems.
#
# === Parameters
# [*domains*]
# Required. Array. For each sssd::domain type you declare, you SHOULD also
# include the domain name here. This defines the domain lookup order.
#
# [*backends*]
# Optional. Hash. The typical way of setting up backends for SSSD is by using
# the sssd::domain defined type. That poses a problem if you want to use
# Hiera for storing your configuration data. This parameter allows you to
# pass a hash that is used to automatically instantiate sssd::domain types.
#
# [*filter_users*]
# Optional. Array. Default is 'root'. Exclude specific users from being
# fetched using sssd. This is particularly useful for system accounts.
#
# [*filter_groups*]
# Optional. Array. Default is 'root'. Exclude specific groups from being
# fetched using sssd. This is particularly useful for system accounts.
#
# [*make_home_dir*]
# (true|false) Optional. Boolean. Default is false. Enable this if you
# want network users to have a home directory created when they login.
#
# === Requires
# - [ripienaar/concat]
# - [puppetlab/stdlib]
#
# === Example
# class { 'sssd':
#   domains => [ 'somedomain.com' ],
# }
#
#
#
class sssd (
  $domains,
  $backends        = undef,
  $make_home_dir   = false,
  $sudoers  = undef,
  $join_ad  = true,  
  $login_group_allowed = undef,
  $createupn = undef,
  $createcomputer = undef,
  $ad_admin_user = undef,
  $smb_realm = undef,
  $domain_realm = undef,
  $smb_workgroup = undef,
  $host_short_name = undef,
  $host_fqdn = undef, 
  $ldap_domain = undef,
  $ldap_sasl_authid = undef,
  #$filter_users    = [ 'root' ],
  #$filter_groups   = [ 'root' ]
) {
  validate_array($domains)
  validate_array($sudoers)
  validate_array($login_group_allowed)
  validate_bool($make_home_dir)
  validate_bool($join_ad)

  #if $backends != undef {
  #  create_resources('sssd::domain', $backends)
  #}

  $sssd_pkgs = [ 'sssd', 'krb5-workstation', 'samba', 'samba-client', 'samba-common', 'oddjob-mkhomedir.x86_64' ]
  package { $sssd_pkgs:
    ensure      => installed,
  }
  
  file { 'hosts':
    path        => '/etc/hosts',
    mode        => '0644',
    content     => template('sssd/hosts.erb'),
    require     => Package[$sssd_pkgs],
  }

  file { 'sssd_conf':
    path        => '/etc/sssd/sssd.conf',
    mode        => '0600',
    content    	=> template('sssd/sssd.conf.erb'),
    # SSSD fails to start if file mode is anything other than 0600
    require     => Package[$sssd_pkgs],
  }

  file { 'krb5_conf':
    path        => '/etc/krb5.conf',
    mode        => '0644',
    content    	=> template('sssd/krb5.conf.erb'),
    require     => Package[$sssd_pkgs],
  }

  file { 'smb_conf':
    path        => '/etc/samba/smb.conf',
    mode        => '0644',
    content    	=> template('sssd/smb.conf.erb'),
    require     => Package[$sssd_pkgs],
  }
  
  file { 'sudoers':
    path        => '/etc/sudoers',
    mode        => '0644',
    content    	=> template('sssd/sudoers.erb'),
    require     => Package[$sssd_pkgs],
  }
  
  file { 'nsswitch_conf':
    path        => '/etc/nsswitch.conf',
    mode        => '0644',
    content    	=> template('sssd/nsswitch.conf.erb'),
    require     => Package[$sssd_pkgs],
  }
  
  file { 'system_auth':
    path        => '/etc/pam.d/system-auth',
    mode        => '0644',
    content    	=> template('sssd/system-auth.erb'),
    require     => Package[$sssd_pkgs],
  }

  file { 'password_auth':
    path        => '/etc/pam.d/password-auth',
    mode        => '0644',
    content    	=> template('sssd/password-auth.erb'),
    require     => Package[$sssd_pkgs],
  }
 
  file { 'login_group_allowed':
    path        => '/etc/login.group.allowed',
    mode        => '0644',
    content    	=> template('sssd/login.group.allowed.erb'),
    require     => Package[$sssd_pkgs],
  }
  

  if $make_home_dir {
    class { 'sssd::homedir': }
  }

  #if $join_ad {
  # exec { 'net-ads-join':
  #  command     => "/us/bin/net ads join createupn=$sssd::createupn createcomputer=$sssd::createcomputer -U $sssd::ad_admin_user",
  #  refreshonly => true,
  #  require     => Package[$sssd_pkgs],
  # }
  #}
  
$sssd_services = [ 'sssd', 'smb', 'oddjobd']
  service { $sssd_services:
    ensure      => running,
    enable      => true,
    #require   => Exec['net-ads-join'],
  }

  #service { 'crond':
  #  subscribe   => Service['sssd'],
  #}
}
