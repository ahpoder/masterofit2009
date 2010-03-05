declare namespace rcp="http://www.brics.dk/ixwt/recipes";
<result>
{
  for $r in doc()//rcp:recipe
  return element recipe {
    element title {$r/rcp:title/text()}, 
    element ingredientCount {count($r//rcp:ingredient)}
  }
}
</result>