# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as certmonger with context %}

{% if certmonger.certs|length %}
{% for cert, opts in certmonger.certs.items() %}

{% if not opts.get('key_location') and not opts.get('db_dir') %}
  {% set key_file = certmonger.key_dir + cert + certmonger.key_ext %}
{% endif %}
{% if not opts.get('certificate_location') and not opts.get('db_dir') %}
  {% set cert_file = certmonger.cert_dir + cert + certmonger.cert_ext %}
{% endif %}


{{ cert }}:
  certmonger.request:
  {# Define values for key/cert paths necessary to generate a basic cert from FreeIPA utilizing the HOST principal.
  If key_location or cert_location is explicitly defined from the pillars (or if a NSSDB is being used), it'll be added
  to the list of parameters with any other explict variables. #}
  {% if key_file %}
  - key_location: {{ key_file }}
  {% endif %}
  {% if cert_file %}
  - certificate_location: {{ cert_file }}
  {% endif %}
  {% if opts.items()|length %}
  {% for key, value in opts.items() %}
  - {{ key }}: {{ value }}
  {% endfor %}
  {% endif %}

{% if key_file %}
{{ key_file }}:
  file.managed:
    - user: root
    - mode: 0600
    - selinux:
      setype: cert_t
    - replace: False
{% endif %}

{% if cert_file %}
{{ cert_file }}:
  file.managed:
    - user: root
    - mode: 0644
    - selinux:
      setype: cert_t
    - replace: False
{% endif %}

{% if opts.get('key_location') %}
{{ key_location }}:
  file.managed:
  - user: {{ opts.get('key_owner') if opts.get('key_owner') is not none else 'root' }}
  - mode: {{ opts.get('key_mode') if opts.get('key_mode') is not none else '0600' }}
  - selinux:
    setype: cert_t
  - replace: False
{% endif %}

{% if opts.get('certificate_location') %}
{{ certificate_location }}:
  file.managed:
  - user: {{ opts.get('cert_owner') if opts.get('cert_owner') is not none else 'root' }}
  - mode: {{ opts.get('cert_mode') if opts.get('cert_mode') is not none else '0644' }}
  - selinux:
    setype: cert_t
  - replace: False
{% endif %}

{% endfor %}
{% endif %}