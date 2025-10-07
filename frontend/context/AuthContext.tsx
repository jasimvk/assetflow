import { createContext, useContext, useEffect, useState } from 'react';

interface User {
  id: string;
  email: string;
  name: string;
  role: string;
}

interface AuthContextType {
  user: User | null;
  login: () => Promise<void>;
  logout: () => Promise<void>;
  isAuthenticated: boolean;
  loading: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider = ({ children }: { children: React.ReactNode }) => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Auto-authenticate for demo purposes (bypassing Azure AD)
    // Check for existing auth token or auto-login
    const token = localStorage.getItem('auth_token');
    if (!token) {
      // Auto-login for demo
      setUser({
        id: 'demo-user-123',
        email: 'demo@assetflow.com',
        name: 'Demo User',
        role: 'admin'
      });
      localStorage.setItem('auth_token', 'demo-token-123');
    } else {
      // Use existing token
      setUser({
        id: 'demo-user-123',
        email: 'demo@assetflow.com',
        name: 'Demo User',
        role: 'admin'
      });
    }
    setLoading(false);
  }, []);

  const login = async () => {
    try {
      // Auto-login for demo (bypassing Azure AD)
      const mockUser = {
        id: 'demo-user-123',
        email: 'demo@assetflow.com',
        name: 'Demo User',
        role: 'admin'
      };
      setUser(mockUser);
      localStorage.setItem('auth_token', 'demo-token-123');
    } catch (error) {
      console.error('Login failed:', error);
    }
  };

  const logout = async () => {
    try {
      setUser(null);
      localStorage.removeItem('auth_token');
    } catch (error) {
      console.error('Logout failed:', error);
    }
  };

  const value = {
    user,
    login,
    logout,
    isAuthenticated: !!user,
    loading,
  };

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};