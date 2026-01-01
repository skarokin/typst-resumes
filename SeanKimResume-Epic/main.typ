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

== Technical Skills
- *Programming Languages:* Go, Python, SQL, TypeScript, JavaScript, Java, C
- *Libraries & Frameworks:* Node.js, SvelteKit, React, Next.js, PyTorch, spaCy, NLTK, NumPy, Pandas
- *Cloud & Devops:* AWS, GCP, Cloudflare, Terraform, Jenkins, Docker, Datadog
- *Platforms & Data:* Git, PostgreSQL, Nginx, RabbitMQ, Redis, Kafka

== Experience
#work(
  title: "Site Reliability Engineer Intern",
  location: "Newton, MA",
  company: "CyberArk",
  dates: dates-helper(start-date: "May 2025", end-date: "Jan 2026"),
)
- Platformized an auto-remediation system via SNS, Step Functions, & Terraform with 70% adoption in 5 teams.
- Automated 20+ Datadog alerts via Python with dry-runs & human fallback on failure, cutting MTTR by 95%.
- Guaranteed 99.99% availability & 0 race conditions using ElastiCache distributed locking for atomic executions.
- Deployed a FedRAMP High compliant Bedrock & Strands agent via API Gateway & Lambda in isolated VPCs.
- Cut incident MTTA by 39% with AWS MCP & Datadog MCP, correlating live metrics with LLM resolutions.
- Instrumented end-to-end agent observability in Datadog, reducing P99 latency by 45% with tool call profiling.
- Built S3 data ingestion pipeline with a Go Lambda, incrementally updating 50k+ docs nightly in under 2 min.

#work(
  title: "Software Engineer Intern",
  location: "Ridgefield, NJ",
  company: "ACL Agency LLC",
  dates: dates-helper(start-date: "May 2024", end-date: "Aug 2024"),
)
- Migrated legacy VMs to AWS EC2 with Auto Scaling & ELB, reducing monthly infrastructure costs by 19%.
- Processed over 500 batch insurance claims 42% faster by optimizing an internal Go service with goroutines.

== Projects
#project(
  name: "copium.dev",
  url: "copium.dev",
  github: "skarokin/copium",
  tech-stack: "Go, TypeScript, SvelteKit, PostgreSQL, Algolia, Docker, GCP, Cloudflare"
)
- Built an internship management platform with SvelteKit and PostgreSQL, processing 3000 weekly applications.
- Scaled Algolia search engine indexes to 500 concurrent ops with Cloud Pub/Sub & Go consumers on Cloud Run.
- Delivered an 81% reduction in query latency for BigQuery data analytics by leveraging CQRS architecture.
- Implemented compensating transactions for consistency across 3 data stores with a 99.99% successful retry rate.

#project(
  name: "ref:note",
  url: "refnote.app",
  github: "skarokin/ref-note",
  tech-stack: "Go, TypeScript, Node.js, Next.js, Docker, Redis, GCP, Vercel"
)
- Launched a Next.js collaborative note editor on Vercel, supporting 1000 concurrent collaborative sessions.
- Reduced deployment costs by 37% by optimizing Node.js WebSocket synchronization with Redis Pub/Sub.
- Deployed a Go backend on Cloud Run via Docker with sub-50ms cold starts for low-latency Firestore queries.

== Education
#edu(
  institution: "Rutgers University" + $dash.em$ + "New Brunswick",
  gpa: "3.86",
  dates: dates-helper(start-date: "Sep 2022", end-date: "Jan 2026"),
  degree: "Bachelor of Arts in Computer Science"
)
- *Relevant Coursework:* Data Structures and Algorithms, Databases, Computer Architecture, Deep Learning