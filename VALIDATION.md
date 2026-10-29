# SQL Validation Notes

## How the script was built

The table definitions, sample data, and queries in `Hospital_Management_System.pdf` appear as MySQL terminal screenshots, not as copyable text. `HospitalManagementSystem.sql` was transcribed from those screenshots (Figures 4.1–4.14 and the query outputs in Section 4). Where the printed query text and the screenshot disagree, the script uses the screenshot, because that is the version that was actually run.

## Test run

- **Server:** MariaDB 12.3.3, a temporary local instance on an empty data directory
- **Command:** `mariadb --table < HospitalManagementSystem.sql`
- **Result:** every statement ran with no errors, including all `CREATE TABLE` statements, inserts, the 25 queries, the stored procedure, the trigger, and the view.
- **Not tested:** Oracle MySQL Server. The script uses only standard MySQL syntax, but it has not been run on MySQL itself.

The query outputs match the report's screenshots, except for the item below.

## Result that differs from the report

**Bill 1's total amount.** The Bill insert in Figure 4.14 gives Bill 1 a `TotalAmount` of `6000.00`. The later query outputs in the report were produced when that value was `6600.00`, and the change is not shown anywhere in the report. As a result:

| Query | Report shows | Script gives |
|-------|--------------|--------------|
| 5.1.8 TotalRevenue | 13600.00 | 13000.00 |
| 5.1.19 Cash total | 6600.00 | 6000.00 |
| 5.1.25 Rohan Mehta's total | 6600.00 | 6000.00 |

The script keeps the inserted value of 6000.00 and does not add an UPDATE that the report doesn't contain. Note that 500 + 4500 + 1000 = 6000, so 6000.00 is also the arithmetically correct total.

## Differences between the report text and its screenshots

| Location | Printed text | Executed (screenshot) | Used in script |
|----------|--------------|-----------------------|----------------|
| 3.1 Database name | `HospitalManagementDB` | `HospitalManagement` | Screenshot |
| 5.1.1 UPDATE | `‘ 9111222333 ‘` (curly quotes with spaces, invalid SQL) | `'9111222333'` | Screenshot |
| 5.1.11 Procedure | `DELIMITER;` (no space, the client will not recognize it) | `DELIMITER ;` | Screenshot |
| 5.1.12 Trigger test | `- 15.00` | `-15.00` | Screenshot (both parse the same way) |
| 5.1.14 Multi-table JOIN | `p.Patient Name, an.Appointment Date, ... doc.Doctor Name` (spaces in column names, undefined alias `an`) | `p.PatientName, a.AppointmentDate, ... doc.DoctorName` | Screenshot |
| 5.1.22 description | "contains 'abad' or 'lore'" | query uses `'%bad%'` | Query as written |

**Recommendation:** fix the printed text for 5.1.1, 5.1.11, and 5.1.14 in the report so it matches what was run.

## Data reconstructed from output

**Department rows 1–5.** Figure 4.2 shows an INSERT of only 3 rows (Cardiology, Neurology, Orthopedics), but the `SELECT * FROM Department` output beneath it shows 8 rows. Rows 1–5 (Cardiology, Neurology, Orthopedics, Pediatrics, General Medicine) were inserted earlier and that insert is not shown. The script adds a separate INSERT for those 5 rows, copied from the SELECT output, so the IDs and the LEFT JOIN result (5.1.16) match the report. As a result, Cardiology, Neurology, and Orthopedics each appear twice in the table.

## Differences between the ER diagram and the implemented tables

The ER diagram (Section 2) shows a more detailed design than the tables that were actually created (Section 3). The SQL script follows the implemented tables.

| Entity | ER diagram | Implemented table |
|--------|------------|-------------------|
| Patient, Doctor | `firstName`, `lastName` | single `PatientName` / `DoctorName` |
| Appointment | relationship with Department (`Appointment.departmentID` in table 2.3.1) | no `DepartmentID` column |
| Patient | `Patient.doctorID` (table 2.3.1) | no `DoctorID` column |
| DoctorSchedule | `roomID`, `recurringWeeks` | `WorkingDay`, `AvailabilityStatus`, no room link |
| MedicalRecord | `visitDate`, `notes`, `nextVisitDate` | `Symptoms`, `RecordDate` |
| MedicalEquipment | `location`, linked to Room (`located_in`) | no room link; has `UnitPrice` |
| Bill | `paidAmount`, `dueAmount`; linked to Prescription (`includes`) | consultation, treatment, and other charges; no prescription link |
| Medicine | named `Medication` with `medicationID` | `Medicine` / `MedicineID` |
| Candidate keys | Email, DepartmentName, RoomNumber, MedicineName are listed as unique | no `UNIQUE` constraints, and Department has duplicate names |

Section 2 of the report also calls the database an "Inventory Management System" in two places, which looks like it was copied from another document.

## Report content

`Hospital_Management_System.pdf` (32 pages) goes from the index (page 2) straight into the middle of the requirement analysis (page 3). The Introduction (1.1–1.4) and the first part of the Requirement Analysis do not appear in this version. They do appear in an earlier version of the report (`Hospital_Management_System_final.pdf`, 41 pages), which the README overview and objectives are based on. Several printed page numbers are also out of sequence (32 and 42 appear on early pages).
