# 📝 Blog Platform

A full-stack blog application built with Spring Boot, React JS, and MySQL.

## 🛠 Tech Stack
| Layer | Technology |
|---|---|
| Backend | Spring Boot 3, Spring Security, JWT |
| Database | MySQL 8, Flyway Migrations |
| Frontend | React JS, Vite, Axios |
| Testing | JUnit 5, Mockito, JaCoCo (80%+ coverage) |
| DevOps | Docker, GitHub Actions CI/CD |
| Deployment | Railway (Backend), Vercel (Frontend) |

## 🏗 Architecture
Monolithic architecture with layered design:
- Controller → Service → Repository → MySQL

## ✨ Features
- JWT-based Authentication & Authorization
- Role-based access (Admin / Author / Reader)
- Blog posts with categories and tags
- Nested comments (reply to comments)
- Multi-environment config (dev / staging / prod)
- CI/CD pipeline with coverage gate

## 🚀 Running Locally
```bash
# Start MySQL
docker run -d --name blogspot-mysql \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=blogspot_dev \
  -p 3306:3306 mysql:8.0

# Run backend
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

## 📁 Project Structure
```
src/
├── config/        # Security, JPA, CORS config
├── controller/    # REST endpoints
├── service/       # Business logic
├── repository/    # JPA repositories
├── entity/        # JPA entities
├── dto/           # Request/Response objects
├── security/      # JWT filter and utilities
├── exception/     # Global exception handler
└── enums/         # Role, PostStatus
```

## 🔐 API Endpoints
| Method | Endpoint | Access |
|---|---|---|
| POST | /api/auth/register | Public |
| POST | /api/auth/login | Public |
| GET | /api/posts | Public |
| POST | /api/posts | Author, Admin |
| DELETE | /api/posts/{id} | Admin |

## 👨‍💻 Author
[Karthick Arumugam] — [LinkedIn URL] — [Portfolio URL]