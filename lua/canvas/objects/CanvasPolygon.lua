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

-- Class used to draw a polygon on a Canvas.
--
-- RO fields: all from AbstractCanvasObject.
--
local CanvasPolygon = ErrorOnInvalidRead.new{
    -- Creates a new CanvasPolygon, and its associated rendering id.
    --
    -- Args:
    -- * initData: Table passed to the rendering API to generate the id.
    --
    -- Returns: The new CanvasPolygon object.
    --
    makeFromInitData = function(initData)
        return AbstractCanvasObject.new{
            id = (rendering.draw_polygon(initData)).id,
            type = "polygon",
        }
    end,

    -- Restores the metatable of a CanvasPolygon instance, and all its owned objects.
    setmetatable = AbstractCanvasObject.setmetatable,
}

AbstractCanvasObject.Factory:registerClass("polygon", CanvasPolygon)
return CanvasPolygon
