open Lwt.Syntax
open Cohttp
open Cohttp_lwt_unix

let sat_formula formula =
  try Marina.sat_str formula
  with exn ->
    let msg = Printexc.to_string exn in
    Printf.sprintf "Error: %s" msg

let handle_request req body =
  let uri = Request.uri req in
  let formula = 
    match Uri.get_query_param uri "formula" with
    | Some f -> f
    | None -> 
        let* body_str = Body.to_string body in
        Lwt.return body_str
  in
  
  let response = sat_formula formula in
  Server.respond_string ~status:`OK ~body:response ()

let server =
  let port = try int_of_string (Sys.getenv "PORT") with _ -> 10000 in
  Server.create ~mode:(`TCP (`Port port)) (Server.make ~callback:handle_request ())

let () = Lwt_main.run server