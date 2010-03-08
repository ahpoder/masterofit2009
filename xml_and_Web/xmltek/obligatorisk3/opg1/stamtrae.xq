declare function local:makePerson($name as xs:string, $g as xs:integer) {
  if ($g eq 0) then 
    element person {
      attribute name { $name }
    }
  else
    element person {
      attribute name { $name },
      element father { local:makePerson(fn:string-join(($name, 'father'), '&apos;s '), $g -1) },
      element mother { local:makePerson(fn:string-join(($name, 'mother'), '&apos;s '), $g -1) }
    }
};

local:makePerson("John Doe", 3)
