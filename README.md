**                MSc ANALYTICS 
**     DATA ENGINEERING PLATFORMS (MSCA 31012)
** File:   Final Project Description
** Desc:   Food_Sense_Database 
** Auth:   Omar AlShaye, Valeri Antonova, Matthew Rosental
** Date:   12/7/2018
************************************************/

Purpose:
The purpose behind this database, is to serve as a 'refrigirator app', which will connect the customer to their favorite grocery store. The app will analyze the customer consumer rate, and provide with a suggested grocery list when the remaining percentage of product reaches below a certain level.
The app will also provide consumption data in zip code area to grocery store.
*****************************************************************************************/

Setting Up Database and Uploading Data:
To upload database to mySQL, first run the script in Food_Sense_Final_DDL.sql

Uploading data takes a couple of steps:
1. Run ImportData_DML.sql
2. Import matt_data.csv, omar_data.csv, val_data.csv consecutively into the customer table by  Table Data Import Wizard.
* To access Table Data Import Wizard, right - click on the appropriate table and select the 5th option in the appeared menu.
3. Import Store_Inventory.csv into the store_inventory table by following the Table Data Import Wizard.
*****************************************************************************************/

Running Queries:
Please run the QueriestoRun.sql file. This populates the information needed for analysis of the data.
*****************************************************************************************/

Visiulizations:
Please refer to the provided Tableau file for dashboards.