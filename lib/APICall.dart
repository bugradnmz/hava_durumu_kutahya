import 'dart:convert';
import 'package:hava_durumu/Weather.dart';
import 'package:http/http.dart' as http; //pubspec.yaml'de depencies altına'da ekledim.

class APICall {
  final String url = "https://api.open-meteo.com/v1/forecast?latitude=39.4242&longitude=29.9833&daily=temperature_2m_max&timezone=auto";

  Future<String> getData() async { //await kullanabilmek için Future tipi metod yazdım.
    final response = await http.get(Uri.parse(url)); //await - alt satırı çalıştırmadan önce cevap bekler. Beklemezse, olmayan verileri yazdırmaya çalışıp hata vebilir.

    if (response.statusCode == 200) { //Status Code 200: The “OK” Response anlamında.
      /*print("JSON HAM VERİ:"
          "\n${response.body}");*/
    return response.body;
    } else {
      throw Exception('Failed to get data.');
    }
  }

  void forecast(){
    getData().then((data) { //future methodundan veriyi dışarıya aktaramadım, bende veriyle data geldiğinde çalıştır methodunu içinde çalıştım.
      //Lakin çok verimli bir yöntem olduğunu düşünmüyorum. Future içindeki veriyi normal methodlarda kullanılmak üzere dışarıya çıkartmayı en verimli şekliyle öğren!
      var timeList = List.from(jsonDecode(data)['daily']['time']); //jsondan gelen 7 günlük datayı listeye çevir.
      var tempList = List.from(jsonDecode(data)['daily']['temperature_2m_max']); //jsondan gelen 7 günlük datayı listeye çevir.
      var weatherForecast = <Weather>[]; //Canım object türü listem
      for (int i=0; i< tempList.length; i++){ //7 gün
        var weather = Weather(city: "KÜTAHYA", time: timeList[i], temp: tempList[i]); //Object yarat ve object listeme ekle.
        weatherForecast.add(weather);
      }
      for (var w in weatherForecast){ //object listemdeki her object'i detaylarıyla yazdır.
        print("${w.city}, ${w.time}, ${w.temp}");
      }
    });
  }
}

