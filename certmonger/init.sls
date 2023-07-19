# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "certmonger/map.jinja" import certmonger with context %}

{% for cert, opts in salt['pillar.get']('certs:certmonger') %}

{{ cert }}:
  certmonger.cert:
  {# Define values for key/cert paths necessary to generate a basic cert from FreeIPA utilizing the HOST principal.
  If key_location or cert_location is explicitly defined from the pillars (or if a NSSDB is being used), it'll be added
  to the list of parameters with any other explict variables. #}
  {% if not opts['key_location'] and not opts['db_dir'] %}
  - key_location: "{{ key_path }}/{{ cert }}.{{ key_ext }}"
  {% endif %}
  {% if not opts['cert_location'] and not opts['db_dir'] %}
  - cert_location: "{{ cert_path }}/{{ cert }}.{{ cert_ext }}"
  {% endif %}
  {{ opts | dict_to_sls_yaml_params | indent }}

  


{% endfor %}