# Makefile for Sportification Backend
# ============================================================================
# Convenience commands for common development and deployment tasks
# ============================================================================

.PHONY: help install dev build test lint format clean docker-build docker-up docker-down deploy-dev deploy-test deploy-prod aws-setup terraform-init terraform-plan terraform-apply

# Variables
ENVIRONMENT ?= dev
IMAGE_TAG ?= latest
AWS_REGION ?= us-east-1

# Colors
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "$(GREEN)Sportification Backend - Available Commands$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""

# ==============================================================================
# Local Development
# ==============================================================================

install: ## Install dependencies
	npm ci

dev: ## Start development server with hot-reload
	npm run dev

dev-docker: ## Start development with Docker Compose
	docker-compose -f config/docker/docker-compose.dev.yml up

build: ## Build TypeScript project
	npm run build

test: ## Run tests
	npm test

test-watch: ## Run tests in watch mode
	npm run test:watch

test-coverage: ## Run tests with coverage
	npm run test:coverage

lint: ## Run linter
	npm run lint

lint-fix: ## Fix linting issues
	npm run lint:fix

format: ## Format code with Prettier
	npm run format

format-check: ## Check code formatting
	npm run format:check

clean: ## Clean build artifacts and dependencies
	rm -rf dist node_modules coverage

# ==============================================================================
# Docker Commands
# ==============================================================================

docker-build: ## Build Docker image
	docker build -f config/docker/Dockerfile -t sportification-api:$(IMAGE_TAG) .

docker-build-prod: ## Build production Docker image
	docker build -f config/docker/Dockerfile --target production -t sportification-api:$(IMAGE_TAG) .

docker-up: ## Start all services with Docker Compose
	docker-compose -f config/docker/docker-compose.$(ENVIRONMENT).yml up

docker-up-detached: ## Start services in background
	docker-compose -f config/docker/docker-compose.$(ENVIRONMENT).yml up -d

docker-down: ## Stop all services
	docker-compose -f config/docker/docker-compose.$(ENVIRONMENT).yml down

docker-logs: ## View Docker logs
	docker-compose -f config/docker/docker-compose.$(ENVIRONMENT).yml logs -f

docker-clean: ## Clean Docker resources
	docker-compose -f config/docker/docker-compose.$(ENVIRONMENT).yml down -v
	docker system prune -f

# ==============================================================================
# AWS Commands
# ==============================================================================

aws-setup: ## Initialize AWS resources
	@echo "$(GREEN)Setting up AWS resources...$(NC)"
	./scripts/deployment/aws-setup.sh

aws-login: ## Login to AWS ECR
	@echo "$(GREEN)Logging in to AWS ECR...$(NC)"
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $$(aws sts get-caller-identity --query Account --output text).dkr.ecr.$(AWS_REGION).amazonaws.com

# ==============================================================================
# Terraform Commands
# ==============================================================================

terraform-init: ## Initialize Terraform
	cd infrastructure/terraform && terraform init

terraform-plan: ## Plan Terraform changes
	@echo "$(YELLOW)Planning infrastructure for $(ENVIRONMENT)...$(NC)"
	cd infrastructure/terraform && terraform plan -var-file=environments/$(ENVIRONMENT).tfvars

terraform-apply: ## Apply Terraform changes
	@echo "$(RED)Applying infrastructure for $(ENVIRONMENT)...$(NC)"
	cd infrastructure/terraform && terraform apply -var-file=environments/$(ENVIRONMENT).tfvars

terraform-destroy: ## Destroy Terraform infrastructure
	@echo "$(RED)⚠️  Destroying infrastructure for $(ENVIRONMENT)...$(NC)"
	@read -p "Are you sure? Type 'yes' to confirm: " confirm && [ "$$confirm" = "yes" ]
	cd infrastructure/terraform && terraform destroy -var-file=environments/$(ENVIRONMENT).tfvars

terraform-output: ## Show Terraform outputs
	cd infrastructure/terraform && terraform output

# ==============================================================================
# Deployment Commands
# ==============================================================================

deploy-dev: ## Deploy to development
	@echo "$(GREEN)Deploying to development...$(NC)"
	./scripts/deployment/deploy.sh dev $(IMAGE_TAG)

deploy-test: ## Deploy to test/staging
	@echo "$(YELLOW)Deploying to test/staging...$(NC)"
	./scripts/deployment/deploy.sh test $(IMAGE_TAG)

deploy-prod: ## Deploy to production
	@echo "$(RED)⚠️  Deploying to production...$(NC)"
	./scripts/deployment/deploy.sh prod $(IMAGE_TAG)

rollback: ## Rollback deployment
	@echo "$(RED)Rolling back $(ENVIRONMENT)...$(NC)"
	./scripts/deployment/deploy.sh $(ENVIRONMENT) rollback

# ==============================================================================
# Database Commands
# ==============================================================================

db-migrate: ## Run database migrations
	npm run migrate

db-seed: ## Seed database with test data
	npm run seed

# ==============================================================================
# Monitoring & Logs
# ==============================================================================

logs-dev: ## View development logs
	aws logs tail /aws/ecs/sportification-dev --follow

logs-test: ## View test logs
	aws logs tail /aws/ecs/sportification-test --follow

logs-prod: ## View production logs
	aws logs tail /aws/ecs/sportification-prod --follow

# ==============================================================================
# CI/CD
# ==============================================================================

ci: lint test build ## Run CI checks locally

pre-commit: lint format test ## Run pre-commit checks

# ==============================================================================
# Quick Start
# ==============================================================================

quick-start: install dev ## Quick start for new developers

quick-start-docker: docker-up-detached ## Quick start with Docker

# ==============================================================================
# Production Deployment Workflow
# ==============================================================================

prod-deploy-full: terraform-plan docker-build-prod aws-login deploy-prod ## Full production deployment workflow
	@echo "$(GREEN)✓ Production deployment complete!$(NC)"

# ==============================================================================
# Examples
# ==============================================================================

.PHONY: examples
examples: ## Show usage examples
	@echo "$(GREEN)Usage Examples:$(NC)"
	@echo ""
	@echo "  $(YELLOW)Local Development:$(NC)"
	@echo "    make install          # Install dependencies"
	@echo "    make dev              # Start dev server"
	@echo "    make dev-docker       # Start with Docker"
	@echo ""
	@echo "  $(YELLOW)Testing:$(NC)"
	@echo "    make test             # Run tests"
	@echo "    make test-coverage    # Run with coverage"
	@echo "    make ci               # Run all CI checks"
	@echo ""
	@echo "  $(YELLOW)Docker:$(NC)"
	@echo "    make docker-build     # Build image"
	@echo "    make docker-up ENVIRONMENT=dev"
	@echo ""
	@echo "  $(YELLOW)Deployment:$(NC)"
	@echo "    make deploy-dev       # Deploy to dev"
	@echo "    make deploy-prod IMAGE_TAG=v1.2.3"
	@echo ""
	@echo "  $(YELLOW)Infrastructure:$(NC)"
	@echo "    make terraform-plan ENVIRONMENT=prod"
	@echo "    make terraform-apply ENVIRONMENT=prod"
	@echo ""
