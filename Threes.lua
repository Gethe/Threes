local NAME, db = ...
Threes = db
--TODO
  --Pause button
  --fade tile in <direction> OnHide

local inProgress = false
local moves = false

local tileMap = {
    "1_1",
    "2_1",
    "3_1",
    "4_1",
    "1_2",
    "2_2",
    "3_2",
    "4_2",
    "1_3",
    "2_3",
    "3_3",
    "4_3",
    "1_4",
    "2_4",
    "3_4",
    "4_4",
}

Threes.frame = CreateFrame("Frame", nil, UIParent, "BasicFrameTemplate")
Threes.frame:SetSize(400, 600)
Threes.frame:SetPoint("CENTER")
Threes.frame.TitleText:SetText("Threes!")

Threes.frame:EnableMouse(true)
Threes.frame:SetMovable(true)
Threes.frame:RegisterForDrag("LeftButton")
Threes.frame:SetScript("OnDragStart", Threes.frame.StartMoving)
Threes.frame:SetScript("OnDragStop", Threes.frame.StopMovingOrSizing)
Threes.frame:SetScript("OnKeyDown", function (self, key )
    print(key)
    if (key == "UP") or (key == "DOWN") or (key == "LEFT") or (key == "RIGHT") then
        Threes[key]()
    end
    inProgress = true
end)
Threes.frame:SetScript("OnEnter", function ( ... )
    Threes.frame:EnableKeyboard(true)
end)
Threes.frame:SetScript("OnLeave", function ( ... )
    Threes.frame:EnableKeyboard(false)
end)
Threes.frame:SetScript("OnShow", function ( self )
    if not inProgress then
        Threes:newGame()
    end
end)

Threes.nextTile = CreateFrame("Button", nil, Threes.frame, "UIPanelButtonTemplate")
Threes.nextTile:SetSize(40, 60)
Threes.nextTile:EnableMouse(false)
Threes.nextTile:SetPoint("BOTTOMRIGHT", -5, 5)

Threes.newGameBtn = CreateFrame("Button", nil, Threes.frame, "UIPanelButtonTemplate")
Threes.newGameBtn:SetText("New Game")
Threes.newGameBtn:SetSize(50, 22)
Threes.newGameBtn:SetPoint("BOTTOMLEFT", 5, 5)
Threes.newGameBtn:SetScript("OnClick", function ( ... )
    Threes:newGame()
    inProgress = false
end)

for row = 1, 4 do
    for col = 1, 4 do
        local inset = CreateFrame("Frame", nil, Threes.frame, "InsetFrameTemplate")
        inset:SetSize(80, 120)
        local tile = CreateFrame("Button", nil, inset, "UIPanelButtonTemplate")
        tile:SetNormalFontObject("SystemFont_OutlineThick_WTF2")
        tile:EnableMouse(false)
        tile:Hide()
        if col == 1 then
            if row == 1 then
                --TOPLEFT inset anchors all the rest
                inset:SetPoint("TOPLEFT", 5, -25)
            else
                --Col 1 anchors to the inset above it
                inset:SetPoint("TOPLEFT", Threes["inset_"..col.."_"..row - 1], "BOTTOMLEFT", 0, -5)
            end
        else
            --Succesive columns anchor to the inset left of it
            inset:SetPoint("TOPLEFT", Threes["inset_"..col - 1 .."_"..row], "TOPRIGHT", 5, 0)
        end
        --tile:ClearAllPoints()
        tile:SetAllPoints(inset)
        Threes["inset_"..col.."_"..row] = inset
        Threes["tile_"..col.."_"..row] = tile
    end
end

--Key press events
function Threes:UP()
    moves = false
    for col = 1, 4 do
        for row = 1, 4 do
            local nextRow = row - 1
            local tile = Threes["tile_"..col.."_"..row]
            local nextTile = Threes["tile_"..col.."_"..nextRow]
            Threes:calcMove(tile, row, nextTile, nextRow, (nextRow >= 1))
        end
    end
    if moves then
        local numTiles = 0
        for i = 1, 8 do
            local rand = fastrandom(1, 4)
            local newTile = Threes["tile_"..rand.."_4"]
            if not newTile:IsShown() then
                newTile:Show()
                local r, g, b = Threes.nextTile.Right:GetVertexColor()
                newTile:SetText(Threes.nextTile:GetText())
                newTile.Left:SetVertexColor(r, g, b)
                newTile.Right:SetVertexColor(r, g, b)
                newTile.Middle:SetVertexColor(r, g, b)
                numTiles = numTiles + 1
            end
            if numTiles == 1 then
                break
            end
        end
        Threes:createTile(Threes.nextTile)
    end
end
function Threes:DOWN()
    moves = false
    for col = 1, 4 do
        for row = 4, 1, -1 do
            local nextRow = row + 1
            local tile = Threes["tile_"..col.."_"..row]
            local nextTile = Threes["tile_"..col.."_"..nextRow]
            Threes:calcMove(tile, row, nextTile, nextRow, (nextRow <= 4))
        end
    end
    if moves then
        local numTiles = 0
        for i = 1, 8 do
            local rand = fastrandom(1, 4)
            local newTile = Threes["tile_"..rand.."_1"]
            if not newTile:IsShown() then
                newTile:Show()
                local r, g, b = Threes.nextTile.Right:GetVertexColor()
                newTile:SetText(Threes.nextTile:GetText())
                newTile.Left:SetVertexColor(r, g, b)
                newTile.Right:SetVertexColor(r, g, b)
                newTile.Middle:SetVertexColor(r, g, b)
                numTiles = numTiles + 1
            end
            if numTiles == 1 then
                break
            end
        end
        Threes:createTile(Threes.nextTile)
    end
end
function Threes:LEFT()
    moves = false
    for row = 1, 4 do
        for col = 1, 4 do
            local nextCol = col - 1
            local tile = Threes["tile_"..col.."_"..row]
            local nextTile = Threes["tile_"..nextCol.."_"..row]
            Threes:calcMove(tile, col, nextTile, nextCol, (nextCol >= 1))
        end
    end
    if moves then
        local numTiles = 0
        for i = 1, 8 do
            local rand = fastrandom(1, 4)
            local newTile = Threes["tile_4_"..rand]
            if not newTile:IsShown() then
                newTile:Show()
                local r, g, b = Threes.nextTile.Right:GetVertexColor()
                newTile:SetText(Threes.nextTile:GetText())
                newTile.Left:SetVertexColor(r, g, b)
                newTile.Right:SetVertexColor(r, g, b)
                newTile.Middle:SetVertexColor(r, g, b)
                numTiles = numTiles + 1
            end
            if numTiles == 1 then
                break
            end
        end
        Threes:createTile(Threes.nextTile)
    end
end
function Threes:RIGHT()
    moves = false
    for row = 1, 4 do
        for col = 4, 1, -1 do
            local nextCol = col + 1
            local tile = Threes["tile_"..col.."_"..row]
            local nextTile = Threes["tile_"..nextCol.."_"..row]
            Threes:calcMove(tile, col, nextTile, nextCol, (nextCol <= 4))
        end
    end
    if moves then
        local numTiles = 0
        for i = 1, 8 do
            local rand = fastrandom(1, 4)
            local newTile = Threes["tile_1_"..rand]
            if not newTile:IsShown() then
                newTile:Show()
                local r, g, b = Threes.nextTile.Right:GetVertexColor()
                newTile:SetText(Threes.nextTile:GetText())
                newTile.Left:SetVertexColor(r, g, b)
                newTile.Right:SetVertexColor(r, g, b)
                newTile.Middle:SetVertexColor(r, g, b)
                numTiles = numTiles + 1
            end
            if numTiles == 1 then
                break
            end
        end
        Threes:createTile(Threes.nextTile)
    end
end

local isPushable = {}
function Threes:calcMove(tile, line, nextTile, nextLine, notBorder)
    print("-------")
    isPushable = {
        true,
        true,
        true,
        true,
    }
    if tile:IsShown() then
        if notBorder then
            local text = Threes:canCombine(tile, nextTile)
            local r, g, b = tile.Right:GetVertexColor()
            print(text)
            
            if nextTile:IsShown() then
                if text then
                    print("combine")
                    --combine tile
                    tile:Hide()
                    nextTile:SetText(text)
                    nextTile.Left:SetVertexColor(r, g, b)
                    nextTile.Right:SetVertexColor(r, g, b)
                    nextTile.Middle:SetVertexColor(r, g, b)
                    moves = true
                elseif isPushable[nextLine] then
                    print("no push")
                    --tile is against a border tile, dont move it
                    isPushable[line] = false
                end
            else
                print("move")
                --move tile
                nextTile:Show()
                nextTile:SetText(tile:GetText())
                nextTile.Left:SetVertexColor(r, g, b)
                nextTile.Right:SetVertexColor(r, g, b)
                nextTile.Middle:SetVertexColor(r, g, b)
                tile:Hide()
                moves = true
            end
        else
            print("border")
            --tile is at a border, dont move it
            isPushable[line] = false
        end
    end
end

function Threes:canCombine(tile, nextTile)
    local txt = tonumber(tile:GetText()) 
    local nextTxt = tonumber(nextTile:GetText())
    print(txt, nextTxt)
    if txt and nextTxt then
        if (txt > 2) and (txt == nextTxt) then
            return txt + nextTxt
        elseif (txt == 1) and (nextTxt == 2) then
            return txt + nextTxt
        elseif (txt == 2) and (nextTxt == 1) then
            return txt + nextTxt
        else
            return false
        end
    else
        return false
    end
end

function Threes:createTile(tile)
    local randNum = fastrandom(-1, 2)
    if randNum == -1 then
        tile:SetText("1")
        tile.Left:SetVertexColor(0.5, 0.5, 1)
        tile.Right:SetVertexColor(0.5, 0.5, 1)
        tile.Middle:SetVertexColor(0.5, 0.5, 1)
    elseif randNum == 0 then
        tile:SetText("2")
        tile.Left:SetVertexColor(1, 0.5, 0.5)
        tile.Right:SetVertexColor(1, 0.5, 0.5)
        tile.Middle:SetVertexColor(1, 0.5, 0.5)
    else
        tile:SetText(randNum * 3)
        tile.Left:SetVertexColor(0.5, 0.5, 0.5)
        tile.Right:SetVertexColor(0.5, 0.5, 0.5)
        tile.Middle:SetVertexColor(0.5, 0.5, 0.5)
    end
end

function Threes:clear()
    for i = 1, 16 do
        local coord = tileMap[i]
        self["tile_"..coord]:Hide()
    end
end
function Threes:newGame()
    self:clear()
    local numTiles = 0
    for i = 1, 16 do
        local randTile = fastrandom(1, 16)
        local coord = tileMap[randTile]
        --print(tileMap[randTile])
        if not self["tile_"..coord]:IsShown() then
            self["tile_"..coord]:Show()
            Threes:createTile(self["tile_"..coord])
            numTiles = numTiles + 1
        end
        if numTiles == 8 then
            break
        end
    end
    Threes:createTile(Threes.nextTile)
end

-- Slash Commands
SLASH_THREES1 = "/threes"
function SlashCmdList.THREES(msg, editBox)
    print("msg:", msg)
    Threes.frame:Show()
end
