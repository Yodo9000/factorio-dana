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

local FactorioLoggerBackend = require("lua/logger/backends/FactorioLoggerBackend")
local Logger = require("lua/logger/Logger")
Logger.init(FactorioLoggerBackend)

--global = storage -- makes it harder to find bugs, as they show up when a save is reloaded, but not the first time
local EventController = require("lua/EventController")

script.on_configuration_changed(EventController.on_configuration_changed)
script.on_load(EventController.on_load)
script.on_init(EventController.on_init)

local events = defines.events
for eventName,eventCallback in pairs(EventController.events) do
	script.on_event(events[eventName], eventCallback)
end
