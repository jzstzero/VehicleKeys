## 🔑 Vehicle Key System for ESX

A lightweight **vehicle locking and key system** for **FiveM (ESX)**.
Players can easily **lock and unlock** their owned or job vehicles using a single key press.

---

### ✨ Features

* 🔒 Lock & unlock vehicles with a realistic key fob animation
* 🚗 Ownership check directly from the database (`owned_vehicles`)
* 👮 Supports job vehicles defined in `config.lua`
* ⚙️ No dependency on TS_Framework or Discord roles
* 💬 Clean ESX notification messages
* 🧩 Fully optimized and standalone within the ESX ecosystem

---

### ⚙️ Installation

1. **Download or clone** this repository into your server’s `resources` folder.
2. Add the following line to your `server.cfg`:

   ```bash
   ensure vehiclekeys
   ```
3. Make sure you have **ESX** and **mysql-async** properly installed.
4. Configure your **job vehicles** inside `config.lua`:

   ```lua
   Config.JobVehicles = {
       ["police"] = {
           ["police"] = { grade = 0 },
       },
   }
   ```
5. Start your server and use the keybind or `/vehiclelock` command to lock/unlock your vehicle.

---

### 🎮 Usage

* Press your assigned key (configured in FiveM settings) or use `/vehiclelock`.
* If you own the vehicle (in `owned_vehicles`) or it matches your job vehicle list,
  you can **lock or unlock** it with a sound and animation.

---

### 🧠 Credits

Developed by **[YourNameHere]**
Open-source and free to use.
