{% from "mailcatcher/map.jinja" import mailcatcher with context %}

include:
  - mailcatcher.gem
{%- if salt['pillar.get']('mailcatcher:php_integration', False) %}
  - mailcatcher.php
{% endif %}
  - mailcatcher.service
