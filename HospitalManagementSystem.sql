-- =====================================================================
-- Hospital Management System - DBMS Case Study (Team 2)
-- MySQL script reconstructed from the project report
-- (Hospital_Management_System.pdf, Sections 3 and 4).
--
-- Source notes:
--   * Table definitions and sample data are transcribed from the MySQL
--     terminal screenshots in Section 3 (Figures 4.1 - 4.14).
--   * Queries 5.1.1 - 5.1.25 follow the report's order. Where the printed
--     query text differs from the screenshot that was actually executed,
--     the executed (screenshot) version is used and the difference is
--     noted in a comment.
--   * Run the whole file top to bottom on an empty server. The UPDATE,
--     DELETE and trigger-test INSERT change the data, so later query
--     results depend on running everything in this order.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. Database creation (Figure 4.1)
-- The report text names the database "HospitalManagementDB", but the
-- screenshot that was executed uses "HospitalManagement".
-- ---------------------------------------------------------------------
CREATE DATABASE HospitalManagement;
USE HospitalManagement;


-- ---------------------------------------------------------------------
-- 2. Table creation and sample data (Section 3.2)
-- Tables are created in dependency order so every foreign key refers to
-- a table that already exists.
-- ---------------------------------------------------------------------

-- 3.2.1 Department (Figure 4.2)
CREATE TABLE Department (
    DepartmentID INT AUTO_INCREMENT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL,
    Description TEXT
);

-- The Department output in Figure 4.2 shows 8 rows, but only the INSERT
-- for rows 6-8 is shown. Rows 1-5 are reconstructed from that SELECT
-- output so the table matches the report (the LEFT JOIN in 5.1.16 also
-- shows all 8 rows, including the duplicated department names).
INSERT INTO Department (DepartmentName, Description)
VALUES
('Cardiology', 'Heart related treatments'),
('Neurology', 'Brain and nervous system'),
('Orthopedics', 'Bone and joint treatments'),
('Pediatrics', 'Child healthcare'),
('General Medicine', 'General health issues');

-- INSERT as shown in Figure 4.2
INSERT INTO Department (DepartmentName, Description)
VALUES
('Cardiology', 'Heart related treatments'),
('Neurology', 'Brain and nervous system'),
('Orthopedics', 'Bones and joints');

SELECT * FROM Department;

-- 3.2.2 Doctor (Figure 4.3)
CREATE TABLE Doctor (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    DoctorName VARCHAR(100) NOT NULL,
    Specialization VARCHAR(100),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID)
        REFERENCES Department(DepartmentID)
);

INSERT INTO Doctor (DoctorName, Specialization, Phone, Email, DepartmentID)
VALUES
('Dr. Rajesh Kumar','Cardiologist','9876543210','rajesh@gmail.com',1),
('Dr. Priya Sharma','Neurologist','9876543211','priya@gmail.com',2),
('Dr. Amit Singh','Orthopedic','9876543212','amit@gmail.com',3);

SELECT * FROM Doctor;

-- 3.2.3 Patient (Figure 4.4)
CREATE TABLE Patient (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    PatientName VARCHAR(100) NOT NULL,
    DateOfBirth DATE,
    Gender VARCHAR(20),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Address VARCHAR(255)
);

INSERT INTO Patient (PatientName, DateOfBirth, Gender, Phone, Email, Address)
VALUES
('Rohan Mehta','2001-05-15','Male','9123456789','rohan@gmail.com','Hyderabad'),
('Sneha Rao','1998-09-20','Female','9234567890','sneha@gmail.com','Bangalore'),
('Karan Patel','2003-02-11','Male','9345678901','karan@gmail.com','Mumbai');

SELECT * FROM Patient;

-- 3.2.4 DoctorSchedule (Figure 4.5)
CREATE TABLE DoctorSchedule (
    ScheduleID INT AUTO_INCREMENT PRIMARY KEY,
    DoctorID INT,
    WorkingDay VARCHAR(20),
    StartTime TIME,
    EndTime TIME,
    AvailabilityStatus VARCHAR(20),
    FOREIGN KEY (DoctorID)
        REFERENCES Doctor(DoctorID)
);

INSERT INTO DoctorSchedule (DoctorID, WorkingDay, StartTime, EndTime, AvailabilityStatus)
VALUES
(1,'Monday','09:00:00','17:00:00','Available'),
(2,'Tuesday','10:00:00','16:00:00','Available'),
(3,'Wednesday','08:00:00','14:00:00','Busy');

SELECT * FROM DoctorSchedule;

-- 3.2.5 Appointment (Figure 4.6)
CREATE TABLE Appointment (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATE,
    AppointmentTime TIME,
    Reason TEXT,
    Status VARCHAR(30),
    FOREIGN KEY (PatientID)
        REFERENCES Patient(PatientID),
    FOREIGN KEY (DoctorID)
        REFERENCES Doctor(DoctorID)
);

INSERT INTO Appointment (PatientID, DoctorID, AppointmentDate, AppointmentTime, Reason, Status)
VALUES
(1,1,'2026-10-20','10:00:00','Chest Pain','Confirmed'),
(2,2,'2026-10-21','11:30:00','Migraine','Pending'),
(3,3,'2026-10-22','09:15:00','Fracture Checkup','Completed');

SELECT * FROM Appointment;

-- 3.2.6 MedicalRecord (Figure 4.7)
CREATE TABLE MedicalRecord (
    RecordID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    Diagnosis TEXT,
    Symptoms TEXT,
    Treatment TEXT,
    Allergies TEXT,
    RecordDate DATE,
    FOREIGN KEY (PatientID)
        REFERENCES Patient(PatientID),
    FOREIGN KEY (DoctorID)
        REFERENCES Doctor(DoctorID)
);

INSERT INTO MedicalRecord (PatientID, DoctorID, Diagnosis, Symptoms, Treatment, Allergies, RecordDate)
VALUES
(1,1,'Heart Disease','Chest Pain','Medication','None','2026-10-20'),
(2,2,'Migraine','Headache','Painkillers','Penicillin','2026-10-21'),
(3,3,'Leg Fracture','Pain','Cast','None','2026-10-22');

SELECT * FROM MedicalRecord;

-- 3.2.7 Prescription (Figure 4.8)
CREATE TABLE Prescription (
    PrescriptionID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    RecordID INT,
    PrescriptionDate DATE,
    Instructions TEXT,
    FOREIGN KEY (PatientID)
        REFERENCES Patient(PatientID),
    FOREIGN KEY (DoctorID)
        REFERENCES Doctor(DoctorID),
    FOREIGN KEY (RecordID)
        REFERENCES MedicalRecord(RecordID)
);

INSERT INTO Prescription (PatientID, DoctorID, RecordID, PrescriptionDate, Instructions)
VALUES
(1,1,1,'2026-10-20','Take medicines after food'),
(2,2,2,'2026-10-21','Sleep well and avoid stress'),
(3,3,3,'2026-10-22','Wear cast for 6 weeks');

SELECT * FROM Prescription;

-- 3.2.8 Medicine (Figure 4.9)
CREATE TABLE Medicine (
    MedicineID INT AUTO_INCREMENT PRIMARY KEY,
    MedicineName VARCHAR(100),
    Manufacturer VARCHAR(100),
    UnitPrice DECIMAL(10,2),
    QuantityInStock INT,
    ReorderLevel INT,
    ExpiryDate DATE
);

INSERT INTO Medicine (MedicineName, Manufacturer, UnitPrice, QuantityInStock, ReorderLevel, ExpiryDate)
VALUES
('Paracetamol','Cipla',10.50,500,100,'2028-01-01'),
('Aspirin','Sun Pharma',15.75,300,50,'2027-12-31'),
('Amoxicillin','Abbott',25.00,200,30,'2027-10-10');

SELECT * FROM Medicine;

-- 3.2.9 PrescriptionItem (Figure 4.10)
CREATE TABLE PrescriptionItem (
    PrescriptionItemID INT AUTO_INCREMENT PRIMARY KEY,
    PrescriptionID INT,
    MedicineID INT,
    Dosage VARCHAR(50),
    Frequency VARCHAR(50),
    Duration VARCHAR(50),
    FOREIGN KEY (PrescriptionID)
        REFERENCES Prescription(PrescriptionID),
    FOREIGN KEY (MedicineID)
        REFERENCES Medicine(MedicineID)
);

INSERT INTO PrescriptionItem (PrescriptionID, MedicineID, Dosage, Frequency, Duration)
VALUES
(1,1,'500mg','Twice a day','5 Days'),
(2,2,'250mg','Once a day','7 Days'),
(3,3,'500mg','Three times a day','10 Days');

SELECT * FROM PrescriptionItem;

-- 3.2.10 MedicalEquipment (Figure 4.11)
-- Note: the ER diagram links MedicalEquipment to Room (located_in), but the
-- implemented table has no RoomID column.
CREATE TABLE MedicalEquipment (
    EquipmentID INT AUTO_INCREMENT PRIMARY KEY,
    EquipmentName VARCHAR(100),
    Category VARCHAR(100),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    ConditionStatus VARCHAR(30)
);

INSERT INTO MedicalEquipment (EquipmentName, Category, Quantity, UnitPrice, ConditionStatus)
VALUES
('ECG Machine','Diagnostic',5,75000.00,'Good'),
('Wheelchair','Support',20,8000.00,'Excellent'),
('X-Ray Machine','Imaging',2,500000.00,'Good');

SELECT * FROM MedicalEquipment;

-- 3.2.11 Room (Figure 4.12)
CREATE TABLE Room (
    RoomID INT AUTO_INCREMENT PRIMARY KEY,
    RoomNumber VARCHAR(20),
    RoomType VARCHAR(50),
    ChargesPerDay DECIMAL(10,2),
    AvailabilityStatus VARCHAR(30)
);

INSERT INTO Room (RoomNumber, RoomType, ChargesPerDay, AvailabilityStatus)
VALUES
('101','General',1000.00,'Available'),
('201','ICU',5000.00,'Occupied'),
('301','Private',3000.00,'Available');

SELECT * FROM Room;

-- 3.2.12 Admission (Figure 4.13)
CREATE TABLE Admission (
    AdmissionID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    RoomID INT,
    AdmissionDate DATE,
    DischargeDate DATE,
    AdmissionStatus VARCHAR(30),
    FOREIGN KEY (PatientID)
        REFERENCES Patient(PatientID),
    FOREIGN KEY (RoomID)
        REFERENCES Room(RoomID)
);

INSERT INTO Admission (PatientID, RoomID, AdmissionDate, DischargeDate, AdmissionStatus)
VALUES
(1,2,'2026-10-20','2026-10-25','Discharged'),
(2,1,'2026-10-21',NULL,'Admitted'),
(3,3,'2026-10-22','2026-10-30','Discharged');

SELECT * FROM Admission;

-- 3.2.13 Bill (Figure 4.14)
CREATE TABLE Bill (
    BillID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    AdmissionID INT,
    BillDate DATE,
    ConsultationCharges DECIMAL(10,2),
    TreatmentCharges DECIMAL(10,2),
    OtherCharges DECIMAL(10,2),
    TotalAmount DECIMAL(12,2),
    PaymentMethod VARCHAR(30),
    PaymentStatus VARCHAR(30),
    FOREIGN KEY (PatientID)
        REFERENCES Patient(PatientID),
    FOREIGN KEY (AdmissionID)
        REFERENCES Admission(AdmissionID)
);

INSERT INTO Bill (PatientID, AdmissionID, BillDate, ConsultationCharges, TreatmentCharges, OtherCharges, TotalAmount, PaymentMethod, PaymentStatus)
VALUES
(1,1,'2026-10-25',500.00,4500.00,1000.00,6000.00,'Cash','Paid'),
(2,2,'2026-10-23',600.00,2500.00,500.00,3600.00,'Card','Pending'),
(3,3,'2026-10-30',700.00,5500.00,800.00,7000.00,'UPI','Paid');

SELECT * FROM Bill;


-- ---------------------------------------------------------------------
-- 3. SQL queries (Section 4, queries 5.1.1 - 5.1.25)
-- ---------------------------------------------------------------------

-- 5.1.1 UPDATE: change an existing patient's phone number.
-- The report text prints ‘ 9111222333 ‘ (curly quotes with spaces); the
-- executed screenshot uses '9111222333', which is used here.
UPDATE Patient SET Phone = '9111222333' WHERE PatientID = 1;

SELECT * FROM Patient;

-- 5.1.2 DELETE: remove a specific appointment.
DELETE FROM Appointment WHERE AppointmentID = 3;

SELECT * FROM Appointment;

-- 5.1.3 JOIN, AS and ORDER BY: patient names and room charges,
-- highest charges first.
SELECT p.PatientName AS FullName, r.RoomNumber, r.ChargesPerDay
FROM Admission ad
JOIN Patient p ON ad.PatientID = p.PatientID
JOIN Room r ON ad.RoomID = r.RoomID
ORDER BY r.ChargesPerDay DESC;

-- 5.1.4 GROUP BY and HAVING: departments with more than one doctor.
-- With the sample data every department has at most one doctor, so this
-- returns an empty set (as in the report).
SELECT dept.DepartmentName, COUNT(d.DoctorID) AS TotalDoctors
FROM Department dept
JOIN Doctor d ON dept.DepartmentID = d.DepartmentID
GROUP BY dept.DepartmentName
HAVING COUNT(d.DoctorID) > 1;

-- 5.1.5 UNION: one directory of patient and doctor names.
SELECT PatientName AS PersonName, 'Patient' AS Role FROM Patient
UNION
SELECT DoctorName AS PersonName, 'Doctor' AS Role FROM Doctor;

-- 5.1.6 EXISTS: patients with at least one bill marked 'Paid'.
SELECT p.PatientName
FROM Patient p
WHERE EXISTS (
    SELECT 1 FROM Bill b
    WHERE b.PatientID = p.PatientID AND b.PaymentStatus = 'Paid'
);

-- 5.1.7 ANY: medicines priced above any 'Cipla' medicine.
SELECT MedicineName, UnitPrice
FROM Medicine
WHERE UnitPrice > ANY (
    SELECT UnitPrice FROM Medicine WHERE Manufacturer = 'Cipla'
);

-- 5.1.8 Aggregates, DISTINCT, BETWEEN and IS NULL: revenue and average
-- treatment cost for discharged admissions billed in October 2026.
-- With the data above this returns TotalRevenue 13000.00. The report shows
-- 13600.00 because Bill 1's TotalAmount was 6600.00 when the report's
-- queries were run; the change from 6000.00 is not shown in the report.
-- The same difference appears in 5.1.19 (Cash) and 5.1.25 (Rohan Mehta).
SELECT
    COUNT(DISTINCT PaymentMethod) AS UniquePaymentMethods,
    SUM(TotalAmount) AS TotalRevenue,
    AVG(TreatmentCharges) AS AvgTreatmentCost
FROM Bill b
JOIN Admission ad ON b.AdmissionID = ad.AdmissionID
WHERE b.BillDate BETWEEN '2026-10-01' AND '2026-10-31'
  AND ad.DischargeDate IS NOT NULL;

-- 5.1.9 Wildcards and string functions (CONCAT, SUBSTRING, LENGTH,
-- UPPER, LOWER): doctor names starting with 'Dr.'.
SELECT
    UPPER(DoctorName) AS UppercaseName,
    LOWER(Specialization) AS LowerSpecialization,
    CONCAT('ID: ', DoctorID, ' - ', Specialization) AS DoctorSummary,
    SUBSTRING(Email, 1, 5) AS EmailPrefix,
    LENGTH(Phone) AS PhoneLength
FROM Doctor
WHERE DoctorName LIKE 'Dr.%';

-- 5.1.10 LIMIT and OFFSET: 2 patients starting from the second record.
SELECT PatientID, PatientName, Address
FROM Patient
LIMIT 2 OFFSET 1;

-- 5.1.11 Stored procedure: medical history for a given patient ID.
-- The report text prints "DELIMITER;" with no space; the executed
-- screenshot uses "DELIMITER ;", which is required by the mysql client.
DELIMITER //
CREATE PROCEDURE GetPatientMedicalHistory(IN p_PatientID INT)
BEGIN
    SELECT mr.RecordID, mr.Diagnosis, mr.Treatment
    FROM MedicalRecord mr
    WHERE mr.PatientID = p_PatientID;
END //
DELIMITER ;

CALL GetPatientMedicalHistory(1);

-- 5.1.12 Trigger: replace a negative unit price with 0 before insert.
DELIMITER //
CREATE TRIGGER BeforeMedicineInsert
BEFORE INSERT ON Medicine
FOR EACH ROW
BEGIN
    IF NEW.UnitPrice < 0 THEN
        SET NEW.UnitPrice = 0;
    END IF;
END //
DELIMITER ;

-- Test row for the trigger (stored with UnitPrice 0.00).
INSERT INTO Medicine (MedicineName, Manufacturer, UnitPrice, QuantityInStock, ReorderLevel, ExpiryDate)
VALUES ('TestMedicine', 'TestLab', -15.00, 100, 20, '2028-01-01');

SELECT * FROM Medicine WHERE MedicineName = 'TestMedicine';

-- 5.1.13 INNER JOIN: each doctor with department and specialization.
SELECT d.DoctorName, dept.DepartmentName, d.Specialization
FROM Doctor d
JOIN Department dept ON d.DepartmentID = dept.DepartmentID;

-- 5.1.14 Multi-table JOIN: appointments with patient and doctor names.
-- The report text prints "p.Patient Name, an.Appointment Date, ...
-- doc.Doctor Name", which is not valid SQL (spaces in column names and an
-- undefined alias "an"). The executed screenshot version is used here.
SELECT p.PatientName, a.AppointmentDate, a.Reason, doc.DoctorName, a.Status
FROM Appointment a
JOIN Patient p ON a.PatientID = p.PatientID
JOIN Doctor doc ON a.DoctorID = doc.DoctorID;

-- 5.1.15 View: doctor details with department names.
CREATE VIEW DoctorDeptView AS
SELECT d.DoctorName, d.Specialization, dept.DepartmentName
FROM Doctor d
JOIN Department dept ON d.DepartmentID = dept.DepartmentID;

SELECT * FROM DoctorDeptView;

-- 5.1.16 LEFT JOIN: all departments, including those without doctors.
SELECT dept.DepartmentName, d.DoctorName
FROM Department dept
LEFT JOIN Doctor d ON dept.DepartmentID = d.DepartmentID;

-- 5.1.17 Subquery with IN: patients admitted to an ICU or Private room.
SELECT PatientName, Phone FROM Patient
WHERE PatientID IN (
    SELECT ad.PatientID FROM Admission ad
    JOIN Room r ON ad.RoomID = r.RoomID
    WHERE r.RoomType IN ('ICU', 'Private')
);

-- 5.1.18 Subquery with NOT IN: patients with no medical records.
-- Every sample patient has a record, so this returns an empty set.
SELECT PatientName, Email FROM Patient
WHERE PatientID NOT IN (
    SELECT DISTINCT PatientID FROM MedicalRecord
);

-- 5.1.19 SUM and GROUP BY: total billed per payment method.
SELECT PaymentMethod, SUM(TotalAmount) AS TotalCollected
FROM Bill
GROUP BY PaymentMethod;

-- 5.1.20 AVG and ROUND: average daily room charge per room type.
SELECT RoomType, ROUND(AVG(ChargesPerDay), 2) AS AverageDailyCharge
FROM Room
GROUP BY RoomType;

-- 5.1.21 String manipulation: one profile string per doctor.
SELECT CONCAT(UPPER(DoctorName), ' - Specialization: ', Specialization) AS DoctorProfile
FROM Doctor;

-- 5.1.22 Wildcard LIKE: addresses containing 'bad' or 'lore'.
-- (The report's description says 'abad'; the query itself uses '%bad%'.)
SELECT PatientName, Address
FROM Patient
WHERE Address LIKE '%bad%' OR Address LIKE '%lore%';

-- 5.1.23 CASE: classify medicines by quantity in stock.
SELECT MedicineName, QuantityInStock,
       CASE
           WHEN QuantityInStock <= 100 THEN 'Low Stock'
           WHEN QuantityInStock BETWEEN 101 AND 300 THEN 'Medium Stock'
           ELSE 'Sufficient Stock'
       END AS StockStatus
FROM Medicine;

-- 5.1.24 DATEDIFF: number of days each discharged patient was admitted.
SELECT AdmissionID, PatientID, AdmissionDate, DischargeDate,
       DATEDIFF(DischargeDate, AdmissionDate) AS TotalDaysAdmitted
FROM Admission
WHERE DischargeDate IS NOT NULL;

-- 5.1.25 Aggregate with HAVING: patients billed more than 5000.00 in total.
SELECT p.PatientName, SUM(b.TotalAmount) AS TotalBilled
FROM Bill b
JOIN Patient p ON b.PatientID = p.PatientID
GROUP BY p.PatientName
HAVING SUM(b.TotalAmount) > 5000.00;
