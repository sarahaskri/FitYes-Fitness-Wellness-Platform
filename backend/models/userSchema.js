const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const Meal = require('./mealSchema');

const userSchema = new mongoose.Schema({
    firstname: { type: String },
    lastname: { type: String },
    password: {
        type: String,
        required: false,
        minlength: 8,

    },
    email: {
        type: String,
        required: true,
        unique: true, 
        match: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
    },
    role: {
        type: String,
        enum: ["admin", "adherent"],
        required: true
    },
    gender: { type: String, enum: ["Male", "Female"] },
    age: { type: Number }, 
    height: { type: Number },
    weight: { type: Number },
    count: { type: Number, default: 1 } ,
    meals: [{  
      mealType: String,
      mealName: String,
      date: String,
      time: String
    }],
  //  champs zedthom lil otp //
  resetOtp: { type: String },
  otpExpiry: { type: Date },
  otpVerified: { type: Boolean, default: false },
},{ timestamps: true }); 

// Middleware pour hacher le mot de passe
userSchema.pre("save", async function (next) {
    if (!this.isModified("password")) return next();
    
    try {
      const salt = await bcrypt.genSalt(10);
      this.password = await bcrypt.hash(this.password, salt);
      
      // Trouver le dernier utilisateur besh nrecupuri el valeur ta3 el count
      const lastUser = await this.constructor.findOne().sort({ count: -1 });
  
    
      const newCount = lastUser ? lastUser.count + 1 : 1;
      this.count = newCount;
      next();
    } catch (error) {
      next(error);
    }
  });
  


const User = mongoose.model('User', userSchema);

User.syncIndexes();

module.exports = User;