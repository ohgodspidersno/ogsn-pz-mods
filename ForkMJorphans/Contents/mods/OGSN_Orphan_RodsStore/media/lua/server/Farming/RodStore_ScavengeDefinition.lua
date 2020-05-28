require "Farming/ScavengeDefinition"

scavenges.medicinalPlants = {};

local Camomile = {};
Camomile.type = "RS.Camomile";
Camomile.minCount = 1;
Camomile.maxCount = 5;
Camomile.skill = 1;
local Mint = {};
Mint.type = "RS.Mint";
Mint.minCount = 1;
Mint.maxCount = 3;
Mint.skill = 2;
local Aloe = {};
Aloe.type = "RS.Aloe";
Aloe.minCount = 1;
Aloe.maxCount = 3;
Aloe.skill = 2;

local Lavender = {};
Lavender.type = "RS.Lavender";
Lavender.minCount = 1;
Lavender.maxCount = 3;
Lavender.skill = 1;

table.insert(scavenges.medicinalPlants, Camomile);
table.insert(scavenges.medicinalPlants, Mint);
table.insert(scavenges.medicinalPlants, Aloe);
table.insert(scavenges.medicinalPlants, Lavender);
