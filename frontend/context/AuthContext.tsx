import { createContext, useContext, useEffect, useState } from 'react';
import { PublicClientApplication, AccountInfo } from '@azure/msal-browser';
import { MsalProvider } from '@azure/msal-react';

const msalConfig = {
  auth: {
    clientId: process.env.NEXT_PUBLIC_AZURE_CLIENT_ID || '',
    authority: `https://login.microsoftonline.com/${process.env.NEXT_PUBLIC_AZURE_TENANT_ID}`,
    redirectUri: '/',
  },
  cache: {
    cacheLocation: 'sessionStorage',
    storeAuthStateInCookie: false,
  },
};

const msalInstance = new PublicClientApplication(msalConfig);

interface AuthContextType {
  user: AccountInfo | null;
  login: () => Promise<void>;
  logout: () => Promise<void>;
  isAuthenticated: boolean;
  loading: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider = ({ children }: { children: React.ReactNode }) => {
  const [user, setUser] = useState<AccountInfo | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const accounts = msalInstance.getAllAccounts();
    if (accounts.length > 0) {
      setUser(accounts[0]);
    }
    setLoading(false);
  }, []);

  const login = async () => {
    try {
      const loginResponse = await msalInstance.loginPopup({
        scopes: ['User.Read', 'Mail.Send'],
      });
      setUser(loginResponse.account);
    } catch (error) {
      console.error('Login failed:', error);
    }
  };

  const logout = async () => {
    try {
      await msalInstance.logoutPopup();
      setUser(null);
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
    <MsalProvider instance={msalInstance}>
      <AuthContext.Provider value={value}>
        {children}
      </AuthContext.Provider>
    </MsalProvider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};