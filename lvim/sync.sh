#!/bin/bash

DIR="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"

cp ~/.config/lvim/config.lua $DIR/config.lua

cp ~/.config/lvim/plugin/* $DIR/plugin

cp ~/.config/lvim/lsp-settings/* $DIR/lsp-settings
