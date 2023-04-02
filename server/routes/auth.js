const express = require("express");
const User = require("../models/user_model")
const authRouter = express.Router();

authRouter.post("/api/signup", async (req, res) => {
    try {
        const { name, email, profilePic } = req.body;
        // email already exists
        let user = await User.findOne({ email: email });


        if (!user) {
            user = new User({
                name,
                email,
                profilePic,
            });
            user = await user.save();
        }


        res.json({ user })

    } catch (error) {
        console.log(error)
    }
});

authRouter.get("/", (req, res) => {
    res.send("ok")
})

module.exports = authRouter;