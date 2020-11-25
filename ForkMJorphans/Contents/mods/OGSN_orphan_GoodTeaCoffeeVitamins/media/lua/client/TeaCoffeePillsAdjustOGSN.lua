function Adjust(Name, Property, Value)
Item = ScriptManager.instance:getItem(Name)
Item:DoParam(Property.." = "..Value)
end

Adjust("Base.Kettle","Weight","0.5")
Adjust("Base.FullKettle","Weight","2")
Adjust("Base.FullKettle","UseDelta","0.04")
Adjust("Base.Sugar","Weight","0.5")
Adjust("Base.Sugar","UseDelta","0.1")

Adjust("Base.Teabag2","Weight","0.005")
Adjust("Base.Teabag2","Count","10")
Adjust("Base.Teabag2","HungerChange","-2")
Adjust("Base.Teabag2","FatigueChange","-25")
Adjust("Base.Teabag2","UnhappyChange","15")
Adjust("Base.Teabag2","ThirstChange","20")

Adjust("Base.Mugfull","FatigueChange","-25")
Adjust("Base.Mugfull","UnhappyChange","-20")
Adjust("Base.Mugfull","StressChange","-50")
Adjust("Base.Mugfull","Weight","0.4")
Adjust("Base.Mugfull","ThirstChange","-20")

Adjust("Base.ColdCuppa","FatigueChange","-25")
Adjust("Base.ColdCuppa","UnhappyChange","10")
Adjust("Base.ColdCuppa","Weight","0.4")
Adjust("Base.ColdCuppa","ThirstChange","-20")

Adjust("Base.PillsVitamins","FatigueChange","-25")
Adjust("Base.PillsVitamins","Weight","0.01")
Adjust("Base.PillsVitamins","UseDelta","0.25")
