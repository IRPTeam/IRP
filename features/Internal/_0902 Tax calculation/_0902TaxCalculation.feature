﻿#language: en
@tree
@Positive
@TaxCalculation

Feature: tax calculation check


# individually applying Tax types

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one




	
Scenario: _0902000 preparation
	When set True value to the constant
	When set True value to the constant Use commission trading
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create catalog CashAccounts objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects (with transaction type)	
		When Create information register TaxSettings records with transaction type
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Countries objects
		When Create catalog BusinessUnits objects 
	* Tax settings
		When filling in Tax settings for company
	* Filling tax rates for Item key in the register
		Given I open hyperlink "e1cib/list/InformationRegister.TaxSettings"
		And I click the button named "FormCreate"
		And I change "RecordType" radio button value to "Item key"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Tax" field
		And I go to line in "List" table
			| 'Description' | 'Reference' |
			| 'VAT'         | 'VAT'       |
		And I select current line in "List" table
		And I click Select button of "Item key" field
		And I go to line in "List" table
			| 'Item' | 'Item key' |
			| 'Bag'  | 'ODS'      |
		And I select current line in "List" table
		And I select "0%" exact value from "Tax rate" drop-down list
		And I input "01.01.2020" text in "Period" field
		And I click "Save and close" button
	* Filling tax rates for Item in the register
		Given I open hyperlink "e1cib/list/InformationRegister.TaxSettings"
		And I click the button named "FormCreate"
		And I change "RecordType" radio button value to "Item"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Tax" field
		And I go to line in "List" table
			| 'Description' | 'Reference' |
			| 'VAT'         | 'VAT'       |
		And I select current line in "List" table
		And I click Select button of "Item" field
		And I go to line in "List" table
			| 'Description' |
			| 'Bag'         |
		And I select current line in "List" table
		And I select "18%" exact value from "Tax rate" drop-down list
		And I input "01.01.2020" text in "Period" field
		And I click "Save and close" button
	* Filling tax rates for Item type in the register
		Given I open hyperlink "e1cib/list/InformationRegister.TaxSettings"
		And I click the button named "FormCreate"
		And I change "RecordType" radio button value to "Item type"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Tax" field
		And I go to line in "List" table
			| 'Description' | 'Reference' |
			| 'VAT'         | 'VAT'       |
		And I select current line in "List" table
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| 'Description' |
			| 'Bags'         |
		And I select current line in "List" table
		And I select "18%" exact value from "Tax rate" drop-down list
		And I input "01.01.2020" text in "Period" field
		And I click "Save and close" button
	And I close all client application windows

Scenario: _09020001 check preparation
	When check preparation

Scenario: _090201 activating Sales Tax calculation in the Sales order and Sales invoice documents
	* Opening a tax creation form
		Given I open hyperlink "e1cib/list/Catalog.Taxes"
		If "List" table does not contain lines Then
				| "Description" |
				| "SalesTax" |
			And I click the button named "FormCreate"
		* Filling in Sales Tax rate settings
			And I input "SalesTax" text in the field named "Description_en"
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'        |
				| 'TaxCalculateVAT_TR' |
			And I select current line in "List" table
			And in the table "TaxRates" I click the button named "TaxRatesAdd"
			And I click choice button of "Tax rate" attribute in "TaxRates" table
			And I click the button named "FormCreate"
			Then "Tax rate (create)" window is opened
			And I input "1%" text in "ENG" field
			And I input "1,000000000000" text in "Rate" field
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| '1%'          |
			And I click the button named "FormChoose"
			And I finish line editing in "TaxRates" table
			And I click "Save" button
			And I click "Settings" button
			And I click "Ok" button
			And I move to "Use documents" tab
			And in the table "UseDocuments" I click the button named "UseDocumentsAdd"
			And I select "Sales order" exact value from "Document name" drop-down list in "UseDocuments" table
			And I finish line editing in "UseDocuments" table
			And in the table "UseDocuments" I click the button named "UseDocumentsAdd"
			And I select "Sales invoice" exact value from "Document name" drop-down list in "UseDocuments" table
			And I finish line editing in "UseDocuments" table
			And I click "Save and close" button
	Given I open hyperlink "e1cib/list/InformationRegister.Taxes"
	If "List" table does not contain lines Then
		| 'Tax'      |
		| 'SalesTax' |
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I input "01.01.2020" text in "Period" field
		And I click Select button of "Tax" field
		And I go to line in "List" table
			| 'Description' |
			| 'SalesTax'    |
		And I select current line in "List" table
		And I set checkbox "Use"
		And I input "8" text in "Priority" field
		And I click "Save and close" button
	Given I open hyperlink "e1cib/list/InformationRegister.TaxSettings"
	If "List" table does not contain lines Then
				| "Tax" |
				| "SalesTax" |
			And I click the button named "FormCreate"
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
			And I click Select button of "Tax" field
			And I go to line in "List" table
				| 'Description' |
				| 'SalesTax'    |
			And I select current line in "List" table
			And I click Select button of "Tax rate" field
			And I select "1%" exact value from "Tax rate" drop-down list	
			And I click "Save and close" button
	
		




Scenario: _090202 VAT and Sales Tax calculation in Sales order (Price includes tax box is set)
	* Open the Sales order creation form
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
	* Adding items to Sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I activate "Procurement method" field in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check the calculation of VAT and Sales Tax
		And "ItemList" table contains lines
		| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Procurement method' | 'Quantity'     | 'Tax amount' | 'SalesTax' | 'Unit' | 'Net amount' | 'Total amount' |
		| '400,00' | 'Trousers' | '18%' | '38/Yellow' | 'Stock'              | '1,000' | '64,98'      | '1%'       | 'pcs'  | '335,02'     | '400,00'       |
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "64,98"
	* Add one more line and check the calculation of VAT and Sales Tax
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "List" table
		And I activate "Procurement method" field in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I move to the next attribute
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount' | 'SalesTax' | 'Net amount' | 'Total amount' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '64,98'      | '1%'       | '335,02'     | '400,00'       |
			| '700,00' | 'Boots'    | '18%' | '37/18SD'   | '2,000' | '227,42'     | '1%'       | '1 172,58'   | '1 400,00'     |
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "292,40"
	* Deleting the row and checking the VAT and Sales Tax recalculation
		And I go to line in "ItemList" table
		| 'Item'     | 'Item key'  |
		| 'Trousers' | '38/Yellow' |
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I delete a line in "ItemList" table
		And "ItemList" table contains lines
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Quantity'     | 'Tax amount' | 'SalesTax' | 'Net amount' | 'Total amount' |
			| '700,00' | 'Boots' | '18%' | '37/18SD'  | '2,000' | '227,42'     | '1%'       | '1 172,58'   | '1 400,00'     |
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "227,42"
		And I close all client application windows

Scenario: _090203 VAT and Sales Tax calculation in Sales order (Price includes tax box isn't set)
	* Open the Sales order creation form
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I move to "Other" tab
		And I expand "More" group
		And I remove checkbox "Price includes tax"
	* Adding items to Sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I activate "Procurement method" field in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check the calculation of VAT and Sales Tax
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount' | 'SalesTax' | 'Unit' | 'Net amount' | 'Total amount' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '76,00'      | '1%'       | 'pcs'  | '400,00'     | '476,00'       |
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "76,00"
	* Add one more line and check the calculation of VAT and Sales Tax
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "List" table
		And I activate "Procurement method" field in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I move to the next attribute
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Procurement method' | 'Quantity'     | 'Tax amount' | 'SalesTax' | 'Unit' | 'Net amount' | 'Total amount' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | 'Stock'              | '1,000' | '76,00'      | '1%'       | 'pcs'  | '400,00'     | '476,00'       |
			| '700,00' | 'Boots'    | '18%' | '37/18SD'   | 'Stock'              | '2,000' | '266,00'     | '1%'       | 'pcs'  | '1 400,00'   | '1 666,00'     |
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "342,00"
	* Deleting the row and checking the VAT and Sales Tax recalculation
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I delete a line in "ItemList" table
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Offers amount' | 'Tax amount' | 'SalesTax' | 'Unit' | 'Net amount' | 'Total amount' |
			| '700,00' | 'Boots'    | '18%' | '37/18SD'   | '2,000' | ''              | '266,00'     | '1%'       | 'pcs'  | '1 400,00'   | '1 666,00'     |
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "266,00"
		And I close all client application windows

Scenario: _090204 manual tax correction in Sales order
	* Open the Sales order creation form
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I move to "Other" tab
		And I expand "More" group
		And I remove checkbox "Price includes tax"
	* Adding items to Sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I activate "Procurement method" field in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Manual tax correction and check display
		And I activate "Tax amount" field in "ItemList" table
		And I select current line in "ItemList" table
		Then "Edit tax" window is opened
		And I activate "Manual amount" field in "TaxTree" table
		And I select current line in "TaxTree" table
		And I input "71,00" text in "Manual amount" field of "TaxTree" table
		And I finish line editing in "TaxTree" table
		And I click "Ok" button	
	* Save verification
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount' | 'SalesTax' | 'Unit' | 'Net amount' | 'Total amount' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '75,00'      | '1%'       | 'pcs'  | '400,00'     | '475,00'       |
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "75,00"
	* Check deleting manual correction when quantity changes
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount'  | 'SalesTax' | 'Unit' | 'Net amount' | 'Total amount' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | '152,00'      | '1%'       | 'pcs'   | '800,00'      | '952,00'     |
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "152,00"
	* Check deleting manual correction when quantity changes
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount'  | 'SalesTax' | 'Unit' | 'Net amount' | 'Total amount' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | '152,00'      | '1%'       | 'pcs'   | '800,00'      | '952,00'     |
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "152,00"
	* Check deleting manual correction when price changes
		And I activate "Tax amount" field in "ItemList" table
		And I select current line in "ItemList" table
		Then "Edit tax" window is opened
		And I activate "Manual amount" field in "TaxTree" table
		And I select current line in "TaxTree" table
		And I input "142,00" text in "Manual amount" field of "TaxTree" table
		And I finish line editing in "TaxTree" table
		And I click "Ok" button	
		And "ItemList" table contains lines
			| 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount' | 'SalesTax' | 'Unit' | 'Net amount' | 'Total amount' |
			| 'Trousers' | '18%' | '38/Yellow' | '2,000' | '150,00'     | '1%'       | 'pcs'  | '800,00'     | '950,00'     |
		And I move to "Item list" tab
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "510,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "193,80"
	* Check deleting manual correction when iten key changes
		And I activate "Tax amount" field in "ItemList" table
		And I select current line in "ItemList" table
		Then "Edit tax" window is opened
		And I activate "Manual amount" field in "TaxTree" table
		And I select current line in "TaxTree" table
		And I input "182,00" text in "Manual amount" field of "TaxTree" table
		And I finish line editing in "TaxTree" table
		And I click "Ok" button	
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount' | 'SalesTax' | 'Unit' | 'Net amount' | 'Total amount' |
			| '510,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | '192,20'     | '1%'       | 'pcs'  | '1 020,00'   | '1 212,20'     |
		And I activate "Item key" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '36/Yellow' |
		And I select current line in "List" table
	* Manual selection of tax rate
		And I activate "VAT" field in "ItemList" table
		And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "8,00"
	And I close all client application windows



Scenario: _090205 check tax transfer in Sales invoice when it is created based on
	* Create Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I activate "Procurement method" field in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "List" table
		And I activate "Procurement method" field in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I move to the next attribute
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Price type'        | 'Quantity'     | 'Unit' | 'SalesTax' | 'Tax amount' | 'Net amount' | 'Total amount' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | 'Basic Price Types' | '1,000' | 'pcs'  | '1%'       | '64,98'      | '335,02'     | '400,00'       |
			| '700,00' | 'Boots'    | '18%' | '37/18SD'   | 'Basic Price Types' | '2,000' | 'pcs'  | '1%'       | '227,42'     | '1 172,58'   | '1 400,00'     |
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |	
		And I activate "Tax amount" field in "ItemList" table
		And I select current line in "ItemList" table
		And I activate "Manual amount" field in "TaxTree" table
		And I go to line in "TaxTree" table
			| 'Amount' | 'Manual amount' | 'Row presentation' |
			| '61,02'  | '61,02'         | 'VAT - TRY - 18%'  |
		And I select current line in "TaxTree" table
		And I input "62,00" text in "Manual amount" field of "TaxTree" table
		And I finish line editing in "TaxTree" table
		And I click "Ok" button
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice090204$$" variable
		And I delete "$$SalesInvoice090204$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice090204$$"
		And I save the window as "$$SalesInvoice090204$$"
		And I click the button named "FormPost"
	* Create Sales invoice based on Sales order and check filling Tax types
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'SalesTax' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | 'pcs'  | '1%'       | '65,96'      | '334,04'     | '400,00'       | 'Store 01' |
			| '700,00' | 'Boots'    | '18%' | '37/18SD'   | '2,000' | 'pcs'  | '1%'       | '227,42'     | '1 172,58'   | '1 400,00'     | 'Store 01' |
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "293,38"
		And I click the button named "FormPostAndClose"
		And I close all client application windows

Scenario: _090206 priority tax rate check on the example of Sales order
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	* Filling in the details of the document Sales order
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Check the tax rate for Item key Bag ODS
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Bag'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item' | 'Item key' |
			| 'Bag'  | 'ODS'      |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Item' | 'VAT' | 'Item key' | 'Quantity'     |
			| 'Bag'  | '0%'  | 'ODS'      | '1,000' |
	* Check the tax rate by item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Bag'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item' | 'Item key' |
			| 'Bag'  | 'PZU'      |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Item' | 'VAT' | 'Item key' | 'Quantity'     |
			| 'Bag'  | '18%'  | 'PZU'      | '1,000' |
	And I close all client application windows
		

Scenario: _090208 check tax in the SO (depend of transaction type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	* Filling in the details of the document Sales order
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Select transaction type
		And I select "Retail sales" exact value from "Transaction type" drop-down list
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'   | 'Item key' |
			| 'Dress'  | 'L/Green'      |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'   | 'Item key' |
			| 'Dress'  | 'M/White'      |
		And I select current line in "List" table
	* Check tax rate
		And "ItemList" table contains lines
			| 'SalesTax' | 'Item key' | 'Quantity' | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Net amount' | 'Total amount' | 'Item'  |
			| '1%'       | 'L/Green'  | '1,000'    | 'pcs'  | '46,19'      | '550,00' | '8%'  | '503,81'     | '550,00'       | 'Dress' |
			| '1%'       | 'M/White'  | '1,000'    | 'pcs'  | '43,67'      | '520,00' | '8%'  | '476,33'     | '520,00'       | 'Dress' |
	* Change transaction type and check tax rate
		And I select "Sales" exact value from "Transaction type" drop-down list
		And "ItemList" table contains lines
			| 'SalesTax' | 'Item key' | 'Quantity' | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Net amount' | 'Total amount' | 'Price type'        | 'Item'  | 'Sales person' |
			| '1%'       | 'L/Green'  | '1,000'    | 'pcs'  | '89,35'      | '550,00' | '18%' | '460,65'     | '550,00'       | 'Basic Price Types' | 'Dress' | ''             |
			| '1%'       | 'M/White'  | '1,000'    | 'pcs'  | '84,47'      | '520,00' | '18%' | '435,53'     | '520,00'       | 'Basic Price Types' | 'Dress' | ''             |
		And I select "Shipment to trade agent" exact value from "Transaction type" drop-down list
		And "ItemList" table contains lines
			| 'SalesTax' | 'Item key' | 'Quantity' | 'Dont calculate row' | 'Unit' | 'Tax amount' | 'Price'  | 'Net amount' | 'Total amount' | 'Store'    | 'Item'  | 'Price type'        |
			| '1%'       | 'L/Green'  | '1,000'    | 'No'                 | 'pcs'  | '5,45'       | '550,00' | '544,55'     | '550,00'       | 'Store 01' | 'Dress' | 'Basic Price Types' |
			| '1%'       | 'M/White'  | '1,000'    | 'No'                 | 'pcs'  | '5,15'       | '520,00' | '514,85'     | '520,00'       | 'Store 01' | 'Dress' | 'Basic Price Types' |
		And I close all client application windows


Scenario: _090209 check tax in the SI (depend of transaction type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	* Filling in the details of the document SI
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Select transaction type
		And I select "Sales" exact value from "Transaction type" drop-down list
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'   | 'Item key' |
			| 'Dress'  | 'L/Green'      |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'   | 'Item key' |
			| 'Dress'  | 'M/White'      |
		And I select current line in "List" table
	* Check tax rate
		And "ItemList" table contains lines
			| 'SalesTax' | 'Item key' | 'Quantity' | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Net amount' | 'Total amount' | 'Price type'        | 'Item'  | 'Sales person' |
			| '1%'       | 'L/Green'  | '1,000'    | 'pcs'  | '89,35'      | '550,00' | '18%' | '460,65'     | '550,00'       | 'Basic Price Types' | 'Dress' | ''             |
			| '1%'       | 'M/White'  | '1,000'    | 'pcs'  | '84,47'      | '520,00' | '18%' | '435,53'     | '520,00'       | 'Basic Price Types' | 'Dress' | ''             |
	* Change transaction type and check tax rate
		And I select "Retail sales" exact value from "Transaction type" drop-down list
		And "ItemList" table contains lines
			| 'SalesTax' | 'Item key' | 'Quantity' | 'Dont calculate row' | 'Unit' | 'Tax amount' | 'Price'  | 'Net amount' | 'Total amount' | 'Store'    | 'Item'  | 'Price type'        |
			| '1%'       | 'L/Green'  | '1,000'    | 'No'                 | 'pcs'  | '5,45'       | '550,00' | '544,55'     | '550,00'       | 'Store 01' | 'Dress' | 'Basic Price Types' |
			| '1%'       | 'M/White'  | '1,000'    | 'No'                 | 'pcs'  | '5,15'       | '520,00' | '514,85'     | '520,00'       | 'Store 01' | 'Dress' | 'Basic Price Types' |
		And I close all client application windows
			
					

Scenario: _090210 check tax in the PI (depend of transaction type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I click the button named "FormCreate"
	* Filling in the details of the document PI
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Select transaction type
		And I select "Purchase" exact value from "Transaction type" drop-down list
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'   | 'Item key' |
			| 'Dress'  | 'L/Green'      |
		And I select current line in "List" table
		And I select current line in "ItemList" table
		And I input "550,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'   | 'Item key' |
			| 'Dress'  | 'M/White'      |
		And I select current line in "List" table
		And I select current line in "ItemList" table
		And I input "520,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check tax rate
		And "ItemList" table contains lines
			| 'Item key' | 'Quantity' | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Net amount' | 'Total amount' | 'Item'  |
			| 'L/Green'  | '1,000'    | 'pcs'  | '83,90'      | '550,00' | '18%' | '466,10'     | '550,00'       | 'Dress' |
			| 'M/White'  | '1,000'    | 'pcs'  | '79,32'      | '520,00' | '18%' | '440,68'     | '520,00'       | 'Dress' |
	* Change transaction type and check tax rate
		And I select "Receipt from consignor" exact value from "Transaction type" drop-down list
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Quantity' | 'Price'  | 'Total amount' |
			| 'Dress' | 'L/Green'  | '1,000'    | '550,00' | '550,00'       |
			| 'Dress' | 'M/White'  | '1,000'    | '520,00' | '520,00'       |
		And I close all client application windows				


Scenario: _090211 check tax in the PO (depend of transaction type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I click the button named "FormCreate"
	* Filling in the details of the document PO
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Select transaction type
		And I select "Purchase" exact value from "Transaction type" drop-down list
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'   | 'Item key' |
			| 'Dress'  | 'L/Green'      |
		And I select current line in "List" table
		And I select current line in "ItemList" table
		And I input "550,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'   | 'Item key' |
			| 'Dress'  | 'M/White'      |
		And I select current line in "List" table
		And I select current line in "ItemList" table
		And I input "520,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check tax rate
		And "ItemList" table contains lines
			| 'Item key' | 'Quantity' | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Net amount' | 'Total amount' | 'Item'  |
			| 'L/Green'  | '1,000'    | 'pcs'  | '83,90'      | '550,00' | '18%' | '466,10'     | '550,00'       | 'Dress' |
			| 'M/White'  | '1,000'    | 'pcs'  | '79,32'      | '520,00' | '18%' | '440,68'     | '520,00'       | 'Dress' |
	* Change transaction type and check tax rate
		And I select "Receipt from consignor" exact value from "Transaction type" drop-down list
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Quantity' | 'Price'  | 'Total amount' |
			| 'Dress' | 'L/Green'  | '1,000'    | '550,00' | '550,00'       |
			| 'Dress' | 'M/White'  | '1,000'    | '520,00' | '520,00'       |
		And I close all client application windows					
	

Scenario: _090212 check tax in the SRO(depend of transaction type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	And I click the button named "FormCreate"
	* Filling in the details of the document SRO
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Select transaction type
		And I select "Return from customer" exact value from "Transaction type" drop-down list
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'   | 'Item key' |
			| 'Dress'  | 'L/Green'      |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'   | 'Item key' |
			| 'Dress'  | 'M/White'      |
		And I select current line in "List" table
	* Check tax rate
		And "ItemList" table contains lines
			| 'Item key' | 'Quantity' | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Net amount' | 'Total amount' | 'Item'  | 'Sales person' |
			| 'L/Green'  | '1,000'    | 'pcs'  | '83,90'      | '550,00' | '18%' | '466,10'     | '550,00'       | 'Dress' | ''             |
			| 'M/White'  | '1,000'    | 'pcs'  | '79,32'      | '520,00' | '18%' | '440,68'     | '520,00'       | 'Dress' | ''             |
	* Change transaction type and check tax rate
		And I select "Return from trade agent" exact value from "Transaction type" drop-down list
		And "ItemList" table contains lines
			| 'Item key' | 'Quantity' | 'Unit' | 'Price'  | 'Total amount' | 'Store'    | 'Item'  |
			| 'L/Green'  | '1,000'    | 'pcs'  | '550,00' | '550,00'       | 'Store 01' | 'Dress' |
			| 'M/White'  | '1,000'    | 'pcs'  | '520,00' | '520,00'       | 'Store 01' | 'Dress' |
		And I close all client application windows


Scenario: _090213 check tax in the SR (depend of transaction type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	And I click the button named "FormCreate"
	* Filling in the details of the document SR
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Select transaction type
		And I select "Return from customer" exact value from "Transaction type" drop-down list
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'   | 'Item key' |
			| 'Dress'  | 'L/Green'      |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'   | 'Item key' |
			| 'Dress'  | 'M/White'      |
		And I select current line in "List" table
	* Check tax rate
		And "ItemList" table contains lines
			| 'Item key' | 'Quantity' | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Net amount' | 'Total amount' | 'Item'  | 'Sales person' |
			| 'L/Green'  | '1,000'    | 'pcs'  | '83,90'      | '550,00' | '18%' | '466,10'     | '550,00'       | 'Dress' | ''             |
			| 'M/White'  | '1,000'    | 'pcs'  | '79,32'      | '520,00' | '18%' | '440,68'     | '520,00'       | 'Dress' | ''             |
	* Change transaction type and check tax rate
		And I select "Return from trade agent" exact value from "Transaction type" drop-down list
		And "ItemList" table contains lines
			| 'Item key' | 'Quantity' | 'Unit' | 'Price'  | 'Total amount' | 'Store'    | 'Item'  |
			| 'L/Green'  | '1,000'    | 'pcs'  | '550,00' | '550,00'       | 'Store 01' | 'Dress' |
			| 'M/White'  | '1,000'    | 'pcs'  | '520,00' | '520,00'       | 'Store 01' | 'Dress' |
		And I close all client application windows


Scenario: _090214 check tax in the PRO(depend of transaction type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	And I click the button named "FormCreate"
	* Filling in the details of the document PRO
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Select transaction type
		And I select "Return to vendor" exact value from "Transaction type" drop-down list
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'   | 'Item key' |
			| 'Dress'  | 'L/Green'      |
		And I select current line in "List" table
		And I select current line in "ItemList" table
		And I input "550,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'   | 'Item key' |
			| 'Dress'  | 'M/White'      |
		And I select current line in "List" table
		And I select current line in "ItemList" table
		And I input "520,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check tax rate
		And "ItemList" table contains lines
			| 'Item key' | 'Quantity' | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Net amount' | 'Total amount' | 'Item'  |
			| 'L/Green'  | '1,000'    | 'pcs'  | '83,90'      | '550,00' | '18%' | '466,10'     | '550,00'       | 'Dress' |
			| 'M/White'  | '1,000'    | 'pcs'  | '79,32'      | '520,00' | '18%' | '440,68'     | '520,00'       | 'Dress' |
	* Change transaction type and check tax rate
		And I select "Return to consignor" exact value from "Transaction type" drop-down list
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Quantity' | 'Price'  | 'Total amount' |
			| 'Dress' | 'L/Green'  | '1,000'    | '550,00' | '550,00'       |
			| 'Dress' | 'M/White'  | '1,000'    | '520,00' | '520,00'       |
		And I close all client application windows


Scenario: _090215 check tax in the PR (depend of transaction type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	And I click the button named "FormCreate"
	* Filling in the details of the document PR
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Select transaction type
		And I select "Return to vendor" exact value from "Transaction type" drop-down list
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'   | 'Item key' |
			| 'Dress'  | 'L/Green'      |
		And I select current line in "List" table
		And I select current line in "ItemList" table
		And I input "550,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'   | 'Item key' |
			| 'Dress'  | 'M/White'      |
		And I select current line in "List" table
		And I select current line in "ItemList" table
		And I input "520,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check tax rate
		And "ItemList" table contains lines
			| 'Item key' | 'Quantity' | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Net amount' | 'Total amount' | 'Item'  |
			| 'L/Green'  | '1,000'    | 'pcs'  | '83,90'      | '550,00' | '18%' | '466,10'     | '550,00'       | 'Dress' |
			| 'M/White'  | '1,000'    | 'pcs'  | '79,32'      | '520,00' | '18%' | '440,68'     | '520,00'       | 'Dress' |
	* Change transaction type and check tax rate
		And I select "Return to consignor" exact value from "Transaction type" drop-down list
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Quantity' | 'Price'  | 'Total amount' |
			| 'Dress' | 'L/Green'  | '1,000'    | '550,00' | '550,00'       |
			| 'Dress' | 'M/White'  | '1,000'    | '520,00' | '520,00'       |
		And I close all client application windows


Scenario: _090216 check tax in the BP (depend of transaction type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	And I click the button named "FormCreate"
	* Filling main info
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'       |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Account"
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, TRY' |
		And I select current line in "List" table
	* Select partner
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "1 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
	* Check tax rate
		And I finish line editing in "PaymentList" table
		And "PaymentList" table became equal
			| 'Partner'   | 'Payee'             | 'Tax amount' | 'Total amount' | 'VAT' | 'Net amount' |
			| 'Ferron BP' | 'Company Ferron BP' | '74,07'      | '1 000,00'     | '8%'  | '925,93'     |
	* Change transaction type and check tax rate
		And I select "Customer advance" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table became equal
			| 'Retail customer' | 'Total amount' |
			| ''                | '925,93'       |
		And I close all client application windows
		

Scenario: _090217 check tax in the CP (depend of transaction type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	And I click the button named "FormCreate"
	* Filling main info
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'       |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "CashAccount"
		And I go to line in "List" table
			| 'Description'       |
			| 'Cash desk №4' |
		And I select current line in "List" table
	* Select partner
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "1 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
	* Check tax rate
		And I finish line editing in "PaymentList" table
		And "PaymentList" table became equal
			| 'Partner'   | 'Payee'             | 'Tax amount' | 'Total amount' | 'VAT' | 'Net amount' |
			| 'Ferron BP' | 'Company Ferron BP' | '74,07'      | '1 000,00'     | '8%'  | '925,93'     |
	* Change transaction type and check tax rate
		And I select "Customer advance" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table became equal
			| 'Retail customer' | 'Total amount' |
			| ''                | '925,93'     |
		And I close all client application windows	
				

Scenario: _090218 check tax in the CR (depend of transaction type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	And I click the button named "FormCreate"
	* Filling main info
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'       |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "CashAccount"
		And I go to line in "List" table
			| 'Description'       |
			| 'Cash desk №4' |
		And I select current line in "List" table
	* Select partner
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "1 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
	* Check tax rate
		And I finish line editing in "PaymentList" table
		And "PaymentList" table became equal
			| 'Partner'   | 'Payer'             | 'Tax amount' | 'Total amount' | 'VAT' | 'Net amount' |
			| 'Ferron BP' | 'Company Ferron BP' | '152,54'     | '1 000,00'     | '18%' | '847,46'     |
	* Change transaction type and check tax rate
		And I select "Return from vendor" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table became equal
			| 'Partner'   | 'Payer'             | 'Tax amount' | 'Total amount' | 'VAT' |
			| 'Ferron BP' | 'Company Ferron BP' | ''           | '847,46'       | '0%'  |
		And I close all client application windows						


Scenario: _090219 check tax in the BR (depend of transaction type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankReceipt"
	And I click the button named "FormCreate"
	* Filling main info
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'       |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Account"
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, TRY' |
		And I select current line in "List" table
	* Select partner
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "1 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
	* Check tax rate
		And I finish line editing in "PaymentList" table
		And "PaymentList" table became equal
			| 'Partner'   | 'Payer'             | 'Tax amount' | 'Total amount' | 'VAT' | 'Net amount' |
			| 'Ferron BP' | 'Company Ferron BP' | '152,54'     | '1 000,00'     | '18%' | '847,46'     |
	* Change transaction type and check tax rate
		And I select "Return from vendor" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table became equal
			| 'Partner'   | 'Payer'             | 'Tax amount' | 'Total amount' | 'VAT' |
			| 'Ferron BP' | 'Company Ferron BP' | ''           | '847,46'       | '0%'  |
		And I close all client application windows	


Scenario: _090220 check tax in the CE (depend of transaction type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashExpense"
	And I click the button named "FormCreate"
	* Filling main info
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'       |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Account"
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, TRY' |
		And I select current line in "List" table
	* Add expense
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "1 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
	* Check tax rate
		And I finish line editing in "PaymentList" table
		And "PaymentList" table became equal
			| 'Tax amount' | 'Total amount' | 'VAT' | 'Net amount' |
			| '152,54'     | '1 000,00'     | '18%' | '847,46'     |
	* Change transaction type and check tax rate
		And I select "Other company expense" exact value from "Transaction type" drop-down list
		And "PaymentList" table became equal
			| 'Total amount' |
			| '847,46'     |
		And I close all client application windows	


Scenario: _090221 check tax in the CR (depend of transaction type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashRevenue"
	And I click the button named "FormCreate"
	* Filling main info
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'       |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Account"
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, TRY' |
		And I select current line in "List" table
	* Add expense
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "1 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
	* Check tax rate
		And I finish line editing in "PaymentList" table
		And "PaymentList" table became equal
			| 'Tax amount' | 'Total amount' | 'VAT' | 'Net amount' |
			| '152,54'     | '1 000,00'     | '18%' | '847,46'     |
	* Change transaction type and check tax rate
		And I select "Other company revenue" exact value from "Transaction type" drop-down list
		And "PaymentList" table became equal
			| 'Total amount' |
			| '847,46'     |
		And I close all client application windows	



Scenario: _090222 check tax in the RSR(without transaction type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
	And I click the button named "FormCreate"
	* Filling in the details
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'   | 'Item key' |
			| 'Dress'  | 'L/Green'      |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'   | 'Item key' |
			| 'Dress'  | 'M/White'      |
		And I select current line in "List" table
	* Check tax rate
		And "ItemList" table contains lines
			| 'Item key' | 'Quantity' | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Net amount' | 'Total amount' | 'Price type'        | 'Item'  | 'Sales person' |
			| 'L/Green'  | '1,000'    | 'pcs'  | '83,90'      | '550,00' | '18%' | '466,10'     | '550,00'       | 'Basic Price Types' | 'Dress' | ''             |
			| 'M/White'  | '1,000'    | 'pcs'  | '79,32'      | '520,00' | '18%' | '440,68'     | '520,00'       | 'Basic Price Types' | 'Dress' | ''             |
		And I close all client application windows


Scenario: _999999 close TestClient session
	And I close TestClient session