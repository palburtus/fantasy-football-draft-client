const express = require('express');
const path = require('path');
const app = express();

// Handles any requests that don't match the ones above
app.get('*', (req,res) =>{
    res.sendFile(path.join(__dirname+'/client/build/index.html'));
});

const port = process.env.PORT || 5001;
app.listen(port);

console.log('App is listening on port ' + port);