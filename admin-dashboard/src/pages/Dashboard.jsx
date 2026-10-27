import React from 'react';
import { Routes, Route } from 'react-router-dom';
import Sidebar from '../components/Sidebar';
import DashboardStats from './DashboardStats';
import UsersList from './UsersList';
import AdvicesList from './AdvicesList';

export default function Dashboard() {
 return (
  <div style={{ display: 'flex', minHeight: '100vh' }}>
   <Sidebar />
   <div style={{ flex: 1, padding: '2rem' }}>
    <Routes>
     <Route path="dashboard-stats" element={<DashboardStats />} />
     <Route path="users" element={<UsersList />} />
     <Route path="advices" element={<AdvicesList />} />
     {/* Optional default route */}
     <Route path="*" element={<DashboardStats />} />
    </Routes>
   </div>
  </div>
 );
}
