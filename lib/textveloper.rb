require "textveloper/version"

module Textveloper

  class SmsService

    def api_actions
      {
      :enviar => 'enviar',
      :puntos_cuenta => 'saldo-cuenta',
      :puntos_subcuenta => 'saldo-subcuenta',
      :compras => 'historial-compras',
      :envios => 'historial-envios',
      }
    end

    def send_sms(number,message)
      response = []
      data = {
        :cuenta_token => account_token_number,
        :subcuenta_token => subaccount_token_number,
        :telefono => number,
        :mensaje => message
      }
      response << Curl.post(url_destiny + api_actions[:enviar] + '/', data ).body_str 
      show_format_response([number],response)
    end

    def subaccount_balance
      data = {
        :cuenta_token => account_token_number,
        :subcuenta_token => subaccount_token_number
      }
      Curl.get(url_destiny + api_actions[:puntos_subcuenta] + '/', data)
    end

    def mass_messages(numbers, message)
      response = []
      numbers.each do |number|
        data = {
        :cuenta_token => account_token_number,
        :subcuenta_token => subaccount_token_number,
        :telefono => number,
        :mensaje => message
        }
        response << Curl.post(url_destiny + api_actions[:enviar] + '/', data ).body_str
      end
      show_format_response(numbers,response)
    end
    
    def show_format_response(numbers,response)
      data = {}
      hash_constructor(numbers,response, data)        
    end

    def hash_constructor(numbers,response, data)
      numbers.each_with_index do |number, index|
        data[number.to_sym] = Hash[*response[index].split(/\W+/)[1..-1]]
      end
      data
    end

    private

    def url_destiny
      'http://api.textveloper.com/' 
    end

    def account_token_number
      '39de7e62118e5e87a94e27ee50805042'
    end

    def subaccount_token_number
      '7c29e632e9b91b13043d7890be0acc11'
    end
  end
end
