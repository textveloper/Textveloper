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

    def core_operation(number, message)
      data = {
        :cuenta_token => @account_token_number,
        :subcuenta_token => @subaccount_token_number,
        :telefono => format_phone(number),
        :mensaje => message
      }
      return Curl.post(url + api_actions[:enviar] + '/', data )
    end

    # Servicio SMS

    def send_sms(number,message)
      response = []
      if message.size <= 160
        response << core_operation(number,message)
      else
        chunck_message(message).each do |m|
          response << core_operation(number, m)
        end
      end
      show_format_response([format_phone(number)],response)
    end

    def mass_messages(numbers, message)
      response = []
      if message.size <= 160
        numbers.each do |number|
          response << core_operation(number, message)
          slow_sms
        end
      else
        numbers.each do |number|
          chunck_message(message).each do |m|
            response << core_operation(number,m)
            slow_sms
          end
        end
      end
      numbers.map!{ |n| format_phone(n)}
      show_format_response(numbers,response)
    end

    # Historial de Transacciones

    def transactional_data
      {
        :cuenta_token => @account_token_number,
        :subcuenta_token => @subaccount_token_number
      }
    end

    def account_data
      {
        :cuenta_token => @account_token_number,
      }
    end

    def account_balance
      hash_contructor(Curl.post(url + api_actions[:puntos_cuenta] + '/', account_data))
    end

    def buy_history
      hash_contructor(Curl.post(url + api_actions[:compras] + '/', account_data))
    end

    def subaccount_balance
      hash_contructor(Curl.post(url + api_actions[:puntos_subcuenta] + '/', transactional_data))
    end

    def account_history
      hash_contructor(Curl.post(url + api_actions[:envios] + '/',transactional_data))
    end

    def transfer_history
      hash_contructor(Curl.post(url + api_actions[:transferencias] + '/',transactional_data))
    end

    # Metodos de formato de data

    def show_format_response(numbers,response)
      hash_constructor_with_numbers(numbers,response)
    end

    def hash_constructor_with_numbers(numbers,response)
      data = Hash.new
      numbers.each_with_index do |number, index|
        data[number.to_sym] = hash_contructor(response[index])
      end
      data
    end

    private

    def format_phone(phone_number)
      phone_number.nil? ? "" : phone_number.gsub(/\W/,"").sub(/^58/,"").sub(/(^4)/, '0\1')
    end

    def valid_content_types
      ["application/json", "application/x-javascript", "text/javascript", "text/x-javascript", "text/x-json"]
    end

    def hash_contructor(response)
      if valid_content_types.any? { |type| response.content_type.match(type) }
        JSON.parse(response.body_str)
      else
        {"transaccion"=>"error", "mensaje_transaccion"=>"ERROR_EN_SERVICIO"}
      end
    end

    def chunck_message(message)
      # Leave space for pagination i.e: "BLAh blah blah (2/3)"
      paginate(message.scan(/.{1,155}\b/).map(&:strip))
    end

    def paginate(arr)
      arr.map!.with_index {|elem,i| elem << " #{i+1}/#{arr.size}" }
    end

    def slow_sms
      sleep(1)
    end

    def url
      'https://api.textveloper.com/'
    end
  end
end
