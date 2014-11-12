{% from "mailcatcher/map.jinja" import mailcatcher with context %}

{% set smtp_service = False %}
{% if salt['pillar.get']('mailcatcher:smtp_service', True) %}
  {%- set smtp_service = mailcatcher['smtp_service'] %}
{% endif %}

include:
  - mailcatcher.gem


{% if smtp_service %}
{#-
 # Kill and disable any other smtp service on this machine.
 # Set mailcatcher['smtp_service'] = False to disable this.
 #}
mailcatcher-kill_smtp:
  service.dead:
    - name: {{ smtp_service }}
    - enable: False
{% endif %}


mailcatcher:
  file.managed:
    - name: /etc/init.d/mailcatcher
    - mode: 755
    - source: salt://mailcatcher/templates/init_d.sh
    - template: jinja
    - context:
      mailcatcher: {{ mailcatcher }}
  service.running:
    - enable: True
    - require:
      - gem: mailcatcher-gem
      - file: mailcatcher
{% if smtp_service %}
      - service: mailcatcher-kill_smtp
{% endif %}
