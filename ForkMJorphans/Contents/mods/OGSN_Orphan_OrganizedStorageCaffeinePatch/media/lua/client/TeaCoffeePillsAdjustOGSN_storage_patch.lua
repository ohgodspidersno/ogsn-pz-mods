function Adjust(Name, Property, Value)
Item = ScriptManager.instance:getItem(Name)
Item:DoParam(Property.." = "..Value)
end

Adjust("Base.Coffee2","Weight","0.005")
Adjust("Base.Coffee2","Count","10")
Adjust("Base.Coffee2","HungerChange","-2")
Adjust("Base.Coffee2","FatigueChange","-25")
Adjust("Base.Coffee2","UnhappyChange","15")
Adjust("Base.Coffee2","ThirstChange","20")
Adjust("Base.Coffee2","Type","Food")
Adjust("Base.Coffee2","EvolvedRecipe","HotDrink:2")
