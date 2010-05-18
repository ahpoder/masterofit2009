Dette dokument indeholder kommentarer til løsningen af obligatorisk opgave 3.

For at få det meste ud af at løse denne opgave besluttede vi først at løse den ved at bruge rå javascript og AJAX, og derved få en forståelse for det bagvedliggende kode, før vi gik over og kikkede på JQuery. Denne "oprindelige" kode er bevaret som sammenligningsgrundlag og som fremtidig reference.

Vi har løst opgaven som et projekt, ved først at implementere den nødvendige funktionalitet, og så tilføje "goldplating" som der var tid til det.

Der er et punkt hvor vi har valgt at prioritere kode simplicitet over overholdelse af HTTP/REST principperne. I vores implmentering er en tilføjelse til en chat bare en udvidelse af en request efter en chat liste, og rent kode-mæssigt er det derfor meget simplere at implementere disse sammen. Dette er naturligvis en overtrædelse af princippet om at GET ikke må have sideeffekter, og HTTP/REST evangelisterne ville helt sikkert har grebet høtyve og fakler og drevet os ud af byen hvis de vidste det. Omvendt har vi valgt at argumentere med at ChatServer, hvor denne overtrædelse finder sted, kun tilgås fra vores AJAX kode, og aldrig skal tilgås direkte, samt at vi naturligvis anvender POST til opdatering (for JQuery løsningen) og GET til request i denne kode, så overtrædelsen er kun en mulighed hvis man overtræder brugs-scenariet for vores applikation.

Endvidere kan det ses at vi altid overfører alt chat indholdet. Dette er den simpleste måde at sikre korrekt rækkefølge af chat entries. Et alternativ er kun at sende nye chat opdateringer, incl. ens egne, i den rigtige rækkefølge og så have en speciel kommando til at requeste en hel chat historik (hvis man ønsker at skifte chat), eller man kan kun sende andres nye chat beskeder og injecte ens egne direkte ind i listen, men det vil kræve client-side kontrol med datoen samt administration af hvis man skifter navn, men det er muligt. Vi har dog valgt den simpleste løsning, og argumenterer med at rå tekst er relativt "billigt" at sende hver gang, og hvis en chat bliver for lang bliver den alligevel uoverskuelig. Dette kan naturligvis løses ved at lave en "expires" tid på chat items, eller en maksimal længde på chat listen, men det er p.t. ikke implementeret - vi genstarter bare tomcat serveren hver nat :)

ChatServeren returnerer chat entries som html. De kunne naturligvis også have været struktureret som XML og dermed fortolket af klienten som den nu måtte ønske det.

Endelig kan det ses at JQuery løsningen, ud over at anvende POST korrekt, også er noget mere let-læselig og dermed overskuelig, hvilket er et stort plus med scripting-kode, og så sikre JQuery også at det er cross-browser kompatibelt, hvilket også er et enormt plus.

Test:
1. Kopier indholdet af tomcat til webapps i tomcat install folderen.
2. Genstart tomcat servicen
3. Naviger til localhost:8080/ChatClient/chat.html (hvis din tomcat service lytter på en anden port anvend den)
4. Udfyld navn og tryk "Set name".
5. Se at 'current name' opdateres
6. Udfyld chat og vælg "Set chat"
7. Se at 'current chat' opdateres
8. Indtast noget tekst og tryk "Add to chat"
9. Se at det indtastede tilføjes med navn og dato i chat listen.
10. Åben en ny browser og gentag 3 - 7 men med et andet navn (samme chat).
11. Se at det tidligere indtastede vises i chat listen.
12. Gentag 8 og se at det indtastede tilføjes til begge chat lister indenfor 3 sekunder.
13. Prøv at skifte chat og se at listen forsvinder.
14. Prøv at indtaste "<h1>test</h1>" og tryk "Add to chat"
15. Se at det indtastede HTML ikke fortolkes (cross-scripting ikke muligt)
16. Åben to nye browsere og gentag 3 - 12 på en anden chat og verificer at to uafhængige chats kan sameksistere.
17. Gentag 3 - 16 men anvend chat_jq.html i stedet for chat.html og verificer at det også virker med jquery versionen.
