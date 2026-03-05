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
  title: "Site Reliability Engineer",
  location: "Santa Clara, CA",
  company: "Palo Alto Networks",
  dates: dates-helper(start-date: "Feb 2026", end-date: "Present")
)
- Engineered an A2A gateway on AWS Fargate to centralize remote agent governance, dynamically routing user-scoped agent access based on Cognito role claims and accelerating security patching by 60%.
- Architected a FedRAMP High-compliant LLM inference backend via Bedrock AgentCore Runtime & AgentCore Identity, serving as the central entrypoint agent to this gateway for 10 engineering teams.
- Aggregated LLM metrics, logs, and traces across all teams' subagents and tools into a unified Datadog dashboard, utilizing tool call profiling & subagent traces to reduce end-to-end P99 latency by 45%.
- Integrated an SRE & incident management subagent into the MCP gateway to automate incident triage and surface root-cause resolutions, processing 100+ weekly alerts and cutting overall MTTA by 39%.

#work(
  title: "Site Reliability Engineer Intern",
  location: "Newton, MA",
  company: "CyberArk",
  dates: dates-helper(start-date: "May 2025", end-date: "Jan 2026"),
)
- Platformized an auto-remediation system via SNS, Step Functions, & Terraform with 70% adoption in 5 teams.
- Automated 20 Datadog alerts via Python with dry-runs & human escalation on failure, cutting MTTR by 95%.
- Guaranteed 99.99% availability & 0 race conditions using Valkey distributed locking for atomic executions.
- Safeguarded prod with a phased rollout system and distributed tracing, catching 95% of bugs pre-production.

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