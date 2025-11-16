import { useEffect, useState } from 'react';
import { getSupabaseClient } from '../utils/supabase';

export default function TestDB() {
  const [result, setResult] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<any>(null);

  useEffect(() => {
    const testConnection = async () => {
      try {
        console.log('Testing Supabase connection...');
        const supabase = getSupabaseClient();
        
        if (!supabase) {
          throw new Error('Supabase client not initialized');
        }

        console.log('Supabase client initialized');

        // Test query
        const { data, error } = await supabase.from('assets').select('*').limit(10);
        
        console.log('Query result:', { data, error });

        if (error) {
          throw error;
        }

        setResult(data);
      } catch (err: any) {
        console.error('Test error:', err);
        setError(err);
      } finally {
        setLoading(false);
      }
    };

    testConnection();
  }, []);

  return (
    <div className="min-h-screen bg-gray-50 p-8">
      <div className="max-w-4xl mx-auto">
        <h1 className="text-3xl font-bold mb-6">Database Connection Test</h1>
        
        {loading && (
          <div className="bg-blue-100 border border-blue-400 text-blue-700 px-4 py-3 rounded">
            Testing connection...
          </div>
        )}

        {error && (
          <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
            <p className="font-bold">Error:</p>
            <pre className="mt-2 text-sm">{JSON.stringify(error, null, 2)}</pre>
          </div>
        )}

        {result && (
          <div className="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
            <p className="font-bold">Success! Found {result.length} assets:</p>
          </div>
        )}

        {result && (
          <div className="bg-white shadow rounded-lg overflow-hidden">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Name</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Category</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Location</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Serial</th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {result.map((asset: any) => (
                  <tr key={asset.id}>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{asset.name}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{asset.category}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{asset.location}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500 font-mono">{asset.serial_number}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}

        <div className="mt-8 bg-gray-100 p-4 rounded">
          <h2 className="font-bold mb-2">Environment Variables:</h2>
          <pre className="text-xs">
            NEXT_PUBLIC_SUPABASE_URL: {process.env.NEXT_PUBLIC_SUPABASE_URL ? '✓ Set' : '✗ Not set'}
            {'\n'}NEXT_PUBLIC_SUPABASE_ANON_KEY: {process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ? '✓ Set' : '✗ Not set'}
          </pre>
        </div>
      </div>
    </div>
  );
}
