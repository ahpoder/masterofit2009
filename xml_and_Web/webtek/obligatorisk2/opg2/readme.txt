Denne fil beskriver test scenariet, samt forløbet med at implementerer RecipeServer og RecipeClient, samt hvad der mangler og udvidelser der kunner/burde laves.

Test scenario:

1.  Deploy content of tomcat folder to webapps
2.  Restart tomcat service.
3.  Execute run.bat
4.  Select 1. GET
5.  Hit enter (blank title)
6.  Verify that the entire recipe collection is returned.
7.  Select 1. GET
8.  Enter "Linguine Pescadoro" and hit enter
9.  Verify that the recipe with the given title is returned.
10. Select 1. GET
11. Enter "Nonexisting recipe" and hit enter
12. Verify that the an 404 error code with a "no such recipe" error is returned.
13. Repeat the test from a standard browser as
    13.1 http:://127.0.0.1/RecipeServer/recipies
    13.2 http:://127.0.0.1/RecipeServer/recipies/Linguine+Pescadoro
    13.3 http:://127.0.0.1/RecipeServer/recipies/Nonexisting+recipe
14. Select 2. POST
15. Copy the XML from the bottom of this document for the POST test and hit enter
16. Verify that a 200 OK and a "success" text is returned.
17. Verify that the recipe.xml document was correctly updated.
18. Select 3. PUT
19. Copy the XML from the bottom of this document for the PUT test and hit enter
20. Verify that a 200 OK and a "success" text is returned.
21. Verify that the recipe.xml document was correctly updated.
22. Select 3. PUT
23. Copy the XML from the bottom of this document for the PUT test and hit enter
24. Verify that a 200 OK and a "success" text is returned.
25. Verify that the recipe.xml document was correctly updated.
26. Play around with POST, PUT and DELETE invalid values and verify error response.
	
Implementation:

RecipeServer.doGet
	1. Indlæs recipe collection dokument med JDOM (ingen grund til at Schema-validere dette, da vi ved det er validt - servletten er eneste indgang til det)
	2. Find ud af om det er en komplet listning eller en delvis listning.
	3. Er det en komplet listning send hele dokumentet tilbage til requesteren.
	4. Er det en delvis listning hent titlen ud af requestet og URLDecode den (vi kan kun requeste på titler, og hvis der er to identiske titler vil kun den første blive returneret).
	   4.1 Brug XPath lookup til at finde den matchende Recipe og returner den.
	   
Vi testede doGet med en standard browser

RecipeServer.doPost (egentlig ikke en del af opgaven, men vi tog den med alligevel)
	1. Indlæs Recipe til opdatering fra POST stream (kun en recipe kan opdateres ad gangen i denne løsning).
	2. Generer XML Dokument ud fra denne stream og valider det op mod recipes.xsd. Ved fejl returner REQUEST ERROR.
	3. Indlæs recipe collection dokument med JDOM (ingen grund til at Schema-validere dette, da vi ved det er validt - servletten er eneste indgang til det)
	4. Undersøg om der findes en opskrift med det ID, hvis der ikke gør returner REQUEST ERROR.
	5. Slet den opskrift fra databasen og tilføj den nye opskrift. Dette er ikke en rigtig XML opdatering, da rækkkefølgen nu er anderledes, men i denne XML er rækkefølgen ligemeget (ligesom en relationel database).

RecipeClient.goGet:
	1. Vi kopierede kode fra webtek/seminar1/opg6 og tilføjede et menusystem og en mulighed for at indtaste en titel på en recipe som blev sat i enden af GET path'en (URL enkodet naturligvis).
	2. Vi skriver bare direkte ud på  skærmen hvad vi modtager.
	
RecipeClient.goPost:
	1. Vi giver mulighed for at indtaste en komplet recipe i XML. Der kan kopieres fra bunden af dette dokument til test.
	2. Vi recipe XML Schema validere det indtastede. Dette virker da vi ikke angiver rod-elementet i recipe XML Schema'et, vi skal bare have defineret rcp namespacet i recipe i stedet for collection.
	3. Vi sender det indtastede (hvis det er validt) som et POST request og begynder at læse svaret. 
	4. Vi skriver bare direkte ud på  skærmen hvad vi modtager.

RecipeServer.doPut og doDelete er variationer af doPost, da vi i doPut bare checker om det givne id findes (hvis det gør er det en REQUEST ERROR) og så undlader vi at slette noget først. doDelete checker vi om id'et findes (hvis det ikke gør er det en REQUEST ERROR) og så undlader vi at tilføje noget bagefter.

Overvejelser:

1. Det er ikke rigtig REST at bare indtaste titlen efter /recipies/. Der bør naturligvis være et lag mere - /recipies/title/<title of recipe>, sådanne at man også kan søge med f.eks. /recipies/id/<id> o.s.v. Dette er ikke gjort her, og vi tillader kun title sortering.
2. Der er ingen begræsninger i recipe XML schema for at der ikke må være to recipes med samme title, så det burde der tages højde for i serveren, men det gøres der ikke.
3. I POST, PUT og DELETE sendes der til /recipies, da det vedhæftede XML jo beskriver den recipe der skal opdateres, tilføjes eller slettes - der er ingen grund til at udtrykke det i stien. En mere REST måde at gøre det på kunne være at slette opskrifter via /recipies/title/<title of recipe> eller /recipies/id/<id>, hvor den første så vil slette alle der har den title. Dette er ikke gjort i den nuværende implementation. For POST og PUT er det lidt sværere, da det vil være dobbelt-konfekt at skulle udtrykke titlen eller id'et både i recipe XML'en og i URL'en. Dette snakkes der mere om i soap.xml.

Text to insert for test:

Recipe to POST to see update

<?xml version="1.0" encoding="UTF-8"?><rcp:recipe xmlns:rcp="http://www.brics.dk/ixwt/recipes" id="r103"><rcp:title>Linguine Pescadoro without sauce</rcp:title><rcp:date>Fri, 04 May 10</rcp:date><rcp:ingredient name="linguini pasta" amount="16" unit="ounce" /><rcp:preparation><rcp:step>In a large pot of boiling salted water cook linguini until al dente. Drain.</rcp:step><rcp:step>Toss cooked and drained linguine pasta. Serve warm.</rcp:step></rcp:preparation><rcp:nutrition calories="532" fat="12%" carbohydrates="59%" protein="29%" /></rcp:recipe>

Recipe to PUT

<?xml version="1.0" encoding="UTF-8"?><rcp:recipe xmlns:rcp="http://www.brics.dk/ixwt/recipes" id="r127"><rcp:title>My new recipe</rcp:title><rcp:date>Fri, 06 May 10</rcp:date><rcp:ingredient name="linguini pasta" amount="16" unit="ounce" /><rcp:preparation><rcp:step>In a large pot of boiling salted water cook linguini until al dente. Drain.</rcp:step><rcp:step>Toss cooked and drained linguine pasta. Serve warm.</rcp:step></rcp:preparation><rcp:nutrition calories="532" fat="12%" carbohydrates="59%" protein="29%" /></rcp:recipe>


Recipe to Delete

<?xml version="1.0" encoding="UTF-8"?><rcp:recipe xmlns:rcp="http://www.brics.dk/ixwt/recipes" id="r103"><rcp:title>Linguine Pescadoro without sauce</rcp:title><rcp:date>Fri, 04 May 10</rcp:date><rcp:ingredient name="linguini pasta" amount="16" unit="ounce" /><rcp:preparation><rcp:step>In a large pot of boiling salted water cook linguini until al dente. Drain.</rcp:step><rcp:step>Toss cooked and drained linguine pasta. Serve warm.</rcp:step></rcp:preparation><rcp:nutrition calories="532" fat="12%" carbohydrates="59%" protein="29%" /></rcp:recipe>