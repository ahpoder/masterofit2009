<result>
{
for $e in doc()//b:card
for $d in doc("c:/dev/mit/xmltek/seminar3/opg3/domains.xml")//domain
let $reg := fn:concat(".*@", $d)
where fn:matches($e/b:email, $reg)
return $e
}
</result>