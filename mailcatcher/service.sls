{% from "mailcatcher/map.jinja" import mailcatcher with context %}

{% set sendmail_service = False %}
{% if salt['pillar.get']('mailcatcher:sendmail_service', True) %}
  {%- set sendmail_service = mailcatcher['sendmail_service'] %}
{% endif %}

include:
  - mailcatcher.gem


{% if sendmail_service %}
{#-
 # Kill and disable any other sendmail service on this machine.
 # Set mailcatcher['sendmail_service'] = False to disable this.
 #}
mailcatcher-kill_sendmail:
  service.dead:
    - name: {{ sendmail_service }}
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
{% if sendmail_service %}
      - service: mailcatcher-kill_sendmail
{% endif %}
