*This project has been created as part of the 42 curriculum by ahbilla.*

# Inception - System Administration Infrastructure with Docker

## Description
Inception is a system administration project in the 42 curriculum designed to broaden understanding of virtualization, containerization, and microservices architecture. The goal is to build a complete, multi-container web infrastructure running WordPress, MariaDB, and NGINX on a dedicated Docker bridge network, with persistent storage backed by Docker named volumes, strictly adhering to container security best practices.

### Architecture Overview
- **NGINX**: The sole entrypoint to the entire infrastructure, exposing only Port 443 with TLSv1.2 and TLSv1.3 protocols.
- **WordPress + PHP-FPM**: Manages dynamic content and FastCGI request handling on port 9000.
- **MariaDB**: The relational database engine handling all WordPress persistent database records on port 3306.
- **Named Volumes**: Dedicated persistent data storage mapped to host directories for database records and website assets.
- **Docker Network**: Custom isolated bridge network (`inception`) connecting all services via Docker's embedded DNS server.

---

## Instructions

### Prerequisites
- Docker & Docker Compose (v2 or later)
- GNU Make

### 1. Local Domain Setup
Map the domain name `ahbilla.42.fr` to your local host IP address in `/etc/hosts`:
```bash
sudo sh -c 'echo "127.0.0.1 ahbilla.42.fr" >> /etc/hosts'
```

### 2. Environment Configuration
Create your environment configuration file at `srcs/.env`:
```env
# MariaDB Settings
DB_ROOT_PASSWORD=your_secure_root_password
DB_NAME=wordpress
DB_USER=your_db_user
DB_PASSWORD=your_secure_db_password
DB_HOST=mariadb

# WordPress Settings
DOMAIN_NAME=ahbilla.42.fr
WP_ADMIN_USER=your_wp_admin
WP_ADMIN_PASSWORD=your_secure_wp_admin_password
WP_ADMIN_EMAIL=your_email@domain.com
WP_USER=your_wp_user
WP_USER_PASSWORD=your_secure_wp_user_password
WP_USER_EMAIL=your_user_email@domain.com
```

### 3. Compilation & Execution
To build and launch the complete stack in the background:
```bash
make
```

### 4. Stopping and Managing the Stack
- **Stop services**: `make down`
- **Clean unused resources**: `make clean`
- **Full reset (removes volumes, images, and data)**: `make fclean`
- **Rebuild and restart**: `make re`

---

## Architectural & Technical Comparisons

### 1. Virtual Machines vs Docker
| Feature | Virtual Machine (VM) | Docker Container |
|---|---|---|
| **Architecture** | Emulates complete hardware; runs a full Guest OS with its own kernel. | Shares the Host OS kernel; uses Linux kernel isolation primitives. |
| **Resource Overhead** | Heavy: consumes gigabytes of RAM and disk storage per VM. | Lightweight: requires megabytes, minimal CPU/RAM overhead. |
| **Startup Time** | Slow: takes minutes to boot full OS. | Instantaneous: starts in milliseconds as a standard process. |
| **Isolation Mechanism** | Hypervisor-level hardware virtualization (Type 1 or Type 2). | Kernel-level isolation via **Namespaces** (PID, NET, MNT, IPC, UTS, USER) and resource constraints via **Cgroups**. |

### 2. Secrets vs Environment Variables
- **Environment Variables (`.env`)**:
  - Injected into container environments at startup.
  - Visible via `docker inspect` and to all child processes inside the container.
  - Suitable for non-confidential configuration (ports, domain names, service flags).
- **Docker Secrets**:
  - Securely stored in encrypted format and mounted in memory (tmpfs at `/run/secrets/`).
  - Never written to disk or exposed in container metadata or inspection logs.
  - Recommended for production credentials, API tokens, and private cryptographic keys.

### 3. Docker Network vs Host Network
- **Docker Bridge Network (Used in this project)**:
  - Creates an isolated private subnet with its own virtual interfaces and routing table.
  - Enables automatic service discovery and DNS resolution by service name (e.g. `mariadb:3306`).
  - Containers only expose designated ports to other internal containers without opening ports on the host.
- **Host Network (`network: host`)**:
  - Directly attaches containers to the host's network stack without namespace isolation.
  - Leads to port conflicts on the host and removes network-level service isolation.
  - Prohibited in Inception for security and design reasons.

### 4. Docker Volumes vs Bind Mounts
- **Docker Named Volumes (Used in this project)**:
  - Managed directly by the Docker daemon lifecycle.
  - Abstract storage location, handle permissions safely across platforms, and guarantee data persistence across container updates and restarts.
  - Backed by designated storage on the host (e.g. `/home/ahbilla/data/`).
- **Bind Mounts**:
  - Directly map a specific file or folder from the host filesystem into a container.
  - Dependent on host directory structure and file permission compatibility.

---

## Resources & AI Usage

### References
**Docker**
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Introduction to Docker](https://www.geeksforgeeks.org/devops/introduction-to-docker/)

**NGINX**
- [NGINX Documentation](https://nginx.org/en/docs/)
- [Purpose of the nginx -g 'daemon off;' command](https://labex.io/questions/what-is-the-purpose-of-the-nginx-g-daemon-off-command-in--871954)

**MariaDB**
- [mariadb-install-db](https://mariadb.com/docs/server/clients-and-utilities/deployment-tools/mariadb-install-db)
- [mysql_install_db](https://dev.mysql.com/doc/refman/5.7/en/mysql-install-db.html)
- [MariaDB Remote Connection Guide](https://mariadb.com/docs/server/mariadb-quickstart-guides/mariadb-remote-connection-guide)
- [MariaDB architecture and best practices](https://dev.to/farhadrahimiklie/a-complete-guide-to-mariadb-architecture-features-installation-and-best-practices-3kpf)

**WordPress**
- [What is WordPress?](https://www.geeksforgeeks.org/wordpress/what-is-wordpress/)

### AI Assistance Declaration
AI was used as a learning assistant throughout the project.

It was mainly used for:
- Understanding Docker concepts, networking, volumes, and secrets.
- Understanding NGINX configurations and PHP-FPM communication.
- Reviewing shell scripts for entrypoints.