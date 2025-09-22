#import "template.typ": *

#let name = "Sean Kim"
#let location = ""
// #let email = link("mailto:taemin.kim0327@gmail.com")[Email]
// #let github = link("https://github.com/skarokin")[GitHub]
// #let linkedin = link("https://linkedin.com/in/kimtaemin")[LinkedIn]
// #let personal-site = link("https://skarokin.com")[Portfolio]
#let email = "taemin.kim0327@gmail.com"
#let github = "github.com/skarokin"
#let linkedin = link("https://linkedin.com/in/kimtaemin")[in/kimtaemin]
#let personal-site = "taeminkim.com"
#let phone = "+1 (201) 937-7441"

#show: resume.with(
  author: name,
  location: location,
  email: email,
  github: github,
  linkedin: linkedin,
  phone: phone,
  personal-site: personal-site,
  accent-color: "#3366CC",
  font: "New Computer Modern",
  font-size: 11pt,
  paper: "us-letter",
  author-position: left,
  personal-info-position: left,
)

== Experience
#work(
  title: "Site Reliability Engineer Intern",
  location: "Newton, MA",
  company: "CyberArk",
  dates: dates-helper(start-date: "May 2025", end-date: "Present"),
)
- Automated remediation for 12 SEV2+ Datadog monitors via SNS & Step Functions, cutting MTTR by 95%.
- Platformized auto-remediation with Jenkins and Terraform, increasing coverage from 0 to 70% across 5 teams.
- Built Bedrock knowledge base with Go, Lambda, S3, & EventBridge, indexing 5000 docs nightly in \<2 min.
- Cut MTTA by 17% by serving LLM citations from the knowledge base with API Gateway, Lambda, and React.

#work(
  title: "Software Engineer Intern",
  location: "Ridgefield, NJ",
  company: "ACL Agency LLC",
  dates: dates-helper(start-date: "May 2024", end-date: "Aug 2024"),
)
- Migrated legacy VMs to AWS EC2 with Auto Scaling and ELB, reducing monthly infrastructure costs by 19%.
- Processed over 500 batch insurance claims 42% faster by optimizing an internal Go service with goroutines.

== Projects
#project(
  name: "copium",
  url: "copium.dev",
  github: "skarokin/copium",
  tech-stack: "Go, TypeScript, SvelteKit, PostgreSQL, GCP, Algolia"
)
- Built an internship management platform with SvelteKit and PostgreSQL, processing 3000 weekly applications.
- Scaled search engine indexes to 2k concurrent operations with Cloud Pub/Sub and Go consumers on Cloud Run.
- Delivered an 81% reduction in query latency for BigQuery data analytics by leveraging CQRS architecture.
- Implemented compensating transactions for consistency across 3 data stores with a 99.9% successful retry rate.

#project(
  name: "ref:note",
  url: "refnote.app",
  github: "skarokin/ref-note",
  tech-stack: "Go, TypeScript, Node.js, Next.js, Docker, Redis, GCP, Vercel"
)
- Launched a Next.js collaborative note editor on Vercel, supporting 1000 concurrent collaborative sessions.
- Reduced deployment costs by 37% by optimizing Node.js WebSocket synchronization with Redis Pub/Sub.
- Deployed a Go backend on Cloud Run via Docker with sub-50ms cold starts for low-latency Firestore queries.

#project(
  name: "grammaCy",
  url: "grammacy.com",
  github: "skarokin/grammacy",
  tech-stack: "Python, spaCy, Flask, Nginx, Docker, AWS"
)
- Developed dependency tree-based grammar checking with spaCy, achieving 83% accuracy on 20 English errors.
- Handled 250 concurrent requests with \<200ms latency on AWS EC2 with Docker Compose, Flask, and Nginx.
- Boosted F1-score by 15% with a parallelized CoNLL-U augmentor, accelerating augmentation speeds by 10x.

== Technical Skills
- *Programming Languages:* Go, Python, SQL, TypeScript, JavaScript, Java, C
- *Libraries & Frameworks:* Node.js, SvelteKit, React, Next.js, PyTorch, spaCy, NLTK
- *Cloud & Devops:* AWS, GCP, Docker, Terraform, Jenkins, Datadog
- *Platforms & Data:* Git, PostgreSQL, Nginx, RabbitMQ, Redis, Kafka

== Education
#edu(
  institution: "Rutgers University" + $dash.em$ + "New Brunswick",
  gpa: "3.84",
  dates: dates-helper(start-date: "Sep 2022", end-date: "Dec 2025"),
  degree: "Bachelor's of Arts in Computer Science"
)
- *Relevant Coursework:* Data Structures and Algorithms, Databases, Computer Architecture, Deep Learning