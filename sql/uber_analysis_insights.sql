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

-- 7. Peak Hours Analysis
SELECT 
    DATEPART(HOUR, Request_timestamp) as Hour,
    COUNT(*) as Requests,
    AVG(DATEDIFF(MINUTE, Request_timestamp, Pickup_timestamp)) as Avg_Wait_Time,
    COUNT(CASE WHEN Status = 'Completed' THEN 1 END) as Completed_Rides,
    COUNT(CASE WHEN Status IN ('Cancelled', 'No Cars Available') THEN 1 END) as Cancellations
FROM uber_requests
WHERE Request_timestamp >= DATEADD(DAY, -7, GETDATE())  -- Last 7 days
GROUP BY DATEPART(HOUR, Request_timestamp)
ORDER BY Hour;

/* INSIGHTS:
1. Monitor recent trends in peak hours
2. Track performance during rush hours
3. Identify emerging patterns in service demand
*/

-- 8. Location Performance Analysis
SELECT 
    Pickup_point,
    COUNT(*) as Total_Requests,
    COUNT(CASE WHEN Status = 'Completed' THEN 1 END) * 100.0 / COUNT(*) as Completion_Rate,
    COUNT(CASE WHEN Status IN ('Cancelled', 'No Cars Available') THEN 1 END) * 100.0 / COUNT(*) as Cancellation_Rate,
    AVG(DATEDIFF(MINUTE, Request_timestamp, Pickup_timestamp)) as Avg_Wait_Time
FROM uber_requests
GROUP BY Pickup_point
ORDER BY Completion_Rate DESC;

/* INSIGHTS:
1. Compare performance across different locations
2. Identify high-performing locations
3. Analyze factors affecting completion rates
*/

-- 9. Time-Based Trends
SELECT 
    DATEPART(WEEKDAY, Request_timestamp) as Day_of_Week,
    DATEPART(HOUR, Request_timestamp) as Hour,
    COUNT(*) as Requests,
    AVG(DATEDIFF(MINUTE, Request_timestamp, Pickup_timestamp)) as Avg_Wait_Time
FROM uber_requests
WHERE Status = 'Completed'
GROUP BY DATEPART(WEEKDAY, Request_timestamp), DATEPART(HOUR, Request_timestamp)
ORDER BY Day_of_Week, Hour;

/* INSIGHTS:
1. Analyze hourly patterns by day of week
2. Identify peak demand periods
3. Optimize resource allocation based on time patterns
*/

-- 10. Driver Performance Analysis
SELECT 
    Driver_id,
    COUNT(*) as Total_Rides,
    AVG(DATEDIFF(MINUTE, Request_timestamp, Pickup_timestamp)) as Avg_Wait_Time,
    COUNT(CASE WHEN Status = 'Completed' THEN 1 END) * 100.0 / COUNT(*) as Completion_Rate
FROM uber_requests
GROUP BY Driver_id
HAVING COUNT(*) > 10  -- Only include drivers with more than 10 rides
ORDER BY Completion_Rate DESC, Avg_Wait_Time ASC;

/* INSIGHTS:
1. Track driver performance metrics
2. Identify top-performing drivers
3. Analyze factors affecting driver efficiency
*/

-- 11. Weekend vs Weekday Analysis
SELECT 
    CASE 
        WHEN DATEPART(WEEKDAY, Request_timestamp) IN (7, 1) THEN 'Weekend'
        ELSE 'Weekday'
    END as Period_Type,
    COUNT(*) as Requests,
    AVG(DATEDIFF(MINUTE, Request_timestamp, Pickup_timestamp)) as Avg_Wait_Time,
    COUNT(CASE WHEN Status = 'Completed' THEN 1 END) * 100.0 / COUNT(*) as Completion_Rate
FROM uber_requests
GROUP BY CASE 
    WHEN DATEPART(WEEKDAY, Request_timestamp) IN (7, 1) THEN 'Weekend'
    ELSE 'Weekday'
    END;

/* INSIGHTS:
1. Compare weekend vs weekday performance
2. Analyze demand patterns
3. Optimize resource allocation for different periods
*/

-- 12. Peak Hour Analysis
WITH HourlyData AS (
    SELECT 
        DATEPART(HOUR, Request_timestamp) as Hour,
        COUNT(*) as Requests
    FROM uber_requests
    GROUP BY DATEPART(HOUR, Request_timestamp)
)
SELECT 
    Hour,
    Requests,
    LAG(Requests) OVER (ORDER BY Hour) as Previous_Hour,
    (Requests - LAG(Requests) OVER (ORDER BY Hour)) * 100.0 / LAG(Requests) OVER (ORDER BY Hour) as Hourly_Change
FROM HourlyData
ORDER BY Hour;

/* INSIGHTS:
1. Track hour-to-hour changes in demand
2. Identify sudden spikes in requests
3. Monitor service capacity during peak hours
*/
