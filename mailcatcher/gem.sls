{% from "mailcatcher/map.jinja" import mailcatcher with context %}


mailcatcher-dependencies:
  pkg.installed:
    - names:
      - {{ mailcatcher.ruby_package }}
      - {{ mailcatcher.libsqlite3dev_package }}


mailcatcher-gem:
  gem.installed:
    - name: mailcatcher
    - require:
      - pkg: mailcatcher-dependencies
