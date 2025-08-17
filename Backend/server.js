require("dotenv").config();
const express = require("express");
const cors = require("cors");
const mongoose = require("mongoose");

const app = express();

// Middlewares
app.use(cors());
app.use(express.json());

// Conexión a DB
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log("Conectado a MongoDB Atlas"))
.catch((err) => console.error("Error de conexión a MongoDB:", err.message));

// Ruta prueba
app.get("/", (req, res) => res.send("API funcionando 🚀"));

// Rutas chingonas
const childDeviceRoutes = require("./routes/childDeviceRoutes");
app.use("/api/childDevices", childDeviceRoutes);

// Puerto
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
