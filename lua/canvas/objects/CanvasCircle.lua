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

local AbstractCanvasObject = require("lua/canvas/objects/AbstractCanvasObject")
local ErrorOnInvalidRead = require("lua/containers/ErrorOnInvalidRead")

-- Class used to draw a circle on a Canvas.
--
-- RO fields: all from AbstractCanvasObject.
--
local CanvasCircle = ErrorOnInvalidRead.new{
    -- Creates a new CanvasCircle, and its associated rendering id.
    --
    -- Args:
    -- * initData: Table passed to the rendering API to generate the circle id.
    --
    -- Returns: The new CanvasCircle object.
    --
    makeFromInitData = function(initData)
        return AbstractCanvasObject.new{
            id = rendering.draw_circle(initData),
            type = "circle",
        }
    end,

    -- Restores the metatable of a CanvasCircle instance, and all its owned objects.
    setmetatable = AbstractCanvasObject.setmetatable,
}

AbstractCanvasObject.Factory:registerClass("circle", CanvasCircle)
return CanvasCircle
