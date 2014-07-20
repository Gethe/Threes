local NAME, db = ...
Threes = db


--TODO
  --Pause button
  --fade tile in <direction> OnHide
    --http://www.wowinterface.com/forums/showthread.php?p=291558#post291558

local moves = false
local score = 0
local isPushable = {}
local tileCount = {}

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

----Game Board---
    Threes.frame = CreateFrame("Frame", nil, UIParent)
    local frameBG = Threes.frame:CreateTexture(nil, "BACKGROUND")
    frameBG:SetTexture("Interface\\AddOns\\Threes\\Media\\Frame")
    frameBG:SetTexCoord(0, 0.6875, 0, 1)
    frameBG:SetAllPoints(Threes.frame)
    Threes.frame:SetSize(352, 512)
    Threes.frame:SetPoint("CENTER")
    Threes.frame:Hide()

    Threes.frame:EnableMouse(true)
    Threes.frame:SetMovable(true)
    Threes.frame:RegisterForDrag("LeftButton")
    Threes.frame:SetScript("OnDragStart", Threes.frame.StartMoving)
    Threes.frame:SetScript("OnDragStop", Threes.frame.StopMovingOrSizing)
    Threes.frame:SetScript("OnKeyDown", function (self, key)
        print(key)
        if (key == "UP") or (key == "DOWN") or (key == "LEFT") or (key == "RIGHT") then
            Threes[key]()
        end
    end)
    Threes.frame:SetScript("OnEnter", function (self)
        self:EnableKeyboard(true)
    end)
    Threes.frame:SetScript("OnLeave", function (self)
        self:EnableKeyboard(false)
    end)
    Threes.frame:SetScript("OnShow", function ( self )
        Threes:newGame()
    end)
    Threes.frame:SetScript("OnHide", function ( self )
        Threes:saveGame()
    end)

    Threes.statsBtn = CreateFrame("Button", nil, Threes.frame, "ThreesButtonTemplate")
    Threes.statsBtn:SetText("Stats")
    Threes.statsBtn:SetSize(80, 27)
    Threes.statsBtn:SetPoint("BOTTOMLEFT", Threes.frame, "TOPLEFT", 4, 6)
    Threes.statsBtn:SetScript("OnShow", function (self)
        self.texture:SetVertexColor(.8, .8, .8)
    end)
    Threes.statsBtn:SetScript("OnEnter", function (self)
        self.texture:SetVertexColor(.8, .8, .2)
    end)
    Threes.statsBtn:SetScript("OnLeave", function (self)
        self.texture:SetVertexColor(.8, .8, .8)
    end)
    Threes.statsBtn:SetScript("OnClick", function ( ... )
        Threes.frame:Hide()
        Threes.stats:Show()
    end)

    Threes.closeBtn = CreateFrame("Button", nil, Threes.frame, "ThreesButtonTemplate")
    Threes.closeBtn:SetText("Close")
    Threes.closeBtn:SetSize(80, 27)
    Threes.closeBtn:SetPoint("BOTTOMRIGHT", Threes.frame, "TOPRIGHT", -4, 6)
    Threes.closeBtn:SetScript("OnShow", function (self)
        self.texture:SetVertexColor(.9, 0.3, 0.3)
    end)
    Threes.closeBtn:SetScript("OnEnter", function (self)
        self.texture:SetVertexColor(.9, 0.5, 0.5)
    end)
    Threes.closeBtn:SetScript("OnLeave", function (self)
        self.texture:SetVertexColor(.9, 0.3, 0.3)
    end)
    Threes.closeBtn:SetScript("OnClick", function (self)
        Threes.frame:Hide()
    end)

    Threes.nextTile = CreateFrame("Button", nil, Threes.frame, "ThreesTileTemplate")
    Threes.nextTile.texture:SetTexture("Interface\\AddOns\\Threes\\Media\\tilePreview")
    Threes.nextTile.texture:SetTexCoord(0, 0.625, 0, 1)
    Threes.nextTile:SetPoint("TOPRIGHT", Threes.frame, "TOPLEFT", -4, -4)
    Threes.nextTile:SetSize(40, 64)
    Threes.nextTile:EnableMouse(false)
    Threes.nextTile.text:Hide()

----Stats Frame----
    Threes.stats = CreateFrame("Frame", nil, UIParent)
    local frameBG = Threes.stats:CreateTexture(nil, "BACKGROUND")
    frameBG:SetTexture("Interface\\AddOns\\Threes\\Media\\Frame")
    frameBG:SetTexCoord(0, 0.6875, 0, 1)
    frameBG:SetAllPoints(Threes.stats)
    Threes.stats:Hide()

    Threes.stats:EnableMouse(true)
    Threes.stats:SetMovable(true)
    Threes.stats:RegisterForDrag("LeftButton")
    Threes.stats:SetScript("OnDragStart", Threes.stats.StartMoving)
    Threes.stats:SetScript("OnDragStop", Threes.stats.StopMovingOrSizing)
    Threes.stats:SetScript("OnShow", function ( self )
        Threes.stats:SetAllPoints(Threes.frame)
    end)

    Threes.backBtn = CreateFrame("Button", nil, Threes.stats, "ThreesButtonTemplate")
    Threes.backBtn:SetText(BACK)
    Threes.backBtn:SetSize(80, 27)
    Threes.backBtn:SetPoint("BOTTOMLEFT", Threes.stats, "TOPLEFT", 4, 6)
    Threes.backBtn:SetScript("OnShow", function (self)
        self.texture:SetVertexColor(.8, .8, .8)
    end)
    Threes.backBtn:SetScript("OnEnter", function (self)
        self.texture:SetVertexColor(.8, .8, .2)
    end)
    Threes.backBtn:SetScript("OnLeave", function (self)
        self.texture:SetVertexColor(.8, .8, .8)
    end)
    Threes.backBtn:SetScript("OnClick", function ( ... )
        Threes.stats:Hide()
        Threes.frame:SetAllPoints(Threes.stats)
        Threes.frame:Show()
    end)

    Threes.scoreTxt = Threes.stats:CreateFontString(nil, "ARTWORK", "ThreesFontLarge")
    Threes.scoreTxt:SetPoint("TOPLEFT", Threes.stats, "TOPLEFT", 20, -15)
    Threes.scoreTxt:SetVertexColor(.2, .2, .2)

    Threes.scoreMaxTxt = Threes.stats:CreateFontString(nil, "ARTWORK", "ThreesFontLarge")
    Threes.scoreMaxTxt:SetPoint("TOPLEFT", Threes.stats, "TOPLEFT", 50, -45)
    Threes.scoreMaxTxt:SetVertexColor(.2, .2, .2)

    Threes.newGameBtn = CreateFrame("Button", nil, Threes.stats, "ThreesButtonTemplate")
    Threes.newGameBtn:SetText("New Game")
    Threes.newGameBtn:SetSize(80, 27)
    Threes.newGameBtn:SetPoint("BOTTOM", Threes.stats, "BOTTOM", 0, 6)
    Threes.newGameBtn:SetScript("OnShow", function (self)
        self.texture:SetVertexColor(.8, .8, .8)
    end)
    Threes.newGameBtn:SetScript("OnEnter", function (self)
        self.texture:SetVertexColor(.8, .8, .2)
    end)
    Threes.newGameBtn:SetScript("OnLeave", function (self)
        self.texture:SetVertexColor(.8, .8, .8)
    end)
    Threes.newGameBtn:SetScript("OnClick", function ( ... )
        Threes.stats:Hide()
        Threes.frame:SetAllPoints(Threes.stats)
        Threes.frame:Show()
        Threes:newGame()
    end)

for row = 1, 4 do
    for col = 1, 4 do
        local tile = CreateFrame("Button", nil, Threes.frame, "ThreesTileTemplate")
        tile:SetSize(80, 126)
        tile:EnableMouse(false)
        tile:Hide()
        if col == 1 then
            if row == 1 then
                --TOPLEFT tile anchors all the rest
                tile:SetPoint("TOPLEFT", 4, 2)
            else
                --Col 1 anchors to the tile above it
                tile:SetPoint("TOPLEFT", Threes["tile_"..col.."_"..row - 1], "BOTTOMLEFT", 0, -2)
            end
        else
            --Succesive columns anchor to the tile left of it
            tile:SetPoint("TOPLEFT", Threes["tile_"..col - 1 .."_"..row], "TOPRIGHT", 8, 0)
        end
        --tile:ClearAllPoints()
        tile.rank = 0
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
                Threes:setupTile(newTile, Threes.nextTile.rank)
                numTiles = numTiles + 1
            end
            if numTiles == 1 then
                break
            end
        end
        Threes:setupTile(Threes.nextTile)
        if Threes.nextTile.rank > 1 then
            Threes.nextTile.text:Show()
            Threes.nextTile.text:SetText("+")
        else
            Threes.nextTile.text:Hide()
        end
    end
    Threes:calcScore()
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
                Threes:setupTile(newTile, Threes.nextTile.rank)
                numTiles = numTiles + 1
            end
            if numTiles == 1 then
                break
            end
        end
        Threes:setupTile(Threes.nextTile)
        if Threes.nextTile.rank > 1 then
            Threes.nextTile.text:Show()
            Threes.nextTile.text:SetText("+")
        else
            Threes.nextTile.text:Hide()
        end
    end
    Threes:calcScore()
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
                Threes:setupTile(newTile, Threes.nextTile.rank)
                numTiles = numTiles + 1
            end
            if numTiles == 1 then
                break
            end
        end
        Threes:setupTile(Threes.nextTile)
        if Threes.nextTile.rank > 1 then
            Threes.nextTile.text:Show()
            Threes.nextTile.text:SetText("+")
        else
            Threes.nextTile.text:Hide()
        end
    end
    Threes:calcScore()
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
            if not newTile:IsShown() and isPushable[rand] then
                newTile:Show()
                Threes:setupTile(newTile, Threes.nextTile.rank)
                numTiles = numTiles + 1
            end
            if numTiles == 1 then
                break
            end
        end
        Threes:setupTile(Threes.nextTile)
        if Threes.nextTile.rank > 1 then
            Threes.nextTile.text:Show()
            Threes.nextTile.text:SetText("+")
        else
            Threes.nextTile.text:Hide()
        end
    end
    Threes:calcScore()
end

function Threes:calcMove(tile, line, nextTile, nextLine, notBorder)
    print("-------")
    isPushable = {
        true,
        true,
        true,
        true,
    }
    if tile:IsShown() then
        print("calcMove:rank", tile.rank)
        if notBorder then
            if nextTile:IsShown() then
                local text = self:canCombine(tile, nextTile)
                print("text", text)
                if text then
                    print("combine")
                    --combine tile
                    if text == 3 then
                        tile.rank = 1
                    else
                        tile.rank = tile.rank + 1
                    end
                    self:setupTile(nextTile, tile.rank)
                    tile:Hide()
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
                self:setupTile(nextTile, tile.rank)
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

function Threes:setupTile(tile, rank, newGame)
    print("Setup:", rank, newGame)
    if (newGame) and (rank > 1) then
        rank = fastrandom(-1, 1)
    elseif (not rank) then
        rank = fastrandom(-1, 2) 
        if rank == 2 then 
            rank = fastrandom(-1, 3)
        end
    end
    print("Rank:", rank)
    tile.rank = rank
    if rank == -1 then
        tile:SetText("1")
        tile.texture:SetVertexColor(.2, .2, .8)
        tile.text:SetVertexColor(.8, .8, .8)
    elseif rank == 0 then
        tile:SetText("2")
        tile.texture:SetVertexColor(.8, .2, .2)
        tile.text:SetVertexColor(.8, .8, .8)
    else
        tile:SetText(3 * (2 ^ (rank - 1)))
        tile.texture:SetVertexColor(.9, .9, .9)
        tile.text:SetVertexColor(0, 0, 0)
    end
end

function Threes:calcScore()
    print("calcScore")
    tileCount = {}
    score = 0
    for i = 1, 16 do
        local rank = self["tile_"..tileMap[i]].rank
        print("stats:", rank, score)
        if tileCount[rank] then
            tileCount[rank] = tileCount[rank] + 1
        else
            tileCount[rank] = 1
        end
        if rank > 0 then
            score = score + (3 ^ rank)
        end
    end
    if score > ThreesDB.scoreMax then
        ThreesDB.scoreMax = score
    end

    Threes.scoreTxt:SetText("Current Score: "..score)
    Threes.scoreMaxTxt:SetText("Highest Score: "..ThreesDB.scoreMax)
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
    if ThreesDB.currGame then
        for i = 1, 16 do
            self:setupTile(self["tile_"..tileMap[i]], ThreesDB.currGame[i].rank)
            if ThreesDB.currGame[i].isShown then 
                self["tile_"..tileMap[i]]:Show()
            end
        end
        ThreesDB.currGame = nil
    else
        for i = 1, 16 do
            local randTile = fastrandom(1, 16)
            local coord = tileMap[randTile]
            --print(tileMap[randTile])
            if not self["tile_"..coord]:IsShown() then
                self["tile_"..coord]:Show()
                self:setupTile(self["tile_"..coord], math.floor((numTiles / 2) - 1, 1), true)
                numTiles = numTiles + 1
            end

            if numTiles == 9 then
                break
            end
        end
    end
    self:setupTile(Threes.nextTile)
    if Threes.nextTile.rank > 1 then
        Threes.nextTile.text:Show()
        Threes.nextTile.text:SetText("+")
    else
        Threes.nextTile.text:Hide()
    end
    Threes:calcScore()
end

function Threes:saveGame()
    print("saveGame")
    ThreesDB.currGame = {}
    for i = 1, 16 do
        ThreesDB.currGame[i] = self["tile_"..tileMap[i]]
        ThreesDB.currGame[i].isShown = self["tile_"..tileMap[i]]:IsShown()
    end
end

-- Slash Commands
SLASH_THREES1 = "/threes"
function SlashCmdList.THREES(msg, editBox)
    print("msg:", msg)
    ThreesDB = ThreesDB or {}
    ThreesDB.scoreMax = ThreesDB.scoreMax or 0
    Threes.frame:Show()
end
