(: this is a comment :)
declare function local:makePerson($name as xs:string, $g as xs:integer, $first as xs:boolean) {
  (: the recursion stop criterion :)
  if ($g le 0) then 
    element person {
      attribute name { $name },
      element father {  },
      element mother {  }
    }
  else 
    (: max number of generations not reached :) 
    if ($first) then 
          (: the root generation needs some namespace stuff added. 
          This is the not so elegant solution that returns the requested result :)
	  <person name="{ $name }" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="stamtrae.xsd">
	    <father>{ local:makePerson(fn:string-join(($name, 'father'), '&apos;s '), $g -1, fn:false()) }</father>
	    <mother>{ local:makePerson(fn:string-join(($name, 'mother'), '&apos;s '), $g -1, fn:false()) }</mother>
	  </person>
	else
	(: we're doing intermediate generations here. 
	The function does a recursive call reducing the generation count by 1 :)
      element person { 
        attribute name { $name },
        element father { local:makePerson(fn:string-join(($name, 'father'), '&apos;s '), $g -1, fn:false()) },
        element mother { local:makePerson(fn:string-join(($name, 'mother'), '&apos;s '), $g -1, fn:false()) }
	  }
};

(: This is the main :)
local:makePerson("John Doe", 3, fn:true())
