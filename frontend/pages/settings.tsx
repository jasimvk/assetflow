import React, { useState } from 'react';
import Layout from '../components/Layout';
import { 
  Settings as SettingsIcon, 
  User, 
  Bell, 
  Shield, 
  Database, 
  Mail, 
  Globe,
  Lock,
  Palette,
  Save,
  Eye,
  EyeOff
} from 'lucide-react';

const Settings = () => {
  const [activeTab, setActiveTab] = useState<'profile' | 'notifications' | 'security' | 'system'>('profile');
  const [showPassword, setShowPassword] = useState(false);

  const tabs = [
    { id: 'profile', label: 'Profile', icon: User },
    { id: 'notifications', label: 'Notifications', icon: Bell },
    { id: 'security', label: 'Security', icon: Shield },
    { id: 'system', label: 'System', icon: Database },
  ];

  return (
    <Layout title="Settings">
      {/* Page Header */}
      <div className="mb-5">
        <h1 className="text-3xl font-bold bg-gradient-to-r from-gray-900 via-gray-800 to-gray-700 bg-clip-text text-transparent mb-2">
          Settings
        </h1>
        <div className="flex items-center space-x-2 text-sm text-gray-500">
          <span>Home</span>
          <span>•</span>
          <span>Settings</span>
          <span>•</span>
          <span>{new Date().toLocaleDateString()}</span>
        </div>
      </div>

      <div className="grid grid-cols-12 gap-6">
        {/* Tabs Sidebar */}
        <div className="col-span-12 lg:col-span-3">
          <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-4 shadow-sm sticky top-24">
            <nav className="space-y-2">
              {tabs.map((tab) => (
                <button
                  key={tab.id}
                  onClick={() => setActiveTab(tab.id as any)}
                  className={`w-full flex items-center gap-3 px-4 py-3 rounded-2xl font-semibold text-sm transition-all duration-200 ${
                    activeTab === tab.id
                      ? 'bg-primary-500 text-white shadow-md'
                      : 'text-gray-600 hover:bg-gray-100'
                  }`}
                >
                  <tab.icon className="h-5 w-5" />
                  {tab.label}
                </button>
              ))}
            </nav>
          </div>
        </div>

        {/* Content Area */}
        <div className="col-span-12 lg:col-span-9">
          {/* Profile Settings */}
          {activeTab === 'profile' && (
            <div className="space-y-6">
              <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-8 shadow-sm">
                <h2 className="text-xl font-bold text-gray-900 mb-6">Profile Information</h2>
                
                {/* Avatar */}
                <div className="flex items-center gap-6 mb-8">
                  <div className="w-24 h-24 bg-gradient-to-br from-primary-500 to-primary-700 rounded-3xl flex items-center justify-center text-white text-2xl font-bold">
                    DU
                  </div>
                  <div>
                    <button className="px-6 py-2 bg-primary-500 text-white rounded-xl font-semibold text-sm hover:bg-primary-600 transition-colors mb-2">
                      Upload New Photo
                    </button>
                    <p className="text-sm text-gray-500">JPG, PNG or GIF. Max size 2MB</p>
                  </div>
                </div>

                {/* Form */}
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div>
                    <label className="block text-sm font-semibold text-gray-700 mb-2">Full Name</label>
                    <input
                      type="text"
                      defaultValue="Development User"
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-semibold text-gray-700 mb-2">Email Address</label>
                    <input
                      type="email"
                      defaultValue="dev@example.com"
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-semibold text-gray-700 mb-2">Phone Number</label>
                    <input
                      type="tel"
                      defaultValue="+1 (555) 123-4567"
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-semibold text-gray-700 mb-2">Department</label>
                    <select className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent">
                      <option>IT</option>
                      <option>HR</option>
                      <option>Finance</option>
                      <option>Operations</option>
                    </select>
                  </div>
                </div>

                <div className="mt-6 flex justify-end">
                  <button className="flex items-center gap-2 px-6 py-3 bg-primary-500 text-white rounded-xl font-semibold hover:bg-primary-600 transition-colors">
                    <Save className="h-5 w-5" />
                    Save Changes
                  </button>
                </div>
              </div>
            </div>
          )}

          {/* Notifications Settings */}
          {activeTab === 'notifications' && (
            <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-8 shadow-sm">
              <h2 className="text-xl font-bold text-gray-900 mb-6">Notification Preferences</h2>
              
              <div className="space-y-6">
                {[
                  { label: 'Email Notifications', description: 'Receive email notifications for important updates' },
                  { label: 'Push Notifications', description: 'Receive push notifications on your device' },
                  { label: 'Asset Updates', description: 'Get notified when assets are updated' },
                  { label: 'Approval Requests', description: 'Notifications for new approval requests' },
                  { label: 'System Alerts', description: 'Important system and security alerts' },
                ].map((item, index) => (
                  <div key={index} className="flex items-center justify-between p-4 bg-gray-50 rounded-2xl">
                    <div>
                      <p className="font-semibold text-gray-900">{item.label}</p>
                      <p className="text-sm text-gray-600">{item.description}</p>
                    </div>
                    <label className="relative inline-flex items-center cursor-pointer">
                      <input type="checkbox" defaultChecked className="sr-only peer" />
                      <div className="w-14 h-7 bg-gray-300 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-primary-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-0.5 after:left-[4px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-6 after:w-6 after:transition-all peer-checked:bg-primary-500"></div>
                    </label>
                  </div>
                ))}
              </div>

              <div className="mt-6 flex justify-end">
                <button className="flex items-center gap-2 px-6 py-3 bg-primary-500 text-white rounded-xl font-semibold hover:bg-primary-600 transition-colors">
                  <Save className="h-5 w-5" />
                  Save Preferences
                </button>
              </div>
            </div>
          )}

          {/* Security Settings */}
          {activeTab === 'security' && (
            <div className="space-y-6">
              <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-8 shadow-sm">
                <h2 className="text-xl font-bold text-gray-900 mb-6">Change Password</h2>
                
                <div className="space-y-4">
                  <div>
                    <label className="block text-sm font-semibold text-gray-700 mb-2">Current Password</label>
                    <div className="relative">
                      <input
                        type={showPassword ? 'text' : 'password'}
                        className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent pr-12"
                      />
                      <button
                        onClick={() => setShowPassword(!showPassword)}
                        className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                      >
                        {showPassword ? <EyeOff className="h-5 w-5" /> : <Eye className="h-5 w-5" />}
                      </button>
                    </div>
                  </div>
                  <div>
                    <label className="block text-sm font-semibold text-gray-700 mb-2">New Password</label>
                    <input
                      type="password"
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-semibold text-gray-700 mb-2">Confirm New Password</label>
                    <input
                      type="password"
                      className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                    />
                  </div>
                </div>

                <div className="mt-6 flex justify-end">
                  <button className="flex items-center gap-2 px-6 py-3 bg-primary-500 text-white rounded-xl font-semibold hover:bg-primary-600 transition-colors">
                    <Lock className="h-5 w-5" />
                    Update Password
                  </button>
                </div>
              </div>

              <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-8 shadow-sm">
                <h2 className="text-xl font-bold text-gray-900 mb-6">Two-Factor Authentication</h2>
                <p className="text-gray-600 mb-6">Add an extra layer of security to your account</p>
                
                <button className="px-6 py-3 bg-green-500 text-white rounded-xl font-semibold hover:bg-green-600 transition-colors">
                  Enable 2FA
                </button>
              </div>
            </div>
          )}

          {/* System Settings */}
          {activeTab === 'system' && (
            <div className="space-y-6">
              <div className="bg-white/70 backdrop-blur-sm border border-gray-200/60 rounded-3xl p-8 shadow-sm">
                <h2 className="text-xl font-bold text-gray-900 mb-6">System Configuration</h2>
                
                <div className="space-y-6">
                  <div>
                    <label className="block text-sm font-semibold text-gray-700 mb-2">
                      <Globe className="inline h-5 w-5 mr-2" />
                      Language
                    </label>
                    <select className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent">
                      <option>English</option>
                      <option>Spanish</option>
                      <option>French</option>
                      <option>German</option>
                    </select>
                  </div>

                  <div>
                    <label className="block text-sm font-semibold text-gray-700 mb-2">
                      <Palette className="inline h-5 w-5 mr-2" />
                      Theme
                    </label>
                    <div className="grid grid-cols-3 gap-4">
                      {['Light', 'Dark', 'Auto'].map((theme) => (
                        <button
                          key={theme}
                          className="p-4 border-2 border-gray-300 rounded-xl hover:border-primary-500 transition-colors"
                        >
                          <p className="font-semibold text-gray-900">{theme}</p>
                        </button>
                      ))}
                    </div>
                  </div>

                  <div>
                    <label className="block text-sm font-semibold text-gray-700 mb-2">
                      <Database className="inline h-5 w-5 mr-2" />
                      Data Backup
                    </label>
                    <div className="flex items-center gap-4">
                      <button className="px-6 py-3 bg-primary-500 text-white rounded-xl font-semibold hover:bg-primary-600 transition-colors">
                        Backup Now
                      </button>
                      <span className="text-sm text-gray-600">Last backup: Oct 6, 2025</span>
                    </div>
                  </div>
                </div>

                <div className="mt-6 flex justify-end">
                  <button className="flex items-center gap-2 px-6 py-3 bg-primary-500 text-white rounded-xl font-semibold hover:bg-primary-600 transition-colors">
                    <Save className="h-5 w-5" />
                    Save Settings
                  </button>
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </Layout>
  );
};

export default Settings;
