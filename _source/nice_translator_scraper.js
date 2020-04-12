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
