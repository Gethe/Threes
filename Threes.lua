local NAME, db = ...
Threes = db
--TODO
  --Pause button


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
end)
Threes.frame:SetScript("OnEnter", function ( ... )
    Threes.frame:EnableKeyboard(true)
end)
Threes.frame:SetScript("OnLeave", function ( ... )
    Threes.frame:EnableKeyboard(false)
end)

for row = 1, 4 do
    for col = 1, 4 do
        local inset = CreateFrame("Frame", nil, Threes.frame, "InsetFrameTemplate")
        inset:SetSize(80, 120)
        local tile = CreateFrame("Button", nil, inset, "UIPanelButtonTemplate")
        tile:EnableMouse(false)
        tile:Hide()
        if col == 1 then
            if row == 1 then
                --TOPLEFT inset anchors all the rest
                inset:SetPoint("TOPLEFT", 5, -25)
                tile:Show()
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

function Threes:UP()
    for col = 1, 4 do
        for row = 1, 4 do
            local nextRow = row - 1
            if Threes["tile_"..col.."_"..row]:IsShown() and (nextRow >= 1) then
                Threes["tile_"..col.."_"..row]:Hide()
                Threes["tile_"..col.."_"..nextRow]:Show()
            end
        end
    end
end
function Threes:DOWN()
    for col = 1, 4 do
        for row = 4, 1, -1 do
            local nextRow = row + 1
            if Threes["tile_"..col.."_"..row]:IsShown() and (nextRow <= 4) then
                Threes["tile_"..col.."_"..row]:Hide()
                Threes["tile_"..col.."_"..nextRow]:Show()
            end
        end
    end
end
function Threes:LEFT()
    for row = 1, 4 do
        for col = 1, 4 do
            local nextCol = col - 1
            if Threes["tile_"..col.."_"..row]:IsShown() and (nextCol >= 1) then
                Threes["tile_"..col.."_"..row]:Hide()
                Threes["tile_"..nextCol.."_"..row]:Show()
            end
        end
    end
end
function Threes:RIGHT()
    for row = 1, 4 do
        for col = 4, 1, -1 do
            local nextCol = col + 1
            if Threes["tile_"..col.."_"..row]:IsShown() and (nextCol <= 4) then
                Threes["tile_"..col.."_"..row]:Hide()
                Threes["tile_"..nextCol.."_"..row]:Show()
            end
        end
    end
end


-- Slash Commands
SLASH_THREES1 = "/threes"
function SlashCmdList.THREES(msg, editBox)
    print("msg:", msg)
    Threes.frame:Show()
end
