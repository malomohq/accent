# Accent

[![Build Status](https://travis-ci.org/sticksnleaves/accent.svg?branch=master)](https://travis-ci.org/sticksnleaves/accent)
[![Coverage Status](https://coveralls.io/repos/github/sticksnleaves/accent/badge.svg?branch=master)](https://coveralls.io/github/sticksnleaves/accent?branch=master)

## Installation

This package can be installed by adding `accent` to your list of dependencies in
`mix.exs`:

```elixir
def deps do
  [{:accent, "~> 0.1.0"}]
end
```

## Usage

This project provides two plugs for handling the conversion of JSON keys to
different cases: `Accent.Plug.Request` and `Accent.Plug.Response`

### `Accent.Plug.Request`

Transforms the keys of an HTTP request's params to the same or a different
case.

You can specify what case to convert keys to by passing in a `:transformer`
option.

Accent supports the following transformers out of the box:

* `Accent.Transformer.CamelCase` (e.g. `CamelCase`)
* `Accent.Transformer.PascalCase` (e.g. `pascalCase`)
* `Accent.Transformer.SnakeCase` (e.g. `snake_case`)

If no transformer is provided then `Accent.Transformer.SnakeCase` will be
used.

Please note that this plug will need to be executed after the request has
been parsed.

### Example

Given this request:

```
curl -X POST https://yourapi.com/endpoints \
  -H "Content-Type: application/json" \
  -d '{"helloWorld": "value"}'
```

a router with this configuration:

```elixir
plug Plug.Parsers, parsers: [:urlencoded, :multipart, :json],
                   pass: ["*/*"],
                   json_decoder: Poison

plug Accent.Plug.Request
```

could expect to receive a `conn.params` value of:

```elixir
%{"hello_world" => "value"}
```

### `Accent.Plug.Response`

Transforms the keys of an HTTP response to the case requested by the client.

A client can request what case the keys are formatted in by passing the case
as a header in the request. By default the header key is `Accent`. If the
client does not request a case or requests an unsupported case then no
conversion will happen. By default the supported cases are `camel`, `pascal`
and `snake`.

### Options

* `:header` - the HTTP header used to determine the case to convert the
  response body to before sending the response (default: `Accent`)
* `:json_encoder` - module used to encode JSON. The module is expected to
  define a `encode!/1` function for encoding the response body as JSON.
  (required)
* `:json_decoder` - module used to decode JSON. The module is expected to
  define a `decode!/1` function for decoding JSON into a map. (required)
* `:supported_cases` - map that defines what cases a client can request. By
  default `camel`, `pascal` and `snake` are supported.

### Examples

Given this request:

```
curl -X POST https://yourapi.com/endpoints \
  -H "Content-Type: application/json" \
  -H "Accent: pascal" \
  -d '{"helloWorld": "value"}'
```

with this router:

```elixir
defmodule MyAPI.Router do
  use Plug.Router

  plug Accent.Plug.Response, json_encoder: Poison,
                             json_decoder: Poison

  post "/endpoints" do
    send_resp(conn, 200, Poison.encode!(%{hello_world: "value"}))
  end
end
```

a client could expect a JSON response of:

```json
{
  "helloWorld": "value"
}
```
