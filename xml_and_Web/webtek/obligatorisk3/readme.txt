Dette dokument indeholder kommetarer til l�sningen af obligatorisk opgave 3.

For at f� det meste ud af at l�se denne opgave besluttede vi f�rst at l�se den ved at bruge r� javascript og AJAX, og derved f� en forst�else for det bagvedliggende kode, f�r vi gik over og kikkede p� JQuery. Denne "oprindelige" kode er bevaret som sammenligningsgrundlag og som fremtidig reference.

Vi har l�st opgaven som et projekt, ved f�rst at implementere den n�dvendige funktionalitet, og s� tilf�je "goldplating" som der var tid til det.

Der er et punkt hvor vi har valgt at prioritere kode simplicitet over overholdelse af HTTP/REST principperne. I vores implmentering er en tilf�jelse til en chat bare en udvidelse af en request efter en chat liste, og rent kode-m�ssigt er det derfor meget simplere at implementere disse sammen. Dette er naturligvis en overtr�delse af princippet om at GET ikke m� have sideeffekter, og HTTP/REST evangelisterne ville helt sikkert har grebet h�tyve og fakler og drevet os ud af byen hvis de vidste det. Omvendt har vi valgt at argumentere med at ChatServer, hvor denne overtr�delse finder sted, kun tilg�s fra vores AJAX kode, og aldrig skal tilg�s direkte, samt at vi naturligvis anvender POST til opdatering og GET til request i denne kode, s� overtr�delsen er kun en mulighed hvis man overtr�der brugs-scenariet for vores applikation.

