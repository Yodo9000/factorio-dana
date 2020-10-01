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

local AbstractQueryEditor = require("lua/apps/query/editor/AbstractQueryEditor")
local AbstractStepWindow = require("lua/apps/query/gui/AbstractStepWindow")
local ClassLogger = require("lua/logger/ClassLogger")
local ErrorOnInvalidRead = require("lua/containers/ErrorOnInvalidRead")
local GuiElement = require("lua/gui/GuiElement")

-- Importing all AbstractQueryEditor to populate its Factory.
require("lua/apps/query/editor/HowToMakeEditor")
require("lua/apps/query/editor/UsagesOfEditor")

local cLogger = ClassLogger.new{className = "QueryEditorWindow"}

local BackButton
local DrawButton
local StepName

-- GUI Window to edit a the query of a QueryApp.
--
-- RO Fields:
-- * backButton: BackButton object of this window.
-- * drawButton: DrawButton of this window.
-- * queryEditor: AbstractQueryEditor of this window.
--
local QueryEditorWindow = ErrorOnInvalidRead.new{
    -- Creates a new QueryEditorWindow object.
    --
    -- Args:
    -- * object: Table to turn into a QueryEditorWindow object (required field: app).
    --
    -- Returns: The argument turned into a QueryEditorWindow object.
    --
    new = function(object)
        object.stepName = StepName
        AbstractStepWindow.new(object)

        local app = object.app
        object.frame.caption = {"dana.apps.query.queryEditor.title"}

        local innerFrame = object.frame.add{
            type = "frame",
            style = "inside_shallow_frame_with_padding",
            direction = "vertical",
        }
        object.queryEditor = AbstractQueryEditor.Factory:make{
            appResources = app.appController.appResources,
            query = app.query,
            root = innerFrame,
        }
        local bottomFlow = object.frame.add{
            type = "flow",
            direction = "horizontal",
        }
        object.backButton = BackButton.new{
            app = app,
            rawElement = bottomFlow.add{
                type = "button",
                caption = {"gui.cancel"},
                style = "back_button",
            },
        }
        local pusher = bottomFlow.add{
            type = "empty-widget",
            style = "draggable_space_with_no_left_margin",
        }
        pusher.style.horizontally_stretchable = true
        object.drawButton = DrawButton.new{
            app = app,
            rawElement = bottomFlow.add{
                type = "button",
                caption = {"dana.apps.query.queryEditor.draw"},
                style = "confirm_button",
            },
        }
        return object
    end,

    -- Restores the metatable of a QueryEditorWindow object, and all its owned objects.
    --
    -- Args:
    -- * object: table to modify.
    --
    setmetatable = function(object)
        BackButton.setmetatable(object.backButton)
        DrawButton.setmetatable(object.drawButton)
        AbstractQueryEditor.Factory:restoreMetatable(object.queryEditor)
        setmetatable(object, AbstractStepWindow.Metatable)
    end,
}

-- Button to go back to the TemplateSelectWindow.
--
-- Inherits from GuiElement.
--
-- RO Fields:
-- * app: QueryApp owning this button.
--
BackButton = GuiElement.newSubclass{
    className = "QueryEditorWindow/BackButton",
    mandatoryFields = {"app"},
    __index = {
        onClick = function(self, event)
            self.app:popStepWindow()
        end,
    },
}

-- Button to run the query and render the generated graph.
--
-- Inherits from GuiElement.
--
-- RO Fields:
-- * app: QueryApp owning this button.
--
DrawButton = GuiElement.newSubclass{
    className = "QueryEditorWindow/DrawButton",
    mandatoryFields = {"app"},
    __index = {
        onClick = function(self, event)
            self.app:runQueryAndDraw()
        end,
    },
}

-- Unique name for this step.
StepName = "queryEditor"

AbstractStepWindow.Factory:registerClass(StepName, QueryEditorWindow)
return QueryEditorWindow
