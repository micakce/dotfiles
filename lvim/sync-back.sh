#!/bin/bash

DIR="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"

cp  $DIR/config.lua ~/.config/lvim/config.lua

cp  $DIR/plugin/* ~/.config/lvim/plugin

cp  $DIR/lsp-settings/* ~/.config/lvim/lsp-settings

