gdno | sed 's/Java\///' | xargs -I _ mkdir -p ~/Zomboid/Workshop/LetMeThink/Contents/mods/LetMeThink/_
gdno | sed 's/Java\///' | xargs -I _ rm -r ~/Zomboid/Workshop/LetMeThink/Contents/mods/LetMeThink/_
gdno | sed 's/Java\///' | xargs -I _ cp $PWD/Java/_ ~/Zomboid/Workshop/LetMeThink/Contents/mods/LetMeThink/_
