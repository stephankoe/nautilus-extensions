#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(realpath "$(dirname "${0}")")"
XDG_DATA_HOME="${XDG_DATA_HOME:-"${HOME:?}/.local/share"}"
INSTALL_DIR="${XDG_DATA_HOME:?}/nautilus-python/extensions/"
ext_name="${1:?}"

[ ! -e "${INSTALL_DIR}" ] && mkdir -p "${INSTALL_DIR}"
cat "${SCRIPT_PATH}/utils"/*.py \
    <(echo "_T = \\") \
    <(python3 "${SCRIPT_PATH}/tools/convert_yaml_to_json.py" "${SCRIPT_PATH}/extensions/${ext_name}/strings.yaml") \
    <(sed "/from utils/d;/import utils/d;/from extensions.${ext_name}/d;/import extensions.${ext_name}/d;/import \./d;/import \.\./d" "${SCRIPT_PATH}/extensions/${ext_name}"/*.py) \
    > "${INSTALL_DIR}/${ext_name}.py"

echo "The Nautilus file manager must be restarted before this extension can be used. Restart Nautilus now? [y/N]"
while true; do
  read -r answer
  answer="$(echo "${answer}" | tr '[:upper:]' '[:lower:]')"

  if [ "${answer}" == "y" ]; then
    nautilus -q
    break 
  elif [ "${answer}" == "n" ] || [ -z "${answer}" ]; then
    break
  else
    echo "'${answer}' is invalid. Please answer with either 'Y' (yes) or 'N' (no)."
  fi
done
echo "Installation done."