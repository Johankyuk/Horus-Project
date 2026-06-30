#!/usr/bin/env bash
# Preview de la UI del instalador (no instala nada).
#   Envoltorio fino sobre la capa real: lib/kyu-ui.sh.
#   Lo que veas aquí es EXACTAMENTE lo que verás en el instalador.
#   Equivale a:  setup_master.sh --preview
set -uo pipefail
_here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$_here/../lib/kyu-ui.sh"
export KYU_UI_PREVIEW=1
KYU_DGPU=0;  lspci 2>/dev/null | grep -qi nvidia && KYU_DGPU=1
KYU_SDBOOT=1; bootctl is-installed &>/dev/null || KYU_SDBOOT=0
kyu_wizard
