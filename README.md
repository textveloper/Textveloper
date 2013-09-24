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
  Pendiente

#### Mensajes Enviados
  Pendiente

#### Compras
  Pendiente

### Consulta de Puntos
  Pendiente



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
