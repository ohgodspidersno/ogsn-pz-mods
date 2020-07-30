
function ISSineWaveDisplay:update()
  ISPanel.update(self);

  local isPaused = UIManager.getSpeedControls|() and UIManager.getSpeedControls|():getCurrentGameSpeed() == 0
  if isPaused then return end

  if self.isOn then
    local p, w, h = self.waveParams, self:getWidth(), self:getHeight();
    -- sine wave
    local ticks = UIManager.getSecondsSinceLastUpdate() * 30
    self.waveCntr = self.waveCntr + ticks
    if (not self.wave) or self.waveCntr >= self.waveUpdInt or self.hasChanged then
      local height = ZombRand((h / 2) * p.minH, (h / 2) * p.maxH);
      self.wave = self:getWaveData(ZombRand(100 * p.minLen, 100 * p.maxLen), - height, height);
      self.waveUpdInt = ZombRand(p.minSpeed, p.maxSpeed);
      self.offsetUpdInt = ZombRand(p.minUpd, p.maxUpd);
      self.waveCntr = 0;
      self.hasChanged = false;
    end

    self.offsetCntr = self.offsetCntr + ticks;
    if self.offsetCntr >= self.offsetUpdInt then
      self.offsetCntr = 0;
      self.offset = self.offset + 1;
      if self.offset >= #self.wave - 1 then self.offset = 0; end
    end
  end
end
