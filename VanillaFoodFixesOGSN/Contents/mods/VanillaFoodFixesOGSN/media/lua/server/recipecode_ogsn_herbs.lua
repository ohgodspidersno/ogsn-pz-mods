-- If we go this route, do this:
-- Normal Herbs OnCook make dried versions that are already "cooked"
-- Normal Herbs OnRotten make rotten versions that are already "rotten"
-- Dried herbs OnBurn make burnt version that are already "burnt"
-- Remember to change translations so that (cooked) does not appear on dried herbs



-- Another Route (might not be feasible):
-- Scrap the rotten and burnt versions entirely
-- Normal herbs would have an OnCook lua that turns them into Dried versions, but only if they're NOT rotten.
-- Then there would be another lua that would make it so that brewing tea would yield a "Bad Herbal Tea" if the ingredient was rotten and/or burnt.
