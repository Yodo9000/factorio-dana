﻿-- This file is part of Dana.
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

local GuiElement = require("lua/gui/GuiElement")
local MockFactorio = require("lua/testing/mocks/MockFactorio")
local SaveLoadTester = require("lua/testing/SaveLoadTester")
local TreeBox = require("lua/gui/TreeBox")

describe("TreeBox", function()
    local factorio
    local player
    local parent
    setup(function()
        factorio = MockFactorio.make{
            rawData = {},
        }
        player = factorio:createPlayer{
            forceName = "player",
        }
        parent = player.gui.center
        factorio:setup()
    end)

    before_each(function()
        parent.clear()
        GuiElement.on_init()
    end)

    it(".new()", function()
        local treeBox = TreeBox.new{
            roots = {
                {
                    caption = "top1",
                    children = {
                        {
                            caption = "child_1a",
                        },{
                            caption = "child_1b",
                        },
                    },
                    expanded = true,
                },{
                    caption = "top2",
                    selectable = true,
                }
            },
        }
        assert.are.same(treeBox,{
            roots = {
                count = 2,
                [1] = {
                    caption = "top1",
                    children = {
                        count = 2,
                        [1] = {
                            caption = "child_1a",
                            children = {count = 0},
                            depth = 1,
                            expanded = false,
                            isLast = false,
                            selectable = false,
                            selected = false,
                            treeBox = treeBox,
                        },
                        [2] = {
                            caption = "child_1b",
                            children = {count = 0},
                            depth = 1,
                            expanded = false,
                            isLast = true,
                            selectable = false,
                            selected = false,
                            treeBox = treeBox,
                        },
                    },
                    depth = 0,
                    expanded = true,
                    isLast = false,
                    selectable = false,
                    selected = false,
                    treeBox = treeBox,
                },
                [2] = {
                    caption = "top2",
                    children = {count = 0},
                    depth = 0,
                    expanded = false,
                    isLast = true,
                    selectable = true,
                    selected = false,
                    treeBox = treeBox,
                },
            },
        })
    end)

    describe(".setmetatable()", function()
        local treeBox

        before_each(function()
            treeBox = TreeBox.new{
                roots = {
                    {
                        caption = "top1",
                        children = {
                            {
                                caption = "middle1",
                                children = {
                                    {
                                        caption = "bottom1",
                                    },
                                },
                            },
                        },
                    },
                },
            }
        end)

        it("-- no gui", function()
            SaveLoadTester.run{
                objects = treeBox,
                metatableSetter = TreeBox.setmetatable,
            }
        end)

        it("-- with gui", function()
            treeBox:makeGui(parent)

            SaveLoadTester.run{
                objects = treeBox,
                metatableSetter = TreeBox.setmetatable,
            }
        end)
    end)

    describe(":close()", function()
        local treeBox
        before_each(function()
            treeBox = TreeBox.new{
                roots = {
                    {
                        caption = "top1",
                        children = {
                            {
                                caption = "child_1a",
                            },
                        },
                    },
                },
            }
        end)

        it("-- no gui", function()
            treeBox:close()
        end)

        it("-- with gui", function()
            treeBox:makeGui(parent)
            local gui = treeBox.gui
            treeBox:close()

            assert.is_false(gui.flow.valid)
            assert.is_nil(rawget(treeBox, "gui"))
            assert.is_nil(rawget(treeBox.roots[1], "gui"))
            assert.are.equals(GuiElement.count(player.index), 0)
        end)
    end)

    describe(":makeGui()", function()
        local treeBox
        before_each(function()
            treeBox = TreeBox.new{
                roots = {
                    caption = "top1",
                    children = {
                        {
                            caption = "child_1a",
                        },
                    },
                },
            }
        end)

        it("-- valid", function()
            treeBox:makeGui(parent)

            assert.is_not_nil(treeBox.gui.flow)
            assert.are.same(treeBox.gui, {
                flow = treeBox.gui.flow,
                parent = parent,
                treeBox = treeBox,
            })
        end)

        it("-- invalid (duplicate gui)", function()
            treeBox:makeGui(parent)
            assert.error(function()
                treeBox:makeGui(parent)
            end)
        end)
    end)

    describe(":setSelection() -- not selectable", function()
        local treeBox = TreeBox.new{
            roots = {
                {
                    caption = "foobar",
                },
            },
        }
        treeBox:setSelection(treeBox.roots[1])
        assert.is_nil(rawget(treeBox, "selection"))
    end)
end)

describe("TreeBoxNode", function()
    local factorio
    local player
    local parent
    setup(function()
        factorio = MockFactorio.make{
            rawData = {},
        }
        player = factorio:createPlayer{
            forceName = "player",
        }
        parent = player.gui.center
        factorio:setup()
    end)

    local treeBox
    before_each(function()
        parent.clear()
        GuiElement.on_init()

        treeBox = TreeBox.new{
            roots = {
                {
                    caption = "first",
                    children = {
                        {
                            caption = "first_1",
                            selectable = true,
                        },
                    },
                    expanded = true,
                },{
                    caption = "second",
                    children = {
                        {
                            caption = "second_1",
                            selectable = true,
                        },{
                            caption = "second_2",
                            selectable = true,
                        },
                    },
                    expanded = false,
                },
            },
        }
    end)

    describe(":setSelected()", function()
        it("-- no gui", function()
            local node = treeBox.roots[1].children[1]
            node:setSelected(true)
            assert.is_true(node.selected)
        end)

        describe("-- gui", function()
            before_each(function()
                treeBox:makeGui(parent)
            end)

            it(", true & selectable", function()
                local node = treeBox.roots[2].children[1]
                node:setSelected(true)
                assert.is_true(node.selected)
                local selectStyle = node.gui.selectLabel.rawElement.style
                assert.are.equals(selectStyle.font, "default-bold")
                assert.are_not.equals(selectStyle.font_color[1], 1)
            end)

            it(", true & not selectable", function()
                local node = treeBox.roots[1]
                node:setSelected(true)
                assert.is_false(node.selected)
            end)

            it(", false", function()
                local node = treeBox.roots[2].children[1]
                node:setSelected(false)
                assert.is_false(node.selected)
                local selectStyle = node.gui.selectLabel.rawElement.style
                assert.are.equals(selectStyle.font, "default")
                assert.are.equals(selectStyle.font_color[1], 1)
            end)
        end)
    end)

    describe(":toggleExpanded()", function()
        describe("-- no gui", function()
            it(", true -> false", function()
                local node = treeBox.roots[1]
                node:toggleExpanded()
                assert.is_false(node.expanded)
            end)

            it(", false -> true", function()
                local node = treeBox.roots[2]
                node:toggleExpanded()
                assert.is_true(node.expanded)
            end)
        end)

        describe("-- with gui", function()
            before_each(function()
                treeBox:makeGui(parent)
            end)

            it(", true -> false", function()
                local node = treeBox.roots[1]
                node:toggleExpanded()
                assert.is_false(node.expanded)
                assert.is_false(node.gui.childrenFlow.visible)
                assert.are.equals(node.gui.headerFlow.children[1].caption, "▶ ")
            end)

            it(", false -> true", function()
                local node = treeBox.roots[2]
                node:toggleExpanded()
                assert.is_true(node.expanded)
                assert.is_true(node.gui.childrenFlow.visible)
                assert.are.equals(node.gui.headerFlow.children[1].caption, "▼ ")
            end)
        end)
    end)

    describe("-- GUI:", function()
        before_each(function()
            treeBox:makeGui(parent)
        end)

        it("ExpandLabel", function()
            GuiElement.on_gui_click{
                player_index = player.index,
                element = treeBox.roots[1].gui.headerFlow.children[1],
            }
            assert.is_false(treeBox.roots[1].expanded)
        end)

        it("SelectLabel", function()
            GuiElement.on_gui_click{
                player_index = player.index,
                element = treeBox.roots[2].children[1].gui.headerFlow.children[3],
            }
            assert.is_true(treeBox.roots[2].children[1].selected)

            GuiElement.on_gui_click{
                player_index = player.index,
                element = treeBox.roots[1].children[1].gui.headerFlow.children[3]
            }
            assert.is_true(treeBox.roots[1].children[1].selected)
            assert.is_false(treeBox.roots[2].children[1].selected)
        end)
    end)
end)
