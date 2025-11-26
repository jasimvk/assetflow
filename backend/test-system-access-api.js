/**
 * System Access API Test Script
 * Run with: node backend/test-system-access-api.js
 */

const API_BASE = 'http://localhost:3002/api/system-access';
const AUTH_TOKEN = 'admin@assetflow.com:admin:IT:user-admin-001'; // Mock auth token format: email:role:department:userId

// Test data
const testRequest = {
    employee_first_name: "John",
    employee_last_name: "Doe",
    employee_id: "EMP001",
    entra_id: "j.doe@1hospitality.ae",
    department: "IT",
    department_head: "Jane Smith",
    email: "john.doe@example.com",
    date_of_joining: "2025-01-15",
    priority: "high",
    notes: "Urgent setup required for new employee",
    request_type: "both",

    // Network & Email Access
    network_email: {
        network_login: true,
        email_generic: false,
        email_personal: true
    },

    // Oracle Fusion ERP Access
    oracle_fusion: {
        it_admin_access: false,
        it_department: false,
        // HR Module
        hr_group_1_dhr: true,
        hr_group_2_hr_manager: false,
        hr_group_3_executive: false,
        hr_group_4_accommodation: false,
        hr_group_5_public_relations: false,
        hr_group_6_hiring: false,
        hr_ess_user: true,
        // Finance Module
        finance_ap: true,
        finance_ar: false,
        finance_manager: false,
        finance_dm_finance: false,
        // Procurement Module
        procurement_group_3_buyer: false,
        procurement_group_4_coordinator: false,
        procurement_group_5_store: false,
        procurement_group_6_receiver: false,
        procurement_group_7_requestor: true
    },

    // Timetec Access
    timetec: {
        group_1_it_admin: false,
        group_2_hr_admin: false,
        group_3_dept_coordinator: true
    },

    // Hardware Requests
    hardware_requests: [
        { asset_type: "Laptop" },
        { asset_type: "Mobile (Camera)" }
    ]
};

// Helper function for API calls
async function apiCall(endpoint, options = {}) {
    const url = endpoint.startsWith('http') ? endpoint : `${API_BASE}${endpoint}`;
    const response = await fetch(url, {
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${AUTH_TOKEN}`,
            ...options.headers
        },
        ...options
    });

    const data = await response.json();
    return { status: response.status, data, ok: response.ok };
}

// Test functions
async function test1_CreateRequest() {
    console.log('\n📝 TEST 1: Create New Request (POST /)');
    console.log('='.repeat(60));

    const result = await apiCall('/', {
        method: 'POST',
        body: JSON.stringify(testRequest)
    });

    if (result.ok) {
        console.log('✅ Success!');
        console.log('Request Number:', result.data.request.request_number);
        console.log('Request ID:', result.data.request.id);
        console.log('Status:', result.data.request.status);
        return result.data.request.id;
    } else {
        console.log('❌ Failed:', result.data.error);
        console.log('Details:', result.data.details);
        return null;
    }
}

async function test2_GetAllRequests() {
    console.log('\n📋 TEST 2: Get All Requests (GET /)');
    console.log('='.repeat(60));

    const result = await apiCall('/?page=1&limit=10');

    if (result.ok) {
        console.log('✅ Success!');
        console.log('Total Requests:', result.data.data.length);
        console.log('First Request:', result.data.data[0]?.request_number || 'None');
        if (result.data.pagination) {
            console.log('Pagination:', result.data.pagination);
        }
    } else {
        console.log('❌ Failed:', result.data.error);
    }
}

async function test3_GetRequestDetails(requestId) {
    console.log('\n🔍 TEST 3: Get Request Details (GET /:id)');
    console.log('='.repeat(60));

    if (!requestId) {
        console.log('⚠️  Skipped - No request ID from previous test');
        return;
    }

    const result = await apiCall(`/${requestId}`);

    if (result.ok) {
        console.log('✅ Success!');
        console.log('Request Number:', result.data.request_number);
        console.log('Employee:', result.data.employee_first_name, result.data.employee_last_name);
        console.log('Priority:', result.data.priority);
        console.log('Status:', result.data.status);
        console.log('\nRelated Data:');
        console.log('  - Network/Email:', result.data.network_email ? 'Yes' : 'No');
        console.log('  - Oracle Fusion:', result.data.oracle_fusion ? 'Yes' : 'No');
        console.log('  - Timetec:', result.data.timetec ? 'Yes' : 'No');
        console.log('  - Hardware Items:', result.data.asset_handovers?.length || 0);
        console.log('  - History Entries:', result.data.history?.length || 0);
    } else {
        console.log('❌ Failed:', result.data.error);
    }
}

async function test4_GetStatistics() {
    console.log('\n📊 TEST 4: Get Statistics (GET /stats/summary)');
    console.log('='.repeat(60));

    const result = await apiCall('/stats/summary');

    if (result.ok) {
        console.log('✅ Success!');
        console.log('Total:', result.data.total);
        console.log('Pending:', result.data.pending);
        console.log('Approved:', result.data.approved);
        console.log('Rejected:', result.data.rejected);
        console.log('In Progress:', result.data.in_progress);
    } else {
        console.log('❌ Failed:', result.data.error);
    }
}

async function test5_GetAvailableAssets() {
    console.log('\n💻 TEST 5: Get Available Assets (GET /assets/available/:type)');
    console.log('='.repeat(60));

    const assetTypes = ['Laptop', 'Monitor', 'Phone'];

    for (const type of assetTypes) {
        const result = await apiCall(`/assets/available/${type}`);

        if (result.ok) {
            console.log(`✅ ${type}: ${result.data.assets?.length || 0} available`);
        } else {
            console.log(`❌ ${type}: Failed -`, result.data.error);
        }
    }
}

async function test6_ApproveRequest(requestId) {
    console.log('\n✅ TEST 6: Approve Request (PATCH /:id/status)');
    console.log('='.repeat(60));

    if (!requestId) {
        console.log('⚠️  Skipped - No request ID from previous test');
        return;
    }

    const result = await apiCall(`/${requestId}/status`, {
        method: 'PATCH',
        body: JSON.stringify({
            status: 'approved',
            comments: 'Test approval - all requirements met'
        })
    });

    if (result.ok) {
        console.log('✅ Success!');
        console.log('New Status:', result.data.request.status);
        console.log('Approved By:', result.data.request.approved_by);
        console.log('Approval Date:', result.data.request.approval_date);
    } else {
        console.log('❌ Failed:', result.data.error);
    }
}

async function test7_RejectRequest(requestId) {
    console.log('\n❌ TEST 7: Reject Request (PATCH /:id/status)');
    console.log('='.repeat(60));

    if (!requestId) {
        console.log('⚠️  Skipped - No request ID from previous test');
        return;
    }

    const result = await apiCall(`/${requestId}/status`, {
        method: 'PATCH',
        body: JSON.stringify({
            status: 'rejected',
            rejection_reason: 'Insufficient justification provided'
        })
    });

    if (result.ok) {
        console.log('✅ Success!');
        console.log('New Status:', result.data.request.status);
        console.log('Rejection Reason:', result.data.request.rejection_reason);
    } else {
        console.log('❌ Failed:', result.data.error);
    }
}

async function test8_SearchAndFilter() {
    console.log('\n🔍 TEST 8: Search and Filter (GET / with params)');
    console.log('='.repeat(60));

    // Test 1: Filter by status
    const byStatus = await apiCall('/?status=pending');
    console.log('By Status (pending):', byStatus.ok ? `✅ ${byStatus.data.data?.length || 0} results` : '❌ Failed');

    // Test 2: Filter by department
    const byDept = await apiCall('/?department=IT');
    console.log('By Department (IT):', byDept.ok ? `✅ ${byDept.data.data?.length || 0} results` : '❌ Failed');

    // Test 3: Search
    const bySearch = await apiCall('/?search=john');
    console.log('By Search (john):', bySearch.ok ? `✅ ${bySearch.data.data?.length || 0} results` : '❌ Failed');
}

// Main test runner
async function runAllTests() {
    console.log('\n🧪 SYSTEM ACCESS API TEST SUITE');
    console.log('='.repeat(60));
    console.log('Testing API at:', API_BASE);
    console.log('Time:', new Date().toLocaleString());

    let createdRequestId = null;

    try {
        // Run tests sequentially
        createdRequestId = await test1_CreateRequest();
        await test2_GetAllRequests();
        await test3_GetRequestDetails(createdRequestId);
        await test4_GetStatistics();
        await test5_GetAvailableAssets();
        await test8_SearchAndFilter();

        // Approval/Rejection tests (only if we have a request ID)
        if (createdRequestId) {
            console.log('\n⚠️  Note: The following tests will modify the request status');
            await test6_ApproveRequest(createdRequestId);
            // Uncomment to test rejection (will overwrite approval)
            // await test7_RejectRequest(createdRequestId);
        }

        console.log('\n' + '='.repeat(60));
        console.log('✅ Test Suite Completed!');
        console.log('='.repeat(60));

    } catch (error) {
        console.error('\n❌ Test Suite Error:', error.message);
        console.error(error);
    }
}

// Run tests
runAllTests();
