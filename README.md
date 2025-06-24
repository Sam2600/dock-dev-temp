# MM Book Store Backend

This repository contains the Docker setup and scripts for developing the Laravel project with PHP, Nginx, and MySQL or PostgreSQL.

---

## 📦 Repository Structure

```
dock-dev-temp/
├── docker-compose.local.yml      # For local development
├── docker-compose.prod.yml       # For production deployment
├── docker-compose.test.yml       # For application testing
├── nginx/
│   ├── Nginx.Dockerfile          # Nginx Dockerfile (dev)
│   ├── Nginx.prod.Dockerfile     # Nginx Dockerfile (prod)
│   └── sites/
│       ├── default_api.conf      # api server config file
│       └── default_web.conf      # web application config file
├── php/
│   ├── PHP.Dockerfile            # PHP Dockerfile (dev)
│   ├── PHP.prod.Dockerfile       # PHP Dockerfile (prod)
│   └── scripts/
│       ├── entrypoint.sh         # Entrypoint for dev
│       └── entrypoint.prod.sh    # Entrypoint for prod
```

---

## 🚀 Quick Start

### 1. **Clone this repository**

> **Important:**  
> Clone or pull this repository **inside your Laravel project root directory**.

```sh
git clone https://github.com/Sam2600/dock-dev-temp.git
cd dock-dev-temp
```

### 2. **Copy `.env.example` to `.env` in your Laravel root (if not present)**

```sh
cp .env.example .env
```

### 3. **Set up environment variables**

- Copy and edit the `.env` files as needed.
- Make sure to set variables in the `.env` file and/or Docker Compose files for:
  - `PRJ_NAME`
  - `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_DATABASE`, `MYSQL_ROOT_PASSWORD`
  - Any other required variables for your workflow

### 4. **Local Development**

```sh
docker-compose -f docker-compose.local.yml up --build
```

- Access the app at `http://localhost:80` or  `http://localhost:88`

### 5. **Production Build & Deployment**

```sh
docker-compose -f docker-compose.prod.yml up --build -d
```

### 6. **Testing Pre-built Images**

```sh
docker-compose -f docker-compose.test.yml up -d
```

---

## 🛠️ Useful Commands

- **Rebuild images:**  
  `docker-compose -f docker-compose.local.yml build --no-cache`
- **Stop containers:**  
  `docker-compose -f docker-compose.local.yml down -v`
- **View logs:**  
  `docker-compose -f docker-compose.local.yml logs -f`
- **View images:**
   `docker image ls`
---

## 📝 Notes

- **Entrypoint scripts** handle Composer install, `.env` creation, cache clear, app optimization cmd and database migrations automatically.
- **For production**, the whole project is copied into the Nginx image.
- **For development**, the whole project is bind-mounted for live reload.
---

## 🤝 Contributing

1. Fork this repo and clone it inside your Laravel root.
2. Create a new branch for your feature or fix.
3. Commit and push your changes.
4. Open a pull request.

---

## 📚 References

- [Laravel Documentation](https://laravel.com/docs)
- [Docker Documentation](https://www.docker.com/)
- [Nginx Documentation](https://nginx.org/)
- [laradock Documentation](https://laradock.io/)

---

## 📬 Support

If you have any questions, please contact the project maintainer or open an issue.
