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
local Intermediate = require("lua/model/Intermediate")

local Metatable

-- Class holding a set of Intermediate objects.
--
-- RO Fields:
-- * fluid[protoName]: Map of Intermediate fluids, indexed by the name of their rawPrototype.
-- * item[protoName]: Map of Intermediate items, indexed by the name of their rawPrototype.
--
local IntermediatesDatabase = ErrorOnInvalidRead.new{
    -- Creates a new IntermediatesDatabase object.
    --
    -- Returns: the new IntermediatesDatabase object.
    --
    new = function()
        local result = {
            fluid = ErrorOnInvalidRead.new(),
            item = ErrorOnInvalidRead.new(),
        }
        setmetatable(result, Metatable)
        return result
    end,

    -- Restores the metatable of an IntermediatesDatabase object, and all its owned objects.
    --
    -- Args:
    -- * object: table to modify.
    --
    setmetatable = function(object)
        setmetatable(object, Metatable)

        ErrorOnInvalidRead.setmetatable(object.fluid)
        for _,fluid in pairs(object.fluid) do
            Intermediate.setmetatable(fluid)
        end

        ErrorOnInvalidRead.setmetatable(object.item)
        for _,item in pairs(object.item) do
            Intermediate.setmetatable(item)
        end
    end,
}

-- Metatable of the IntermediatesDatabase class.
Metatable = {
    __index = ErrorOnInvalidRead.new{
        -- Resets the content of the database.
        --
        -- Args:
        -- * self: IntermediatesDatabase object.
        -- * gameScript: LuaGameScript object holding the new prototypes.
        --
        rebuild = function(self, gameScript)
            local fluids = ErrorOnInvalidRead.new()
            for _,fluid in pairs(prototypes.fluid) do
                fluids[fluid.name] = Intermediate.new{
                    type = "fluid",
                    rawPrototype = fluid,
                }
            end
            self.fluid = fluids

            local items = ErrorOnInvalidRead.new()
            for _,item in pairs(prototypes.item) do
                items[item.name] = Intermediate.new{
                    type = "item",
                    rawPrototype = item,
                }
            end
            self.item = items
        end,

        -- Get the Intermediate object wrapping a given ingredient/product from Factorio.
        --
        -- Args:
        -- * self: IntermediatesDatabase object.
        -- * ingredientOrProduct: Ingredient or Product object from Factorio.
        --
        getIngredientOrProduct = function(self, ingredientOrProduct)
            return self[ingredientOrProduct.type][ingredientOrProduct.name]
        end,
    },
}

return IntermediatesDatabase
