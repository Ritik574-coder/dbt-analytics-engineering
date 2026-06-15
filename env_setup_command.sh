####################################################################################
# PROJECT SETUP: requirement tools for data pipeline (Docker + SQL Server)
# Author: Ritik
# Purpose: Setup virtual environment, install dependencies, configure database
#          credentials, and run the pipeline script.
####################################################################################



################################################################################
################### DOCKER INSTRALLITION AND SETUP #############################
################################################################################
#Install dependencies
sudo apt update
sudo apt install ca-certificates curl gnupg lsb-release

#Adding Docker official GPG key
sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Adding Docker repository
echo \
"deb [arch=$(dpkg --print-architecture) \
signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt update

sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Starting and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

#Fixing permission
sudo usermod -aG docker $USER

# Verify versions
docker --version
docker compose version

################################################################################
################### MSSQL INSTRALLITION AND SETUP ##############################
################################################################################
# Pulling SQL Server image
docker pull mcr.microsoft.com/mssql/server:2022-latest

# creting and running container
docker run -e "ACCEPT_EULA=Y" \
    -e "MSSQL_SA_PASSWORD=YourStrong!Passw0rd" \
    -p 1433:1433 \
    --name sqlserver \
    -v sql_data:/var/opt/mssql \
    -d mcr.microsoft.com/mssql/server:2022-latest

# Check running containers
docker ps

# Check all containers 
docker ps -a

# Check downloaded images
docker images

# Check Docker volumes 
docker volume ls

# Start container 
docker start sqlserver

# Stop container
docker stop sqlserver

# Access container terminal
docker exec -it -u root sqlserver bash


# Add Microsoft repo
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list

# Update
sudo apt update

# Install ODBC Driver 18 
sudo ACCEPT_EULA=Y apt install msodbcsql18

# Optional but useful tools
sudo apt install unixodbc-dev

# This opens SQL CLI (sqlcmd)
docker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd 
-S localhost -U sa -P "YourStrong!Passw0rd"

# moving data 
docker cp /workspaces/YourFieName/dataset sqlserver:/data/

# access SQL serve cli
docker exec -it -u root sqlserver bash

#chage file permition 
chmod -R 777 /workspaces/YourFieName/dataset
################################################################################
########################### ADDING GIT COMMAND  ################################
################################################################################  

# authenticate github account
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"

# create new branch
git branch warehouse_branch

# switch to branch
git switch warehouse_branch

# add single file
git add README.md

# check repository status
git status

# add all files
git add .

# commit changes
git commit -m "Implement bronze layer ETL process"

# commit with co-author
git commit -m "Refactor silver layer SQL scripts for improved data structure and integrity

Co-authored-by: ritsky-project <ritsky598@gmail.com>"

# push changes to github
git push origin warehouse_branch

# view commit history
git log

################################################################################
########################### ADDING SUPERSET COMMAND  ###########################
################################################################################   
# Get Superset 
git clone https://github.com/apache/superset

# Start the latest official release of Superset
# Enter the repository you just cloned
$ cd superset

# Set the repo to the state associated with the latest official version
$ git checkout tags/6.0.0

# Fire up Superset using Docker Compose
$ docker compose -f docker-compose-image-tag.yml up

# Log into Superset 
username: admin
password: admin

################################################################################
########################### ADDING DBT COMMANDS ###############################
################################################################################

# =============================================
# DBT INSTALLATION AND SETUP
# =============================================
# Install dbt-core and SQL Server adapter
pip install dbt-core dbt-sqlserver

# Verify dbt installation
dbt --version

# =============================================
# DBT PROJECT INITIALIZATION
# =============================================
# Initialize a new dbt project (run in your project directory)
dbt init retail_analytics

# Navigate into the project directory
cd retail_analytics

# =============================================
# DBT PROJECT COMMANDS
# =============================================

# --- DEBUGGING AND VALIDATION ---
# Check dbt project configuration and connection
dbt debug

# Compile SQL files without running (checks for syntax errors)
dbt compile

# List all models in the project (shows DAG structure)
dbt ls

# List models in a specific path (e.g., staging)
dbt ls --select staging

# --- RUNNING MODELS ---
# Run all models in the project
dbt run

# Run a specific model (e.g., stg_customers)
dbt run --models stg_customers

# Run models with a specific tag (e.g., staging)
dbt run --select tag:staging

# Run models incrementally (for incremental models)
dbt run --full-refresh  # Forces a full rebuild

# --- TESTING ---
# Run all tests in the project
dbt test

# Run tests for a specific model
dbt test --models stg_customers

# Run tests for a specific test type (e.g., not_null)
dbt test --select test_type:not_null

# --- DOCUMENTATION ---
# Generate dbt documentation (lineage, DAG, etc.)
dbt docs generate

# Serve dbt documentation locally (opens in browser)
dbt docs serve

# --- SNAPSHOTS (SCD Type 2) ---
# Run snapshots to track historical changes
dbt snapshot

# --- SEEDS (Static Data) ---
# Load CSV files defined in the seeds directory
dbt seed

# --- CLEANUP ---
# Remove the target/ directory (clean compiled files)
dbt clean

# --- DEPENDENCY GRAPH ---
# Visualize the DAG (requires graphviz)
dbt docs generate
dbt docs serve  # Open http://localhost:8080 to view lineage

# =============================================
# DBT ENVIRONMENT AND PROFILES
# =============================================
# List available profiles
dbt list-profiles

# Test a specific profile connection
dbt debug --profile dbt_retail_analytics

# Run dbt with a specific profile
dbt run --profile dbt_retail_analytics

# Run dbt with a specific target (e.g., prod)
dbt run --target prod

# =============================================
# DBT ADVANCED COMMANDS
# =============================================
# Run only models that have changed since the last run
dbt run --select state:modified+

# Run models and their parents (upstream)
dbt run --models fct_sales+1

# Run models and their children (downstream)
dbt run --models stg_customers+1+

# Run a specific path (e.g., all models under staging/)
dbt run --select staging

# Exclude specific models from running
dbt run --exclude tag:slow

# Run dbt with custom variables (e.g., for dynamic SQL)
dbt run --var 'start_date: 2023-01-01'

# =============================================
# DBT UTILITY COMMANDS
# =============================================
# Show dbt version and plugins
dbt --version

# Show all available commands
dbt --help

# Show help for a specific command (e.g., run)
dbt run --help

# =============================================
# DBT CI/CD COMMANDS 
# =============================================
# Run dbt with a specific profile directory 
dbt run --profiles-dir /path/to/profiles

# Run dbt with a custom project directory
dbt run --project-dir /path/to/project

# Run dbt in a specific environment
dbt run --target prod --profiles-dir /path/to/profiles