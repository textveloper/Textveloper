require "textveloper/version"
require "curb"
require "json"

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
      :transferencias => 'historial-transferencias'
      }
    end

    #Servicio SMS 

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

    #Historial de Transacciones 

    def account_balance
      data = {
        :cuenta_token => @account_token_number,
      }
      hash_contructor(Curl.post(url + api_actions[:puntos_cuenta] + '/', data).body_str)
    end

    def subaccount_balance
      data = {
        :cuenta_token => @account_token_number,
        :subcuenta_token => @subaccount_token_number
      }
      hash_contructor(Curl.post(url + api_actions[:puntos_subcuenta] + '/', data).body_str)
    end

    def account_history
      data = {
        :cuenta_token => @account_token_number,
        :subcuenta_token => @subaccount_token_number
      }
      hash_contructor(Curl.post(url + api_actions[:envios] + '/',data).body_str)
    end

    def buy_history
      data = {
        :cuenta_token => @account_token_number
      }
      hash_contructor(Curl.post(url + api_actions[:compras] + '/',data).body_str)
    end

    def transfer_history
       data = {
        :cuenta_token => @account_token_number,
        :subcuenta_token => @subaccount_token_number
      }
      hash_contructor(Curl.post(url + api_actions[:transferencias] + '/',data).body_str)
    end
    
    #metodos de formato de data

    def show_format_response(numbers,response)
      data = {}
      hash_constructor_with_numbers(numbers,response, data)        
    end

    def hash_constructor_with_numbers(numbers,response, data)
      numbers.each_with_index do |number, index|
        data[number.to_sym] = hash_contructor(  response[index])
      end
      data
    end

    def format_phone(phone_number)
      phone_number.gsub(/\W/,"").sub(/^58/,"").sub(/(^4)/, '0\1')
    end    

    def hash_contructor(response)
      JSON.parse(response)
    end


    private

    def url
      'http://api.textveloper.com/' 
    end
  end
end
