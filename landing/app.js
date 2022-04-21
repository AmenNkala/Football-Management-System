const sql = require('mssql/msnodesqlv8');
const express = require('express');
const app = express();
const path = require('path');
const alert = require('alert');

const port = 4000;

app.use(express.urlencoded({extended:true}));
app.use(express.static(__dirname + '/public'));

const config = {
  server: 'SANDILEN\\SQLEXPRESS',
  database: 'MovieDB',
  driver: 'msnodesqlv8',
  options:{
    trustedConnection: true
  },
}

app.get('/', (req, res)=> {
res.sendFile(path.join(__dirname ,"index.html" ));
})

app.post('/register',(req,res)=>{

    sql.connect(config, (err)=>{
    if(err){
      console.log(err);
    }
    const request = new sql.Request();
     request.query("insert into [dbo].[user](username,email,password) values('"+req.body.username+"','"+req.body.email+"','"+req.body.password+"')",(err, results)=>{
       if(err){
         return res.send(`Error occurred`);
       }
      // return res.send(`${req.body.username} registered succesfully.`);
      alert(`${req.body.username} registered succesfully.`);
      res.sendFile(path.join(__dirname ,"index.html" ));
     });
  })
})

app.get('/agency', function (req, res,html) {
  res.sendFile(path.join(__dirname+'/agency.html'));
 });

 app.get('/agency', function (req, res,html) {
  res.sendFile(path.join(__dirname+'/agency.html'));
 });

app.listen(port, ()=>{
  console.log(`listening on port: ${port}`);
})

