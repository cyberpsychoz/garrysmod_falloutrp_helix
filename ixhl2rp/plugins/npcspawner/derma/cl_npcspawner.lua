
local PANEL = {}

function PANEL:Setup(entity)
    self.entity = entity

    self.enabledBoolValue = self.entity:GetEnabled()
    self.enabledBool:SetChecked(self.entity:GetEnabled(), true)
    self.npcClassValue = self.entity:GetNPCClass()
    self.npcClassText:SetValue(self.entity:GetNPCClass())
    self.spawnRadiusValue = self.entity:GetNPCSpawnRadius()
    self.spawnRadiusSlider:SetValue(self.entity:GetNPCSpawnRadius())
    self.playerRadiusValue = self.entity:GetPlayerRadius()
    self.playerRadiusSlider:SetValue(self.entity:GetPlayerRadius())
    self.maxNPCValue = self.entity:GetMaxNPCs()
    self.maxNPCSlider:SetValue(self.entity:GetMaxNPCs())
    self.spawnAmountValue = self.entity:GetSpawnAmount()
    self.spawnAmountSlider:SetValue(self.entity:GetSpawnAmount())
    self.spawnIntervalValue = self.entity:GetSpawnInterval()
    self.spawnIntervalSlider:SetValue(self.entity:GetSpawnInterval())
end

function PANEL:Init()
    self:SetSize(ScrW() * 0.45, ScrH() * 0.4)
    self:SetTitle(L("npcSpawnerManager"))
    self:Center()
    self:SetMouseInputEnabled(true)
    self:MakePopup()

    self.npcSpawnerPanel = self:Add("DPanel")
    self.npcSpawnerPanel:Dock(FILL)

    self.npcSpawnerPanel.AddRow = function(panel)
        local row = panel:Add("DPanel")
        AccessorFunc(row, "bShowReset", "ShowReset", FORCE_BOOL)
        row:Dock(TOP)
        row:SetWide(panel:GetWide() * 0.5 - 7)
        row:SetTall(ScrW() * 0.025)

        row.AddLabel = function(parent, text)
            local label = row:Add("DLabel")
            label:Dock(LEFT)
            label:Center()
            label:SetWide(self:GetWide())
            label:SetText(text)
            label:SetTextInset(4, 0)
            label:SetTextColor(color_white)
            label:SetFont("ixMediumFont")
        end

        row.AddSlider = function(parent, value, min, max, fValueChanged)
            row.slider = row:Add("ixNumSlider")
            row.slider:Dock(RIGHT)
            row.slider:SetWide(self:GetWide() * .4)
            row.slider:SetValue(value)
            row.slider:SetMin(min)
            row.slider:SetMax(max)
            row.slider.OnValueChanged = fValueChanged

            local sliderLabel = row.slider:GetLabel()
            sliderLabel:SetCursor("hand")
            sliderLabel:SetMouseInputEnabled(true)
            sliderLabel.OnMousePressed = function(_, key)
                if (key == MOUSE_LEFT) then
                    if (IsValid(self.entry)) then
                        self.entry:Remove()
                        return
                    end

                    self.entry = vgui.Create("ixSettingsRowNumberEntry")
                    self.entry:Attach(sliderLabel)
                    self.entry:SetValue(self:GetValue(), true)
                    self.entry.OnValueChanged = function(this)
                        local newValue = math.Round(this:GetValue(), row.slider:GetDecimals())

                        if (newValue != self:GetValue()) then
                            row.slider:SetValue(newValue, true)
                            row.slider:OnValueChanged(newValue)
                        end
                    end
                end
            end

            return row.slider
        end

        row.SetShowReset = function(parent, value, name, default)
            value = tobool(value)

            if (value and !IsValid(row.reset)) then
                row.reset = row:Add("DButton")
                row.reset:SetFont("ixSmallTitleIcons")
                row.reset:SetText("x")
                row.reset:SetTextColor(ColorAlpha(derma.GetColor("Warning", row), 100))
                row.reset:Dock(RIGHT)
                row.reset:SizeToContents()
                row.reset.Paint = nil
                row.reset.DoClick = function()
                    row:OnResetClicked()
                end
                row.reset:SetHelixTooltip(function(tooltip)
                    local title = tooltip:AddRow("title")
                    title:SetImportant()
                    title:SetText(L("resetDefault"))
                    title:SetBackgroundColor(derma.GetColor("Warning", row))
                    title:SizeToContents()

                    local description = tooltip:AddRow("description")
                    description:SetText(L("resetDefaultDescription", tostring(name), tostring(default)))
                    description:SizeToContents()
                end)
            elseif (!value and IsValid(row.reset)) then
                row.reset:Remove()
            end

            row.bShowReset = value
        end

        return row
    end

    self.enabledRow = self.npcSpawnerPanel:AddRow()
    self.enabledLabel = self.enabledRow:AddLabel(L("npcSpawnerEnabled"))
    self.enabledBool = self.enabledRow:Add("ixCheckBox")
    self.enabledBool:Dock(RIGHT)
    self.enabledBool.DoClick = function(panel)
        self.enabledBoolValue = panel:GetValue()
        self.enabledRow:SetShowReset(panel:GetValue() != self.entity:GetEnabled(), L("npcSpawnerEnabled"), self.entity:GetEnabled())
    end
    self.enabledRow.OnResetClicked = function()
        self.enabledRow:SetShowReset(false)
        self.enabledBool:SetChecked(self.entity:GetEnabled())
    end

    self.npcClassRow = self.npcSpawnerPanel:AddRow()
    self.npcClassLabel = self.npcClassRow:AddLabel(L("npcSpawnerNPCClass"))
    self.npcClassText = self.npcClassRow:Add("ixTextEntry")
    self.npcClassText:Dock(RIGHT)
    self.npcClassText:SetFont("ixMenuButtonFont")
    self.npcClassText:SetBackgroundColor(derma.GetColor("DarkerBackground", self))
    self.npcClassText:SetWide(self:GetWide() * 0.4)
    self.npcClassText.OnChange = function(panel)
        self.npcClassValue = panel:GetValue()
        self.npcClassRow:SetShowReset(panel:GetValue() != self.entity:GetNPCClass(), L("npcSpawnerNPCClass"), self.entity:GetNPCClass())
    end
    self.npcClassRow.OnResetClicked = function()
        self.npcClassRow:SetShowReset(false)
        self.npcClassText:SetValue(self.entity:GetNPCClass())
    end

    self.spawnRadiusRow = self.npcSpawnerPanel:AddRow()
    self.spawnRadiusLabel = self.spawnRadiusRow:AddLabel(L("npcSpawnerNPCRadius"))
    self.spawnRadiusSlider = self.spawnRadiusRow:AddSlider(0, 50, 16383, function(panel)
        self.spawnRadiusValue = panel:GetValue()
        self.spawnRadiusRow:SetShowReset(panel:GetValue() != self.entity:GetNPCSpawnRadius(), L("npcSpawnerNPCRadius"), self.entity:GetNPCSpawnRadius())
    end)
    self.spawnRadiusRow.OnResetClicked = function()
        self.spawnRadiusRow:SetShowReset(false)
        self.spawnRadiusSlider:SetValue(self.entity:GetNPCSpawnRadius())
    end

    self.playerRadiusRow = self.npcSpawnerPanel:AddRow()
    self.playerRadiusLabel = self.playerRadiusRow:AddLabel(L("npcSpawnerPlayerRadius"))
    self.playerRadiusSlider = self.playerRadiusRow:AddSlider(0, 0, 16383, function(panel)
        self.playerRadiusValue = panel:GetValue()
        self.playerRadiusRow:SetShowReset(panel:GetValue() != self.entity:GetPlayerRadius(), L("npcSpawnerPlayerRadius"), self.entity:GetPlayerRadius())
    end)
    self.playerRadiusRow.OnResetClicked = function()
        self.playerRadiusRow:SetShowReset(false)
        self.playerRadiusSlider:SetValue(self.entity:GetPlayerRadius())
    end

    self.maxNPCRow = self.npcSpawnerPanel:AddRow()
    self.maxNPCLabel = self.maxNPCRow:AddLabel(L("npcSpawnerMaxNPCs"))
    self.maxNPCSlider = self.maxNPCRow:AddSlider(0, 1, 255, function(panel)
        self.maxNPCValue = panel:GetValue()
        self.maxNPCRow:SetShowReset(panel:GetValue() != self.entity:GetMaxNPCs(), L("npcSpawnerMaxNPCs"), self.entity:GetMaxNPCs())
    end)
    self.maxNPCRow.OnResetClicked = function()
        self.maxNPCRow:SetShowReset(false)
        self.maxNPCSlider:SetValue(self.entity:GetMaxNPCs())
    end

    self.spawnIntervalRow = self.npcSpawnerPanel:AddRow()
    self.spawnIntervalLabel = self.spawnIntervalRow:AddLabel(L("npcSpawnerSpawnInterval"))
    self.spawnIntervalSlider = self.spawnIntervalRow:AddSlider(0, 1, 65535, function(panel)
        self.spawnIntervalValue = panel:GetValue()
        self.spawnIntervalRow:SetShowReset(panel:GetValue() != self.entity:GetSpawnInterval(), L("npcSpawnerSpawnInterval"), self.entity:GetSpawnInterval())
    end)
    self.spawnIntervalRow.OnResetClicked = function()
        self.spawnIntervalRow:SetShowReset(false)
        self.spawnIntervalSlider:SetValue(self.entity:GetSpawnInterval())
    end

    self.spawnAmountRow = self.npcSpawnerPanel:AddRow()
    self.spawnAmountLabel = self.spawnAmountRow:AddLabel(L("npcSpawnerSpawnAmount"))
    self.spawnAmountSlider = self.spawnAmountRow:AddSlider(0, 1, 255, function(panel)
        self.spawnAmountValue = panel:GetValue()
        self.spawnAmountRow:SetShowReset(panel:GetValue() != self.entity:GetSpawnAmount(), L("npcSpawnerSpawnAmount"), self.entity:GetSpawnAmount())
    end)
    self.spawnAmountRow.OnResetClicked = function()
        self.spawnAmountRow:SetShowReset(false)
        self.spawnAmountSlider:SetValue(self.entity:GetSpawnAmount())
    end

    self.saveButton = self.npcSpawnerPanel:Add("DButton")
    self.saveButton:SetText(L("npcSpawnerSaveChanges"))
    self.saveButton:SetFont("ixMediumFont")
    self.saveButton:SizeToContents()
    self.saveButton:Dock(FILL)
    self.saveButton.DoClick = function()
        self:SaveChanges()
        self:Remove()
    end
end

function PANEL:OnRemove()

end

function PANEL:SaveChanges()
    if (IsValid(ix.gui.npcSpawnerPools)) then
        ix.gui.npcSpawnerPools:SaveChanges()
    end

    net.Start("npcSpawnerSaveChanges")
        net.WriteEntity(self.entity)
        net.WriteBool(self.enabledBoolValue)
        net.WriteString(self.npcClassValue)
        net.WriteUInt(self.playerRadiusValue, 14)
        net.WriteUInt(self.spawnRadiusValue, 14)
        net.WriteUInt(self.maxNPCValue, 8)
        net.WriteUInt(self.spawnIntervalValue, 16)
        net.WriteUInt(self.spawnAmountValue, 8)
    net.SendToServer()
end

vgui.Register("npcSpawner", PANEL, "DFrame")