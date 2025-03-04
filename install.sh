#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="$(realpath "$(dirname "${0}")")"
XDG_DATA_HOME="${XDG_DATA_HOME:-"${HOME:?}/.local/share"}"
INSTALL_DIR="${XDG_DATA_HOME:?}/nautilus-python/extensions/"
ext_name="${1:?}"
ext_folder="${SCRIPT_PATH}/extensions/${ext_name}"

function compile_locales {
  for lang_dir in "${ext_folder}/locales"/*; do
    lang="$(basename "${lang_dir}")"
    if [[ "${lang}" =~ ^[a-zA-Z_]+$ ]] && [ -d "${lang_dir}" ]; then
      compile_locale "${lang}"
    fi
  done
}

function compile_locale {
  lang_dir="${1:?}"
  locale_dir="${ext_folder}/locales/${lang_dir}/LC_MESSAGES"
  echo "Compiling locales for ${lang_dir}"
  msgfmt -o "${locale_dir}/${ext_name}.mo" "${locale_dir}/${ext_name}.po"
}

function copy_sources {
  cp -v "${ext_folder}/main.py" "${INSTALL_DIR}/${ext_name}.py"
  cp -rv "${SCRIPT_PATH}/utils" "${INSTALL_DIR}"
  copy_only "${ext_folder}/locales" "*.mo" "${INSTALL_DIR}/locales"
}

function copy_only {
  source_dir="${1:?}"
  file_pattern="${2:?}"
  target_dir="${3:?}"
  find "${source_dir}" -type f -iname "${file_pattern}" -print0 \
    | while IFS= read -r -d '' file_path; do
      rel_path="$(realpath --relative-to="${source_dir}" "${file_path}")"
      dest_dir="${target_dir}/$(dirname "${rel_path}")"
      mkdir -p "${dest_dir}"
      cp -v "${file_path}" "${dest_dir}"
    done
}

function restart_nautilus {
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
}

compile_locales
copy_sources
restart_nautilus
echo "Installation done."