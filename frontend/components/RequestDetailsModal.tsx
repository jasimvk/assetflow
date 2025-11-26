import { useState, useEffect } from 'react';
import { createClient } from '@supabase/supabase-js';
import { X, CheckCircle, XCircle, Clock, User, Mail, Calendar, FileText, AlertCircle } from 'lucide-react';

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
);

export default function RequestDetailsModal({ requestId, onClose, onUpdate, userRole }) {
    const [request, setRequest] = useState(null);
    const [loading, setLoading] = useState(true);
    const [actionLoading, setActionLoading] = useState(false);
    const [rejectionReason, setRejectionReason] = useState('');
    const [showRejectInput, setShowRejectInput] = useState(false);

    useEffect(() => {
        fetchRequestDetails();
    }, [requestId]);

    const fetchRequestDetails = async () => {
        try {
            setLoading(true);
            const response = await fetch(`http://localhost:3002/api/system-access/${requestId}`, {
                headers: {
                    'Authorization': `Bearer ${localStorage.getItem('auth_token')}`
                }
            });

            if (!response.ok) throw new Error('Failed to fetch request');

            const data = await response.json();
            setRequest(data);
        } catch (error) {
            console.error('Error fetching request details:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleApprove = async () => {
        setActionLoading(true);
        try {
            const response = await fetch(`http://localhost:3002/api/system-access/${requestId}/status`, {
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${localStorage.getItem('auth_token')}`
                },
                body: JSON.stringify({
                    status: 'approved',
                    comments: 'Request approved'
                })
            });

            if (!response.ok) throw new Error('Failed to approve request');

            onUpdate();
            onClose();
        } catch (error) {
            console.error('Error approving request:', error);
            alert('Failed to approve request');
        } finally {
            setActionLoading(false);
        }
    };

    const handleReject = async () => {
        if (!rejectionReason) {
            alert('Please provide a reason for rejection');
            return;
        }

        setActionLoading(true);
        try {
            const response = await fetch(`http://localhost:3002/api/system-access/${requestId}/status`, {
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${localStorage.getItem('auth_token')}`
                },
                body: JSON.stringify({
                    status: 'rejected',
                    rejection_reason: rejectionReason
                })
            });

            if (!response.ok) throw new Error('Failed to reject request');

            onUpdate();
            onClose();
        } catch (error) {
            console.error('Error rejecting request:', error);
            alert('Failed to reject request');
        } finally {
            setActionLoading(false);
        }
    };

    if (loading) {
        return (
            <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
                <div className="bg-white rounded-lg p-8">
                    <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
                    <p className="text-gray-600 mt-4">Loading request details...</p>
                </div>
            </div>
        );
    }

    if (!request) {
        return null;
    }

    const isAdmin = userRole === 'admin' || userRole === 'it_admin' || userRole === 'manager';
    const canApprove = isAdmin && request.status === 'pending';

    return (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
            <div className="bg-white rounded-xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-hidden flex flex-col">
                {/* Header */}
                <div className="p-6 border-b border-gray-200 flex justify-between items-center bg-gradient-to-r from-blue-600 to-blue-700">
                    <div>
                        <h2 className="text-2xl font-bold text-white">Request Details</h2>
                        <p className="text-blue-100 text-sm mt-1">{request.request_number}</p>
                    </div>
                    <button onClick={onClose} className="text-white hover:bg-blue-800 p-2 rounded-lg transition">
                        <X className="w-6 h-6" />
                    </button>
                </div>

                {/* Content */}
                <div className="flex-1 overflow-y-auto p-6">
                    {/* Employee Information */}
                    <div className="mb-6">
                        <h3 className="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
                            <User className="w-5 h-5" />
                            Employee Information
                        </h3>
                        <div className="bg-gray-50 rounded-lg p-4 grid grid-cols-2 gap-4">
                            <div>
                                <p className="text-sm text-gray-600">Name</p>
                                <p className="font-medium">{request.employee_first_name} {request.employee_last_name}</p>
                            </div>
                            <div>
                                <p className="text-sm text-gray-600">Employee ID</p>
                                <p className="font-medium">{request.employee_id || 'N/A'}</p>
                            </div>
                            <div>
                                <p className="text-sm text-gray-600">Email</p>
                                <p className="font-medium">{request.email}</p>
                            </div>
                            <div>
                                <p className="text-sm text-gray-600">Entra ID</p>
                                <p className="font-medium">{request.entra_id || 'N/A'}</p>
                            </div>
                            <div>
                                <p className="text-sm text-gray-600">Department</p>
                                <p className="font-medium">{request.department}</p>
                            </div>
                            <div>
                                <p className="text-sm text-gray-600">Department Head</p>
                                <p className="font-medium">{request.department_head || 'N/A'}</p>
                            </div>
                            <div>
                                <p className="text-sm text-gray-600">Date of Joining</p>
                                <p className="font-medium">{request.date_of_joining ? new Date(request.date_of_joining).toLocaleDateString() : 'N/A'}</p>
                            </div>
                            <div>
                                <p className="text-sm text-gray-600">Priority</p>
                                <span className={`inline-block px-3 py-1 text-sm font-semibold rounded-full ${request.priority === 'high' ? 'bg-red-100 text-red-800' :
                                    request.priority === 'medium' ? 'bg-yellow-100 text-yellow-800' :
                                        'bg-green-100 text-green-800'
                                    }`}>
                                    {request.priority === 'high' ? '🔴 High' :
                                        request.priority === 'medium' ? '🟡 Medium' :
                                            '🟢 Low'}
                                </span>
                            </div>
                        </div>
                    </div>

                    {/* System Access Details */}
                    {(request.system_details?.length > 0 || request.oracle_fusion || request.timetec || request.network_email) && (
                        <div className="mb-6">
                            <h3 className="text-lg font-semibold text-gray-900 mb-4">System Access</h3>

                            {/* Network & Email - You'll need to fetch this from the backend */}
                            {request.network_email && (
                                <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-3">
                                    <h4 className="font-semibold text-gray-900 mb-2">Network & Email</h4>
                                    <ul className="list-disc list-inside text-sm space-y-1">
                                        {request.network_email.network_login && <li>Network Login (Windows/Entra ID)</li>}
                                        {request.network_email.email_generic && <li>Generic Email</li>}
                                        {request.network_email.email_personal && <li>Personal Email</li>}
                                    </ul>
                                </div>
                            )}

                            {/* Oracle Fusion - You'll need to fetch and display this */}
                            {request.oracle_fusion && (
                                <div className="bg-purple-50 border border-purple-200 rounded-lg p-4 mb-3">
                                    <h4 className="font-semibold text-gray-900 mb-2">Oracle Fusion ERP</h4>
                                    <p className="text-sm text-gray-600">Access details saved in database</p>
                                </div>
                            )}

                            {/* Timetec */}
                            {request.timetec && (
                                <div className="bg-green-50 border border-green-200 rounded-lg p-4">
                                    <h4 className="font-semibold text-gray-900 mb-2">Timetec Time Attendance</h4>
                                    <p className="text-sm text-gray-600">Access details saved in database</p>
                                </div>
                            )}
                        </div>
                    )}

                    {/* Hardware Assets */}
                    {request.asset_handovers?.length > 0 && (
                        <div className="mb-6">
                            <h3 className="text-lg font-semibold text-gray-900 mb-4">IT Assets Requested</h3>
                            <div className="space-y-2">
                                {request.asset_handovers.map((handover, idx) => (
                                    <div key={idx} className="bg-gray-50 rounded-lg p-3 flex justify-between items-center">
                                        <span className="font-medium">{handover.asset_type}</span>
                                        <span className={`px-2 py-1 text-xs rounded-full ${handover.status === 'handed_over' ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'
                                            }`}>
                                            {handover.status}
                                        </span>
                                    </div>
                                ))}
                            </div>
                        </div>
                    )}

                    {/* Notes */}
                    {request.notes && (
                        <div className="mb-6">
                            <h3 className="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
                                <FileText className="w-5 h-5" />
                                Special Requirements
                            </h3>
                            <div className="bg-gray-50 rounded-lg p-4">
                                <p className="text-gray-700">{request.notes}</p>
                            </div>
                        </div>
                    )}

                    {/* Status & History */}
                    <div className="mb-6">
                        <h3 className="text-lg font-semibold text-gray-900 mb-4">Status & History</h3>
                        <div className="bg-gray-50 rounded-lg p-4">
                            <div className="flex items-center gap-2 mb-4">
                                <span className="text-sm text-gray-600">Current Status:</span>
                                <span className={`px-3 py-1 text-sm font-semibold rounded-full ${request.status === 'pending' ? 'bg-yellow-100 text-yellow-800' :
                                    request.status === 'approved' ? 'bg-green-100 text-green-800' :
                                        request.status === 'rejected' ? 'bg-red-100 text-red-800' :
                                            'bg-blue-100 text-blue-800'
                                    }`}>
                                    {request.status.replace('_', ' ').toUpperCase()}
                                </span>
                            </div>

                            {request.history && request.history.length > 0 && (
                                <div className="mt-4">
                                    <p className="text-sm font-medium text-gray-700 mb-2">Activity Log:</p>
                                    <div className="space-y-2">
                                        {request.history.map((entry, idx) => (
                                            <div key={idx} className="text-sm text-gray-600 flex items-start gap-2">
                                                <Clock className="w-4 h-4 mt-0.5 flex-shrink-0" />
                                                <div>
                                                    <p>{entry.description}</p>
                                                    <p className="text-xs text-gray-500">
                                                        {new Date(entry.performed_at).toLocaleString()}
                                                        {entry.performed_by_user && ` by ${entry.performed_by_user.name}`}
                                                    </p>
                                                </div>
                                            </div>
                                        ))}
                                    </div>
                                </div>
                            )}
                        </div>
                    </div>

                    {/* Rejection Input */}
                    {showRejectInput && (
                        <div className="mb-4 p-4 bg-red-50 border border-red-200 rounded-lg">
                            <label className="block text-sm font-medium text-gray-700 mb-2">
                                Reason for Rejection *
                            </label>
                            <textarea
                                value={rejectionReason}
                                onChange={(e) => setRejectionReason(e.target.value)}
                                rows={3}
                                placeholder="Explain why this request is being rejected..."
                                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-red-500 focus:border-transparent"
                            />
                        </div>
                    )}
                </div>

                {/* Footer - Approval Actions */}
                {canApprove && (
                    <div className="p-6 border-t border-gray-200 bg-gray-50 flex justify-end gap-3">
                        {!showRejectInput ? (
                            <>
                                <button
                                    onClick={() => setShowRejectInput(true)}
                                    className="px-4 py-2 border-2 border-red-500 text-red-700 rounded-lg hover:bg-red-50 transition flex items-center gap-2"
                                >
                                    <XCircle className="w-5 h-5" />
                                    Reject
                                </button>
                                <button
                                    onClick={handleApprove}
                                    disabled={actionLoading}
                                    className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition flex items-center gap-2 disabled:bg-gray-400"
                                >
                                    <CheckCircle className="w-5 h-5" />
                                    {actionLoading ? 'Approving...' : 'Approve'}
                                </button>
                            </>
                        ) : (
                            <>
                                <button
                                    onClick={() => {
                                        setShowRejectInput(false);
                                        setRejectionReason('');
                                    }}
                                    className="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-100"
                                >
                                    Cancel
                                </button>
                                <button
                                    onClick={handleReject}
                                    disabled={actionLoading || !rejectionReason}
                                    className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition disabled:bg-gray-400"
                                >
                                    {actionLoading ? 'Rejecting...' : 'Confirm Rejection'}
                                </button>
                            </>
                        )}
                    </div>
                )}
            </div>
        </div>
    );
}
