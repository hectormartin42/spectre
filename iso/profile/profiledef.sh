#!/usr/bin/env bash

iso_name="spectre-os"
iso_label="SPECTRE_OS_$(date +%Y%m)"
iso_publisher="Spectre OS <https://github.com/hectormartin42/spectre>"
iso_application="Spectre OS — Cybersecurity & Pentesting"
iso_version="0.1.0"
file_permissions=(
    ["/etc/shadow"]="0:0:400"
    ["/etc/gshadow"]="0:0:400"
    ["/root"]="0:0:750"
    ["/usr/local/bin/spc"]="0:0:755"
)
