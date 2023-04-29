import 'dart:io';
import 'package:mysql1/mysql1.dart';

void main() async {
	// запуск web-сервера.
  var server = await HttpServer.bind(InternetAddress.anyIPv6, 8888);
  print("Listening for connections on http://localhost:8888/");
  await server.forEach((HttpRequest request) {
 
    var resText = "Page Not Found";
    switch (request.uri.path) {
      case "/":               // если обращение к главной странице
        resText = "Index Page";
        break;
      case "/about":               // если обращение по пути "/about"
        resText = "About Page";
        break;
      case "/contact":               // если обращение по пути "/contacts"
        resText = "Contacts Page";
        break;
    }
    final res = request.response;
//	res.write(resText);
	ReadTpl(res);

  });
}

void ReadTpl(res) async {
	res.headers.add(HttpHeaders.contentTypeHeader, "text/html; charset=utf-8");
	File file = File("select.html");
	var lines = await file.readAsLines();
	for(final line in lines){
		print(line);
		
		if ((line != "@tr") && (line != "@ver")) {
			res.write(line);
		}
		if (line.contains("@tr")) {
			viewSelect(res);
		}
		if (line.contains("@ver")) {
			viewVer(res);
		}		
	}
	 
	print("User is ok.");
}

void viewSelect(res) async {
	final conn = await MySqlConnection.connect(new ConnectionSettings(host: '127.0.0.1',port: 3306,user: 'root',/*password: '',*/db: 'test',));
	res.write('<table>');
	var heads = await conn.query("SHOW COLUMNS FROM myarttable");
	res.write('<tr>');
	for (var head in heads) {
		res.write('<td>${head[0]}</td>');
		print('${head[0]}');
	}
	res.write('</tr>');	
	
	var rows = await conn.query("SELECT * FROM myarttable WHERE id>14 ORDER BY id DESC");
	for (var row in rows) {
		res.write('<tr>');
		for (var col in row) {
			res.write('<td>${col}</td>');
			print('${col}');
		}
		res.write('</tr>');
	}
	res.write('</table>');
	await conn.close();
	res.close();
}

void viewVer(res) async {
	final conn = await MySqlConnection.connect(new ConnectionSettings(host: '127.0.0.1',port: 3306,user: 'root',/*password: '',*/db: 'test',));
	var vers = await conn.query("SELECT VERSION() AS ver");
	for (var ver in vers) {
		res.write('<p>${ver[0]}</p>');
		print('${ver[0]}');
	}
}