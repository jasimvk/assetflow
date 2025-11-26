import React from 'react';
import Head from 'next/head';
import Link from 'next/link';
import LandingLayout from '../../components/LandingLayout';
import {
    BarChart3,
    ShieldCheck,
    Zap,
    Smartphone,
    Users,
    Clock,
    ArrowRight,
    CheckCircle2,
    Key,
    Lock,
    FileText,
    UserCheck,
    Share2,
    PieChart
} from 'lucide-react';

const LandingPage = () => {
    return (
        <LandingLayout>
            <Head>
                <title>AssetFlow - Unified Access & Asset Management</title>
                <meta name="description" content="The ultimate Request Access Management System with connected Asset Management and Reporting." />
            </Head>

            {/* Hero Section */}
            <section className="relative pt-20 pb-24 overflow-hidden">
                <div className="absolute inset-0 bg-gradient-to-br from-slate-50 via-white to-blue-50 -z-10" />

                <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center relative z-10">
                    <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-white/50 border border-slate-200 shadow-sm mb-8 animate-fade-in">
                        <span className="flex h-2 w-2 rounded-full bg-primary-500 animate-pulse"></span>
                        <span className="text-sm font-medium text-slate-600">Unified Enterprise Platform</span>
                    </div>

                    <h1 className="text-5xl md:text-7xl font-extrabold text-slate-900 tracking-tight mb-8 leading-tight">
                        The Ultimate Request <br />
                        <span className="bg-clip-text text-transparent bg-gradient-to-r from-primary-600 to-purple-600">
                            Access Management System
                        </span>
                    </h1>

                    <p className="text-xl text-slate-600 max-w-2xl mx-auto mb-10 leading-relaxed">
                        Streamline approvals, manage system access, and track connected assets in one unified platform.
                        Say goodbye to siloed tools and spreadsheets.
                    </p>

                    <div className="flex flex-col sm:flex-row items-center justify-center gap-4 mb-16">
                        <Link
                            href="/"
                            className="w-full sm:w-auto px-8 py-4 bg-slate-900 text-white font-semibold rounded-xl hover:bg-slate-800 transition-all duration-300 shadow-lg hover:shadow-xl hover:-translate-y-1 flex items-center justify-center gap-2"
                        >
                            Demo Dashboard <ArrowRight className="w-5 h-5" />
                        </Link>
                    </div>

                    {/* Hero Visual: Glassmorphism Dashboard */}
                    <div className="relative mx-auto max-w-5xl mt-16 perspective-1000">
                        {/* Main Dashboard Card (Background) */}
                        <div className="relative z-10 bg-white/40 backdrop-blur-xl border border-white/50 rounded-2xl shadow-2xl overflow-hidden transform rotate-x-12 transition-transform duration-700 hover:rotate-x-0">
                            <div className="absolute inset-0 bg-gradient-to-br from-white/40 to-white/10 pointer-events-none" />

                            {/* Dashboard Header */}
                            <div className="h-12 border-b border-white/20 flex items-center px-6 gap-4">
                                <div className="flex gap-2">
                                    <div className="w-3 h-3 rounded-full bg-red-400/80" />
                                    <div className="w-3 h-3 rounded-full bg-yellow-400/80" />
                                    <div className="w-3 h-3 rounded-full bg-green-400/80" />
                                </div>
                                <div className="h-6 w-32 bg-white/30 rounded-full" />
                            </div>

                            {/* Dashboard Content Grid */}
                            <div className="p-6 grid grid-cols-3 gap-6">
                                {/* Sidebar Placeholder */}
                                <div className="col-span-1 space-y-3">
                                    <div className="h-8 w-full bg-white/30 rounded-lg" />
                                    <div className="h-4 w-3/4 bg-white/20 rounded-lg" />
                                    <div className="h-4 w-5/6 bg-white/20 rounded-lg" />
                                    <div className="h-4 w-4/5 bg-white/20 rounded-lg" />
                                </div>

                                {/* Main Content Area */}
                                <div className="col-span-2 space-y-4">
                                    <div className="flex gap-4">
                                        <div className="h-24 flex-1 bg-gradient-to-br from-purple-500/10 to-blue-500/10 rounded-xl border border-white/30" />
                                        <div className="h-24 flex-1 bg-gradient-to-br from-blue-500/10 to-cyan-500/10 rounded-xl border border-white/30" />
                                    </div>
                                    <div className="h-40 bg-white/20 rounded-xl border border-white/30" />
                                </div>
                            </div>
                        </div>

                        {/* Floating Element 1: Access Request */}
                        <div className="absolute -left-12 top-20 z-20 animate-float-slow">
                            <div className="animate-pop-in" style={{ animationDelay: '0.2s' }}>
                                <div className="bg-white/90 backdrop-blur-md p-4 rounded-2xl shadow-xl border border-white/50 w-64">
                                    <div className="flex items-center gap-3 mb-3">
                                        <div className="w-10 h-10 rounded-full bg-gradient-to-br from-purple-500 to-indigo-500 flex items-center justify-center text-white font-bold text-sm">
                                            JD
                                        </div>
                                        <div>
                                            <p className="text-xs font-bold text-slate-800">New Access Request</p>
                                            <p className="text-[10px] text-slate-500">John Doe • Engineering</p>
                                        </div>
                                    </div>
                                    <div className="flex gap-2">
                                        <div className="flex-1 py-1.5 bg-slate-900 text-white text-xs font-medium rounded-lg text-center">Approve</div>
                                        <div className="flex-1 py-1.5 bg-slate-100 text-slate-600 text-xs font-medium rounded-lg text-center">Deny</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        {/* Floating Element 2: Asset Status */}
                        <div className="absolute -right-8 bottom-12 z-20 animate-float-delayed">
                            <div className="animate-pop-in" style={{ animationDelay: '0.6s' }}>
                                <div className="bg-white/90 backdrop-blur-md p-4 rounded-2xl shadow-xl border border-white/50 w-56">
                                    <div className="flex items-center gap-3 mb-2">
                                        <div className="w-8 h-8 rounded-lg bg-blue-100 flex items-center justify-center">
                                            <Smartphone className="w-4 h-4 text-blue-600" />
                                        </div>
                                        <div>
                                            <p className="text-xs font-bold text-slate-800">Device Assigned</p>
                                            <p className="text-[10px] text-green-600 font-medium flex items-center gap-1">
                                                <CheckCircle2 className="w-3 h-3" /> Active
                                            </p>
                                        </div>
                                    </div>
                                    <div className="h-1.5 w-full bg-slate-100 rounded-full overflow-hidden">
                                        <div className="h-full w-3/4 bg-blue-500 rounded-full" />
                                    </div>
                                </div>
                            </div>
                        </div>

                        {/* Floating Element 3: Report Ready */}
                        <div className="absolute -left-8 bottom-24 z-20 animate-float-delayed hidden sm:block">
                            <div className="animate-pop-in" style={{ animationDelay: '1.0s' }}>
                                <div className="bg-slate-900/90 backdrop-blur-md p-3 rounded-2xl shadow-xl border border-slate-700 flex items-center gap-3">
                                    <div className="w-8 h-8 rounded-full bg-purple-500/20 flex items-center justify-center">
                                        <FileText className="w-4 h-4 text-purple-400" />
                                    </div>
                                    <div>
                                        <p className="text-xs font-bold text-white">Monthly Report</p>
                                        <p className="text-[10px] text-slate-400">Ready for download</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        {/* Floating Element 4: License Expiry (Center) */}
                        <div className="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 z-30 animate-pulse-slow">
                            <div className="animate-pop-in" style={{ animationDelay: '1.4s' }}>
                                <div className="bg-white/95 backdrop-blur-xl p-4 rounded-2xl shadow-2xl border border-red-100 flex flex-col items-center text-center w-48 transform hover:scale-105 transition-transform duration-300">
                                    <div className="w-10 h-10 rounded-full bg-red-50 flex items-center justify-center mb-2">
                                        <Clock className="w-5 h-5 text-red-500" />
                                    </div>
                                    <p className="text-xs font-bold text-slate-800">Adobe Creative Cloud</p>
                                    <p className="text-[10px] text-red-500 font-medium bg-red-50 px-2 py-0.5 rounded-full mt-1">
                                        Expires in 3 days
                                    </p>
                                    <button className="mt-3 w-full py-1.5 bg-slate-900 text-white text-[10px] font-medium rounded-lg hover:bg-slate-800 transition-colors">
                                        Renew License
                                    </button>
                                </div>
                            </div>
                        </div>

                        {/* Floating Element 5: Low Stock (Top Right) */}
                        <div className="absolute right-12 -top-6 z-20 animate-float-slow hidden sm:block">
                            <div className="animate-pop-in" style={{ animationDelay: '1.8s' }}>
                                <div className="bg-white/90 backdrop-blur-md p-3 rounded-2xl shadow-xl border border-white/50 flex items-center gap-3">
                                    <div className="w-8 h-8 rounded-full bg-orange-100 flex items-center justify-center">
                                        <BarChart3 className="w-4 h-4 text-orange-600" />
                                    </div>
                                    <div>
                                        <p className="text-xs font-bold text-slate-800">Low Stock Alert</p>
                                        <p className="text-[10px] text-slate-500">MacBook Air M2 (2 left)</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        {/* Background Glow Effects */}
                        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[120%] h-[120%] bg-gradient-to-r from-purple-400/30 via-blue-400/30 to-cyan-400/30 blur-3xl -z-10 rounded-full mix-blend-multiply" />
                    </div>
                </div>
            </section>

            {/* Core Feature 1: Request Access Management */}
            <section id="access" className="py-32 bg-white relative overflow-hidden">
                <div className="absolute top-0 left-0 w-full h-full overflow-hidden pointer-events-none">
                    <div className="absolute top-1/4 -left-64 w-96 h-96 bg-purple-100 rounded-full mix-blend-multiply filter blur-3xl opacity-70 animate-blob" />
                    <div className="absolute top-1/3 -right-64 w-96 h-96 bg-blue-100 rounded-full mix-blend-multiply filter blur-3xl opacity-70 animate-blob animation-delay-2000" />
                </div>

                <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
                    <div className="flex flex-col lg:flex-row items-center gap-20">
                        <div className="lg:w-1/2">
                            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-purple-50 text-purple-700 text-sm font-semibold mb-6 border border-purple-100 shadow-sm">
                                <ShieldCheck className="w-4 h-4" />
                                Core Module
                            </div>
                            <h2 className="text-4xl md:text-5xl font-bold text-slate-900 mb-6 leading-tight">
                                Seamless Access <br />
                                <span className="text-transparent bg-clip-text bg-gradient-to-r from-purple-600 to-indigo-600">Request Management</span>
                            </h2>
                            <p className="text-lg text-slate-600 mb-8 leading-relaxed">
                                Empower your workforce with a self-service portal for system access.
                                Automate approval workflows based on roles, departments, or security levels.
                            </p>

                            <ul className="space-y-5">
                                {[
                                    "Customizable approval workflows",
                                    "Role-based access control (RBAC)",
                                    "Automated provisioning & de-provisioning",
                                    "Audit trails for compliance"
                                ].map((item, idx) => (
                                    <li key={idx} className="flex items-center gap-3 group">
                                        <div className="w-6 h-6 rounded-full bg-purple-100 flex items-center justify-center group-hover:bg-purple-600 transition-colors duration-300">
                                            <CheckCircle2 className="w-4 h-4 text-purple-600 group-hover:text-white transition-colors duration-300" />
                                        </div>
                                        <span className="text-slate-700 font-medium group-hover:text-purple-900 transition-colors">{item}</span>
                                    </li>
                                ))}
                            </ul>
                        </div>
                        <div className="lg:w-1/2 w-full">
                            <div className="relative">
                                <div className="absolute inset-0 bg-gradient-to-br from-purple-600 to-indigo-600 rounded-3xl blur-2xl opacity-20 transform rotate-3 scale-105" />
                                <div className="bg-white/60 backdrop-blur-xl rounded-3xl p-8 border border-white/50 shadow-2xl relative">
                                    <div className="space-y-6">
                                        {/* Mock Approval Flow UI */}
                                        <div className="bg-white p-5 rounded-2xl shadow-lg border border-slate-100 flex items-center justify-between transform transition-transform hover:-translate-y-1 duration-300">
                                            <div className="flex items-center gap-4">
                                                <div className="w-12 h-12 rounded-full bg-gradient-to-br from-slate-100 to-slate-200 flex items-center justify-center text-slate-600 font-bold text-lg shadow-inner">JD</div>
                                                <div>
                                                    <p className="text-base font-bold text-slate-900">John Doe</p>
                                                    <p className="text-sm text-slate-500">Requested access to <span className="text-purple-600 font-semibold">AWS Production</span></p>
                                                </div>
                                            </div>
                                            <span className="px-3 py-1 bg-yellow-100 text-yellow-700 text-xs font-bold rounded-full border border-yellow-200">Pending</span>
                                        </div>

                                        <div className="flex justify-center py-2">
                                            <div className="w-0.5 h-8 bg-slate-200 relative">
                                                <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-2 h-2 bg-slate-300 rounded-full" />
                                            </div>
                                        </div>

                                        <div className="bg-white/80 p-5 rounded-2xl shadow-sm border border-slate-100 flex items-center justify-between">
                                            <div className="flex items-center gap-4">
                                                <div className="w-12 h-12 rounded-full bg-blue-50 flex items-center justify-center text-blue-600 font-bold shadow-sm">
                                                    <ShieldCheck className="w-6 h-6" />
                                                </div>
                                                <div>
                                                    <p className="text-base font-bold text-slate-900">Security Team</p>
                                                    <p className="text-sm text-slate-500">Approval Step 1</p>
                                                </div>
                                            </div>
                                            <div className="flex gap-2">
                                                <button className="px-4 py-2 bg-slate-900 text-white text-xs font-bold rounded-lg hover:bg-slate-800 transition-colors shadow-md">Approve</button>
                                                <button className="px-4 py-2 bg-white text-slate-600 border border-slate-200 text-xs font-bold rounded-lg hover:bg-slate-50 transition-colors">Deny</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            {/* Core Feature 2: Connected Asset Management */}
            <section id="assets" className="py-32 bg-slate-50 relative overflow-hidden">
                <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
                    <div className="flex flex-col lg:flex-row-reverse items-center gap-20">
                        <div className="lg:w-1/2">
                            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-blue-100 text-blue-700 text-sm font-semibold mb-6 border border-blue-200">
                                <Share2 className="w-4 h-4" />
                                Connected Module
                            </div>
                            <h2 className="text-4xl md:text-5xl font-bold text-slate-900 mb-6 leading-tight">
                                Integrated <br />
                                <span className="text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-cyan-600">Asset Management</span>
                            </h2>
                            <p className="text-lg text-slate-600 mb-8 leading-relaxed">
                                Don't just manage access—manage the devices they access from.
                                Link physical assets to user profiles for a complete view of your inventory.
                            </p>

                            <ul className="space-y-5">
                                {[
                                    "Track laptops, mobiles, and hardware",
                                    "Assign assets to users during onboarding",
                                    "Monitor asset health and maintenance",
                                    "Real-time inventory tracking"
                                ].map((item, idx) => (
                                    <li key={idx} className="flex items-center gap-3 group">
                                        <div className="w-6 h-6 rounded-full bg-blue-100 flex items-center justify-center group-hover:bg-blue-600 transition-colors duration-300">
                                            <CheckCircle2 className="w-4 h-4 text-blue-600 group-hover:text-white transition-colors duration-300" />
                                        </div>
                                        <span className="text-slate-700 font-medium group-hover:text-blue-900 transition-colors">{item}</span>
                                    </li>
                                ))}
                            </ul>
                        </div>
                        <div className="lg:w-1/2 w-full">
                            <div className="relative group">
                                <div className="absolute inset-0 bg-gradient-to-br from-blue-500 to-cyan-500 rounded-3xl blur-2xl opacity-20 transform -rotate-3 scale-105 transition-opacity duration-500 group-hover:opacity-30" />
                                <div className="bg-white rounded-3xl shadow-2xl border border-slate-200 overflow-hidden relative transform transition-transform duration-500 group-hover:scale-[1.02]">
                                    <div className="bg-slate-50/80 backdrop-blur px-6 py-4 border-b border-slate-200 flex items-center justify-between">
                                        <div className="flex items-center gap-3">
                                            <div className="w-8 h-8 rounded-lg bg-white border border-slate-200 flex items-center justify-center shadow-sm">
                                                <BarChart3 className="w-4 h-4 text-slate-600" />
                                            </div>
                                            <span className="font-bold text-slate-700">Asset Inventory</span>
                                        </div>
                                        <div className="flex gap-2">
                                            <div className="w-3 h-3 rounded-full bg-red-400"></div>
                                            <div className="w-3 h-3 rounded-full bg-yellow-400"></div>
                                            <div className="w-3 h-3 rounded-full bg-green-400"></div>
                                        </div>
                                    </div>
                                    <div className="p-6 bg-white">
                                        <div className="space-y-3">
                                            {[1, 2, 3].map((_, i) => (
                                                <div key={i} className="flex items-center justify-between p-4 hover:bg-slate-50 rounded-xl transition-all duration-300 border border-transparent hover:border-slate-200 hover:shadow-sm cursor-default group/item">
                                                    <div className="flex items-center gap-4">
                                                        <div className="w-12 h-12 bg-slate-100 rounded-xl flex items-center justify-center group-hover/item:bg-white group-hover/item:shadow-md transition-all">
                                                            <Smartphone className="w-6 h-6 text-slate-500 group-hover/item:text-blue-600 transition-colors" />
                                                        </div>
                                                        <div>
                                                            <p className="text-sm font-bold text-slate-900">MacBook Pro M2</p>
                                                            <p className="text-xs text-slate-500 font-mono">SN: XYZ-123-{i}</p>
                                                        </div>
                                                    </div>
                                                    <span className="text-xs font-bold text-green-700 bg-green-50 border border-green-100 px-3 py-1 rounded-full">Assigned</span>
                                                </div>
                                            ))}
                                        </div>
                                    </div>

                                    {/* Floating Badge */}
                                    <div className="absolute bottom-6 right-6 bg-white p-4 rounded-2xl shadow-xl border border-orange-100 animate-float-delayed hidden sm:block">
                                        <div className="flex items-center gap-3">
                                            <div className="w-10 h-10 rounded-full bg-orange-50 flex items-center justify-center">
                                                <Zap className="w-5 h-5 text-orange-500" />
                                            </div>
                                            <div>
                                                <p className="text-xs font-bold text-slate-800">Low Stock Alert</p>
                                                <p className="text-[10px] text-slate-500">Order more devices</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            {/* Core Feature 3: Reporting */}
            <section id="reports" className="py-32 bg-slate-900 text-white relative overflow-hidden">
                <div className="absolute top-0 right-0 w-2/3 h-full bg-gradient-to-l from-primary-900/40 to-transparent pointer-events-none" />
                <div className="absolute bottom-0 left-0 w-1/2 h-1/2 bg-gradient-to-t from-purple-900/20 to-transparent pointer-events-none" />

                <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
                    <div className="text-center max-w-3xl mx-auto mb-20">
                        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-slate-800/50 text-slate-300 border border-slate-700/50 text-sm font-semibold mb-6 backdrop-blur-sm">
                            <PieChart className="w-4 h-4" />
                            Intelligence
                        </div>
                        <h2 className="text-4xl md:text-5xl font-bold mb-6 bg-clip-text text-transparent bg-gradient-to-r from-white to-slate-400">
                            Powerful Reporting & Analytics
                        </h2>
                        <p className="text-lg text-slate-400 leading-relaxed">
                            Gain deep insights into system usage, asset utilization, and compliance status.
                            Make data-driven decisions with real-time dashboards.
                        </p>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                        {[
                            {
                                title: "Access Audits",
                                desc: "Who accessed what and when? Get detailed logs for security compliance.",
                                icon: FileText,
                                color: "text-blue-400",
                                bg: "bg-blue-500/10"
                            },
                            {
                                title: "Asset Utilization",
                                desc: "Identify underused assets and optimize your procurement strategy.",
                                icon: BarChart3,
                                color: "text-purple-400",
                                bg: "bg-purple-500/10"
                            },
                            {
                                title: "Cost Analysis",
                                desc: "Track spending on software licenses and hardware maintenance.",
                                icon: PieChart,
                                color: "text-green-400",
                                bg: "bg-green-500/10"
                            }
                        ].map((feature, idx) => (
                            <div key={idx} className="group bg-slate-800/30 backdrop-blur-sm border border-slate-700/50 p-8 rounded-3xl hover:bg-slate-800/80 transition-all duration-500 hover:-translate-y-2 hover:shadow-2xl hover:shadow-primary-900/20">
                                <div className={`w-14 h-14 rounded-2xl ${feature.bg} flex items-center justify-center mb-6 group-hover:scale-110 transition-transform duration-500`}>
                                    <feature.icon className={`w-7 h-7 ${feature.color}`} />
                                </div>
                                <h3 className="text-xl font-bold mb-3 text-white group-hover:text-primary-400 transition-colors">{feature.title}</h3>
                                <p className="text-slate-400 leading-relaxed group-hover:text-slate-300 transition-colors">
                                    {feature.desc}
                                </p>
                            </div>
                        ))}
                    </div>
                </div>
            </section>

            {/* CTA Section */}
            <section className="py-32 bg-white relative overflow-hidden">
                <div className="absolute inset-0 bg-gradient-to-b from-white via-slate-50 to-slate-100" />
                <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[800px] bg-gradient-to-r from-primary-200/30 to-purple-200/30 rounded-full blur-3xl opacity-50 pointer-events-none" />

                <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center relative z-10">
                    <h2 className="text-5xl md:text-6xl font-bold text-slate-900 mb-8 tracking-tight">
                        One System. <br />
                        <span className="text-transparent bg-clip-text bg-gradient-to-r from-primary-600 to-purple-600">Total Control.</span>
                    </h2>
                    <p className="text-xl text-slate-600 mb-12 max-w-2xl mx-auto leading-relaxed">
                        Join the future of enterprise management. Secure access, manage assets, and report with confidence.
                    </p>
                    <div className="flex flex-col sm:flex-row items-center justify-center gap-6">
                        <Link
                            href="/"
                            className="w-full sm:w-auto px-10 py-5 bg-slate-900 text-white font-bold rounded-2xl hover:bg-slate-800 transition-all duration-300 shadow-xl hover:shadow-2xl hover:-translate-y-1 flex items-center justify-center gap-3 group"
                        >
                            Demo Dashboard <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
                        </Link>
                    </div>
                </div>
            </section>
        </LandingLayout>
    );
};

export default LandingPage;
