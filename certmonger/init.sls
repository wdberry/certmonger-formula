# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as certmonger with context %}

{% for cert in certmonger.certs %}

{{ cert }}:
  certmonger.request:
  {# Define values for key/cert paths necessary to generate a basic cert from FreeIPA utilizing the HOST principal.
  If key_location or cert_location is explicitly defined from the pillars (or if a NSSDB is being used), it'll be added
  to the list of parameters with any other explict variables. #}
  {% if not cert.get('key_location') and not cert.get('db_dir') %}
  - key_location: "{{ key_dir }}/{{ cert }}.{{ key_ext }}"
  {% endif %}
  {% if not cert.get('cert_location') and not cert.get('db_dir') %}
  - cert_location: "{{ cert_dir }}/{{ cert }}.{{ cert_ext }}"
  {% endif %}
  {{ cert | dict_to_sls_yaml_params | indent }}

  


{% endfor %}