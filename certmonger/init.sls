# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as certmonger with context %}

{% for cert, opts in certmonger.certs.iteritems() %}

{{ cert }}:
  certmonger.request:
  {# Define values for key/cert paths necessary to generate a basic cert from FreeIPA utilizing the HOST principal.
  If key_location or cert_location is explicitly defined from the pillars (or if a NSSDB is being used), it'll be added
  to the list of parameters with any other explict variables. #}
  {% if not opts.get('key_location') and not opts.get('db_dir') %}
  - key_location: "{{ certmonger.key_dir }}{{ cert }}{{ certmonger.key_ext }}"
  {% endif %}
  {% if not opts.get('cert_location') and not opts.get('db_dir') %}
  - cert_location: "{{ certmonger.cert_dir }}{{ cert }}{{ certmonger.cert_ext }}"
  {% endif %}
  {{ opts | dict_to_sls_yaml_params | indent }}

  


{% endfor %}