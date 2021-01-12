# 1. Basic Dashboard help

To do this, you will need to be familiar with:
- importing csv / xlsx
- basic power query
- aggregation behaviour of PBI
- creating visuals
- edit interactions
- 

Please use the guidance below to help you create the report. You can also 


1. Download the data from [ONS website](https://www.ons.gov.uk/generator?format=csv&uri=/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/timeseries/lf24/lms)

- This can be downloaded and stored locally, then loaded to the .pbix.
- Or you can download directly from the webpage that hosts the table.

2. Cleaning the data. Use Power Query to:

- Remove unrequired rows from the top of the table.
- Create a valid date column.
- Filter to the smallest level of granularity.
- Rename columns as required.
- Change data types. Advise keeping year as text.

3. Present the data:

- 2 line charts showing time series against **average** employment rates.
- 1 table showing all data rows currently selected by the user.
- 1 slicer for a categorical year field. Specify the slicer as `Paint Roller` > `General` > `Orientation` > `Horizontal`.
- Top time series will be for user selected year. Display quarter by default.
- Bottom time series will be total time series data. Display year by default. Make this non responsive to filter interactions.
- Under the paint roller, select `shapes`, increase `stroke width` to 5 and toggle show marker to `on`.