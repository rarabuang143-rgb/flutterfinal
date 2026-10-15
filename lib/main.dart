import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final AppointmentStore appointmentStore = AppointmentStore();

void main() {
  runApp(const MyApp());
}

class AppointmentStore {
  final List<Appointment> appointments = [
    const Appointment(
      id: 1,
      residentName: 'Maria Santos',
      service: 'Barangay Clearance',
      date: '2026-10-16',
      time: '09:00 AM',
      status: 'Pending',
      isApiProvided: false,
    ),
    const Appointment(
      id: 2,
      residentName: 'Juan Dela Cruz',
      service: 'ID Assistance',
      date: '2026-10-16',
      time: '10:30 AM',
      status: 'Booked',
      isApiProvided: false,
    ),
    const Appointment(
      id: 3,
      residentName: 'Ana Reyes',
      service: 'Business Permit',
      date: '2026-10-17',
      time: '01:15 PM',
      status: 'Approved',
      isApiProvided: false,
    ),
    const Appointment(
      id: 4,
      residentName: 'Pedro Tan',
      service: 'Certificate of Residency',
      date: '2026-10-18',
      time: '08:45 AM',
      status: 'Pending',
      isApiProvided: false,
    ),
  ];

  void replaceAll(List<Appointment> newAppointments) {
    appointments.clear();
    appointments.addAll(newAppointments);
  }

  void add(Appointment appointment) {
    appointments.insert(0, appointment);
  }

  void removeById(int id) {
    appointments.removeWhere((appointment) => appointment.id == id);
  }

  void approveById(int id) {
    final index = appointments.indexWhere((appointment) => appointment.id == id);
    if (index == -1) return;

    final current = appointments[index];
    appointments[index] = Appointment(
      id: current.id,
      residentName: current.residentName,
      service: current.service,
      date: current.date,
      time: current.time,
      status: 'Approved',
      isApiProvided: current.isApiProvided,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barangay Appointment Scheduling System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.light),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F7F2),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F6F43),
          foregroundColor: Colors.white,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.isAdminAccess = false});

  final bool isAdminAccess;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'admin');
  final _passwordController = TextEditingController(text: 'barangay123');

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      final enteredUser = _usernameController.text.trim();
      final enteredPass = _passwordController.text.trim();

      if (enteredUser.toLowerCase() == 'admin' && enteredPass == 'barangay123') {
        if (widget.isAdminAccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminDashboardPage(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AppointmentsHomePage()),
          );
        }
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password. Try admin / barangay123')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F2),
      appBar: AppBar(
        title: const Text('Barangay Appointment Scheduling System'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Admin Login',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF123E2B)),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sign in to manage appointments',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Please enter username' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Please enter password' : null,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _login,
                          icon: const Icon(Icons.login),
                          label: const Text('Login'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF1F6F43),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const AppointmentsHomePage()),
                            );
                          },
                          child: const Text('Continue to schedule'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Appointment {
  const Appointment({
    required this.id,
    required this.residentName,
    required this.service,
    required this.date,
    required this.time,
    required this.status,
    required this.isApiProvided,
  });

  final int id;
  final String residentName;
  final String service;
  final String date;
  final String time;
  final String status;
  final bool isApiProvided;
}

class BookingFormResult {
  const BookingFormResult({required this.appointment, this.isDeleted = false});

  final Appointment appointment;
  final bool isDeleted;
}

class AppointmentsHomePage extends StatefulWidget {
  const AppointmentsHomePage({super.key});

  @override
  State<AppointmentsHomePage> createState() => _AppointmentsHomePageState();
}

class _AppointmentsHomePageState extends State<AppointmentsHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _serviceOptions = const [
    'Barangay Clearance',
    'ID Assistance',
    'Business Permit',
    'Certificate of Residency',
    'Complaint Filing',
    'Community Support',
  ];

  List<Appointment> _appointments = appointmentStore.appointments;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAppointments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final fetchedAppointments = await fetchAppointments();
      appointmentStore.replaceAll(fetchedAppointments);
      setState(() {
        _appointments = appointmentStore.appointments;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  Future<List<Appointment>> fetchAppointments() async {
    final usersResponse = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users?_limit=4'),
    );
    final todosResponse = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/todos?_limit=6'),
    );

    if (usersResponse.statusCode != 200 || todosResponse.statusCode != 200) {
      throw Exception('Unable to load appointment data right now. Please try again.');
    }

    final users = jsonDecode(usersResponse.body) as List;
    final todos = jsonDecode(todosResponse.body) as List;

    final List<Appointment> loaded = [];
    for (var i = 0; i < todos.length; i++) {
      final user = users[i % users.length];
      final todo = todos[i];
      loaded.add(
        Appointment(
          id: int.tryParse(todo['id'].toString()) ?? i + 1,
          residentName: user['name'] as String,
          service: _serviceOptions[i % _serviceOptions.length],
          date: _dateForIndex(i),
          time: _timeForIndex(i),
          status: todo['completed'] as bool ? 'Approved' : 'Pending',
          isApiProvided: true,
        ),
      );
    }

    return loaded;
  }

  List<Appointment> get filteredAppointments {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return _appointments;
    }

    return _appointments.where((appointment) {
      final matchesResident = appointment.residentName.toLowerCase().contains(query);
      final matchesService = appointment.service.toLowerCase().contains(query);
      return matchesResident || matchesService;
    }).toList();
  }

  Future<void> _openBookingForm({Appointment? appointment}) async {
    final result = await Navigator.push<BookingFormResult>(
      context,
      MaterialPageRoute(builder: (context) => BookingFormScreen(appointment: appointment)),
    );

    if (!mounted || result == null) return;

    if (result.isDeleted) {
      appointmentStore.removeById(result.appointment.id);
      setState(() {
        _appointments = appointmentStore.appointments;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment deleted for ${result.appointment.residentName}')),
      );
      return;
    }

    final index = appointmentStore.appointments.indexWhere((entry) => entry.id == result.appointment.id);
    if (index == -1) {
      appointmentStore.add(result.appointment);
    } else {
      appointmentStore.appointments[index] = result.appointment;
    }

    setState(() {
      _appointments = appointmentStore.appointments;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          appointment != null ? 'Appointment updated successfully.' : 'New appointment added successfully.',
        ),
      ),
    );
  }

  Future<void> _deleteAppointment(Appointment appointment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete appointment?'),
        content: Text(
          'This will remove ${appointment.residentName} from the schedule for ${appointment.service}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (confirmed == true) {
      appointmentStore.removeById(appointment.id);
      setState(() {
        _appointments = appointmentStore.appointments;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment deleted.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayedAppointments = filteredAppointments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barangay Appointment Scheduling System'),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            tooltip: 'Admin dashboard',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(isAdminAccess: true),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.event_available),
            tooltip: 'Refresh schedule',
            onPressed: _loadAppointments,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroPanel(
                onAdd: _openBookingForm,
                onAdmin: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(isAdminAccess: true),
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search appointment or service',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const SectionTitle(title: "Today's schedule"),
              const SizedBox(height: 12),
              if (_isLoading)
                const SizedBox(
                  height: 220,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_errorMessage != null)
                ErrorPanel(message: _errorMessage!)
              else if (displayedAppointments.isEmpty)
                const EmptyStateCard()
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayedAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = displayedAppointments[index];
                    return AppointmentCard(
                      appointment: appointment,
                      onEdit: () => _openBookingForm(appointment: appointment),
                      onDelete: () => _deleteAppointment(appointment),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _dateForIndex(int index) {
    final date = DateTime.now().add(Duration(days: index + 1));
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _timeForIndex(int index) {
    const availableTimes = [
      '08:30 AM',
      '09:15 AM',
      '10:00 AM',
      '11:45 AM',
      '01:30 PM',
      '02:15 PM',
    ];
    return availableTimes[index % availableTimes.length];
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.onAdd, required this.onAdmin});

  final VoidCallback onAdd;
  final VoidCallback onAdmin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF123E2B), Color(0xFF1F6F43)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good day, Barangay Staff!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Manage appointments, keep residents informed, and provide quick scheduling support.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    FilledButton.icon(
                      onPressed: onAdd,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1F6F43),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text('Add appointment'),
                    ),
                    OutlinedButton.icon(
                      onPressed: onAdmin,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.admin_panel_settings_outlined),
                      label: const Text('Admin'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.calendar_month,
              color: Colors.white,
              size: 42,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0F2D1F),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onEdit,
    required this.onDelete,
  });

  final Appointment appointment;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isApproved = appointment.status == 'Approved';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isApproved ? Colors.green.shade100 : Colors.orange.shade100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isApproved ? Icons.check_circle : Icons.pending_actions,
              color: isApproved ? Colors.green.shade800 : Colors.orange.shade800,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        appointment.residentName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF163724),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isApproved ? Colors.green.shade50 : Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        appointment.status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isApproved ? Colors.green.shade800 : Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.badge_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(appointment.service),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(appointment.date),
                    const SizedBox(width: 12),
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(appointment.time),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit'),
                        style: TextButton.styleFrom(foregroundColor: const Color(0xFF1F6F43)),
                      ),
                      TextButton.icon(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete'),
                        style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  List<Appointment> get _appointments => appointmentStore.appointments;

  List<Appointment> get _pendingAppointments {
    return _appointments
        .where((appointment) => appointment.status.toLowerCase() == 'pending' || appointment.status.toLowerCase() == 'booked')
        .toList();
  }

  void _acceptAppointment(Appointment appointment) {
    appointmentStore.approveById(appointment.id);
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Appointment accepted for ${appointment.residentName}.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = [
      {'label': 'Total appointments', 'value': _appointments.length.toString(), 'color': const Color(0xFF1F6F43)},
      {'label': 'Pending review', 'value': _pendingAppointments.length.toString(), 'color': const Color(0xFFCA8A04)},
      {'label': 'Approved today', 'value': _appointments.where((a) => a.status == 'Approved').length.toString(), 'color': const Color(0xFF0F766E)},
      {'label': 'Residents served', 'value': '${_appointments.length + 10}', 'color': const Color(0xFF1D4ED8)},
    ];

    final alerts = [
      '4 residents waiting for barangay clearance updates.',
      '2 business permit requests need verification.',
      'ID assistance queue is heavy this afternoon.',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Operations overview',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF123E2B)),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.8,
                ),
                itemCount: stats.length,
                itemBuilder: (context, index) {
                  final item = stats[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: item['color'] as Color,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['label'] as String,
                          style: const TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['value'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 22),
              const SectionTitle(title: 'Pending appointments'),
              const SizedBox(height: 12),
              if (_pendingAppointments.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text('No pending appointments at the moment.'),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _pendingAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = _pendingAppointments[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  appointment.residentName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  appointment.status,
                                  style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(appointment.service),
                          const SizedBox(height: 4),
                          Text('${appointment.date} • ${appointment.time}'),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FilledButton.icon(
                              onPressed: () => _acceptAppointment(appointment),
                              icon: const Icon(Icons.check_circle_outline),
                              label: const Text('Accept'),
                              style: FilledButton.styleFrom(backgroundColor: const Color(0xFF1F6F43)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              const SizedBox(height: 22),
              const SectionTitle(title: 'Quick actions'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ServiceManagementPage()),
                        );
                      },
                      icon: const Icon(Icons.miscellaneous_services),
                      label: const Text('Manage services'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const SectionTitle(title: 'Priority alerts'),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_active, color: Color(0xFF1F6F43)),
                        const SizedBox(width: 10),
                        Expanded(child: Text(alerts[index])),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceManagementPage extends StatefulWidget {
  const ServiceManagementPage({super.key});

  @override
  State<ServiceManagementPage> createState() => _ServiceManagementPageState();
}

class _ServiceManagementPageState extends State<ServiceManagementPage> {
  final List<Map<String, dynamic>> _services = [
    {'name': 'Barangay Clearance', 'active': true},
    {'name': 'ID Assistance', 'active': true},
    {'name': 'Business Permit', 'active': false},
    {'name': 'Certificate of Residency', 'active': true},
    {'name': 'Complaint Filing', 'active': true},
  ];

  Future<void> _showServiceDialog({int? index, String? initialName, bool initialActive = true}) async {
    final controller = TextEditingController(text: initialName ?? '');
    final formKey = GlobalKey<FormState>();
    bool active = initialActive;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(index == null ? 'Add service' : 'Edit service'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: 'Service name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.trim().isEmpty ? 'Please enter a service name' : null,
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Available for booking'),
                      value: active,
                      onChanged: (value) {
                        setDialogState(() {
                          active = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context, true);
                    }
                  },
                  child: Text(index == null ? 'Add' : 'Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true) {
      final newName = controller.text.trim();
      if (newName.isEmpty) return;

      setState(() {
        if (index == null) {
          _services.add({'name': newName, 'active': active});
        } else {
          _services[index] = {'name': newName, 'active': active};
        }
      });
    }
  }

  Future<void> _deleteService(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete service?'),
        content: const Text('This will remove the service from the list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _services.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Management'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showServiceDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add service'),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(18),
          itemCount: _services.length,
          itemBuilder: (context, index) {
            final service = _services[index];
            final serviceName = service['name'] as String;
            final isActive = service['active'] as bool;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          serviceName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isActive ? 'Available for booking' : 'Currently paused',
                          style: TextStyle(
                            color: isActive ? Colors.green.shade700 : Colors.red.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isActive,
                    activeThumbColor: const Color(0xFF1F6F43),
                    onChanged: (value) {
                      setState(() {
                        _services[index]['active'] = value;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _showServiceDialog(
                      index: index,
                      initialName: serviceName,
                      initialActive: isActive,
                    ),
                    tooltip: 'Edit service',
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    onPressed: () => _deleteService(index),
                    tooltip: 'Delete service',
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ErrorPanel extends StatelessWidget {
  const ErrorPanel({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: const [
          Icon(Icons.event_busy, size: 46, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'No matching appointments found.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class BookingFormScreen extends StatefulWidget {
  const BookingFormScreen({super.key, this.appointment});

  final Appointment? appointment;

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _residentController = TextEditingController();
  final _serviceController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  final List<String> _services = const [
    'Barangay Clearance',
    'ID Assistance',
    'Business Permit',
    'Certificate of Residency',
    'Complaint Filing',
  ];

  bool get _isEditing => widget.appointment != null;

  @override
  void initState() {
    super.initState();
    final current = widget.appointment;
    if (current != null) {
      _residentController.text = current.residentName;
      _serviceController.text = current.service;
      _dateController.text = current.date;
      _timeController.text = current.time;
    } else {
      _serviceController.text = _services.first;
    }
  }

  @override
  void dispose() {
    _residentController.dispose();
    _serviceController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (!mounted) return;

    if (pickedDate != null) {
      _dateController.text =
          '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );

    if (!mounted) return;

    if (pickedTime != null) {
      final hour = pickedTime.hourOfPeriod == 0 ? 12 : pickedTime.hourOfPeriod;
      final period = pickedTime.period == DayPeriod.am ? 'AM' : 'PM';
      final minute = pickedTime.minute.toString().padLeft(2, '0');
      _timeController.text = '$hour:$minute $period';
    }
  }

  Future<void> _deleteAppointment() async {
    if (widget.appointment == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete appointment?'),
        content: Text('This will remove ${widget.appointment!.residentName} from the appointment list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (confirmed == true) {
      Navigator.pop(
        context,
        BookingFormResult(
          appointment: widget.appointment!,
          isDeleted: true,
        ),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final appointment = Appointment(
        id: widget.appointment?.id ?? DateTime.now().millisecondsSinceEpoch,
        residentName: _residentController.text.trim(),
        service: _serviceController.text.trim(),
        date: _dateController.text.trim(),
        time: _timeController.text.trim(),
        status: widget.appointment?.status ?? 'Booked',
        isApiProvided: false,
      );
      Navigator.pop(context, BookingFormResult(appointment: appointment));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit appointment' : 'Book an appointment'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditing ? 'Update resident appointment details' : 'Schedule a resident appointment',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _residentController,
                  decoration: const InputDecoration(
                    labelText: 'Resident name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Please enter resident name' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _serviceController.text.isEmpty ? _services.first : _serviceController.text,
                  onChanged: (value) => _serviceController.text = value ?? _services.first,
                  items: _services
                      .map(
                        (service) => DropdownMenuItem(value: service, child: Text(service)),
                      )
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'Service requested',
                    prefixIcon: Icon(Icons.design_services),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: const InputDecoration(
                    labelText: 'Preferred date',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Please choose a date' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _timeController,
                  readOnly: true,
                  onTap: _pickTime,
                  decoration: const InputDecoration(
                    labelText: 'Preferred time',
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Please choose a time' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _submitForm,
                    icon: Icon(_isEditing ? Icons.save : Icons.check_circle),
                    label: Text(_isEditing ? 'Save changes' : 'Confirm booking'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                if (_isEditing) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _deleteAppointment,
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Delete appointment'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                        side: BorderSide(color: Colors.red.shade300),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
