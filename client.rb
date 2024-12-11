require 'net/http'
require 'json'

# Configuración del cliente
$url = URI('http://localhost:4567/rpc')

# Llamar al método remoto
def call_rpc(method, params)
  request_body = {
    jsonrpc: '2.0',
    method: method,
    params: params,
    id: 1
  }

  response = Net::HTTP.post(
    $url,
    request_body.to_json,
    'Content-Type' => 'application/json'
  )

  JSON.parse(response.body)
end

# Ejemplo de uso
puts 'Suma de 5 y 3:'
puts call_rpc('add', [5, 3])

puts 'Resta de 10 y 4:'
puts call_rpc('subtract', [10, 4])
