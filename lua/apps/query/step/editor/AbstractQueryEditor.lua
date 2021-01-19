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

local AbstractFactory = require("lua/class/AbstractFactory")
local AbstractQuery = require("lua/query/AbstractQuery")
local AbstractStepWindow = require("lua/apps/query/step/AbstractStepWindow")
local ClassLogger = require("lua/logger/ClassLogger")
local Closeable = require("lua/class/Closeable")
local ErrorOnInvalidRead = require("lua/containers/ErrorOnInvalidRead")
local GuiQueryEditor = require("lua/apps/query/step/editor/GuiQueryEditor")
local MetaUtils = require("lua/class/MetaUtils")

local cLogger = ClassLogger.new{className = "AbstractQueryEditor"}
local super = AbstractStepWindow.Metatable.__index

local StepName

-- Class used to generate a GUI to edit an AbstractQuery.
--
-- Inherits from AbstractStepWindow.
--
-- RO Fields:
-- * query: AbstractQuery. The edited query.
-- * paramsEditor: AbstractGuiController or nil. Current editor.
-- + AbstractStepWindow.
--
local AbstractQueryEditor = ErrorOnInvalidRead.new{
    -- Factory instance able to restore metatables of AbstractQueryEditor objects.
    Factory = AbstractFactory.new{
        enableMake = true,

        getClassNameOfObject = function(object)
            return object.query.queryType
        end,
    },

    -- Creates a new AbstractQueryEditor object.
    --
    -- Args:
    -- * object: table.
    -- * metatable: table. Metatable to set.
    -- * queryType: Expected value at `self.query.queryType`.
    --
    -- Returns: AbstractQueryEditor. The `object` argument.
    --
    make = function(object, metatable, queryType)
        object.stepName = StepName

        local query = cLogger:assertField(object, "query")
        if query.queryType ~= queryType then
            cLogger:error("Invalid filter type (found: " .. query.queryType .. ", expected: " .. queryType .. ").")
        end

        AbstractStepWindow.new(object, metatable)
        return object
    end,

    -- Metatable of the AbstractQueryEditor class.
    Metatable = MetaUtils.derive(AbstractStepWindow.Metatable, {
        __index = {
            -- Implements AbstractStepWindow:close().
            close = function(self)
                super.close(self)
                Closeable.safeClose(rawget(self, "paramsEditor"))
            end,

            -- Implements AbstractStepWindow:makeGui().
            makeGui = function(self, parent)
                return GuiQueryEditor.new{
                    controller = self,
                    parent = parent,
                }
            end,

            -- Creates a new GUI controller to edit a specific subset of parameters.
            --
            -- Args:
            -- * self: AbstractQueryEditor.
            -- * name: string. Identifier of the editor to open.
            --
            -- Returns: AbstractGuiController. The new editor.
            --
            makeParamsEditor = function(self, name)
                cLogger:error("Unknown paramsEditor name: " .. name .. ".")
            end,

            -- Runs the query in the application.
            --
            -- Args:
            -- * self: QueryAppInterface object.
            --
            runQueryAndDraw = function(self)
                self.appInterface:runQueryAndDraw(self.query)
            end,

            -- Sets the "paramsEditor" field.
            --
            -- Args:
            -- * self: AbstractQueryEditor.
            -- * name: string. Identifier of the editor to open.
            --
            setParamsEditor = function(self, name)
                Closeable.safeClose(rawget(self, "paramsEditor"))
                self.paramsEditor = self:makeParamsEditor(name)

                local gui = rawget(self, "gui")
                if gui then
                    gui:updateParamsEditor()
                end
            end,
        },
    }),

    -- Restores the metatable of a AbstractQueryEditor object, and all its owned objects.
    --
    -- Args:
    -- * object: table.
    -- * metatable: table. Metatable to set.
    --
    setmetatable = function(object, metatable)
        AbstractStepWindow.setmetatable(object, metatable, GuiQueryEditor.setmetatable)
        AbstractQuery.Factory:restoreMetatable(object.query)
    end,
}

-- Unique name for this step.
StepName = "queryEditor"

AbstractStepWindow.Factory:registerClass(StepName, AbstractQueryEditor)
return AbstractQueryEditor
