# Textveloper

Envío de mensajes de texto a tráves del servicio de mesajeria de [Textveloper](http://textveloper.com)

[![Code Climate](https://codeclimate.com/repos/523697cdc7f3a37543001042/badges/d8939168e4bd8e639d39/gpa.png)](https://codeclimate.com/repos/523697cdc7f3a37543001042/feed)

[![Gem Version](https://badge.fury.io/rb/textveloper.png)](http://badge.fury.io/rb/textveloper)

[![Build Status](https://travis-ci.org/GusGA/Textveloper.png?branch=master)](https://travis-ci.org/GusGA/Textveloper)

## Installation

Add this line to your application's Gemfile:

    gem 'textveloper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install textveloper

## Uso

```ruby
sms = Textveloper::Sdk.new(cuenta_token,subcuenta_token)
```

### Enviar mensajes individuales

```ruby
  sms.send_sms(numero,mensaje)
  sms.send_sms("04141234567","Hola Mundo")
```

Este metodo retorna un Hash object (de ser exitoso esta seria la respuesta)
 
```ruby
 {:"04141234567" => {"transaccion"=>"exitosa", "mensaje_transaccion"=>"MENSAJE_ENVIADO"}}
```

### Enviar mensajes "cadena" o masivos
  único mensaje a multiples números celulares

```ruby
  sms.mass_messages(arreglo_de_numeros, mensaje)
```

```ruby
  telefonos = ["04121234567","04149876543","04164567890"]

  sms.mass_messages(telefonos, "Hola a todos") 
```

Retorna un hash con la respuesta asociada a cada número telefónico


```ruby
  {
    :"04141234567" => {"transaccion"=>"exitosa", "mensaje_transaccion"=>"MENSAJE_ENVIADO"},
    :"04149876543" => {"transaccion"=>"exitosa", "mensaje_transaccion"=>"MENSAJE_ENVIADO"},
    :"04164567890" => {"transaccion"=>"exitosa", "mensaje_transaccion"=>"MENSAJE_ENVIADO"}
  }
```

### Historial 

#### Transferencias
  Consulta de transferencia de puntos a subcuentas

  ```ruby
    sms.transfer_history
  ```

  ```ruby
    {
      "transaccion"=>"exitosa", 
      "historico"=>[{"codigo_transaccion"=>"13", "fecha"=>"2013-09-24 00:29:13", "cantidad"=>"50"}]
    }
  ```
#### Mensajes Enviados
  
  Consulta de mensajes enviados por cuenta

  ```ruby
    sms.account_history
  ```  
  
  ```ruby
    { 
      "transaccion"=>"exitosa", 
      "historico"=>
        [
          {"codigo_log"=>"100", "telefono"=>"04141234567", "estatus"=>"Enviado", "mensaje"=>"Hola Mundo", "fecha"=>"2013-09-23 23:20:07"}, 
          {"codigo_log"=>"101", "telefono"=>"04129876543", "estatus"=>"Enviado", "mensaje"=>"Hola Marte", "fecha"=>"2013-09-23 23:24:43"}
        ]
    }
  ```

#### Compras
  Pendiente

### Consulta de Puntos
  
  Consulta de puntos por cuenta

  ```ruby
    sms.account_balance
  ```
  
  ```ruby
    {"transaccion"=>"exitosa", "puntos_utilizados"=>"54", "total_puntos"=>"100", "puntos_disponibles"=>"46"}
  ```

  `puntos_utilizados` todos los puntos que fueron transferidos a las distintas subcuentas
  
  `total_puntos` todos los puntos adquiridos
  
  `puntos_disponibles` todos los puntos que aún no han sido utilizados 

  Consulta de Puntos por subcuenta
  
  Las subcuentas deben ser limitadas y tener un numero finito de puntos(mensajes)


  ```ruby
    sms.subaccount_balance 
  ```

  ```ruby
    {"transaccion"=>"exitosa", "puntos_enviados"=>"2", "total_puntos"=>"50", "puntos_disponibles"=>"48"}
  ```




## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
