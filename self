
[1mFrom:[0m /workspace/querylet/lib/querylet/tree.rb:41 Querylet::Tree::Partial#_eval:

    [1;34m38[0m:       [32mdef[0m [1;34m_eval[0m(context)
    [1;34m39[0m:         key = [31m[1;31m"[0m[31m#{partial}[0m[31m__#{path}[0m[31m[1;31m"[0m[31m[0m
    [1;34m40[0m: 
 => [1;34m41[0m:         binding.pry
    [1;34m42[0m:         context.set_scope(key)
    [1;34m43[0m: 
    [1;34m44[0m:         [parameters].flatten.map(&[33m:values[0m).map [32mdo[0m |vals|
    [1;34m45[0m:           context.add_item vals.first.to_s, vals.last._eval(context)
    [1;34m46[0m:         [32mend[0m
    [1;34m47[0m: 
    [1;34m48[0m:         content = context.get_partial(partial.to_s, path)
    [1;34m49[0m:         [32mif[0m partial == [31m[1;31m'[0m[31marray[1;31m'[0m[31m[0m
    [1;34m50[0m:         [31m[1;31m<<-HEREDOC[0m[31m[0m.chomp
    [1;34m51[0m: ([1;34;4mSELECT[0m COALESCE(array_to_json(array_agg(row_to_json(array_row))),[35m[1;35m'[0m[35m[][1;35m'[0m[35m[0m:[33m:json[0m) [1;34;4mFROM[0m (
    [1;34m52[0m: [1;34m#{content}[0m
    [1;34m53[0m: ) array_row)
    [1;34m54[0m:         [1;34;4mHEREDOC[0m
    [1;34m55[0m:         [32melsif[0m partial == [31m[1;31m'[0m[31mobject[1;31m'[0m[31m[0m
    [1;34m56[0m:         [31m[1;31m<<-HEREDOC[0m[31m[0m.chomp
    [1;34m57[0m: ([1;34;4mSELECT[0m COALESCE(row_to_json(object_row),[35m[1;35m'[0m[35m{}[1;35m'[0m[35m[0m:[33m:json[0m) [1;34;4mFROM[0m (
    [1;34m58[0m: [1;34m#{content}[0m
    [1;34m59[0m: ) object_row)
    [1;34m60[0m:       [1;34;4mHEREDOC[0m
    [1;34m61[0m:         [32melsif[0m partial == [31m[1;31m'[0m[31minclude[1;31m'[0m[31m[0m
    [1;34m62[0m:           content
    [1;34m63[0m:         [32mend[0m
    [1;34m64[0m:       [32mend[0m

