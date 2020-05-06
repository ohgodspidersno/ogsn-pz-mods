local cliim = getClimateManager();
local FOG_ID = 5;
local fog = cliim:getClimateFloat(FOG_ID);
local starting_strength = 0.3;
local max_fog = 1;
local min_fog = 0.3;

local fog_strength = starting_strength

local function getNextFogStrength(old_strength)
    local max = max_fog
    local min = min_fog
    local new_strength = (ZombRand(min*10,max*10)+ZombRand(min*10,max*10))/20
    print('new_strength',new_strength)

    -- if new_strength == max or new_strength == min then
      -- fog_strength = new_strength -- on rare occasion it will get suddenly really clear or totally fogg
    -- else
    local df = new_strength - old_strength
    print('df:',df)
    if df > 0 then
      fog_strength = math.min(old_strength+0.001,max)  -- trends up, unless it's already at full power
    else
      fog_strength = math.max(old_strength-0.001,min)  -- trends down, unless it's already at min power
    end
    -- end
    print('just finished getNextFogStrength:',fog_strength)
    return fog_strength
end

local function updateFog()
  -- self.character:Say(tostring(fog_strength))
  print('fog was:',fog_strength)
  fog:setEnableAdmin(true);
  fog:setAdminValue(fog_strength);
  getNextFogStrength(fog_strength)
  -- self.character:Say(tostring(fog_strength))
end

Events.OnGameStart.Add(
  function()
      fog:setEnableAdmin(true);
      fog_strength = fog:getAdminValue()
      if fog_strength < min_fog or fog_strength > max_fog then fog_strength = starting_strength end -- in case something weird happens it will reset
  end
);

Events.EveryHours.Add(
  -- updateFog
);

Events.EveryTenMinutes.Add(
  updateFog
);
