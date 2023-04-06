const express = require("express");
const jwt = require("jsonwebtoken");
const User = require("../models/user_model")
const auth = require("../middlerwares/auth");
const authRouter = express.Router();

authRouter.post("/api/signUp", async (req, res) => {
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

        const token = jwt.sign({ id: user._id }, "passwordKey")
        res.json({ user, token })

    } catch (e) {
        console.log(error)
        res.status(500).json({ error: e.message })

    }
});

authRouter.get("/", auth, async (req, res) => {
    const user = await User.findOne({ _id: req.user });
    res.json({ user, token: req.token })
})

module.exports = authRouter;