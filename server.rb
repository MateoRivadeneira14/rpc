require 'sinatra'
require 'json'

# Configuración básica de Sinatra
set :bind, '0.0.0.0'
set :port, 4567

# Manejo de solicitudes GET en '/rpc'
get '/rpc' do
  content_type :json
  {
    message: 'Este servidor soporta JSON-RPC a través de solicitudes POST en esta ruta.',
    instructions: {
      example_request: {
        jsonrpc: '2.0',
        method: 'add',
        params: [5, 3],
        id: 1
      }
    }
  }.to_json
end

# Manejo de solicitudes POST en '/rpc' para JSON-RPC
post '/rpc' do
  begin
    request_payload = JSON.parse(request.body.read)

    # Validar JSON-RPC básico
    if request_payload['jsonrpc'] == '2.0' && request_payload['method']
      method_name = request_payload['method']
      params = request_payload['params'] || []

      # Ejecución del método solicitado
      result = case method_name
               when 'add'
                 params[0] + params[1]
               when 'subtract'
                 params[0] - params[1]
               else
                 { error: 'Método no soportado' }
               end

      # Respuesta JSON-RPC
      {
        jsonrpc: '2.0',
        result: result,
        id: request_payload['id']
      }.to_json
    else
      status 400
      { error: 'Solicitud inválida' }.to_json
    end
  rescue JSON::ParserError
    status 400
    { error: 'El cuerpo de la solicitud debe ser JSON válido' }.to_json
  end
end
