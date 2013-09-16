require 'spec_helper'

describe Textveloper do

  let(:account_token){"account_token"}
  let(:subaccount_token){"subaccount_token"}
  let(:notificator){Textveloper::Sdk.new(account_token,subaccount_token)}
  let(:tel_numbers){["04147890123","04141234567","04161234567"]}
  let(:mensaje){"Enviado desde textveloper plataform"}
  let(:hash_response){{"transaccion"=>"exitosa", "mensaje_transaccion"=>"MENSAJE_ENVIADO"}}
  let(:points){"{\"transaccion\":\"exitosa\",\"puntos_enviados\":\"0\",\"total_puntos\":\"0\",\"puntos_disponibles\":\"0\",}"}
  let(:hash_response_points){{"transaccion"=>"exitosa", "puntos_enviados"=>"0", "total_puntos" => "0", "puntos_disponibles" => "0"}}
  let(:url){'http://api.textveloper.com/'}


  it "consulta de puntos" do
      stub_request(:post, "http://api.textveloper.com/saldo-subcuenta/").
         with(:body => "cuenta_token=account_token&subcuenta_token=subaccount_token").
         to_return(:status => 200, :body => points, :headers => {})
    notificator.subaccount_balance.should == hash_response_points  
  end


  it 'envio de mensaje simple' do
    stub_request(:post, "http://api.textveloper.com/enviar/").
         with(:body => "cuenta_token=account_token&subcuenta_token=subaccount_token&telefono=04121234567&mensaje=Enviado+desde+textveloper+plataform").
         to_return(:status => 200, :body => "{\"transaccion\":\"exitosa\",\"mensaje_transaccion\":\"MENSAJE_ENVIADO\"}", :headers => {})

    notificator.send_sms("04121234567",mensaje).should == {:"04121234567"=>hash_response}
  end 

  it 'envio masivo de mensajes' do
    tel_numbers.each do |number|
        stub_request(:post, "http://api.textveloper.com/enviar/").
         with(:body => "cuenta_token=account_token&subcuenta_token=subaccount_token&telefono=#{number}&mensaje=Enviado+desde+textveloper+plataform").
         to_return(:status => 200, :body => "{\"transaccion\":\"exitosa\",\"mensaje_transaccion\":\"MENSAJE_ENVIADO\"}", :headers => {})
    end     
    notificator.mass_messages(tel_numbers,mensaje).should == {:"04147890123"=>hash_response, :"04141234567"=>hash_response, :"04161234567"=>hash_response}
  end

  context "asociación de numeros de telefono con data recibida" do
    let(:data){Hash.new}
    let(:numero){["04146578904"]}
    let(:numeros){["04147890123","04141234567"]}
    let(:response){"{\"transaccion\":\"exitosa\",\"mensaje_transaccion\":\"MENSAJE_ENVIADO\"}"}
    
    it "un telefono" do
      notificator.hash_constructor_with_numbers(numero,[response], data).should == {:"04146578904"=>hash_response}
    end

    it "varios numeros" do 
      notificator.hash_constructor_with_numbers(numeros,[response,response], data).should == {:"04147890123"=>hash_response,:"04141234567"=>hash_response}
    end

  end


end