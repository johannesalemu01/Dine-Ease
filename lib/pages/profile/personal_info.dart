import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dine_ease/providers/user/user_repository.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PersonalInformation extends ConsumerStatefulWidget {
  const PersonalInformation({super.key});

  @override
  ConsumerState<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends ConsumerState<PersonalInformation> {
  final _formKey = GlobalKey<FormState>();
  String? _title = 'Mr.';
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  DateTime? _dob;
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProfile());
  }

  Future<void> _loadProfile() async {
    if (!mounted) return;
    setState(() { _loading = true; _errorMessage = null; });
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      _firstName.text = 'Guest';
      _lastName.text = 'User';
      _email.text = 'guest@mesob.com';
      _loading = false;
    });
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 25, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (ctx, child) =>
          Theme(data: Theme.of(context), child: child ?? const SizedBox()),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _loading = true);
    
    final success = await ref.read(userRepositoryProvider).updateProfile({
      'fullName': '${_firstName.text} ${_lastName.text}'.trim(),
      'phoneNumber': '', // Add phone field if needed
    });

    setState(() => _loading = false);

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: 'Failed to update profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    const pageBg = Color.fromARGB(255, 10, 24, 39);
    const cardBg = Color.fromARGB(255, 11, 23, 36);
    const accent = Color.fromARGB(255, 29, 144, 94);

    if (_loading) {
      return const Scaffold(
        backgroundColor: pageBg,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: pageBg,
        appBar: AppBar(
          title: const Text('Personal Information', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded, color: Colors.white38, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Could not load profile',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadProfile,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        title: const Text('Personal Information'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      backgroundImage: AssetImage('assets/images/mesob.png'),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_firstName.text} ${_lastName.text}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _email.text,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _title,
                              dropdownColor: cardBg,
                              decoration: InputDecoration(
                                labelText: 'Title',
                                labelStyle: const TextStyle(
                                  color: Colors.white70,
                                ),
                                filled: true,
                                fillColor: const Color(0xFF0B1218),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Mr.',
                                  child: Text(
                                    'Mr.',
                                    style: TextStyle(
                                      color: Color.fromARGB(234, 255, 255, 255),
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Mrs.',
                                  child: Text(
                                    'Mrs.',
                                    style: TextStyle(
                                      color: Color.fromARGB(234, 255, 255, 255),
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Ms.',
                                  child: Text(
                                    'Ms.',
                                    style: TextStyle(
                                      color: Color.fromARGB(234, 255, 255, 255),
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (v) => setState(() => _title = v),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _firstName,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'First name',
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: const Color(0xFF0B1218),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.white70,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter first name'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _lastName,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Last name',
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: const Color(0xFF0B1218),
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: Colors.white70,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter last name'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        readOnly: true, // Email usually managed via Supabase
                        style: const TextStyle(color: Colors.white38),
                        decoration: InputDecoration(
                          labelText: 'Email (Read Only)',
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: const Color(0xFF0B1218),
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Colors.white70,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: _pickDob,
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Date of birth',
                              labelStyle: const TextStyle(
                                color: Colors.white70,
                              ),
                              filled: true,
                              fillColor: const Color(0xFF0B1218),
                              prefixIcon: const Icon(
                                Icons.calendar_today,
                                color: Colors.white70,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              hintText: _dob == null
                                  ? 'Select date'
                                  : '${_dob!.year}-${_dob!.month.toString().padLeft(2, '0')}-${_dob!.day.toString().padLeft(2, '0')}',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _loading 
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
