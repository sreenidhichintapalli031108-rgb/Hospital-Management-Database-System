# Hospital Management System

A relational database case study built with MySQL for the Database Management Systems course, Department of CSE (AI&ML), BVRIT HYDERABAD College of Engineering for Women.

## Overview

Hospitals that keep records by hand often end up with duplicate data, calculation errors, slow access to patient information, and trouble managing appointments and stock. This project designs a MySQL database that stores hospital information in related tables, so the data stays organized and consistent and can be queried with SQL.

The database covers:

- **Patients**: personal and contact details
- **Doctors and departments**: specializations, contact details, and department assignment
- **Doctor schedules**: working days, shift times, and availability
- **Appointments**: patient–doctor bookings with date, time, reason, and status
- **Medical records**: diagnoses, symptoms, treatments, and allergies
- **Prescriptions**: prescriptions issued by doctors and the medicines on each one, with dosage, frequency, and duration
- **Pharmacy and equipment inventory**: medicine prices, stock levels, reorder levels, and expiry dates, plus medical equipment
- **Rooms and admissions**: room types, daily charges, availability, and admission and discharge dates
- **Billing**: consultation, treatment, and other charges, with payment method and status

## Objectives

- Keep hospital information in one central relational database.
- Reduce manual record-keeping, duplicated data, and calculation errors.
- Link related records through primary and foreign keys.
- Manage appointments, doctor availability, admissions, and room allocation.
- Keep medical histories, prescriptions, and billing records accurate.
- Track medicine and equipment stock.
- Retrieve and analyze hospital data with SQL joins, subqueries, filters, and aggregate functions.

## Technologies Used

- **Database:** MySQL
- **Language:** SQL (DDL, DML, and queries; one stored procedure, one trigger, and one view)
- **Interface:** MySQL command-line client

## Database Schema

The database is named `HospitalManagement` and has 13 tables. The ER diagram is in [`ER_Diagram.png`](ER_Diagram.png).

| # | Table | Columns | Foreign keys |
|---|-------|---------|--------------|
| 1 | `Department` | DepartmentID, DepartmentName, Description | none |
| 2 | `Doctor` | DoctorID, DoctorName, Specialization, Phone, Email, DepartmentID | Department |
| 3 | `Patient` | PatientID, PatientName, DateOfBirth, Gender, Phone, Email, Address | none |
| 4 | `DoctorSchedule` | ScheduleID, DoctorID, WorkingDay, StartTime, EndTime, AvailabilityStatus | Doctor |
| 5 | `Appointment` | AppointmentID, PatientID, DoctorID, AppointmentDate, AppointmentTime, Reason, Status | Patient, Doctor |
| 6 | `MedicalRecord` | RecordID, PatientID, DoctorID, Diagnosis, Symptoms, Treatment, Allergies, RecordDate | Patient, Doctor |
| 7 | `Prescription` | PrescriptionID, PatientID, DoctorID, RecordID, PrescriptionDate, Instructions | Patient, Doctor, MedicalRecord |
| 8 | `Medicine` | MedicineID, MedicineName, Manufacturer, UnitPrice, QuantityInStock, ReorderLevel, ExpiryDate | none |
| 9 | `PrescriptionItem` | PrescriptionItemID, PrescriptionID, MedicineID, Dosage, Frequency, Duration | Prescription, Medicine |
| 10 | `MedicalEquipment` | EquipmentID, EquipmentName, Category, Quantity, UnitPrice, ConditionStatus | none |
| 11 | `Room` | RoomID, RoomNumber, RoomType, ChargesPerDay, AvailabilityStatus | none |
| 12 | `Admission` | AdmissionID, PatientID, RoomID, AdmissionDate, DischargeDate, AdmissionStatus | Patient, Room |
| 13 | `Bill` | BillID, PatientID, AdmissionID, BillDate, ConsultationCharges, TreatmentCharges, OtherCharges, TotalAmount, PaymentMethod, PaymentStatus | Patient, Admission |

Every table uses an `INT AUTO_INCREMENT` primary key. Many-to-many relationships are resolved through junction tables: `Appointment` and `Admission` (Patient–Doctor), `PrescriptionItem` (Prescription–Medicine), and `Admission` (Patient–Room).

## SQL Concepts Demonstrated

The 25 queries in Section 4 of the report (numbered 5.1.1 to 5.1.25) cover:

| Concept | Query |
|---------|-------|
| `UPDATE`, `DELETE` | 5.1.1, 5.1.2 |
| `INNER JOIN`, multi-table joins, aliases (`AS`), `ORDER BY` | 5.1.3, 5.1.13, 5.1.14 |
| `LEFT JOIN` | 5.1.16 |
| `GROUP BY`, `HAVING` | 5.1.4, 5.1.19, 5.1.20, 5.1.25 |
| Aggregates: `COUNT`, `SUM`, `AVG`, `ROUND`, `DISTINCT` | 5.1.4, 5.1.8, 5.1.19, 5.1.20, 5.1.25 |
| `UNION` | 5.1.5 |
| `EXISTS` subquery | 5.1.6 |
| `ANY` subquery | 5.1.7 |
| `IN` / `NOT IN` subqueries | 5.1.17, 5.1.18 |
| `BETWEEN`, `IS NOT NULL` | 5.1.8, 5.1.23, 5.1.24 |
| `LIKE` wildcards | 5.1.9, 5.1.22 |
| String functions: `CONCAT`, `UPPER`, `LOWER`, `SUBSTRING`, `LENGTH` | 5.1.9, 5.1.21 |
| `LIMIT` / `OFFSET` | 5.1.10 |
| `CASE` expression | 5.1.23 |
| Date function: `DATEDIFF` | 5.1.24 |
| Stored procedure (`GetPatientMedicalHistory`) | 5.1.11 |
| Trigger (`BeforeMedicineInsert`) | 5.1.12 |
| View (`DoctorDeptView`) | 5.1.15 |

## Repository Contents

| File | Description |
|------|-------------|
| `README.md` | This file. |
| `Hospital_Management_System.pdf` | The full project report: requirement analysis, ER diagram, database implementation with screenshots, and SQL queries with outputs. |
| `HospitalManagementSystem.sql` | MySQL script that creates the database and 13 tables, inserts the sample data, and runs all 25 report queries in order. |
| `ER_Diagram.png` | Entity Relationship diagram from Section 2 of the report. |
| `VALIDATION.md` | Notes from testing the SQL script, and differences found between the report text, its screenshots, and the ER diagram. |
| `.gitignore` | Excludes OS, editor, and temporary files. |

## Viewing the Report and Queries

- Open `Hospital_Management_System.pdf` in any PDF viewer, or click it on GitHub to preview it in the browser.
- The table definitions are in Section 3 of the report and in section 2 of `HospitalManagementSystem.sql`.
- The queries are in Section 4 of the report and in section 3 of the SQL file, with the same numbers (5.1.1 to 5.1.25).

## Running the SQL Script

### Prerequisites

- MySQL Server 8.0 or later, or a compatible MariaDB server
- The `mysql` command-line client, or a client that understands `DELIMITER` (for example MySQL Workbench)
- An account that can create databases, tables, views, procedures, and triggers

### Steps

The script creates a database named `HospitalManagement` and will stop with an error if one already exists. To run it from the repository folder:

```bash
mysql -u <username> -p --table < HospitalManagementSystem.sql
```

Or from inside the MySQL client:

```sql
SOURCE /path/to/HospitalManagementSystem.sql;
```

To run it again, first drop the existing database:

```sql
DROP DATABASE HospitalManagement;
```

### Notes

- Run the script once, top to bottom. Queries 5.1.1 (UPDATE), 5.1.2 (DELETE), and the trigger test in 5.1.12 change the data, so later results depend on that order.
- The stored procedure and trigger use `DELIMITER //`, which works in the `mysql` client and MySQL Workbench but not in every GUI tool.
- The script was tested end to end on MariaDB 12.3 and ran with no errors. It has not been run on Oracle MySQL Server. See [`VALIDATION.md`](VALIDATION.md) for details, including one result that differs from the report.

## Team

Team 2, under the guidance of Mrs V. Asha (Assistant Professor), Department of CSE (AI&ML), BVRIT HYDERABAD College of Engineering for Women.

| Roll No. | Name |
|----------|------|
| 25WH1A6666 | Kamatam Shraddha |
| 25WH1A6673 | Bandarupalli Bhuvana Kruthi |
| 25WH1A6680 | Sree Nidhi Chintapalli |
| 25WH1A6687 | Battu Navya |
| 25WH1A6694 | Mudireddy Vishvateja |
| 25WH1A66A1 | Rupika Gouri Dasamantharao |
| 25WH1A66A8 | Kaparapu Jahnavi |
| 25WH1A66B6 | Kandlagunta Maheswari |
| 25WH1A66C3 | Bail Kammara Pranitha |
| 26WH5A6609 | Guddeti Srivani |

## Disclaimer

This is an academic project made for a DBMS course. All names, contact details, and medical data in the sample records are fictitious. It is not intended for use in a real healthcare setting.
