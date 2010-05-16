Dette dokument indeholder kommetarer til løsningen af obligatorisk opgave 3.

For at få det meste ud af at løse denne opgave besluttede vi først at løse den ved at bruge rå javascript og AJAX, og derved få en forståelse for det bagvedliggende kode, før vi gik over og kikkede på JQuery. Denne "oprindelige" kode er bevaret som sammenligningsgrundlag og som fremtidig reference.

Vi har løst opgaven som et projekt, ved først at implementere den nødvendige funktionalitet, og så tilføje "goldplating" som der var tid til det.

Der er et punkt hvor vi har valgt at prioritere kode simplicitet over overholdelse af HTTP/REST principperne. I vores implmentering er en tilføjelse til en chat bare en udvidelse af en request efter en chat liste, og rent kode-mæssigt er det derfor meget simplere at implementere disse sammen. Dette er naturligvis en overtrædelse af princippet om at GET ikke må have sideeffekter, og HTTP/REST evangelisterne ville helt sikkert har grebet høtyve og fakler og drevet os ud af byen hvis de vidste det. Omvendt har vi valgt at argumentere med at ChatServer, hvor denne overtrædelse finder sted, kun tilgås fra vores AJAX kode, og aldrig skal tilgås direkte, samt at vi naturligvis anvender POST til opdatering og GET til request i denne kode, så overtrædelsen er kun en mulighed hvis man overtræder brugs-scenariet for vores applikation.

Test:

1. Copier indholdet af tomcat til webapps i tomcat install folderen.
2. Genstrat tomcat servicen
3. Naviger til 127.0.0.1:8080/ChatClient/chat.html (hvis din tomcat service lyter på en anden port anvend den)
4. Udfyld navn og tryk "Set nama".
5. Se at current name opdateres
6. Udfyld chat og vælg "Set chat"
7. Se at current chat opdateres
8. Indtast noget tekst og tryk "Add to chat"
9. Se at de indtastede tilføjes med navn og dato i chat listen.
10. Åben en ny borwser og gentag 3 - 7 men med et andet navn (samme chat).
11. Se at det tidligere indtastede vises i chat listen.
12. Gentag 8 og se at det indtastede tilføjes til begge chat lister indenfor 3 sekunder.
13. Prøv at skifte chat og se at listen forsvinder.
14. Prøv at indtaste "<h1>test</h1>" og tryk "Add to chat"
15. Se at det indtastede HTML ikke fortolkes (cross-scriptig ikke muligt)
16. Åben to nye browsere og gentag 3 - 12 på en anden chat og verificer at to uafhængige chats kan sameksisterer.
17. Gentag 3 - 16 men anvend chat_jq.html i stedet for chat.html og erificer at det også virker med jquery versionen.
