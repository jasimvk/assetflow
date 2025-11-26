import { useState, useEffect } from 'react';
import { createClient } from '@supabase/supabase-js';
import { X, ChevronRight, ChevronLeft, CheckCircle, AlertCircle, Laptop, Monitor, Smartphone, Radio, CreditCard } from 'lucide-react';

const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
);

export default function RequestAccessWizard({ onClose, onSuccess, user }) {
    const [currentStep, setCurrentStep] = useState(1);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');

    // Form data
    const [formData, setFormData] = useState({
        // Employee Info
        employee_first_name: user?.name?.split(' ')[0] || '',
        employee_last_name: user?.name?.split(' ')[1] || '',
        employee_id: '',
        entra_id: '', // f.lastname@1hospitality.ae
        department: user?.department || '',
        department_head: '',
        email: user?.email || '',
        date_of_joining: new Date().toISOString().split('T')[0],

        // Request metadata
        priority: 'medium',
        notes: '',

        // Network & Email
        network_login: false,
        email_generic: false,
        email_personal: false,

        // Oracle Fusion ERP
        oracle_it_admin: false,
        oracle_it_dept: false,
        // HR Module
        oracle_hr_group1_dhr: false,
        oracle_hr_group2_manager: false,
        oracle_hr_group3_executive: false,
        oracle_hr_group4_accommodation: false,
        oracle_hr_group5_pr: false,
        oracle_hr_group6_hiring: false,
        oracle_hr_ess: false,
        // Finance Module
        oracle_finance_ap: false,
        oracle_finance_ar: false,
        oracle_finance_manager: false,
        oracle_finance_dm: false,
        // Procurement Module
        oracle_procurement_buyer: false,
        oracle_procurement_coordinator: false,
        oracle_procurement_store: false,
        oracle_procurement_receiver: false,
        oracle_procurement_requestor: false,

        // Timetec
        timetec_it_admin: false,
        timetec_hr_admin: false,
        timetec_dept_coordinator: false,

        // IT Assets
        asset_laptop: false,
        asset_desktop: false,
        asset_mobile_camera: false,
        asset_mobile_non_camera: false,
        asset_walkie_talkie: false,
        asset_duty_sim: false
    });

    const hasOracleFusionAccess = () => {
        return formData.oracle_it_admin || formData.oracle_it_dept ||
            formData.oracle_hr_group1_dhr || formData.oracle_hr_group2_manager ||
            formData.oracle_hr_group3_executive || formData.oracle_hr_group4_accommodation ||
            formData.oracle_hr_group5_pr || formData.oracle_hr_group6_hiring ||
            formData.oracle_hr_ess || formData.oracle_finance_ap ||
            formData.oracle_finance_ar || formData.oracle_finance_manager ||
            formData.oracle_finance_dm || formData.oracle_procurement_buyer ||
            formData.oracle_procurement_coordinator || formData.oracle_procurement_store ||
            formData.oracle_procurement_receiver || formData.oracle_procurement_requestor;
    };

    const hasTimetecAccess = () => {
        return formData.timetec_it_admin || formData.timetec_hr_admin || formData.timetec_dept_coordinator;
    };

    const hasNetworkEmailAccess = () => {
        return formData.network_login || formData.email_generic || formData.email_personal;
    };

    const hasITAssets = () => {
        return formData.asset_laptop || formData.asset_desktop ||
            formData.asset_mobile_camera || formData.asset_mobile_non_camera ||
            formData.asset_walkie_talkie || formData.asset_duty_sim;
    };

    const handleSubmit = async () => {
        setLoading(true);
        setError('');

        try {
            // Prepare request data
            const requestData = {
                employee_first_name: formData.employee_first_name,
                employee_last_name: formData.employee_last_name,
                employee_id: formData.employee_id,
                entra_id: formData.entra_id,
                department: formData.department,
                department_head: formData.department_head,
                email: formData.email,
                date_of_joining: formData.date_of_joining,
                priority: formData.priority,
                notes: formData.notes,
                request_type: hasITAssets() ? (hasOracleFusionAccess() || hasTimetecAccess() || hasNetworkEmailAccess() ? 'both' : 'hardware') : 'software',

                // System access details
                network_email: hasNetworkEmailAccess() ? {
                    network_login: formData.network_login,
                    email_generic: formData.email_generic,
                    email_personal: formData.email_personal
                } : null,

                oracle_fusion: hasOracleFusionAccess() ? {
                    it_admin_access: formData.oracle_it_admin,
                    it_department: formData.oracle_it_dept,
                    hr_group_1_dhr: formData.oracle_hr_group1_dhr,
                    hr_group_2_hr_manager: formData.oracle_hr_group2_manager,
                    hr_group_3_executive: formData.oracle_hr_group3_executive,
                    hr_group_4_accommodation: formData.oracle_hr_group4_accommodation,
                    hr_group_5_public_relations: formData.oracle_hr_group5_pr,
                    hr_group_6_hiring: formData.oracle_hr_group6_hiring,
                    hr_ess_user: formData.oracle_hr_ess,
                    finance_ap: formData.oracle_finance_ap,
                    finance_ar: formData.oracle_finance_ar,
                    finance_manager: formData.oracle_finance_manager,
                    finance_dm_finance: formData.oracle_finance_dm,
                    procurement_group_3_buyer: formData.oracle_procurement_buyer,
                    procurement_group_4_coordinator: formData.oracle_procurement_coordinator,
                    procurement_group_5_store: formData.oracle_procurement_store,
                    procurement_group_6_receiver: formData.oracle_procurement_receiver,
                    procurement_group_7_requestor: formData.oracle_procurement_requestor
                } : null,

                timetec: hasTimetecAccess() ? {
                    group_1_it_admin: formData.timetec_it_admin,
                    group_2_hr_admin: formData.timetec_hr_admin,
                    group_3_dept_coordinator: formData.timetec_dept_coordinator
                } : null,

                // Hardware requests
                hardware_requests: hasITAssets() ? [
                    formData.asset_laptop && { asset_type: 'Laptop' },
                    formData.asset_desktop && { asset_type: 'Desktop' },
                    formData.asset_mobile_camera && { asset_type: 'Mobile (Camera)' },
                    formData.asset_mobile_non_camera && { asset_type: 'Mobile (Non-Camera)' },
                    formData.asset_walkie_talkie && { asset_type: 'Walkie Talkie' },
                    formData.asset_duty_sim && { asset_type: 'Duty SIM Card' }
                ].filter(Boolean) : []
            };

            const response = await fetch('http://localhost:3002/api/system-access', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${localStorage.getItem('auth_token')}`
                },
                body: JSON.stringify(requestData)
            });

            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.error || 'Failed to create request');
            }

            const result = await response.json();
            onSuccess(result.request);
            onClose();
        } catch (err) {
            setError(err.message);
        } finally {
            setLoading(false);
        }
    };

    const nextStep = () => {
        if (currentStep < 4) setCurrentStep(currentStep + 1);
    };

    const prevStep = () => {
        if (currentStep > 1) setCurrentStep(currentStep - 1);
    };

    const canProceed = () => {
        switch (currentStep) {
            case 1:
                return formData.employee_first_name && formData.employee_last_name && formData.email;
            case 2:
                return hasNetworkEmailAccess() || hasOracleFusionAccess() || hasTimetecAccess();
            case 3:
                return true; // Hardware is optional
            case 4:
                return true; // Priority and notes are optional
            default:
                return true;
        }
    };

    const getPriorityColor = (priority) => {
        switch (priority) {
            case 'high': return 'border-red-500 bg-red-50';
            case 'medium': return 'border-yellow-500 bg-yellow-50';
            case 'low': return 'border-green-500 bg-green-50';
            default: return 'border-gray-300';
        }
    };

    return (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
            <div className="bg-white rounded-xl shadow-2xl max-w-5xl w-full max-h-[90vh] overflow-hidden flex flex-col">
                {/* Header */}
                <div className="p-6 border-b border-gray-200 flex justify-between items-center bg-gradient-to-r from-blue-600 to-blue-700">
                    <div>
                        <h2 className="text-2xl font-bold text-white">New Access Request</h2>
                        <p className="text-blue-100 text-sm mt-1">Step {currentStep} of 4</p>
                    </div>
                    <button onClick={onClose} className="text-white hover:bg-blue-800 p-2 rounded-lg transition">
                        <X className="w-6 h-6" />
                    </button>
                </div>

                {/* Progress Bar */}
                <div className="px-6 pt-6">
                    <div className="flex items-center justify-between mb-6">
                        {['Employee Details', 'System Access', 'IT Assets', 'Priority & Notes'].map((label, idx) => (
                            <div key={idx} className="flex items-center flex-1">
                                <div className={`flex flex-col items-center ${idx < 3 ? 'flex-1' : ''}`}>
                                    <div className={`flex items-center justify-center w-10 h-10 rounded-full font-semibold text-sm ${currentStep > idx + 1 ? 'bg-green-600 text-white' :
                                            currentStep === idx + 1 ? 'bg-blue-600 text-white' : 'bg-gray-200 text-gray-600'
                                        }`}>
                                        {currentStep > idx + 1 ? <CheckCircle className="w-6 h-6" /> : idx + 1}
                                    </div>
                                    <span className="text-xs mt-1 text-gray-600">{label}</span>
                                </div>
                                {idx < 3 && (
                                    <div className={`flex-1 h-1 mx-2 ${currentStep > idx + 1 ? 'bg-green-600' : 'bg-gray-200'}`} />
                                )}
                            </div>
                        ))}
                    </div>
                </div>

                {/* Content */}
                <div className="flex-1 overflow-y-auto px-6 pb-6">
                    {error && (
                        <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg flex items-start gap-3">
                            <AlertCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
                            <p className="text-red-700 text-sm">{error}</p>
                        </div>
                    )}

                    {/* Step 1: Employee Details */}
                    {currentStep === 1 && (
                        <div className="space-y-4">
                            <h3 className="text-lg font-semibold text-gray-900 mb-4">👤 Employee Information</h3>
                            <div className="grid grid-cols-2 gap-4">
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-2">First Name *</label>
                                    <input
                                        type="text"
                                        value={formData.employee_first_name}
                                        onChange={(e) => setFormData({ ...formData, employee_first_name: e.target.value })}
                                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                    />
                                </div>
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-2">Last Name *</label>
                                    <input
                                        type="text"
                                        value={formData.employee_last_name}
                                        onChange={(e) => setFormData({ ...formData, employee_last_name: e.target.value })}
                                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                    />
                                </div>
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-2">Employee ID</label>
                                    <input
                                        type="text"
                                        value={formData.employee_id}
                                        onChange={(e) => setFormData({ ...formData, employee_id: e.target.value })}
                                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                    />
                                </div>
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-2">Entra ID</label>
                                    <input
                                        type="text"
                                        value={formData.entra_id}
                                        onChange={(e) => setFormData({ ...formData, entra_id: e.target.value })}
                                        placeholder="f.lastname@1hospitality.ae"
                                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                    />
                                </div>
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-2">Department</label>
                                    <input
                                        type="text"
                                        value={formData.department}
                                        onChange={(e) => setFormData({ ...formData, department: e.target.value })}
                                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                    />
                                </div>
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-2">Department Head</label>
                                    <input
                                        type="text"
                                        value={formData.department_head}
                                        onChange={(e) => setFormData({ ...formData, department_head: e.target.value })}
                                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                    />
                                </div>
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-2">Email *</label>
                                    <input
                                        type="email"
                                        value={formData.email}
                                        onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                    />
                                </div>
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-2">Date of Joining</label>
                                    <input
                                        type="date"
                                        value={formData.date_of_joining}
                                        onChange={(e) => setFormData({ ...formData, date_of_joining: e.target.value })}
                                        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                    />
                                </div>
                            </div>
                        </div>
                    )}

                    {/* Step 2: System Access */}
                    {currentStep === 2 && (
                        <div className="space-y-6">
                            <h3 className="text-lg font-semibold text-gray-900 mb-4">💻 System Access Required</h3>

                            {/* Network & Email */}
                            <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
                                <h4 className="font-semibold text-gray-900 mb-3">Network & Email</h4>
                                <div className="space-y-2">
                                    <label className="flex items-center gap-2">
                                        <input
                                            type="checkbox"
                                            checked={formData.network_login}
                                            onChange={(e) => setFormData({ ...formData, network_login: e.target.checked })}
                                            className="w-4 h-4 text-blue-600 rounded focus:ring-blue-500"
                                        />
                                        <span className="text-sm">Network Login (Windows/Entra ID)</span>
                                    </label>
                                    <label className="flex items-center gap-2">
                                        <input
                                            type="checkbox"
                                            checked={formData.email_generic}
                                            onChange={(e) => setFormData({ ...formData, email_generic: e.target.checked })}
                                            className="w-4 h-4 text-blue-600 rounded focus:ring-blue-500"
                                        />
                                        <span className="text-sm">Generic Email</span>
                                    </label>
                                    <label className="flex items-center gap-2">
                                        <input
                                            type="checkbox"
                                            checked={formData.email_personal}
                                            onChange={(e) => setFormData({ ...formData, email_personal: e.target.checked })}
                                            className="w-4 h-4 text-blue-600 rounded focus:ring-blue-500"
                                        />
                                        <span className="text-sm">Personal Email</span>
                                    </label>
                                </div>
                            </div>

                            {/* Oracle Fusion ERP */}
                            <div className="bg-purple-50 border border-purple-200 rounded-lg p-4">
                                <h4 className="font-semibold text-gray-900 mb-3">Oracle Fusion ERP Access</h4>

                                {/* IT Admin */}
                                <div className="mb-3">
                                    <h5 className="text-sm font-medium text-gray-700 mb-2">IT Admin Access</h5>
                                    <div className="space-y-1 ml-4">
                                        <label className="flex items-center gap-2">
                                            <input type="checkbox" checked={formData.oracle_it_admin} onChange={(e) => setFormData({ ...formData, oracle_it_admin: e.target.checked })} className="w-4 h-4" />
                                            <span className="text-sm">IT Admin</span>
                                        </label>
                                        <label className="flex items-center gap-2">
                                            <input type="checkbox" checked={formData.oracle_it_dept} onChange={(e) => setFormData({ ...formData, oracle_it_dept: e.target.checked })} className="w-4 h-4" />
                                            <span className="text-sm">IT Department</span>
                                        </label>
                                    </div>
                                </div>

                                {/* HR Module */}
                                <div className="mb-3">
                                    <h5 className="text-sm font-medium text-gray-700 mb-2">HR Module</h5>
                                    <div className="space-y-1 ml-4 grid grid-cols-2 gap-2">
                                        <label className="flex items-center gap-2">
                                            <input type="checkbox" checked={formData.oracle_hr_group1_dhr} onChange={(e) => setFormData({ ...formData, oracle_hr_group1_dhr: e.target.checked })} className="w-4 h-4" />
                                            <span className="text-sm">Group 1: DHR</span>
                                        </label>
                                        <label className="flex items-center gap-2">
                                            <input type="checkbox" checked={formData.oracle_hr_group2_manager} onChange={(e) => setFormData({ ...formData, oracle_hr_group2_manager: e.target.checked })} className="w-4 h-4" />
                                            <span className="text-sm">Group 2: HR Manager</span>
                                        </label>
                                        <label className="flex items-center gap-2">
                                            <input type="checkbox" checked={formData.oracle_hr_group3_executive} onChange={(e) => setFormData({ ...formData, oracle_hr_group3_executive: e.target.checked })} className="w-4 h-4" />
                                            <span className="text-sm">Group 3: Executive</span>
                                        </label>
                                        <label className="flex items-center gap-2">
                                            <input type="checkbox" checked={formData.oracle_hr_group4_accommodation} onChange={(e) => setFormData({ ...formData, oracle_hr_group4_accommodation: e.target.checked })} className="w-4 h-4" />
                                            <span className="text-sm">Group 4: Accommodation</span>
                                        </label>
                                        <label className="flex items-center gap-2">
                                            <input type="checkbox" checked={formData.oracle_hr_group5_pr} onChange={(e) => setFormData({ ...formData, oracle_hr_group5_pr: e.target.checked })} className="w-4 h-4" />
                                            <span className="text-sm">Group 5: Public Relations</span>
                                        </label>
                                        <label className="flex items-center gap-2">
                                            <input type="checkbox" checked={formData.oracle_hr_group6_hiring} onChange={(e) => setFormData({ ...formData, oracle_hr_group6_hiring: e.target.checked })} className="w-4 h-4" />
                                            <span className="text-sm">Group 6: Hiring</span>
                                        </label>
                                        <label className="flex items-center gap-2">
                                            <input type="checkbox" checked={formData.oracle_hr_ess} onChange={(e) => setFormData({ ...formData, oracle_hr_ess: e.target.checked })} className="w-4 h-4" />
                                            <span className="text-sm">ESS User (Employee Self-Service)</span>
                                        </label>
                                    </div>
                                </div>

                                {/* Finance Module */}
                                <div className="mb-3">
                                    <h5 className="text-sm font-medium text-gray-700 mb-2">Finance Module</h5>
                                    <div className="space-y-1 ml-4 grid grid-cols-2 gap-2">
                                        <label className="flex items-center gap-2">
                                            <input type="checkbox" checked={formData.oracle_finance_ap} onChange={(e) => setFormData({ ...formData, oracle_finance_ap: e.target.checked })} className="w-4 h-4" />
                                            <span className="text-sm">AP (Accounts Payable)</span>
                                        </label>
                                        <label className="flex items-center gap-2">
                                            <input type="checkbox" checked={formData.oracle_finance_ar} onChange={(e) => setFormData({ ...formData, oracle_finance_ar: e.target.checked })} className="w-4 h-4" />
                                            <span className="text-sm">AR (Accounts Receivable)</span>
                                        </label>
                                        <label className="flex items-center gap-2">
                                            <input type="checkbox" checked={formData.oracle_finance_manager} onChange={(e) => setFormData({ ...formData, oracle_finance_manager: e.target.checked })} className="w-4 h-4" />
                                            <span className="text-sm">Finance Manager</span>
                                        </label>
                                        <label className="flex items-center gap-2">
                                            <input type="checkbox" checked={formData.oracle_finance_dm} onChange={(e) => setFormData({ ...formData, oracle_finance_dm: e.target.checked })} className="w-4 h-4" />
                                            <span className="text-sm">DM Finance</span>
                                        </label>
                                    </div>
                                </div>

                                {/* Procurement Module */}
                                <div>
                                    <h5 className="text-sm font-medium text-gray-700 mb-2">Procurement Module</h5>
                                    <div className="space-y-1 ml-4 grid grid-cols-2 gap-2">
                                        <label className="flex items-center gap-2">
                                            <input type="checkbox" checked={formData.oracle_procurement_buyer} onChange={(e) => setFormData({ ...formData, oracle_procurement_buyer: e.target.checked })} className="w-4 h-4" />
                                            <span className="text-sm">Group 3: Buyer</span>
                                        </label>
                                        <label className="flex items-center gap-2">
                                            <input type="checkbox" checked={formData.oracle_procurement_coordinator} onChange={(e) => setFormData({ ...formData, oracle_procurement_coordinator: e.target.checked })} className="w-4 h-4" />
                                            <span className="text-sm">Group 4: Coordinator</span>
                                        </label>
                                        <label className="flex items-center gap-2">
                                            <input type="checkbox" checked={formData.oracle_procurement_store} onChange={(e) => setFormData({ ...formData, oracle_procurement_store: e.target.checked })} className="w-4 h-4" />
                                            <span className="text-sm">Group 5: Store</span>
                                        </label>
                                        <label className="flex items-center gap-2">
                                            <input type="checkbox" checked={formData.oracle_procurement_receiver} onChange={(e) => setFormData({ ...formData, oracle_procurement_receiver: e.target.checked })} className="w-4 h-4" />
                                            <span className="text-sm">Group 6: Receiver</span>
                                        </label>
                                        <label className="flex items-center gap-2">
                                            <input type="checkbox" checked={formData.oracle_procurement_requestor} onChange={(e) => setFormData({ ...formData, oracle_procurement_requestor: e.target.checked })} className="w-4 h-4" />
                                            <span className="text-sm">Group 7: Requestor</span>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            {/* Timetec */}
                            <div className="bg-green-50 border border-green-200 rounded-lg p-4">
                                <h4 className="font-semibold text-gray-900 mb-3">Timetec Time Attendance</h4>
                                <div className="space-y-2 ml-4">
                                    <label className="flex items-center gap-2">
                                        <input type="checkbox" checked={formData.timetec_it_admin} onChange={(e) => setFormData({ ...formData, timetec_it_admin: e.target.checked })} className="w-4 h-4" />
                                        <span className="text-sm">Group 1: IT Admin</span>
                                    </label>
                                    <label className="flex items-center gap-2">
                                        <input type="checkbox" checked={formData.timetec_hr_admin} onChange={(e) => setFormData({ ...formData, timetec_hr_admin: e.target.checked })} className="w-4 h-4" />
                                        <span className="text-sm">Group 2: HR Admin</span>
                                    </label>
                                    <label className="flex items-center gap-2">
                                        <input type="checkbox" checked={formData.timetec_dept_coordinator} onChange={(e) => setFormData({ ...formData, timetec_dept_coordinator: e.target.checked })} className="w-4 h-4" />
                                        <span className="text-sm">Group 3: Dept Coordinator</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                    )}

                    {/* Step 3: IT Assets */}
                    {currentStep === 3 && (
                        <div className="space-y-4">
                            <h3 className="text-lg font-semibold text-gray-900 mb-4">🖥️ IT Assets Needed</h3>
                            <div className="grid grid-cols-2 gap-4">
                                {[
                                    { key: 'asset_laptop', label: 'Laptop', icon: Laptop },
                                    { key: 'asset_desktop', label: 'Desktop', icon: Monitor },
                                    { key: 'asset_mobile_camera', label: 'Mobile (with camera)', icon: Smartphone },
                                    { key: 'asset_mobile_non_camera', label: 'Mobile (non-camera)', icon: Smartphone },
                                    { key: 'asset_walkie_talkie', label: 'Walkie Talkie', icon: Radio },
                                    { key: 'asset_duty_sim', label: 'Duty SIM Card', icon: CreditCard }
                                ].map(({ key, label, icon: Icon }) => (
                                    <button
                                        key={key}
                                        onClick={() => setFormData({ ...formData, [key]: !formData[key] })}
                                        className={`p-4 border-2 rounded-lg transition flex items-center gap-3 ${formData[key] ? 'border-blue-600 bg-blue-50' : 'border-gray-300 hover:border-blue-400'
                                            }`}
                                    >
                                        <input
                                            type="checkbox"
                                            checked={formData[key]}
                                            onChange={() => { }}
                                            className="w-5 h-5 text-blue-600 rounded"
                                        />
                                        <Icon className="w-6 h-6 text-gray-700" />
                                        <span className="font-medium">{label}</span>
                                    </button>
                                ))}
                            </div>
                        </div>
                    )}

                    {/* Step 4: Priority & Notes */}
                    {currentStep === 4 && (
                        <div className="space-y-6">
                            <div>
                                <h3 className="text-lg font-semibold text-gray-900 mb-4">Set Priority</h3>
                                <div className="grid grid-cols-3 gap-4">
                                    {[
                                        { value: 'high', label: 'High', emoji: '🔴', desc: 'Urgent, starting today' },
                                        { value: 'medium', label: 'Medium', emoji: '🟡', desc: 'Standard, 2-3 days' },
                                        { value: 'low', label: 'Low', emoji: '🟢', desc: 'Non-urgent' }
                                    ].map(({ value, label, emoji, desc }) => (
                                        <button
                                            key={value}
                                            onClick={() => setFormData({ ...formData, priority: value })}
                                            className={`p-4 border-2 rounded-lg transition ${formData.priority === value ? getPriorityColor(value) + ' border-2' : 'border-gray-300 hover:bg-gray-50'
                                                }`}
                                        >
                                            <div className="text-3xl mb-2">{emoji}</div>
                                            <div className="font-semibold text-gray-900">{label}</div>
                                            <div className="text-xs text-gray-600 mt-1">{desc}</div>
                                        </button>
                                    ))}
                                </div>
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-2">Special Requirements / Notes</label>
                                <textarea
                                    value={formData.notes}
                                    onChange={(e) => setFormData({ ...formData, notes: e.target.value })}
                                    rows={4}
                                    placeholder="Add any special requirements or notes for IT..."
                                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                />
                            </div>
                        </div>
                    )}
                </div>

                {/* Footer */}
                <div className="p-6 border-t border-gray-200 bg-gray-50 flex justify-between">
                    <button
                        onClick={prevStep}
                        disabled={currentStep === 1}
                        className="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-100 disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-2"
                    >
                        <ChevronLeft className="w-5 h-5" />
                        Previous
                    </button>

                    {currentStep < 4 ? (
                        <button
                            onClick={nextStep}
                            disabled={!canProceed()}
                            className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-400 flex items-center gap-2"
                        >
                            Next
                            <ChevronRight className="w-5 h-5" />
                        </button>
                    ) : (
                        <button
                            onClick={handleSubmit}
                            disabled={loading}
                            className="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 disabled:bg-gray-400"
                        >
                            {loading ? 'Submitting...' : 'Submit Request'}
                        </button>
                    )}
                </div>
            </div>
        </div>
    );
}
