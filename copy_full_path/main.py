from typing import List
import urllib.parse

import gi

gi.require_version("Gdk", "4.0")
gi.require_version("Gtk", "4.0")
gi.require_version("Notify", "0.7")
from gi.repository import Gdk, GLib, GObject, Gtk, Nautilus, Notify

from utils.translate import translate


class CopyPathExtension(GObject.GObject, Nautilus.MenuProvider):

    def __init__(self):
        super().__init__()

        Notify.init("Copy full path Nautilus extension")

    def menu_activate_cb(
        self,
        menu: Nautilus.MenuItem,
        file: Nautilus.FileInfo,
    ) -> None:

        if file.is_gone():
            return

        file_path = urllib.parse.unquote(file.get_uri()[7:])
        clipboard = Gdk.Display.get_default().get_clipboard()
        clipboard.set(file_path)
        clipboard = Gdk.Display.get_default().get_primary_clipboard()
        clipboard.set(file_path)

        notification = Notify.Notification.new(
            translate("copy_full_path_success_notify_title"),
            translate("copy_full_path_success_notify_text", file_path),
            "dialog-information"
        )
        notification.set_timeout(5000)
        notification.show()

    def get_file_items(
        self,
        files: List[Nautilus.FileInfo],
    ) -> List[Nautilus.MenuItem]:
        if len(files) != 1:
            return []

        file = files[0]

        if file.get_uri_scheme() != "file":
            return []

        item = Nautilus.MenuItem(
            name="Nautilus::ext::copy_full_path",
            label=translate("copy_full_path_menu_item_label"),
            tip=translate("copy_full_path_menu_item_tip"),
        )
        item.connect("activate", self.menu_activate_cb, file)

        return [
            item,
        ]

    def get_background_items(
        self,
        current_folder: Nautilus.FileInfo,
    ) -> List[Nautilus.MenuItem]:
        return []
