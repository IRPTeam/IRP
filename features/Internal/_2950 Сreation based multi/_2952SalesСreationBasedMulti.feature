#language: en
@tree
@Positive
@CreationBasedMulti

Feature: creation mechanism based on for sales documents

# Sales order - Sales invoice - Shipment confirmation - Bank receipt/Cash receipt

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


# First Sales invoice then Shipment confirmation

Scenario: _0295200 preparation (creation mechanism based on for sales documents)
	When set True value to the constant
	* Load info
		When Create information register Barcodes records
		When Create catalog CancelReturnReasons objects
		When Create catalog Companies objects (own Second company)
		When Create catalog Countries objects
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
		When Create catalog Partners objects (Ferron BP)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create information register Taxes records (VAT)
		Given I open hyperlink "e1cib/app/DataProcessor.SystemSettings"
		And I set checkbox "Number editing available"
		And I close "System settings" window



Scenario: _02952001 check preparation
	When check preparation


Scenario: _090401 create Sales invoice for several Sales order with different legal names
# should be created 2 Sales invoice
* Create test Sales order 324
	When create the first test SO for a test on the creation mechanism based on
	* Change the document number to 324
		And I move to "Other" tab
		And I expand "More" group
		And I input "324" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "324" text in "Number" field
	And I click the button named "FormPostAndClose"
* Create Sales order 325
	When create the second test SO for a test on the creation mechanism based on
	* Change the document number to 325
		And I move to "Other" tab
		And I expand "More" group
		And I input "325" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "325" text in "Number" field
	And I click the button named "FormPostAndClose"
* Create Sales invoice based on Sales order 324 and 325 (should be created 2)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I go to line in "List" table
			| Number    |
			| 324       |
	And I move one line down in "List" table and select line
	And I click the button named "FormDocumentSalesInvoiceGenerate"
	And I click "Ok" button
	Then the form attribute named "Partner" became equal to "Ferron BP"
	Then the form attribute named "LegalName" became equal to "Second Company Ferron BP"
	Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
	Then the form attribute named "Company" became equal to "Main Company"
	Then the form attribute named "Store" became equal to "Store 02"
	And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Store'      | 'Unit'   | 'Quantity'   | 'Sales order'         |
			| 'Dress'   | 'M/White'    | 'Store 02'   | 'pcs'    | '10,000'     | 'Sales order 325*'    |
	Then the form attribute named "PriceIncludeTax" became equal to "Yes"
	* Change the document number to 325
		And I expand "More" group
		And I input "325" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "325" text in "Number" field
	And I click the button named "FormPostAndClose"
	When I click command interface button "Sales invoice (create)"
	And Delay 2
	Then the form attribute named "Partner" became equal to "Ferron BP"
	Then the form attribute named "LegalName" became equal to "Company Ferron BP"
	Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
	Then the form attribute named "Comment" became equal to "Click to enter description"
	Then the form attribute named "Company" became equal to "Main Company"
	Then the form attribute named "Store" became equal to "Store 02"
	And Delay 5
	And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Store'      | 'Sales order'        | 'Unit'   | 'Quantity'    |
			| 'Dress'      | 'M/White'     | 'Store 02'   | 'Sales order 324*'   | 'pcs'    | '20,000'      |
			| 'Dress'      | 'L/Green'     | 'Store 02'   | 'Sales order 324*'   | 'pcs'    | '20,000'      |
			| 'Trousers'   | '36/Yellow'   | 'Store 02'   | 'Sales order 324*'   | 'pcs'    | '30,000'      |
	* Change the document number to 324
		And I expand "More" group
		And I input "324" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "324" text in "Number" field
	And I click the button named "FormPostAndClose"
And I close all client application windows

Scenario: _090402 create Sales invoice for several Sales order with the same partner, legal name, partner term, currency and store
# Should be created Sales invoice
* Create test Sales order 326
	When create the first test SO for a test on the creation mechanism based on
	* Change the document number to 326
		And I move to "Other" tab
		And I expand "More" group
		And I input "326" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "326" text in "Number" field
	And I click Select button of "Legal name" field
	And I go to line in "List" table
			| Description          |
			| Company Ferron BP    |
	And I select current line in "List" table
	And I click the button named "FormPostAndClose"
* Create test Sales order 327
	When create the second test SO for a test on the creation mechanism based on
	* Change the document number to 327
		And I move to "Other" tab
		And I expand "More" group
		And I input "327" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "327" text in "Number" field
	And I click Select button of "Legal name" field
	And I go to line in "List" table
			| Description          |
			| Company Ferron BP    |
	And I select current line in "List" table
	And I click the button named "FormPostAndClose"
* Create based on Sales order 326 and 327 Sales invoice (should be created 1)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I go to line in "List" table
			| Number    |
			| 326       |
	And I move one line down in "List" table and select line
	And I click the button named "FormDocumentSalesInvoiceGenerate"
	And I click "Ok" button
	Then the form attribute named "Partner" became equal to "Ferron BP"
	Then the form attribute named "LegalName" became equal to "Company Ferron BP"
	Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
	Then the form attribute named "Company" became equal to "Main Company"
	Then the form attribute named "Store" became equal to "Store 02"
	And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Store'      | 'Sales order'        | 'Unit'   | 'Quantity'    |
			| 'Dress'      | 'M/White'     | 'Store 02'   | 'Sales order 327*'   | 'pcs'    | '10,000'      |
			| 'Dress'      | 'M/White'     | 'Store 02'   | 'Sales order 326*'   | 'pcs'    | '20,000'      |
			| 'Dress'      | 'L/Green'     | 'Store 02'   | 'Sales order 326*'   | 'pcs'    | '20,000'      |
			| 'Trousers'   | '36/Yellow'   | 'Store 02'   | 'Sales order 326*'   | 'pcs'    | '30,000'      |
	* Change the document number to 327
		And I expand "More" group
		And I input "327" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "327" text in "Number" field
	And I click the button named "FormPostAndClose"
	And I close all client application windows
	
Scenario: _090403 create Sales invoice for several Sales order with different partners of the same legal name (partner terms are the same)
# should be created 2 Sales invoice
* Create first test SO 328
	When create the first test SO for a test on the creation mechanism based on
	* Change the document number to 328
		And I move to "Other" tab
		And I expand "More" group
		And I input "328" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "328" text in "Number" field
	* Filling in customer info
		And I click Select button of "Partner" field
		And I click "List" button		
		And I go to line in "List" table
				| Description          |
				| Partner Ferron 1     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| Description                  |
				| Basic Partner terms, TRY     |
		And I select current line in "List" table
		And I click "OK" button
		And I click Select button of "Store" field
		And I go to line in "List" table
				| Description     |
				| Store 02        |
		And I select current line in "List" table
		And I click "OK" button
	And I click the button named "FormPostAndClose"
* Create second test SO 329
	When create the second test SO for a test on the creation mechanism based on
	* Change the document number to 329
		And I move to "Other" tab
		And I expand "More" group
		And I input "329" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "329" text in "Number" field
	* Filling in customer info
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| Description          |
				| Partner Ferron 2     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| Description                  |
				| Basic Partner terms, TRY     |
		And I select current line in "List" table
		And I click "OK" button
		And I click Select button of "Store" field
		And I go to line in "List" table
				| Description     |
				| Store 02        |
		And I select current line in "List" table
		And I click "OK" button
	And I click the button named "FormPostAndClose"
* Create based on Sales order 328 and 329 Sales invoice (should be created 2)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I go to line in "List" table
			| Number    |
			| 328       |
	And I move one line down in "List" table and select line
	And I click the button named "FormDocumentSalesInvoiceGenerate"
	And I click "Ok" button
	Then the form attribute named "Partner" became equal to "Partner Ferron 2"
	Then the form attribute named "LegalName" became equal to "Company Ferron BP"
	Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
	Then the form attribute named "Company" became equal to "Main Company"
	Then the form attribute named "Store" became equal to "Store 02"
	And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Store'      | 'Unit'   | 'Quantity'   | 'Sales order'         |
			| 'Dress'   | 'M/White'    | 'Store 02'   | 'pcs'    | '10,000'     | 'Sales order 329*'    |
	Then the form attribute named "PriceIncludeTax" became equal to "Yes"
	* Change the document number to 329
		And I expand "More" group
		And I input "329" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "329" text in "Number" field
	And I click the button named "FormPostAndClose"
	When I click command interface button "Sales invoice (create)"
	And Delay 2
	Then the form attribute named "Partner" became equal to "Partner Ferron 1"
	Then the form attribute named "LegalName" became equal to "Company Ferron BP"
	Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
	Then the form attribute named "Comment" became equal to "Click to enter description"
	Then the form attribute named "Company" became equal to "Main Company"
	Then the form attribute named "Store" became equal to "Store 02"
	And Delay 5
	And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Store'      | 'Sales order'        | 'Unit'   | 'Quantity'    |
			| 'Dress'      | 'M/White'     | 'Store 02'   | 'Sales order 328*'   | 'pcs'    | '20,000'      |
			| 'Dress'      | 'L/Green'     | 'Store 02'   | 'Sales order 328*'   | 'pcs'    | '20,000'      |
			| 'Trousers'   | '36/Yellow'   | 'Store 02'   | 'Sales order 328*'   | 'pcs'    | '30,000'      |
	* Change the document number to 329
		And I expand "More" group
		And I input "328" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "328" text in "Number" field
	And I click the button named "FormPostAndClose"
And I close all client application windows


Scenario: _090404 create Sales invoice for several Sales order with different partner terms (price with VAT and price without VAT)
# should be created 2 Sales invoice
* Create first test SO 330
	When create the first test SO for a test on the creation mechanism based on
	* Change the document number to 330
		And I move to "Other" tab
		And I expand "More" group
		And I input "330" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "330" text in "Number" field
	* Filling in customer info
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| Description          |
				| Partner Ferron 1     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| Description                  |
				| Basic Partner terms, TRY     |
		And I select current line in "List" table
		And I click "OK" button
		And I click Select button of "Store" field
		And I go to line in "List" table
				| Description     |
				| Store 02        |
		And I select current line in "List" table
		And I click "OK" button
	And I click the button named "FormPostAndClose"
* Create second test SO 331 Partner Ferron 1 and select partner term Vendor Ferron Discount
	When create the second test SO for a test on the creation mechanism based on
	* Change the document number to 331
		And I move to "Other" tab
		And I expand "More" group
		And I input "331" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "331" text in "Number" field
	* Filling in customer info
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| Description          |
				| Partner Ferron 1     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| Description                          |
				| Basic Partner terms, without VAT     |
		And I select current line in "List" table
		And I click "OK" button
		And I click Select button of "Store" field
		And I go to line in "List" table
				| Description     |
				| Store 02        |
		And I select current line in "List" table
	And I click the button named "FormPostAndClose"
* Create based on Sales order 330 and 331 Sales invoice (should be created 2)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I go to line in "List" table
			| Number    |
			| 330       |
	And I move one line down in "List" table and select line
	And I click the button named "FormDocumentSalesInvoiceGenerate"
	And I click "Ok" button
	Then the form attribute named "Partner" became equal to "Partner Ferron 1"
	Then the form attribute named "LegalName" became equal to "Company Ferron BP"
	Then the form attribute named "Agreement" became equal to "Basic Partner terms, without VAT"
	Then the form attribute named "Company" became equal to "Main Company"
	Then the form attribute named "Store" became equal to "Store 02"
	And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'   | 'Store'      | 'Delivery date'   | 'Sales order'         |
			| 'Dress'   | 'M/White'    | '10,000'     | 'pcs'    | 'Store 02'   | '*'               | 'Sales order 331*'    |
	Then the form attribute named "PriceIncludeTax" became equal to "No"
	* Change the document number to 331
		And I expand "More" group
		And I input "331" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "331" text in "Number" field
	And I click the button named "FormPostAndClose"
	When I click command interface button "Sales invoice (create)"
	And Delay 2
	Then the form attribute named "Partner" became equal to "Partner Ferron 1"
	Then the form attribute named "LegalName" became equal to "Company Ferron BP"
	Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
	Then the form attribute named "Comment" became equal to "Click to enter description"
	Then the form attribute named "Company" became equal to "Main Company"
	Then the form attribute named "Store" became equal to "Store 02"
	And Delay 5
	And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Quantity'   | 'Unit'   | 'Store'      | 'Delivery date'   | 'Sales order'         |
			| 'Trousers'   | '36/Yellow'   | '30,000'     | 'pcs'    | 'Store 02'   | '*'               | 'Sales order 330*'    |
			| 'Dress'      | 'M/White'     | '20,000'     | 'pcs'    | 'Store 02'   | '*'               | 'Sales order 330*'    |
			| 'Dress'      | 'L/Green'     | '20,000'     | 'pcs'    | 'Store 02'   | '*'               | 'Sales order 330*'    |
	* Change the document number to 330
		And I expand "More" group
		And I input "330" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "330" text in "Number" field
	And I click the button named "FormPostAndClose"
And I close all client application windows


Scenario: _090405 create Sales invoice for several Sales order with different stores (one is created)
# Create one SI
* Create first test PO 334
	When create the first test SO for a test on the creation mechanism based on
	* Change the document number to 334
		And I move to "Other" tab
		And I expand "More" group
		And I input "334" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "334" text in "Number" field
	* Filling in customer info
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| Description          |
				| Partner Ferron 1     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| Description                  |
				| Basic Partner terms, TRY     |
		And I select current line in "List" table
		And I click "OK" button
		And I click Select button of "Store" field
		And I go to line in "List" table
				| Description     |
				| Store 02        |
		And I select current line in "List" table
		And I click "OK" button
	And I click the button named "FormPostAndClose"
* Create second test SO 335
	When create the second test SO for a test on the creation mechanism based on
	* Change the document number to 335
		And I move to "Other" tab
		And I expand "More" group
		And I input "335" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "335" text in "Number" field
	* Filling in customer info
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| Description          |
				| Partner Ferron 1     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| Description                  |
				| Basic Partner terms, TRY     |
		And I select current line in "List" table
		And I click "OK" button
		And I click Select button of "Store" field
		And I go to line in "List" table
				| Description     |
				| Store 03        |
		And I select current line in "List" table
		And I click "OK" button
	And I click the button named "FormPostAndClose"
* Create based on Sales order 335 and 334 Sales invoice (should be created 1)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I go to line in "List" table
			| Number    |
			| 334       |
	And I move one line down in "List" table and select line
	And I click the button named "FormDocumentSalesInvoiceGenerate"
	And I click "Ok" button
	Then the form attribute named "Partner" became equal to "Partner Ferron 1"
	Then the form attribute named "LegalName" became equal to "Company Ferron BP"
	Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
	Then the form attribute named "Company" became equal to "Main Company"
	And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Quantity'   | 'Unit'   | 'Store'      | 'Delivery date'   | 'Sales order'         |
			| 'Dress'      | 'L/Green'     | '20,000'     | 'pcs'    | 'Store 02'   | '*'               | 'Sales order 334*'    |
			| 'Trousers'   | '36/Yellow'   | '30,000'     | 'pcs'    | 'Store 02'   | '*'               | 'Sales order 334*'    |
			| 'Dress'      | 'M/White'     | '20,000'     | 'pcs'    | 'Store 02'   | '*'               | 'Sales order 334*'    |
			| 'Dress'      | 'M/White'     | '10,000'     | 'pcs'    | 'Store 03'   | '*'               | 'Sales order 335*'    |
	* Change the document number to 335
		And I expand "More" group
		And I input "335" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "335" text in "Number" field
	And I click the button named "FormPostAndClose"
	And I close all client application windows

	
Scenario: _090406 create Sales invoice for several Sales order with different own companies
* Create first test SO 336
	When create the first test SO for a test on the creation mechanism based on
	* Change the document number to 336
		And I move to "Other" tab
		And I expand "More" group
		And I input "336" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "336" text in "Number" field
	* Filling in customer info
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| Description          |
				| Partner Ferron 1     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| Description                  |
				| Basic Partner terms, TRY     |
		And I select current line in "List" table
		And I click "OK" button
		And I click Select button of "Store" field
		And I go to line in "List" table
				| Description     |
				| Store 02        |
		And I select current line in "List" table
		And I click "OK" button
		And I click Select button of "Company" field
		Then "Companies" window is opened
		And I go to line in "List" table
				| Description        |
				| Second Company     |
		And I select current line in "List" table
	And I click the button named "FormPostAndClose"
* Create second test SO 337
	When create the second test SO for a test on the creation mechanism based on
	* Change the document number to 337
		And I move to "Other" tab
		And I expand "More" group
		And I input "337" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "337" text in "Number" field
	* Filling in customer info
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| Description          |
				| Partner Ferron 1     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| Description                  |
				| Basic Partner terms, TRY     |
		And I select current line in "List" table
		And I click "OK" button
		And I click Select button of "Store" field
		And I go to line in "List" table
				| Description     |
				| Store 02        |
		And I select current line in "List" table
		And I click "OK" button
	And I click the button named "FormPostAndClose"
* Create based on Sales order 336 and 337 Sales invoice (should be created 2)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I go to line in "List" table
			| Number    |
			| 336       |
	And I move one line down in "List" table and select line
	And I click the button named "FormDocumentSalesInvoiceGenerate"
	And I click "Ok" button
	Then the form attribute named "Partner" became equal to "Partner Ferron 1"
	Then the form attribute named "LegalName" became equal to "Company Ferron BP"
	Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
	Then the form attribute named "Company" became equal to "Main Company"
	Then the form attribute named "Store" became equal to "Store 02"
	And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'   | 'Store'      | 'Sales order'         |
			| 'Dress'   | 'M/White'    | '10,000'     | 'pcs'    | 'Store 02'   | 'Sales order 337*'    |
	* Change the document number to 337
		And I move to "Other" tab
		And I expand "More" group
		And I input "337" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "337" text in "Number" field
	And I click the button named "FormPostAndClose"
	When I click command interface button "Sales invoice (create)"
	And Delay 2
	Then the form attribute named "Partner" became equal to "Partner Ferron 1"
	Then the form attribute named "LegalName" became equal to "Company Ferron BP"
	Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
	Then the form attribute named "Comment" became equal to "Click to enter description"
	Then the form attribute named "Company" became equal to "Second Company"
	Then the form attribute named "Store" became equal to "Store 02"
	And Delay 5
	And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Quantity'   | 'Unit'   | 'Store'      | 'Sales order'         |
			| 'Dress'      | 'M/White'     | '20,000'     | 'pcs'    | 'Store 02'   | 'Sales order 336*'    |
			| 'Dress'      | 'L/Green'     | '20,000'     | 'pcs'    | 'Store 02'   | 'Sales order 336*'    |
			| 'Trousers'   | '36/Yellow'   | '30,000'     | 'pcs'    | 'Store 02'   | 'Sales order 336*'    |
	* Change the document number to 136
		And I move to "Other" tab
		And I expand "More" group
		And I input "336" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "336" text in "Number" field
	And I click the button named "FormPostAndClose"
And I close all client application windows

Scenario: _090407 create Shipment confirmation for several Sales order with different procurement method (goods and services)
* Create first test SO №800
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	* Filling in details
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
				| 'Description'           |
				| 'Company Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
		And I select current line in "List" table
	* Filling in the tabular part
		* Add services
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
					| 'Description'      |
					| 'Service'          |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
					| 'Item'        | 'Item key'      |
					| 'Service'     | 'Rent'          |
			And I select current line in "List" table
			And I move to the next attribute
			And I activate "Price" field in "ItemList" table
			And I input "200,00" text in "Price" field of "ItemList" table
		* Add a product that will not be shipped
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
					| 'Description'      |
					| 'Trousers'         |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
					| 'Item'         | 'Item key'       |
					| 'Trousers'     | '38/Yellow'      |
			And I select current line in "List" table
			And I activate "Procurement method" field in "ItemList" table
			And I select "No reserve" exact value from "Procurement method" drop-down list in "ItemList" table
			And I change "Cancel" checkbox in "ItemList" table	
			And I activate "Cancel reason" field in "ItemList" table
			And I click choice button of "Cancel reason" attribute in "ItemList" table	
			And I go to line in "List" table
					| 'Description'        |
					| 'not available'      |
			And I select current line in "List" table		
			And I move to the next attribute
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Add items with procurement method purchase
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
					| 'Description'      |
					| 'Shirt'            |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
					| 'Item'      | 'Item key'      |
					| 'Shirt'     | '38/Black'      |
			And I select current line in "List" table
			And I activate "Procurement method" field in "ItemList" table
			And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
			And I move to the next attribute
			And I finish line editing in "ItemList" table
		* Add items with procurement method stock
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
					| 'Description'      |
					| 'Trousers'         |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
					| 'Item'         | 'Item key'       |
					| 'Trousers'     | '38/Yellow'      |
			And I select current line in "List" table
			And I activate "Procurement method" field in "ItemList" table
			And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
			And I move to the next attribute
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Tick Shipment confirmation before Sales invoice and post an order
			And I move to "Other" tab
			* Change the document number
				And I input "800" text in "Number" field
				Then "1C:Enterprise" window is opened
				And I click "Yes" button
				And I input "800" text in "Number" field
			And I click the button named "FormPostAndClose"
* Create second test SO №801
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	* Filling in details
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
				| 'Description'           |
				| 'Company Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
		And I select current line in "List" table
	* Filling in the tabular part
		* Add a product that will not be shipped
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
					| 'Description'      |
					| 'Trousers'         |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
					| 'Item'         | 'Item key'       |
					| 'Trousers'     | '38/Yellow'      |
			And I select current line in "List" table
			And I activate "Procurement method" field in "ItemList" table
			And I select "No reserve" exact value from "Procurement method" drop-down list in "ItemList" table
			And I change "Cancel" checkbox in "ItemList" table
			And I activate "Cancel reason" field in "ItemList" table
			And I click choice button of "Cancel reason" attribute in "ItemList" table	
			And I go to line in "List" table
					| 'Description'        |
					| 'not available'      |
			And I select current line in "List" table
			And I move to the next attribute
			And I input "8,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Add items with procurement method stock
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
					| 'Description'      |
					| 'Trousers'         |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
					| 'Item'         | 'Item key'       |
					| 'Trousers'     | '38/Yellow'      |
			And I select current line in "List" table
			And I activate "Procurement method" field in "ItemList" table
			And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
			And I move to the next attribute
			And I input "10,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Tick Shipment confirmation before Sales invoice and post an order
			And I move to "Other" tab
			* Change the document number
				And I input "801" text in "Number" field
				Then "1C:Enterprise" window is opened
				And I click "Yes" button
				And I input "801" text in "Number" field
			And I click the button named "FormPostAndClose"
* Create Sales invoice based on SO №800 and SO №801
	And I go to line in "List" table
			| Number    |
			| 800       |
	And I move one line down in "List" table and select line
	And I click the button named "FormDocumentSalesInvoiceGenerate"
	And I click "Ok" button
	* Check filling in tabular part
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Quantity'    |
			| 'Service'    | 'Rent'        | '1,000'       |
			| 'Trousers'   | '38/Yellow'   | '10,000'      |
			| 'Trousers'   | '38/Yellow'   | '2,000'       |
		Then the number of "ItemList" table lines is "меньше или равно" 3
		And I close current window
* Create Shipment confirmation based on SO №800 and SO №801 (should get 2 lines for items from two orders)
	And I go to line in "List" table
			| Number    |
			| 800       |
	And I move one line down in "List" table and select line
	And I click the button named "FormDocumentShipmentConfirmationGenerate"
	And I click "Ok" button	
	* Check filling in details
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
	* Check filling in tabular part
		Then the number of "ItemList" table lines is "меньше или равно" 2
		And "ItemList" table contains lines
			| 'Item'       | 'Quantity'   | 'Item key'    | 'Unit'   | 'Store'      | 'Shipment basis'      |
			| 'Trousers'   | '2,000'      | '38/Yellow'   | 'pcs'    | 'Store 01'   | 'Sales order 800*'    |
			| 'Trousers'   | '10,000'     | '38/Yellow'   | 'pcs'    | 'Store 02'   | 'Sales order 801*'    |
	And I close current window
* Check filling in Purchase order (should get one string)
	And I go to line in "List" table
			| Number    |
			| 800       |
	And I move one line down in "List" table and select line
	And I click the button named "FormDocumentPurchaseOrderGenerate"
	And I click "Ok" button
	Then the number of "ItemList" table lines is "меньше или равно" 1
	And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Purchase basis'      |
			| 'Shirt'   | '38/Black'   | '1,000'      | 'Sales order 800*'    |
	And I close current window
* Check filling in Purchase invoice (should get one string)
	And I go to line in "List" table
			| Number    |
			| 800       |
	And I move one line down in "List" table and select line
	And I click the button named "FormDocumentPurchaseInvoiceGenerate"
	And I click "Ok" button
	Then the number of "ItemList" table lines is "меньше или равно" 1
	And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Sales order'         |
			| 'Shirt'   | '38/Black'   | '1,000'      | 'Sales order 800*'    |
	And I close all client application windows


Scenario: _090408 create one Sales order - several Shipment confirmation - one Sales invoice
	* Create Sales order
		When create the first test SO for a test on the creation mechanism based on
		And I click the button named "FormPost"
		And I delete "$$NumberSalesOrder090408$$" variable
		And I delete "$$SalesOrder090408$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder090408$$"
		And I save the window as "$$SalesOrder090408$$"
		And I click the button named "FormPostAndClose"
	* Create 3 Shipment confirmation
		* First SC
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I go to line in "List" table
				| 'Number'                         |
				| '$$NumberSalesOrder090408$$'     |
			And I click the button named "FormDocumentShipmentConfirmationGenerate"
			And I click "Ok" button	
			And I activate "Quantity" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "5,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'    | 'Quantity'     |
				| 'Dress'    | 'L/Green'     | '20,000'       |
			And I select current line in "ItemList" table
			And I input "5,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'     | 'Quantity'     |
				| 'Trousers'    | '36/Yellow'    | '30,000'       |
			And I select current line in "ItemList" table
			And I input "10,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			And I delete "$$NumberShipmentConfirmation0904081$$" variable
			And I delete "$$ShipmentConfirmation0904081$$" variable
			And I save the value of "Number" field as "$$NumberShipmentConfirmation0904081$$"
			And I save the window as "$$ShipmentConfirmation0904081$$"
			And I click the button named "FormPostAndClose"
		* Second SC
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I go to line in "List" table
				| 'Number'                         |
				| '$$NumberSalesOrder090408$$'     |
			And I click the button named "FormDocumentShipmentConfirmationGenerate"
			And I click "Ok" button	
			And I activate "Quantity" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "8,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'L/Green'      |
			And I select current line in "ItemList" table
			And I input "8,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '36/Yellow'     |
			And I select current line in "ItemList" table
			And I input "12,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			And I delete "$$NumberShipmentConfirmation0904082$$" variable
			And I delete "$$ShipmentConfirmation0904082$$" variable
			And I save the value of "Number" field as "$$NumberShipmentConfirmation0904082$$"
			And I save the window as "$$ShipmentConfirmation0904082$$"
			And I click the button named "FormPostAndClose"
		* Third SC
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I go to line in "List" table
				| 'Number'                         |
				| '$$NumberSalesOrder090408$$'     |
			And I click the button named "FormDocumentShipmentConfirmationGenerate"
			And I click "Ok" button	
			And I activate "Quantity" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "7,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'L/Green'      |
			And I select current line in "ItemList" table
			And I input "7,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '36/Yellow'     |
			And I select current line in "ItemList" table
			And I input "8,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			And I delete "$$NumberShipmentConfirmation0904083$$" variable
			And I delete "$$ShipmentConfirmation0904083$$" variable
			And I save the value of "Number" field as "$$NumberShipmentConfirmation0904083$$"
			And I save the window as "$$ShipmentConfirmation0904083$$"
			And I click the button named "FormPostAndClose"
	* Create Sales invoice for 3 Shipment Confirmation
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder090408$$'    |
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		And I click "Ok" button
		And "ItemList" table contains lines
		| 'VAT'  | 'Item'      | 'Price'   | 'Item key'   | 'Tax amount'  | 'Quantity'  | 'Price type'         | 'Unit'  | 'Dont calculate row'  | 'Net amount'  | 'Total amount'  | 'Store'     | 'Sales order'            |
		| '18%'  | 'Dress'     | '520,00'  | 'M/White'    | '1 586,44'    | '20,000'    | 'Basic Price Types'  | 'pcs'   | 'No'                  | '8 813,56'    | '10 400,00'     | 'Store 02'  | '$$SalesOrder090408$$'   |
		| '18%'  | 'Dress'     | '550,00'  | 'L/Green'    | '1 677,97'    | '20,000'    | 'Basic Price Types'  | 'pcs'   | 'No'                  | '9 322,03'    | '11 000,00'     | 'Store 02'  | '$$SalesOrder090408$$'   |
		| '18%'  | 'Trousers'  | '400,00'  | '36/Yellow'  | '1 830,51'    | '30,000'    | 'Basic Price Types'  | 'pcs'   | 'No'                  | '10 169,49'   | '12 000,00'     | 'Store 02'  | '$$SalesOrder090408$$'   |
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice0904083$$" variable
		And I delete "$$SalesInvoice0904083$$" variable
		And I delete "$$DateSalesInvoice0904083$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice0904083$$"
		And I save the window as "$$SalesInvoice0904083$$"
		And I save the value of the field named "Date" as "$$DateSalesInvoice0904083$$"	
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$SalesInvoice0904083$$'                   | ''              | ''                              | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                          | ''                       | ''          | ''                       | ''                              |
			| 'Document registrations records'            | ''              | ''                              | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                          | ''                       | ''          | ''                       | ''                              |
			| 'Register  "R2021 Customer transactions"'   | ''              | ''                              | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                          | ''                       | ''          | ''                       | ''                              |
			| ''                                          | 'Record type'   | 'Period'                        | 'Resources'   | 'Dimensions'     | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                          | ''                       | ''          | 'Attributes'             | ''                              |
			| ''                                          | ''              | ''                              | 'Amount'      | 'Company'        | 'Branch'   | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'          | 'Partner'     | 'Agreement'                  | 'Basis'                     | 'Order'                  | 'Project'   | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                          | 'Receipt'       | '$$DateSalesInvoice0904083$$'   | '5 718,08'    | 'Main Company'   | ''         | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | '$$SalesInvoice0904083$$'   | '$$SalesOrder090408$$'   | ''          | 'No'                     | ''                              |
			| ''                                          | 'Receipt'       | '$$DateSalesInvoice0904083$$'   | '33 400'      | 'Main Company'   | ''         | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | '$$SalesInvoice0904083$$'   | '$$SalesOrder090408$$'   | ''          | 'No'                     | ''                              |
			| ''                                          | 'Receipt'       | '$$DateSalesInvoice0904083$$'   | '33 400'      | 'Main Company'   | ''         | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | '$$SalesInvoice0904083$$'   | '$$SalesOrder090408$$'   | ''          | 'No'                     | ''                              |
		And I close all client application windows
