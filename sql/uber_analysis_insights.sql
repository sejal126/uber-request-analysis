-- SQL Queries for Uber Analysis with Insights

-- 1. Total Requests by Location
SELECT 
    Pickup_point,
    COUNT(*) as Total_Requests,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as Percentage
FROM uber_requests
GROUP BY Pickup_point
ORDER BY Total_Requests DESC;

/* INSIGHTS:
1. Identify the most popular pickup locations
2. Analyze location-wise service demand
3. Optimize driver allocation based on location popularity
*/

-- 2. Request Status Distribution
SELECT 
    Status,
    COUNT(*) as Count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as Percentage
FROM uber_requests
GROUP BY Status;

/* INSIGHTS:
1. Track completion rate vs cancellation rate
2. Identify reasons for high cancellation rates
3. Monitor service availability issues
*/

-- 3. Hourly Request Distribution
SELECT 
    DATEPART(HOUR, Request_timestamp) as Hour,
    COUNT(*) as Requests,
    AVG(DATEDIFF(MINUTE, Request_timestamp, Pickup_timestamp)) as Avg_Wait_Time
FROM uber_requests
GROUP BY DATEPART(HOUR, Request_timestamp)
ORDER BY Hour;

/* INSIGHTS:
1. Identify peak hours for service demand
2. Analyze wait times during peak hours
3. Optimize driver scheduling based on hourly patterns
*/

-- 4. Cancellation Analysis
SELECT 
    Pickup_point,
    COUNT(*) as Total_Cancellations,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() as Percentage,
    AVG(DATEDIFF(MINUTE, Request_timestamp, Pickup_timestamp)) as Avg_Wait_Time
FROM uber_requests
WHERE Status IN ('Cancelled', 'No Cars Available')
GROUP BY Pickup_point
ORDER BY Total_Cancellations DESC;

/* INSIGHTS:
1. Identify high cancellation locations
2. Analyze correlation between wait times and cancellations
3. Implement location-specific strategies to reduce cancellations
*/

-- 5. Wait Time Analysis
SELECT 
    Pickup_point,
    COUNT(*) as Total_Completed,
    AVG(DATEDIFF(MINUTE, Request_timestamp, Pickup_timestamp)) as Avg_Wait_Time,
    MIN(DATEDIFF(MINUTE, Request_timestamp, Pickup_timestamp)) as Min_Wait_Time,
    MAX(DATEDIFF(MINUTE, Request_timestamp, Pickup_timestamp)) as Max_Wait_Time,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY DATEDIFF(MINUTE, Request_timestamp, Pickup_timestamp)) OVER(PARTITION BY Pickup_point) as Median_Wait_Time
FROM uber_requests
WHERE Status = 'Completed'
GROUP BY Pickup_point;

/* INSIGHTS:
1. Compare wait times across different locations
2. Identify locations with unusually high wait times
3. Monitor service performance by location
*/

-- 6. Day of Week Analysis
SELECT 
    DATENAME(WEEKDAY, Request_timestamp) as Day_of_Week,
    COUNT(*) as Requests,
    AVG(DATEDIFF(MINUTE, Request_timestamp, Pickup_timestamp)) as Avg_Wait_Time,
    COUNT(CASE WHEN Status = 'Completed' THEN 1 END) as Completed_Rides,
    COUNT(CASE WHEN Status IN ('Cancelled', 'No Cars Available') THEN 1 END) as Cancellations
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

/* INSIGHTS:
1. Compare weekday vs weekend demand
2. Analyze completion rates by day
3. Identify patterns in cancellation behavior
*/
