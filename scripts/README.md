# 📜 Automation Scripts

This directory contains automation scripts for development, deployment, and database operations.

## 📁 Directory Structure

```
scripts/
├── development/               # Development and setup scripts
│   ├── setup-local-env.sh    # Local environment setup
│   ├── setup.sh              # Initial project setup
│   └── health-check.sh       # Health check script
│
├── deployment/                # Deployment automation
│   ├── deploy.sh             # Deployment script
│   └── aws-setup.sh          # AWS infrastructure setup
│
└── database/                  # Database scripts
    └── mongo-init.js         # MongoDB initialization
```

## 🚀 Development Scripts

### `development/setup-local-env.sh`

Sets up local development environment including:

- Creating `.env` file from template
- Installing dependencies
- Setting up Git hooks
- Verifying prerequisites

**Usage:**

```bash
./scripts/development/setup-local-env.sh
```

### `development/setup.sh`

Initial project setup script for new developers.

**Usage:**

```bash
./scripts/development/setup.sh
```

### `development/health-check.sh`

Checks the health of running services.

**Usage:**

```bash
./scripts/development/health-check.sh
```

## 🚢 Deployment Scripts

### `deployment/deploy.sh`

Automated deployment script supporting multiple environments.

**Usage:**

```bash
# Deploy to development
./scripts/deployment/deploy.sh dev

# Deploy to production
./scripts/deployment/deploy.sh prod
```

**Environments:**

- `dev` - Development environment
- `test` - Testing environment
- `prod` - Production environment

### `deployment/aws-setup.sh`

Sets up AWS infrastructure using Terraform.

**Usage:**

```bash
./scripts/deployment/aws-setup.sh
```

## 💾 Database Scripts

### `database/mongo-init.js`

MongoDB initialization script that:

- Creates databases
- Sets up users and permissions
- Creates initial collections
- Adds indexes

**Usage:**

```bash
# Run directly with MongoDB
mongo < scripts/database/mongo-init.js

# Or via Docker
docker-compose exec mongodb mongo /scripts/mongo-init.js
```

## 🔧 Script Permissions

All scripts should have execute permissions:

```bash
# Grant execute permission
chmod +x scripts/**/*.sh

# Or use the setup command
npm run setup
```

## 📝 Script Conventions

### Naming

- Use kebab-case: `setup-local-env.sh`
- Descriptive names: `deploy.sh` not `d.sh`
- Extension: `.sh` for shell scripts, `.js` for Node scripts

### Structure

All scripts should include:

- Shebang line (`#!/bin/bash` or `#!/usr/bin/env node`)
- Description comment
- Error handling (`set -e`)
- Usage function
- Logging with colors

### Example Template

```bash
#!/bin/bash
set -e

# Script: deploy.sh
# Description: Deploy application to specified environment
# Usage: ./deploy.sh [dev|test|prod]

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
usage() {
  echo "Usage: $0 [dev|test|prod]"
  exit 1
}

log_info() {
  echo -e "${GREEN}[INFO]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Main script logic
# ...
```

## 🔐 Security Notes

- **Never commit secrets**: No API keys, passwords, or tokens in scripts
- **Use environment variables**: Access secrets via `.env` files
- **Validate inputs**: Always validate and sanitize user inputs
- **Audit logs**: Log all deployment actions

## 🧪 Testing Scripts

Test scripts before committing:

```bash
# Test shell scripts syntax
shellcheck scripts/**/*.sh

# Test with dry-run (if supported)
./scripts/deployment/deploy.sh dev --dry-run
```

## 📚 Related Documentation

- [Deployment Guide](../docs/deployment/DEPLOYMENT_CHECKLIST.md)
- [Development Workflow](../docs/guides/DEVELOPMENT.md)
- [Environment Configuration](../docs/ENVIRONMENT_CONFIGURATION.md)

## 🆘 Troubleshooting

### Permission Denied

```bash
chmod +x scripts/path/to/script.sh
```

### Script Not Found

Ensure you're running from project root:

```bash
cd /path/to/sportification-be
./scripts/development/setup.sh
```

### Environment Variables Missing

Copy and configure environment file:

```bash
cp config/environments/.env.example .env
```

---

**Last Updated:** October 11, 2025
