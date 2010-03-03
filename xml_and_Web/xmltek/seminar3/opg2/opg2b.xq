declare namespace rcp="http://www.brics.dk/ixwt/recipes";
<result>
{
  for $r in doc()//rcp:recipe
  where $r/rcp:ingredient/rcp:ingredient
  return element { 
    "title" } {$r/rcp:title/text()}
}
</result>