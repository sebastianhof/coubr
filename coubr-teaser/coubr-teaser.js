// server.js

// set up ========================
var express = require('express');
var app = express();
var path = require('path');

// configuration =================
app.use('/static', express.static(path.join(__dirname,'static')));

app.engine('html', require('ejs').renderFile);

app.get('/', function(req, res) {
    res.render(path.join(__dirname,'index.html'));
});

// listen ========================
app.listen(8181);
