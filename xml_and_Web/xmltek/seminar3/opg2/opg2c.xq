IKKE AFSLUTTET
declare namespace rcp="http://www.brics.dk/ixwt/recipes";
<result>
{
  for $r in doc()//rcp:recipe
  where ($r//rcp:ingredient[./@name='butter'] and $r//rcp:ingredient[./@name='olive oil'])
  return element { "recipe"} {
    element {"title" } {$r/rcp:title/text()},
    element {"ingredient"} {$r//rcp:ingredient[./@name='butter']/@name},
    element {"ingredient"} {$r//rcp:ingredient[./@name='olive oil']/@name}
  }
}
</result>