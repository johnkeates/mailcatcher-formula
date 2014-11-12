{% from "mailcatcher/map.jinja" import mailcatcher with context %}

{% set apache_integration = salt['pillar.get']('mailcatcher:apache_integration', False) %}
{% set nginx_integration = salt['pillar.get']('mailcatcher:nginx_integration', False) %}

include:
  - mailcatcher.gem
  - mailcatcher.service
  - php
{% if apache_integration %}
  - apache
{% endif %}
{% if nginx_integration %}
  - nginx
{% endif %}

mailcatcher-php:
  file.managed:
    - name: {{ mailcatcher['php_conf_d'] }}/mailcatcher.ini
    - mode: 644
    - source: salt://mailcatcher/templates/php.ini
    - template: jinja
    - context:
      mailcatcher: {{ mailcatcher }}
    - require:
      - pkg: php

    - require_in:
      - service: mailcatcher
    {%- if apache_integration %}
      - service: {{ mailcatcher.apache_service }}
    {%- endif %}
    {%- if nginx_integration %}
      - service: {{ mailcatcher.nginx_service }}
    {%- endif %}

    - watch_in:
      - service: mailcatcher
    {%- if apache_integration %}
      - service: {{ mailcatcher.apache_service }}
    {%- endif %}
    {%- if nginx_integration %}
      - service: {{ mailcatcher.nginx_service }}
    {%- endif %}
