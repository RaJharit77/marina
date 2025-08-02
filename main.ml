open Cohttp_lwt_unix
open Cohttp
open Lwt

let sat_handler formula =
  try Ok (Marina.sat_str formula)
  with
  | Prop.Bad_parenthesis -> Error "Bad parenthesis"
  | Prop.Invalid_operator -> Error "Invalid operator"
  | Prop.Invalid_atom -> Error "Invalid atom"
  | Prop.Parsing_error -> Error "Parsing error"

let handle_request req body =
  let uri = Request.uri req in
  match Request.meth req with
  | `POST when Uri.path uri = "/sat" ->
      body |> Cohttp_lwt.Body.to_string >|= fun body_str ->
      let formula = 
        match Uri.get_query_param uri "formula" with
        | Some f -> f 
        | None -> body_str 
      in
      (match sat_handler formula with
        | Ok result -> 
            let headers = Header.init_with "Content-Type" "text/plain" in
            (Response.make ~status:`OK ~headers (), Body.of_string result)
        | Error msg -> 
            (Response.make ~status:`Bad_request (), Body.of_string msg))
  | _ ->
      Lwt.return (Response.make ~status:`Not_found (), Body.of_string "Not found")

let start_server () =
  let callback _conn req body = handle_request req body in
  Server.create ~mode:(`TCP (`Port 10000)) (Server.make ~callback ())

let () = 
  Printexc.record_backtrace true;
  Lwt_main.run (start_server ())