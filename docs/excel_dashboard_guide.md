# Uber Request Data Dashboard Guide

## Step 1: Prepare Your Data
1. Open `Uber_Dashboard_Template.xlsx`
2. Copy your Uber Request Data.csv into this Excel file
3. Ensure your data has these columns:
   - Request timestamp
   - Pickup timestamp
   - Pickup point
   - Status
   - Driver id
   - Request id

## Step 1: Create Cleaned Data File

### 1. Create a New Workbook
1. Open a new Excel workbook
2. Create these sheets:
   - Sheet1: Raw Data
   - Sheet2: Cleaned Data
   - Sheet3: Charts
   - Sheet4: Pivot Tables
   - Sheet5: Dashboard

### 2. Import Raw Data
1. In Sheet1 (Raw Data):
   - Copy your raw data from the CSV file
   - Paste it in Sheet1
   - Name the sheet "Raw Data"

### 3. Clean the Data
1. In Sheet2 (Cleaned Data):
   - Copy headers from Raw Data sheet
   - Add these new columns:
     - Hour: `=HOUR('Raw Data'!A2)`
     - Day: `=TEXT('Raw Data'!A2, "dddd")`
     - Weekday: `=TEXT('Raw Data'!A2, "ddd")`
     - Date: `='Raw Data'!A2`
     - Wait Time: `=IFERROR(('Raw Data'!C2-'Raw Data'!A2)/60, 0)`
     - Peak Hour: `=IF(OR(HOUR('Raw Data'!A2)=17, HOUR('Raw Data'!A2)=18, HOUR('Raw Data'!A2)=19), "Yes", "No")`
     - Weekend: `=IF(OR(TEXT('Raw Data'!A2, "dddd")="Saturday", TEXT('Raw Data'!A2, "dddd")="Sunday"), "Yes", "No")`

2. Format the data:
   - Hour: Number format
   - Day: Text format
   - Weekday: Text format
   - Date: Date format
   - Wait Time: Number format (1 decimal place)
   - Status: Text format
   - Request id: Number format

3. Clean the data:
   - Remove duplicates:
     - Select all data in Cleaned Data sheet
     - Go to Data → Remove Duplicates
     - Keep only unique rows
   - Clean Status column:
     - Select Status column
     - Go to Data → Text to Columns → Delimited → Finish
     - Remove extra spaces

4. Save the file:
   - Save as "Uber_Cleaned_Data.xlsx"
   - Keep this file for all future analysis

### 4. Create Pivot Tables
1. In Sheet4 (Pivot Tables):
   - Create all pivot tables here
   - Each pivot table in a new section
   - Name each section clearly

### 5. Create Charts
1. In Sheet3 (Charts):
   - Create all charts here
   - Link charts to pivot tables
   - Format charts consistently

### 6. Create Dashboard

#### 1. Dashboard Layout
1. In Sheet5 (Dashboard):
   - Rename Sheet5 to "Dashboard"
   - Set row height to 20
   - Set column width to 15
   - Add a title: "Uber Request Analysis Dashboard"

#### 2. Add Slicers
1. Select any cell in your Cleaned Data
2. Go to Insert → Slicer
3. Add these slicers:
   - Pickup Point
   - Status
   - Date
   - Hour
   - Weekend
   - Peak Hour
4. Format slicers:
   - Right-click slicer → Slicer Settings
   - Set size and position
   - Choose colors
   - Add captions

#### 3. Add Charts
1. Add these charts to your dashboard:

##### A. Request Distribution Chart
- Location: Top-left
- Type: Clustered Column Chart
- Data: Request count by Pickup Point
- Format:
  - Title: "Request Distribution by Location"
  - Add data labels
  - Format colors
  - Add percentage labels

##### B. Status Distribution Chart
- Location: Top-right
- Type: Pie Chart
- Data: Request count by Status
- Format:
  - Title: "Request Status Distribution"
  - Add legend
  - Add percentage labels
  - Format colors

##### C. Hourly Pattern Chart
- Location: Middle
- Type: Line Chart
- Data: Request count by Hour
- Format:
  - Title: "Hourly Request Pattern"
  - Format X-axis (0-23)
  - Format Y-axis
  - Add trendline

##### D. Daily Pattern Chart
- Location: Bottom-left
- Type: Stacked Bar Chart
- Data: Request count by Day
- Format:
  - Title: "Daily Request Distribution"
  - Format X-axis
  - Format Y-axis
  - Add data labels

##### E. Wait Time Analysis
- Location: Bottom-right
- Type: Box Plot (if available) or Histogram
- Data: Wait Time distribution
- Format:
  - Title: "Wait Time Distribution"
  - Format X-axis
  - Format Y-axis
  - Add mean/median lines

#### 4. Add Interactive Elements
1. Add a date range selector:
   - Go to Insert → Form Controls → Scroll Bar
   - Link to cell
   - Format as date range

2. Add a summary table:
   - Total requests
   - Average wait time
   - Peak hour
   - Most active location

3. Add conditional formatting:
   - Highlight peak hours
   - Highlight high wait times
   - Highlight weekend requests

#### 5. Format Dashboard
1. Add borders and shading
2. Use consistent colors
3. Add descriptive text boxes
4. Add navigation buttons if needed
5. Protect the dashboard sheet

#### 6. Best Practices
1. Keep charts simple and focused
2. Use consistent colors throughout
3. Add clear titles and labels
4. Include legends where needed
5. Use appropriate chart types:
   - Column charts for comparisons
   - Line charts for time series
   - Pie charts for proportions
   - Box plots for distributions

#### 7. Common Issues and Solutions
1. If charts aren't updating:
   - Check data source
   - Refresh pivot tables
   - Reconnect chart data

2. If slicers aren't working:
   - Check data connections
   - Clear existing slicers
   - Reapply slicers

3. If dashboard is slow:
   - Reduce chart complexity
   - Use fewer data points
   - Optimize calculations

#### 8. Final Touches
1. Add a dashboard title
2. Add descriptive text boxes
3. Format all charts consistently
4. Add borders and background colors
5. Add navigation buttons if needed
6. Protect the dashboard sheet

## Step 2: Create Pivot Tables

### 1. Request Distribution by Location
1. In Pivot Tables sheet:
   - Select any cell in Cleaned Data
   - Go to `Insert` → `PivotTable`
   - In the Create PivotTable dialog:
     - Choose 'New Worksheet'
     - Click 'OK'
2. In the PivotTable Fields pane:

## Step 2: Create Pivot Tables

### 1. Request Distribution by Location
1. Select any cell in your data
2. Go to `Insert` → `PivotTable`
3. In the Create PivotTable dialog:
   - Choose 'New Worksheet'
   - Click 'OK'
4. In the PivotTable Fields pane:
   - Drag 'Pickup point' to Rows
   - Drag 'Request id' to Values
   - Change Value Field Settings to 'Count'
5. Format:
   - Add a title: "Request Distribution by Location"
   - Format numbers:
     1. Click on any number in the Count column
     2. Right-click → select 'Format Cells'
     3. Go to the 'Number' tab
     4. Select 'Number'
     5. Check 'Use 1000 separator (,)' or
     6. Alternatively, select 'Number' and set decimal places to 0
   - Add percentage column:
     1. Click on the Count column
     2. Go to PivotTable Analyze → Fields, Items & Sets → Calculated Field
     3. Name it 'Percentage'
     4. Formula: =Count of Request id / SUM(Count of Request id)
     5. Click OK
     6. Format as percentage:
        - Click on the percentage values
        - Right-click → Format Cells
        - Select 'Percentage'
        - Set decimal places to 1 or 2
   - Add borders and shading for better readability:
     1. Select the entire pivot table
     2. Go to Home → Borders → All Borders
     3. Use Conditional Formatting for highlighting important values

### 2. Status Distribution
1. Create a new PivotTable:
   - Select any cell in your data
   - Go to Insert → PivotTable
   - In the Create PivotTable dialog:
     - Choose 'New Worksheet' (this will create Sheet2)
     - Click 'OK'
2. In the PivotTable Fields pane:
   - Drag 'Status' to Rows
   - Drag 'Request id' to Values
   - Change Value Field Settings to 'Count'
3. Format:
   - Add a title: "Request Status Distribution"
   - Add percentage calculation
   - Sort by count in descending order

### 3. Hourly Patterns
1. Create a new PivotTable:
   - Select any cell in your CLEANED data
   - Go to Insert → PivotTable
   - In the Create PivotTable dialog:
     - Choose 'New Worksheet' (this will create Sheet3)
     - Click 'OK'
2. In the PivotTable Fields pane::
   - Select any cell in your data
   - Go to Insert → PivotTable
   - In the Create PivotTable dialog:
     - Choose 'New Worksheet' (this will create Sheet3)
     - Click 'OK'
2. In the PivotTable Fields pane:
   - Drag 'Request timestamp' to Rows
   - Drag 'Request id' to Values
3. Format Request timestamp:
   - Click on any timestamp in the Rows area
   - Go to `PivotTable Analyze` → `Group`
   - In the Grouping dialog:
     - Check 'Hours'
     - Uncheck all other options (Days, Months, Years)
     - Set 'Starting at' to 0
     - Set 'Ending at' to 23
     - Set 'By' to 1 hour
   - Click 'OK'

4. Format the grouped hours:
   - Right-click on any hour value
   - Select 'Value Field Settings'
   - Choose 'Count'
   - Click 'OK'

5. Additional formatting:
   - Sort hours from 0 to 23
   - Format numbers as comma style
   - Add borders to the table
   - Add a title: "Hourly Request Distribution"
   - Add data labels if needed
   - Format colors for better visibility
4. Format:
   - Sort by hour
   - Add title: "Hourly Request Distribution"

### 4. Daily Patterns
1. Create a new PivotTable:
   - Select any cell in your data
   - Go to Insert → PivotTable
   - In the Create PivotTable dialog:
     - Choose 'New Worksheet' (this will create Sheet4)
     - Click 'OK'
2. In the PivotTable Fields pane:
   - Drag 'Request timestamp' to Rows
   - Drag 'Request id' to Values
3. Format Request timestamp:
   - Click on any timestamp
   - Go to `PivotTable Analyze` → `Group`
   - Select 'Days'
   - Click 'OK'
4. Format:
   - Sort by day
   - Add title: "Daily Request Distribution"

## Step 3: Create Charts

### 1. Location Distribution Chart
1. Select your Location PivotTable
2. Go to `Insert` → `Column Chart` → `Clustered Column`
3. Format:
   - Add title: "Request Distribution by Location"
   - Add data labels
   - Format colors
   - Add percentage labels

### 2. Status Distribution Chart
1. Select your Status PivotTable
2. Go to `Insert` → `Pie Chart`
3. Format:
   - Add title: "Request Status Distribution"
   - Add legend
   - Add percentage labels
   - Format colors

### 3. Hourly Pattern Chart
1. Select your Hourly PivotTable
2. Go to `Insert` → `Line Chart`
3. Format:
   - Add title: "Hourly Request Distribution"
   - Format X-axis to show hours
   - Format Y-axis with appropriate scale
   - Add trendline

### 4. Daily Pattern Chart
1. Select your Daily PivotTable
2. Go to `Insert` → `Bar Chart`
3. Format:
   - Add title: "Daily Request Distribution"
   - Format X-axis to show days
   - Format Y-axis with appropriate scale
   - Add data labels

## Step 4: Dashboard Layout
1. Create a new worksheet named 'Dashboard'
2. Arrange your charts and pivot tables:
   - Top: Location Distribution Chart
   - Middle: Status Distribution Chart
   - Bottom: Time-based charts (Hourly and Daily)
3. Add slicers for filtering:
   - Go to `Insert` → `Slicer`
   - Add slicers for:
     - Pickup point
     - Status
     - Date range

## Step 5: Final Touches
1. Add a dashboard title
2. Add descriptive text boxes
3. Format all charts consistently
4. Add borders and background colors
5. Add navigation buttons if needed
6. Protect the dashboard sheet

## Tips for Better Dashboards
1. Use consistent colors throughout
2. Keep charts simple and focused
3. Use appropriate chart types:
   - Column charts for comparisons
   - Line charts for time series
   - Pie charts for proportions
4. Add interactive elements:
   - Slicers
   - Drop-down lists
   - Buttons
5. Use conditional formatting for key metrics
6. Add data validation for inputs

## Common Excel Shortcuts
- Ctrl + Shift + L: Add/Remove filter
- Ctrl + Shift + ;: Insert current time
- Ctrl + ;: Insert current date
- Alt + D + P: Quick PivotTable creation
- Ctrl + T: Create table
- Alt + E + S + V: Paste values

## Troubleshooting
1. If pivot table is not updating:
   - Click anywhere in the pivot table
   - Go to `PivotTable Analyze` → `Refresh`
2. If data is not grouping properly:
   - Check data format
   - Clear existing grouping
   - Reapply grouping
3. If charts are not updating:
   - Check data source
   - Refresh pivot tables
   - Reconnect chart data
