{% from "slurm/map.jinja" import slurm with context %}
include:
  - slurm
  - slurm.munge
  - slurm.energy
  - slurm.topology

slurm_package:
  pkg.installed:
  - name: {{ slurm.pkgSlurmNode }}
  - pkgs:
    - {{ slurm.pkgSlurmNode }}: {{ slurm.slurm_version }}
  - require:
    - pkg: {{ slurm.pkgSlurm }}
    {% if salt['pillar.get']('slurm:AuthType') == 'munge' %}
    - service: slurm_munge
    {%endif %}

slurm_service:
  file.directory:
    - name: /var/log/slurm/
    - user: slurm
    - group: slurm
  service.running:
    - enable: True
    - name: {{ slurm.slurmd }}
    - reload: False
    - require:
      - pkg: slurm_package

slurm_config_logrotate:
  file.managed:
    - name: /etc/logrotate.d/slurmd
    - user: root
    - group: root
    - mode: '644'
    - template: jinja
    - source: salt://slurm/files/slurmd-logrotate.log
    - require:
      - file: slurm_service
