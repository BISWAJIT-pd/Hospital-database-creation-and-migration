CREATE DATABASE  IF NOT EXISTS HOSPITAL;
USE HOSPITAL;
-- CREATING DEPERTMENT TABLE
CREATE TABLE DEPERTMENT
(
 `depertmentID` int auto_increment primary key,-- Ensure uniqueness
 `name` varchar(50) not null
);
 
-- CREATING DOCTOR TABLE
CREATE TABLE DOCTOR
(
 `doctorid` int auto_increment primary key,
 `name` varchar(50),
 specialization varchar(100),
 `role` varchar(50),
 `depertmentID` int,
 foreign key (`depertmentID`) references DEPERTMENT(`depertmentID`)-- we can't assign a department to doctor which is not exists
);

-- CREATING DOCTOR PATIENT
CREATE TABLE PATIENTS
(
 Patientid int auto_increment primary key,
 `name` varchar(50),
 Dateofbirth date,
 Gender varchar(1),
 Phone varchar(15),
 check (Gender in('m','f','o'))
);

-- CREATING DOCTOR APPOINTMENT
CREATE TABLE APPOINTMENTS
(
 Appointmentid int auto_increment primary key,
 patientid int,
 Doctorid int,
 Appointment_time datetime,
 `status` varchar(50),
 foreign key (patientid) references PATIENTS(Patientid),-- only those patients came those are mentioned in PATIENT table
 foreign key (Doctorid) references DOCTOR(`doctorid`),
 check (`status` in('Schedule','Completed','Cancelled'))
);

-- CREATING DOCTOR PRESCRIPTION
CREATE TABLE PRESCRIPTIONS
(
 Prescriptionid int auto_increment primary key,
 Appointmentid int,
 Medication varchar(100),
 Dosage varchar(100),
 foreign key (Appointmentid) references APPOINTMENTS(Appointmentid)
);

-- CREATING DOCTOR BILLS
CREATE TABLE BILLS
(
 Billid int auto_increment primary key,
 Appointmentid int,
 Amount decimal(10,2),
 Paid tinyint(1),
 BillDate datetime default current_timestamp,-- we want not to manually enter time
 foreign key (Appointmentid) references APPOINTMENTS(Appointmentid)
);

-- CREATING DOCTOR LABREPORTS
CREATE TABLE LABREPORT
(
 Reportid int auto_increment primary key,
 Appointmentid int,
 ReportData text,
 CreateDate datetime default current_timestamp,
 foreign key (Appointmentid) references APPOINTMENTS(Appointmentid)
);

-- INSERTION IN DATABASE
-- INSERT VALUES INTO DEPERTMENTS TABLE
select `Departments.DepartmentID` from hospital_data_10000_rows;
select group_concat(concat('`',column_name,'`')) from information_schema.columns
where table_schema='hospital'-- what if in my data departments... 80 columns exists so this will fetch all columns here
and table_name='hospital_data_10000_rows'
and column_name like 'Departments.%';

insert into DEPERTMENT(`depertmentID`,`name`)
select `Departments.DepartmentID`,`Departments.Name` from hospital_data_10000_rows
where `Departments.DepartmentID`<>'';

-- INSERT VALUES INTO DOCTORS TABLE
select group_concat(concat('`',column_name,'`')) from information_schema.columns
where table_schema='hospital'
and table_name='hospital_data_10000_rows'
and column_name like 'Doctors.%';

insert into DOCTOR(`doctorid`,`name`,specialization,`role`,`depertmentID`)
select `Doctors.DoctorID`,`Doctors.Name`,`Doctors.Specialization`,`Doctors.Role`,`Doctors.DepartmentID`
from hospital_data_10000_rows
where `Doctors.DoctorID`<>'';

-- INSERT VALUES INTO PATIENT TABLE
select group_concat(concat('`',column_name,'`')) from information_schema.columns
where table_schema='hospital'
and table_name='hospital_data_10000_rows'
and column_name like 'Patients.%';

insert into PATIENTS(Patientid,`name`, Dateofbirth, Gender, Phone)
select `Patients.PatientID`,`Patients.Name`,str_to_date(`Patients.DateOfBirth`,'%d-%m-%Y'),`Patients.Gender`,`Patients.Phone`
from hospital_data_10000_rows
where `Patients.PatientID`<>'';

SHOW CREATE TABLE APPOINTMENTS;-- in previous by mistake i write Scheduled as Schedule
ALTER TABLE  APPOINTMENTS
DROP CHECK  APPOINTMENTS_chk_1;
ALTER TABLE APPOINTMENTS
ADD CONSTRAINT APPOINTMENTS_chk_1
CHECK (`Status` IN ('Scheduled', 'Completed', 'Cancelled'));

-- INSERT VALUES INTO APPOINTMENT TABLE
select group_concat(concat('`',column_name,'`')) from information_schema.columns
where table_schema='hospital'
and table_name='hospital_data_10000_rows'
and column_name like 'Appointments.%';

insert into APPOINTMENTS(Appointmentid, patientid, Doctorid, Appointment_time, `status`)
select `Appointments.AppointmentID`,`Appointments.PatientID`,`Appointments.DoctorID`,str_to_date(`Appointments.AppointmentTime`,'%d-%m-%Y %H:%i'),`Appointments.Status`
from hospital_data_10000_rows;

-- INSERT VALUES INTO PRESCRIPTION TABLE
select group_concat(concat('`',column_name,'`')) from information_schema.columns
where table_schema='hospital'
and table_name='hospital_data_10000_rows'
and column_name like 'Prescriptions.%';

insert into PRESCRIPTIONS(Prescriptionid, Appointmentid, Medication, Dosage)
select `Prescriptions.PrescriptionID`,`Prescriptions.AppointmentID`,`Prescriptions.Medication`,`Prescriptions.Dosage`
from hospital_data_10000_rows
where `Prescriptions.PrescriptionID`<>'';

-- INSERT VALUES INTO LABREPORT TABLE
select group_concat(concat('`',column_name,'`')) from information_schema.columns
where table_schema='hospital'
and table_name='hospital_data_10000_rows'
and column_name like 'LabReports.%';

insert into LABREPORT(Reportid, Appointmentid, ReportData, CreateDate)
select `LabReports.ReportID`,`LabReports.AppointmentID`,`LabReports.ReportData`,`LabReports.CreatedAt`
from hospital_data_10000_rows
where `LabReports.ReportID`<>'';

-- INSERT VALUES INTO BILLS TABLE
select group_concat(concat('`',column_name,'`')) from information_schema.columns
where table_schema='hospital'
and table_name='hospital_data_10000_rows'
and column_name like 'Bills.%';

insert into BILLS(Billid, Appointmentid, Amount, Paid, BillDate)
select `Bills.BillID`,`Bills.AppointmentID`,`Bills.Amount`,`Bills.Paid`,`Bills.BillDate`
from hospital_data_10000_rows
where `Bills.BillID`<>'';
-- triggered on insert
-- when 1>when back date insert 2> same date same time
DELIMITER $$
create trigger check_new_appointment
before insert on APPOINTMENTS for each row
begin
	IF NEW.Appointment_time<now() THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Error: Appointment can not be in past';
	end if;
    if exists
	(	select * from APPOINTMENTS
        where Doctorid=new.Doctorid and
        Appointment_time=new.Appointment_time
        and `status` in ('SCHEDULED')
	) then
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT='Error: Doctor already has an appointment in this time';
    end if;
end$$
DELIMITER ;

-- point 5
DELIMITER $$
create procedure view_DOCTOR_DATA(in input_username varchar(100), in input_password varchar(100))
begin
 declare doc_role varchar(100);
 declare doc_dept int;
 declare doc_id int;
 select doctor_id into doc_id
 from doctor_credentials where user_name=input_username 
 and password=input_password ;
 -- get role and depertment from doctor table
 select `role`,`depertmentID`
 into doc_role,doc_dept from
 DOCTOR where `doctorid`=doc_id;
 -- show appropieate patient data
 if doc_role='senior' then
	select p.Patientid,p.`name`,p.Gender,a.Appointment_time,
	pr.Medication,lr.ReportData
	from PATIENTS as p inner join
	APPOINTMENTS as a on
	a.patientid=p.Patientid
    join DOCTOR as d on d.`doctorid`=a.Doctorid
	left join PRESCRIPTIONS as pr on a.Appointmentid=pr.Appointmentid
	left join LABREPORT as lr on a.Appointmentid=lr.Appointmentid
    where d.`depertmentID`=doc_dept;
 else  
	select p.Patientid,p.`name`,p.Gender,a.Appointment_time,
	pr.Medication,lr.ReportData
	from PATIENTS as p inner join
	APPOINTMENTS as a on
	a.patientid=p.Patientid
	left join PRESCRIPTIONS as pr on a.Appointmentid=pr.Appointmentid
	left join LABREPORT as lr on a.Appointmentid=lr.Appointmentid
    where a.Doctorid=doc_id;
 end if;
end$$
DELIMITER ;

-- sample check
call view_DOCTOR_DATA('doctor1','W3jzIANG');

 -- point 6
 DELIMITER //
 create procedure monthly_revenue(in p_YEAR int,in p_MONTH int)
 begin
  select d1.`name` as depertment,
  sum(b.Amount) as total_revenue
  from BILLS as b
  inner join APPOINTMENTS as a on a.Appointmentid=b.Appointmentid
  inner join DOCTOR as d on d.`doctorid`=a.Doctorid
  inner join DEPERTMENT as d1 on d1.`depertmentID`=d.`doctorid`
  where month(b.BillDate)=p_MONTH and year(b.BillDate)=p_YEAR
  group by d1.`name`;
 end//
 DELIMITER ;
 
 -- check
call monthly_revenue(2025,5);