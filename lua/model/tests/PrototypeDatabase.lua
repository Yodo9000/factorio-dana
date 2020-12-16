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

local LuaGameScript = require("lua/testing/mocks/LuaGameScript")
local PrototypeDatabase = require("lua/model/PrototypeDatabase")
local SaveLoadTester = require("lua/testing/SaveLoadTester")

describe("PrototypeDatabase", function()
    local gameScript
    setup(function()
        local data = {
            item = {
                iron = {type = "item", name = "iron"},
                ironStack = {type = "item", name = "ironStack"},
            },
            recipe = {
                sink = {
                    type = "recipe",
                    name = "sink",
                    ingredients = {
                        {type = "item", name = "iron", amount = 1},
                    },
                    results = {},
                },
                stacking = {
                    type = "recipe",
                    name = "stacking",
                    ingredients = {
                        {"iron", 5},
                    },
                    results = {
                        {"ironStack", 1},
                    },
                },
                unstacking = {
                    type = "recipe",
                    name = "unstacking",
                    ingredients = {
                        {"ironStack", 1},
                    },
                    results = {
                        {"iron", 5},
                    },
                },
            },
        }
        for i=1,15 do
            local itemName = "item" .. i
            data.item[itemName] = {
                type = "item",
                name = itemName,
            }
            local recipeName = "indirect" .. i
            data.recipe[recipeName] = {
                type = "recipe",
                name = recipeName,
                ingredients = {
                    {type = "item", name = itemName, amount = 2},
                },
                results = {
                    {type = "item", name = "iron", amount = 1},
                }
            }
        end

        gameScript = LuaGameScript.make(data)
    end)

    local prototypes
    before_each(function()
        prototypes = PrototypeDatabase.new(gameScript)
    end)

    it(".new()", function()
        assert.is_not_nil(prototypes.intermediates)
        assert.is_not_nil(prototypes.transforms)
        assert.is_not_nil(prototypes.simpleCycles)
        assert.is_not_nil(prototypes.sinkCache)
    end)

    it(":rebuild()", function()
        prototypes:rebuild(gameScript)
        local unstacking = prototypes.transforms.recipe.unstacking
        local stacking = prototypes.transforms.recipe.stacking
        assert.is_not_nil(prototypes.intermediates.item.ironStack)
        assert.is_not_nil(prototypes.transforms.recipe.unstacking)
        assert.are.same(prototypes.simpleCycles.nonPositive[stacking],{
            [unstacking] = true,
        })
        local indirect7 = prototypes.transforms.recipe.indirect7
        assert.are.equals(prototypes.sinkCache.indirectThresholds.normal[indirect7], 15)
    end)

    it(".setmetatable()", function()
        prototypes:rebuild(gameScript)
        SaveLoadTester.run{
            objects = prototypes,
            metatableSetter = PrototypeDatabase.setmetatable,
        }
    end)
end)
