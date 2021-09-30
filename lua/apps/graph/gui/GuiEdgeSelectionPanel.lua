-- This file is part of Dana.
-- Copyright (C) 2020,2021 Vincent Saulue-Laborde <vincent_saulue@hotmail.fr>
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

local AbstractGuiSelectionPanel = require("lua/apps/graph/gui/AbstractGuiSelectionPanel")
local ErrorOnInvalidRead = require("lua/containers/ErrorOnInvalidRead")
local GuiMaker = require("lua/gui/GuiMaker")
local GuiSelectionConstants = require("lua/apps/graph/gui/GuiSelectionConstants")
local MetaUtils = require("lua/class/MetaUtils")

local Metatable

-- Instanciated GUI of an EdgeSelectionPanel.
--
-- Inherits from AbstractGuiSelectionPanel.
--
-- RO Fields:
-- * controller (override): EdgeSelectionPanel.
--
local GuiEdgeSelectionPanel = ErrorOnInvalidRead.new{
    -- Creates a new GuiEdgeSelectionPanel object.
    --
    -- RO Fields:
    -- * object: table. Required fields: see AbstractGuiSelectionPanel.new().
    --
    -- Returns: GuiEdgeSelectionPanel. The `object` argument turned into the desired type.
    --
    new = function(object)
        return AbstractGuiSelectionPanel.new(object, Metatable)
    end,

    -- Restores the metatable of an GuiEdgeSelectionPanel, and all its owned objects.
    --
    -- Args:
    -- * object: table.
    --
    setmetatable = function(object)
        AbstractGuiSelectionPanel.setmetatable(object, Metatable)
    end,
}

-- Metatable of the GuiEdgeSelectionPanel class.
Metatable = {
    __index = {
        -- Implements AbstractGuiSelectionPanel.makeElementGui().
        --
        -- Args:
        -- * parent: LuaGuiElement.
        -- * prepNodeIndex: PrepNodeIndex.
        --
        makeElementGui = function(parent, prepNodeIndex)
            local edgeIndex = prepNodeIndex.index

            GuiMaker.run(parent, {
                type = "flow",
                direction = "horizontal",
                children = {
                    GuiSelectionConstants.EdgeTypeIcon[edgeIndex.type],
                    {
                        type = "sprite",
                        name = "edgeIcon",
                        resize_to_sprite = false,
                        sprite = edgeIndex.spritePath,
                        styleModifiers = GuiSelectionConstants.IconStyleModifiers,
                    },{
                        type = "label",
                        caption = edgeIndex:getShortName(),
                    },
                },
            })
        end,

        -- Defines AbstractGuiSelectionPanel.Title.
        Title = {"dana.apps.graph.selectionWindow.edgeCategory"},
    },
}
MetaUtils.derive(AbstractGuiSelectionPanel.Metatable, Metatable)

return GuiEdgeSelectionPanel
