from gi.repository import GLib

_T = {
    "en": {},
}


def translate(name: str, *args) -> str:
    lang = GLib.get_language_names()[0].split(".")[0].split("_")[0].lower()
    return _T.get(lang, 'en')[name].format(*args).strip()
