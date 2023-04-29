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
		
	}
	 
	print("User is ok.");
}

void viewSelect(res) async {
  final conn = await MySqlConnection.connect(new ConnectionSettings(host: '127.0.0.1',port: 3306,user: 'root',/*password: '',*/db: 'test',));
  var rows = await conn.query('select * from myarttable');
  for (var row in rows) {
	res.write('<tr>');
    for (var col in row) {
		res.write('<td>'+'${col}'+'</td>');
		print('${col}');
	}
	res.write('</tr>');
  }
  await conn.close();
  res.close();
}
