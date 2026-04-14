import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/cv_model.dart';

class PdfService {
  static Future<Uint8List> generateCV(CVModel cv) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // --- HEADER ---
            pw.Center(
              child: pw.Text(
                cv.name.isEmpty ? 'Your Name' : cv.name.toUpperCase(),
                style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Center(
              child: pw.Text(
                [cv.email, cv.phone, cv.location, cv.links].where((e) => e.isNotEmpty).join(' | '),
                style: const pw.TextStyle(fontSize: 12),
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Divider(thickness: 1),
            pw.SizedBox(height: 12),

            // --- SUMMARY ---
            if (cv.summary.isNotEmpty) ...[
              _buildSectionTitle('PROFESSIONAL SUMMARY'),
              pw.Text(cv.summary, style: const pw.TextStyle(fontSize: 11)),
              pw.SizedBox(height: 16),
            ],

            // --- EXPERIENCE ---
            if (cv.experiences.isNotEmpty) ...[
              _buildSectionTitle('WORK EXPERIENCE'),
              ...cv.experiences.map((exp) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(exp.jobTitle, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                          pw.Text(exp.dateRange, style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 11)),
                        ],
                      ),
                      pw.Text(exp.company, style: pw.TextStyle(fontSize: 11, fontStyle: pw.FontStyle.italic)),
                      if (exp.description.isNotEmpty) ...[
                        pw.SizedBox(height: 4),
                        pw.Text(exp.description, style: const pw.TextStyle(fontSize: 11)),
                      ]
                    ],
                  ),
                );
              }),
              pw.SizedBox(height: 8),
            ],

            // --- EDUCATION ---
            if (cv.educations.isNotEmpty) ...[
              _buildSectionTitle('EDUCATION'),
              ...cv.educations.map((edu) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(edu.degree, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                          pw.Text(edu.dateRange, style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 11)),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(edu.institution, style: const pw.TextStyle(fontSize: 11)),
                          if (edu.result.isNotEmpty)
                            pw.Text('CGPA/Result: ${edu.result}', style: const pw.TextStyle(fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              pw.SizedBox(height: 8),
            ],

            // --- RESEARCH ---
            if (cv.researches.isNotEmpty) ...[
              _buildSectionTitle('RESEARCH & PUBLICATIONS'),
              ...cv.researches.map((res) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(res.title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                      pw.Text(res.role, style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 11)),
                      if (res.description.isNotEmpty) ...[
                        pw.SizedBox(height: 4),
                        pw.Text(res.description, style: const pw.TextStyle(fontSize: 11)),
                      ]
                    ],
                  ),
                );
              }),
              pw.SizedBox(height: 8),
            ],

            // --- PROJECTS ---
            if (cv.projects.isNotEmpty) ...[
              _buildSectionTitle('PROJECTS'),
              ...cv.projects.map((proj) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(proj.title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                          if (proj.techStack.isNotEmpty)
                            pw.Text('Tech: ${proj.techStack}', style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 10)),
                        ],
                      ),
                      if (proj.description.isNotEmpty) ...[
                        pw.SizedBox(height: 4),
                        pw.Text(proj.description, style: const pw.TextStyle(fontSize: 11)),
                      ]
                    ],
                  ),
                );
              }),
              pw.SizedBox(height: 8),
            ],

            // --- SKILLS & LANGUAGES ---
            if (cv.skills.isNotEmpty || cv.languages.isNotEmpty) ...[
              _buildSectionTitle('SKILLS & LANGUAGES'),
              if (cv.skills.isNotEmpty)
                pw.Text('Skills: ${cv.skills}', style: const pw.TextStyle(fontSize: 11)),
              if (cv.languages.isNotEmpty)
                pw.Text('Languages: ${cv.languages}', style: const pw.TextStyle(fontSize: 11)),
              pw.SizedBox(height: 16),
            ],

            // --- CERTIFICATIONS ---
            if (cv.certifications.isNotEmpty) ...[
              _buildSectionTitle('CERTIFICATIONS'),
              ...cv.certifications.map((cert) {
                return pw.Text(
                  '${cert.title} - ${cert.issuer} (${cert.year})',
                  style: const pw.TextStyle(fontSize: 11),
                );
              }),
              pw.SizedBox(height: 16),
            ],

             // --- EXTRACURRICULAR ACCIVITIES ---
            if (cv.activities.isNotEmpty) ...[
              _buildSectionTitle('EXTRACURRICULARS'),
              ...cv.activities.map((act) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(act.role, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                      pw.Text(act.organization, style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 11)),
                      if (act.description.isNotEmpty) pw.Text(act.description, style: const pw.TextStyle(fontSize: 11))
                    ],
                  ),
                );
              }),
              pw.SizedBox(height: 8),
            ],

             // --- REFERENCES ---
            if (cv.references.isNotEmpty) ...[
              _buildSectionTitle('REFERENCES'),
              ...cv.references.map((ref) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(ref.name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                      pw.Text('${ref.title}, ${ref.organization}', style: const pw.TextStyle(fontSize: 11)),
                      pw.Text(ref.contactInfo, style: const pw.TextStyle(fontSize: 11)),
                    ],
                  ),
                );
              }),
            ],
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildSectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800),
          ),
          pw.Divider(thickness: 1, color: PdfColors.blueGrey800),
        ],
      ),
    );
  }
}
