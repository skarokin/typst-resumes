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

== Education
#edu(
  institution: "Rutgers University" + $dash.em$ + "New Brunswick",
  gpa: "3.86",
  dates: dates-helper(start-date: "Sep 2022", end-date: "Jan 2026"),
  degree: "Bachelor of Arts in Computer Science"
)

== Experience
#work(
  title: "Site Reliability Engineer",
  location: "Santa Clara, CA",
  company: "Palo Alto Networks",
  dates: dates-helper(start-date: "Feb 2026", end-date: "Present")
)
- Engineered a FedRAMP High AI SRE agent on Lambda/API Gateway with 12 MCP integrations, orchestrating subagents for parallel root-cause and triage which cut investigation time from \~30m to \~5m and MTTR by 47%.
- Hardened agent safety with Bedrock Guardrails, HITL, and RBAC, which masked sensitive data, caught 93% of hallucination cases, blocked unauthorized tool use, and gated high-risk tools through human approval flows.
- Centralized LLM observability in Datadog, adding monitors that reduced time to detect regressions by 93%.
- Architected an autoremediation platform with SNS, Lambda, DynamoDB, and S3, turning ad-hoc Python scripts into safe production automations which reduced MTTR for 42 Datadog monitors to under 5 seconds.
- Built a DynamoDB policy engine and Slack control plane, combining runtime config, human escalation, idempotent retries, atomic locks, and recurrence windows to block 100% of unsafe or conflicting executions.
- Guaranteed safe, auditable executions via 97% test coverage and Pydantic validation, while leveraging S3 audit trails and Datadog traces, logging, and custom metrics to enable sub-5 minute RCA for failed remediations.


#work(
  title: "Site Reliability Engineer Intern",
  location: "Newton, MA",
  company: "CyberArk",
  dates: dates-helper(start-date: "May 2025", end-date: "Jan 2026"),
)
- Prototyped an SNS and Step Functions auto-remediation pipeline to validate zero-touch alert resolution.
- Automated 3 Datadog alerts by implementing runbooks in Python, cutting the MTTR for those alerts by 95%.
- Built an AI SRE agent with Confluence, GitHub, and Datadog integrations to accelerate incident response.

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


== Technical Skills
- *Programming Languages:* Go, Python, SQL, TypeScript, JavaScript, Java, C
- *Libraries & Frameworks:* Node.js, SvelteKit, React, Next.js, PyTorch, spaCy, NLTK, NumPy, Pandas
- *Cloud & Devops:* AWS, GCP, Cloudflare, Terraform, Jenkins, Docker, Datadog
- *Platforms & Data:* Git, PostgreSQL, Nginx, RabbitMQ, Redis, Kafka