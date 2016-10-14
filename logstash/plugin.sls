{%- from 'logstash/map.jinja' import logstash with context %}

{% if logstash.plugin_install %}
{% if logstash.version.startswith('2') %}
{% for plugin in logstash.plugin_install %}
logstash_plugin_{{ plugin.name }}:
  cmd.run:
{% if plugin.version is defined %}
    - name: /opt/logstash/bin/logstash-plugin install --version {{ plugin.version }} {{ plugin.name }}
{% else %}
    - name: /opt/logstash/bin/logstash-plugin install {{ plugin.name }}
{% endif %}
    - unless: /opt/logstash/bin/logstash-plugin list | grep {{ plugin.name }}
    - require:
      - pkg: logstash
{% endfor %}
{% endif %}
{% endif %}

extend:
  logstash:
    service:
      - watch:
{% for plugin in logstash.plugin_install %}
        - cmd: logstash_plugin_{{ plugin.name }}
{% endfor %}
