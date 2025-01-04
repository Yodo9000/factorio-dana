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

local AbstractTransform = require("lua/model/AbstractTransform")
local ErrorOnInvalidRead = require("lua/containers/ErrorOnInvalidRead")
local ProductAmount = require("lua/model/ProductAmount")

local Metatable

-- Transform associated to a tile.
--
-- Inherits from AbstractTransform.
--
-- RO Fields:
-- * rawPump: Prototype of the pump doing this transform.
--
local TileTransform = ErrorOnInvalidRead.new{
    -- Restores the metatable of an TileTransform object, and all its owned objects.
    --
    -- Args:
    -- * object: table to modify.
    --
    setmetatable = function(object)
        AbstractTransform.setmetatable(object, Metatable)
    end,

    -- Creates a new TileTransform from a tile prototype.
    --
    -- Args:
    -- * tilePrototype: Factorio prototype of a tile.
    -- * intermediatesDatabase: Database containing the Intermediate object to use for this transform.
    --
    -- Returns: The new TileTransform object.
    --
    make = function(tilePumpPrototype, intermediatesDatabase)
        local fluid = intermediatesDatabase.fluid[tilePrototype.fluid.name]
        local result = AbstractTransform.new({
            rawPump = tilePrototype,
            type = "tile",
        }, Metatable)
        local unitsPerSecond = 60 * offshorePumpPrototype.pumping_speed
        result:addProduct(fluid, ProductAmount.makeConstant(unitsPerSecond))
        return result
    end,

    -- LocalisedString representing the type.
    TypeLocalisedStr = AbstractTransform.makeTypeLocalisedStr("tileType"),
}

-- Metatable of the TileTransform class.
Metatable = {
    __index = ErrorOnInvalidRead.new{
        -- Implements AbstractTransform:generateSpritePath().
        generateSpritePath = function(self)
            return AbstractTransform.makeSpritePath("entity", self.rawPump)
        end,

        -- Implements AbstractTransform:getTypeStr().
        getShortName = function(self)
            return self.rawPump.localised_name
        end,

        -- Implements AbstractTransform:getTypeStr().
        getTypeStr = function(self)
            return TileTransform.TypeLocalisedStr
        end,
    },
}
setmetatable(Metatable.__index, {__index = AbstractTransform.Metatable.__index})

return TileTransform
