{%- from 'logstash/map.jinja' import logstash with context %}

{% if logstash.plugin_install %}
{% if logstash.version.startswith('5') %}
{% for plugin in logstash.plugin_install %}
logstash_plugin_{{ plugin.name }}:
  cmd.run:
{% if plugin.version is defined %}
    - name: {{ logstash.home }}/bin/logstash-plugin install --version {{ plugin.version }} {{ plugin.name }}
{% else %}
    - name: {{ logstash.home }}/bin/logstash-plugin install {{ plugin.name }}
{% endif %}
    - unless: {{ logstash.home }}/bin/logstash-plugin list | grep {{ plugin.name }}
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
