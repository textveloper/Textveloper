require "textveloper/version"
require "curb"

module Textveloper

  class Sdk

    def initialize(account_token_number, subaccount_token_number)
      @account_token_number = account_token_number
      @subaccount_token_number = subaccount_token_number
    end

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
        :cuenta_token => @account_token_number,
        :subcuenta_token => @subaccount_token_number,
        :telefono => number,
        :mensaje => message
      }
      response << Curl.post(url + api_actions[:enviar] + '/', data ).body_str 
      show_format_response([number],response)
    end

    def subaccount_balance
      data = {
        :cuenta_token => @account_token_number,
        :subcuenta_token => @subaccount_token_number
      }
      response = Curl.post(url + api_actions[:puntos_subcuenta] + '/', data).body_str
      hash_contructor(response)
    end

    def mass_messages(numbers, message)
      response = []
      numbers.each do |number|
        data = {
        :cuenta_token => @account_token_number,
        :subcuenta_token => @subaccount_token_number,
        :telefono => number,
        :mensaje => message
        }
        response << Curl.post(url + api_actions[:enviar] + '/', data ).body_str
      end
      show_format_response(numbers,response)
    end
    
    def show_format_response(numbers,response)
      data = {}
      hash_constructor_with_numbers(numbers,response, data)        
    end

    def hash_contructor(response)
      Hash[*response.split(/\W+/)[1..-1]]
    end

    def hash_constructor_with_numbers(numbers,response, data)
      numbers.each_with_index do |number, index|
        data[number.to_sym] = Hash[*response[index].split(/\W+/)[1..-1]]
      end
      data
    end

    def format_phone(phone_number)
      if phone_number[0] == '0'
        phone_number.gsub(/[\W]|58|/,'')
      else
        '0' + phone_number.gsub(/[\W]|58|/,'')
      end
    end

    private

    def url
      'http://api.textveloper.com/' 
    end
  end
end
