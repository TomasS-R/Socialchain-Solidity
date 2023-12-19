const express = require("express");
const path = require("path");
const app = express();

// Serve static files from the 'public' directory
app.use(express.static(__dirname + '/css'));

app.get("/", (req, res) => {
    res.sendFile(path.join(__dirname + "/formulario_alta.html"));
})


const server = app.listen(5000);
const portNumber = server.address().port;
console.log(`port is open on ${portNumber}`);