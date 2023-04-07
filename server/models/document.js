const mongoose = require("mongoose");

const documentSchema = mongoose.Schema({
    uid: {
        type: String,
        require: true,
    },

    createAt: {
        type: Number,
        require: true
    },
    title: {
        type: String,
        require: true,
        trim: true,
    },
    content: {
        type: Array,
        default: [],
    }

});

const Document = mongoose.model("Document", documentSchema);
module.exports = Document;

