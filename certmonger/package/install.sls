# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as certmonger with context %}

certmonger-package-install-pkg-installed:
  pkg.installed:
    - name: {{ certmonger.pkg.name }}
