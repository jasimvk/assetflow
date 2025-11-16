import React, { useState } from 'react';
import Layout from '../components/Layout';
import { getSupabaseClient } from '../utils/supabase';
import { Play, CheckCircle, XCircle, AlertCircle } from 'lucide-react';

interface TestResult {
  name: string;
  status: 'pending' | 'running' | 'passed' | 'failed';
  message?: string;
  details?: any;
}

const TestCRUD = () => {
  const [results, setResults] = useState<TestResult[]>([
    { name: 'CREATE - Add new asset', status: 'pending' },
    { name: 'READ - Fetch single asset', status: 'pending' },
    { name: 'READ - Fetch all assets with department JOIN', status: 'pending' },
    { name: 'UPDATE - Modify asset', status: 'pending' },
    { name: 'DELETE - Remove asset', status: 'pending' },
    { name: 'FILTER - Category filter', status: 'pending' },
    { name: 'SEARCH - Name search', status: 'pending' },
    { name: 'DEPARTMENT - Verify integration', status: 'pending' },
  ]);
  const [isRunning, setIsRunning] = useState(false);
  const [testAssetId, setTestAssetId] = useState<string | null>(null);

  const supabase = getSupabaseClient();

  const updateResult = (index: number, status: TestResult['status'], message?: string, details?: any) => {
    setResults(prev => prev.map((r, i) => 
      i === index ? { ...r, status, message, details } : r
    ));
  };

  const runTests = async () => {
    setIsRunning(true);
    let createdAssetId: string | null = null;

    // Test 1: CREATE
    try {
      updateResult(0, 'running');
      const testAsset = {
        name: 'TEST-Laptop-' + Date.now(),
        category: 'Laptop',
        location: 'Office - Floor 1',
        serial_number: 'TEST-SN-' + Date.now(),
        model: 'Test Model X1',
        manufacturer: 'Test Manufacturer',
        current_value: 5000,
        condition: 'excellent',
        status: 'active',
        purchase_date: '2024-01-15',
        purchase_cost: 5500,
        description: 'Test asset for CRUD operations',
      };

      const { data, error } = await supabase
        .from('assets')
        .insert([testAsset])
        .select()
        .single();

      if (error) throw error;
      
      createdAssetId = data.id;
      setTestAssetId(data.id);
      updateResult(0, 'passed', `Created asset: ${data.name}`, { id: data.id });
    } catch (err: any) {
      updateResult(0, 'failed', err.message);
      setIsRunning(false);
      return;
    }

    // Test 2: READ Single
    try {
      updateResult(1, 'running');
      const { data, error } = await supabase
        .from('assets')
        .select('*')
        .eq('id', createdAssetId)
        .single();

      if (error) throw error;
      updateResult(1, 'passed', `Found asset: ${data.name}`);
    } catch (err: any) {
      updateResult(1, 'failed', err.message);
    }

    // Test 3: READ All with JOIN
    try {
      updateResult(2, 'running');
      const { data, error } = await supabase
        .from('assets')
        .select(`
          *,
          department:department_id (
            id,
            name,
            description
          )
        `)
        .limit(5);

      if (error) throw error;
      updateResult(2, 'passed', `Fetched ${data.length} assets with departments`, { count: data.length });
    } catch (err: any) {
      updateResult(2, 'failed', err.message);
    }

    // Test 4: UPDATE
    try {
      updateResult(3, 'running');
      const updates = {
        current_value: 4500,
        condition: 'good',
        status: 'maintenance',
      };

      const { data, error } = await supabase
        .from('assets')
        .update(updates)
        .eq('id', createdAssetId)
        .select()
        .single();

      if (error) throw error;
      updateResult(3, 'passed', `Updated value: ${data.current_value}, status: ${data.status}`);
    } catch (err: any) {
      updateResult(3, 'failed', err.message);
    }

    // Test 5: DELETE
    try {
      updateResult(4, 'running');
      const { error } = await supabase
        .from('assets')
        .delete()
        .eq('id', createdAssetId);

      if (error) throw error;

      // Verify deletion
      const { data: verifyData } = await supabase
        .from('assets')
        .select('id')
        .eq('id', createdAssetId);

      if (verifyData && verifyData.length === 0) {
        updateResult(4, 'passed', 'Asset successfully deleted and verified');
      } else {
        updateResult(4, 'failed', 'Asset still exists after deletion');
      }
    } catch (err: any) {
      updateResult(4, 'failed', err.message);
    }

    // Test 6: FILTER
    try {
      updateResult(5, 'running');
      const { data, error } = await supabase
        .from('assets')
        .select('id, name, category')
        .eq('category', 'Laptop')
        .limit(5);

      if (error) throw error;
      updateResult(5, 'passed', `Found ${data.length} laptops`);
    } catch (err: any) {
      updateResult(5, 'failed', err.message);
    }

    // Test 7: SEARCH
    try {
      updateResult(6, 'running');
      const { data, error } = await supabase
        .from('assets')
        .select('id, name')
        .ilike('name', '%Laptop%')
        .limit(5);

      if (error) throw error;
      updateResult(6, 'passed', `Search found ${data.length} results`);
    } catch (err: any) {
      updateResult(6, 'failed', err.message);
    }

    // Test 8: DEPARTMENT
    try {
      updateResult(7, 'running');
      
      // Check departments table
      const { data: depts, error: deptError } = await supabase
        .from('departments')
        .select('id, name')
        .limit(5);

      if (deptError) throw deptError;

      // Check assets with departments
      const { data: assets, error: assetError } = await supabase
        .from('assets')
        .select(`
          id,
          name,
          department:department_id (
            name
          )
        `)
        .not('department_id', 'is', null)
        .limit(5);

      if (assetError) throw assetError;

      updateResult(7, 'passed', `Departments: ${depts.length}, Assets with dept: ${assets.length}`);
    } catch (err: any) {
      updateResult(7, 'failed', err.message);
    }

    setIsRunning(false);
  };

  const getStatusIcon = (status: TestResult['status']) => {
    switch (status) {
      case 'passed':
        return <CheckCircle className="h-5 w-5 text-green-600" />;
      case 'failed':
        return <XCircle className="h-5 w-5 text-red-600" />;
      case 'running':
        return <div className="animate-spin h-5 w-5 border-2 border-blue-600 border-t-transparent rounded-full" />;
      default:
        return <AlertCircle className="h-5 w-5 text-gray-400" />;
    }
  };

  const passedCount = results.filter(r => r.status === 'passed').length;
  const failedCount = results.filter(r => r.status === 'failed').length;
  const totalCount = results.length;

  return (
    <Layout>
      <div className="max-w-4xl mx-auto p-6">
        {/* Header */}
        <div className="bg-gradient-to-r from-blue-500 to-indigo-600 rounded-2xl p-8 mb-6 text-white shadow-lg">
          <h1 className="text-3xl font-bold mb-2">CRUD Test Suite</h1>
          <p className="text-blue-100">
            Comprehensive testing for AssetFlow Supabase API operations
          </p>
        </div>

        {/* Run Button */}
        <div className="mb-6">
          <button
            onClick={runTests}
            disabled={isRunning}
            className={`w-full flex items-center justify-center gap-3 px-8 py-4 rounded-xl font-semibold text-white text-lg shadow-lg transition-all ${
              isRunning
                ? 'bg-gray-400 cursor-not-allowed'
                : 'bg-gradient-to-r from-green-500 to-emerald-500 hover:from-green-600 hover:to-emerald-600 hover:shadow-xl'
            }`}
          >
            <Play className="h-6 w-6" />
            {isRunning ? 'Running Tests...' : 'Run All Tests'}
          </button>
        </div>

        {/* Summary Stats */}
        {(passedCount > 0 || failedCount > 0) && (
          <div className="grid grid-cols-3 gap-4 mb-6">
            <div className="bg-white rounded-xl p-4 border-2 border-gray-200">
              <p className="text-gray-600 text-sm font-semibold">Total Tests</p>
              <p className="text-3xl font-bold text-gray-900">{totalCount}</p>
            </div>
            <div className="bg-green-50 rounded-xl p-4 border-2 border-green-200">
              <p className="text-green-700 text-sm font-semibold">Passed</p>
              <p className="text-3xl font-bold text-green-600">{passedCount}</p>
            </div>
            <div className="bg-red-50 rounded-xl p-4 border-2 border-red-200">
              <p className="text-red-700 text-sm font-semibold">Failed</p>
              <p className="text-3xl font-bold text-red-600">{failedCount}</p>
            </div>
          </div>
        )}

        {/* Test Results */}
        <div className="bg-white rounded-2xl shadow-lg border border-gray-200 overflow-hidden">
          <div className="p-6 border-b border-gray-200 bg-gray-50">
            <h2 className="text-xl font-bold text-gray-900">Test Results</h2>
          </div>
          <div className="divide-y divide-gray-200">
            {results.map((result, index) => (
              <div
                key={index}
                className={`p-6 transition-colors ${
                  result.status === 'running' ? 'bg-blue-50' : ''
                }`}
              >
                <div className="flex items-start gap-4">
                  <div className="mt-1">{getStatusIcon(result.status)}</div>
                  <div className="flex-1">
                    <h3 className="font-semibold text-gray-900 mb-1">
                      {result.name}
                    </h3>
                    {result.message && (
                      <p className="text-sm text-gray-600">{result.message}</p>
                    )}
                    {result.details && (
                      <pre className="mt-2 text-xs bg-gray-50 p-2 rounded border border-gray-200 overflow-auto">
                        {JSON.stringify(result.details, null, 2)}
                      </pre>
                    )}
                  </div>
                  <div>
                    <span
                      className={`inline-flex px-3 py-1 text-xs font-semibold rounded-full ${
                        result.status === 'passed'
                          ? 'bg-green-100 text-green-800'
                          : result.status === 'failed'
                          ? 'bg-red-100 text-red-800'
                          : result.status === 'running'
                          ? 'bg-blue-100 text-blue-800'
                          : 'bg-gray-100 text-gray-800'
                      }`}
                    >
                      {result.status.toUpperCase()}
                    </span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Success Message */}
        {!isRunning && passedCount === totalCount && failedCount === 0 && passedCount > 0 && (
          <div className="mt-6 bg-gradient-to-r from-green-50 to-emerald-50 border-2 border-green-200 rounded-2xl p-6">
            <div className="flex items-center gap-3">
              <CheckCircle className="h-8 w-8 text-green-600" />
              <div>
                <h3 className="text-lg font-bold text-green-900">
                  🎉 All Tests Passed!
                </h3>
                <p className="text-green-700">
                  CRUD operations are working correctly with Supabase.
                </p>
              </div>
            </div>
          </div>
        )}

        {/* Test Asset ID */}
        {testAssetId && (
          <div className="mt-6 bg-gray-50 rounded-xl p-4 border border-gray-200">
            <p className="text-sm text-gray-600">
              <span className="font-semibold">Test Asset ID:</span>{' '}
              <code className="bg-white px-2 py-1 rounded border border-gray-300">
                {testAssetId}
              </code>
            </p>
          </div>
        )}
      </div>
    </Layout>
  );
};

export default TestCRUD;
