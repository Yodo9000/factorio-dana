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

local ErrorOnInvalidRead = require("lua/containers/ErrorOnInvalidRead")

local run

-- Helper library to build GUIs.
local GuiMaker = ErrorOnInvalidRead.new{
    -- Creates a new LuaGuiElement hierarchy.
    --
    -- Args:
    -- * parent: LuaGuiElement. Root element of the new GUI.
    -- * cArgs: table. Same fields as LuaGuiElement.add() argument, plus:
    -- ** children: array<table>. Table following the same format as `cArgs`.
    -- ** styleModifiers: table. Values to override in the "style" property of the new element.
    --
    -- Returns: LuaGuiElement. The top-level element created.
    --
    run = function(parent, cArgs)
        local result = parent.add(cArgs)

        local styleModifiers = cArgs.styleModifiers
        if styleModifiers then
            local style = result.style
            for index,value in pairs(styleModifiers) do
                style[index] = value
            end
        end

        local children = cArgs.children
        if children then
            for _,childArgs in ipairs(children) do
                run(result, childArgs)
            end
        end

        return result
    end,
}

run = GuiMaker.run

return GuiMaker
