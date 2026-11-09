# UI / UX Requirements

## Visual direction
Create a modern, credible university portal: clean light surfaces, deep navy/indigo primary, restrained teal/emerald success, warm amber warnings, neutral page backgrounds, clear typography, consistent spacing and rounded cards. Avoid excessive gradients, glass effects, animation, or oversized hero sections. Prioritize clarity and usability over decoration.

## Shared shell
- Responsive sidebar on desktop; collapsible drawer on mobile.
- Top bar with page title, current user, role, and logout.
- Breadcrumbs where useful.
- Consistent buttons, inputs, badges, tables, cards, modals, toast notifications.
- Accessible labels, keyboard navigation, visible focus, sufficient contrast.
- Loading skeletons/spinners, empty states, error states and retry actions.

## Required pages
1. Login.
2. Admin dashboard with KPI cards and real report charts.
3. User management: searchable/paginated list, create/edit/deactivate modal.
4. Course management: create/edit course, assign faculty.
5. Enrollment management: enroll student, filter by course/student.
6. Faculty dashboard and assigned course list.
7. Faculty exam list with draft/published/closed states.
8. Exam editor: metadata, schedule, duration, marks.
9. Question editor: question text, marks, four options, one correct option.
10. Exam preview and publish confirmation.
11. Student dashboard and enrolled courses.
12. Available exam list with schedule and eligibility state.
13. Exam-taking page: question navigation, answer selection, countdown, submit confirmation, autosave feedback.
14. Student result/history page.
15. Faculty exam result page and reports.
16. Admin reports page.

## Interaction requirements
- All forms validate and show field-level errors.
- Search and filters must call the API, not filter only a tiny hard-coded demo array.
- Tables have useful empty states and pagination where appropriate.
- Confirm destructive actions.
- Disable unavailable actions based on state, but backend must independently enforce state.
- Exam timer is driven by server timestamps/deadline.
- Student exam payload must not reveal correct answer flags.
- Show success/error messages from API responses.
- Charts use API response data and have an accessible table/summary fallback.
