require 'spec_helper'

describe Textveloper do

  let(:account_token){"account_token"}
  let(:subaccount_token){"subaccount_token"}
  let(:notificator){Textveloper::Sdk.new(account_token,subaccount_token)}
  let(:tel_numbers){["04147890123","04141234567","04161234567"]}
  let(:mensaje){"Enviado desde textveloper plataform"}
  let(:response){"{\"transaccion\":\"exitosa\",\"mensaje_transaccion\":\"MENSAJE_ENVIADO\"}"}
  let(:hash_response){{"transaccion"=>"exitosa", "mensaje_transaccion"=>"MENSAJE_ENVIADO"}}
  let(:points){"{\"transaccion\":\"exitosa\",\"puntos_enviados\":\"0\",\"total_puntos\":\"0\",\"puntos_disponibles\":\"0\"}"}
  let(:hash_response_points){{"transaccion"=>"exitosa", "puntos_enviados"=>"0", "total_puntos" => "0", "puntos_disponibles" => "0"}}
  let(:mensaje_largo){"Doggy ipsizzle dolor black amizzle, yo mamma rizzle elit. Nullizzle its fo rizzle velizzle, fo volutpizzle, suscipizzle quis, ghetto vel, fizzle. Pellentesque crunk tortizzle. Sizzle pizzle. Sizzle izzle dolor nizzle turpis mofo gizzle. Maurizzle pellentesque shizzle my nizzle crocodizzle crackalackin turpizzle."}
  let(:url){'http://api.textveloper.com/'}


  it "consulta de puntos" do
    stub_request(:post, "http://api.textveloper.com/saldo-subcuenta/").
      with(:body => "cuenta_token=account_token&subcuenta_token=subaccount_token").
      to_return(:status => 200, :body => points, :headers => {"Content-Type" => "application/json"})
    notificator.subaccount_balance.should == hash_response_points
  end

  it 'Api no responde sin envía algo distinto a JSON' do
    stub_request(:post, "http://api.textveloper.com/enviar/").
      with(:body => "cuenta_token=account_token&subcuenta_token=subaccount_token&telefono=04121234567&mensaje=Enviado+desde+textveloper+plataform").
      to_return(:status => 200, :body => "<html><head></head><body><h1>To Many Request</h1></body></html>", :headers => {"Content-Type" => "application/html"})
    notificator.send_sms("04121234567", mensaje).should == {:"04121234567"=>{"transaccion"=>"error", "mensaje_transaccion"=>"ERROR_EN_SERVICIO"}}
  end


  it 'envio de mensaje simple' do
    stub_request(:post, "http://api.textveloper.com/enviar/").
      with(:body => "cuenta_token=account_token&subcuenta_token=subaccount_token&telefono=04121234567&mensaje=Enviado+desde+textveloper+plataform").
      to_return(:status => 200, :body => response, :headers => {"Content-Type" => "application/json"})

    notificator.send_sms("04121234567",mensaje).should == {:"04121234567"=>hash_response}
  end

  it 'envio masivo de mensajes' do
    tel_numbers.each do |number|
      stub_request(:post, "http://api.textveloper.com/enviar/").
        with(:body => "cuenta_token=account_token&subcuenta_token=subaccount_token&telefono=#{number}&mensaje=Enviado+desde+textveloper+plataform").
        to_return(:status => 200, :body => response, :headers => {"Content-Type" => "application/json"})
    end
    notificator.mass_messages(tel_numbers,mensaje).should == {:"04147890123"=>hash_response, :"04141234567"=>hash_response, :"04161234567"=>hash_response}
  end

  context "asociacion de numeros de telefono con data recibida" do
    let(:numero){["04146578904"]}
    let(:numeros){["04147890123","04141234567"]}


    it "un telefono" do
      responses = []
      numero.each do |number|
        stub_request(:post, "http://api.textveloper.com/enviar/").
          with(:body => "cuenta_token=account_token&subcuenta_token=subaccount_token&telefono=#{number}&mensaje=Enviado+desde+textveloper+plataform").
          to_return(:status => 200, :body => response, :headers => {"Content-Type" => "application/json"})
          responses << notificator.core_operation(number, mensaje)
      end
      notificator.hash_constructor_with_numbers(numero,responses).should == {:"04146578904"=>hash_response}
    end

    it "varios numeros" do
      responses = []
      numeros.each do |number|
        stub_request(:post, "http://api.textveloper.com/enviar/").
          with(:body => "cuenta_token=account_token&subcuenta_token=subaccount_token&telefono=#{number}&mensaje=Enviado+desde+textveloper+plataform").
          to_return(:status => 200, :body => response, :headers => {"Content-Type" => "application/json"})
          responses << notificator.core_operation(number, mensaje)
      end
      notificator.hash_constructor_with_numbers(numeros,responses).should == {:"04147890123"=>hash_response,:"04141234567"=>hash_response}
    end

  end

  it "Error en servicio, respuesta del firewall formato HTML" do
    stub_request(:post, "http://api.textveloper.com/enviar/").
      with(:body => "cuenta_token=account_token&subcuenta_token=subaccount_token&telefono=04121234567&mensaje=Enviado+desde+textveloper+plataform").
      to_return(:status => 200, :body => "<html><head></head><body><h1>To Many Request</h1></body></html>", :headers => {"Content-Type" => "application/html"})
    response = notificator.core_operation("04121234567", mensaje)
    notificator.send(:hash_contructor, response).should == {"transaccion"=>"error", "mensaje_transaccion"=>"ERROR_EN_SERVICIO"}
  end

  it "formatear el numero de telefono a la forma 04xxxxxxxx" do
    notificator.send(:format_phone,"+584121234567").should eq("04121234567")
    notificator.send(:format_phone,"+58-412.123.45.67").should eq("04121234567")
    notificator.send(:format_phone,"0412-123-45-67").should eq("04121234567")
    notificator.send(:format_phone,"0412.123.45.67").should eq("04121234567")
    notificator.send(:format_phone,"+58-412.158.58.58").should eq("04121585858")
    notificator.send(:format_phone,"58.412.1.2.3.4.5.6.7").should eq("04121234567")
    notificator.send(:format_phone,"+58 412 123 45 67").should eq("04121234567")
    notificator.send(:format_phone,"(0412)1234567").should eq("04121234567")

  end

  it "formatear response a hash " do
    stub_request(:post, "http://api.textveloper.com/enviar/").
      with(:body => "cuenta_token=account_token&subcuenta_token=subaccount_token&telefono=04121234567&mensaje=Enviado+desde+textveloper+plataform").
      to_return(:status => 200, :body => response, :headers => {"Content-Type" => "application/json"})
    rspn = notificator.core_operation("04121234567", mensaje)
    notificator.send(:hash_contructor,rspn).should eq(hash_response)
  end

  it "Divisor de mensajes" do
    mensaje_cortado = ["Doggy ipsizzle dolor black amizzle, yo mamma rizzle elit. Nullizzle its fo rizzle velizzle, fo volutpizzle, suscipizzle quis, ghetto vel, fizzle. 1/3",
                       "Pellentesque crunk tortizzle. Sizzle pizzle. Sizzle izzle dolor nizzle turpis mofo gizzle. Maurizzle pellentesque shizzle my nizzle crocodizzle 2/3",
                       "crackalackin turpizzle 3/3"]
    notificator.send(:chunck_message, mensaje_largo).should eq(mensaje_cortado)

  end


end
