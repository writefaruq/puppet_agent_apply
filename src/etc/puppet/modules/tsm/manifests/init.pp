# Class for tsm clients
class tsm (
  $tsmserver = undef,
  $nodename = undef,
  $tsmpassword = undef,
) {
    include tsm::centos
    include tsm::common
}

class tsm::centos {

   exec { "gskcrypt64":
		command => ['/usr/bin/yum install --nogpgcheck gskcrypt64 -y'],
   }
   exec { "gskssl64":
		command => ['/usr/bin/yum install --nogpgcheck gskssl64 -y'],
                require     => Exec["gskcrypt64"],
   }
   exec { "TIVsm-API64":
	        command => ['/usr/bin/yum install --nogpgcheck TIVsm-API64 -y'],
                require => [ Exec["gskssl64"], ],
   }
   exec { "TIVsm-BA":
		command => ['/usr/bin/yum install --nogpgcheck TIVsm-BA -y'],
       		require => [ Exec["gskcrypt64"], Exec["TIVsm-API64"] ],
   }


    file { "tsm_client_init":
        ensure  => present,
        owner   => "root",
        group   => "root",
        mode    => "755",
        path    => "/etc/init.d/dsmcad",
        source  => "puppet:///modules/tsm/dsmcad-centos",
        require =>  [ 	Exec["TIVsm-BA"],
                      	Exec["TIVsm-API64"],
                	File["/var/log/tsm"],
                	File["/opt/tivoli/tsm/client/ba/bin/dsm.opt"],
                	File["/opt/tivoli/tsm/client/ba/bin/dsm.sys"]
		    ],
            
    } # file
} # class

class tsm::common {

    service { "dsmcad":
        subscribe   => [ File["/opt/tivoli/tsm/client/ba/bin/dsm.sys"], File["/opt/tivoli/tsm/client/ba/bin/dsm.opt"] ],
        ensure      => running,
        enable      => true,
        pattern     => "dsmcad",
    }

    file { "/var/log/tsm":
        ensure => directory,
        owner  => "root",
        group  => "root",
    }

    file { "/opt/tivoli/tsm/client/ba/bin/dsm.opt":
        owner   => "root",
        group   => "bin",
        mode    => "0644",
        require => Exec["TIVsm-BA"],
        content => template("tsm/dsm.opt.erb"),
    }

    file { "/opt/tivoli/tsm/client/ba/bin/dsm.sys":
        owner   => root,
        group   => bin,
        mode    => "0644",
        require => File["/opt/tivoli/tsm/client/ba/bin/dsm.opt"],
        content => template("tsm/dsm.sys.erb"),
    }
   
    file { "/opt/tivoli/tsm/client/ba/bin/backup.inclexcl":
        owner   => root,
        group   => bin,
        mode    => "0644",
        require => File["/opt/tivoli/tsm/client/ba/bin/dsm.sys"],
        content => template("tsm/backup.inclexcl.erb"),
    }



    file { "/etc/profile.d/dsmcad-paths.sh":
        owner   => root,
        group   => root,
        mode    => "0644",
        require => File["/opt/tivoli/tsm/client/ba/bin/dsm.sys"],
        source => "puppet:///modules/tsm/dsmcad-paths.sh",
    }

    # Check TSM password is valid and update if not
        
    #exec { "store-password":
    #    cwd         => "/opt/tivoli/tsm/client/ba/bin",
    #    path        => "/opt/tivoli/tsm/client/ba/bin",
    #    require     => File["/opt/tivoli/tsm/client/ba/bin/dsm.sys"],
    #    command     => "./dsmc set password $tsmpassword $tsmpassword",
    #    onlyif      => "./dsmc query session </dev/null | /bin/grep ^ANS1025E",
    #}
}
