-- This file is part of Dana.
-- Copyright (C) 2021 Vincent Saulue-Laborde <vincent_saulue@hotmail.fr>
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

local ClassLogger = require("lua/logger/ClassLogger")
local ErrorOnInvalidRead = require("lua/containers/ErrorOnInvalidRead")

local cLogger = ClassLogger.new{className = "QueryEditorInterface"}

-- Interface for QueryEditor implementations.
--
-- RO Fields:
-- * appResources: AppResources. Resources of the owning application.
--
local QueryEditorInterface = ErrorOnInvalidRead.new{
    -- Checks that all methods are implemented.
    --
    -- Args:
    -- * object: QueryAppInterface.
    --
    checkMethods = function(object)
        cLogger:assertField(object, "getGuiUpcalls")
        cLogger:assertField(object, "setParamsEditor")
    end,
}

--[[
-- Metatable of QueryEditorInterface.
Metatable = {
    __index = ErrorOnInvalidRead.new{
        -- Implementation of AbstractGuiController:getGuiUpcalls().
        getGuiUpcalls = function(self) end,

        -- Changes the current set of parameters being edited.
        --
        -- Args:
        -- * self: AbstractQueryEditor.
        -- * name: string. Identifier of the parameter editor to open.
        --
        setParamsEditor = function(self, name) end,
    },
}
--]]

return QueryEditorInterface
