var express = require('express');
var app = express();

app.use(express.static(__dirname + '/client'));
app.set('view engine', 'ejs');


app.get('/', function (req, res) {
  res.render('client/index.html');
});


var port = process.env.PORT || 8080;
var server = app.listen(port, function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log('coubr-app is listening at http://%s:%s', host, port);
});
