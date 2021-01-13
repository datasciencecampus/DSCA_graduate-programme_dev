# 2. Advanced Dashboard Help

## 1. parliament_odata_feed.pbix

To do this, you will need to be familiar with:
- all content in the basic task
- OData feeds
- Relational database modelling
- API queries, handling JSON
- Conditional formatting 



Please use the guidance below to help you create the report. You can also access the solution and view the query
steps under 'transform data` to assist you.

### Reference materials:

* [UK Parliament api documentation](http://data.parliament.uk/membersdataplatform/open.aspx)
* Odata endpoint: http://data.parliament.uk/membersdataplatform/open/OData.svc
* [ONS Open Geography Portal LAD codes](https://geoportal.statistics.gov.uk/datasets/fe6bcee87d95476abc84e194fe088abb_0/geoservice)
* API query used from above: https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/LAD_APR_2020_UK_NC/FeatureServer/0/query?where=1%3D1&outFields=LAD20CD,LAD20NM&outSR=4326&f=json

[shapefiles link](https://geoportal.statistics.gov.uk/datasets/7f83b82ef6ce46d3a5635d371e8a3e7c_0/geoservice)
shapefile query not working: https://ons-inspire.esriuk.com/arcgis/rest/services/Administrative_Boundaries/Local_Authority_Districts_May_2020_Boundaries_UK_BFE/MapServer/0/query?where=1%3D1&outFields=lad20cd,lad20nm,long,lat&outSR=4326&f=json

* [Conditional formatting table fields on hex colours.](https://docs.microsoft.com/en-us/power-bi/create-reports/desktop-conditional-table-formatting)

Need to go over how to import from JSON.
Then build a map that can be used to filter the data.
Also, use this as a good use case for DAX meeasure cards and buttons to present geo vs card filters.


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