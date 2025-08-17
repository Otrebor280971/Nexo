const ChildDevice = require("../models/ChildDevice");
const Device = require("../models/ChildDevice");

// Registrar un dispositivo
exports.registerDevice = async (req, res) => {
  try {
    const { code, parentId, alias } = req.body;
    const device = new Device({ code, parentId, alias });
    await device.save();
    res.status(201).json(device);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};


exports.searchDevice = async (req, res) => {
  try{
    const {code} = req.params;
    const device = await Device.findOne({code});

    if(!device){
      return res.status(404).json({error:"Device not found"});
    }

    res.status(200).json(device);
  }catch(error){
    res.status(500).json({error: error.message});
  }
};

exports.deleteDevice = async (req, res) => {
  try{
    const { code } = req.params;
    const device = await Device.findOneAndDelete({code});

    if (!device) {
      return res.status(404).json({ error: "Device not found" });
    }

    res.status(200).json({ message: "Device deleted successfully" });
  }catch(error){
    res.status(500).json({ error: error.message });
  }
};

exports.checkDevice = async (req, res) => {
  try {
    const { deviceId } = req.params;
    const device = await ChildDevice.findOne({ deviceId: deviceId});
    if (device) {
      return res.status(200).json({ isRegistered: true });
    } else {
      return res.status(200).json({ isRegistered: false });
    }
  } catch (error) {
    console.error("Error al verificar el dispositivo:", error);
    res.status(500).json({ message: "Error interno del servidor"});
  }
};

// Obtener dispositivos de un usuario
// exports.getDevicesByUser = async (req, res) => {
//   try {
//     const { parentId } = req.params;
//     const devices = await Device.find({ parentId });
//     res.json(devices);
//   } catch (error) {
//     res.status(500).json({ error: error.message });
//   }
// };
