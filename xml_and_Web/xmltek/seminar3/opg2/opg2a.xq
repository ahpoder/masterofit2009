declare namespace rcp="http://www.brics.dk/ixwt/recipes";
declare namespace r="http://www.result.org";
<result>
{
  for $r in doc()//rcp:recipe
  return element {"r:recipe"} {
    element { "r:title" } {$r/rcp:title/text()}, 
    element {"r:ingredientCount" } {count($r//rcp:ingredient)}
  }
}
</result>