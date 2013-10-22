# Class: java::params
#
# This class builds a hash of JDK/JRE packages and (for Debian)
# alternatives.  For wheezy/precise, we provide Oracle JDK/JRE
# options, even though those are not in the package repositories.
#
# For more info on how to package Oracle JDK/JRE, see the Debian wiki:
# http://wiki.debian.org/JavaPackage
#
# Because the alternatives system makes it very difficult to tell
# which Java alternative is enabled, we hard code the path to bin/java
# for the config class to test if it is enabled.
class java::params {

  case $::osfamily {
    default: { fail("unsupported platform ${::osfamily}") }
    'RedHat': {
      case $::operatingsystem {
        default: { fail("unsupported os ${::operatingsystem}") }
        'RedHat', 'CentOS', 'OracleLinux', 'Scientific': {
          if (versioncmp($::operatingsystemrelease, '5.0') < 0) {
            $jdk_package = 'java-1.6.0-sun-devel'
            $jre_package = 'java-1.6.0-sun'
          }
          elsif (versioncmp($::operatingsystemrelease, '6.3') < 0) {
            $jdk_package = 'java-1.6.0-openjdk-devel'
            $jre_package = 'java-1.6.0-openjdk'
          }
          else {
            $jdk_package = 'java-1.7.0-openjdk-devel'
            $jre_package = 'java-1.7.0-openjdk'
          }
        }
        'Fedora': {
          $jdk_package = 'java-1.7.0-openjdk-devel'
          $jre_package = 'java-1.7.0-openjdk'
        }
        'Amazon': {
          $jdk_package = 'java-1.7.0-openjdk-devel'
          $jre_package = 'java-1.7.0-openjdk'
        }
      }
      $java = {
        'jdk' => { 'package' => $jdk_package, 'home' => "/usr/lib/jvm/${jre_package}"},
        'jre' => { 'package' => $jre_package, 'home' => "/usr/lib/jvm/${jre_package}/jre"},
      }
    }
    'Debian': {
      case $::lsbdistcodename {
        default: { fail("unsupported release ${::lsbdistcodename}") }
        'lenny', 'squeeze', 'lucid', 'natty': {
          $java  = {
            'jdk' => {
              'package'          => 'openjdk-6-jdk',
              'alternative'      => 'java-6-openjdk',
              'home'             => '/usr/lib/jvm/java-6-openjdk',
              'alternative_path' => '/usr/lib/jvm/java-6-openjdk/jre/bin/java',
            },
            'jre' => {
              'package'          => 'openjdk-6-jre-headless',
              'alternative'      => 'java-6-openjdk',
              'home'             => '/usr/lib/jvm/java-6-openjdk',
              'alternative_path' => '/usr/lib/jvm/java-6-openjdk/jre/bin/java',
            },
            'sun-jre' => {
              'package'          => 'sun-java6-jre',
              'alternative'      => 'java-6-sun',
              'home'             => '/usr/lib/jvm/java-6-sun',
              'alternative_path' => '/usr/lib/jvm/java-6-sun/jre/bin/java',
            },
            'sun-jdk' => {
              'package'          => 'sun-java6-jdk',
              'alternative'      => 'java-6-sun',
              'home'             => '/usr/lib/jvm/java-6-sun',
              'alternative_path' => '/usr/lib/jvm/java-6-sun/jre/bin/java',
            },
          }
        }
        'wheezy', 'precise','quantal','raring': {
          $java =  {
            'jdk' => {
              'package'          => 'openjdk-7-jdk',
              'alternative'      => "java-1.7.0-openjdk-${::architecture}",
              'home'             => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/bin/java",
            },
            'jre' => {
              'package'          => 'openjdk-7-jre-headless',
              'alternative'      => "java-1.7.0-openjdk-${::architecture}",
              'home'             => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/bin/java",
            },
            'oracle-jre' => {
              'package'          => 'oracle-j2re1.7',
              'alternative'      => 'j2re1.7-oracle',
              'home'             => "/usr/lib/jvm/j2re1.7-oracle",
              'alternative_path' => '/usr/lib/jvm/j2re1.7-oracle/bin/java',
            },
            'oracle-jdk' => {
              'package'          => 'oracle-j2sdk1.7',
              'alternative'      => 'j2sdk1.7-oracle',
              'home'             => "/usr/lib/jvm/j2sdk1.7-oracle",
              'alternative_path' => '/usr/lib/jvm/j2sdk1.7-oracle/jre/bin/java',
            },
          }
        }
      }
    }
    'Solaris': {
      $java = {
        'jdk' => { 'package' => 'developer/java/jdk-7', },
        'jre' => { 'package' => 'runtime/java/jre-7', },
      }
    }
    'Suse': {
      case $::operatingsystem {
        default: {
          $jdk_package = 'java-1_6_0-ibm-devel'
          $jre_package = 'java-1_6_0-ibm'
        }

        'OpenSuSE': {
          $jdk_package = 'java-1_7_0-openjdk-devel'
          $jre_package = 'java-1_7_0-openjdk'
        }
      }
      $java = {
        'jdk' => { 'package' => $jdk_package, 'home' => "/usr/lib/jvm/${jre_package}" },
        'jre' => { 'package' => $jre_package, 'home' => "/usr/lib/jvm/${jre_package}" },
      }
    }
  }
}
