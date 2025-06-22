-- SQL Queries for Uber Analysis

-- 1. Total Requests by Location
SELECT 
    Pickup_point,
    COUNT(*) as Total_Requests
FROM uber_requests
GROUP BY Pickup_point
ORDER BY Total_Requests DESC;

-- 2. Request Status Distribution
SELECT 
    Status,
    COUNT(*) as Count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as Percentage
FROM uber_requests
GROUP BY Status;

-- 3. Hourly Request Distribution
SELECT 
    DATEPART(HOUR, Request_timestamp) as Hour,
    COUNT(*) as Requests
FROM uber_requests
GROUP BY DATEPART(HOUR, Request_timestamp)
ORDER BY Hour;

-- 4. Cancellation Analysis
SELECT 
    Pickup_point,
    COUNT(*) as Total_Cancellations
FROM uber_requests
WHERE Status IN ('Cancelled', 'No Cars Available')
GROUP BY Pickup_point
ORDER BY Total_Cancellations DESC;

-- 5. Wait Time Analysis
SELECT 
    AVG(DATEDIFF(MINUTE, Request_timestamp, Pickup_timestamp)) as Avg_Wait_Time,
    MIN(DATEDIFF(MINUTE, Request_timestamp, Pickup_timestamp)) as Min_Wait_Time,
    MAX(DATEDIFF(MINUTE, Request_timestamp, Pickup_timestamp)) as Max_Wait_Time
FROM uber_requests
WHERE Status = 'Completed';

-- 6. Day of Week Analysis
SELECT 
    DATENAME(WEEKDAY, Request_timestamp) as Day_of_Week,
    COUNT(*) as Requests
FROM uber_requests
GROUP BY DATENAME(WEEKDAY, Request_timestamp)
ORDER BY CASE 
    WHEN DATENAME(WEEKDAY, Request_timestamp) = 'Monday' THEN 1
    WHEN DATENAME(WEEKDAY, Request_timestamp) = 'Tuesday' THEN 2
    WHEN DATENAME(WEEKDAY, Request_timestamp) = 'Wednesday' THEN 3
    WHEN DATENAME(WEEKDAY, Request_timestamp) = 'Thursday' THEN 4
    WHEN DATENAME(WEEKDAY, Request_timestamp) = 'Friday' THEN 5
    WHEN DATENAME(WEEKDAY, Request_timestamp) = 'Saturday' THEN 6
    WHEN DATENAME(WEEKDAY, Request_timestamp) = 'Sunday' THEN 7
    END;
