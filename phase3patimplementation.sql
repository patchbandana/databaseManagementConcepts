CREATE TABLE WELLNESS_CENTER_PROFILE (
    Center_ID VARCHAR(10) NOT NULL,
    Services_details TEXT,
    Statistics TEXT,
    Enrollment_stats TEXT,
    Career_ID VARCHAR(10),
    PRIMARY KEY (Center_ID),
    FOREIGN KEY (Center_ID)
        REFERENCES WELLNESS_CENTER (Facility_ID)
);

CREATE TABLE WELLNESS_PROGRAM (
Program_ID VARCHAR(10) NOT NULL,
Mental_Health_program VARCHAR(100),
Physical_Therapy_program VARCHAR(100),
Nutrition_counseling_program VARCHAR(100),
Preventive_care_program VARCHAR(100),
Program_name VARCHAR(100) NOT NULL,
Program_desc TEXT,
Progress_updates TEXT,
Program_participation TEXT,
Patient_feedback TEXT,
PRIMARY KEY (Program_ID)
);

INSERT INTO WELLNESS_CENTER_PROFILE VALUES
('WC001', 'Yoga, Meditation, Pilates, Nutritional Counseling', 'Monthly visits: 430, Avg session duration: 55 min', 'Active members: 215, New enrollments this month: 24', 'CAR001'),
('WC002', 'Physical Therapy, Stress Management, Weight Management', 'Monthly visits: 380, Avg session duration: 45 min', 'Active members: 195, New enrollments this month: 18', 'CAR002'),
('WC003', 'Massage Therapy, Group Fitness, Aquatic Therapy', 'Monthly visits: 520, Avg session duration: 60 min', 'Active members: 250, New enrollments this month: 30', 'CAR003'),
('WC004', 'Mental Health Workshops, Diet Planning, Ergonomic Training', 'Monthly visits: 280, Avg session duration: 50 min', 'Active members: 140, New enrollments this month: 15', 'CAR004'),
('WC005', 'Senior Wellness, Cardiac Rehab, Diabetes Management', 'Monthly visits: 320, Avg session duration: 65 min', 'Active members: 180, New enrollments this month: 12', 'CAR005');

INSERT INTO WELLNESS_PROGRAM VALUES
('WP001', 'Stress Reduction Therapy', NULL, NULL, NULL, 'Mind & Body Balance', 'An 8-week program focusing on stress reduction and mental wellness techniques', 'Week 3: 87% attendance, positive progress noted for 72% of participants', '45 active participants, 8 sessions completed', 'Average satisfaction rating: 4.7/5'),
('WP002', NULL, 'Post-Surgery Recovery', NULL, NULL, 'Back to Health', 'A specialized rehabilitation program for post-surgery patients', 'Week 5: 92% attendance, 65% showing significant mobility improvement', '32 active participants, 15 sessions completed', 'Average satisfaction rating: 4.5/5'),
('WP003', NULL, NULL, 'Healthy Eating Habits', NULL, 'Nutrition for Life', 'A nutrition program focusing on sustainable healthy eating habits', 'Week 4: 78% attendance, 60% reporting improved dietary choices', '38 active participants, 4 sessions completed', 'Average satisfaction rating: 4.3/5'),
('WP004', NULL, NULL, NULL, 'Disease Prevention', 'Preventive Health Screenings', 'Regular health screenings and preventive care education', 'Month 2: 85% completion of scheduled screenings', '120 active participants, quarterly screenings', 'Average satisfaction rating: 4.8/5'),
('WP005', 'Cognitive Behavioral Therapy', NULL, NULL, NULL, 'Mental Wellness Path', 'A 12-week program using CBT techniques for anxiety and depression', 'Week 7: 83% attendance, 68% reporting reduced symptoms', '28 active participants, 7 sessions completed', 'Average satisfaction rating: 4.6/5'),
('WP006', NULL, 'Joint Mobility Focus', NULL, NULL, 'Active Joints', 'A program designed to improve joint mobility and reduce pain', 'Week 6: 88% attendance, 75% reporting reduced pain', '35 active participants, 12 sessions completed', 'Average satisfaction rating: 4.4/5'),
('WP007', NULL, NULL, 'Weight Management', NULL, 'Healthy Weight', 'A comprehensive weight management program', 'Month 3: 72% meeting weight goals, 90% reporting improved habits', '42 active participants, 12 weeks program', 'Average satisfaction rating: 4.2/5'),
('WP008', NULL, NULL, NULL, 'Senior Wellness', 'Golden Years Health', 'A preventive care program specifically designed for seniors', 'Month 4: 92% completion of wellness checks', '75 active participants, monthly check-ins', 'Average satisfaction rating: 4.9/5');

CREATE VIEW Patient_Visit_History AS
    SELECT 
        p.Patient_ID,
        p.First_Name,
        p.Last_Name,
        a.Appointment_ID,
        a.Meeting_time,
        a.Feedback,
        pr.Provider_ID,
        pr.First_Name AS Provider_First_Name,
        pr.Last_Name AS Provider_Last_Name,
        f.Facility_ID,
        f.Name AS Facility_Name,
        f.Service_rating
    FROM
        PATIENT p
            JOIN
        APPOINTMENT a ON p.Patient_ID = a.Patient_ID
            JOIN
        PROVIDER pr ON a.Provider_ID = pr.Provider_ID
            JOIN
        FACILITY f ON pr.Facility_ID = f.Facility_ID
    ORDER BY p.Patient_ID , a.Meeting_time DESC;
    
    CREATE VIEW Facility_Services_And_Ratings AS
    SELECT 
        f.Facility_ID,
        f.Name,
        f.Service_rating,
        COUNT(f.Special_services) AS Number_of_Special_Services,
        f.Special_services,
        CASE
            WHEN h.Facility_ID IS NOT NULL THEN 'Hospital'
            WHEN c.Facility_ID IS NOT NULL THEN 'Clinic'
            WHEN er.Facility_ID IS NOT NULL THEN 'Emergency Room'
            WHEN wc.Facility_ID IS NOT NULL THEN 'Wellness Center'
            ELSE 'Unknown'
        END AS Facility_Type
    FROM
        FACILITY f
            LEFT JOIN
        HOSPITAL h ON f.Facility_ID = h.Facility_ID
            LEFT JOIN
        CLINIC c ON f.Facility_ID = c.Facility_ID
            LEFT JOIN
        ER er ON f.Facility_ID = er.Facility_ID
            LEFT JOIN
        WELLNESS_CENTER wc ON f.Facility_ID = wc.Facility_ID
    GROUP BY f.Facility_ID , f.Name , f.Service_rating
    ORDER BY f.Service_rating DESC;
    
    CREATE VIEW Comprehensive_Provider_Profiles AS
    SELECT 
        p.Provider_ID,
        p.First_Name,
        p.Last_Name,
        p.Qualifications,
        p.Specialty_type,
        COUNT(a.Appointment_ID) AS Appointment_Count,
        AVG(a.Rating) AS Average_Patient_Rating,
        MAX(a.Meeting_time) AS Last_Appointment_Date,
        f.Name AS Facility_Name
    FROM
        PROVIDER p
            LEFT JOIN
        APPOINTMENT a ON p.Provider_ID = a.Provider_ID
            LEFT JOIN
        FACILITY f ON p.Facility_ID = f.Facility_ID
    GROUP BY p.Provider_ID , p.First_Name , p.Last_Name , p.Qualifications , p.Specialty_type , f.Name
    ORDER BY Appointment_Count DESC;
    
    CREATE VIEW Patient_Wellness_Program_Enrollment AS
    SELECT 
        p.Patient_ID,
        p.First_Name,
        p.Last_Name,
        COUNT(wp.Program_ID) AS Number_of_Programs,
        GROUP_CONCAT(wp.Program_name
            SEPARATOR ', ') AS Enrolled_Programs
    FROM
        PATIENT p
            LEFT JOIN
        PARTICIPATES_IN pi ON p.Patient_ID = pi.Patient_ID
            LEFT JOIN
        WELLNESS_PROGRAM wp ON pi.Program_ID = wp.Program_ID
    GROUP BY p.Patient_ID , p.First_Name , p.Last_Name
    ORDER BY Number_of_Programs DESC;
    
    SELECT 
    wc.Facility_ID,
    f.Name,
    wcp.Services_details,
    wcp.Enrollment_stats
FROM
    WELLNESS_CENTER wc
        JOIN
    FACILITY f ON wc.Facility_ID = f.Facility_ID
        JOIN
    WELLNESS_CENTER_PROFILE wcp ON wc.Facility_ID = wcp.Center_ID
ORDER BY f.Name;

SELECT 
    wp.Program_ID,
    wp.Program_name,
    wp.Mental_Health_program,
    SUBSTRING_INDEX(wp.Program_participation, ' ', 2) AS Active_Participants,
    wp.Patient_feedback
FROM
    WELLNESS_PROGRAM wp
WHERE
    wp.Mental_Health_program IS NOT NULL
ORDER BY SUBSTRING_INDEX(wp.Patient_feedback, ':', - 1) DESC;