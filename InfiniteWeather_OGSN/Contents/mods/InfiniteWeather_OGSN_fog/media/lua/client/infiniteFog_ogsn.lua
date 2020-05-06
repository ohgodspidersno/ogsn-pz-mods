local clim --= getClimateManager();
local FOG_ID --= 5;
local fog --= clim:getClimateFloat(FOG_ID);
local starting_strength --= 0.3;
local max_fog --= 1;
local min_fog --= 0.3;
local df --= 0.005; -- the step size for fog intensity's change every ten minutes

local fog_strength --= starting_strength  -- fog_strength is the current intensity
local fog_trend --= max_fog -- this will update daily and will determine where the intensity that fog will gradually creep toward over the course of the day

local function setFogTrend()
  local suddenChange = ZombRand(15) -- small flat chance that it will simply trend toward the max
  if suddenChange == 1 then fog_trend = max_fog
  else fog_trend = (ZombRandFloat(min_fog,max_fog)+ZombRandFloat((min_fog+1),max_fog))/2 -- makes two rolls of the dice, designed to skew slightly higher than the median
  end
  print("fog_trend today: ",fog_trend)
end

local function setNextFogStrength()
    local delta = fog_trend - fog_strength
    if delta > 0 then fog_strength = math.min(fog_strength + df, max_fog)  -- trends up, unless it's already at full power
    elseif delta < 0 then fog_strength = math.max(fog_strength - df, min_fog)  -- trends down, unless it's already at min power
    end
    -- print('just finished setNextFogStrength:',fog_strength)
end

local function updateFog()
  -- print('fog was:',fog_strength)
  fog:setEnableAdmin(true);
  fog:setAdminValue(fog_strength);
  setNextFogStrength()
end

Events.OnGameStart.Add(
  function()
      clim = getClimateManager();
      FOG_ID = 5;
      fog = clim:getClimateFloat(FOG_ID);
      starting_strength = 0.3;
      max_fog = 1;
      min_fog = 0.3;
      df = 0.005; -- the step size for fog intensity's change every ten minutes

      fog_strength = starting_strength  -- fog_strength is the current intensity
      fog_trend = max_fog -- this will update daily and will determine where the intensity that fog will gradually creep toward over the course of the day

      setFogTrend()
      fog:setEnableAdmin(true);
      fog_strength = fog:getAdminValue()
      -- Now check for other weirdnesses, like if it was too big/small or if the min/max changed since last time the game was opened
      if fog_strength < min_fog then fog_strength = min_fog
      elseif fog_strength > max_fog then fog_strength = max_fog end -- in case something weird happens it will reset
      fog:setAdminValue(fog_strength)
  end
);

Events.EveryDays.Add(
  setFogTrend
);

Events.EveryHours.Add(
  function()
    if getGameTime():getHour() % 6 == 0 and fog_strength ~= fog_trend then
      print('Fog level is changing, currently at %s',fog_strength,' on its way to %s',fog_trend)
    end
  end
)

Events.EveryTenMinutes.Add(
  updateFog
);
