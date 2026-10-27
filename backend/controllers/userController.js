const userSchema = require("../models/userSchema");
const Meal = require("../models/mealSchema");
const Workout = require("../models/workoutSchema");
const Progression = require("../models/progressionSchema");
const Goal = require("../models/goalSchema");
const bcrypt = require("bcryptjs");
const jwt = require('jsonwebtoken');
const express = require('express');
const app = express();
app.use(express.json());
const mongoose = require('mongoose');
const User = require("../models/userSchema");
const Conseil = require('../models/conseilSchema');
const Notification = require('../models/NotificationSchema');
const transporter = require('../middlewares/mailer');



module.exports.addUserAdherent = async (req, res) => {
  try {
    const { firstname, lastname, email, password, age } = req.body;
    const role = "adherent";

  
    const passwordRegex = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
    if (!passwordRegex.test(password)) {
      return res.status(400).json("The password must contain at least 8 characters, one uppercase letter, one lowercase letter, one number and one special character.");
    }

   
    const existingUser = await userSchema.findOne({ email });
    if (existingUser) {
      return res.status(400).json("Cet email est déjà utilisé");
    }

    const user = await userSchema.create({ firstname, lastname, email, password, role, age });
   
    res.status(201).json({
      firstname: user.firstname,
      lastname: user.lastname,
      email: user.email,
      role: user.role,
      _id: user._id,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt
    });

  } catch (error) {
    console.error(error);
    res.status(500).json("Erreur serveur");
  }
};


module.exports.addUserAdmin = async (req, res) => {
  try {
    const { firstname, lastname, email, password, age } = req.body;
    const role = "admin";
    const user = await userSchema.create({ firstname, lastname, email, password, role: role, age });
    res.status(200).json({ user });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports.getAllUsers = async (req, res) => {
  try {
    const users = await userSchema.find();
    res.status(200).json(users);

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports.getUserById = async (req, res) => {
  try {
    const id = req.params.id;
    const user = await userSchema.findById(id);
    res.status(200).json(user);

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports.deleteUserById = async (req, res) => {
  try {
    const id = req.params.id;
    const checkifExist = await userSchema.findById(id);
    if (!checkifExist) {
      res.status(404).json({ message: "user not found" });
    }
    const user = await userSchema.findByIdAndDelete(id);
    res.status(200).json(user);

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports.addUserAdherentWithImg = async (req, res) => {
  try {
    const { firstname, lastname, email, password } = req.body;
    const role = "adherent";
    const { file_name } = req.file;
    const user = await userSchema.create({ firstname, lastname, email, password, role: role, user_image: file_name });
    res.status(200).json({ user });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports.upDateAdherent = async (req, res) => {
  try {
    const id = req.params.id;
    res.status(200).json(esmFonction);

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.updateUserById = async (req, res) => {
  try {
    const id = req.params.id;
    const updates = req.body;
  
    const user = await userSchema.findById(id);
    if (!user) {
      return res.status(404).json({ message: "Utilisateur introuvable" });
    }

    if (updates.email && updates.email !== user.email) {
      const existingUser = await userSchema.findOne({ email: updates.email });
      if (existingUser) {
        return res.status(400).json({ message: "Cet email est déjà utilisé" });
      }
    }

    const updatedUser = await userSchema.findByIdAndUpdate(id, updates, { new: true, runValidators: true });

    res.status(200).json({ message: "Utilisateur mis à jour avec succès", user: updatedUser });
  } catch (error) {
    console.error("Erreur lors de la mise à jour :", error);
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

module.exports.searchByUserName = async (req, res) => {
  try {
    const { firstname } = req.body;

    if (!firstname) {
      return res.status(400).json({ message: "firstname is required" });
    }

    const users = await userSchema.find({ firstname: { $regex: firstname, $options: 'i' } });

    if (users.length === 0) {
      return res.status(404).json({ message: "user not found" });
    }

    res.status(200).json({ count: users.length, users });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports.getAllUsersByAge = async (req, res) => {
  try {
    const users = await userSchema.find().sort({ age: 1 });
    res.status(200).json(users);

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports.addProfileInformation = async (req, res) => {
  try {
    const { email, gender, age, weight, height } = req.body;

    const user = await userSchema.findOneAndUpdate(
      { email },
      { $set: { gender, age, weight, height } }, 
      { new: true, runValidators: true }
    );

    if (!user) {
      return res.status(404).json({ message: "Utilisateur non trouvé" });
    }

    res.status(200).json({ message: "Informations mises à jour avec succès", user });

  } catch (error) {
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};

module.exports.handleGoogleSignIn = async (req, res) => {
  try {
    const { uid, email, firstName, lastName } = req.body;

    let user = await userSchema.findOne({ email });
    if (!user) {
      user = new userSchema({
        uid,
        email,
        firstname: firstName,
        lastname: lastName,
        password: "", 
      });
      await user.save();
    }

    res.status(200).json({ message: "Connexion Google réussie", user });
  } catch (error) {
    console.error("Erreur Google Sign-In :", error);
    res.status(500).json({ message: "Erreur serveur" });
  }
};

module.exports.addMeal = async (req, res) => {
  const { userId, mealType, mealName, date, time, imagePath, nutrition = {} } = req.body;
  console.log("Received mealnpm run dev data:", req.body);
  if (!userId || !mealType || !mealName || !date || !time || !imagePath || !nutrition) {
    return res.status(400).json({ message: 'Missing fields' });
  }

  try {
    
    const user = await userSchema.findById(userId);
    if (!user) return res.status(404).json({ message: 'User not found' });

    const cleanedNutrition = {
      Calories: String(nutrition?.Calories || '0').replace(/[^\d]/g, ''),
      Fats: String(nutrition?.Fats || '0').replace(/[^\d]/g, ''),
      Proteins: String(nutrition?.Proteins || '0').replace(/[^\d]/g, ''),
      Carbs: String(nutrition?.Carbs || '0').replace(/[^\d]/g, '')
    };
    
    const newMeal = new Meal({
      userId,
      mealType,
      mealName,
      date,
      time,
      imagePath,
      nutrition: cleanedNutrition,
    });

    await newMeal.save();

    res.status(200).json({ message: 'Meal added successfully', meal: newMeal });
  } catch (error) {
    console.error('Add Meal Error:', error);
    res.status(500).json({ message: 'Internal server error' });
  }

}

module.exports.todayMeal = async (req, res) => {
  try {
    const { userId, mealType } = req.body;

    if (!userId || !mealType) {
      return res.status(400).json({ message: "userId and mealType are requeired" });
    }

   
    const today = new Date().toISOString().split('T')[0];
   
    const allMeals = await Meal.find({
      userId: userId,
      mealType: { $regex: mealType, $options: 'i' },
      imagePath: { $exists: true }
    });

    const todayMeals = allMeals.filter(meal => {
      const mealDate = new Date(meal.date).toISOString().split('T')[0];
      return mealDate === today;
    });

    if (todayMeals.length === 0) {
      return res.status(404).json({ message: "No meals found for today" });
    }

    res.status(200).json({ count: todayMeals.length, meals: todayMeals });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

//////////////// for admin //////////////////////
exports.addMealByAdmin = async (req, res) => {
  console.log('Received :', req.body);

  try {
    const meal = new Meal(req.body);
    await meal.save();
    res.status(201).json(meal);
  } catch (err) {
    console.error("Error adding :", err);
    res.status(400).json({ error: err.message });
  }
};

// Update Meal////
exports.updateMealByAdmin = async (req, res) => {
  console.log('Received :', req.body);
  try {
    const meal = await Meal.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(meal);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Delete Meal////
exports.deleteMealByAdmin = async (req, res) => {
  try {
    await Meal.findByIdAndDelete(req.params.id);
    res.json({ message: 'Meal deleted' });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }

};

//  Get All Meals////
exports.getAllMealsByAdmin = async (req, res) => {
  try {
    const meals = await Meal.find();
    res.json(meals);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.getMealsByType = async (req, res) => {
  try {
    
    const { mealType } = req.query;
 
    if (!mealType) {
      return res.status(400).json({ error: "The mealType parameter is required" });
    }

    const meals = await Meal.find({
      mealType,
      role: 'admin'
    });
    res.json(meals);
    console.log("Meals successfully collected :", meals);
  } catch (err) {
    console.error("Error getMealsByType :", err);
    res.status(500).json({ error: "Server error when retrieving meals" });
  }
};

// Ajouter un nouvel exercice ///
exports.addExercise = async (req, res) => {
  try {
    const {
      userId,
      image,
      nameOfExercise,
      info,
      description,
      nameOfWorkout,
      selectedDifficulty,
      burnedCalories,
      date,
      time,
    } = req.body;

    if (
      !userId || !image || !nameOfExercise || !info || !date || !time ||
      !description || !nameOfWorkout || !selectedDifficulty ||
      burnedCalories === undefined
    ) {
      return res.status(400).json({ message: 'All fields are required' });
    }

    const newWorkout = new Workout({
      userId,
      image,
      nameOfExercise,
      info,
      description,
      nameOfWorkout,
      selectedDifficulty,
      burnedCalories,
      date,
      time,
    });

    await newWorkout.save();

    res.status(200).json({ message: 'Exercise added successfully', workout: newWorkout });
  } catch (error) {
    console.error('Error adding exercise:', error);
    res.status(500).json({ message: 'Server Error' });
  }
};

exports.getWorkoutsByType = async (req, res) => {
  const { userId, type } = req.params;

  try {
    const workouts = await Workout.find({ userId, nameOfWorkout: type });

    if (!workouts.length) {
      return res.status(404).json({ message: 'No workouts found for this user and type' });
    }

    res.json({ workouts });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};


exports.deletedWorkout = async (req, res) => {
  const { id } = req.params;

  try {
    const deletedWorkout = await Workout.findByIdAndDelete(id);

    if (!deletedWorkout) {
      return res.status(404).json({ message: 'Workout not found' });
    }

    res.status(200).json({ message: 'Workout successfully deleted' });
  } catch (error) {
    console.error('Error while deleting:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

//notifications//////

exports.postfornotifications = async (req, res) => {
  const { userId, fcmToken } = req.body;
  const today = new Date().toISOString().split('T')[0]; 

  try {
    const workout = await Workout.findOne({ userId, date: today });

    if (workout) {
      const title = "Today's training";
      const body = `you have "${workout.nameOfExercise}" today at ${workout.time}`;

      const message = {
        notification: { title, body },
        token: fcmToken,
      };

      await admin.messaging().send(message);


      const savedNotif = await Notification.create({ userId, title, body });
      console.log('Notification saved:', savedNotif);


      return res.status(200).send('Notification sent and saved');
    }

    res.status(200).send('No exercise today');
  } catch (error) {
    console.error(error);
    res.status(500).send('Server error');
  }
};

exports.getNotifications = async (req, res) => {
  const { userId } = req.params;

  try {
    if (!mongoose.Types.ObjectId.isValid(userId)) {
      console.error('Invalid userId in getNotifications:', userId);
      return res.status(400).json({ error: 'Invalid userId' });
    }

    const notifications = await Notification.find({ userId }).sort({ date: -1 });
    console.log('Notifications fetched:', notifications);
    res.status(200).json(notifications);
  } catch (error) {
    console.error('Error in getNotifications:', error);
    res.status(500).json({ error: 'Server error: ' + error.message });
  }
};

///////////// GOAL CONTROLLER //

exports.calculate_goal = async (req, res) => {
  try {
    const { userId, goal } = req.body;
    console.log("Received goal data:", req.body);
    const user = await userSchema.findOne({ _id: userId });
    if (!user) return res.status(404).json({ error: 'User not found' });

    const weight = user.weight;
    const height = user.height / 100;
    const imc = weight / (height * height);

    let targetWeight;
    let message = '';

    if (goal === 'lose weight') {
      targetWeight = Math.round(24.9 * (height * height));
      const toLose = weight - targetWeight;
      message = `For a normal BMI (24.9), you need to lose about ${toLose.toFixed(1)} kg.`;
    } else if (goal === 'gain weight') {
      targetWeight = Math.round(22 * (height * height));
      const toGain = targetWeight - weight;
      message = `For a normal BMI (22), you should gain approximately ${toGain.toFixed(1)} kg.`;
    } else if (goal === 'build muscle') {
      targetWeight = Math.round(weight * 1.1);
      const toGain = targetWeight - weight;
      message = `To build muscle, you can aim for around${targetWeight.toFixed(1)} kg, either +${toGain.toFixed(1)} kg.`;
    }

    const newGoal = new Goal({
      userId,
      goal,
      targetWeight,
      initialWeight: weight,
      imc,
    });

    await newGoal.save();

    res.json({ imc: imc.toFixed(1), message, goal });
  } catch (err) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
};


exports.getGoalByUserId = async (req, res) => {
  const { userId } = req.params;
  console.log("Received userId:", userId); 
  try {
    const goalEntry = await Goal.findOne({ userId });
    
    if (!goalEntry) {
      return res.status(404).json({ message: 'Goal not found' });
    }
    
    if (!goalEntry.goal) {
      return res.status(400).json({ message: 'Goal data is missing' });
    }

    res.json({ goal: goalEntry.goal });
  } catch (error) {
   
    console.error(error);  
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};


exports.addGoogleUser = async (req, res) => {
  const { uid, email, name, firstName, lastName } = req.body;

  try {
    console.log("userId", uid);
    let user = await userSchema.findOne({ userId: uid });

    if (!user) {
      user = new userSchema({
        firstname: firstName,
        lastname: lastName,
        userId: uid,
        email,
        name,
        role: 'adherent'
      });
      await user.save();
    }

    res.status(200).json({ message: "Google user successfully added", user });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.login_with_google = async (req, res) => {
  const { email } = req.body;
  try {

    console.log("email", email);
 
    let user = await userSchema.findOne({ email });

    if (user) {
      res.status(200).json({ email: user.email, userId: user._id });
    }
    else {
      res.status(500).json({ message: "User not found" });
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getAdherentById = async (req, res) => {
  try {
    const { id } = req.params;

    const user = await userSchema.findById(id);

    if (!user || user.role !== 'adherent') {
      return res.status(404).json({ message: 'Member not found' });
    }

    res.status(200).json({
      firstname: user.firstname,
      lastname: user.lastname,
      email: user.email,
      age: user.age,
      weight: user.weight,
      height: user.height,
      password: user.password,
      gender: user.gender,
    });
  } catch (error) {
    console.error('Error retrieving member:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

exports.update = async (req, res) => {
  const { id } = req.params;
  const { firstname, lastname, email, weight, height, age, goal } = req.body;

  const emailRegex = /^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$/;
  if (!emailRegex.test(email)) {
    return res.status(400).json({ error: 'Invalid email format' });
  }
  const validGoals = ['lose weight', 'gain weight', 'build muscle'];
  if (!validGoals.includes(goal)) {
    return res.status(400).json({ error: 'Invalid goal. Must be one of: lose weight, gain weight, build muscle' });
  }

  try {
    const existingUser = await userSchema.findOne({ email, _id: { $ne: id } });
    if (existingUser) {
      return res.status(409).json({ error: 'This email is already used' });
    }

    await userSchema.findByIdAndUpdate(id, {
      firstname,
      lastname,
      email,
      weight,
      height,
      age,
      goal,
    });

    const numericWeight = parseFloat(weight);
    const numericHeight = parseFloat(height);
    if (isNaN(numericWeight) || isNaN(numericHeight)) {
      return res.status(400).json({ error: 'Invalid weight or height format' });
    }

    const heightInMeters = numericHeight / 100;
    const imc = numericWeight / (heightInMeters * heightInMeters);

    let targetWeight = null;
    if (goal === 'lose weight') {
      targetWeight = 24.9 * (heightInMeters * heightInMeters);
    } else if (goal === 'gain weight') {
      targetWeight = 22 * (heightInMeters * heightInMeters);
    } else if (goal === 'build muscle') {
      targetWeight = numericWeight * 1.1;
    }

    const existingGoal = await Goal.findOne({ userId: id });
    if (existingGoal) {
      await Goal.findOneAndUpdate(
        { userId: id },
        { goal, imc, targetWeight }
      );
    } else {
      return res.status(404).json({ error: "No goals found for this user" });
    }

    res.status(200).json({ message: 'Profile updated successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to update profile' });
  }
};


exports.updatePassword = async (req, res) => {
  const { id } = req.params;
  const { oldPassword, newPassword } = req.body;

  if (newPassword.length < 8) {
    return res.status(400).json({ error: 'New password must be at least 8 characters' });
  }

  try {
    const user = await userSchema.findById(id).select('+password'); 
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const isMatch = await bcrypt.compare(oldPassword, user.password);
    if (!isMatch) {
      return res.status(400).json({ error: 'Old password is incorrect' });
    }

    const passwordRegex = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
    if (!passwordRegex.test(newPassword)) {
      return res.status(400).json("The password must contain at least 8 characters, one uppercase letter, one lowercase letter, one number and one special character.");
    }

    user.password = newPassword;
    await user.save();

    res.status(200).json({ message: 'Password updated successfully' });
  } catch (error) {
    console.error('Password update error:', error); 
    res.status(500).json({ error: 'Failed to update password' });
  }
};
exports.deleteAdherent = async (req, res) => {
  const { id } = req.params;
  try {
    const user = await userSchema.findByIdAndDelete(id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.status(200).json({ message: 'User deleted successfully' });
  } catch (error) {
    console.error('Delete user error:', error);
    res.status(500).json({ error: 'Failed to delete user' });
  }
};

exports.getGoal_targetWieght = async (req, res) => {
  const { userId } = req.params;
  try {
    const goalEntry = await Goal.findOne({ userId });
    if (!goalEntry) {
      return res.status(404).json({ message: 'Goal not found' });
    }
    if (!goalEntry.goal) {
      return res.status(400).json({ message: 'Goal data is missing' });
    }
    res.status(200).json({
      goal: goalEntry.goal,
      targetWeight: goalEntry.targetWeight,
      initialWeight: goalEntry.initialWeight, 
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

exports.addProgression = async (req, res) => {
  const { userId, targetWeight, initialWeight, currentWeight, weightDifference } = req.body;

  try {
 
    if (!mongoose.Types.ObjectId.isValid(userId)) {
      return res.status(400).json({ error: "ID utilisateur invalide" });
    }
    
    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ error: "Utilisateur non trouvé" });

    const progression = new Progression({
      userId,
      targetWeight,
      initialWeight,
      currentWeight,
      weightDifference,
    });

    await progression.save();
    await User.findByIdAndUpdate(userId, { weight: currentWeight });

    const goal = await Goal.findOne({ userId });
    if (goal) {
      const height = user.height / 100;
      const imc = currentWeight / (height * height);

      let newTargetWeight;
      let message = '';

      if (goal.goal === 'lose weight') { 
        newTargetWeight = 24.9 * (height * height);
        const toLose = currentWeight - newTargetWeight;
        message = `Pour un IMC normal (24.9), vous devez perdre environ ${toLose.toFixed(1)} kg.`;
      } else if (goal.goal === 'gain weight') {
        newTargetWeight = 22 * (height * height);
        const toGain = newTargetWeight - currentWeight;
        message = `Pour un IMC normal (22), vous devez prendre environ ${toGain.toFixed(1)} kg.`;
      } else if (goal.goal === 'build muscle') {
        newTargetWeight = null;
        message = `Votre IMC est ${imc.toFixed(1)}. Concentrez-vous sur un excédent calorique contrôlé et l'entraînement.`;
      }

  
      const updatedGoal = await Goal.findByIdAndUpdate(
        goal._id, 
        {
          imc: imc,
          targetWeight: newTargetWeight,
          initialWeight: initialWeight,
          currentWeight: currentWeight
        },
        { new: true, runValidators: true } 
      );

      if (!updatedGoal) {
        return res.status(500).json({ error: "Erreur lors de la mise à jour de l'objectif" });
      }
    }

    res.status(200).json({
      message: "Progression enregistrée, poids et objectif mis à jour avec succès",
      progression,
    });

  } catch (err) {
    console.error("Erreur dans addProgressionById :", err);
    res.status(500).json({ error: err.message });
  }
};


exports.getGoal_tW_imc_ByUserId = async (req, res) => {
  const { userId } = req.params;

  try {
   
    if (!userId) {
      return res.status(400).json({ message: "userId is required" });
    }
    const goal = await Goal.findOne({ userId });

    if (!goal) {
      return res.status(404).json({ message: "Goal not found for this user" });
    }

    const responseData = {
      goal: goal.goal,
      targetWeight: goal.targetWeight,
      imc: goal.imc,
    };

    res.status(200).json(responseData);
  } catch (error) {
    console.error("Error retrieving goal:", error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

exports.getAdherent_Fn_Ln_ById = async (req, res) => {
  try {
    const { id } = req.params;

    const user = await userSchema.findById(id);

    if (!user || user.role !== 'adherent') {
      return res.status(404).json({ message: 'Adhérent non trouvé' });
    }

    res.status(200).json({
      firstname: user.firstname,
      lastname: user.lastname,
    });
  } catch (error) {
    console.error('Erreur lors de la récupération de l’adhérent:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};

exports.getTodayNutrition = async (req, res) => {
  try {
    const { userId } = req.params;

    const today = new Date().toISOString().split('T')[0];

    const meals = await Meal.find({ userId: userId, date: today });

    let totalCalories = 0;
    let totalFats = 0;
    let totalCarbs = 0;
    let totalProteins = 0;

    meals.forEach(meal => {
      const nutrition = meal.nutrition;
      totalCalories += parseFloat(nutrition.Calories || 0);
      totalFats += parseFloat(nutrition.Fats || 0);
      totalCarbs += parseFloat(nutrition.Carbs || 0);
      totalProteins += parseFloat(nutrition.Proteins || 0);
    });

    res.json({
      date: today,
      userId,
      totalCalories,
      totalFats,
      totalCarbs,
      totalProteins
    });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

exports.getAdherentDetails = async (req, res) => {
  try {
    const { userId } = req.params;

    const user = await userSchema.findById(userId);

    if (!user || user.role !== 'adherent') {
      return res.status(404).json({ message: 'Adhérent non trouvé' });
    }

    res.status(200).json({
      weight: user.weight,
      height: user.height,
    });
  } catch (error) {
    console.error('Erreur lors de la récupération de l’adhérent:', error);
    res.status(500).json({ message: 'Erreur serveur' });
  }
};
exports.updateGoal = async (req, res) => {
  const { userId } = req.params;
  const { goal, targetWeight } = req.body;

  try {
    if (!userId || !goal) {
      return res.status(400).json({ message: "userId and goal are required" });
    }

    const updatedGoal = await Goal.findOneAndUpdate(
      { userId },
      { goal, targetWeight },
      { new: true }
    );

    if (!updatedGoal) {
      return res.status(404).json({ message: "Goal not found for this user" });
    }

    res.status(200).json(updatedGoal);
  } catch (error) {
    console.error("Error updating goal:", error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
};


exports.getAdvice = async (req, res) => {
  const { goal } = req.body;

  try {
    const conseils = await Conseil.find({ goal });
    if (conseils.length === 0) {
      return res.status(404).json({ message: 'No tips found for this lens.' });
    }

  
    const adviceList = conseils
      .flatMap(c => c.advice || []) 
      .filter(advice => typeof advice === 'string' && advice.trim() !== ''); 

    if (adviceList.length === 0) {
      return res.status(404).json({ message: 'No valid advice found.' });
    }

    res.status(200).json({ advice: adviceList });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

exports.todayExercice = async (req, res) => {
  const { userId } = req.body;
  const todayDate = new Date();
  const today = todayDate.toISOString().split('T')[0]; 

  try {
    if (!mongoose.Types.ObjectId.isValid(userId)) {
      return res.status(400).json({ error: 'Invalid userId' });
    }

    const workouts = await Workout.find({ userId, date: today });

    if (workouts.length === 0) {
      return res.status(404).json({ message: 'No exercise planned for today' });
    }

    const notificationsSent = [];

    for (const workout of workouts) {
      const exerciseName = workout.nameOfExercise;
      const time = workout.time || ''; 

      const formattedDate = todayDate.toLocaleDateString('fr-FR');
      const title = 'Training Reminder';
      const body = `Exercise scheduled for${formattedDate} : ${exerciseName}${time ? ' at ' + time : ''}.`;

     
      const existing = await Notification.findOne({
        userId,
        title,
        body,
        date: {
          $gte: new Date(today + 'T00:00:00.000Z'),
          $lte: new Date(today + 'T23:59:59.999Z'),
        },
      });

      if (!existing) {
        const newNotif = await Notification.create({
          userId,
          title,
          body,
        });
        notificationsSent.push(newNotif);
      }
    }

    if (notificationsSent.length > 0) {
      return res.status(200).json({
        message: `${notificationsSent.length} notification(s) successfully registered.`,
        notifications: notificationsSent,
      });
    } else {
      return res.status(200).json({
        message: 'Notifications already recorded for all exercises.',
      });
    }

  } catch (error) {
    console.error('Error in todayExercise:', error);
    return res.status(500).json({ error: 'Server Error: ' + error.message });
  }
};
exports.deleteNotification = async (req, res) => {
  const { notificationId } = req.params;

  try {
    if (!mongoose.Types.ObjectId.isValid(notificationId)) {
      return res.status(400).json({ error: 'Invalid notification ID' });
    }

    const deleted = await Notification.findByIdAndDelete(notificationId);

    if (!deleted) {
      return res.status(404).json({ error: 'Notification not found' });
    }

    return res.status(200).json({ message: 'Notification supprimée avec succès.' });
  } catch (error) {
    console.error('Erreur lors de la suppression :', error);
    return res.status(500).json({ error: 'Erreur serveur : ' + error.message });
  }
};

exports.loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });

    if (!user) return res.status(400).json({ message: "Utilisateur non trouvé" });

    const isValid = await bcrypt.compare(password, user.password);
    if (!isValid) return res.status(400).json({ message: "Mot de passe incorrect" });

    const payload = {
      _id: user._id,
      firstname: user.firstname,
      email: user.email,
    };

    const token = jwt.sign(payload, process.env.JWT_SECRET, {
      expiresIn: process.env.JWT_EXPIRES_IN || '1d',
    });

    return res.status(200).json({
      message: "Connexion réussie",
      token,
      user_role: user.role,
    });
  } catch (err) {
    return res.status(500).json({ message: "Erreur serveur", error: err.message });
  }
};


// fonction li nabeth beha fil code bil mail //

exports.requestResetPassword = async (req, res) => {
  try {
    const { email } = req.body;
    const user = await User.findOne({ email });

    if (!user)
      return res.status(400).json({ message: "Aucun utilisateur avec cet email" });

    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    const otpExpiry = new Date(Date.now() + 15 * 60 * 1000); // 15 min

    user.resetOtp = otp;
    user.otpExpiry = otpExpiry;
    await user.save();

    const mailOptions = {
      from: `"Support Future Now" <${process.env.GMAIL_USER}>`,
      to: email,
      subject: ' Code de réinitialisation de mot de passe',
      html: `
        <div style="font-family: Arial, sans-serif; padding: 20px;">
          <h2>Bonjour ${user.firstname || ''},</h2>
          <p>Voici votre code OTP pour réinitialiser votre mot de passe :</p>
          <h1 style="background:#f3f3f3; padding: 10px; display:inline-block;">${otp}</h1>
          <p>Ce code est valable 15 minutes.</p>
          <p>Si vous n'avez pas demandé cette réinitialisation, vous pouvez ignorer cet e-mail.</p>
        </div>
      `,
    };

    await transporter.sendMail(mailOptions);

    return res.status(200).json({ message: "OTP envoyé par email" });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ message: "Erreur serveur", error: err.message });
  }
};

// fonction l tverify lcode OTP //

exports.verifyResetOtp = async (req, res) => {
  try {
    const { email, otp } = req.body;

    const user = await User.findOne({ email });
    if (!user)
      return res.status(400).json({ message: "Utilisateur non trouvé" });

    if (!user.resetOtp || user.resetOtp !== otp)
      return res.status(400).json({ message: "Code OTP incorrect" });

    if (user.otpExpiry < new Date())
      return res.status(400).json({ message: "Code OTP expiré" });

    user.otpVerified = true;
    await user.save();

    return res.status(200).json({ message: "OTP vérifié avec succès" });
  } catch (err) {
    return res.status(500).json({ message: "Erreur serveur", error: err.message });
  }
};

// l fonction l tbadel password  //

exports.resetPassword = async (req, res) => {
  try {
    const { email, newPassword } = req.body;

    const user = await User.findOne({ email });
    if (!user) return res.status(400).json({ message: "Utilisateur non trouvé" });

    if (!user.otpVerified) {
      return res.status(400).json({ message: "OTP non vérifié" });
    }

    user.password = newPassword; 
    user.resetOtp = null;
    user.otpExpiry = null;
    user.otpVerified = false;

    await user.save(); 

    return res.status(200).json({ message: "Mot de passe réinitialisé avec succès" });
  } catch (err) {
    console.error(" Erreur dans resetPassword:", err);
    return res.status(500).json({ message: "Erreur serveur", error: err.message });
  }
};

// fonction ta3 stat based on user goal //

exports.getNutritionStatsByUserId = async (req, res) => {
  try {
    const { id } = req.params;
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ error: "ID utilisateur invalide" });
    }

    const goal = await Goal.findOne({ userId: id }).lean();
    const meals = await Meal.find({ userId: id }).lean();

    const now = new Date();
    const todayStr = now.toISOString().split('T')[0];

    const isSameDay = (dateStr) => {
      if (!dateStr) return false;
      const d = new Date(dateStr).toISOString().split('T')[0];
      return d === todayStr;
    };

    const isSameWeek = (dateStr) => {
      const date = new Date(dateStr);
      const weekStart = new Date(now);
      weekStart.setDate(now.getDate() - now.getDay());
      const weekEnd = new Date(weekStart);
      weekEnd.setDate(weekStart.getDate() + 7);
      return date >= weekStart && date < weekEnd;
    };

    const isSameMonth = (dateStr) => {
      const date = new Date(dateStr);
      return date.getMonth() === now.getMonth() && date.getFullYear() === now.getFullYear();
    };

    const sumNutrition = (mealList) => {
      return mealList.reduce((totals, meal) => {
        if (!meal.nutrition) return totals;
        const n = meal.nutrition;
        totals.Proteins += parseFloat(n.Proteins || 0);
        totals.Fats += parseFloat(n.Fats || 0);
        totals.Carbs += parseFloat(n.Carbs || 0);
        return totals;
      }, { Proteins: 0, Fats: 0, Carbs: 0 });
    };

    const dailyMeals = meals.filter(m => isSameDay(m.date));
    const weeklyMeals = meals.filter(m => isSameWeek(m.date));
    const monthlyMeals = meals.filter(m => isSameMonth(m.date));

    const actualDaily = sumNutrition(dailyMeals);
    const actualWeekly = sumNutrition(weeklyMeals);
    const actualMonthly = sumNutrition(monthlyMeals);

    const weight = goal?.currentWeight || 70;

    let targets = { Proteins: 0, Fats: 0, Carbs: 0 };

    if (goal?.goal === 'gain weight') {
      targets.Proteins = weight * 1.6;
    } else if (goal?.goal === 'lose weight') {
      targets.Proteins = weight * 1.8;
    } else if (goal?.goal === 'build muscle') {
      targets.Proteins = weight * 2.0;
    }

    // Macros basées alee 2000 kcal/jour 
    const baseCalories = 2000;
    targets.Fats = (baseCalories * 0.25) / 9;
    targets.Carbs = (baseCalories * 0.50) / 4;

    res.status(200).json({
      goal: goal?.goal || "unknown",
      daily: {
        Proteins: { actual: actualDaily.Proteins, target: targets.Proteins },
        Fats: { actual: actualDaily.Fats, target: targets.Fats },
        Carbs: { actual: actualDaily.Carbs, target: targets.Carbs }
      },
      weekly: {
        Proteins: { actual: actualWeekly.Proteins, target: targets.Proteins * 7 },
        Fats: { actual: actualWeekly.Fats, target: targets.Fats * 7 },
        Carbs: { actual: actualWeekly.Carbs, target: targets.Carbs * 7 }
      },
      monthly: {
        Proteins: { actual: actualMonthly.Proteins, target: targets.Proteins * 30 },
        Fats: { actual: actualMonthly.Fats, target: targets.Fats * 30 },
        Carbs: { actual: actualMonthly.Carbs, target: targets.Carbs * 30 }
      }
    });
  } catch (err) {
    console.error(" Erreur getNutritionStats:", err);
    res.status(500).json({ error: "Erreur serveur", message: err.message });
  }
};

exports.getDashboardStats = async (req, res) => {
  try {
    const now = new Date();

    //  Utilisateurs inscrits sur les 7 derniers jours 
    const sevenDaysAgo = new Date(now);
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 6); 

    const weeklyUsers = await User.aggregate([
      {
        $match: {
          createdAt: { $gte: sevenDaysAgo }
        }
      },
      {
        $group: {
          _id: {
            $dateToString: { format: "%Y-%m-%d", date: "$createdAt" }
          },
          count: { $sum: 1 }
        }
      },
      { $sort: { _id: 1 } }
    ]);

    // Répartition par rôle
    const roles = await User.aggregate([
      {
        $group: {
          _id: "$role",
          value: { $sum: 1 }
        }
      }
    ]);

    // Croissance mensuelle 
    const lastYear = new Date(now);
    lastYear.setMonth(lastYear.getMonth() - 11);
    lastYear.setDate(1);

    const monthlyGrowth = await User.aggregate([
      {
        $match: {
          createdAt: { $gte: lastYear }
        }
      },
      {
        $group: {
          _id: {
            year: { $year: "$createdAt" },
            month: { $month: "$createdAt" }
          },
          growth: { $sum: 1 }
        }
      },
      { $sort: { "_id.year": 1, "_id.month": 1 } }
    ]);

    res.json({
      weeklyUsers: weeklyUsers.map(item => ({ date: item._id, users: item.count })),
      roles: roles.map(item => ({ name: item._id, value: item.value })),
      monthlyGrowth: monthlyGrowth.map(item => ({
        month: `${item._id.year}-${String(item._id.month).padStart(2, "0")}`,
        growth: item.growth
      }))
    });
  } catch (err) {
    console.error(" Erreur stats dashboard:", err);
    res.status(500).json({ error: 'Erreur chargement statistiques' });
  }
};
exports.getAllUsers = async (req, res) => {
  try {
    const users = await User.find({}, '-password');

    return res.status(200).json({
      message: "Liste des utilisateurs récupérée avec succès",
      users
    });
  } catch (err) {
    console.error(" Erreur dans getAllUsers:", err);
    return res.status(500).json({
      message: "Erreur serveur",
      error: err.message
    });
  }
};