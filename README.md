# TaxView360 - Detailed Plan

## 1. Homepage (Login Page)

- **Login Form**:
  - Fields:
    - **Username**: Users can enter their username (email or custom identifier).
    - **Password**: A password field with optional eye icon to toggle visibility.
    - **Remember Me**: Checkbox for users who want to stay logged in across sessions.
  - **Error Handling**: If login fails, display clear error messages like "Incorrect username or password".
  - **Two-Factor Authentication**: After successful login, request a second factor (e.g., an OTP sent to their email/phone).
  - **Captcha**: Add a CAPTCHA (e.g., Google reCAPTCHA) to prevent bots.
  
- **Register Modal**:
  - **Activation**: The "Need an account?" link opens the **Register Modal** (slide-in or modal popup).
  - **Fields**:
    - Full Name
    - Email (username)
    - Password (with strength indicator)
    - Confirm Password
    - Agree to Terms (checkbox)
  - **Validation**: Ensure email is unique and passwords match. Use a password strength meter (at least 8 characters, one uppercase letter, one number, and a special character).
  - **Confirmation**: After registration, send a confirmation email with an activation link.

#### Security Measures:
- **Data Encryption**: Ensure all sensitive user data (passwords) is encrypted using strong hashing algorithms (e.g., bcrypt).
- **Token-based Authentication**: Use JWT tokens for secure, stateless authentication.
- **Session Management**: Implement token-based authentication for secure session management.
  
## 2. Client Update Page

- **Client List**:
  - **Table Design**: Use alternating row colors for readability.
  - **Actions**: Add an "Edit" button in each row to open the client details for modification.
  - **Pagination**: Implement server-side pagination for large datasets, allowing users to browse clients across multiple pages.
  
- **Client Details**:
  - Allow for updating contact details, phone numbers, addresses, and other essential client info.
  - **Audit Log**: For every change made, store an audit record in the database. This will include who made the update, when, and what was changed.

## 3. Account Page

- **Work Status**: 
  - Use color coding (e.g., red for pending, green for completed, yellow for in-progress) for intuitive work status representation.
  - Allow sorting by status or update time.
  - **Activity Log**: 
    - Include detailed logs with timestamps, user info, and any relevant comments.
    - Provide a "View History" button to display all updates made to the account.

## 4. Audit Page

- **Audit Status**: Display the status in color-coded labels.
- **Audit List**: The table should have expandable rows, allowing users to see more details for each audit.
  - **Columns**: Audit ID, Company Name, Audit Type, Status, Last Updated, User who updated.
  - Include **filters** for auditing type, company, and status.

- **Audit History**: Provide a sidebar or expandable section to view detailed logs of past audits.

## 5. Tax Page (View-Only)

- **Real-Time Data Sync**:
  - **WebSocket or AJAX**: Use real-time updates with WebSockets to push new tax data to the client’s browser or use AJAX to refresh data at intervals (e.g., every minute).
  
- **Columns**:
  - Tax Form Type (Borang C, Borang E, CP204) with descriptions on hover.
  - **Filter/Search**: Allow users to search by tax form type or company ID.
  - **Sorting & Pagination**: Add pagination and sort by any column (e.g., tax value, filing date).

## 6. Navigation Simplicity

- **Sticky Navigation Bar**: Make the navigation bar sticky so that it remains visible when the user scrolls down.
- **Responsive Layout**: Use a collapsible side menu for mobile devices, with easy navigation through icons and labels.

## 7. Design Consistency & Visuals

- **Theme**: Consistent use of colors (Blue, Grey, and White) across all pages.
- **Typography**: Opt for modern and readable fonts like Roboto or Open Sans for all headings and body text.
- **Hover Effects**: Buttons should have hover effects to indicate interactivity. Also, highlight editable fields when hovered over.

## Database Structure (Relational Database Design)

### Tables:

1. **Users**
   - **user_id** (PK)
   - **full_name**
   - **email** (Unique)
   - **password_hash**
   - **role** (admin, accountant, auditor)
   - **status** (active, suspended)
   - **created_at**
   - **updated_at**

2. **Clients**
   - **client_id** (PK)
   - **company_name**
   - **contact_name**
   - **contact_email**
   - **contact_phone**
   - **assigned_accountant_id** (FK to Users)
   - **status** (active, inactive)
   - **created_at**
   - **updated_at**

3. **Client Updates** (Audit Log for Client Updates)
   - **update_id** (PK)
   - **client_id** (FK to Clients)
   - **updated_by** (FK to Users)
   - **update_details** (JSON or text)
   - **updated_at**

4. **Accounts**
   - **account_id** (PK)
   - **client_id** (FK to Clients)
   - **work_status** (enum: in_progress, completed, pending)
   - **last_updated_by** (FK to Users)
   - **last_updated_at**

5. **Audits**
   - **audit_id** (PK)
   - **company_name**
   - **audit_type** (Tax, Financial)
   - **status** (pending, in_progress, completed)
   - **assigned_auditor_id** (FK to Users)
   - **created_at**
   - **updated_at**

6. **Audit Logs** (Audit History)
   - **log_id** (PK)
   - **audit_id** (FK to Audits)
   - **action_taken** (e.g., status update)
   - **performed_by** (FK to Users)
   - **created_at**

7. **Tax Records** (For real-time tax data)
   - **tax_record_id** (PK)
   - **company_id**
   - **tax_form_type** (Borang C, Borang E, CP204)
   - **tax_value**
   - **filing_date**
   - **last_updated_by** (FK to Users)
   - **last_updated_at**

## Additional Considerations:

### Role-based Access Control:
- Users can have different roles (admin, accountant, auditor).
  - **Admin**: Full access (can create/update/delete clients, accounts, and audits).
  - **Accountant**: Can update client accounts and manage their respective clients.
  - **Auditor**: View and manage audits, with read-only access to tax data.

### Security Measures:
- **Data Encryption**: Ensure all sensitive user data (passwords) is encrypted using strong hashing algorithms (e.g., bcrypt).
- **Token-based Authentication**: Use JWT tokens for secure, stateless authentication.
- **Role-based Access**: Each user’s access is determined by their role, ensuring they only access what they are authorized to.

### Performance:
- **Caching**: Implement server-side caching (Redis or Memcached) to speed up frequently requested data.
- **Optimized Queries**: Use indexed columns (e.g., client_id, user_id) to speed up queries, especially in the Client Update, Audit, and Tax Pages.

### Backup & Recovery:
- Regularly back up the database and maintain disaster recovery protocols.

### User Experience:
- Provide a **progress bar** or spinner for long-running tasks (e.g., client updates or fetching tax data).
- Ensure the interface is **responsive**, especially for users accessing on mobile devices.
