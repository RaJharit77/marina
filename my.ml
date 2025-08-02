let list_sub l start len =
  if start < 0 || len < 0 || start + len > List.length l then
    []
  else
    List.init len (fun i -> List.nth l (start + i))