# 2-Tier Flask App — CI/CD Pipeline with Terraform & Jenkins

A fully automated 2-tier web application deployed on AWS using Terraform for infrastructure provisioning and Jenkins for CI/CD pipeline.

---

## Tech Stack

| Layer | Tool |
|---|---|
| Infrastructure | Terraform |
| Cloud | AWS (EC2, VPC, Security Group) |
| CI/CD | Jenkins |
| App | Python Flask |
| Database | MySQL 8.0 |
| Containerization | Docker + Docker Compose |
| Version Control | GitHub |

---

## Architecture
Developer → GitHub → Jenkins → Docker Compose → Flask + MySQL
↑
Terraform
(VPC, EC2, SG, IGW)

## Project Structure
├── terraform/
│   ├── main.tf            # VPC, EC2, SG, IGW, Key Pair
│   ├── variables.tf       # Input variables
│   ├── outputs.tf         # EC2 IP, Jenkins URL, Flask URL
│   └── user_data.sh       # Auto-installs Docker + Jenkins on EC2
└── app/
├── app.py             # Flask application
├── Dockerfile         # Flask container image
├── docker-compose.yml # Flask + MySQL orchestration
├── Jenkinsfile        # CI/CD pipeline definition
├── requirements.txt   # Python dependencies
└── templates/
└── index.html     # Frontend UI

---

## How to Run

### 1. Prerequisites
- AWS CLI configured
- Terraform installed
- SSH key pair at `~/.ssh/flask-key`

### 2. Provision Infrastructure
```bash
cd terraform/
terraform init
terraform plan
terraform apply
```

### 3. Access Jenkins
- URL printed after `terraform apply`
- Format: `http://<ec2-ip>:8080`
- Get initial password:
```bash
ssh -i ~/.ssh/flask-key ubuntu@<ec2-ip>
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### 4. Configure Jenkins Pipeline
- New Item → Pipeline
- Pipeline script from SCM → Git
- Repo URL: your GitHub repo
- Script Path: `app/Jenkinsfile`
- Build Now

### 5. Access Flask App
- URL: `http://<ec2-ip>:5000`

---

## Destroy Infrastructure
```bash
cd terraform/
terraform destroy
```

---

## Author
Praneeth Kulkarni