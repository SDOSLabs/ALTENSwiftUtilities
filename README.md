- [ALTENSwiftUtilities](#altenswiftutilities)
  - [Introducción](#introducción)
  - [Instalación](#instalación)
    - [Añadir al proyecto](#añadir-al-proyecto)
    - [Como dependencia en Package.swift](#como-dependencia-en-packageswift)
  - [Cómo se usa](#cómo-se-usa)
  - [Qué incluye](#qué-incluye)
    - [`CancelBag`](#cancelbag)
    - [`ModelDataState`](#modeldatastate)

# ALTENSwiftUtilities
- Changelog: https://github.com/SDOSLabs/ALTENSwiftUtilities/blob/main/CHANGELOG.md

## Introducción
ALTENSwiftUtilities proporciona structuras, clases y funciones de utilidad para cualquier proyecto que use Swift, SwiftUI o Combine.

## Instalación

### Añadir al proyecto

Abrir Xcode y e ir al apartado `File > Add Packages...`. En el cuadro de búsqueda introducir la url del respositorio y seleccionar la versión:
```
https://github.com/SDOSLabs/ALTENSwiftUtilities.git
```
Se debe añadir al target de la aplicación en la que queremos que esté disponible

### Como dependencia en Package.swift

``` swift
dependencies: [
    .package(url: "https://github.com/SDOSLabs/ALTENSwiftUtilities.git", .upToNextMajor(from: "1.0.0"))
]
```

Se debe añadir al target de la aplicación en la que queremos que esté disponible

``` swift
.target(
    name: "MyTarget",
    dependencies: [
        .product(name: "ALTENSwiftUtilities", package: "ALTENSwiftUtilities")
    ]),
```

## Cómo se usa

Una vez que la librería este descargada y añadida al target de la aplicación, sólo habrá que importarla en aquellos ficheros donde sea necesario usarla

``` swift
import ALTENSwiftUtilities
```

## Qué incluye

### `CancelBag`

Esta clase nos permite almacenar las suscripciones realizadas con `Combine`.

``` swift
let cancelBag = CancelBag()
var searchTerm = CurrentValueSubject<String, Never>("")

[...]

searchTerm.sink { _ in
    [...]
}.store(in: cancelBag)
```

### `ModelDataState`

Este enumerador permite representar los estados más comunes en el que podemos encontrarnos una vista de `SwiftUI`. Implementa el protocolo `Equatable` y tiene varias extensiones donde tienen en consideración que los genéricos `T` y `E` también implementan el protocolo `Equatable`. De esta forma es muy fácil realizar la comparación de los estados, ya que sólo necesitaremos usar el operador `==`.

Los estados que puede tener son:
+ `.idle`: Indica que está "en espera"
+ `.loading`: Indica que está cargando
+ `.loaded(T)`: Indica que ha cargado y proporciona los datos cargados de tipo genérico `T`
+ `.error(E)`: Indica que ha ocurrido un error y el error producido de tipo genérico `Error`

``` swift
let state: ModelDataState<Int, Error> = .idle
```

``` swift
let state1: ModelDataState<Int, Error> = .loading
let state2: ModelDataState<Int, Error> = .loading
if (state1 == state2) { } //Devolverá `true`
```

``` swift
let state: ModelDataState<Int, Error> = .loaded([1, 2, 3, 4, 5, 6])
let value: [Int]? = state.elementLoaded
```

``` swift
let state: ModelDataState<Int, Error> = .error(URLError(.badURL))

[...]

switch state {
  case .idle:
      //Hacer algo cuando el estado es `.idle`
  case .loading:
      //Hacer algo cuando el estado es `.loading`
  case .loaded(let number):
      //Hacer algo cuando el estado es `.loaded(T)`
  case .error(let error):
  //Hacer algo cuando el estado es `.error(E)`
}
```

También añade una extensión de Combine donde permite suscribirnos a la vez que transforma los datos al tipo `ModelDataState`

``` swift
var bag = Set<AnyCancellable>()
Just(1).sinkToState{ result in
    // `result` es de tipo `ModelDataState<Int, Never>`
    // En este punto será igual a `.loaded(1)`
}.store(in: &bag)
```

