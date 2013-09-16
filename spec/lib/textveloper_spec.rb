require 'spec_helper'

describe Textveloper do

  let(:account_token){"account_token"}
  let(:subaccount_token){"subaccount_token"}
  let(:notificator){Textveloper::Sdk.new(account_token,subaccount_token)}
  let(:tel_numbers){["04122202111","04123809179","04160147168"]}
  let(:mensaje){"Enviado desde textveloper plataform"}
  let(:hash_response){{"transaccion"=>"exitosa", "mensaje_transaccion"=>"MENSAJE_ENVIADO"}}
  let(:url){'http://api.textveloper.com/'}

  context "asociación de numeros de telefono con data recibida" do
    let(:data){Hash.new}
    let(:numero){["04122202111"]}
    let(:numeros){["04122202111","04143007951"]}
    let(:response){"{\"transaccion\":\"exitosa\",\"mensaje_transaccion\":\"MENSAJE_ENVIADO\"}"}
    
    it "un telefono" do
      notificator.hash_constructor(numero,[response], data).should == {:"04122202111"=>hash_response}
    end

    it "varios numeros" do 
      notificator.hash_constructor(numeros,[response,response], data).should == {:"04122202111"=>hash_response,:"04143007951"=>hash_response}
    end

  end

  it 'envio de mensaje simple' do
    Curb.stub_chain(:post,:body_str).with(url + 'enviar/', data).and_return(response)
    notificator.send_sms("04122202111",mensaje).should == {:"04122202111"=>hash_response}
  end 

  it 'envio masivo de mensajes' do
    Curb.stub_chain(:post,:body_str).with(url + 'enviar/', data).and_return(response)
    notificator.mass_messages(tel_numbers,mensaje).should == {:"04122202111"=>hash_response, :"04123809179"=>hash_response, :"04160147168"=>hash_response}
  end    
end