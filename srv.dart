import 'dart:async';
import 'dart:io';

import 'package:mysql_client/mysql_client.dart';

var mysql_ip;
final collation = "utf8mb4_unicode_ci";

void main() async {
  var server = await HttpServer.bind(InternetAddress.anyIPv4, 8888);
  print("Listening for connections on http://host.docker.internal:8888/");
  mysql_ip = await getDatabaseIP();

  await server.forEach((HttpRequest request) {
    switch (request.uri.path) {
      case "/":
        print(request.uri);
        var uri = Uri.parse(request.uri.toString());
        uri.queryParameters.forEach((k, v) {
          print('key: $k - value: $v');
        });
        print('Count: ' + uri.queryParameters.length.toString());
        if (uri.queryParameters.length > 0) {
          rowInsert(uri.queryParameters);
        }
        break;
    }
    final res = request.response;
    ReadTpl(res);
  });
}

Future<String> getDatabaseIP() async {
  final addresses = await InternetAddress.lookup('dart_mysql_lab_2');
	print('getDatabaseIP: ${addresses.first.address}');
  return addresses.first.address;
}

void ReadTpl(res) async {
  res.headers.add(HttpHeaders.contentTypeHeader, "text/html; charset=utf-8");
  File file = File("select.html");
  var lines = await file.readAsLines();
  for (final line in lines) {
    if (line.contains("@tr")) {
      await viewSelect(res);
    } else if (line.contains("@ver")) {
      await viewVer(res);
    } else {
      res.write(line);
    }
  }
  res.close();
}

Future<void> viewSelect(res) async {
  try {
    final name1 = "Observation";
    final name2 = "NaturalObjects";
    final conn = await MySQLConnection.createConnection(
      host: mysql_ip,
      port: 3306,
      userName: "root",
      password: "12345678",
      databaseName: "lab_2",
      collation: collation,
    );
    await conn.connect();
    res.write('<table>');
    var table =
        await conn.execute("SELECT * FROM ${name1} NATURAL JOIN ${name2}");
    final numOfCols = table.numOfColumns;
    res.write('<tr>');
    for (var col in table.cols) {
      res.write('<td>${col.name}</td>');
    }
    res.write('</tr>');

    for (var row in table.rows) {
      res.write('<tr>');
      for (var i = 0; i < numOfCols; i++) {
        var val = row.colAt(i);
        res.write('<td>${val}</td>');
      }
      res.write('</tr>');
    }
    res.write('</table>');
    await conn.close();
  } on Exception catch (e) {
    res.write('WAITING FOR SQL SERVER TO SETUP');
    print('viewSelect: $e');
  }
}

Future<void> viewVer(res) async {
  try {
    final conn = await MySQLConnection.createConnection(
        host: mysql_ip,
        port: 3306,
        userName: "root",
        password: "12345678",
        databaseName: "lab_2",
        collation: collation);
    await conn.connect();
    var vers = await conn.execute("SELECT VERSION() AS ver");
    for (var ver in vers.rows) {
      res.write('${ver.colAt(0)}');
			print('viewVer: ${ver.colAt(0)}');
    }
    await conn.close();
  } on Exception catch (e) {
    res.write('WAITING FOR SQL SERVER TO SETUP');
    print('viewVer: $e');
  }
}

Future<void> rowInsert(mass) async {
  try {
    print('rowInsert');
    String sValue = '';
    int i = 0;
    mass.forEach((k, v) {
      if (i > 0) {
        sValue = sValue + ',';
      }
      sValue = sValue + "'$v'";
      i++;
    });
    sValue =
        'INSERT INTO Individuals (last_name, first_name, middle_name, passport, tax_number, social_number, driver_license, documents, notes) VALUES ($sValue)';

    final conn = await MySQLConnection.createConnection(
        host: mysql_ip,
        port: 3306,
        userName: "root",
        password: "12345678",
        databaseName: "lab_2",
        collation: collation);
    await conn.connect();
    await conn.execute(sValue);
    await conn.close();
    print('Insert into table is good.');
  } on Exception catch (e) {
    print('rowInsert: $e');
  }
}
