# API Documentation

Complete API reference for the Sportification Backend with comprehensive documentation for all endpoints.

## 📡 API Reference

### 📚 Main Documentation Files

- **[COMPLETE_API_REFERENCE.md](COMPLETE_API_REFERENCE.md)** - **NEW! Complete API reference with all endpoints**
  - ✅ All 9 API modules fully documented
  - ✅ Detailed request/response examples
  - ✅ Parameter tables with validation rules
  - ✅ Authentication requirements
  - ✅ Error responses with codes
  - ✅ curl examples for all endpoints
  - ✅ Common patterns and formats
  - ✅ Rate limiting information
  - ✅ WebSocket events

- **[API_DOCUMENTATION.md](API_DOCUMENTATION.md)** - Extended API documentation
  - Authentication endpoints (login, register, OAuth, MFA)
  - User management APIs
  - Team management APIs
  - Match management APIs
  - Tournament management APIs
  - Venue management APIs
  - Chat APIs
  - Notification APIs
  - Admin APIs
  - Request/response schemas
  - Error handling
  - Rate limiting
  - WebSocket events

## 🚀 Quick Start

### Authentication

```bash
# Register a new user
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePass123!",
  "username": "johndoe"
}
```

### Using the API

```bash
# Get user profile (authenticated)
GET /api/users/me
Authorization: Bearer <your-jwt-token>
```

## 📚 Related Documentation

- **[Authentication Guide](../features/auth.md)** - Authentication system details
- **[Security Guide](../features/security.md)** - Security best practices
- **[WebSocket API](../features/websockets.md)** - Real-time communication
- **[Integration Examples](../examples/)** - Complete integration workflows

## 🔗 External Links

- [OpenAPI Specification](../../openapi.yaml) - OpenAPI/Swagger spec
- [Postman Collection](#) - API testing collection

---

**[⬆ Back to Documentation](../README.md)**
