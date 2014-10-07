// server.js

// set up ========================
var express = require('express');
var app = express();
var path = require('path');

// configuration =================
app.use('/static', express.static(path.join(__dirname,'../coubr-web/src/main/webapp/WEB-INF/static/')));

app.engine('html', require('ejs').renderFile);

app.get('/app', function(req, res) {
    res.render(path.join(__dirname,'../coubr-web/src/main/webapp/WEB-INF/templates/app.html'));
});
app.get('/business', function(req, res) {
    res.render(path.join(__dirname,'../coubr-web/src/main/webapp/WEB-INF/templates/business.html'));
});
app.get('/b', function(req, res) {
    res.render(path.join(__dirname,'../coubr-web/src/main/webapp/WEB-INF/templates/b.html'));
});
app.get('/', function(req, res) {
    res.redirect("/app");
});

// listen (start app with node server.js) ======================================
app.listen(8181);
console.log("App listening on port 8181");