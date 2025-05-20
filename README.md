# TPZ-CORE Doorlocks

## Requirements

1. TPZ-Core: https://github.com/TPZ-CORE/tpz_core
2. TPZ-Characters: https://github.com/TPZ-CORE/tpz_characters
3. TPZ-Inventory : https://github.com/TPZ-CORE/tpz_inventory

# Installation

1. When opening the zip file, open `tpz_doorlocks-main` directory folder and inside there will be another directory folder which is called as `tpz_doorlocks`, this directory folder is the one that should be exported to your resources (The folder which contains `fxmanifest.lua`).

2. Add `ensure tpz_doorlocks` after the **REQUIREMENTS** in the resources.cfg or server.cfg, depends where your scripts are located.

## Basic Information

1. The doors are created through configuration file and not through any menu, by handling all doors from
the configuration file, it is the most easiest and efficient way, especially by editing existing doors or their jobs. 

2. The doors open by pressing `ENTER` key by default. 

3. Use `doorhashes.lua` to register new doors from custom MLO (The developer should provide the door requirements).