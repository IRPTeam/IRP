#language: en
@tree
@Positive
@ProcurementDataProc


Feature: check procurement data processor

Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario:_700000 preparation (procurement data proccessor)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
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
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)	
	* Tax settings
		When filling in Tax settings for company
	When Create document InternalSupplyRequest objects (for procurement)
	When create an order for Ferron BP Basic Partner term, TRY (Dress -10 and Trousers - 5)
	* Change procurement date
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I move to "Other" tab
		And I save "CurrentDate() + 240000" in "$$$$Date$$$$" variable
		And I input "$$$$Date$$$$" variable value in "Procurement date" field
		And I move to the next attribute
		And I click "Post and close" button
		And I go to line in "List" table
			| 'Number' |
			| '2'      |
		And I select current line in "List" table
		And I move to "Other" tab
		And I save "CurrentDate() + 1200000" in "$$$$Date2$$$$" variable
		And I input "$$$$Date2$$$$" variable value in "Procurement date" field
		And I move to the next attribute
		And I click "Post and close" button
		And I go to line in "List" table
			| 'Number' |
			| '3'      |
		And I select current line in "List" table
		And I move to "Other" tab
		And I save "CurrentDate() + 1500000" in "$$$$Date3$$$$" variable
		And I input "$$$$Date3$$$$" variable value in "Procurement date" field
		And I move to the next attribute
		And I click "Post and close" button
		And I go to line in "List" table
			| 'Number' |
			| '4'      |
		And I select current line in "List" table
		And I move to "Other" tab
		And I save "CurrentDate() + 1800000" in "$$$$Date4$$$$" variable
		And I input "$$$$Date4$$$$" variable value in "Procurement date" field
		And I move to the next attribute
		And I click "Post and close" button
	When Create document PriceList objects (for procurement)
	When Create document PurchaseInvoice objects (for procurement)
	* Change PI date
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I move to "Other" tab
		And I input current date and time in "Date" field
		And I move to the next attribute
		If window with "Update item list info" header has appeared Then
			And I remove checkbox "Do you want to update filled prices?"		
			And I click "OK" button		
		And I click "Post and close" button
		And I go to line in "List" table
			| 'Number' |
			| '2'      |
		And I select current line in "List" table
		And I move to "Other" tab
		And I input current date and time in "Date" field
		And I move to the next attribute
		If window with "Update item list info" header has appeared Then
			And I remove checkbox "Do you want to update filled prices?"		
			And I click "OK" button	
		And I click "Post and close" button
		And I go to line in "List" table
			| 'Number' |
			| '3'      |
		And I select current line in "List" table
		And I move to "Other" tab
		And I input current date and time in "Date" field
		And I move to the next attribute
		If window with "Update item list info" header has appeared Then
			And I remove checkbox "Do you want to update filled prices?"		
			And I click "OK" button	
		And I click "Post and close" button
	When Create document PurchaseOrder objects (for procurement)
	* Change PO date
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I move to "Other" tab
		And I input current date and time in "Date" field
		And I move to the next attribute
		If window with "Update item list info" header has appeared Then
			And I remove checkbox "Do you want to update filled prices?"		
			And I click "OK" button	
		And I input "$$$$Date$$$$" text in "Delivery date" field
		And I click "Post and close" button
	* Post document
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I go to line in "List" table
			| 'Number' |
			| '58'      |
		And I select current line in "List" table
		And I click "Post and close" button
		And I close all client application windows

Scenario:_700001 procurement data proccessor form
	Given I open hyperlink "e1cib/app/DataProcessor.Procurement"
	Then the form attribute named "Company" became equal to ""
	Then the form attribute named "Store" became equal to ""
	Then the form attribute named "Period" became equal to ""
	Then the form attribute named "Periodicity" became equal to ""
	Then the number of "Analysis" table lines is "равно" 0
	Then the number of "Details" table lines is "равно" 0
	* Check company filter
		And I click Select button of "Company" field
		And "List" table became equal
			| 'Description'    |
			| 'Main Company'   |
			| 'Second Company' |
		Then the number of "List" table lines is "меньше или равно" "2"
		And I go to line in "List" table
			| 'Description'    |
			| 'Main Company'   |
		And I select current line in "List" table
	* Check filling in store
		And I click Select button of "Store" field
		And "List" table contains lines
			| 'Description' |
			| 'Store 01'    |
			| 'Store 02'    |
			| 'Store 03'    |
			| 'Store 04'    |
			| 'Store 07'    |
			| 'Store 08'    |
			| 'Store 05'    |
			| 'Store 06'    |
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'   |
		And I select current line in "List" table
	* Check filling in Period
		And I click Select button of "Period" field
		And I input current date in "DateBegin" field
		And I save the value of "DateBegin" field as "$$$$CurrentDate$$$$"
		And I input "$$$$Date4$$$$" text in "DateEnd" field
		And I click "Select" button
	* Check filling in periodicity
		And I select "Month" exact value from "Periodicity" drop-down list
		And I select "Day" exact value from "Periodicity" drop-down list
		And I select "Week" exact value from "Periodicity" drop-down list	
		And I click "Refresh" button
		And "Analysis" table contains lines
			| 'Item'       | 'Item key' | 'Total procurement' | 'Ordered'  | 'Shortage' |
			| 'Boots'      | '36/18SD'  | '48'            | ''         | '48'   |
			| 'Boots'      | '37/18SD'  | '30'            | ''         | '30'   |
			| 'Dress'      | 'XS/Blue'  | '70'            | '9'         | '61'   |
			| 'High shoes' | '39/19SD'  | '15'            | ''         | '15'   |
		And "Details" table contains lines
			| 'Document'                   | 'Total quantity' |
			| 'Internal supply request 1*' | '5'          |
			| 'Internal supply request 2*' | '43'         |
		And I close all client application windows
		



Scenario:_700005 analyze procurement
	Given I open hyperlink "e1cib/app/DataProcessor.Procurement"
	* Filling main attributes
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'    |
		And I select current line in "List" table
		And I click Select button of "Period" field
		And I save "CurrentDate() + 86400" in "$$$$Date7$$$$" variable
		And I input "$$$$Date7$$$$" text in "DateBegin" field
		And I input "$$$$Date2$$$$" text in "DateEnd" field
		And I click "Select" button
		And I select "Day" exact value from "Periodicity" drop-down list
		And I click "Refresh" button
	* Check filling in info tab
		And "Analysis" table contains lines
			| 'Item'       | 'Item key' | 'Unit' | 'Total procurement' | 'Ordered' | 'Shortage' | 'Expired' | 'Open balance' |
			| 'Boots'      | '36/18SD'  | 'pcs'  | '48'                | ''        | '48'       | ''        | ''             |
			| 'Boots'      | '37/18SD'  | 'pcs'  | '30'                | ''        | '30'       | ''        | ''             |
			| 'Dress'      | 'XS/Blue'  | 'pcs'  | '70'                | '9'       | '51'       | ''        | '10'           |
			| 'High shoes' | '39/19SD'  | 'pcs'  | '15'                | ''        | '15'       | ''        | ''             |
		And I go to line in "Analysis" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And Delay 5
		And "Details" table contains lines
			| 'Document'                                            | 'Total quantity' |
			| 'Internal supply request 1 dated 01.12.2020 16:06:22' | '20'          |
			| 'Internal supply request 2 dated 01.12.2020 16:07:11' | '50'         |
	* Change date and check refilling info tab
		And I click Select button of "Period" field
		And I input current date in "DateBegin" field
		And I click "Select" button
		And I click "Refresh" button
		And "Analysis" table contains lines
			| 'Item'       | 'Item key' | 'Unit' | 'Total procurement' | 'Ordered' | 'Shortage' | 'Expired' |
			| 'Boots'      | '36/18SD'  | 'pcs'  | '48'                | ''        | '48'       | ''        |
			| 'Boots'      | '37/18SD'  | 'pcs'  | '30'                | ''        | '30'       | ''        |
			| 'Dress'      | 'XS/Blue'  | 'pcs'  | '70'                | '9'       | '61'       | ''        |
			| 'High shoes' | '39/19SD'  | 'pcs'  | '15'                | ''        | '15'       | ''        |
		And I click Select button of "Period" field
		And I input "$$$$Date7$$$$" text in "DateBegin" field
		And I click "Select" button
		And I click "Refresh" button
		And "Analysis" table contains lines
			| 'Item'       | 'Item key' | 'Unit' | 'Total procurement' | 'Ordered' | 'Shortage' | 'Expired' | 'Open balance' |
			| 'Boots'      | '36/18SD'  | 'pcs'  | '48'                | ''        | '48'       | ''        | ''             |
			| 'Boots'      | '37/18SD'  | 'pcs'  | '30'                | ''        | '30'       | ''        | ''             |
			| 'Dress'      | 'XS/Blue'  | 'pcs'  | '70'                | '9'       | '51'       | ''        | '10'           |
			| 'High shoes' | '39/19SD'  | 'pcs'  | '15'                | ''        | '15'       | ''        | ''             |
	* Analyze procurement
		And I go to line in "Analysis" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I click "Analyze procurement" button		
		And "TableOfInternalSupplyRequest" table contains lines
			| 'Use' | 'Internal supply request'                             | 'Quantity' |
			| 'Yes' | 'Internal supply request 1 dated 01.12.2020 16:06:22' | '20'   |
			| 'Yes' | 'Internal supply request 2 dated 01.12.2020 16:07:11' | '50'   |
		Then the number of "TableOfInternalSupplyRequest" table lines is "равно" "2"
		* Select 1 ISR
			And I go to line in "TableOfInternalSupplyRequest" table
				| 'Internal supply request'                             |
				| 'Internal supply request 2 dated 01.12.2020 16:07:11' |
			And I change "Use" checkbox in "TableOfInternalSupplyRequest" table
			And I finish line editing in "TableOfInternalSupplyRequest" table
			And I click "Ok" button
			And "TableOfInternalSupplyRequest" table contains lines
				| 'Internal supply request'                             | 'Procurement date' | 'Quantity' | 'Transfer' | 'Purchase' |
				| 'Internal supply request 1 dated 01.12.2020 16:06:22' | '*'     | '20'   | ''         | ''         |
			Then the number of "TableOfInternalSupplyRequest" table lines is "равно" "1"
			And "TableOfBalance" table contains lines
				| 'Store'    | 'Balance' | 'Quantity' |
				| 'Store 08' | '10'  | ''         |
			Then the number of "TableOfInternalSupplyRequest" table lines is "равно" "1"
			And "TableOfPurchase" table contains lines
				| 'Partner'          | 'Agreement'                                  | 'Price type'              | 'Price'  | 'Date of relevance' | 'Delivery date'       | 'Quantity' |
				| 'Ferron BP'        | 'Vendor Ferron, TRY'                         | 'Vendor price, TRY'       | '100,00' | '07.12.2020'        | '$$$$CurrentDate$$$$' | ''         |
				| 'Maxim'            | 'Partner term Maxim'                         | 'Vendor price, TRY'       | '100,00' | '07.12.2020'        | '$$$$CurrentDate$$$$' | ''         |
				| 'Veritas'          | 'Posting by Standard Partner term (Veritas)' | 'Vendor price, TRY'       | '100,00' | '07.12.2020'        | '$$$$CurrentDate$$$$' | ''         |
				| 'Partner Kalipso'  | 'Partner Kalipso Vendor'                     | 'Basic Price without VAT' | '440,68' | '01.11.2018'        | '$$$$CurrentDate$$$$' | ''         |
				| 'DFC'              | 'Partner term vendor DFC'                    | 'Basic Price Types'       | '520,00' | '01.11.2018'        | '$$$$CurrentDate$$$$' | ''         |
				| 'Partner Kalipso'  | 'Partner term vendor Partner Kalipso'        | 'Basic Price Types'       | '520,00' | '01.11.2018'        | '$$$$CurrentDate$$$$' | ''         |
				| 'DFC'              | 'DFC Vendor by Partner terms'                | 'Vendor price, TRY'       | '100,00' | '07.12.2020'        | '$$$$CurrentDate$$$$' | ''         |
				| 'Partner Ferron 1' | 'Vendor Ferron 1'                            | 'Vendor price, TRY'       | '100,00' | '07.12.2020'        | '$$$$CurrentDate$$$$' | ''         |
				| 'Partner Ferron 1' | 'Vendor Ferron Discount'                     | 'Vendor price, TRY'       | '100,00' | '07.12.2020'        | '$$$$CurrentDate$$$$' | ''         |
				| 'Partner Ferron 2' | 'Vendor Ferron Partner 2'                    | 'Vendor price, TRY'       | '100,00' | '07.12.2020'        | '$$$$CurrentDate$$$$' | ''         |
			And I close current window
		* Select 2 ISR
			And I go to line in "Analysis" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			And I click "Analyze procurement" button
			And I click "Ok" button
			And "TableOfInternalSupplyRequest" table contains lines
				| 'Internal supply request'                             | 'Procurement date' | 'Quantity' | 'Transfer' | 'Purchase' |
				| 'Internal supply request 1 dated 01.12.2020 16:06:22' | '*'     | '20'   | ''         | ''         |
				| 'Internal supply request 2 dated 01.12.2020 16:07:11' | '*'      | '50'   | ''         | ''         |
			And "TableOfBalance" table became equal
				| 'Store'    | 'Balance' | 'Quantity' |
				| 'Store 08' | '10'  | ''         |
			And "TableOfPurchase" table contains lines
				| 'Partner'          | 'Agreement'                                  | 'Price type'              | 'Price'  | 'Date of relevance' | 'Delivery date'       | 'Quantity' |
				| 'Ferron BP'        | 'Vendor Ferron, TRY'                         | 'Vendor price, TRY'       | '100,00' | '07.12.2020'        | '$$$$CurrentDate$$$$' | ''         |
				| 'Maxim'            | 'Partner term Maxim'                         | 'Vendor price, TRY'       | '100,00' | '07.12.2020'        | '$$$$CurrentDate$$$$' | ''         |
				| 'Veritas'          | 'Posting by Standard Partner term (Veritas)' | 'Vendor price, TRY'       | '100,00' | '07.12.2020'        | '$$$$CurrentDate$$$$' | ''         |
				| 'Partner Kalipso'  | 'Partner Kalipso Vendor'                     | 'Basic Price without VAT' | '440,68' | '01.11.2018'        | '$$$$CurrentDate$$$$' | ''         |
				| 'DFC'              | 'Partner term vendor DFC'                    | 'Basic Price Types'       | '520,00' | '01.11.2018'        | '$$$$CurrentDate$$$$' | ''         |
				| 'Partner Kalipso'  | 'Partner term vendor Partner Kalipso'        | 'Basic Price Types'       | '520,00' | '01.11.2018'        | '$$$$CurrentDate$$$$' | ''         |
				| 'DFC'              | 'DFC Vendor by Partner terms'                | 'Vendor price, TRY'       | '100,00' | '07.12.2020'        | '$$$$CurrentDate$$$$' | ''         |
				| 'Partner Ferron 1' | 'Vendor Ferron 1'                            | 'Vendor price, TRY'       | '100,00' | '07.12.2020'        | '$$$$CurrentDate$$$$' | ''         |
				| 'Partner Ferron 1' | 'Vendor Ferron Discount'                     | 'Vendor price, TRY'       | '100,00' | '07.12.2020'        | '$$$$CurrentDate$$$$' | ''         |
				| 'Partner Ferron 2' | 'Vendor Ferron Partner 2'                    | 'Vendor price, TRY'       | '100,00' | '07.12.2020'        | '$$$$CurrentDate$$$$' | ''         |
		* Select procurement method
			And I activate field named "TableOfBalanceQuantity" in "TableOfBalance" table
			And I select current line in "TableOfBalance" table
			And I input "5" text in the field named "TableOfBalanceQuantity" of "TableOfBalance" table
			And I finish line editing in "TableOfBalance" table
			And "TableOfInternalSupplyRequest" table contains lines
				| 'Internal supply request'                             | 'Procurement date' | 'Quantity' | 'Transfer' | 'Purchase' |
				| 'Internal supply request 1 dated 01.12.2020 16:06:22' | '*'     | '20'   | '5'    | ''         |
				| 'Internal supply request 2 dated 01.12.2020 16:07:11' | '*'    | '50'   | ''         | ''         |
			And I activate field named "TableOfBalanceQuantity" in "TableOfBalance" table
			And I select current line in "TableOfBalance" table
			And I input "0" text in the field named "TableOfBalanceQuantity" of "TableOfBalance" table
			And I finish line editing in "TableOfBalance" table
			And "TableOfInternalSupplyRequest" table contains lines
				| 'Internal supply request'                             | 'Procurement date' | 'Quantity' | 'Transfer' | 'Purchase' |
				| 'Internal supply request 1 dated 01.12.2020 16:06:22' | '*'     | '20'   | ''    | ''         |
				| 'Internal supply request 2 dated 01.12.2020 16:07:11' | '*'    | '50'   | ''         | ''         |			
			And I activate field named "TableOfBalanceQuantity" in "TableOfBalance" table
			And I select current line in "TableOfBalance" table
			And I input "7" text in the field named "TableOfBalanceQuantity" of "TableOfBalance" table
			And I finish line editing in "TableOfBalance" table
			And I go to line in "TableOfPurchase" table
				| 'Agreement'              | 'Partner'         | 'Price'  | 'Price type'              |
				| 'Partner Kalipso Vendor' | 'Partner Kalipso' | '440,68' | 'Basic Price without VAT' |
			And I go to line in "TableOfPurchase" table
				| 'Agreement'                   | 'Partner' | 'Price'  | 'Price type'        |
				| 'DFC Vendor by Partner terms' | 'DFC'     | '100,00' | 'Vendor price, TRY' |
			And I input "12" text in the field named "TableOfPurchaseQuantity" of "TableOfPurchase" table
			And I finish line editing in "TableOfPurchase" table
			And I go to line in "TableOfPurchase" table
				| 'Agreement'       | 'Partner'          | 'Price'  | 'Price type'        |
				| 'Vendor Ferron 1' | 'Partner Ferron 1' | '100,00' | 'Vendor price, TRY' |
			And I go to line in "TableOfPurchase" table
				| 'Agreement'          | 'Partner' | 'Price'  | 'Price type'        |
				| 'Partner term Maxim' | 'Maxim'   | '100,00' | 'Vendor price, TRY' |
			And I input "40" text in the field named "TableOfPurchaseQuantity" of "TableOfPurchase" table
			And I finish line editing in "TableOfPurchase" table
			And I go to line in "TableOfPurchase" table
				| 'Agreement'              | 'Partner'         | 'Price'  | 'Price type'              |
				| 'Partner Kalipso Vendor' | 'Partner Kalipso' | '440,68' | 'Basic Price without VAT' |
			And "TableOfInternalSupplyRequest" table contains lines
				| 'Internal supply request'                             | 'Quantity' | 'Transfer' | 'Purchase' |
				| 'Internal supply request 1 dated 01.12.2020 16:06:22' | '20'   | '7'    | '13'   |
				| 'Internal supply request 2 dated 01.12.2020 16:07:11' | '50'   | ''         | '39'   |
			And I go to line in "TableOfPurchase" table
				| 'Agreement'                                  | 'Partner' |
				| 'Posting by Standard Partner term (Veritas)' | 'Veritas' |
			And I input "12" text in the field named "TableOfPurchaseQuantity" of "TableOfPurchase" table
			And I finish line editing in "TableOfPurchase" table
			And "TableOfInternalSupplyRequest" table contains lines
				| 'Internal supply request'                             | 'Quantity' | 'Transfer' | 'Purchase' |
				| 'Internal supply request 1 dated 01.12.2020 16:06:22' | '20'   | '7'    | '13'   |
				| 'Internal supply request 2 dated 01.12.2020 16:07:11' | '50'   | ''         | '50'   |
			And I click "Ok" button
	* Check data save
		And I go to line in "Analysis" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I click "Analyze procurement" button
		And I click "Ok" button
		And "TableOfInternalSupplyRequest" table contains lines
			| 'Internal supply request'                             | 'Quantity' | 'Transfer' | 'Purchase' |
			| 'Internal supply request 1 dated 01.12.2020 16:06:22' | '20'   | '7'    | '13'   |
			| 'Internal supply request 2 dated 01.12.2020 16:07:11' | '50'   | ''         | '50'   |
		And I click "Ok" button
	* Analyze one more item
		And I go to line in "Analysis" table
			| 'Item'       | 'Item key' |
			| 'High shoes' | '39/19SD'  |
		And I activate field named "AnalysisUnit" in "Analysis" table
		And I click "Analyze procurement" button
		And "TableOfInternalSupplyRequest" table contains lines
			| 'Use' | 'Internal supply request'                             | 'Quantity' |
			| 'Yes' | 'Internal supply request 2 dated 01.12.2020 16:07:11' | '15'   |
		And I click "Ok" button
		Then the number of "TableOfBalance" table lines is "равно" 0
		And "TableOfPurchase" table contains lines
			| 'Partner'         | 'Agreement'                           | 'Price type'              | 'Price'  | 'Date of relevance' | 'Delivery date' | 'Quantity' |
			| 'Partner Kalipso' | 'Partner Kalipso Vendor'              | 'Basic Price without VAT' | '462,96' | '01.11.2018'        | '*'             | ''         |
			| 'DFC'             | 'Partner term vendor DFC'             | 'Basic Price Types'       | '500,00' | '01.11.2018'        | '*'             | ''         |
			| 'Partner Kalipso' | 'Partner term vendor Partner Kalipso' | 'Basic Price Types'       | '500,00' | '01.11.2018'        | '*'             | ''         |
		And I go to line in "TableOfPurchase" table
			| 'Agreement'              | 'Partner'         |
			| 'Partner Kalipso Vendor' | 'Partner Kalipso' |
		And I input "15" text in the field named "TableOfPurchaseQuantity" of "TableOfPurchase" table
		And I finish line editing in "TableOfPurchase" table
		And I click "Ok" button
		And I go to line in "Analysis" table
			| 'Item'       | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I activate field named "AnalysisUnit" in "Analysis" table
		And I click "Analyze procurement" button
		And I click "Ok" button
		And I go to line in "TableOfPurchase" table
			| 'Agreement'              | 'Partner'         |
			| 'Partner Kalipso Vendor' | 'Partner Kalipso' |
		And I input "15" text in the field named "TableOfPurchaseQuantity" of "TableOfPurchase" table
		And I finish line editing in "TableOfPurchase" table
		And I click "Ok" button
	* Check results
		And I move to "Results" tab
		Then "Procurement" window is opened
		And I go to line in "ResultsItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Dress' | 'XS/Blue'  | 'pcs'  |	
		And "ResultsTableOfBalance" table contains lines
			| 'Store'    | 'Quantity' |
			| 'Store 08' | '7'    |
		And "ResultsTableOfPurchase" table contains lines
			| 'Partner' | 'Agreement'                                  | 'Price type'        | 'Price'  | 'Date of relevance' | 'Quantity' |
			| 'Maxim'   | 'Partner term Maxim'                         | 'Vendor price, TRY' | '100,00' | '07.12.2020'        | '40'   |
			| 'Veritas' | 'Posting by Standard Partner term (Veritas)' | 'Vendor price, TRY' | '100,00' | '07.12.2020'        | '12'   |
			| 'DFC'     | 'DFC Vendor by Partner terms'                | 'Vendor price, TRY' | '100,00' | '07.12.2020'        | '12'   |
		And I go to line in "ResultsItemList" table
			| 'Item'       | 'Item key' | 'Unit' |
			| 'High shoes' | '39/19SD'  | 'pcs'  |
		And "ResultsTableOfInternalSupplyRequest" table became equal
			| 'Internal supply request'                             | 'Procurement date' | 'Quantity' | 'Transfer' | 'Purchase' |
			| 'Internal supply request 2 dated 01.12.2020 16:07:11' | '*'                | '15'   | ''         | '15'   |
	* Delete results
		And I go to line in "ResultsItemList" table
			| 'Item'       | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I click "ResultsItemListDeleteResults" button		
		And "ResultsItemList" table does not contain lines
			| 'Item'       | 'Item key' |
			| 'Boots' | '37/18SD'  |
	* Edit results
		And I go to line in "ResultsItemList" table
			| 'Item'       | 'Item key' |
			| 'High shoes' | '39/19SD'  |
		And I click "ResultsItemListChangeResults" button
		And I go to line in "TableOfPurchase" table
			| 'Agreement'               | 'Date of relevance' | 'Partner' | 'Price'  | 'Price type'        |
			| 'Partner term vendor DFC' | '01.11.2018'        | 'DFC'     | '500,00' | 'Basic Price Types' |
		And I activate field named "TableOfPurchaseQuantity" in "TableOfPurchase" table
		And I select current line in "TableOfPurchase" table
		And I input "10" text in the field named "TableOfPurchaseQuantity" of "TableOfPurchase" table
		And I finish line editing in "TableOfPurchase" table
		And I go to line in "TableOfPurchase" table
			| 'Agreement'                           | 'Partner'         | 'Price'  | 'Price type'        |
			| 'Partner term vendor Partner Kalipso' | 'Partner Kalipso' | '500,00' | 'Basic Price Types' |
		And I click "Ok" button
	* Create documents
		And I click "Create documents" button
		And Delay 20
		And "CreatedInventoryTransferOrders" table contains lines
			| 'Document'                  | 'Status' | 'Store sender' |
			| 'Inventory transfer order*' | 'Wait'   | 'Store 08'     |
		And "CreatedPurchaseOrders" table contains lines
			| 'Document'         | 'Partner'         | 'Status' |
			| 'Purchase order *' | 'Maxim'           | 'Wait'   |
			| 'Purchase order *' | 'Veritas'         | 'Wait'   |
			| 'Purchase order *' | 'DFC'             | 'Wait'   |
			| 'Purchase order *' | 'Partner Kalipso' | 'Wait'   |
			| 'Purchase order *' | 'DFC'             | 'Wait'   |
		And I close all client application windows
		
	

		
				

		
				

		
				
		
				
				
		
				
		
				


		
				
				
			
						
						


						
			
						
				
		
				 

		

		
				
		
				

		
				
		
				

				
		
				
		
				
		
