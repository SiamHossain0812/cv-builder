import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/cv_model.dart';
import 'preview_screen.dart';

// --- Form Helper Classes ---
class ExperienceForm {
  final title = TextEditingController();
  final company = TextEditingController();
  final date = TextEditingController();
  final desc = TextEditingController();
}

class EducationForm {
  final degree = TextEditingController();
  final institution = TextEditingController();
  final date = TextEditingController();
  final result = TextEditingController();
}

class ResearchForm {
  final title = TextEditingController();
  final role = TextEditingController();
  final desc = TextEditingController();
}

class ProjectForm {
  final title = TextEditingController();
  final techStack = TextEditingController();
  final desc = TextEditingController();
}

class CertificationForm {
  final title = TextEditingController();
  final issuer = TextEditingController();
  final year = TextEditingController();
}

class ActivityForm {
  final role = TextEditingController();
  final org = TextEditingController();
  final desc = TextEditingController();
}

class ReferenceForm {
  final name = TextEditingController();
  final title = TextEditingController();
  final org = TextEditingController();
  final contact = TextEditingController();
}

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _linksController = TextEditingController();
  final _summaryController = TextEditingController();
  final _skillsController = TextEditingController();
  final _languagesController = TextEditingController();

  final List<ExperienceForm> _experiences = [];
  final List<EducationForm> _educations = [];
  final List<ResearchForm> _researches = [];
  final List<ProjectForm> _projects = [];
  final List<CertificationForm> _certifications = [];
  final List<ActivityForm> _activities = [];
  final List<ReferenceForm> _references = [];

  final List<String> _stepTitles = [
    "Personal Info",
    "Experience",
    "Projects",
    "References"
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      _generateCV();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildModernHeader(),
                _buildStepper(),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      _buildPageWrapper(_buildBasicsTab()),
                      _buildPageWrapper(_buildCoreTab()),
                      _buildPageWrapper(_buildExtrasTab()),
                      _buildPageWrapper(_buildReferencesTab()),
                    ],
                  ),
                ),
                _buildBottomNavigation(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFDBEAFE),
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          left: -150,
          child: Container(
            width: 500,
            height: 500,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE0E7FF),
            ),
          ),
        ),
        Positioned(
          top: 300,
          left: 50,
          child: Container(
            width: 250,
            height: 250,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF3E8FF),
            ),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }

  Widget _buildModernHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Step ${_currentPage + 1} of 4",
                style: const TextStyle(
                  color: Color(0xFF3B82F6),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _stepTitles[_currentPage],
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.w900,
                  fontSize: 32,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.remove_red_eye, color: Color(0xFF0F172A)),
              tooltip: 'Quick Preview',
              onPressed: _generateCV,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index <= _currentPage;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(right: index < 3 ? 12 : 0),
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF3B82F6) : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(3),
                boxShadow: isActive
                    ? [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 2))]
                    : [],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: const Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            InkWell(
              onTap: _prevPage,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Text(
                  "Back",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
                ),
              ),
            )
          else
            const SizedBox.shrink(),
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              foregroundColor: Colors.white,
              elevation: 10,
              shadowColor: const Color(0xFF0F172A).withOpacity(0.3),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _currentPage == 3 ? "Generate CV" : "Continue",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 8),
                Icon(_currentPage == 3 ? Icons.auto_awesome : Icons.arrow_forward_rounded, size: 20),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPageWrapper(Widget child) {
    return ClipRRect(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(28, 10, 28, 100),
        child: child,
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color, VoidCallback onAdd) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, top: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))],
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.add, size: 18, color: color),
                  const SizedBox(width: 6),
                  Text("Add", style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(List<Widget> children, Color indicatorColor, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0, top: 0, bottom: 0,
            child: Container(
              width: 8,
              decoration: BoxDecoration(
                color: indicatorColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), bottomLeft: Radius.circular(24)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 30, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
          Positioned(
            top: 16, right: 16,
            child: InkWell(
              onTap: onRemove,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close_rounded, color: Colors.redAccent, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 1: Basics ---
  Widget _buildBasicsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        Text("Tell us about yourself", style: TextStyle(fontSize: 16, color: const Color(0xFF64748B), fontWeight: FontWeight.w600)),
        const SizedBox(height: 24),
        SleekField(hint: 'Full Name', controller: _nameController, icon: Icons.person_outline),
        SleekField(hint: 'Email Address', controller: _emailController, icon: Icons.alternate_email),
        SleekField(hint: 'Phone Number', controller: _phoneController, icon: Icons.phone_outlined),
        SleekField(hint: 'Location (City, Country)', controller: _locationController, icon: Icons.location_on_outlined),
        SleekField(hint: 'Links (LinkedIn/GitHub URL)', controller: _linksController, icon: Icons.link_rounded),
        const SizedBox(height: 16),
        Container(
          height: 1,
          color: const Color(0xFFE2E8F0),
        ),
        const SizedBox(height: 32),
        Text("Professional Summary", style: TextStyle(fontSize: 18, color: const Color(0xFF0F172A), fontWeight: FontWeight.w800)),
        const SizedBox(height: 20),
        SleekField(hint: 'Write a powerful summary...', controller: _summaryController, maxLines: 4),
        SleekField(hint: 'Key Skills (comma separated)', controller: _skillsController, maxLines: 2, icon: Icons.bolt),
        SleekField(hint: 'Languages (comma separated)', controller: _languagesController, icon: Icons.language),
      ],
    );
  }

  // --- TAB 2: Core (Experience & Education) ---
  Widget _buildCoreTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('Experience', Icons.work_outline_rounded, const Color(0xFF3B82F6), () {
          setState(() => _experiences.insert(0, ExperienceForm()));
        }),
        ..._experiences.map((form) => _buildExperienceCard(form)).toList(),

        _buildSectionHeader('Education', Icons.school_outlined, const Color(0xFF10B981), () {
          setState(() => _educations.insert(0, EducationForm()));
        }),
        ..._educations.map((form) => _buildEducationCard(form)).toList(),

        _buildSectionHeader('Research', Icons.science_outlined, const Color(0xFF8B5CF6), () {
          setState(() => _researches.insert(0, ResearchForm()));
        }),
        ..._researches.map((form) => _buildResearchCard(form)).toList(),
      ],
    );
  }

  // --- TAB 3: Projects & Extras ---
  Widget _buildExtrasTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('Projects', Icons.code_rounded, const Color(0xFFF59E0B), () {
          setState(() => _projects.insert(0, ProjectForm()));
        }),
        ..._projects.map((form) => _buildProjectCard(form)).toList(),

        _buildSectionHeader('Certifications', Icons.workspace_premium_outlined, const Color(0xFFEC4899), () {
          setState(() => _certifications.insert(0, CertificationForm()));
        }),
        ..._certifications.map((form) => _buildCertificationCard(form)).toList(),

        _buildSectionHeader('Extracurriculars', Icons.volunteer_activism_outlined, const Color(0xFF06B6D4), () {
          setState(() => _activities.insert(0, ActivityForm()));
        }),
        ..._activities.map((form) => _buildActivityCard(form)).toList(),
      ],
    );
  }

  // --- TAB 4: References ---
  Widget _buildReferencesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('Recommendations', Icons.people_outline_rounded, const Color(0xFF64748B), () {
          setState(() => _references.insert(0, ReferenceForm()));
        }),
        ..._references.map((form) => _buildReferenceCard(form)).toList(),
      ],
    );
  }

  // --- Card Implementations ---

  Widget _buildExperienceCard(ExperienceForm form) {
    return _buildCard([
      SleekField(hint: 'Job Title', controller: form.title, icon: Icons.badge_outlined),
      SleekField(hint: 'Company Name', controller: form.company, icon: Icons.business_outlined),
      SleekField(hint: 'Date Range (e.g. Jan 2020 - Present)', controller: form.date, icon: Icons.calendar_today_outlined),
      SleekField(hint: 'Key Responsibilities', controller: form.desc, maxLines: 4),
    ], const Color(0xFF3B82F6), () => setState(() => _experiences.remove(form)));
  }

  Widget _buildEducationCard(EducationForm form) {
    return _buildCard([
      SleekField(hint: 'Degree (e.g. B.Sc. in Computer Science)', controller: form.degree, icon: Icons.school_outlined),
      SleekField(hint: 'Institution', controller: form.institution, icon: Icons.account_balance_outlined),
      SleekField(hint: 'Date Range', controller: form.date, icon: Icons.calendar_today_outlined),
      SleekField(hint: 'CGPA / Result', controller: form.result, icon: Icons.grade_outlined),
    ], const Color(0xFF10B981), () => setState(() => _educations.remove(form)));
  }

  Widget _buildResearchCard(ResearchForm form) {
    return _buildCard([
      SleekField(hint: 'Research Title', controller: form.title, icon: Icons.science_outlined),
      SleekField(hint: 'Your Role / Contribution', controller: form.role, icon: Icons.person_outline),
      SleekField(hint: 'Abstract or Description', controller: form.desc, maxLines: 3),
    ], const Color(0xFF8B5CF6), () => setState(() => _researches.remove(form)));
  }

  Widget _buildProjectCard(ProjectForm form) {
    return _buildCard([
      SleekField(hint: 'Project Title', controller: form.title, icon: Icons.laptop_mac_outlined),
      SleekField(hint: 'Tech Stack (e.g. Flutter, Firebase)', controller: form.techStack, icon: Icons.layers_outlined),
      SleekField(hint: 'Project Description', controller: form.desc, maxLines: 3),
    ], const Color(0xFFF59E0B), () => setState(() => _projects.remove(form)));
  }

  Widget _buildCertificationCard(CertificationForm form) {
    return _buildCard([
      SleekField(hint: 'Certification Title', controller: form.title, icon: Icons.verified_outlined),
      SleekField(hint: 'Issuing Organization', controller: form.issuer, icon: Icons.apartment_outlined),
      SleekField(hint: 'Year Achieved', controller: form.year, icon: Icons.calendar_today_outlined),
    ], const Color(0xFFEC4899), () => setState(() => _certifications.remove(form)));
  }

  Widget _buildActivityCard(ActivityForm form) {
    return _buildCard([
      SleekField(hint: 'Role', controller: form.role, icon: Icons.star_outline_rounded),
      SleekField(hint: 'Organization or Club', controller: form.org, icon: Icons.groups_outlined),
      SleekField(hint: 'Description', controller: form.desc, maxLines: 3),
    ], const Color(0xFF06B6D4), () => setState(() => _activities.remove(form)));
  }

  Widget _buildReferenceCard(ReferenceForm form) {
    return _buildCard([
      SleekField(hint: 'Reference Name', controller: form.name, icon: Icons.person_outline),
      SleekField(hint: 'Position / Title', controller: form.title, icon: Icons.work_outline),
      SleekField(hint: 'Organization', controller: form.org, icon: Icons.business_outlined),
      SleekField(hint: 'Contact Information', controller: form.contact, icon: Icons.call_outlined),
    ], const Color(0xFF64748B), () => setState(() => _references.remove(form)));
  }

  void _generateCV() {
    final cvData = CVModel(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      location: _locationController.text,
      links: _linksController.text,
      summary: _summaryController.text,
      skills: _skillsController.text,
      languages: _languagesController.text,
      experiences: _experiences.map((f) => Experience(f.title.text, f.company.text, f.date.text, f.desc.text)).toList(),
      educations: _educations.map((f) => Education(f.degree.text, f.institution.text, f.date.text, f.result.text)).toList(),
      researches: _researches.map((f) => Research(f.title.text, f.role.text, f.desc.text)).toList(),
      projects: _projects.map((f) => Project(f.title.text, f.techStack.text, f.desc.text)).toList(),
      certifications: _certifications.map((f) => Certification(f.title.text, f.issuer.text, f.year.text)).toList(),
      activities: _activities.map((f) => Activity(f.role.text, f.org.text, f.desc.text)).toList(),
      references: _references.map((f) => Reference(f.name.text, f.title.text, f.org.text, f.contact.text)).toList(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(cvData: cvData),
      ),
    );
  }
}

// --- Custom Sleek Glassmorphic Text Field ---
class SleekField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final IconData? icon;

  const SleekField({
    super.key,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
    this.icon,
  });

  @override
  State<SleekField> createState() => _SleekFieldState();
}

class _SleekFieldState extends State<SleekField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: _isFocused ? Colors.white : Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isFocused ? const Color(0xFF3B82F6) : Colors.white,
          width: 2,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      child: Focus(
        onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
        child: TextFormField(
          controller: widget.controller,
          maxLines: widget.maxLines,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w600),
            prefixIcon: widget.icon != null
                ? Icon(
                    widget.icon,
                    color: _isFocused ? const Color(0xFF3B82F6) : const Color(0xFF94A3B8),
                    size: 22,
                  )
                : null,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          ),
        ),
      ),
    );
  }
}
