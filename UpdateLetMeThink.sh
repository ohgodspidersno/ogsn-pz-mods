if read -p "Make sure that 'gdno' in ~/zomboid-content/ only prints the files that reference getSpeedControls()"; then
    cd ~/zomboid-contents
    git diff --name-only | sed 's/Java\///' | xargs -I _ mkdir -p ~/Zomboid/Workshop/LetMeThink/Contents/mods/LetMeThink/_;
    git diff --name-only | sed 's/Java\///' | xargs -I _ rm -r ~/Zomboid/Workshop/LetMeThink/Contents/mods/LetMeThink/_;
    git diff --name-only | sed 's/Java\///' | xargs -I _ cp $PWD/Java/_ ~/Zomboid/Workshop/LetMeThink/Contents/mods/LetMeThink/_-original;
    cd ~/Zomboid/Workshop
fi
