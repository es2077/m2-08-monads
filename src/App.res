/**
 * Monads
 * - Introdução
 * - Manipulando DOM de forma unsafe
 * - Criando nossa primeira Monad
 * - Manipulando DOM de maneira safe com Monads
 * - Utilizando rescript-webapi + Option Monad do ReScript
 * - Combinando pipe + Monads
 * - A anatomia de uma Monad e suas regras
 * - Quando utilizar uma Monad?
 */

module Optional = {
  /* type t<'a> = None | Some('a) */
  type t<'a> = option<'a>

  let return = value => Some(value)

  let getWithDefault = (optional, defaultValue) =>
    switch optional {
    | None => defaultValue
    | Some(value) => value
    }

  let flatMap = (optional, function) =>
    switch optional {
    | None => None
    | Some(value) => function(value)
    }
}

// Valores de apoio
let x = 1
let f = a => Optional.return(a + 1)
let g = a => Optional.return(a * 2)
let m = Optional.return(x)

// 1. Left Identity
// Exemplo: Optional.return(x)->Optional.flatMap(f) == f(x)
Js.log3(`1. Left Identity =>`, Optional.return(x)->Optional.flatMap(f), f(x))

// 2. Right Identity
// Exemplo: m->Optional.flatMap(Optional.return) == m
Js.log3(`2. Right Identity =>`, m->Optional.flatMap(Optional.return), m)

// 3. Associative
Js.log3(
  `3. Associative =>`,
  m->Optional.flatMap(f)->Optional.flatMap(g),
  m->Optional.flatMap(x => x->f->Optional.flatMap(g)),
)
module Dom = {
  @val external document: Dom.element = "document"
  @send @return(nullable)
  external querySelector: (Dom.element, string) => option<Dom.element> = "querySelector"
  @get external innerText: Dom.element => string = "innerText"
}

// document.querySelector("...")

@react.component
let make = () => {
  React.useEffect0(() => {
    open Dom

    document
    ->querySelector(".main-container")
    ->Belt.Option.flatMap(container => container->querySelector("h1"))
    ->Belt.Option.flatMap(element => element->innerText->Optional.return)
    ->Belt.Option.flatMap(innerText => `Elemento, innerText: ${innerText}`->Optional.return)
    ->Belt.Option.getWithDefault(`Elemento não encontrado`)
    ->ignore

    //->Js.log

    // let mainContainer = document->querySelector(".main-container")

    /* switch mainContainer { */
    /* | None => Js.log(`Elemento não foi encontrado`) */
    /* | Some(element) => */
    /* switch element->querySelector("h2") { */
    /* | None => Js.log(`Elemento não foi encontrado`) */
    /* | Some(h2) => Js.log(`Elemento encotrado, innerText:${h2->innerText}`) */
    /* } */
    /* } */

    None
  })

  <div className="main-container">
    {`Outra parte do texto`->React.string} <h2> {`Hello from Vite`->React.string} </h2>
  </div>
}
