namespace AppName._1

module HttpHandlers =

    open Microsoft.AspNetCore.Http
    open FSharp.Control.Tasks.V2.ContextInsensitive
    open Giraffe
    open AppName._1.Models

    let handleGetHello =
        fun (next : HttpFunc) (ctx : HttpContext) ->
            task {
                let response = {
                    Text = "Hello world, from Giraffe!"
                }
                return! json response next ctx
            }