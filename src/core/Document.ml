
(* This file is free software. See file "license" for more details. *)

(** {1 Simple Formatted Document} *)

module Fmt = CCFormat

type block =
  [ `S of string (* section *)
  | `P of string (* paragraph *)
  | `Pre of string (* formatted paragraph *)
  | `I of string * t (* indented doc with header *)
  ]

and t = block list

let section s = `S s
let paragraph s = `P s
let paragraph_f s = CCFormat.ksprintf ~f:paragraph s
let indent i j = `I (i,j)
let pre s = `Pre s
let pre_f s = CCFormat.ksprintf ~f:pre s
let sub l = `Sub l

let rec pp out (l:t) =
  Fmt.fprintf out "@[<v>%a@]@." (Fmt.list ~start:"" ~stop:"" ~sep:"" pp_block) l

and pp_block out : block -> unit = function
  | `S sec -> Fmt.fprintf out "# @[<h>%s@]@," sec
  | `P msg -> Fmt.fprintf out "@[%a@]" Format.pp_print_text msg
  | `Pre msg -> Fmt.fprintf out "@[%s@]" msg
  | `I (head, body) ->
    Fmt.fprintf out "@[<2>%s@ %a@]" head pp body
