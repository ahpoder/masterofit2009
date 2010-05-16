Dette dokument indeholder kommetarer til l�sningen af obligatorisk opgave 3.

For at f� det meste ud af at l�se denne opgave besluttede vi f�rst at l�se den ved at bruge r� javascript og AJAX, og derved f� en forst�else for det bagvedliggende kode, f�r vi gik over og kikkede p� JQuery. Denne "oprindelige" kode er bevaret som sammenligningsgrundlag og som fremtidig reference.

Vi har l�st opgaven som et projekt, ved f�rst at implementere den n�dvendige funktionalitet, og s� tilf�je "goldplating" som der var tid til det.

Der er et punkt hvor vi har valgt at prioritere kode simplicitet over overholdelse af HTTP/REST principperne. I vores implmentering er en tilf�jelse til en chat bare en udvidelse af en request efter en chat liste, og rent kode-m�ssigt er det derfor meget simplere at implementere disse sammen. Dette er naturligvis en overtr�delse af princippet om at GET ikke m� have sideeffekter, og HTTP/REST evangelisterne ville helt sikkert har grebet h�tyve og fakler og drevet os ud af byen hvis de vidste det. Omvendt har vi valgt at argumentere med at ChatServer, hvor denne overtr�delse finder sted, kun tilg�s fra vores AJAX kode, og aldrig skal tilg�s direkte, samt at vi naturligvis anvender POST til opdatering og GET til request i denne kode, s� overtr�delsen er kun en mulighed hvis man overtr�der brugs-scenariet for vores applikation.

Test:

1. Copier indholdet af tomcat til webapps i tomcat install folderen.
2. Genstrat tomcat servicen
3. Naviger til 127.0.0.1:8080/ChatClient/chat.html (hvis din tomcat service lyter p� en anden port anvend den)
4. Udfyld navn og tryk "Set nama".
5. Se at current name opdateres
6. Udfyld chat og v�lg "Set chat"
7. Se at current chat opdateres
8. Indtast noget tekst og tryk "Add to chat"
9. Se at de indtastede tilf�jes med navn og dato i chat listen.
10. �ben en ny borwser og gentag 3 - 7 men med et andet navn (samme chat).
11. Se at det tidligere indtastede vises i chat listen.
12. Gentag 8 og se at det indtastede tilf�jes til begge chat lister indenfor 3 sekunder.
13. Pr�v at skifte chat og se at listen forsvinder.
14. Pr�v at indtaste "<h1>test</h1>" og tryk "Add to chat"
15. Se at det indtastede HTML ikke fortolkes (cross-scriptig ikke muligt)
16. �ben to nye browsere og gentag 3 - 12 p� en anden chat og verificer at to uafh�ngige chats kan sameksisterer.
17. Gentag 3 - 16 men anvend chat_jq.html i stedet for chat.html og erificer at det ogs� virker med jquery versionen.
