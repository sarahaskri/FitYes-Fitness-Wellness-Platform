import React, { useEffect, useState } from 'react';
import './DashboardStats.css';
import axios from 'axios';

const API_URL = (import.meta.env.VITE_API_URL || 'http://localhost:5003').replace(/\/$/, '');
import {
 BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer,
 PieChart, Pie, Cell, Legend,
 LineChart, Line
} from 'recharts';

const COLORS = ['#0088FE', '#00C49F', '#FFBB28', '#FF8042'];

export default function DashboardStats() {
 const [weeklyUsers, setWeeklyUsers] = useState([]);
 const [roles, setRoles] = useState([]);
 const [monthlyGrowth, setMonthlyGrowth] = useState([]);

 useEffect(() => {
  axios.get(`${API_URL}/api/users/dashboard/stats`)
   .then(res => {
    setWeeklyUsers(res.data.weeklyUsers);
    setRoles(res.data.roles);
    setMonthlyGrowth(res.data.monthlyGrowth);
   })
   .catch(err => {
    console.error("Erreur de chargement des stats:", err);
   });
 }, []);

 return (
  <div className="section1">
   <h1 className="section-title">📊 App Statistics</h1>

   <div className="stats-grid">
    <div className="stat-card">
     <h2>{weeklyUsers.reduce((sum, item) => sum + item.users, 0)}</h2>
     <p className="stat-title">New Users</p>
     <p className="stat-desc">Last 7 days</p>
    </div>
    <div className="stat-card">
     <h2>{roles.reduce((sum, item) => sum + item.value, 0)}</h2>
     <p className="stat-title">Total Users</p>
     <p className="stat-desc">All roles</p>
    </div>
    <div className="stat-card">
     <h2>{monthlyGrowth.reduce((sum, item) => sum + item.growth, 0)}</h2>
     <p className="stat-title">Monthly Growth</p>
     <p className="stat-desc">Last 12 months</p>
    </div>
   </div>

   <div className="charts-section">
    <div className="chart-card">
     <h3>📆 Weekly New Users</h3>
     <ResponsiveContainer width="100%" height={250}>
      <BarChart data={weeklyUsers}>
       <CartesianGrid strokeDasharray="3 3" />
       <XAxis dataKey="date" />
       <YAxis />
       <Tooltip />
       <Bar dataKey="users" fill="#8884d8" />
      </BarChart>
     </ResponsiveContainer>
    </div>

    <div className="chart-card">
     <h3>👥 User Roles</h3>
     <ResponsiveContainer width="100%" height={250}>
      <PieChart>
       <Pie data={roles} dataKey="value" nameKey="name" label outerRadius={80}>
        {roles.map((entry, index) => (
         <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
        ))}
       </Pie>
       <Tooltip />
       <Legend />
      </PieChart>
     </ResponsiveContainer>
    </div>

    <div className="chart-card">
     <h3>📈 Monthly User Growth</h3>
     <ResponsiveContainer width="100%" height={250}>
      <LineChart data={monthlyGrowth}>
       <CartesianGrid strokeDasharray="3 3" />
       <XAxis dataKey="month" />
       <YAxis />
       <Tooltip />
       <Line type="monotone" dataKey="growth" stroke="#82ca9d" strokeWidth={2} />
      </LineChart>
     </ResponsiveContainer>
    </div>
   </div>
  </div>
 );
}


