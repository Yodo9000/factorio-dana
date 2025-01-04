-- This file is part of Dana.
-- Copyright (C) 2019,2020 Vincent Saulue-Laborde <vincent_saulue@hotmail.fr>
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

local Dana = require("lua/Dana")
local ErrorOnInvalidRead = require("lua/containers/ErrorOnInvalidRead")
local GuiElement = require("lua/gui/GuiElement")
local Logger = require("lua/logger/Logger")

local dana

-- Table containing all the callbacks that should be bound to LuaBootstrap in Factorio.
--
local EventController = ErrorOnInvalidRead.new{
    -- Callback for Factorio's event of the same name.
    on_configuration_changed = function(configChangedData)
        dana:on_configuration_changed(configChangedData)
    end,

    -- Callback for LuaBootstrap.on_init().
    on_init = function()
        Logger.info("on_init() started.")

        GuiElement.on_init()

        dana = Dana.new()
        storage.Dana = dana

        Logger.info("on_init() completed.")
    end,

    -- Callback for LuaBootstrap.on_load().
    on_load = function()
        Logger.info("on_load() started.")

        GuiElement.on_load()

        dana = storage.Dana
        Dana.setmetatable(dana)

        Logger.info("on_load() completed.")
    end,

    -- Map[eventName] -> function. Map of callbacks for LuaBootstrap.on_event(), indexed by the event's name.
    events = ErrorOnInvalidRead.new{
        on_force_created = function(event)
            dana:on_force_created(event)
        end,

        on_gui_elem_changed = GuiElement.on_gui_elem_changed,
        on_gui_checked_state_changed = GuiElement.on_gui_checked_state_changed,
        on_gui_click = GuiElement.on_gui_click,

        on_gui_closed = function(event)
            dana:on_gui_closed(event)
        end,

        on_gui_opened = function(event)
            dana:on_gui_opened(event)
        end,

        on_gui_text_changed = GuiElement.on_gui_text_changed,

        on_lua_shortcut = function(event)
            dana:on_lua_shortcut(event)
        end,

        on_player_changed_surface = function(event)
            dana:on_player_changed_surface(event)
        end,

        on_player_created = function(event)
            GuiElement.on_player_created(event)
            dana:on_player_created(event)
        end,

        on_player_selected_area = function(event)
            dana:on_player_selected_area(event)
        end,

        on_runtime_mod_setting_changed = function(event)
            dana:on_runtime_mod_setting_changed(event)
        end,
    }
}

return EventController
