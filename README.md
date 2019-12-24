# Accent

![](https://github.com/malomohq/accent/workflows/ci/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/sticksnleaves/accent/badge.svg?branch=master)](https://coveralls.io/github/sticksnleaves/accent?branch=master)

## Installation

This package can be installed by adding `accent` to your list of dependencies in
`mix.exs`:

```elixir
def deps do
  [{:accent, "~> 1.0"}]
end
```

Please note that you will need to provide `accent` with a JSON codec. Both
[`poison`](https://github.com/devinus/poison) and
[`jason`](https://github.com/michalmuskala/jason) are supported.

## Usage

This project provides two plugs for handling the conversion of JSON keys to
different cases: `Accent.Plug.Request` and `Accent.Plug.Response`

### `Accent.Plug.Request`

Transforms the keys of an HTTP request's params to the same or a different
case.

You can specify what case to convert keys to by passing in a `:transformer`
option.

Accent supports the following transformers out of the box:

* `Accent.Case.Camel` (e.g. `camelCase`)
* `Accent.Case.Pascal` (e.g. `PascalCase`)
* `Accent.Case.Snake` (e.g. `snake_case`)

If no transformer is provided then `Accent.Case.Snake` will be
used.

Please note that this plug will need to be executed after the request has
been parsed.

**Example**

Given this request:

```
curl -X POST https://yourapi.com/endpoints \
  -H "Content-Type: application/json" \
  -d '{"hello": "Accent"}'
```

a router with this configuration:

```elixir
plug Plug.Parsers, parsers: [:urlencoded, :multipart, :json],
                   pass: ["*/*"],
                   json_decoder: Jason

plug Accent.Plug.Request
```

could expect to receive a `conn.params` value of:

```elixir
%{"hello" => "Accent"}
```

### `Accent.Plug.Response`

Transforms the keys of an HTTP response to the case requested by the client.

A client can request what case the keys are formatted in by passing the case
as a header in the request. By default the header key is `Accent`. If the
client does not request a case or requests an unsupported case then a default
case defined by `:default_case` will be used. If no default case is provided
then no conversion will happen. By default the supported cases are `camel`,
`pascal` and `snake`.

## Options

* `:default_case` - module used to case the response when the client does not
  request a case or requests an unsupported case. When not provided then no
  conversation will happen for the above scenarios. Defaults to `nil`.
* `:header` - the HTTP header used to determine the case to convert the
  response body to before sending the response (default: `Accent`)
* `:json_codec` - module used to encode and decode JSON. The module is
  expected to define `decode/1` and `encode!/1` functions (required).
* `:supported_cases` - map that defines what cases a client can request. By
  default `camel`, `pascal` and `snake` are supported.

**Example**

```
plug Accent.Plug.Response, default_case: Accent.Case.Snake,
                           header: "x-accent",
                           supported_cases: %{"pascal" => Accent.Case.Pascal},
                           json_codec: Jason
```

Given this request:

```
curl -X POST https://yourapi.com/endpoints \
  -H "Content-Type: application/json" \
  -H "Accent: camel" \
  -d '{"hello": "Accent"}'
```

with this router:

```elixir
defmodule MyAPI.Router do
  use Plug.Router

  plug Accent.Plug.Response, json_codec: Jason

  post "/" do
    send_resp(conn, 200, Jason.encode!(%{hello_back: "Anthony"}))
  end
end
```

a client could expect a JSON response of:

```json
{
  "helloBack": "Anthony"
}
```

## Contributors

A special thanks to all of our contributors!

* [@anthonator](https://github.com/anthonator)
* [@maxsalven](https://github.com/maxsalven)
* [@szajbus](https://github.com/szajbus)
