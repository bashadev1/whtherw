import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => (runApp(MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int temp = 0, woeid = 2487956;
  String location = 'india';
  String weather = 'clear';
  String searchApi = 'https://www.metaweather.com/api/location/search/?query=';
  String searchlocaton = 'https://www.metaweather.com/api/location/';
  void fetch(String input) async {
    var searchresult = await http.get(searchApi + input);
    var result = json.decode(searchresult.body)[0];
    setState(() {
      location = result["title"];
      woeid = result["woied"];
    });
  }

  void fetchloaction() async {
    var locationResult = await http.get(searchlocaton + woeid.toString());
    var result = json.decode(locationResult.body);
    var consolidated_weather = result["consolidated_weather"];
    var data = consolidated_weather[0];
    setState(() {
      temp = data["the_temp"].round();
      weather = data["weather_state_name"];
    });
  }

  onTextFieldSubmitted(String input) {
    fetch(input);
    fetchloaction();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'ast/a.jpg',
              ),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                temp.toString() + '~C',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.normal),
              ),
            ),
            Text(
              location,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.normal),
            ),
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 300,
                    child: TextField(
                      onSubmitted: (String input) {
                        onTextFieldSubmitted(input);
                      },
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search Cities..',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
