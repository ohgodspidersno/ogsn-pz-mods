// This scrapes the translations from nicetranslator.com and adds them at the bottom of the page
// in several formats that are fairly useful for easy copy-pasting
// IMPORTANT: You MUST first have all languages selected or else it won't work properly and you'll get mislabeled translations and possibly errors.
// English (EN), Chinese (CN), Estonian (EE), Japanese (JP) – UTF-8
//
// Afrikaans (AF), Arabic (AR), Danish (DA), German (DE), Spanish (ES), French (FR), Hungarian (HU), Italian (IT), Dutch (NL), Norwegian (NO), Portuguese (PT), Brazilian Portuguese (PTBR), Thai (TH) – Windows 1252
// Chinese (CH) – Big-5
// Czech (CH), Polish (PL) – Windows-1250
// Russian (RU) – Windows-1251

var all_translations_arr = []
var steam_translations_arr_full_labels = []
var steam_translations_arr_native_labels = []
var steam_translations_arr_no_labels = []
var pz_translations_arr = []

function copyAllTranslations() {
    var x = document.getElementsByClassName("translation")
    all_translations_arr = []
    steam_translations_arr_full_labels = []
    steam_translations_arr_native_labels = []
    steam_translations_arr_no_labels = []
    pz_translations_arr = []
    for (i = 0; i < x.length; i++) {
      var tr = x.item(i).innerHTML;
      console.log(tr)
      var lang_eng  = nicetranslator_languages_arr[i]
      var lang_nat  = language_names[lang_eng]
      var lang_abbr = pz_abbrevs[lang_eng]
      console.log("i think this is "+lang_eng);
      all_translations_arr.push(tr)

      if (steam_languages.includes(lang_eng)) {
        console.log("I think "+lang_eng+"is a steam language")
        console.log("I think "+tr+"is in "+lang_eng);
        steam_translations_arr_full_labels.push("[h1]"+lang_nat+" ("+lang_eng+")[/h1]<br>"+tr)
        steam_translations_arr_native_labels.push("[h1]"+lang_nat+"[/h1]<br>"+tr)
        steam_translations_arr_no_labels.push(tr)
      }
      if (lang_eng in pz_abbrevs) {
        console.log("I think "+lang_eng+"is a PZ language")
        console.log("I think "+tr+"is in "+lang_eng);
        pz_translations_arr.push(lang_abbr+" ("+lang_eng+")<br>"+tr)
      }
    }
    var maindiv = document.getElementsByClassName('maincontent')[0]

    // just raw text of all of them unlabeled
    var all_p = document.createElement('p');
    all_p.setAttribute('id','all_p')
    for (i = 0; i < all_translations_arr.length; i++) {
      all_p.innerHTML += all_translations_arr[i] + "<br><br>"
    }
    all_p.innerHTML += "<br><br><br>"

    // Steam languages. Translation preceded by Native Language Name (English's name for that language)
    var steam_full_p = document.createElement('p');
    steam_full_p.setAttribute('id','steam_full_p')
    for (i = 0; i < steam_translations_arr_full_labels.length; i++) {
      steam_full_p.innerHTML += steam_translations_arr_full_labels[i] + "<br><br>"
    }
    steam_full_p.innerHTML += "<br><br><br>"

    // Steam languages. Translation preceded by Native Language Name.
    var steam_native_p = document.createElement('p');
    steam_native_p.setAttribute('id','steam_native_p')
    for (i = 0; i < steam_translations_arr_native_labels.length; i++) {
      steam_native_p.innerHTML += steam_translations_arr_native_labels[i] + "<br><br>"
    }
    steam_native_p.innerHTML += "<br><br><br>"

    // Steam languages. Translation, not preceded by anything.
    var steam_none_p = document.createElement('p');
    steam_none_p.setAttribute('id','steam_none_p')
    for (i = 0; i < steam_translations_arr_no_labels.length; i++) {
      steam_none_p.innerHTML += steam_translations_arr_no_labels[i] + "<br><br>"
    }
    steam_none_p.innerHTML += "<br><br><br>"


    // PZ languages. Translation preceded by the PZ language code
    var pz_p = document.createElement('p');
    pz_p.setAttribute('id','pz_p')
    for (i = 0; i < pz_translations_arr.length; i++) {
      pz_p.innerHTML += pz_translations_arr[i] + "<br><br>"
    }
    pz_p.innerHTML += "<br><br><br>"

    // all_p.innerHTML=translation

    maindiv.innerHTML = ""
    // maindiv.innerHTML += "<h1>All Translations Unlabeled</h1><br>"
    // maindiv.appendChild(all_p);
    //
    maindiv.innerHTML += "<h1>Steam Language Translations Fully Labeled</h1><br>"
    maindiv.appendChild(steam_full_p);
    //
    // maindiv.innerHTML += "<h1>Steam Language Translations Native Labeled</h1><br>"
    // maindiv.appendChild(steam_native_p);
    //
    // maindiv.innerHTML += "<h1>Steam Language Translations UnLabeled</h1><br>"
    // maindiv.appendChild(steam_none_p);

    // maindiv.innerHTML += "<h1>PZ Translations with Abbreviations</h1><br>"
    // maindiv.appendChild(pz_p);

    // var copyText = document.getElementById('maindiv').innerhHTML;
    // copyText.select();
    // document.execCommand('copy');
}


nicetranslator_languages_arr = [
  "Chinese (Simplified)",
  "Chinese (Traditional)",
  "Czech",
  "Danish",
  "Dutch",
  "French",
  "German",
  "Hungarian",
  "Italian",
  "Japanese",
  "Korean",
  "Norwegian",
  "Polish",
  "Portuguese",
  "Romanian",
  "Russian",
  "Spanish",
  "Thai",
  "Turkish",
]

language_names = {
    "Afrikaans" : "Afrikaans",
    "Arabic" :  "عربى",
    "Bulgarian" : "български",
    "Catalan" : "Català",
    "Cantonese" : "广东话",
    "Chinese (Simplified)" : "中文 - 简体",
    "Chinese (Traditional)" : "中文 - 繁體",
    "Croatian" :  "Hrvatski",
    "Czech" : "Čeština",
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
    "Romanian" :  "Românesc",
    "Russian" : "Pусский",
    "Serbian" : "Српски",
    "Slovak" :  "Slovenský",
    "Slovenian" : "Slovenščina",
    "Spanish" : "Español",
    "Swahili" : "Kiswahili",
    "Swedish" : "Svenska",
    "Thai" :  "ไทย",
    "Turkish" : "Türk",
    "Ukrainian" : "Українська",
    "Vietnamese" :  "Việt không",
    "Welsh" : "Cymraeg",
}

pz_abbrevs = {
    'Afrikaans' : 'AF',
    'Chinese (Traditional)' : 'CH',
    'Chinese (Simplified)' : 'CN',
    'Czech' : 'CS',
    'Danish' : 'DA',
    'German' : 'DE',
    'English' : 'EN',
    'Estonian' : 'EE',
    'Spanish' : 'ES',
    'French' : 'FR',
    'Hungarian' : 'HU',
    'Italian' : 'IT',
    'Japanese' : 'JP',
    'Korean' : 'KO',
    'Dutch' : 'NL',
    'Norwegian' : 'NO',
    'Polish' : 'PL',
    'Portuguese' : 'PT',
    'Russian' : 'RU',
    'Thai' : 'TH',
    'Turkish' : 'TR',
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
    // "English",
    "Spanish",
    // "Greek",      // not in game though
    "French",
    "Italian",
    "Hungarian",
    "Dutch",
    "Norwegian",
    "Polish",
    "Portuguese",
    "Romanian",
    "Russian",
    // "Finnish",    // not in game though
    // "Swedish",    // not in game though
    "Turkish",
    // "Vietnamese", // not in game though
    // "Ukrainian",  // not in game though
]

copyAllTranslations()


// Full list of possible nicetranslator languages:
// "Afrikaans",
// "Arabic",
// "Bulgarian",
// "Catalan",
// "Cantonese",
// "Chinese (Simplified)",
// "Chinese (Traditional)",
// "Croatian",
// "Czech",
// "Danish",
// "Dutch",
// "English",
// "Estonian",
// "Filipino",
// "Finnish",
// "Kävi koulua",
// "French",
// "German",
// "Greek",
// "Hebrew",
// "Hindi",
// "Hungarian",
// "Icelandic",
// "Italian",
// "Japanese",
// "Korean",
// "Latvian",
// "Lithuanian",
// "Malay",
// "Maltese",
// "Norwegian",
// "Persian",
// "Polish",
// "Portuguese",
// "Romanian",
// "Russian",
// "Serbian",
// "Slovak",
// "Slovenian",
// "Spanish",
// "Swahili",
// "Swedish",
// "Thai",
// "Turkish",
// "Ukrainian",
// "Vietnamese",
// "Welsh",
