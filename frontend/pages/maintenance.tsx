import React, { useState } from 'react';
import Layout from '../components/Layout';
import { Calendar, Plus, Clock, CheckCircle, AlertCircle } from 'lucide-react';

const Maintenance = () => {
  const [maintenanceRecords] = useState([
    {
      id: '1',
      asset_name: 'MacBook Pro 16"',
      maintenance_type: 'Software Update',
      scheduled_date: '2024-12-01',
      status: 'scheduled',
      cost: 0,
      technician: 'IT Team',
      priority: 'medium'
    },
    {
      id: '2',
      asset_name: 'Standing Desk',
      maintenance_type: 'Height Adjustment Check',
      scheduled_date: '2024-11-15',
      status: 'in_progress',
      cost: 50,
      technician: 'Facilities Team',
      priority: 'low'
    },
    {
      id: '3',
      asset_name: 'Server Rack',
      maintenance_type: 'Cooling System Maintenance',
      scheduled_date: '2024-10-20',
      status: 'completed',
      cost: 300,
      technician: 'HVAC Specialist',
      priority: 'high'
    },
    {
      id: '4',
      asset_name: 'Conference Table',
      maintenance_type: 'Surface Refinishing',
      scheduled_date: '2024-11-30',
      status: 'scheduled',
      cost: 150,
      technician: 'Maintenance Crew',
      priority: 'low'
    }
  ]);

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'scheduled': return <Clock className="h-4 w-4 text-blue-500" />;
      case 'in_progress': return <AlertCircle className="h-4 w-4 text-yellow-500" />;
      case 'completed': return <CheckCircle className="h-4 w-4 text-green-500" />;
      default: return <Clock className="h-4 w-4 text-gray-500" />;
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'scheduled': return 'bg-blue-100 text-blue-800';
      case 'in_progress': return 'bg-yellow-100 text-yellow-800';
      case 'completed': return 'bg-green-100 text-green-800';
      case 'cancelled': return 'bg-red-100 text-red-800';
      default: return 'bg-gray-100 text-gray-800';
    }
  };

  const getPriorityColor = (priority: string) => {
    switch (priority) {
      case 'high': return 'bg-red-100 text-red-800';
      case 'medium': return 'bg-yellow-100 text-yellow-800';
      case 'low': return 'bg-green-100 text-green-800';
      default: return 'bg-gray-100 text-gray-800';
    }
  };

  return (
    <Layout title="Maintenance">
      <div className="space-y-6">
        {/* Header */}
        <div className="flex justify-between items-center">
          <div className="flex items-center space-x-2">
            <Calendar className="h-6 w-6 text-primary-600" />
            <h1 className="text-2xl font-bold text-gray-900">Maintenance</h1>
          </div>
          <button className="btn-primary flex items-center space-x-2">
            <Plus className="h-4 w-4" />
            <span>Schedule Maintenance</span>
          </button>
        </div>

        {/* Summary Cards */}
        <div className="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4">
          <div className="card">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <div className="bg-blue-100 rounded-md p-3">
                  <Clock className="h-6 w-6 text-blue-600" />
                </div>
              </div>
              <div className="ml-5 w-0 flex-1">
                <dl>
                  <dt className="text-sm font-medium text-gray-500 truncate">
                    Scheduled
                  </dt>
                  <dd className="text-lg font-medium text-gray-900">
                    {maintenanceRecords.filter(r => r.status === 'scheduled').length}
                  </dd>
                </dl>
              </div>
            </div>
          </div>

          <div className="card">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <div className="bg-yellow-100 rounded-md p-3">
                  <AlertCircle className="h-6 w-6 text-yellow-600" />
                </div>
              </div>
              <div className="ml-5 w-0 flex-1">
                <dl>
                  <dt className="text-sm font-medium text-gray-500 truncate">
                    In Progress
                  </dt>
                  <dd className="text-lg font-medium text-gray-900">
                    {maintenanceRecords.filter(r => r.status === 'in_progress').length}
                  </dd>
                </dl>
              </div>
            </div>
          </div>

          <div className="card">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <div className="bg-green-100 rounded-md p-3">
                  <CheckCircle className="h-6 w-6 text-green-600" />
                </div>
              </div>
              <div className="ml-5 w-0 flex-1">
                <dl>
                  <dt className="text-sm font-medium text-gray-500 truncate">
                    Completed
                  </dt>
                  <dd className="text-lg font-medium text-gray-900">
                    {maintenanceRecords.filter(r => r.status === 'completed').length}
                  </dd>
                </dl>
              </div>
            </div>
          </div>

          <div className="card">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <div className="bg-purple-100 rounded-md p-3">
                  <Calendar className="h-6 w-6 text-purple-600" />
                </div>
              </div>
              <div className="ml-5 w-0 flex-1">
                <dl>
                  <dt className="text-sm font-medium text-gray-500 truncate">
                    Total Cost
                  </dt>
                  <dd className="text-lg font-medium text-gray-900">
                    ${maintenanceRecords.reduce((sum, record) => sum + record.cost, 0).toLocaleString()}
                  </dd>
                </dl>
              </div>
            </div>
          </div>
        </div>

        {/* Filter Bar */}
        <div className="flex flex-col sm:flex-row gap-4">
          <select className="px-3 py-2 border border-gray-300 rounded-md focus:ring-primary-500 focus:border-primary-500">
            <option>All Status</option>
            <option>Scheduled</option>
            <option>In Progress</option>
            <option>Completed</option>
            <option>Cancelled</option>
          </select>
          <select className="px-3 py-2 border border-gray-300 rounded-md focus:ring-primary-500 focus:border-primary-500">
            <option>All Priorities</option>
            <option>High</option>
            <option>Medium</option>
            <option>Low</option>
          </select>
        </div>

        {/* Maintenance Records Table */}
        <div className="card overflow-hidden">
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Asset & Maintenance
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Scheduled Date
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Status
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Priority
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Cost
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Technician
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Actions
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {maintenanceRecords.map((record) => (
                  <tr key={record.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div>
                        <div className="text-sm font-medium text-gray-900">{record.asset_name}</div>
                        <div className="text-sm text-gray-500">{record.maintenance_type}</div>
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm text-gray-900">
                        {new Date(record.scheduled_date).toLocaleDateString()}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center">
                        {getStatusIcon(record.status)}
                        <span className={`ml-2 inline-flex px-2 py-1 text-xs font-medium rounded-full ${getStatusColor(record.status)}`}>
                          {record.status.replace('_', ' ')}
                        </span>
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span className={`inline-flex px-2 py-1 text-xs font-medium rounded-full ${getPriorityColor(record.priority)}`}>
                        {record.priority}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm font-medium text-gray-900">
                        ${record.cost.toLocaleString()}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm text-gray-900">{record.technician}</div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <div className="flex space-x-2">
                        <button className="text-primary-600 hover:text-primary-900">
                          View
                        </button>
                        <button className="text-primary-600 hover:text-primary-900">
                          Edit
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </Layout>
  );
};

export default Maintenance;