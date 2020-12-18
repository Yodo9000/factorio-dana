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

local AbstractQuery = require("lua/query/AbstractQuery")
local ErrorOnInvalidRead = require("lua/containers/ErrorOnInvalidRead")

local Metatable
local QueryType

-- Query generating the full crafting graph.
--
-- Inherits from AbstractQuery.
--
local FullGraphQuery = ErrorOnInvalidRead.new{
    -- Creates a new FullGraphQuery object.
    --
    -- Returns: The new FullGraphQuery object.
    --
    new = function()
        return AbstractQuery.new({
            queryType = QueryType,
        }, Metatable)
    end,

    -- Restores the metatable of a FullGraphQuery object, and all its owned objects.
    --
    -- Args:
    -- * object: table to modify.
    --
    setmetatable = function(object)
        AbstractQuery.setmetatable(object, Metatable)
    end,
}

-- Metatable of the FullGraphQuery class.
Metatable = {
    __index = ErrorOnInvalidRead.new{
        -- Implements AbstractQuery:copy().
        copy = function(self)
            return AbstractQuery.copy(self, Metatable)
        end,

        -- Implements AbstractQuery:execute().
        execute = function(self, force)
            return AbstractQuery.preprocess(self, force)
        end,
    },
}

-- Identifier for this subtype of Query.
QueryType = "FullGraphQuery"

AbstractQuery.Factory:registerClass(QueryType, FullGraphQuery)
return FullGraphQuery
