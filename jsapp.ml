module H = Dom_html
let js = Js.string

let status =
  Js.Opt.get (H.document##getElementById(js"status")) (fun () -> assert false)

let display msg =
  status##innerHTML <- js msg

let string_of_gamepad (g:Gamepad_types.gamepad Js.t) =
  let print_double_array x =
    "[" ^ String.concat ";" (List.map string_of_float (Array.to_list x)) ^ "]"
  in
  Printf.sprintf ("id='%s' axes=%s")
    (Js.to_string g##id)
    (g##axes |> Js.to_array |> print_double_array)

let runAnimation () =
  let gamepads = Gamepad.getGamepads () in
  for i = 0 to gamepads##length - 1 do
    let go = Js.array_get gamepads i in
    Js.Optdef.iter go (fun g ->
      display (string_of_gamepad g)
    )
  done

let _ =
  H.window##setInterval (Js.wrap_callback runAnimation, 100.)
