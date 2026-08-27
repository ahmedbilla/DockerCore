# 📘 Inception - User Documentation

Welcome to the **Inception** infrastructure user guide. This document provides end-users and administrators with all instructions needed to operate, access, and manage the web infrastructure.

---

## 1. Overview of Services

The infrastructure runs three dedicated containerized services:

| Service | Technology | Role | Port | Access |
|---|---|---|---|---|
| **Web Server** | NGINX | Secure HTTPS Gateway & Reverse Proxy | 443 (HTTPS) | Public (via `ahbilla.42.fr`) |
| **Application** | WordPress + PHP-FPM 8.2 | Content Management System & FastCGI Engine | 9000 (TCP) | Internal Docker Network only |
| **Database** | MariaDB | Relational Database for WordPress content | 3306 (TCP) | Internal Docker Network only |

---

## 2. Starting and Stopping the Project

All operational lifecycle commands are managed through the root `Makefile`:

### Start the Infrastructure
```bash
make
```
* Builds images (if not yet built), prepares host volume storage, sets up network, and starts all containers in detached mode.

### Shut Down the Infrastructure
```bash
make down
```
* Stops and removes containers while preserving all volume databases and website data.

---

## 3. Accessing the Website and Admin Panel

### Public Website
Open your browser and navigate to:
👉 **`https://ahbilla.42.fr`**

> **Note on SSL Warning:**
> Because the infrastructure uses a self-signed TLS certificate generated with OpenSSL for local development, web browsers will show an initial security warning (*"Your connection is not private"*).
> Click **"Advanced"** -> **"Proceed to ahbilla.42.fr"** to view the site.

### WordPress Administration Panel
To manage posts, plugins, themes, and users, navigate to:
👉 **`https://ahbilla.42.fr/wp-login.php`**

* **Default Admin Username:** `your_wp_admin`
* **Default Admin Password:** `your_secure_wp_admin_password`

### Standard User Account
* **Username:** `your_wp_user`
* **Password:** `your_secure_wp_user_password`
* **Role:** `Author`

---

## 4. Credentials & Configuration Management

All credentials and service configuration parameters are centrally located in the `srcs/.env` file:

```env
# Database Credentials
DB_ROOT_PASSWORD=your_secure_root_password
DB_NAME=wordpress
DB_USER=your_db_user
DB_PASSWORD=your_secure_db_password
DB_HOST=mariadb

# WordPress Application Credentials
DOMAIN_NAME=ahbilla.42.fr
WP_ADMIN_USER=your_wp_admin
WP_ADMIN_PASSWORD=your_secure_wp_admin_password
WP_ADMIN_EMAIL=your_email@domain.com
WP_USER=your_wp_user
WP_USER_PASSWORD=your_secure_wp_user_password
WP_USER_EMAIL=your_user_email@domain.com
```

### To Update Credentials:
1. Modify the values in `srcs/.env`.
2. Perform a full reset to re-initialize databases with new credentials:
   ```bash
   make re
   ```

---

## 5. Verifying Service Health and Status

### Check Running Containers
```bash
docker compose -f srcs/docker-compose.yml ps
```
*Expected Output: All three containers (`mariadb`, `wordpress`, `nginx`) should show `Up` status.*

### Inspect Live Logs
```bash
docker compose -f srcs/docker-compose.yml logs -f
```
To view logs for a specific service:
```bash
docker compose -f srcs/docker-compose.yml logs -f nginx
docker compose -f srcs/docker-compose.yml logs -f wordpress
docker compose -f srcs/docker-compose.yml logs -f mariadb
```