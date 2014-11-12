mailcatcher Salt Formula
========================

Install [mailcatcher](https://github.com/sj26/mailcatcher).
Configure server to send ALL mail to mailcatcher so nothing escapes.

See the full [Salt Formulas installation and usage instructions](http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html)


## Available states

- [mailcatcher](#mailcatcher)
- [mailcatcher.gem](#mailcatcher-gem)
- [mailcatcher.php](#mailcatcher-php)
- [mailcatcher.service](#mailcatcher-service)

### mailcatcher

Install mailcatcher and start the service.

### mailcatcher.gem

Install mailcatcher and its dependencies.

### mailcatcher.php

Configure PHP to use mailcatcher.

### mailcatcher.service

Start the service (after stopping any other mail service).


Configuration
=============

All pillar values are optional, though you likely want to make sure we're catching mail from
all the places you may be sending it.

Standalone PHP
--------------

```yaml
mailcatcher:
  php_integration: True
```

The pillar setting above will update php.ini such that PHP uses mailcatcher to send mail.


Apache + PHP
------------

```yaml
mailcatcher:
  apache_integration: True
  php_integration: True
```

The pillar setting above will update php.ini such that PHP uses mailcatcher to send mail, and it will
restart Apache so the changes take effect.

Nginx + PHP
-----------

```yaml
mailcatcher:
  nginx_integration: True
  php_integration: True
```

The pillar setting above will update php.ini such that PHP uses mailcatcher to send mail, and it will
restart Nginx so the changes take effect.


Note about Sendmail
===================

Mailcatcher cannot run if Sendmail or exim is running.  Thus it will STOP and DISABLE
the existing sendmail service.

The name of the service is defined in the map.jinja, we guess it is `exim4` on modern
systems but who knows what yours is.

```yaml
mailcatcher:
  lookup:
    smtp_service: custom_service_name
```

If you don't have any existing SMTP service running on your machine and you don't want us to
constantly check that said non-existing service is dead, you can set a pillar like

```yaml
mailcatcher:
  smtp_service: False
```
