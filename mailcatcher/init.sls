{% from "mailcatcher/map.jinja" import mailcatcher with context %}

include:
  - mailcatcher.gem
{% if mailcatcher['php_integration'] %}
  - mailcatcher.php
{% endif %}
  - mailcatcher.service
