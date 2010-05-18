Dette dokument indeholder kommentarer til l�sningen af obligatorisk opgave 3.

For at f� det meste ud af at l�se denne opgave besluttede vi f�rst at l�se den ved at bruge r� javascript og AJAX, og derved f� en forst�else for det bagvedliggende kode, f�r vi gik over og kikkede p� JQuery. Denne "oprindelige" kode er bevaret som sammenligningsgrundlag og som fremtidig reference.

Vi har l�st opgaven som et projekt, ved f�rst at implementere den n�dvendige funktionalitet, og s� tilf�je "goldplating" som der var tid til det.

Der er et punkt hvor vi har valgt at prioritere kode simplicitet over overholdelse af HTTP/REST principperne. I vores implmentering er en tilf�jelse til en chat bare en udvidelse af en request efter en chat liste, og rent kode-m�ssigt er det derfor meget simplere at implementere disse sammen. Dette er naturligvis en overtr�delse af princippet om at GET ikke m� have sideeffekter, og HTTP/REST evangelisterne ville helt sikkert har grebet h�tyve og fakler og drevet os ud af byen hvis de vidste det. Omvendt har vi valgt at argumentere med at ChatServer, hvor denne overtr�delse finder sted, kun tilg�s fra vores AJAX kode, og aldrig skal tilg�s direkte, samt at vi naturligvis anvender POST til opdatering (for JQuery l�sningen) og GET til request i denne kode, s� overtr�delsen er kun en mulighed hvis man overtr�der brugs-scenariet for vores applikation.

Endvidere kan det ses at vi altid overf�rer alt chat indholdet. Dette er den simpleste m�de at sikre korrekt r�kkef�lge af chat entries. Et alternativ er kun at sende nye chat opdateringer, incl. ens egne, i den rigtige r�kkef�lge og s� have en speciel kommando til at requeste en hel chat historik (hvis man �nsker at skifte chat), eller man kan kun sende andres nye chat beskeder og injecte ens egne direkte ind i listen, men det vil kr�ve client-side kontrol med datoen samt administration af hvis man skifter navn, men det er muligt. Vi har dog valgt den simpleste l�sning, og argumenterer med at r� tekst er relativt "billigt" at sende hver gang, og hvis en chat bliver for lang bliver den alligevel uoverskuelig. Dette kan naturligvis l�ses ved at lave en "expires" tid p� chat items, eller en maksimal l�ngde p� chat listen, men det er p.t. ikke implementeret - vi genstarter bare tomcat serveren hver nat :)

ChatServeren returnerer chat entries som html. De kunne naturligvis ogs� have v�ret struktureret som XML og dermed fortolket af klienten som den nu m�tte �nske det.

Endelig kan det ses at JQuery l�sningen, ud over at anvende POST korrekt, ogs� er noget mere let-l�selig og dermed overskuelig, hvilket er et stort plus med scripting-kode, og s� sikre JQuery ogs� at det er cross-browser kompatibelt, hvilket ogs� er et enormt plus.

Test:
1. Kopier indholdet af tomcat til webapps i tomcat install folderen.
2. Genstart tomcat servicen
3. Naviger til localhost:8080/ChatClient/chat.html (hvis din tomcat service lytter p� en anden port anvend den)
4. Udfyld navn og tryk "Set name".
5. Se at 'current name' opdateres
6. Udfyld chat og v�lg "Set chat"
7. Se at 'current chat' opdateres
8. Indtast noget tekst og tryk "Add to chat"
9. Se at det indtastede tilf�jes med navn og dato i chat listen.
10. �ben en ny browser og gentag 3 - 7 men med et andet navn (samme chat).
11. Se at det tidligere indtastede vises i chat listen.
12. Gentag 8 og se at det indtastede tilf�jes til begge chat lister indenfor 3 sekunder.
13. Pr�v at skifte chat og se at listen forsvinder.
14. Pr�v at indtaste "<h1>test</h1>" og tryk "Add to chat"
15. Se at det indtastede HTML ikke fortolkes (cross-scripting ikke muligt)
16. �ben to nye browsere og gentag 3 - 12 p� en anden chat og verificer at to uafh�ngige chats kan sameksistere.
17. Gentag 3 - 16 men anvend chat_jq.html i stedet for chat.html og verificer at det ogs� virker med jquery versionen.
