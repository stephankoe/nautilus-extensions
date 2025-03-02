# Nautilus Extensions

This repository contains several small extensions for the Nautilus file manager:

- `copy_full_path`: adds an entry to the right-click menu of Nautilus to copy the currently selected file/folder path to the clipboard.

## Installation

Simply run the `install.sh` script on the command-line to install an extension:

```bash
./install.sh <EXT_NAME>
```

`<EXT_NAME>` must be replaced by an existing folder inside the `extensions/` folder, for example `copy_full_path`. 
The script will then merge the extension and utils files and put them to the correct location.
The new functionality will be available after a restart of Nautilus (via `nautilus -q`).
