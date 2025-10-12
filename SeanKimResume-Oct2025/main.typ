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
- Leveraged Bedrock to cut incident MTTA by 17% by unifying knowledge base with the Datadog MCP server.

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
  name: "sixsevenlabs",
  url: "sixsevenlabs.com",
  github: "sixsevenlabs/sixsevenlabs",
  tech-stack: "Go, Python, spaCy, PostgreSQL, Kafka, Stripe, Terraform, AWS"
)
- Architected a Step Functions data augmentation platform ingesting 10TB/month with 27% less cost vs. EC2.
- Augmented 8GB/sec at peak throughput with the Distributed Map state across 1000s of concurrent Lambdas.
- Processed 1m daily events with a real-time usage metering system using Kinesis and Lambda for Stripe billing.
- Engineered a job ingestion pipeline with SQS, queueing over 1000 job requests per minute with 0 data loss.

#project(
  name: "copium",
  url: "copium.dev",
  github: "skarokin/copium",
  tech-stack: "Go, TypeScript, SvelteKit, PostgreSQL, Algolia, GCP, Cloudflare"
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

== Technical Skills
- *Programming Languages:* Go, Python, SQL, TypeScript, JavaScript, Java, C
- *Libraries & Frameworks:* Node.js, SvelteKit, React, Next.js, PyTorch, spaCy, NLTK, NumPy, Pandas
- *Cloud & Devops:* AWS, GCP, Cloudflare, Terraform, Jenkins, Docker, Datadog
- *Platforms & Data:* Git, PostgreSQL, Nginx, RabbitMQ, Redis, Kafka

== Education
#edu(
  institution: "Rutgers University" + $dash.em$ + "New Brunswick",
  gpa: "3.84",
  dates: dates-helper(start-date: "Sep 2022", end-date: "Dec 2025"),
  degree: "Bachelor's of Arts in Computer Science"
)
- *Relevant Coursework:* Data Structures and Algorithms, Databases, Computer Architecture, Deep Learning