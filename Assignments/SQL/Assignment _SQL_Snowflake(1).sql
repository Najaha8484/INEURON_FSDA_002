USE DEMODATABASE;

--TABLE CREATION--
--Load the given dataset into snowflake with a primary key to Order Date column.
CREATE OR REPLACE TABLE NJ_SALES_DATA_FINAL
(
ORDER_ID	VARCHAR(100),
ORDER_DATE	STRING NOT NULL PRIMARY KEY,
SHIP_DATE	STRING,
SHIP_MODE	VARCHAR(100),
CUSTOMER_NAME	VARCHAR(100),
SEGMENT	VARCHAR(100),
STATE	VARCHAR(100),
COUNTRY	VARCHAR(100),
MARKET	VARCHAR(100),
REGION	VARCHAR(100),
PRODUCT_ID	VARCHAR(100),
CATEGORY	VARCHAR(100),
SUB_CATEGORY	VARCHAR(100),
PRODUCT_NAME	VARCHAR(500),
SALES	DECIMAL(38,000),
QUANTITY	DECIMAL(38,000),
DISCOUNT	DECIMAL(38,000),
PROFIT	DECIMAL(38,000),
SHIPPING_COST	DECIMAL(38,000),
ORDER_PROIRITY	VARCHAR(100),
YEAR	STRING
);

DESCRIBE TABLE NJ_SALES_DATA_FINAL;

SELECT * FROM NJ_SALES_DATA_FINAL;

-- SET PRIMARY KEY--

ALTER TABLE  NJ_SALES_DATA_FINAL --DROPE CURRENT PRIMARY KEY
DROP PRIMARY KEY; 

DESCRIBE TABLE NJ_SALES_DATA_FINAL;

ALTER TABLE NJ_SALES_DATA_FINAL -- Change the Primary key to Order Id Column.
ADD PRIMARY KEY(ORDER_ID); 

--CHANGING DATA TYPE STRING TO DATE--(QUESTION:CHECK THE ORDER DATE AND SHIP DATE TYPE AND THINK IN WHICH DATA TYPE YOU HAVE TO CHANGE?)

SELECT TO_DATE (ORDER_DATE,'YYYY-MM-DD' ) AS NEW_ORDER_DATE -- USE TO_DATE FUNCTION TO CHANGE THE DATE TYPE
FROM NJ_SALES_DATA_FINAL;

SELECT TO_DATE (SHIP_DATE,'DD/MM/YYYY' ) as NEW_SHIP_DATE -- USED TO_DATE FUNCTION TO CHNAGE THE DATE TYPE
FROM NJ_SALES_DATA_FINAL;

--Create a new column called order_extract and extract the number after the last
‘–‘from Order ID column.--

ALTER TABLE NJ_SALES_DATA_FINAL
ADD ORDER_EXTRAT INT;

UPDATE NJ_SALES_DATA_FINAL SET ORDER_EXTRAT = SPLIT_PART (ORDER_ID,'-',3); 

SELECT ORDER_ID, ORDER_EXTRAT FROM NJ_SALES_DATA_FINAL;

--Create a new column called Discount Flag and categorize it based on discount.
--Use ‘Yes’ if the discount is greater than zero else ‘No’.--

SELECT *,
     CASE
          WHEN DISCOUNT > 0 THEN 'YES'
          ELSE 'NO' 
     END AS DISCOUNT_FLAG 
FROM NJ_SALES_DATA_FINAL;


--Create a new column called process days and calculate how many days it takes
--for each order id to process from the order to its shipment.

SELECT datediff(DAYS, TO_DATE (ORDER_DATE,'YYYY-MM-DD' ), TO_DATE (SHIP_DATE,'DD/MM/YYYY' )) AS PROCESS_DAYS
FROM NJ_SALES_DATA_FINAL;

--Create a new column called Rating and then based on the Process dates give
--rating like given below.
--a. If process days less than or equal to 3days then rating should be 5
--b. If process days are greater than 3 and less than or equal to 6 then rating
--should be 4
--c. If process days are greater than 6 and less than or equal to 10 then rating should be 3
--d. If process days are greater than 10 then the rating should be 2.

ALTER TABLE NJ_SALES_DATA_FINAL
ADD PROCESS_DAYS INT;

UPDATE NJ_SALES_DATA_FINAL SET PROCESS_DAYS = datediff(DAYS, TO_DATE (ORDER_DATE,'YYYY-MM-DD' ), TO_DATE (SHIP_DATE,'DD/MM/YYYY' ));

SELECT *,
        CASE
            WHEN PROCESS_DAYS <= '3' THEN 5
            WHEN PROCESS_DAYS > '3' AND PROCESS_DAYS <= '6' THEN 4
            WHEN PROCESS_DAYS > '6' AND PROCESS_DAYS <= '10' THEN 3
            ELSE 2
        END AS RATING
FROM NJ_SALES_DATA_FINAL;




        








