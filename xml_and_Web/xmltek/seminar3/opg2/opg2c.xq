declare namespace rcp="http://www.brics.dk/ixwt/recipes";
declare function local:unitConverter($l)
{
  for $x in $l
    return 
      if ($x/@unit="cup") then 
        $x/@amount*250 
      else if ($x/@unit="tablespoon") then 
        $x/@amount*15 
      else ()
};
<result>
{
  for $r in doc()//rcp:recipe
  let $butter:=$r//rcp:ingredient[./@name='butter']
  let $olive:=$r//rcp:ingredient[./@name='olive oil']
  let $butterSum := fn:sum(local:unitConverter($butter))
  let $oliveSum := fn:sum(local:unitConverter($olive))
  where ($butter and $olive and $butterSum > $oliveSum)
  return element { "recipe"} {
    element {"title" } {$r/rcp:title/text()}
  }

}
</result>