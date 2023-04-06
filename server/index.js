const express = require("express");
const mongoose = require('mongoose');
const cors = require("cors");

const authRouter = require("./routes/auth");


const PORT = process.env.PORT | 3001;
const app = express();

app.use(cors());
app.use(express.json());
app.use(authRouter);

const DBUrl = "mongodb://127.0.0.1:27017/tuhin";
mongoose.connect(DBUrl)
    .then(() => {
        console.log("data is connect db")
    });



app.listen(PORT, "0.0.0.0", () => {
    console.log(`my server is ready port with ${PORT}`)
})