# [FEATURE NAME] - Backend API Specification

## Overview

[Provide a brief description of the feature, its purpose, and how it fits into the overall system. Explain the problem it solves and the key differences from similar features if applicable.]

**Related Resources:**

- Ticket: [TICKET-ID]
- PRD: [PRD_LINK]
- Figma: [FIGMA_LINK]
- Confluence: [CONFLUENCE_LINK]

---

## Status Definitions

<!--
  ACTION REQUIRED: Define all status enums used in this feature.
  Group by entity type if you have multiple entities with different statuses.
  Include clear descriptions for each status value.
-->

### [Entity Name] Statuses

| Status       | Description                             |
| ------------ | --------------------------------------- |
| `[status_1]` | [Description of what this status means] |
| `[status_2]` | [Description of what this status means] |
| `[status_3]` | [Description of what this status means] |

### [Another Entity Name] Statuses (if applicable)

| Status       | Description                             |
| ------------ | --------------------------------------- |
| `[status_1]` | [Description of what this status means] |
| `[status_2]` | [Description of what this status means] |

---

## API Endpoints

### Base URLs

- **Staging**: `[staging-domain]/api`
- **UAT**: `[uat-domain]/api`
- **Production**: `[production-domain]/api` (if applicable)

**Portal Role Required**: `[role_name]` (or authentication requirements)

---

## 1. [Resource Name] Management

<!--
  ACTION REQUIRED: Group related endpoints by resource/domain.
  For each endpoint, provide complete details about:
  - Method and path
  - Description
  - Query parameters (with types and constraints)
  - Request body schema
  - Response schemas (success and error cases)
  - Any special notes or behaviors
-->

### 1.1 List [Resources]

**Endpoint**: `GET /[resources]`

**Description**: [What this endpoint does]

**Query Parameters**:

- `page_id` (integer, required) - Page number, starts with 1
- `per_page` (integer, required) - Results per page, range [MIN, MAX]
- `[filter_param][]` (array[string], optional) - Filter by [field description]
- `from_time` (string, optional) - Filter by [field] start time (ISO 8601)
- `to_time` (string, optional) - Filter by [field] end time (ISO 8601)

**Headers**:

- `Authorization` (required) - User access token
- `Content-Type: application/json`

**Response 200**:

```json
{
  "verdict": "success",
  "message": "...",
  "data": {
    "items": [
      {
        "id": "string",
        "[field_1]": "string",
        "[field_2]": 0,
        "created_at": "string",
        "updated_at": "string"
      }
    ],
    "total": 0
  }
}
```

---

### 1.2 Create [Resource]

**Endpoint**: `POST /[resources]`

**Description**: [What this endpoint does]

**Headers**:

- `Authorization` (required) - User access token
- `Content-Type: application/json` (or `multipart/form-data` for file uploads)

**Request Body**:

```json
{
  "[required_field]": "value",
  "[optional_field]": "value"
}
```

**Response 200**:

```json
{
  "verdict": "success",
  "message": "...",
  "data": {
    "id": "string",
    "[field_1]": "string",
    "status": "[initial_status]",
    "created_at": "string",
    "updated_at": "string"
  }
}
```

**Error Response 400**:

```json
{
  "verdict": "invalid_parameters",
  "message": "[specific error message]"
}
```

---

### 1.3 Get [Resource] Details

**Endpoint**: `GET /[resources]/{id}`

**Description**: [What this endpoint does]

**Path Parameters**:

- `id` (string, required) - The [resource] ID

**Headers**:

- `Authorization` (required) - User access token
- `Content-Type: application/json`

**Response 200**:

```json
{
  "verdict": "success",
  "message": "...",
  "data": {
    "id": "string",
    "[field_1]": "string",
    "[field_2]": 0,
    "created_at": "string",
    "updated_at": "string"
  }
}
```

---

### 1.4 Update [Resource]

**Endpoint**: `PATCH /[resources]/{id}` (or `PUT` for full updates)

**Description**: [What this endpoint does]

**Path Parameters**:

- `id` (string, required) - The [resource] ID

**Headers**:

- `Authorization` (required) - User access token
- `Content-Type: application/json`

**Request Body**:

```json
{
  "[updatable_field]": "new value"
}
```

**Response 200**:

```json
{
  "verdict": "success",
  "message": "...",
  "data": {
    "id": "string",
    "[field_1]": "updated value",
    "updated_at": "string"
  }
}
```

---

### 1.5 Delete [Resource]

**Endpoint**: `DELETE /[resources]/{id}`

**Description**: [What this endpoint does]

**Path Parameters**:

- `id` (string, required) - The [resource] ID

**Headers**:

- `Authorization` (required) - User access token

**Response 200**:

```json
{
  "verdict": "success",
  "message": "[Resource] deleted successfully"
}
```

---

### 1.6 [Custom Action on Resource]

**Endpoint**: `POST /[resources]/{id}/[action]`

**Description**: [What this custom action does]

**Path Parameters**:

- `id` (string, required) - The [resource] ID

**Headers**:

- `Authorization` (required) - User access token
- `Content-Type: application/json`

**Request Body** (if applicable):

```json
{
  "[action_parameter]": "value"
}
```

**Response 200**:

```json
{
  "verdict": "success",
  "message": "[Success message]",
  "data": {
    "id": "string",
    "status": "[new_status]",
    "updated_at": "string"
  }
}
```

**Processing Flow** (if async):

1. [Step 1 - e.g., Status changes to processing]
2. [Step 2 - e.g., Background job enqueued]
3. [Step 3 - e.g., Records updated in batches]
4. [Step 4 - e.g., Final status update]

---

## 2. [Another Resource Group] (if applicable)

### 2.1 [Endpoint Name]

**Endpoint**: `[METHOD] /[path]`

**Description**: [What this endpoint does]

[Follow the same structure as above]

---

## 3. File Operations (if applicable)

### 3.1 Export [Resources]

**Endpoint**: `POST /[resources]/export`

**Description**: Export [resources] to [format]. Limit: ≤ [MAX_LIMIT] records. File name format: `[format description]`.

**Headers**:

- `Authorization` (required) - User access token
- `Content-Type: application/json`

**Request Body**:

```json
{
  "ids": ["id1", "id2"],
  "[filter_param]": "value"
}
```

**Response 200**:

```json
{
  "file_id": "uuid-string"
}
```

**Note**: [Any special processing or data enrichment that happens during export]

---

### 3.2 Download File

**Endpoint**: `GET /download/{id}`

**Description**: Download exported file from storage.

**Path Parameters**:

- `id` (string, required) - File ID from export response

**Response 200**: File content (binary)

---

### 3.3 Upload File

**Endpoint**: `POST /[resources]/upload`

**Description**: Upload [file type] for processing.

**Headers**:

- `Authorization` (required) - User access token
- `Content-Type: multipart/form-data`

**Request Body**:

- `file` (binary, required) - The [file description]
- `[metadata_field]` (string, optional) - [Description]

**Response 200**:

```json
{
  "verdict": "success",
  "message": "...",
  "data": {
    "id": "string",
    "file_name": "string",
    "status": "uploaded",
    "created_at": "string"
  }
}
```

**Error Response 400**:

```json
{
  "verdict": "invalid_parameters",
  "message": "[specific validation error]"
}
```

---

## Data Models

<!--
  ACTION REQUIRED: Define all data models/entities used in the API.
  Include TypeScript-style interfaces or similar pseudocode.
  Document all fields with their types and purpose.
-->

### [Primary Entity]

```typescript
{
  id: string; // [ID format/constraint, e.g., VARCHAR(27), UUID]
  [field_name]: string; // [Description and constraints]
  [numeric_field]: number; // [Description, unit if applicable]
  status: string; // One of: '[status_1]' | '[status_2]' | '[status_3]'
  [relation_id]: string; // Foreign key to [related entity]
  created_at: string; // ISO 8601 timestamp
  updated_at: string; // ISO 8601 timestamp
}
```

### [Secondary Entity]

```typescript
{
  id: string;
  [field_name]: string;
  [array_field]: string[]; // [Description of array contents]
  [nested_object]: {
    [sub_field]: string;
    [sub_field_2]: number;
  };
  created_at: string;
  updated_at: string;
}
```

### Database Schema Updates (if applicable)

**Table: `[table_name]`**

```sql
ALTER TABLE `[database]`.`[table_name]`
ADD COLUMN `[column_name]` VARCHAR(255) NOT NULL AFTER `[after_column]`;
ADD COLUMN `[json_column]` JSON NULL AFTER `[after_column]`;
ADD INDEX `idx_[column]` (`[column]`);

-- [JSON column structure]
{
  "[field]": "string",
  "[field_2]": "number"
}
```

**Table: `[new_table_name]`** (if creating new table)

```sql
CREATE TABLE `[database]`.`[table_name]` (
  `id` VARCHAR(27) NOT NULL,
  `[field]` VARCHAR(255) NOT NULL,
  `status` ENUM('[status_1]', '[status_2]') NOT NULL DEFAULT '[status_1]',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_[field]` (`[field]`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## Error Responses

<!--
  ACTION REQUIRED: Document all possible error responses.
  Include status codes and example response bodies.
-->

### 400 Bad Request

```json
{
  "verdict": "invalid_parameters",
  "message": "[Specific validation error]"
}
```

### 401 Unauthorized

```json
{
  "verdict": "invalid_credentials",
  "message": "Unauthorized"
}
```

### 403 Forbidden

```json
{
  "verdict": "forbidden",
  "message": "Insufficient permissions"
}
```

### 404 Not Found

```json
{
  "verdict": "record_not_found",
  "message": "Not found"
}
```

### 409 Conflict

```json
{
  "verdict": "conflict",
  "message": "[Specific conflict description]"
}
```

### 422 Unprocessable Entity

```json
{
  "verdict": "unprocessable",
  "message": "[Business logic validation error]"
}
```

### 500 Internal Server Error

```json
{
  "verdict": "failure",
  "message": "Internal server error"
}
```

---

## State Transitions

<!--
  ACTION REQUIRED: Document all state machine transitions.
  Use clear notation to show valid state changes.
  Format: [initial_state] → [action/trigger] → [final_state]
-->

### [Entity] Status Transition

```
[*] → [initial_status] (trigger: [event description])
[initial_status] → [next_status] (trigger: [event description])
[next_status] → [success_status] (trigger: [event description])
[next_status] → [failure_status] (trigger: [event description])
[failure_status] → [retry_status] (trigger: [event description, e.g., manual retry])
[success_status] → [*]
```

**Notes**:

- [Any special rules or edge cases in transitions]
- [Conditions that must be met for certain transitions]
- [Irreversible transitions or terminal states]

---

## Integration Notes

<!--
  ACTION REQUIRED: Document all external integrations and dependencies.
  Include service names, API versions, and key integration points.
-->

1. **[External Service Name]**: [Description of integration purpose and how data flows]

2. **[Background Processing System]**: [How async jobs are handled, e.g., Temporal, Bull, etc.]

3. **[Storage Service]**: [Where files/objects are stored, e.g., S3, GCS]

4. **[Third-Party API]**: [What data is exchanged and when]

5. **Concurrency Control**: [How concurrent operations are handled]

6. **Rate Limiting**: [Any rate limits or throttling applied]

7. **[Business Logic Constraints]**:
   - [Constraint 1]
   - [Constraint 2]

---

## Business Rules & Constraints

<!--
  ACTION REQUIRED: Document important business logic and validation rules.
-->

1. **[Rule Category]**:

   - [Specific rule or constraint]
   - [Another rule]

2. **Validation Rules**:

   - [Field validation rule]
   - [Cross-field validation rule]

3. **Limits**:

   - Maximum [X] per [time period/operation]
   - Minimum [Y] required for [operation]

4. **Authorization**:
   - [Who can perform what operations]
   - [Role-based restrictions]

---

## Performance Considerations

<!--
  OPTIONAL: Include if there are specific performance requirements or concerns.
-->

- **Expected Load**: [Request volume, concurrent users, data volume]
- **Response Time SLA**: [p50, p95, p99 targets]
- **Batch Processing**: [How bulk operations are handled]
- **Caching Strategy**: [What is cached and for how long]
- **Database Indexes**: [Key indexes for query performance]

---

## Security Considerations

<!--
  OPTIONAL: Include if there are specific security requirements.
-->

- **Authentication**: [How users are authenticated]
- **Authorization**: [How permissions are enforced]
- **Data Sensitivity**: [PII, financial data, etc.]
- **Audit Logging**: [What operations are logged]
- **Data Retention**: [How long data is kept]

---

## Frontend Integration Checklist

<!--
  ACTION REQUIRED: Create a comprehensive checklist for frontend developers.
  Include all UI components, user flows, and integration points.
-->

### Core Functionality

- [ ] Implement [resource] list page with filtering ([filters list])
- [ ] Add pagination controls (page size: [MIN] - [MAX])
- [ ] Create [resource] creation/upload form
- [ ] Build [resource] detail view
- [ ] Add [resource] edit capability
- [ ] Implement [custom action] flow

### Data Display

- [ ] Display status badges for [entity] statuses
- [ ] Show proper date/time formatting (timezone aware)
- [ ] Handle empty states (no data)
- [ ] Implement search/filter UI
- [ ] Add sorting capabilities

### File Operations

- [ ] Handle file export with download trigger
- [ ] Implement file upload with progress indicator
- [ ] Handle file download from `/download/{id}` endpoint
- [ ] Validate file types and sizes before upload
- [ ] Show file processing status

### User Experience

- [ ] Add loading states for all async operations
- [ ] Implement proper error handling for all API responses
- [ ] Show success/error toast notifications
- [ ] Add confirmation dialogs for destructive actions
- [ ] Implement optimistic UI updates where appropriate

### Validation

- [ ] Client-side validation for required fields
- [ ] Validate [specific constraint, e.g., max 1000 records for export]
- [ ] Handle edge cases (empty lists, max limits, etc.)
- [ ] Display server validation errors clearly

### State Management

- [ ] Set up API client functions for all endpoints
- [ ] Implement caching strategy for list data
- [ ] Handle real-time updates (polling if applicable)
- [ ] Manage form state and validation state

---

**Last Updated**: [DATE]  
**Maintained By**: [TEAM/PERSON]  
**Status**: [Draft | Review | Approved | Implemented]
