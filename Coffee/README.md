# Dataset Details

This dataset was collected in October 2023 when ["world champion barista" James Hoffmann](https://www.youtube.com/watch?v=bMOOQfeloH0) and [coffee company Cometeer](https://cometeer.com/pages/the-great-american-coffee-taste-test) held the "Great American Coffee Taste Test" on YouTube, during which viewers were asked to fill out a survey about 4 coffees they ordered from Cometeer for the tasting. [Data blogger Robert McKeon Aloe analyzed the data the following month](https://rmckeon.medium.com/great-american-coffee-taste-test-breakdown-7f3fdcc3c41d).

# Project Overview

My main task was to clean up the [raw coffee survey data](GACTT_RESULTS_ANONYMIZED_v2.csv) and standardize certain aspects of it and prepare it for further analysis. The main things I did were to rename columns into sensible names & dropping some attributes for easier exploration, handling NULL values, and also reformatting some values' types. Dataset has **98 columns and 4k+ entries**.

  - **SQL Skills Used**: Table Creation & Alteration, Data Manipulation, Data Type Conversion, Handling Missing Values, Normalization.
  - [View SQL Script](Coffee/coffee_dataCleaningProject.sql)

## Errors ran into while doing this project:

> MySQL said: Identifier name 'How do you brew coffee at home? (Coffee brewing machine (e.g. Mr. Coffee))' is too long
>> Renamed some columns

> MySQL said: Row size too large. The maximum row size for the used table type, not counting BLOBs, is 65535. This includes storage overhead, check the manual. You have to change some columns to TEXT or BLOBs
>> Changed column types to TEXT

> MySQL said: The storage engine for the table doesn't support nullable columns
>> https://groups.google.com/g/sequel-pro/c/PZVrYyEXrJc/m/647e_PBQBbcJ

> found out that mysql stores boolean columns as `TINYINT(1)` instead of `BOOLEAN`. interesting!