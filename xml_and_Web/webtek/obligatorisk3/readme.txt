Dette dokument indeholder kommetarer til løsningen af obligatorisk opgave 3.

For at få det meste ud af at løse denne opgave besluttede vi først at løse den ved at bruge rå javascript og AJAX, og derved få en forståelse for det bagvedliggende kode, før vi gik over og kikkede på JQuery. Denne "oprindelige" kode er bevaret som sammenligningsgrundlag og som fremtidig reference.

Vi har løst opgaven som et projekt, ved først at implementere den nødvendige funktionalitet, og så tilføje "goldplating" som der var tid til det.

Der er et punkt hvor vi har valgt at prioritere kode simplicitet over overholdelse af HTTP/REST principperne. I vores implmentering er en tilføjelse til en chat bare en udvidelse af en request efter en chat liste, og rent kode-mæssigt er det derfor meget simplere at implementere disse sammen. Dette er naturligvis en overtrædelse af princippet om at GET ikke må have sideeffekter, og HTTP/REST evangelisterne ville helt sikkert har grebet høtyve og fakler og drevet os ud af byen hvis de vidste det. Omvendt har vi valgt at argumentere med at ChatServer, hvor denne overtrædelse finder sted, kun tilgås fra vores AJAX kode, og aldrig skal tilgås direkte, samt at vi naturligvis anvender POST til opdatering og GET til request i denne kode, så overtrædelsen er kun en mulighed hvis man overtræder brugs-scenariet for vores applikation.

