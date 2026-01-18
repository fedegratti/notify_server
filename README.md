# Notification Management API

A Rails-based notification management system that allows users to create, manage, and send notifications through multiple channels including email, SMS, and push notifications. Built with a microservices-ready architecture for easy extensibility.

## Features

- **User Authentication**: Complete user management with Devise and JWT authentication
- **Multi-Channel Notifications**: Send notifications via email, SMS, and push notifications
- **RESTful API**: Full CRUD operations for notifications
- **Microservices Architecture**: Extensible channel-based sending system
- **Security**: JWT-based authentication with token revocation
- **Testing**: Comprehensive test suite with RSpec
- **Code Quality**: Rubocop linting and code formatting

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Database Setup](#database-setup)
- [Running the Application](#running-the-application)
- [API Documentation](#api-documentation)
- [Testing](#testing)
- [Architecture](#architecture)
- [Contributing](#contributing)

## Requirements

- **Ruby**: 3.2.2
- **Rails**: 7.1.6
- **Database**: PostgreSQL
- **Web Server**: Puma

## Installation

1. **Clone the repository**
   ```bash
   git clone git@github.com:fedegratti/notify_server.git
   cd notify_server
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

## Configuration

### Environment Variables

Create a `.env` file in the root directory with the following variables:

```env
# Database Configuration
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres
DATABASE_HOST=localhost

# JWT Configuration
DEVISE_JWT_SECRET_KEY=your_jwt_secret_key
```

### CORS Configuration

The application includes CORS support for frontend integration. Configure allowed origins in `config/initializers/cors.rb`.

## Database Setup

1. **Create and setup the database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

2. **Verify database connection**
   ```bash
   rails db:version
   ```

## Running the Application

### Development

```bash
rails server
```

The API will be available at `http://localhost:3001`

### Using Docker

```bash
docker build -t notify-server .
docker run -p 3001:3001 notify-server
```

## API Documentation

### Authentication Endpoints

#### Sign Up
```http
POST /signup
Content-Type: application/json

{
  "user": {
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123"
  }
}
```

#### Sign In
```http
POST /login
Content-Type: application/json

{
  "user": {
    "email": "john@example.com",
    "password": "password123"
  }
}
```

#### Sign Out
```http
DELETE /logout
Authorization: Bearer <jwt_token>
```

### Notification Endpoints

All notification endpoints require authentication via JWT token in the Authorization header.

#### Create Notification
```http
POST /notifications
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "notification": {
    "title": "Welcome!",
    "content": "Thank you for joining our service",
    "channel": "email",
    "user_id": 1
  }
}
```

#### List Notifications
```http
GET /notifications
Authorization: Bearer <jwt_token>
```

#### Get Notification
```http
GET /notifications/:id
Authorization: Bearer <jwt_token>
```

#### Update Notification
```http
PUT /notifications/:id
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "notification": {
    "title": "Updated Title",
    "content": "Updated content"
  }
}
```

#### Delete Notification
```http
DELETE /notifications/:id
Authorization: Bearer <jwt_token>
```

### Supported Channels

- `email` - Email notifications
- `sms` - SMS notifications  
- `push` - Push notifications

## Testing

### Run the full test suite
```bash
bundle exec rspec
```

### Run specific tests
```bash
# Models
bundle exec rspec spec/models/

# Controllers
bundle exec rspec spec/requests/

# Specific test file
bundle exec rspec spec/models/user_spec.rb
```

### Code Coverage
```bash
COVERAGE=true bundle exec rspec
```

View coverage report at `coverage/index.html`

### Code Quality
```bash
# Run Rubocop
bundle exec rubocop

# Auto-fix issues
bundle exec rubocop -a
```

## Architecture

### Service-Oriented Design

The application follows a service-oriented architecture with clear separation of concerns:

```
app/
├── controllers/          # HTTP request handling
├── models/               # Data models and business logic
├── services/             # Business logic and external integrations
│   └── notifications/    # Notification sending services
│       └── channels/     # Channel-specific implementations
└── serializers/          # JSON API response formatting
```

### Notification Channel System

The notification system is designed for easy extensibility:

1. **Base Service**: `Notifications::Send` - Orchestrates notification delivery
2. **Channel Services**: Individual services for each delivery method
   - `Notifications::Channels::Email`
   - `Notifications::Channels::Sms`
   - `Notifications::Channels::Push`

### Adding New Channels

To add a new notification channel:

1. Create a new service class in `app/services/notifications/channels/`
2. Implement the `call(notification)` method
3. Add the channel to the `Notification` model enum
4. Update the migration to include the new channel option

Example:
```ruby
# app/services/notifications/channels/slack.rb
module Notifications
  module Channels
    class Slack < ApplicationService
      def call(notification)
        # Slack notification logic
      end
    end
  end
end

# Update notification.rb model
enum :channel, { email: 0, sms: 1, push: 2, slack: 3 }
```

## Security Features

- **JWT Authentication**: Stateless authentication with token revocation
- **CORS Protection**: Configurable cross-origin request handling
- **Parameter Filtering**: Sensitive data filtering in logs
- **SQL Injection Protection**: ActiveRecord ORM with parameterized queries
- **Password Encryption**: Bcrypt password hashing via Devise

## Deployment

### Production Setup

1. Set production environment variables
2. Precompile assets (if using):
   ```bash
   RAILS_ENV=production rails assets:precompile
   ```
3. Run database migrations:
   ```bash
   RAILS_ENV=production rails db:migrate
   ```
4. Start the server:
   ```bash
   RAILS_ENV=production rails server
   ```

### Health Check

The application includes a health check endpoint:
```http
GET /up
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Rails conventions and best practices
- Write tests for new features and bug fixes
- Run Rubocop before submitting PRs
- Update documentation as needed

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, please open an issue on GitHub or contact the development team.
