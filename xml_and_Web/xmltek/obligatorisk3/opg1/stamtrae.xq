declare function local:makePerson($name as xs:string, $g as xs:integer, $first as xs:boolean) {
  if ($g eq 0) then 
    element person {
      attribute name { $name },
      element father {  },
      element mother {  }
    }
  else 
    if ($first) then
	  <person name="{ $name }" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="stamtrae.xsd">
	    <father>{ local:makePerson(fn:string-join(($name, 'father'), '&apos;s '), $g -1, fn:false()) }</father>
		<mother>{ local:makePerson(fn:string-join(($name, 'mother'), '&apos;s '), $g -1, fn:false()) }</mother>
	  </person>
	else
      element person {
        attribute name { $name },
        element father { local:makePerson(fn:string-join(($name, 'father'), '&apos;s '), $g -1, fn:false()) },
        element mother { local:makePerson(fn:string-join(($name, 'mother'), '&apos;s '), $g -1, fn:false()) }
	  }
};

local:makePerson("John Doe", 3, fn:true())
