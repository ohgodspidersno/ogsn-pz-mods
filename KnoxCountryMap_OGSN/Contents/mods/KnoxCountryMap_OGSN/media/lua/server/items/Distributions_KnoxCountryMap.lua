require 'Items/Distributions'


function stockIWBUMS()
  table.insert(Distributions["zippeestore"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(Distributions["zippeestore"]["shelvesmag"].items, 1);

  table.insert(Distributions["fossoil"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(Distributions["fossoil"]["shelvesmag"].items, 1);

  table.insert(Distributions["cornerstore"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(Distributions["cornerstore"]["shelvesmag"].items, 1);

  table.insert(Distributions["grocery"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(Distributions["grocery"]["shelvesmag"].items, 1);

  table.insert(Distributions["all"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(Distributions["all"]["shelvesmag"].items, 1);

  table.insert(Distributions["gigamart"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(Distributions["gigamart"]["shelvesmag"].items, 1);

  table.insert(Distributions["all"]["inventorymale"].items, "Base.KnoxCountryMap");
  table.insert(Distributions["all"]["inventorymale"].items, 0.1);

  table.insert(Distributions["all"]["inventoryfemale"].items, "Base.KnoxCountryMap");
  table.insert(Distributions["all"]["inventoryfemale"].items, 0.1);

  table.insert(Distributions["all"]["sidetable"].items, "Base.KnoxCountryMap");
  table.insert(Distributions["all"]["sidetable"].items, 0.01);

  table.insert(Distributions["Bag_SurvivorBag"].items, "Base.KnoxCountryMap");
  table.insert(Distributions["Bag_SurvivorBag"].items, 30);

  table.insert(VehicleDistributions["GloveBox"].items, "Base.KnoxCountryMap");
  table.insert(VehicleDistributions["GloveBox"].items, 5);
end

function stockClassic()
  -- zippeestore>shelvesmag
  table.insert(Distributions["zippeestore"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(Distributions["zippeestore"]["shelvesmag"].items, 1);

  -- fossoil>shelvesmag
  table.insert(Distributions["fossoil"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(Distributions["fossoil"]["shelvesmag"].items, 1);

  -- cornerstore>shelvesmag
  table.insert(Distributions["cornerstore"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(Distributions["cornerstore"]["shelvesmag"].items, 1);

  -- grocery>shelvesmag
  table.insert(Distributions["grocery"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(Distributions["grocery"]["shelvesmag"].items, 1);

  -- all>shelvesmag
  table.insert(Distributions["all"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(Distributions["all"]["shelvesmag"].items, 1);

  -- all>inventorymale
  table.insert(Distributions["all"]["inventorymale"].items, "Base.KnoxCountryMap");
  table.insert(Distributions["all"]["inventorymale"].items, 0.1);

  -- all>inventoryfemale
  table.insert(Distributions["all"]["inventoryfemale"].items, "Base.KnoxCountryMap");
  table.insert(Distributions["all"]["inventoryfemale"].items, 0.1);

  -- all>sidetable
  table.insert(Distributions["all"]["sidetable"].items, "Base.KnoxCountryMap");
  table.insert(Distributions["all"]["sidetable"].items, 0.01);

  -- bedroom>sidetable
  table.insert(Distributions["bedroom"]["sidetable"].items, "Base.KnoxCountryMap");
  table.insert(Distributions["bedroom"]["sidetable"].items, 0.01);

  -- all>desk
  table.insert(Distributions["all"]["desk"].items, "Base.KnoxCountryMap");
  table.insert(Distributions["all"]["desk"].items, 0.1);
end

if string.match(getCore():getVersionNumber(), "IWBUMS")
  then stockStuff = stockIWBUMS;
  else stockStuff = stockClassic
end;

stockStuff()
