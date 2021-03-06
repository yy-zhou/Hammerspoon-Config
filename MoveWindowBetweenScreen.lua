-- lua script for Hammerspoon

local hotkey = require 'hs.hotkey'
local window = require 'hs.window'
local geometry = require 'hs.geometry'
local drawing = require 'hs.drawing'
local mouse = require 'hs.mouse'

local moveWindow = {'cmd', 'ctrl', 'shift'}

window.animationDuration = 0

-- Function that can be used in init.lua
function move_window()
   
    -- Move window between monitors: ⌘ + ^ + ⇧ + e 
    hotkey.bind(moveWindow, 'e', function() moveWindowOneScreen('next') end)
    -- hotkey.bind(moveWindow, '1', function() moveWindowOneScreen('previous') end)
end

-- Local Functions
function moveWindowOneScreen(type)
    local win = getGoodFocusedWindow(true)
    if not win then return end

    local screen = nil
    if type == 'next' then
        hs.alert.show("Next Monitor")
        screen = win:screen():next()
    elseif type == 'previous' then
        hs.alert.show("Prev Monitor")
        screen = win:screen():previous()
    else
        return
    end

    win:moveToScreen(screen)
end

function getGoodFocusedWindow(isNoFull)
    local win = window.focusedWindow()
    if not win or not win:isStandard() then return end
    if isNoFull and win:isFullScreen() then return end
    return win
end

function setFrame(win, unit)
    if not win then
        return nil
    end

    local id = win:id()
    local state = win:frame()
    snapbackStates[id] = state
    return win:setFrame(unit)
end

local mouseCircle = nil
local mouseCircleTimer = nil

function hs.window:moveToScreen(nextScreen)
    local currentFrame = self:frame()
    local screenFrame = self:screen():frame()
    local nextScreenFrame = nextScreen:frame()
    self:setFrame({
        x = ((((currentFrame.x - screenFrame.x) / screenFrame.w) * nextScreenFrame.w) + nextScreenFrame.x),
        y = ((((currentFrame.y - screenFrame.y) / screenFrame.h) * nextScreenFrame.h) + nextScreenFrame.y),
        h = currentFrame.h,
        w = currentFrame.w
    })
end
