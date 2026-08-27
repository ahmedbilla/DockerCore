# 🛠️ Inception - Developer Documentation

This technical documentation is intended for developers maintaining, extending, or testing the **Inception** infrastructure codebase.

---

## 1. Environment Setup from Scratch

### Prerequisites
1. **Operating System**: Linux (Debian/Ubuntu) or macOS with Docker Desktop.
2. **Tools Required**:
   - `docker` (v24.0+)
   - `docker compose` (v2.20+)
   - `make` (GNU Make)
   - `openssl` (for certificate verification)

### Step-by-Step Initialization

#### 1. Configure Host Domain Resolution
Ensure the custom local domain points to the loopback interface in `/etc/hosts`:
```bash
sudo sh -c 'echo "127.0.0.1 ahbilla.42.fr" >> /etc/hosts'
```

#### 2. Create the Environment File
Copy or create `srcs/.env` with your project configuration:
```bash
cat << 'EOF' > srcs/.env
DB_ROOT_PASSWORD=your_secure_root_password
DB_NAME=wordpress
DB_USER=your_db_user
DB_PASSWORD=your_secure_db_password
DB_HOST=mariadb

DOMAIN_NAME=ahbilla.42.fr
WP_ADMIN_USER=your_wp_admin
WP_ADMIN_PASSWORD=your_secure_wp_admin_password
WP_ADMIN_EMAIL=your_email@domain.com
WP_USER=your_wp_user
WP_USER_PASSWORD=your_secure_wp_user_password
WP_USER_EMAIL=your_user_email@domain.com
EOF
```

---

## 2. Architecture & File Structure

```text
inception/
├── Makefile                          # Primary build and lifecycle automation
├── README.md                         # Project overview and technical comparisons
├── USER_DOC.md                       # User-facing administration guide
├── DEV_DOC.md                        # Developer and maintainer technical guide
├── docs/                             # In-depth concepts and cheatsheets
└── srcs/
    ├── .env                          # Sensitive configuration variables (gitignored)
    ├── docker-compose.yml            # Multi-container service definitions & volume mappings
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile            # Debian 12 + MariaDB Server
        │   ├── conf/config.cnf       # Custom bind-address and port configuration
        │   └── tools/init.sh         # Bootstrap database & user initialization script
        ├── wordpress/
        │   ├── Dockerfile            # Debian 12 + PHP-FPM 8.2 + WP-CLI
        │   └── init.sh               # WP-CLI download, wp-config creation & install script
        └── nginx/
            ├── Dockerfile            # Debian 12 + NGINX + OpenSSL self-signed cert
            └── conf/nginx.conf       # SSL TLSv1.2/TLSv1.3 & FastCGI proxy configuration
```

---

## 3. Building and Launching

### Standard Build and Startup
```bash
make
# Or directly:
make up
```
This triggers:
1. Target directory creation for host-backed persistent storage (`/home/ahbilla/data/mariadb` and `/home/ahbilla/data/wordpress` on Linux; `$HOME/data/` on macOS).
2. Building Docker images with layer caching enabled.
3. Launching containers attached to the `inception` bridge network.

### Force Image Rebuilding
```bash
make build
```

---

## 4. Developer Management Commands

### Interactive Container Shells
To access an interactive shell inside a running service:

```bash
# NGINX Container
docker exec -it nginx bash

# WordPress Container
docker exec -it wordpress bash

# MariaDB Container
docker exec -it mariadb bash
```

### Database Verification via CLI
```bash
# Direct SQL query execution
docker exec -it mariadb mariadb -u your_db_user -pyour_secure_db_password -h 127.0.0.1 -e "USE wordpress; SHOW TABLES;"
```

### WordPress Verification via WP-CLI
```bash
# Check WordPress core status
docker exec -it wordpress wp core is-installed --allow-root

# List configured users
docker exec -it wordpress wp user list --allow-root
```

### NGINX Syntax & SSL Verification
```bash
# Test NGINX configuration syntax
docker exec -it nginx nginx -t

# Inspect SSL certificate details
docker exec -it nginx openssl x509 -in /etc/nginx/ssl/inception.crt -text -noout
```

---

## 5. Data Storage & Persistence Mechanism

### Persistent Storage Design
In accordance with 42 evaluation specifications, persistent data must survive container destruction and system restarts.

| Service | Container Path | Host Storage Path | Stored Content |
|---|---|---|---|
| **MariaDB** | `/var/lib/mysql` | `/home/ahbilla/data/mariadb` | System tables, WordPress relational database tables (`wp_posts`, `wp_users`, etc.) |
| **WordPress** | `/var/www/html` | `/home/ahbilla/data/wordpress` | WordPress core files, media uploads (`wp-content/uploads`), plugins, themes |

### Volume Reset & Deep Clean
To completely wipe all persistent data, remove images, and reset the environment:
```bash
make fclean
```
This executes:
1. `docker compose down -v --rmi all --remove-orphans`
2. Removal of stopped containers and dangling images
3. Deletion of host storage directories (`$(DATA_DIR)`)