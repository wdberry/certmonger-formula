# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as certmonger with context %}

certmonger-service-clean-service-dead:
  service.dead:
    - name: {{ certmonger.service.name }}
    - enable: False
