for $s in fn:doc("students.xml")//student
let $m := $s/major
where fn:count($m) ge 2
order by $s/@id
return <double>
         { $s/name/text() }
       </double>
