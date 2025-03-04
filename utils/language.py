import gettext
import os

_DEFAULT_LANG = "en"


def setup_translation(file_path: str,
                      ) -> gettext.gettext:
    domain_name = os.path.splitext(os.path.basename(file_path))[0]
    locales_dir = os.path.join(os.path.dirname(file_path), "locales")
    args = (domain_name, locales_dir)
    try:
        translation = gettext.translation(*args)
    except FileNotFoundError:  # default language does not exist
        translation = gettext.translation(*args, languages=[_DEFAULT_LANG])
    return translation.gettext
