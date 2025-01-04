-- This file is part of Dana.
-- Copyright (C) 2020 Vincent Saulue-Laborde <vincent_saulue@hotmail.fr>
--
-- Dana is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- Dana is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with Dana.  If not, see <https://www.gnu.org/licenses/>.

local shortcutIcon = {
    type = "sprite",
    name = "dana-shortcut-icon",
    filename = "__dana__/graphics/shortcut-icon-black.png",
    flags = {"icon"},
    mipmap_count = 2,
    priority = "extra-high-no-scale",
    size = 32,
}

local selection_mode = {
    border_color = {
        r = 0,
        g = 0.5,
        b = 0
    },
    cursor_box_type = "copy",
    mode = "nothing"
}

data:extend{
    {
        type = "selection-tool",
        name = "dana-select",
        --[[alt_selection_color = {
            r = 0,
            g = 0.5,
            b = 0,
        },
        selection_color = {
            r = 0,
            g = 0.5,
            b = 0,
        },
        alt_selection_mode = {"nothing"},
        selection_mode = {"nothing"},
        selection_cursor_box_type = "copy",
        alt_selection_cursor_box_type = "copy",
        ]]
        select = selection_mode,
        alt_select = selection_mode,
        flags = {"not-stackable","only-in-cursor"},
        stack_size = 1,
        icon = "__base__/graphics/icons/blueprint.png",
        --icon_mipmaps = 4,
        icon_size = 64,
    },{
        type = "shortcut",
        name = "dana-shortcut",
        action = "lua",
        --icon = shortcutIcon,
        icon = shortcutIcon.filename,
        small_icon = shortcutIcon.filename,
        icon_size = shortcutIcon.size,
        small_icon_size = shortcutIcon.size,
        localised_name = {"dana.longName"},
        toggleable = true,
    },
    shortcutIcon,
    {
        type = "sprite",
        name = "dana-boiler-icon",
        filename = "__dana__/graphics/boiler-symbol.png",
        width = 32,
        height = 32,
    },{
        type = "sprite",
        name = "dana-fluid-icon",
        filename = "__dana__/graphics/fluid-symbol.png",
        width = 32,
        height = 32,
    },{
        type = "sprite",
        name = "dana-fuel-icon",
        filename = "__dana__/graphics/fuel-symbol.png",
        width = 32,
        height = 32,
    },{
        type = "sprite",
        name = "dana-item-icon",
        filename = "__dana__/graphics/item-symbol.png",
        width = 32,
        height = 32,
    },{
        type = "sprite",
        name = "dana-recipe-icon",
        filename = "__dana__/graphics/recipe-symbol.png",
        width = 32,
        height = 32,
    },
}
-- add styles removed in 2.0:
-- I hope there is a nicer way of doing this.
data.raw["gui-style"]["default"]["draggable_space_with_no_left_margin"] = {
    type = "empty_widget_style",
    parent = "draggable_space",
    left_margin = 0
}
data.raw["gui-style"]["default"]["borderless_deep_frame"] = {
    type = "frame_style",
    parent = "invisible_frame",
    graphical_set = { base = { center = {position = {42, 8}, size = {1, 1}}}}
}