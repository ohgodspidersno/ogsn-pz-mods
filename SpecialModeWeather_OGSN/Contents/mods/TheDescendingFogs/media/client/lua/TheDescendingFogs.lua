local cliim = getClimateManager();
local FOG_ID = 5;
local fog = cliim:getClimateFloat(FOG_ID);
local starting_strength = 0.3;
local max_fog = 1;
local min_fog = 0.3;

local fog_strength = starting_strength

local function getNextFogStrength()
    local max = max_fog
    local min = min_fog
