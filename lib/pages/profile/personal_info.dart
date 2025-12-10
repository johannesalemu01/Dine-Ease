import 'package:flutter/material.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  final _formKey = GlobalKey<FormState>();
  String? _title = 'Mr.';
  final TextEditingController _firstName = TextEditingController(
    text: 'Yohannes',
  );
  final TextEditingController _lastName = TextEditingController(text: 'Alemu');
  final TextEditingController _email = TextEditingController(
    text: 'jo@gmail.com',
  );
  DateTime? _dob;

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

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: persist changes via your repository/controller
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile saved')));
  }

  @override
  Widget build(BuildContext context) {
    const pageBg = Color.fromARGB(255, 10, 24, 39);
    const cardBg = Color.fromARGB(255, 11, 23, 36);
    const accent = Color.fromARGB(255, 29, 144, 94);

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
              // avatar + basic info
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
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Yohannes Alemu',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'jo@gmail.com',
                            style: TextStyle(color: Colors.white70),
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

              // form card
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
                      // Title dropdown
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

                      // First name
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

                      // Last name
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

                      // Email
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Email',
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
                        validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return 'Enter email';
                          final emailRegex = RegExp(
                            r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                          );
                          return emailRegex.hasMatch(v.trim())
                              ? null
                              : 'Enter a valid email';
                        },
                      ),
                      const SizedBox(height: 12),

                      // DOB picker
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
                            validator: (v) =>
                                _dob == null ? 'Select date of birth' : null,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Save button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
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
