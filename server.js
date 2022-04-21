const { app, port } = require("./js/config");
const path = require("path");

app.listen(port, () => {
  console.log(`Listening at http://localhost:${port}`);
});

app.get("/agency", (req, res) => {
  res.sendFile(path.join(__dirname + "/" + "agency.html"));
});
