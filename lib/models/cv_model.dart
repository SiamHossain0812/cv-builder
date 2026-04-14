class Experience {
  final String jobTitle;
  final String company;
  final String dateRange;
  final String description;

  Experience(this.jobTitle, this.company, this.dateRange, this.description);
}

class Education {
  final String degree;
  final String institution;
  final String dateRange;
  final String result;

  Education(this.degree, this.institution, this.dateRange, this.result);
}

class Research {
  final String title;
  final String role;
  final String description;

  Research(this.title, this.role, this.description);
}

class Project {
  final String title;
  final String techStack;
  final String description;

  Project(this.title, this.techStack, this.description);
}

class Certification {
  final String title;
  final String issuer;
  final String year;

  Certification(this.title, this.issuer, this.year);
}

class Activity {
  final String role;
  final String organization;
  final String description;

  Activity(this.role, this.organization, this.description);
}

class Reference {
  final String name;
  final String title;
  final String organization;
  final String contactInfo;

  Reference(this.name, this.title, this.organization, this.contactInfo);
}

class CVModel {
  final String name;
  final String email;
  final String phone;
  final String location;
  final String links;
  final String summary;
  final String skills;
  final String languages;

  final List<Experience> experiences;
  final List<Education> educations;
  final List<Research> researches;
  final List<Project> projects;
  final List<Certification> certifications;
  final List<Activity> activities;
  final List<Reference> references;

  CVModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.links,
    required this.summary,
    required this.skills,
    required this.languages,
    required this.experiences,
    required this.educations,
    required this.researches,
    required this.projects,
    required this.certifications,
    required this.activities,
    required this.references,
  });
}
