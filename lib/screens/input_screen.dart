import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CV Builder'),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Color(0xFF2563EB),
            unselectedLabelColor: Color(0xFF6B7280),
            indicatorColor: Color(0xFF2563EB),
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'Basic Info'),
              Tab(text: 'Core Profile'),
              Tab(text: 'Projects & Extras'),
              Tab(text: 'References'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBasicsTab(),
            _buildCoreTab(),
            _buildExtrasTab(),
            _buildReferencesTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _generateCV,
          label: const Text('Generate PDF', style: TextStyle(fontWeight: FontWeight.bold)),
          icon: const Icon(Icons.picture_as_pdf),
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          elevation: 4,
        ),
      ),
    );
  }

  // --- UI Helper Methods for Modern Design ---

  Widget _buildSectionHeader(String title, IconData icon, Color color, VoidCallback onAdd) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add'),
            style: ElevatedButton.styleFrom(
              backgroundColor: color.withOpacity(0.12),
              foregroundColor: color,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(List<Widget> children, Color indicatorColor, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Color indicator block on the left
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: indicatorColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
              ),
            ),
            // Card Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.redAccent, size: 20),
                        onPressed: onRemove,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...children,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: maxLines > 1,
        ),
      ),
    );
  }

  // --- TAB 1: Basics ---
  Widget _buildBasicsTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
        const SizedBox(height: 16),
        _buildTextField('Full Name', _nameController),
        _buildTextField('Email', _emailController),
        _buildTextField('Phone', _phoneController),
        _buildTextField('Location (City, Country)', _locationController),
        _buildTextField('Links (LinkedIn/GitHub)', _linksController),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Divider(color: Color(0xFFE5E7EB)),
        ),
        const Text('Summary & Skills', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
        const SizedBox(height: 16),
        _buildTextField('Professional Summary', _summaryController, maxLines: 3),
        _buildTextField('Skills (comma separated)', _skillsController, maxLines: 2),
        _buildTextField('Languages (comma separated)', _languagesController, maxLines: 2),
        const SizedBox(height: 80),
      ],
    );
  }

  // --- TAB 2: Core (Experience & Education) ---
  Widget _buildCoreTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionHeader('Work Experience', Icons.work_outline, const Color(0xFF2563EB), () {
          setState(() => _experiences.add(ExperienceForm()));
        }),
        ..._experiences.map((form) => _buildExperienceCard(form)).toList(),

        _buildSectionHeader('Education', Icons.school_outlined, const Color(0xFF10B981), () {
          setState(() => _educations.add(EducationForm()));
        }),
        ..._educations.map((form) => _buildEducationCard(form)).toList(),

        _buildSectionHeader('Research', Icons.science_outlined, const Color(0xFF8B5CF6), () {
          setState(() => _researches.add(ResearchForm()));
        }),
        ..._researches.map((form) => _buildResearchCard(form)).toList(),

        const SizedBox(height: 80),
      ],
    );
  }

  // --- TAB 3: Projects & Extras ---
  Widget _buildExtrasTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionHeader('Projects', Icons.code, const Color(0xFFF59E0B), () {
          setState(() => _projects.add(ProjectForm()));
        }),
        ..._projects.map((form) => _buildProjectCard(form)).toList(),

        _buildSectionHeader('Certifications', Icons.workspace_premium_outlined, const Color(0xFFEC4899), () {
          setState(() => _certifications.add(CertificationForm()));
        }),
        ..._certifications.map((form) => _buildCertificationCard(form)).toList(),

        _buildSectionHeader('Extracurriculars', Icons.volunteer_activism_outlined, const Color(0xFF06B6D4), () {
          setState(() => _activities.add(ActivityForm()));
        }),
        ..._activities.map((form) => _buildActivityCard(form)).toList(),

        const SizedBox(height: 80),
      ],
    );
  }

  // --- TAB 4: References ---
  Widget _buildReferencesTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionHeader('Recommendations', Icons.people_outline, const Color(0xFF64748B), () {
          setState(() => _references.add(ReferenceForm()));
        }),
        ..._references.map((form) => _buildReferenceCard(form)).toList(),

        const SizedBox(height: 80),
      ],
    );
  }

  // --- Card Implementations ---

  Widget _buildExperienceCard(ExperienceForm form) {
    return _buildCard([
      _buildTextField('Job Title', form.title),
      _buildTextField('Company', form.company),
      _buildTextField('Date Range', form.date),
      _buildTextField('Responsibilities', form.desc, maxLines: 2),
    ], const Color(0xFF2563EB), () => setState(() => _experiences.remove(form)));
  }

  Widget _buildEducationCard(EducationForm form) {
    return _buildCard([
      _buildTextField('Degree', form.degree),
      _buildTextField('Institution', form.institution),
      _buildTextField('Date Range', form.date),
      _buildTextField('CGPA / Result', form.result),
    ], const Color(0xFF10B981), () => setState(() => _educations.remove(form)));
  }

  Widget _buildResearchCard(ResearchForm form) {
    return _buildCard([
      _buildTextField('Research Title', form.title),
      _buildTextField('Your Role', form.role),
      _buildTextField('Abstract', form.desc, maxLines: 2),
    ], const Color(0xFF8B5CF6), () => setState(() => _researches.remove(form)));
  }

  Widget _buildProjectCard(ProjectForm form) {
    return _buildCard([
      _buildTextField('Project Title', form.title),
      _buildTextField('Tech Stack', form.techStack),
      _buildTextField('Description', form.desc, maxLines: 2),
    ], const Color(0xFFF59E0B), () => setState(() => _projects.remove(form)));
  }

  Widget _buildCertificationCard(CertificationForm form) {
    return _buildCard([
      _buildTextField('Title', form.title),
      _buildTextField('Issuing Org', form.issuer),
      _buildTextField('Year', form.year),
    ], const Color(0xFFEC4899), () => setState(() => _certifications.remove(form)));
  }

  Widget _buildActivityCard(ActivityForm form) {
    return _buildCard([
      _buildTextField('Role', form.role),
      _buildTextField('Organization', form.org),
      _buildTextField('Description', form.desc, maxLines: 2),
    ], const Color(0xFF06B6D4), () => setState(() => _activities.remove(form)));
  }

  Widget _buildReferenceCard(ReferenceForm form) {
    return _buildCard([
      _buildTextField('Name', form.name),
      _buildTextField('Position', form.title),
      _buildTextField('Organization', form.org),
      _buildTextField('Contact Info', form.contact),
    ], const Color(0xFF64748B), () => setState(() => _references.remove(form)));
  }

  // --- Generate the Final CV Object ---
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
