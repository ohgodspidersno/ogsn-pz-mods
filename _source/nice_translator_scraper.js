function copyAllTranslations() {
    var x = document.getElementsByClassName("translation")
    var translation = ""
    for (i = 0; i < x.length; i++) {
      var tr = x.item(i).innerHTML;
      translation += "<br><br>" + tr
    }
    var maindiv = document.getElementsByClassName('maincontent')[0]
    var newp = document.createElement('p');
    newp.setAttribute('id','dummy')
    newp.innerHTML=translation
    maindiv.innerHTML = ""
    maindiv.appendChild(newp)
    var copyText = document.getElementById('dummy').innerhHTML;
    copyText.select();
    document.execCommand('copy');
}
copyAllTranslations()

language_names = {
    "Afrikaans" : "Afrikaans",
    "Arabic" :  "عربى",
    "Bulgarian" : "български",
    "Catalan" : "Català",
    "Cantonese" : "广东话",
    "Chinese (Simplified)" : "中文 - 简体",
    "Chinese (Traditional)" : "中文 - 繁體",
    "Croatian" :  "Hrvatski",
    "Czech" : "čeština",
    "Danish" :  "Danish",
    "Dutch" : "Dansk",
    "English" : "English",
    "Estonian" :  "Eestlane",
    "Filipino" :  "Pilipino",
    "Finnish" : "Suomalainen",
    "Kävi koulua" : "Kävi",
    "French" :  "Français",
    "German" :  "Deutsch",
    "Greek" : "Ελληνικά",
    "Hebrew" :  "עברית",
    "Hindi" : "हिन्दी",
    "Hungarian" : "हंगेरी",
    "Icelandic" : "Íslensku",
    "Italian" : "Italiano",
    "Japanese" :  "日本語",
    "Korean" :  "한국어",
    "Latvian" : "Latvietis",
    "Lithuanian" :  "Lietuvis",
    "Malay" : "Melayu",
    "Maltese" : "Malti",
    "Norwegian" : "Norsk",
    "Persian" : "فارسی",
    "Polish" :  "Perski",
    "Portuguese" :  "Português",
    "Portuguese - Brazil" :  "Português - Brazil",
    "Romanian" :  "Românesc",
    "Russian" : "Pусский",
    "Serbian" : "Српски",
    "Slovak" :  "Slovenský",
    "Slovenian" : "Slovenščina",
    "Spanish" : "Español",
    "Spanish - Spain" : "Español - España",
    "Spanish - Latin America" : "Español - America Latina",
    "Swahili" : "Kiswahili",
    "Swedish" : "Svenska",
    "Thai" :  "ไทย",
    "Turkish" : "Türk",
    "Ukrainian" : "Українська",
    "Vietnamese" :  "Việt không",
    "Welsh" : "Cymraeg",
}

pz_abbrev_to_name = {
    'AF'  : 'Afrikaans',
    'AR'  : 'Spanish - Latin America',
    'CH'  : 'Chinese (Traditional)',
    'CN'  : 'Chinese (Simplified)',
    'CS'  : 'Czech',
    'DA'  : 'Danish',
    'DE'  : 'German',
    'EN'  : 'English',
    'ES'  : 'Spanish - Spain',
    'FR'  : 'French',
    'HU'  : 'Hungarian',
    'IT'  : 'Italian',
    'JP'  : 'Japanese',
    'KO'  : 'Korean',
    'NL'  : 'Dutch',
    'NO'  : 'Norwegian',
    'PL'  : 'Polish',
    'PT'  : 'Portuguese',
    'PTBR': 'Portuguese - Brazil',
    'RU'  : 'Russian',
    'TH'  : 'Thai',
    'TR'  : 'Turkish',

    'EE'  : 'English', // Unclear what this is
}

steam_languages = [
    "Chinese (Simplified)",
    "Chinese (Traditional)",
    "Japanese",
    "Korean",
    "Thai",
    // "Bulgarian",  // not in game though
    "Czech",
    "Danish",
    "German",
    "English",
    "Spanish - Spain",
    "Spanish - Latin America",
    // "Greek",      // not in game though
    "French",
    "Italian",
    "Hungarian",
    "Dutch",
    "Norwegian",
    "Polish",
    "Portuguese",
    "Portuguese - Brazil",
    "Romanian",
    "Russian",
    // "Finnish",    // not in game though
    // "Swedish",    // not in game though
    "Turkish",
    // "Vietnamese", // not in game though
    // "Ukrainian",  // not in game though
]
