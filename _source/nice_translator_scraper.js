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
  "Chinese | S" : "中文",
  "Chinese | T" : "繁體中文",
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
  "درباره ما" : "درباره",
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
