{%- from 'logstash/map.jinja' import logstash with context %}

{% set splitversion = logstash.version.split('.') %}
{% set repoversion = splitversion[0] + "." + splitversion[1] %}

{%- if grains['os_family'] == 'Debian' %}
logstash-repo:
  pkgrepo.managed:
    - humanname: Logstash {{ repoversion }}.x Debian Repository
    - name: deb https://packages.elastic.co/logstash/{{ repoversion }}/debian stable main
    - file: /etc/apt/sources.list.d/logstash.list
    - gpgcheck: 1
    - key_url: http://packages.elasticsearch.org/GPG-KEY-elasticsearch
{%- elif grains['os_family'] == 'RedHat' %}
logstash-repo-key:
  cmd.run:
    - name:  rpm --import http://packages.elasticsearch.org/GPG-KEY-elasticsearch
    - unless: rpm -qi gpg-pubkey-d88e42b4-52371eca

logstash-repo:
  pkgrepo.managed:
    - humanname: logstash repository for {{ repoversion }}.x packages
    - baseurl: http://packages.elasticsearch.org/logstash/{{ repoversion }}/centos
    - gpgcheck: 1
    - gpgkey: http://packages.elasticsearch.org/GPG-KEY-elasticsearch
    - enabled: 1
    - require:
      - cmd: logstash-repo-key
{%- endif %}