const mongoose = require("mongoose");

const DeviceSchema = new mongoose.Schema({
  code: { type: String, required: true, unique: true }, 
  parentId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  alias: { type: String },
}, { timestamps: true });

module.exports = mongoose.model("childdevices", DeviceSchema);
