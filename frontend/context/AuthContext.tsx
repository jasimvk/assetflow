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
    // In development mode, automatically authenticate with mock user
    if (process.env.NODE_ENV === 'development') {
      setUser({
        id: 'dev-user-123',
        email: 'dev@example.com',
        name: 'Development User',
        role: 'admin'
      });
      localStorage.setItem('auth_token', 'dev-token-123');
    } else {
      // Check for existing auth token in localStorage for production
      const token = localStorage.getItem('auth_token');
      if (token) {
        // In production, validate token with backend
        // For now, just set mock user
        setUser({
          id: 'prod-user-123',
          email: 'user@company.com',
          name: 'Production User',
          role: 'user'
        });
      }
    }
    setLoading(false);
  }, []);

  const login = async () => {
    try {
      // In development mode, simulate login
      if (process.env.NODE_ENV === 'development') {
        const mockUser = {
          id: 'dev-user-123',
          email: 'dev@example.com',
          name: 'Development User',
          role: 'admin'
        };
        setUser(mockUser);
        localStorage.setItem('auth_token', 'dev-token-123');
        return;
      }

      // In production, this would use Azure AD MSAL
      // For now, show an alert about configuration needed
      alert('Azure AD authentication needs to be configured for production use');
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