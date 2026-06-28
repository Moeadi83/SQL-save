The Situation: I have joined Judah Inc., a company specializing in computer hardware sales to large businesses, as a sales analyst.
The Vice President of Sales is generally satisfied with her team's performance but seeks a clearer understanding of its strengths and weaknesses.
I have been tasked with analyzing last year's sales, including key statistics on the sales pipeline's health and sales agent performance.
I will also assess product popularity and customer profiles.





Objective 1 
Pipeline metrics
  
Calculate the number of sales opportunities created each month using "engage_date" and identify month with the most opportunities. 
  
SELECT * FROM sales_pipeline;

SELECT YEAR(engage_date),MONTH(engage_date), count(*)
FROM sales_pipeline
GROUP BY year(engage_date) ,MONTH(engage_date)
ORDER BY count(*) DESC

YEAR	MONTH	Count
2017	7	  796
2017	4	  753
2017	10	703
2017	6	  681
2017	9	  677
2017	3	  655
2017	5 	588
2017	8	  539
2017	2	  420
2017	1	  247
2017	11	244
2016	12	196
2017	12	103
2016	11	102
2016	10	7

FIND the average time deals stayed open ( from "engage_date" to "close date"), and compare closed delas versus won deals

SELECT AVG (DATEDIFF(close_date, engage_date)) FROM sales_pipeline;
47.9854
  


SELECT deal_stage, AVG (DATEDIFF(close_date, engage_date))
FROM sales_pipeline
GROUP BY deal_stage
ORDER BY 2 DESC;
deal stage	Days
Won       52
lost      41


Calculate the percentage of deals in each stage, and determine what share were lost


SELECT AVG(CASE WHEN deal_stage = 'lost' THEN 1 ELSE 0 END) * 100 as lost_rate FROM sales_pipeline;
lost_rate
36.8499

Compute the win rate for each product,and identify which one had the highest win rate 

SELECT product,AVG(CASE WHEN deal_stage = 'won' THEN 1 ELSE 0 END) *100 as win_rate
FROM sales_pipeline
GROUP BY Product
ORDER BY 2 DESC;

product	     win_rate
MG Special	 64.8406
GTX Plus Pro	64.2953
GTX Basic	    63.7187
GTXPro	      63.5571
GTX Plus Basic	62.1313
MG Advanced	    60.3321
Calculate total_revenue by product series and compare their performance  
  
SELECT p.series, sum(sp.close_value) as revenue
FROM products p
LEFT JOIN sales_pipeline sp on p.product = sp.product
WHERE sp.deal_stage = 'won'
GROUP BY p.series
ORDER BY 2 DESC;
  
series	revenue
GTX	   3834189
MG	   2260155
GTK	   400612



Objective 4
Account Analysis

Calculate revenue  by office location, and identify the lowest performer 

SELECT office_location, SUM(revenue) as revenue
FROM accounts
GROUP BY office_location
ORDER BY 2;

office_location	   revenue
China	             40.79
Romania	          167.89
Brazil	          405.59
Philipines	      587.34
Kenya	            647.18
Italy            	894.33
Poland          	894.37
Germany	          1012.72
Norway	         1223.72
Belgium         	1376.8
Panama	         2938.67
Jordan	        3027.46
Japan	          5158.71
Korea	          8170.38
United States	 142997.85




  



  
  
Find the gap in yaers between the oldest and newest customer, and name those companies
Which accounts that were subsidiaries ahd the most lost sale opportunities

SELECT MAX(year_established) - MIN(year_established) as age_gap
FROM accounts
  
age_gap
38

  
select account, year_established
FROM accounts
WHERE year_established in (1979, 2017)
  
account	year_established
Condax	2017
Zotware	1979




  
  
Join the companies to their subsidiaries. Which one had the hightest total revenue?  
  
SELECT a.account, count(sp.opportunity_id) as opportunities
FROM accounts a
LEFT JOIN sales_pipeline sp ON a.account=sp.account
WHERE a.subsidiary_of != '' and sp.deal_stage='lost'
GROUP BY a.account
ORDER BY 2;

account	       opportunities
Iselectrics	        13
Dalttechnology	    18
Nam-zim        	    20
Bluth Company     	20
Gogozoom	          22
Donquadtech	        22
Vehement Capital Partners	23
Faxquote	         28
Scottech	         29
Scotfind	         31
Cheers	          33
dambase           37
Funholding	      40
Treequote	        41
Codehow           45

  
WITH company_parent AS (
SELECT account, CASE WHEN subsidiary_of = '' then account ELSE subsidiary_of END AS parent_company
FROM accounts
)
, won_deals AS (
SELECT sp.account, sp.close_value
FROM sales_pipeline sp
WHERE sp.deal_stage = 'won'
)

SELECT cp.parent_company, SUM(wd.close_value) AS total_revenue
FROM company_parent cp
LEFT JOIN won_deals wd ON wd.account=cp.account
GROUP BY cp.parent_company
ORDER BY total_revenue DESC

parent_company	total_revenue
Acme Corporation	519349
Sonron	479028
Kan-code	341455
Inity	340612
Bubba Gump	329909
Golddex	290215
Massive Dynamic	288130
Konex	269245
Warephase	233149
Condax	206410
Hottechi	194957
Goodsilron	182522
Xx-holding	169357
Isdom	164683
Mathtouch	163339
Singletechno	163339
Plussunin	155195
Umbrella Corporation	152701
Rangreen	151777
Plexzap	144976
Stanredtax	142711
Labdrill	140086
Zotware	138339
Xx-zobam	135346
Gekko & Co	134731
Y-corporation	131427
Dontechi	128048
Finjob	127569
Fasehatice	127009
Ron-tech	125481
Conecom	125310
Ganjaflex	123506
Lexiqvolax	121418
Cancity	118627
Hatfan	117942
Streethex	117463
Finhigh	117255
Globex Corporation	115712
Genco Pura Olive Oil Company	114352
Rundofase	110512
Ontomedia	110098
Betatech	107408
Sunnamplex	106754
Groovestreet	106098
J-Texon	102610
Domzoom	99639
Green-Plus	99293
Betasoloin	97036
Kinnamplus	95060
Bioholding	90991
Initech	89792
Plusstrip	89208
Blackzim	87715
Zencorporation	86690
Toughzap	85902
Rantouch	84754
Silis	83816
Newex	82622
Doncon	82118
Opentech	78669
Zumgoity	78237
Zoomit	76684
The New York Inquirer	76636
Yearin	75424
Konmatfix	72457
Bioplex	67393
Statholdings	67080
Sumace	59905
Donware	56637
Zathunicon	55616
  
  

  

  
  
