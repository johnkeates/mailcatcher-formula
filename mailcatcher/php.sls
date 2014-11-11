{% from "mailcatcher/map.jinja" import mailcatcher with context %}

include:
  - mailcatcher.gem
  - mailcatcher.service

mailcatcher-php:
  file.managed:
    - name: {{ mailcatcher['php_conf_d'] }}/mailcatcher.ini
    - mode: 644
    - source: salt://mailcatcher/templates/php.ini
    - template: jinja
    - context:
      mailcatcher: {{ mailcatcher }}

    - require_in:
      - service: mailcatcher
    {%- if mailcatcher['apache_integration'] %}
      - service: {{ mailcatcher.apache_service }}
    {%- endif %}
    {%- if mailcatcher['nginx_integration'] %}
      - service: {{ mailcatcher.nginx_service }}
    {%- endif %}

    - watch_in:
      - service: mailcatcher
    {%- if mailcatcher['apache_integration'] %}
      - service: {{ mailcatcher.apache_service }}
    {%- endif %}
    {%- if mailcatcher['nginx_integration'] %}
      - service: {{ mailcatcher.nginx_service }}
    {%- endif %}
