{% from "slurm/map.jinja" import slurm with context %}
include:
  - slurm

{% if salt['pillar.get']('slurm:CheckpointType') == 'blcr' -%}
slurm_checkpoint_pkgs:
  pkg.installed:
    - pkgs:
      - slurm-blcr
      - blcr
{% endif %}
