import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _aliasController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedBloodType;
  final List<String> _bloodTypes = [
    'O+',
    'O-',
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-'
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _aliasController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate() && _selectedBloodType != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Registration submitted successfully! Welcome to TABANG.'),
          backgroundColor: Color(0xFF2E7D32),
        ),
      );
    } else if (_selectedBloodType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your blood type.'),
          backgroundColor: Color(0xFFC62828),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.sizeOf(context).width >= 1000;

    return Scaffold(
      body: Stack(
        children: [
          // ==============================================
          // BACKGROUND CONTENT (Split Layout)
          // ==============================================
          Column(
            children: [
              const SizedBox(height: 56),
              Expanded(
                child: Row(
                  children: [
                    // Left Crimson Panel (Solid deep warm red with subtle gradient)
                    if (isWide)
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(
                                    0xFF8E2124), // Slightly brighter warm tone at top-left
                                Color(0xFF7A1C1E), // Deep dark warm blood red
                                Color(
                                    0xFF5D1214), // Rich shadow tone at bottom-right
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Spacer(),
                              const Text(
                                'Your single bag of blood can\nsave up to three lives.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  height: 1.25,
                                  fontFamily: 'serif',
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Every day, patients across the Philippines need urgent blood\ntransfusions. By registering as a voluntary donor, you become their\nhero in waiting.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 12.5,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 35),
                              const Text(
                                '1.2 Million',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Bags needed annually',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'The nationwide requirement to secure healthy blood reserves for emergencies.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 10.5,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Divider(
                                    color: Colors.white24, thickness: 1),
                              ),
                              const Text(
                                '588,575',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Units collected last year',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Every contribution helps close the persistent gap to serve those in dire need.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 10.5,
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),

                    // Right Form Panel
                    Expanded(
                      flex: isWide ? 5 : 10,
                      child: Container(
                        color: theme.colorScheme.surface,
                        child: Center(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: isWide ? 40 : 16,
                              vertical: 24,
                            ),
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 420),
                              padding: EdgeInsets.all(isWide ? 28 : 20),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: theme.colorScheme.outlineVariant),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Center(
                                      child: Text(
                                        'Register',
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'To protect your data privacy only your nickname, blood type, and barangay will be first shown when interacting with other users.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        color: Colors.black54,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Full Name
                                    _fieldLabel('Full Name'),
                                    const SizedBox(height: 4),
                                    TextFormField(
                                      controller: _fullNameController,
                                      style: const TextStyle(fontSize: 12),
                                      decoration: _mockupInputDecor(
                                          'Briones, Iverson D.'),
                                      validator: (val) =>
                                          val == null || val.isEmpty
                                              ? 'Required'
                                              : null,
                                    ),
                                    const SizedBox(height: 12),

                                    // Nickname/Alias
                                    _fieldLabel('Nickname/Alias'),
                                    const SizedBox(height: 4),
                                    TextFormField(
                                      controller: _aliasController,
                                      style: const TextStyle(fontSize: 12),
                                      decoration: _mockupInputDecor('Iver'),
                                      validator: (val) =>
                                          val == null || val.isEmpty
                                              ? 'Required'
                                              : null,
                                    ),
                                    const SizedBox(height: 12),

                                    // Email Address
                                    _fieldLabel('Email Address'),
                                    const SizedBox(height: 4),
                                    TextFormField(
                                      controller: _emailController,
                                      style: const TextStyle(fontSize: 12),
                                      decoration: _mockupInputDecor(
                                          'iversonbriones@gmail.com'),
                                      validator: (val) =>
                                          val == null || !val.contains('@')
                                              ? 'Invalid email'
                                              : null,
                                    ),
                                    const SizedBox(height: 12),

                                    // Contact Number
                                    _fieldLabel('Contact Number'),
                                    const SizedBox(height: 4),
                                    TextFormField(
                                      controller: _phoneController,
                                      style: const TextStyle(fontSize: 12),
                                      decoration:
                                          _mockupInputDecor('09123456789'),
                                      validator: (val) =>
                                          val == null || val.isEmpty
                                              ? 'Required'
                                              : null,
                                    ),
                                    const SizedBox(height: 12),

                                    // Birth Date & Blood Type Row
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _fieldLabel('Birth Date'),
                                              const SizedBox(height: 4),
                                              TextFormField(
                                                controller:
                                                    _birthDateController,
                                                readOnly: true,
                                                onTap: () async {
                                                  final date =
                                                      await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime(2000),
                                                    firstDate: DateTime(1900),
                                                    lastDate: DateTime.now(),
                                                  );
                                                  if (date != null) {
                                                    _birthDateController.text =
                                                        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                                                  }
                                                },
                                                style: const TextStyle(
                                                    fontSize: 12),
                                                decoration: _mockupInputDecor(
                                                    'YYYY-MM-DD'),
                                                validator: (value) =>
                                                    DateTime.tryParse(
                                                                value ?? '') ==
                                                            null
                                                        ? 'Select a valid date'
                                                        : null,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _fieldLabel('Blood Type'),
                                              const SizedBox(height: 4),
                                              DropdownButtonFormField<String>(
                                                initialValue:
                                                    _selectedBloodType,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black87),
                                                hint: Text('Select Blood Type',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors
                                                            .grey.shade400)),
                                                decoration:
                                                    _mockupInputDecor(''),
                                                items: _bloodTypes.map((type) {
                                                  return DropdownMenuItem(
                                                      value: type,
                                                      child: Text(type,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      12)));
                                                }).toList(),
                                                onChanged: (val) => setState(
                                                    () => _selectedBloodType =
                                                        val),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    // City Address
                                    _fieldLabel('City Address'),
                                    const SizedBox(height: 4),
                                    TextFormField(
                                      controller: _addressController,
                                      style: const TextStyle(fontSize: 12),
                                      decoration: _mockupInputDecor(
                                          'Barangay, City, Province'),
                                      validator: (val) =>
                                          val == null || val.isEmpty
                                              ? 'Required'
                                              : null,
                                    ),
                                    const SizedBox(height: 20),

                                    // Submit Button
                                    SizedBox(
                                      width: double.infinity,
                                      height: 38,
                                      child: FilledButton(
                                        onPressed: _handleRegister,
                                        child: const Text(
                                          'Create profile',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
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
                  ],
                ),
              ),
            ],
          ),

          // ==============================================
          // Registration page header
          // ==============================================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Material(
              color: theme.colorScheme.surface,
              child: SizedBox(
                height: 56,
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Back',
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Text('Donor registration',
                        style: theme.textTheme.titleMedium),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
    );
  }

  InputDecoration _mockupInputDecor(String hint) {
    final colors = Theme.of(context).colorScheme;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: colors.onSurfaceVariant),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      filled: true,
      fillColor: colors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.primary, width: 2),
      ),
    );
  }
}
