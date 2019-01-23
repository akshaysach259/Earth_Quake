import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() async{
  Map _data = await getJson();
  List _features = _data['features'];
  print(_data['features'][0]['properties']['mag']);
  runApp(
    new MaterialApp(
      title: "Earth Quakes",
      home: new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text("Earth Quake"),
        ),
        body: new Center(
          child: new ListView.builder(
              itemCount: _features.length,
              padding: EdgeInsets.all(16.9),
              itemBuilder: (BuildContext context, int position){
                if(position.isOdd)return new Divider();
                final index = position ~/ 2; // We are dividing by 2 and getting int
                var format = new DateFormat.yMMMd().add_jm();
                var date = format.format(new DateTime.fromMicrosecondsSinceEpoch(_features[index]['properties']['time'] * 1000));
                //Rows For our List view
                return ListTile(
                 title: new Text(" At : ${date}",style: new TextStyle(
                   fontSize: 17.8,
                   fontWeight: FontWeight.w500
                 ),),
                  leading: new CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text("${_features[index]['properties']['mag']}"),
                  ),
                  subtitle: new Text("${_features[index]['properties']['place']}",style: new TextStyle(fontWeight: FontWeight.w700)),
                 onTap: () {_showAlertMessage(context, "Type : ${_features[index]['properties']['type']}\nInfo : ${_features[index]['properties']['title']}\nPlace : ${_features[index]['properties']['place']}\nFelt : ${_features[index]['properties']['felt']}");},
                );
              }),
        ),
      ),
    )
  );
}

void _showAlertMessage(BuildContext context, String message) {
  var Alert = new AlertDialog(
    title: new Text("Earth Quake"),
    content: new Text(message,style: new TextStyle(fontSize: 14.2,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic),),
    actions: <Widget>[
      new FlatButton(onPressed: (){Navigator.pop(context);}, child: new Text("Done"))
    ],
  );
  showDialog(context: context,child: Alert);
}

Future<Map> getJson() async{
  Uri uri = Uri.parse("https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson");
  http.Response response = await http.get(uri);
  return jsonDecode(response.body);
}