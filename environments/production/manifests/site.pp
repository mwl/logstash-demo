Exec {
  path => "/usr/bin:/usr/sbin:/bin"
}
exec { "apt-get-update" :
  command => "/usr/bin/apt-get update"
} -> Package <| |>

node "zookeeper" {
  package {"zookeeperd":
    ensure => installed
  } ->
  service {"zookeeper":
    ensure => running,
    enable => true
  }
}

service {"puppet":
  ensure => stopped,
  enable => false
}

class mesos {
  file {"/etc/apt/sources.list.d/openjdk.list":
    content => "deb http://ppa.launchpad.net/openjdk-r/ppa/ubuntu trusty main"
  } ->
  exec {"apt-key adv --keyserver keyserver.ubuntu.com --recv 86F44E2A":
    unless => "apt-key list | grep 86F44E2A"
  } -> Exec["apt-get-update"]

  file {"/etc/apt/sources.list.d/mesosphere.list":
    content => "deb http://repos.mesosphere.io/ubuntu/ trusty main"
  } ->
  exec {"apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF":
    unless => "apt-key list | grep E56151BF"
  } -> Exec["apt-get-update"]

  package {"openjdk-8-jre-headless":
    ensure => installed
  } ->
  package {"mesos":
    ensure => "0.25.0-0.2.70.ubuntu1404"
  }

  file {
    default:
      require => Package["mesos"],
      tag => ["mesos"];
    "/etc/mesos/zk":
      content => "zk://172.16.33.10:2181/mesos";
  }

  service {"zookeeper":
    ensure => stopped,
    enable => false,
    require => Package["mesos"]
  }
}

node /^mesosmaster[0-9]*$/ {
  include mesos

  file {
    default:
      require => Package["mesos"],
      tag => ["mesos"];
    "/etc/mesos-master/advertise_ip":
      content => "${ipaddress_eth1}";
    "/etc/mesos-master/roles":
      content => "logstash";
    "/etc/mesos-master/advertise_port":
      content => "5050";
  }

  File <| tag == "mesos" |> ~> service {"mesos-master":
    require => [Package["mesos"], Service["zookeeper"]],
    ensure => running,
    enable => true
  }
}

node /^mesosslave[0-9]*$/ {
  include mesos

  file {
    default:
      require => Package["mesos"],
      tag => ["mesos"];
    "/etc/mesos-slave/containerizers":
      content => "mesos,docker";
    "/etc/mesos-slave/ip":
      content => "${ipaddress_eth1}";
    "/etc/mesos-slave/hostname":
      content => "${ipaddress_eth1}";
    "/etc/mesos-slave/resources":
      content => "ports(logstash):[514-514,25826-25826]; ports(*):[31000-32000]; cpus(*):0.8; mem(*):795; disk(*):200";
  }

  file {"/etc/apt/sources.list.d/docker.list":
    content => "deb https://apt.dockerproject.org/repo ubuntu-trusty main"
  } ->
  exec {"apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D":
    unless => "apt-key list | grep 2C52609D"
  } -> Exec["apt-get-update"]

  package {"docker-engine":
    ensure => installed
  } ->
  service {"docker":
    ensure => running,
    enable => true
  }

  File <| tag == "mesos" |> ~> service {"mesos-slave":
    require => [Package["mesos"], Service["zookeeper"], Service["docker"]],
    ensure => running,
    enable => true
  }

  service {"mesos-master":
    require => Package["mesos"],
    ensure => stopped,
    enable => false
  }

  package {"collectd":
    ensure => installed
  } ->
  file {"/etc/collectd/collectd.conf.d/logstash.conf":
    content => 'LoadPlugin interface
LoadPlugin load
LoadPlugin memory
LoadPlugin network

<Plugin interface>
    Interface "eth0"
    IgnoreSelected false
</Plugin>
<Plugin network>
    <Server "127.0.0.1">
    </Server>
</Plugin>

'
  } ~>
  service {"collectd":
    ensure => running,
    enable => true
  }
}

node "elasticsearch" {
  file {"/etc/apt/sources.list.d/docker.list":
    content => "deb https://apt.dockerproject.org/repo ubuntu-trusty main"
  } ->
  exec {"apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D":
    unless => "apt-key list | grep 2C52609D"
  } -> Exec["apt-get-update"]

  package {"docker-engine":
    ensure => installed
  } ->
  service {"docker":
    ensure => running,
    enable => true
  }

  file {"/home/vagrant/docker-compose.yml":
    content => 'elasticsearch:
  image: elasticsearch:1.7
  ports:
    - "9200:9200"
    - "9300:9300"
kibana:
  image: kibana:4.1
  ports:
    - "5601:5601"
  links:
    - elasticsearch
'
  }

  exec {"curl -L https://github.com/docker/compose/releases/download/1.5.1/run.sh > /usr/local/bin/docker-compose":
    creates => "/usr/local/bin/docker-compose"
  } ->
  file {"/usr/local/bin/docker-compose":
    ensure => file,
    mode => "0755"
  }
}
