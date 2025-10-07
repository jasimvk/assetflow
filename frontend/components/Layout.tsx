import React, { useState } from 'react';
import Sidebar from './Sidebar';
import { Menu, Bell, Search } from 'lucide-react';
import { useAuth } from '../context/AuthContext';

interface LayoutProps {
  children: React.ReactNode;
  title?: string;
}

const Layout: React.FC<LayoutProps> = ({ children, title = 'AssetFlow' }) => {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const { user } = useAuth();

  return (
    <div className="flex h-screen overflow-hidden bg-gradient-to-br from-gray-50 via-white to-blue-50">
      <Sidebar isOpen={sidebarOpen} onClose={() => setSidebarOpen(false)} />
      
      <div className="flex-1 flex flex-col overflow-hidden">
        {/* Top navigation */}
        <div className="flex-shrink-0 flex h-20 bg-white/80 backdrop-blur-lg shadow-sm border-b border-gray-200/60 z-10">
          <button
            type="button"
            className="px-6 border-r border-gray-200/60 text-gray-500 hover:text-gray-700 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-primary-500 lg:hidden transition-colors"
            onClick={() => setSidebarOpen(true)}
          >
            <Menu className="h-6 w-6" />
          </button>
          
          {/* Search bar */}
          <div className="flex-1 px-8 flex justify-between items-center">
            <div className="flex-1 flex max-w-2xl">
              <div className="w-full flex md:ml-0">
                <label htmlFor="search-field" className="sr-only">
                  Search
                </label>
                <div className="relative w-full">
                  <div className="absolute inset-y-0 left-0 flex items-center pointer-events-none pl-4">
                    <Search className="h-5 w-5 text-gray-400" />
                  </div>
                  <input
                    id="search-field"
                    className="block w-full pl-12 pr-4 py-3 bg-gray-50/80 border border-gray-200/60 rounded-2xl text-gray-900 placeholder-gray-500 focus:outline-none focus:bg-white focus:border-primary-300 focus:ring-2 focus:ring-primary-100 transition-all duration-200"
                    placeholder="Search assets, maintenance, users..."
                    type="search"
                    name="search"
                  />
                </div>
              </div>
            </div>
            
            {/* Notifications & Profile */}
            <div className="ml-6 flex items-center space-x-4">
              <button
                type="button"
                className="relative p-3 bg-gray-50/80 hover:bg-white border border-gray-200/60 rounded-2xl text-gray-500 hover:text-gray-700 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2 transition-all duration-200"
              >
                <Bell className="h-5 w-5" />
                <span className="absolute -top-1 -right-1 h-4 w-4 bg-red-500 rounded-full flex items-center justify-center">
                  <span className="text-xs font-bold text-white">3</span>
                </span>
              </button>
              
              {/* Profile dropdown placeholder */}
              <div className="relative">
                <div className="flex items-center space-x-3 bg-gray-50/80 hover:bg-white border border-gray-200/60 rounded-2xl px-4 py-2 transition-all duration-200">
                  <div className="h-10 w-10 bg-gradient-to-br from-primary-500 to-primary-700 rounded-2xl flex items-center justify-center shadow-sm">
                    <span className="text-sm font-bold text-white">
                      {user?.name?.charAt(0) || 'U'}
                    </span>
                  </div>
                  <div className="hidden md:block">
                    <p className="text-sm font-semibold text-gray-800">{user?.name || 'Development User'}</p>
                    <p className="text-xs text-gray-500">Administrator</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Main content */}
        <main className="flex-1 bg-transparent overflow-y-auto pt-6">
          <div className="max-w-7xl mx-auto px-8">
            {children}
          </div>
        </main>
      </div>
    </div>
  );
};

export default Layout;