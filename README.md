mailcatcher Salt Formula
========================

Install [mailcatcher](https://github.com/sj26/mailcatcher).
Configure server to send ALL mail to mailcatcher so nothing escapes.

See the full [Salt Formulas installation and usage instructions](http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html)


Available states
================

- [mailcatcher](#mailcatcher)
- [mailcatcher.gem](#mailcatcher-gem)
- [mailcatcher.php](#mailcatcher-php)
- [mailcatcher.service](#mailcatcher-service)

## mailcatcher

Install mailcatcher and start the service.

## mailcatcher.gem

Install mailcatcher and its dependencies.

## mailcatcher.php

Configure PHP to use mailcatcher.

## mailcatcher.service

Start the service (after stopping any other mail service).


Configuration
=============

All pillar values are optional, though you likely want to make sure we're catching mail from
all the places you may be sending it.

Apache + PHP
------------

```yaml
mailcatcher:
  lookup:
    apache_integration: True
    php_integration: True
```

Nginx + PHP
-----------

```yaml
mailcatcher:
  lookup:
    nginx_integration: True
    php_integration: True
```

Note about Sendmail
===================

Mailcatcher cannot run if Sendmail or exim is running.  Thus it will STOP and DISABLE
the existing sendmail service.

The name of the service is defined in the map.jinja, we guess it is `exim4` on modern
systems but who knows what yours is.

```yaml
mailcatcher:
  lookup:
    sendmail_service: custom_service_name
```

You can disable this functionality by setting `sendmail_service = False`
