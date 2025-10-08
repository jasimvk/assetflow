import React from 'react';
import Link from 'next/link';
import { useRouter } from 'next/router';
import { useAuth } from '../context/AuthContext';
import { 
  Home, 
  Package, 
  Settings, 
  Users, 
  Calendar, 
  BarChart3, 
  LogOut,
  Menu,
  Shield,
  Activity,
  UserPlus
} from 'lucide-react';

interface SidebarProps {
  isOpen: boolean;
  onClose: () => void;
}

const Sidebar: React.FC<SidebarProps> = ({ isOpen, onClose }) => {
  const router = useRouter();
  const { logout, user } = useAuth();

  const navigation = [
    { name: 'Dashboard', href: '/', icon: Home, color: 'text-blue-600', bgColor: 'bg-blue-100' },
    { name: 'Assets', href: '/assets', icon: Package, color: 'text-emerald-600', bgColor: 'bg-emerald-100' },
    { name: 'System Access', href: '/system-access', icon: UserPlus, color: 'text-orange-600', bgColor: 'bg-orange-100' },
    { name: 'Users', href: '/users', icon: Users, color: 'text-purple-600', bgColor: 'bg-purple-100' },
    { name: 'Reports', href: '/reports', icon: BarChart3, color: 'text-pink-600', bgColor: 'bg-pink-100' },
    { name: 'Settings', href: '/settings', icon: Settings, color: 'text-gray-600', bgColor: 'bg-gray-100' },
  ];

  const handleLogout = async () => {
    await logout();
    router.push('/login');
  };

  return (
    <>
      {/* Mobile overlay */}
      {isOpen && (
        <div 
          className="fixed inset-0 bg-black bg-opacity-50 z-40 lg:hidden"
          onClick={onClose}
        />
      )}
      
      {/* Sidebar */}
      <div className={`
        fixed inset-y-0 left-0 z-50 w-72 sidebar transform transition-all duration-300 ease-in-out
        lg:translate-x-0 lg:static lg:inset-0
        ${isOpen ? 'translate-x-0' : '-translate-x-full'}
      `}>
        <div className="flex items-center justify-between h-20 px-6 border-b border-white/20">
          <div className="flex items-center space-x-3">
            <div className="w-10 h-10 bg-gradient-to-br from-primary-500 to-primary-700 rounded-xl flex items-center justify-center shadow-lg">
              <Shield className="h-6 w-6 text-white" />
            </div>
            <div>
              <h1 className="text-xl font-black bg-gradient-to-r from-primary-600 to-primary-800 bg-clip-text text-transparent">
                AssetFlow
              </h1>
              <p className="text-xs text-gray-500 font-medium">Enterprise Management</p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="lg:hidden p-2 rounded-xl text-gray-400 hover:text-gray-600 hover:bg-white/50 transition-all duration-200"
          >
            <Menu className="h-5 w-5" />
          </button>
        </div>
        
        <nav className="mt-8 px-4">
          <div className="space-y-2">
            {navigation.map((item) => {
              const isActive = router.pathname === item.href;
              return (
                <Link
                  key={item.name}
                  href={item.href}
                  className={`
                    group flex items-center px-4 py-3 text-sm font-semibold rounded-2xl transition-all duration-300 transform hover:scale-105
                    ${isActive 
                      ? 'bg-gradient-to-r from-primary-500 to-primary-600 text-white shadow-lg shadow-primary-500/25' 
                      : 'text-gray-700 hover:bg-white/60 hover:text-gray-900 hover:shadow-lg'
                    }
                  `}
                  onClick={onClose}
                >
                  <div className={`
                    flex items-center justify-center w-8 h-8 rounded-xl mr-4 transition-all duration-300
                    ${isActive 
                      ? 'bg-white/20 text-white' 
                      : `${item.bgColor} ${item.color} shadow-sm`
                    }
                  `}>
                    <item.icon className="h-4 w-4" />
                  </div>
                  <span className="font-medium">{item.name}</span>
                  {isActive && (
                    <div className="ml-auto w-2 h-2 rounded-full bg-white animate-pulse"></div>
                  )}
                </Link>
              );
            })}
          </div>
          
          {/* Quick Stats */}
          {/* <div className="mt-8 p-4 bg-gradient-to-br from-white/20 to-white/10 backdrop-blur-sm rounded-2xl border border-white/20">
            <h3 className="text-sm font-semibold text-gray-700 mb-3">Quick Overview</h3>
            <div className="space-y-2">
              <div className="flex items-center justify-between">
                <span className="text-xs text-gray-600">Total Assets</span>
                <span className="text-sm font-bold text-primary-600">124</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-xs text-gray-600">Active Tasks</span>
                <span className="text-sm font-bold text-orange-600">8</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-xs text-gray-600">System Health</span>
                <div className="flex items-center">
                  <Activity className="h-3 w-3 text-green-500 mr-1" />
                  <span className="text-xs font-bold text-green-600">Good</span>
                </div>
              </div>
            </div>
          </div> */}
        </nav>
        
        {/* User info and logout */}
        <div className="absolute bottom-0 left-0 right-0 p-6 border-t border-white/20">
          <div className="bg-gradient-to-r from-white/20 to-white/10 backdrop-blur-sm rounded-2xl p-4 border border-white/20">
            <div className="flex items-center mb-4">
              <div className="flex-shrink-0">
                <div className="h-12 w-12 bg-gradient-to-br from-primary-500 to-primary-700 rounded-2xl flex items-center justify-center shadow-lg">
                  <span className="text-lg font-bold text-white">
                    {user?.name?.charAt(0) || 'U'}
                  </span>
                </div>
              </div>
              <div className="ml-4 flex-1">
                <p className="text-sm font-bold text-gray-800">{user?.name || 'Development User'}</p>
                <p className="text-xs text-gray-600">{user?.email || 'dev@example.com'}</p>
                <div className="flex items-center mt-1">
                  <div className="w-2 h-2 bg-green-400 rounded-full mr-2 animate-pulse"></div>
                  <span className="text-xs font-medium text-green-600">Online</span>
                </div>
              </div>
            </div>
            <button
              onClick={handleLogout}
              className="flex items-center w-full px-4 py-3 text-sm font-semibold text-gray-700 rounded-xl hover:bg-white/40 hover:text-gray-900 transition-all duration-300 group"
            >
              <div className="w-8 h-8 bg-red-100 rounded-xl flex items-center justify-center mr-3 group-hover:bg-red-200 transition-colors">
                <LogOut className="h-4 w-4 text-red-600" />
              </div>
              Sign out
            </button>
          </div>
        </div>
      </div>
    </>
  );
};

export default Sidebar;