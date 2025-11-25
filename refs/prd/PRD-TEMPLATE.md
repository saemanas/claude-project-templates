# PRD-{NNN}: {Feature/Module Name}

**Version**: 1.0
**Status**: Draft | Review | Approved | Deprecated
**Created**: {YYYY-MM-DD}
**Last Updated**: {YYYY-MM-DD}
**Author**: {Author}

---

## 1. Overview

### 1.1 Summary
{One-line summary of the feature}

### 1.2 Background
{Background explanation of why this feature is needed}

### 1.3 Goals
- [ ] {Goal 1}
- [ ] {Goal 2}
- [ ] {Goal 3}

### 1.4 Non-Goals (Out of Scope)
- {Not included in this scope 1}
- {Not included in this scope 2}

---

## 2. User Stories

### 2.1 Primary User
**As a** {user type}
**I want to** {desired action}
**So that** {value to obtain}

### 2.2 Secondary Users
| User Type | Need | Priority |
|-----------|------|----------|
| {type} | {need} | High/Medium/Low |

---

## 3. Functional Requirements

### 3.1 Core Features

#### FR-001: {Feature Name}
**Priority**: Must Have | Should Have | Nice to Have
**Description**: {Detailed description}

**Acceptance Criteria**:
- [ ] {Criterion 1}
- [ ] {Criterion 2}
- [ ] {Criterion 3}

#### FR-002: {Feature Name}
**Priority**: {Priority}
**Description**: {Detailed description}

**Acceptance Criteria**:
- [ ] {Criterion}

### 3.2 User Flows

```
[Start] → [Action 1] → [Action 2] → [Result]
                    ↘ [Error Handling] → [Recovery]
```

---

## 4. Non-Functional Requirements

### 4.1 Performance
| Metric | Target | Measurement |
|--------|--------|-------------|
| Response Time | < 200ms | p95 |
| Throughput | > 1000 req/s | Peak |
| Availability | 99.9% | Monthly |

### 4.2 Security
- [ ] Authentication required: {Yes/No}
- [ ] Permission level: {Admin/User/Guest}
- [ ] Data encryption: {Yes/No}
- [ ] OWASP Top 10 compliance: {items}

### 4.3 Scalability
{Scalability requirements}

### 4.4 Compliance
{Regulatory compliance - GDPR, privacy laws, etc.}

---

## 5. Technical Considerations

### 5.1 Dependencies
| Dependency | Version | Purpose |
|------------|---------|---------|
| {package} | {version} | {purpose} |

### 5.2 Data Model
```
Entity: {EntityName}
├── id: UUID (PK)
├── field1: string
├── field2: integer
├── created_at: timestamp
└── updated_at: timestamp
```

### 5.3 API Endpoints
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/v1/resource | Retrieve resource |
| POST | /api/v1/resource | Create resource |

### 5.4 Integration Points
- {Integration system 1}: {Integration method}
- {Integration system 2}: {Integration method}

---

## 6. UI/UX Considerations

### 6.1 Wireframes
{Wireframe link or description}

### 6.2 User Interface Requirements
- [ ] Responsive design required
- [ ] Accessibility (WCAG 2.1 AA)
- [ ] Multi-language support: {Yes/No}

---

## 7. Testing Strategy

### 7.1 Unit Tests
- {Test item 1}
- {Test item 2}

### 7.2 Integration Tests
- {Test item 1}

### 7.3 E2E Tests
- {Scenario 1}

### 7.4 Edge Cases
| Case | Expected Behavior |
|------|------------------|
| {case} | {expected behavior} |

---

## 8. Rollout Plan

### 8.1 Phases
| Phase | Scope | Timeline |
|-------|-------|----------|
| Alpha | Internal testing | {period} |
| Beta | Limited users | {period} |
| GA | All users | {period} |

### 8.2 Feature Flags
- `feature_xxx_enabled`: {description}

### 8.3 Rollback Plan
{Rollback procedure}

---

## 9. Metrics & Success Criteria

### 9.1 KPIs
| Metric | Current | Target | Timeline |
|--------|---------|--------|----------|
| {metric} | {current} | {target} | {period} |

### 9.2 Monitoring
- Dashboard: {link}
- Alerts: {conditions}

---

## 10. Open Questions

| # | Question | Owner | Status | Answer |
|---|----------|-------|--------|--------|
| 1 | {question} | {owner} | Open/Resolved | {answer} |

---

## 11. References

- Related PRDs: {link}
- Design Docs: {link}
- External Docs: {link}

---

## Changelog

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | {date} | {author} | Initial draft |

---

**Approval**:
- [ ] Product Owner: _______________
- [ ] Tech Lead: _______________
- [ ] Design Lead: _______________
