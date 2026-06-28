# 🏥 Hospital Database Migration & Automation

A real-world SQL project that transforms a hospital's Excel-based data management system into a scalable relational database. The project focuses on database design, data migration, automation, security, and reporting using MySQL.
---
## 📌 Project Overview
Many hospitals still rely on Excel spreadsheets to manage patients, doctors, appointments, prescriptions, laboratory reports, and billing. This approach often results in duplicate records, inconsistent data, scheduling conflicts, and security issues.
This project migrates those records into a normalized SQL database while enforcing business rules through constraints, triggers, stored procedures, and role-based access control.

---
## 🎯 Objectives

- Design a normalized relational database
- Migrate and clean Excel data
- Maintain data integrity using constraints
- Prevent invalid data with triggers
- Implement role-based access control
- Automate reporting for hospital management
---
## 🛠 Tech Stack

- MySQL
- SQL
- MySQL Workbench
- Excel
---

## 📂 Database Schema

Main entities include:

- Patients
- Doctors
- Departments
- Appointments
- Prescriptions
- Lab Reports
- Billing

### Relationships

- One Department → Many Doctors
- One Doctor → Many Appointments
- One Patient → Many Appointments
- One Appointment → One Billing Record
- One Appointment → Many Prescriptions
- One Appointment → Many Lab Reports

---

## ⚙ Features

### Database Design

- Normalized relational schema
- Primary Keys
- Foreign Keys
- Unique Constraints
- CHECK Constraints

### Data Validation

- Standardized gender values
- Appointment status validation
- Duplicate record removal
- Consistent date formatting

### Automation

- Prevent appointments in the past
- Prevent doctor double-booking
- Automatic billing status updates
- Stored procedures for reporting

### Security

Role-Based Access Control

- Admin
- Senior Doctor
- Doctor
- Lab Technician
- Billing Staff

---

## 📊 Reports

The database supports automated SQL reports including:

- Department Revenue Report
- Patient Billing Summary
- Doctor Workload Report
- Appointment Trend Analysis

---

## 📈 Business Impact

- Improved data integrity
- Reduced duplicate records
- Eliminated doctor scheduling conflicts
- Enhanced patient data security
- Faster report generation
- Scalable database architecture

---

## 📁 Project Structure

```text
Hospital-Database-Migration/
│
├── Data/
├── SQL_Scripts/
├── Reports/
├── README.md
```

## 👨‍💻 Skills Demonstrated

- Relational Database Design
- SQL
- MySQL
- Constraints
- Triggers
- Stored Procedures
- Role-Based Access Control
- Data Cleaning
- Data Migration
---

## ⭐ Key Highlights

✔ Excel to SQL Database Migration

✔ Normalized Database Design

✔ Business Rule Automation

✔ Secure Role-Based Access

✔ Automated Reporting

✔ Scalable Healthcare Database
