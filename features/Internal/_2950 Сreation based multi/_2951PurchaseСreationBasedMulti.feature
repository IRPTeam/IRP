#language: en
@tree
@Positive
@CreationBasedMulti

Feature: creation mechanism based on for purchase documents

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


# Internal supply request - Purchase order - Purchase invoice - Goods receipt - Bank payment/Cash payment
# A direct delivery scheme first an invoice, then an order


Scenario: _090300 preparation (creation mechanism based on for purchase documents)
	When set True value to the constant
	* Load info
		When Create catalog Companies objects (second company Ferron BP)
		When Create information register Barcodes records
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
				




Scenario: _0903001 check preparation
	When check preparation


Scenario: _090302 create purchase invoice for several purchase orders with different legal name
	# should be created 2 Purchase invoice
	* Create Purchase order
		When create the first test PO for a test on the creation mechanism based on
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder09030201$$" variable
		And I delete "$$PurchaseOrder09030201$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder09030201$$"
		And I save the window as "$$PurchaseOrder09030201$$"
		And I click the button named "FormPostAndClose"
	* Create Purchase order
		When create the second test PO for a test on the creation mechanism based on
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder09030202$$" variable
		And I delete "$$PurchaseOrder09030202$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder09030202$$"
		And I save the window as "$$PurchaseOrder09030202$$"
		And I click the button named "FormPostAndClose"
	* Create Purchase invoice based on Purchase orders (should be created 2)
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| Number                             |
			| $$NumberPurchaseOrder09030201$$    |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		And I click "Ok" button
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		Then the number of "ItemList" table lines is "меньше или равно" 3
		If the field named "LegalName" is equal to "Second Company Ferron BP" Then
			And "ItemList" table contains lines
			| 'Price'    | 'Item'    | 'VAT'   | 'Item key'   | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Purchase order'               | 'Sales order'    |
			| '200,00'   | 'Dress'   | '18%'   | 'M/White'    | '10,000'     | 'pcs'    | '305,08'       | '1 694,92'     | '2 000,00'       | 'Store 02'   | '$$PurchaseOrder09030202$$ '   | ''               |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice09030202$$" variable
			And I delete "$$PurchaseInvoice09030202$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice09030202$$"
			And I save the window as "$$PurchaseInvoice09030202$$"
		If the field named "LegalName" is equal to "Company Ferron BP" Then
			And "ItemList" table contains lines
			| 'Price'    | 'Item'       | 'VAT'   | 'Item key'    | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Purchase order'              | 'Sales order'   | 'Additional analytic'    |
			| '200,00'   | 'Dress'      | '18%'   | 'M/White'     | '20,000'     | 'pcs'    | '610,17'       | '3 389,83'     | '4 000,00'       | 'Store 02'   | '$$PurchaseOrder09030201$$'   | ''              | ''                       |
			| '210,00'   | 'Dress'      | '18%'   | 'L/Green'     | '20,000'     | 'pcs'    | '640,68'       | '3 559,32'     | '4 200,00'       | 'Store 02'   | '$$PurchaseOrder09030201$$'   | ''              | ''                       |
			| '210,00'   | 'Trousers'   | '18%'   | '36/Yellow'   | '30,000'     | 'pcs'    | '961,02'       | '5 338,98'     | '6 300,00'       | 'Store 02'   | '$$PurchaseOrder09030201$$'   | ''              | ''                       |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice09030201$$" variable
			And I delete "$$PurchaseInvoice09030201$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice09030201$$"
			And I save the window as "$$PurchaseInvoice09030201$$"
		And I click the button named "FormPostAndClose"
		When I click command interface button "Purchase invoice (create)"
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		Then the number of "ItemList" table lines is "меньше или равно" 3
		If the field named "LegalName" is equal to "Second Company Ferron BP" Then
			And "ItemList" table contains lines
			| 'Price'    | 'Item'    | 'VAT'   | 'Item key'   | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Purchase order'               | 'Sales order'    |
			| '200,00'   | 'Dress'   | '18%'   | 'M/White'    | '10,000'     | 'pcs'    | '305,08'       | '1 694,92'     | '2 000,00'       | 'Store 02'   | '$$PurchaseOrder09030202$$ '   | ''               |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice09030202$$" variable
			And I delete "$$PurchaseInvoice09030202$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice09030202$$"
			And I save the window as "$$PurchaseInvoice09030202$$"
		If the field named "LegalName" is equal to "Company Ferron BP" Then
			And "ItemList" table contains lines
			| 'Price'    | 'Item'       | 'VAT'   | 'Item key'    | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Purchase order'              | 'Sales order'   | 'Additional analytic'    |
			| '200,00'   | 'Dress'      | '18%'   | 'M/White'     | '20,000'     | 'pcs'    | '610,17'       | '3 389,83'     | '4 000,00'       | 'Store 02'   | '$$PurchaseOrder09030201$$'   | ''              | ''                       |
			| '210,00'   | 'Dress'      | '18%'   | 'L/Green'     | '20,000'     | 'pcs'    | '640,68'       | '3 559,32'     | '4 200,00'       | 'Store 02'   | '$$PurchaseOrder09030201$$'   | ''              | ''                       |
			| '210,00'   | 'Trousers'   | '18%'   | '36/Yellow'   | '30,000'     | 'pcs'    | '961,02'       | '5 338,98'     | '6 300,00'       | 'Store 02'   | '$$PurchaseOrder09030201$$'   | ''              | ''                       |
			
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice09030201$$" variable
			And I delete "$$PurchaseInvoice09030201$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice09030201$$"
			And I save the window as "$$PurchaseInvoice09030201$$"
		And I click the button named "FormPostAndClose"
		And I close all client application windows
	* Create Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And "List" table contains lines
			| 'Number'                               |
			| '$$NumberPurchaseInvoice09030202$$'    |
			| '$$NumberPurchaseInvoice09030201$$'    |
		And I close all client application windows




		

Scenario: _090303 create Purchase invoice for several Purchase order with the same partner, legal name, partner term, currency and store
# Should be created 1 Purchase invoice
	* Create Purchase order
		When create the first test PO for a test on the creation mechanism based on
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| Description          |
			| Company Ferron BP    |
		And I select current line in "List" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder09030203$$" variable
		And I delete "$$PurchaseOrder09030203$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder09030203$$"
		And I save the window as "$$PurchaseOrder09030203$$"
		And I click the button named "FormPostAndClose"
	* Create Purchase order
		When create the second test PO for a test on the creation mechanism based on
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| Description          |
			| Company Ferron BP    |
		And I select current line in "List" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder090302031$$" variable
		And I delete "$$PurchaseOrder090302031$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder090302031$$"
		And I save the window as "$$PurchaseOrder090302031$$"
		And I click the button named "FormPostAndClose"
	* Create Purchase invoice based on Purchase orders (should be created 1)
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| Number                             |
			| $$NumberPurchaseOrder09030203$$    |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		And I click "Ok" button
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table contains lines
			| 'Net amount'   | 'Item'       | 'Price'    | 'Item key'    | 'Quantity'   | 'Unit'   | 'Total amount'   | 'Store'      | 'Purchase order'                |
			| '3 389,83'     | 'Dress'      | '200,00'   | 'M/White'     | '20,000'     | 'pcs'    | '4 000,00'       | 'Store 02'   | '$$PurchaseOrder09030203$$'     |
			| '3 559,32'     | 'Dress'      | '210,00'   | 'L/Green'     | '20,000'     | 'pcs'    | '4 200,00'       | 'Store 02'   | '$$PurchaseOrder09030203$$'     |
			| '5 338,98'     | 'Trousers'   | '210,00'   | '36/Yellow'   | '30,000'     | 'pcs'    | '6 300,00'       | 'Store 02'   | '$$PurchaseOrder09030203$$'     |
			| '1 694,92'     | 'Dress'      | '200,00'   | 'M/White'     | '10,000'     | 'pcs'    | '2 000,00'       | 'Store 02'   | '$$PurchaseOrder090302031$$'    |
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseInvoice090302031$$" variable
		And I delete "$$PurchaseInvoice090302031$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice090302031$$"
		And I save the window as "$$PurchaseInvoice090302031$$"
		And I click the button named "FormPostAndClose"
		And I close all client application windows
	* Create Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And "List" table contains lines
			| 'Number'                                |
			| '$$NumberPurchaseInvoice090302031$$'    |
		And I close all client application windows
	
Scenario: _090304 create Purchase invoice for several Purchase order with different partners of the same legal name (partner terms are different)
# should be created 2 Purchase invoice
	* Create first test PO
		When create the first test PO for a test on the creation mechanism based on
		* Filling in vendor info
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
				| Description         |
				| Vendor Ferron 1     |
			And I select current line in "List" table
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description     |
				| Store 02        |
			And I select current line in "List" table
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
			And I input "200" text in "Price" field of "ItemList" table
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'L/Green'     |
			And I input "210" text in "Price" field of "ItemList" table
			And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '36/Yellow'    |
			And I input "210" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder090302041$$" variable
		And I delete "$$PurchaseOrder090302041$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder090302041$$"
		And I save the window as "$$PurchaseOrder090302041$$"
		And I click the button named "FormPostAndClose"
	* Create second test PO
		When create the second test PO for a test on the creation mechanism based on
		* Filling in vendor info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description          |
				| Partner Ferron 2     |
			And I select current line in "List" table
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description                 |
				| Vendor Ferron Partner 2     |
			And I select current line in "List" table
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description     |
				| Store 02        |
			And I select current line in "List" table
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
			And I input "200" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder090302042$$" variable
		And I delete "$$PurchaseOrder090302042$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder090302042$$"
		And I save the window as "$$PurchaseOrder090302042$$"
		And I click the button named "FormPostAndClose"
	* Create  Purchase invoice based on Purchase orders (should be created 2)
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| Number                              |
			| $$NumberPurchaseOrder090302041$$    |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		And I click "Ok" button
		Then the number of "ItemList" table lines is "меньше или равно" 3
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseInvoice090302041$$" variable
		And I delete "$$PurchaseInvoice090302041$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice090302041$$"
		And I save the window as "$$PurchaseInvoice090302041$$"
		And I click the button named "FormPostAndClose"
		When I click command interface button "Purchase invoice (create)"
		And Delay 2
		Then the number of "ItemList" table lines is "меньше или равно" 3
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseInvoice090302042$$" variable
		And I delete "$$PurchaseInvoice090302042$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice090302042$$"
		And I save the window as "$$PurchaseInvoice090302042$$"
		And I click the button named "FormPostAndClose"
	And I close all client application windows




Scenario: _090305 create purchase invoice for several purchase order with different partner terms
# should be created 2 Purchase invoice
	* Create first test PO
		When create the first test PO for a test on the creation mechanism based on
		* Filling in vendor info
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
				| Description         |
				| Vendor Ferron 1     |
			And I select current line in "List" table
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description     |
				| Store 02        |
			And I select current line in "List" table
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
			And I input "200" text in "Price" field of "ItemList" table
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'L/Green'     |
			And I input "210" text in "Price" field of "ItemList" table
			And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '36/Yellow'    |
			And I input "210" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder090302051$$" variable
		And I delete "$$PurchaseOrder090302051$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder090302051$$"
		And I save the window as "$$PurchaseOrder090302051$$"
		And I click the button named "FormPostAndClose"
	* Create second test PO Partner Ferron 1 with partner term Vendor Ferron Discount
		When create the second test PO for a test on the creation mechanism based on
		* Filling in vendor info
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
				| Description                |
				| Vendor Ferron Discount     |
			And I select current line in "List" table
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description     |
				| Store 02        |
			And I select current line in "List" table
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
			And I input "200" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder090302052$$" variable
		And I delete "$$PurchaseOrder090302052$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder090302052$$"
		And I save the window as "$$PurchaseOrder090302052$$"
		And I click the button named "FormPostAndClose"
	* Create Purchase invoice based on Purchase orders (should be created 2)
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| Number                              |
			| $$NumberPurchaseOrder090302051$$    |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		And I click "Ok" button
		Then the form attribute named "Partner" became equal to "Partner Ferron 1"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "Agreement" is equal to "Vendor Ferron 1" Then
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Tax amount'    | 'Net amount'    | 'Total amount'    | 'Store'       | 'Purchase order'                 |
				| '200,00'    | 'Dress'       | '18%'    | 'M/White'      | '20,000'      | 'pcs'     | '720,00'        | '4 000,00'      | '4 720,00'        | 'Store 02'    | '$$PurchaseOrder090302051$$'     |
				| '210,00'    | 'Dress'       | '18%'    | 'L/Green'      | '20,000'      | 'pcs'     | '756,00'        | '4 200,00'      | '4 956,00'        | 'Store 02'    | '$$PurchaseOrder090302051$$'     |
				| '210,00'    | 'Trousers'    | '18%'    | '36/Yellow'    | '30,000'      | 'pcs'     | '1 134,00'      | '6 300,00'      | '7 434,00'        | 'Store 02'    | '$$PurchaseOrder090302051$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseOrder090302052$$" variable
			And I delete "$$PurchaseOrder090302052$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice090302052$$"
			And I save the window as "$$PurchaseInvoice090302052$$"
		If the field named "Agreement" is equal to "Vendor Ferron Discount" Then
			And "ItemList" table contains lines
				| 'Price'     | 'Item'     | 'VAT'    | 'Item key'    | 'Quantity'    | 'Unit'    | 'Tax amount'    | 'Net amount'    | 'Total amount'    | 'Store'       | 'Purchase order'                 |
				| '200,00'    | 'Dress'    | '18%'    | 'M/White'     | '10,000'      | 'pcs'     | '360,00'        | '2 000,00'      | '2 360,00'        | 'Store 02'    | '$$PurchaseOrder090302052$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice090302051$$" variable
			And I delete "$$PurchaseInvoice090302051$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice090302051$$"
			And I save the window as "$$PurchaseInvoice090302051$$"
		And I click the button named "FormPostAndClose"
		When I click command interface button "Purchase invoice (create)"
		* Check filling in second PurchaseInvoice
		Then the form attribute named "Partner" became equal to "Partner Ferron 1"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "Agreement" is equal to "Vendor Ferron 1" Then
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Tax amount'    | 'Net amount'    | 'Total amount'    | 'Store'       | 'Purchase order'                 |
				| '200,00'    | 'Dress'       | '18%'    | 'M/White'      | '20,000'      | 'pcs'     | '720,00'        | '4 000,00'      | '4 720,00'        | 'Store 02'    | '$$PurchaseOrder090302051$$'     |
				| '210,00'    | 'Dress'       | '18%'    | 'L/Green'      | '20,000'      | 'pcs'     | '756,00'        | '4 200,00'      | '4 956,00'        | 'Store 02'    | '$$PurchaseOrder090302051$$'     |
				| '210,00'    | 'Trousers'    | '18%'    | '36/Yellow'    | '30,000'      | 'pcs'     | '1 134,00'      | '6 300,00'      | '7 434,00'        | 'Store 02'    | '$$PurchaseOrder090302051$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice090302052$$" variable
			And I delete "$$PurchaseInvoice090302052$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice090302052$$"
			And I save the window as "$$PurchaseInvoice090302052$$"
		If the field named "Agreement" is equal to "Vendor Ferron Discount" Then
			And "ItemList" table contains lines
				| 'Price'     | 'Item'     | 'VAT'    | 'Item key'    | 'Quantity'    | 'Unit'    | 'Tax amount'    | 'Net amount'    | 'Total amount'    | 'Store'       | 'Purchase order'                 |
				| '200,00'    | 'Dress'    | '18%'    | 'M/White'     | '10,000'      | 'pcs'     | '360,00'        | '2 000,00'      | '2 360,00'        | 'Store 02'    | '$$PurchaseOrder090302052$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice090302051$$" variable
			And I delete "$$PurchaseInvoice090302051$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice090302051$$"
			And I save the window as "$$PurchaseInvoice090302051$$"
		And I click the button named "FormPostAndClose"
	And I close all client application windows
	



Scenario: _090306 create Purchase invoice for several Purchase order with different stores (created one)
# Create one PI
	* Create first test PO
		When create the first test PO for a test on the creation mechanism based on
		* Filling in vendor info
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
				| Description                |
				| Vendor Ferron Discount     |
			And I select current line in "List" table
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description     |
				| Store 01        |
			And I select current line in "List" table
			And I click "OK" button
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
			And I input "200" text in "Price" field of "ItemList" table
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'L/Green'     |
			And I input "210" text in "Price" field of "ItemList" table
			And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '36/Yellow'    |
			And I input "210" text in "Price" field of "ItemList" table
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseOrder090302061$$" variable
			And I delete "$$PurchaseOrder090302061$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseOrder090302061$$"
			And I save the window as "$$PurchaseOrder090302061$$"
		And I click the button named "FormPostAndClose"
	* Create second test PO
		When create the second test PO for a test on the creation mechanism based on
		* Filling in vendor info
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
				| Description                |
				| Vendor Ferron Discount     |
			And I select current line in "List" table
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description     |
				| Store 02        |
			And I select current line in "List" table
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
			And I input "200" text in "Price" field of "ItemList" table
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseOrder090302062$$" variable
			And I delete "$$PurchaseOrder090302062$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseOrder090302062$$"
			And I save the window as "$$PurchaseOrder090302062$$"
		And I click the button named "FormPostAndClose"
	* Create Purchase invoice based on Purchase orders (should be created 1)
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| Number                              |
			| $$NumberPurchaseOrder090302061$$    |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		And I click "Ok" button
		Then the form attribute named "Partner" became equal to "Partner Ferron 1"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron Discount"
		Then the form attribute named "Company" became equal to "Main Company"
		And "ItemList" table contains lines
			| 'Item'       | 'Price'    | 'Item key'    | 'Store'      | 'Unit'   | 'Quantity'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Purchase order'                |
			| 'Dress'      | '200,00'   | 'M/White'     | 'Store 01'   | 'pcs'    | '20,000'     | ''                | '4 000,00'     | '4 720,00'       | '$$PurchaseOrder090302061$$'    |
			| 'Dress'      | '210,00'   | 'L/Green'     | 'Store 01'   | 'pcs'    | '20,000'     | ''                | '4 200,00'     | '4 956,00'       | '$$PurchaseOrder090302061$$'    |
			| 'Trousers'   | '210,00'   | '36/Yellow'   | 'Store 01'   | 'pcs'    | '30,000'     | ''                | '6 300,00'     | '7 434,00'       | '$$PurchaseOrder090302061$$'    |
			| 'Dress'      | '200,00'   | 'M/White'     | 'Store 02'   | 'pcs'    | '10,000'     | ''                | '2 000,00'     | '2 360,00'       | '$$PurchaseOrder090302062$$'    |
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseInvoice090302062$$" variable
		And I delete "$$PurchaseInvoice090302062$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice090302062$$"
		And I save the window as "$$PurchaseInvoice090302062$$"
		And I click the button named "FormPostAndClose"
		And I close all client application windows
	* Create Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And "List" table contains lines
			| 'Number'                                |
			| '$$NumberPurchaseInvoice090302062$$'    |
		And I close all client application windows

	
Scenario: _090307 create purchase invoice for several purchase order with different own companies
	# Create one PI
	* Create first test PO
		When create the first test PO for a test on the creation mechanism based on
		* Filling in vendor info
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
				| Description                |
				| Vendor Ferron Discount     |
			And I select current line in "List" table
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description     |
				| Store 02        |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description        |
				| Second Company     |
			And I select current line in "List" table
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
			And I input "200" text in "Price" field of "ItemList" table
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'L/Green'     |
			And I input "210" text in "Price" field of "ItemList" table
			And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '36/Yellow'    |
			And I input "210" text in "Price" field of "ItemList" table
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseOrder09030701$$" variable
			And I delete "$$PurchaseOrder09030701$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseOrder09030701$$"
			And I save the window as "$$PurchaseOrder09030701$$"
		And I click the button named "FormPostAndClose"
	* Create second test PO
		When create the second test PO for a test on the creation mechanism based on
		* Filling in vendor info
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
				| Description                |
				| Vendor Ferron Discount     |
			And I select current line in "List" table
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description     |
				| Store 02        |
			And I select current line in "List" table
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
			And I input "200" text in "Price" field of "ItemList" table
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseOrder09030702$$" variable
			And I delete "$$PurchaseOrder09030702$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseOrder09030702$$"
			And I save the window as "$$PurchaseOrder09030702$$"
		And I click the button named "FormPostAndClose"
	* Create Purchase invoice based on Purchase orders (should be created 2)
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| Number                             |
			| $$NumberPurchaseOrder09030701$$    |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		And I click "Ok" button
		Then the form attribute named "Partner" became equal to "Partner Ferron 1"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron Discount"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "Company" is equal to "Main Company" Then
			And "ItemList" table contains lines
				| 'Item'     | 'Price'     | 'Item key'    | 'Store'       | 'Unit'    | 'Quantity'    | 'Net amount'    | 'Total amount'    | 'Purchase order'                |
				| 'Dress'    | '200,00'    | 'M/White'     | 'Store 02'    | 'pcs'     | '10,000'      | '2 000,00'      | '2 360,00'        | '$$PurchaseOrder09030702$$'     |
			Then the form attribute named "PriceIncludeTax" became equal to "No"
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice09030702$$" variable
			And I delete "$$PurchaseInvoice09030702$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice09030702$$"
			And I save the window as "$$PurchaseInvoice09030702$$"
		If the field named "Company" is equal to "Second Company" Then
			And "ItemList" table contains lines
			| 'Item'       | 'Price'    | 'Item key'    | 'Store'      | 'Unit'   | 'Quantity'   | 'Net amount'   | 'Total amount'   | 'Purchase order'               |
			| 'Dress'      | '200,00'   | 'M/White'     | 'Store 02'   | 'pcs'    | '20,000'     | '4 000,00'     | '4 000,00'       | '$$PurchaseOrder09030701$$'    |
			| 'Dress'      | '210,00'   | 'L/Green'     | 'Store 02'   | 'pcs'    | '20,000'     | '4 200,00'     | '4 200,00'       | '$$PurchaseOrder09030701$$'    |
			| 'Trousers'   | '210,00'   | '36/Yellow'   | 'Store 02'   | 'pcs'    | '30,000'     | '6 300,00'     | '6 300,00'       | '$$PurchaseOrder09030701$$'    |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice09030701$$" variable
			And I delete "$$PurchaseInvoice09030701$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice09030701$$"
			And I save the window as "$$PurchaseInvoice09030701$$"
		And I click the button named "FormPostAndClose"
		When I click command interface button "Purchase invoice (create)"
		Then the form attribute named "Partner" became equal to "Partner Ferron 1"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron Discount"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "Company" is equal to "Main Company" Then
			And "ItemList" table contains lines
				| 'Item'     | 'Price'     | 'Item key'    | 'Store'       | 'Unit'    | 'Quantity'    | 'Net amount'    | 'Total amount'    | 'Purchase order'                |
				| 'Dress'    | '200,00'    | 'M/White'     | 'Store 02'    | 'pcs'     | '10,000'      | '2 000,00'      | '2 360,00'        | '$$PurchaseOrder09030702$$'     |
			Then the form attribute named "PriceIncludeTax" became equal to "No"
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice09030702$$" variable
			And I delete "$$PurchaseInvoice09030702$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice09030702$$"
			And I save the window as "$$PurchaseInvoice09030702$$"
		If the field named "Company" is equal to "Second Company" Then
			And "ItemList" table contains lines
			| 'Item'       | 'Price'    | 'Item key'    | 'Store'      | 'Unit'   | 'Quantity'   | 'Total amount'   | 'Purchase order'               |
			| 'Dress'      | '200,00'   | 'M/White'     | 'Store 02'   | 'pcs'    | '20,000'     | '4 000,00'       | '$$PurchaseOrder09030701$$'    |
			| 'Dress'      | '210,00'   | 'L/Green'     | 'Store 02'   | 'pcs'    | '20,000'     | '4 200,00'       | '$$PurchaseOrder09030701$$'    |
			| 'Trousers'   | '210,00'   | '36/Yellow'   | 'Store 02'   | 'pcs'    | '30,000'     | '6 300,00'       | '$$PurchaseOrder09030701$$'    |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice09030701$$" variable
			And I delete "$$PurchaseInvoice09030701$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice09030701$$"
			And I save the window as "$$PurchaseInvoice09030701$$"
		And I click the button named "FormPostAndClose"
	And I close all client application windows
	* Create Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And "List" table contains lines
			| 'Number'                               |
			| '$$NumberPurchaseInvoice09030702$$'    |
			| '$$NumberPurchaseInvoice09030701$$'    |
		And I close all client application windows




Scenario: _090308 create Goods receipt for Purchase invoice with different legal names (Purchase invoice before Goods receipt)
# Should be created 2 GR
	* Create Goods receipt for PI 125, 126
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		* Sort the list by document number 
			And I click "Configure list..." button
			And I move to "Order" tab
			And in the table "SettingsComposerUserSettingsItem1Order" I click the button named "SettingsComposerUserSettingsItem1OrderDelete"
			And I go to line in "SettingsComposerUserSettingsItem1AvailableFieldsTable" table
				| 'Available fields'     |
				| 'Number'               |
			And I select current line in "SettingsComposerUserSettingsItem1AvailableFieldsTable" table
			And I click "Finish editing" button
		And I go to line in "List" table
				| 'Number'                                |
				| '$$NumberPurchaseInvoice09030202$$'     |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentGoodsReceiptGenerate"
		And I click "Ok" button	
	* Check filling in Goods receipt
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "LegalName" is equal to "Company Ferron BP" Then
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903081$$" variable
			And I delete "$$GoodsReceipt0903081$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903081$$"
			And I save the window as "$$GoodsReceipt0903081$$"
			And "ItemList" table contains lines
			| 'Item'       | 'Quantity'   | 'Item key'    | 'Unit'   | 'Store'      | 'Receipt basis'                  |
			| 'Dress'      | '20,000'     | 'M/White'     | 'pcs'    | 'Store 02'   | '$$PurchaseInvoice09030201$$'    |
			| 'Dress'      | '20,000'     | 'L/Green'     | 'pcs'    | 'Store 02'   | '$$PurchaseInvoice09030201$$'    |
			| 'Trousers'   | '30,000'     | '36/Yellow'   | 'pcs'    | 'Store 02'   | '$$PurchaseInvoice09030201$$'    |
		If the field named "LegalName" is equal to "Second Company Ferron BP" Then
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903082$$" variable
			And I delete "$$GoodsReceipt0903082$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903082$$"
			And I save the window as "$$GoodsReceipt0903082$$"
			And "ItemList" table contains lines
			| 'Item'    | 'Quantity'   | 'Item key'   | 'Unit'   | 'Store'      | 'Receipt basis'                  |
			| 'Dress'   | '10,000'     | 'M/White'    | 'pcs'    | 'Store 02'   | '$$PurchaseInvoice09030202$$'    |
		And I click the button named "FormPostAndClose"
	When I click command interface button "Goods receipt (create)"
	* Check filling in second Goods receipt
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "LegalName" is equal to "Company Ferron BP" Then
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903081$$" variable
			And I delete "$$GoodsReceipt0903081$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903081$$"
			And I save the window as "$$GoodsReceipt0903081$$"
			And "ItemList" table contains lines
			| 'Item'       | 'Quantity'   | 'Item key'    | 'Unit'   | 'Store'      | 'Receipt basis'                  |
			| 'Dress'      | '20,000'     | 'M/White'     | 'pcs'    | 'Store 02'   | '$$PurchaseInvoice09030201$$'    |
			| 'Dress'      | '20,000'     | 'L/Green'     | 'pcs'    | 'Store 02'   | '$$PurchaseInvoice09030201$$'    |
			| 'Trousers'   | '30,000'     | '36/Yellow'   | 'pcs'    | 'Store 02'   | '$$PurchaseInvoice09030201$$'    |
		If the field named "LegalName" is equal to "Second Company Ferron BP" Then
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903082$$" variable
			And I delete "$$GoodsReceipt0903082$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903082$$"
			And I save the window as "$$GoodsReceipt0903082$$"
			And "ItemList" table contains lines
			| 'Item'    | 'Quantity'   | 'Item key'   | 'Unit'   | 'Store'      | 'Receipt basis'                  |
			| 'Dress'   | '10,000'     | 'M/White'    | 'pcs'    | 'Store 02'   | '$$PurchaseInvoice09030202$$'    |
		And I click the button named "FormPostAndClose"
	* Create Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And "List" table contains lines
			| 'Number'                           |
			| '$$NumberGoodsReceipt0903081$$'    |
			| '$$NumberGoodsReceipt0903082$$'    |
		And I close all client application windows



Scenario: _090309 create Goods receipt for several Purchase invoice with different partners of the same legal name (Purchase invoice before Goods receipt)
# Should be created 2 GR
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
				| 'Number'                                 |
				| '$$NumberPurchaseInvoice090302041$$'     |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentGoodsReceiptGenerate"
		And I click "Ok" button	
	* Check filling in Goods receipt
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "Partner" is equal to "Partner Ferron 2" Then
			And "ItemList" table contains lines
				| 'Item'     | 'Quantity'    | 'Item key'    | 'Unit'    | 'Store'       | 'Receipt basis'                    |
				| 'Dress'    | '10,000'      | 'M/White'     | 'pcs'     | 'Store 02'    | '$$PurchaseInvoice090302041$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt090309N129$$" variable
			And I delete "$$GoodsReceipt090309N129$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt090309N129$$"
			And I save the window as "$$GoodsReceipt090309N129$$"
		If the field named "Partner" is equal to "Partner Ferron 1" Then
			And "ItemList" table contains lines
				| 'Item'        | 'Quantity'    | 'Item key'     | 'Unit'    | 'Store'       | 'Receipt basis'                    |
				| 'Dress'       | '20,000'      | 'M/White'      | 'pcs'     | 'Store 02'    | '$$PurchaseInvoice090302042$$'     |
				| 'Dress'       | '20,000'      | 'L/Green'      | 'pcs'     | 'Store 02'    | '$$PurchaseInvoice090302042$$'     |
				| 'Trousers'    | '30,000'      | '36/Yellow'    | 'pcs'     | 'Store 02'    | '$$PurchaseInvoice090302042$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt090309N130$$" variable
			And I delete "$$GoodsReceipt090309N130$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt090309N130$$"
			And I save the window as "$$GoodsReceipt090309N130$$"
	And I click the button named "FormPostAndClose"
	When I click command interface button "Goods receipt (create)"
	* Check filling in second Goods receipt
		If the field named "Partner" is equal to "Partner Ferron 2" Then
			And "ItemList" table contains lines
				| 'Item'     | 'Quantity'    | 'Item key'    | 'Unit'    | 'Store'       | 'Receipt basis'                    |
				| 'Dress'    | '10,000'      | 'M/White'     | 'pcs'     | 'Store 02'    | '$$PurchaseInvoice090302041$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt090309N129$$" variable
			And I delete "$$GoodsReceipt090309N129$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt090309N129$$"
			And I save the window as "$$GoodsReceipt090309N129$$"
		If the field named "Partner" is equal to "Partner Ferron 1" Then
			And "ItemList" table contains lines
				| 'Item'        | 'Quantity'    | 'Item key'     | 'Unit'    | 'Store'       | 'Receipt basis'                    |
				| 'Dress'       | '20,000'      | 'M/White'      | 'pcs'     | 'Store 02'    | '$$PurchaseInvoice090302042$$'     |
				| 'Dress'       | '20,000'      | 'L/Green'      | 'pcs'     | 'Store 02'    | '$$PurchaseInvoice090302042$$'     |
				| 'Trousers'    | '30,000'      | '36/Yellow'    | 'pcs'     | 'Store 02'    | '$$PurchaseInvoice090302042$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt090309N130$$" variable
			And I delete "$$GoodsReceipt090309N130$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt090309N130$$"
			And I save the window as "$$GoodsReceipt090309N130$$"
	And I click the button named "FormPostAndClose"
	* Create Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And "List" table contains lines
			| 'Number'                              |
			| '$$NumberGoodsReceipt090309N129$$'    |
			| '$$NumberGoodsReceipt090309N130$$'    |
		And I close all client application windows


Scenario: _090310 create Goods receipt for several Purchase invoice with different partner terms, Purchase invoice before Goods receipt
# Should be created 1 GR
	* Create Goods receipt for PI PurchaseInvoice090302051, PurchaseInvoice090302052
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
				| Number                                 |
				| $$NumberPurchaseInvoice090302051$$     |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentGoodsReceiptGenerate"
		And I click "Ok" button	
	* Check filling in Goods receipt
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Store" became equal to "Store 02"
		Then the form attribute named "Partner" became equal to "Partner Ferron 1"
		And I save number of "ItemList" table lines as "Quantity"
		If "Quantity" variable is equal to 1 Then
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903N140$$" variable
			And I delete "$$GoodsReceipt0903N140$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903N140$$"
			And I save the window as "$$GoodsReceipt0903N140$$"
			And "ItemList" table contains lines
			| 'Item'    | 'Quantity'   | 'Item key'   | 'Store'      | 'Unit'   | 'Receipt basis'                   |
			| 'Dress'   | '10,000'     | 'M/White'    | 'Store 02'   | 'pcs'    | '$$PurchaseInvoice090302051$$'    |
		If "Quantity" variable is equal to 3 Then
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903N141$$" variable
			And I delete "$$GoodsReceipt0903N141$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903N141$$"
			And I save the window as "$$GoodsReceipt0903N141$$"
			And "ItemList" table contains lines
			| 'Item'       | 'Quantity'   | 'Item key'    | 'Unit'   | 'Store'      | 'Receipt basis'                   |
			| 'Dress'      | '20,000'     | 'M/White'     | 'pcs'    | 'Store 02'   | '$$PurchaseInvoice090302052$$'    |
			| 'Dress'      | '20,000'     | 'L/Green'     | 'pcs'    | 'Store 02'   | '$$PurchaseInvoice090302052$$'    |
			| 'Trousers'   | '30,000'     | '36/Yellow'   | 'pcs'    | 'Store 02'   | '$$PurchaseInvoice090302052$$'    |
			| 'Dress'      | '10,000'     | 'M/White'     | 'pcs'    | 'Store 02'   | '$$PurchaseInvoice090302051$$'    |
	And I click the button named "FormPostAndClose"
	And I close all client application windows
	


Scenario: _090311 create Goods receipt for several Purchase invoice with different stores, Purchase invoice before Goods receipt (only one store use Goods receipt)
# Create one GR
	* Create Goods receipt for PurchaseInvoice090302062
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
				| Number                                 |
				| $$NumberPurchaseInvoice090302062$$     |
		And I click the button named "FormDocumentGoodsReceiptGenerate"
		And I click "Ok" button	
	* Check filling in Goods receipt
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table contains lines
		| 'Item'   | 'Quantity'  | 'Item key'  | 'Unit'  | 'Store'     | 'Receipt basis'                  |
		| 'Dress'  | '10,000'    | 'M/White'   | 'pcs'   | 'Store 02'  | '$$PurchaseInvoice090302062$$'   |
		And I click the button named "FormPost"
		And I delete "$$NumberGoodsReceipt0903N135$$" variable
		And I delete "$$GoodsReceipt0903N135$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt0903N135$$"
		And I save the window as "$$GoodsReceipt0903N135$$"
	And I click the button named "FormPostAndClose"
	* Create Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And "List" table contains lines
			| 'Number'                            |
			| '$$NumberGoodsReceipt0903N135$$'    |
		And I close all client application windows


Scenario: _090312 create Goods receipt for several Purchase order with different own companies, Purchase invoice before Goods receipt
# Should be created GR
	* Create Goods receipt for PI PurchaseInvoice09030701, PurchaseInvoice09030702
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'                               |
			| '$$NumberPurchaseInvoice09030702$$'    |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentGoodsReceiptGenerate"
		And I click "Ok" button	
	* Check filling in Goods receipt
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "Company" is equal to "Second Company" Then
			And "ItemList" table contains lines
				| 'Item'        | 'Quantity'    | 'Item key'     | 'Unit'    | 'Store'       | 'Receipt basis'                   |
				| 'Dress'       | '20,000'      | 'M/White'      | 'pcs'     | 'Store 02'    | '$$PurchaseInvoice09030701$$'     |
				| 'Dress'       | '20,000'      | 'L/Green'      | 'pcs'     | 'Store 02'    | '$$PurchaseInvoice09030701$$'     |
				| 'Trousers'    | '30,000'      | '36/Yellow'    | 'pcs'     | 'Store 02'    | '$$PurchaseInvoice09030701$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903N136$$" variable
			And I delete "$$GoodsReceipt0903N136$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903N136$$"
			And I save the window as "$$GoodsReceipt0903N136$$"
		If the field named "Company" is equal to "Main Company" Then
			And "ItemList" table contains lines
				| 'Item'     | 'Quantity'    | 'Item key'    | 'Unit'    | 'Store'        |
				| 'Dress'    | '10,000'      | 'M/White'     | 'pcs'     | 'Store 02'     |
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903N137$$" variable
			And I delete "$$GoodsReceipt0903N137$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903N137$$"
			And I save the window as "$$GoodsReceipt0903N137$$"
	And I click the button named "FormPostAndClose"
	When I click command interface button "Goods receipt (create)"
	* Check filling in Goods receipt
		If the field named "Company" is equal to "Second Company" Then
			And "ItemList" table contains lines
				| 'Item'        | 'Quantity'    | 'Item key'     | 'Unit'    | 'Store'       | 'Receipt basis'                   |
				| 'Dress'       | '20,000'      | 'M/White'      | 'pcs'     | 'Store 02'    | '$$PurchaseInvoice09030701$$'     |
				| 'Dress'       | '20,000'      | 'L/Green'      | 'pcs'     | 'Store 02'    | '$$PurchaseInvoice09030701$$'     |
				| 'Trousers'    | '30,000'      | '36/Yellow'    | 'pcs'     | 'Store 02'    | '$$PurchaseInvoice09030701$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903N136$$" variable
			And I delete "$$GoodsReceipt0903N136$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903N136$$"
			And I save the window as "$$GoodsReceipt0903N136$$"
		If the field named "Company" is equal to "Main Company" Then
			And "ItemList" table contains lines
				| 'Item'     | 'Quantity'    | 'Item key'    | 'Unit'    | 'Store'        |
				| 'Dress'    | '10,000'      | 'M/White'     | 'pcs'     | 'Store 02'     |
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903N137$$" variable
			And I delete "$$GoodsReceipt0903N137$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903N137$$"
			And I save the window as "$$GoodsReceipt0903N137$$"
	And I click the button named "FormPostAndClose"
	* Create Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And "List" table contains lines
			| 'Number'                            |
			| '$$NumberGoodsReceipt0903N136$$'    |
			| '$$NumberGoodsReceipt0903N137$$'    |
		And I close all client application windows



# First Goods receipt then Purchase invoice

Scenario: _090313 create Goods receipt for Purchase order with different legal names, Purchase invoice after Goods receipt
# should be created 2 Goods receipt
	* Create Purchase order 140
		When create the first test PO for a test on the creation mechanism based on
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder0903N140$$" variable
		And I delete "$$PurchaseOrder0903N140$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder0903N140$$"
		And I save the window as "$$PurchaseOrder0903N140$$"
		And I click the button named "FormPostAndClose"
	* Create Purchase order 141
		When create the second test PO for a test on the creation mechanism based on
		And I move to "Other" tab
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder0903N141$$" variable
		And I delete "$$PurchaseOrder0903N141$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder0903N141$$"
		And I save the window as "$$PurchaseOrder0903N141$$"
		And I click the button named "FormPostAndClose"
	* Create based on Purchase order 140 and 141 Goods receipt (should be created 2)
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                             |
			| '$$NumberPurchaseOrder0903N140$$'    |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentGoodsReceiptGenerate"
		And I click "Ok" button	
	* Check filling in Goods receipt
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "LegalName" is equal to "Second Company Ferron BP" Then
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903N143$$" variable
			And I delete "$$GoodsReceipt0903N143$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903N143$$"
			And I save the window as "$$GoodsReceipt0903N143$$"
			And "ItemList" table contains lines
				| 'Item'     | 'Quantity'    | 'Item key'    | 'Unit'    | 'Store'       | 'Receipt basis'                 |
				| 'Dress'    | '10,000'      | 'M/White'     | 'pcs'     | 'Store 02'    | '$$PurchaseOrder0903N141$$'     |
		If the field named "LegalName" is equal to "Company Ferron BP" Then
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903N142$$" variable
			And I delete "$$GoodsReceipt0903N142$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903N142$$"
			And I save the window as "$$GoodsReceipt0903N142$$"
			And "ItemList" table contains lines
				| 'Item'        | 'Quantity'    | 'Item key'     | 'Unit'    | 'Store'       | 'Receipt basis'                 |
				| 'Dress'       | '20,000'      | 'M/White'      | 'pcs'     | 'Store 02'    | '$$PurchaseOrder0903N140$$'     |
				| 'Dress'       | '20,000'      | 'L/Green'      | 'pcs'     | 'Store 02'    | '$$PurchaseOrder0903N140$$'     |
				| 'Trousers'    | '30,000'      | '36/Yellow'    | 'pcs'     | 'Store 02'    | '$$PurchaseOrder0903N140$$'     |
	And I click the button named "FormPostAndClose"
	When I click command interface button "Goods receipt (create)"
	* Check filling in Goods receipt
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "LegalName" is equal to "Second Company Ferron BP" Then
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903N143$$" variable
			And I delete "$$GoodsReceipt0903N143$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903N143$$"
			And I save the window as "$$GoodsReceipt0903N143$$"
			And "ItemList" table contains lines
				| 'Item'     | 'Quantity'    | 'Item key'    | 'Unit'    | 'Store'       | 'Receipt basis'                 |
				| 'Dress'    | '10,000'      | 'M/White'     | 'pcs'     | 'Store 02'    | '$$PurchaseOrder0903N141$$'     |
		If the field named "LegalName" is equal to "Company Ferron BP" Then
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903N142$$" variable
			And I delete "$$GoodsReceipt0903N142$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903N142$$"
			And I save the window as "$$GoodsReceipt0903N142$$"
			And "ItemList" table contains lines
				| 'Item'        | 'Quantity'    | 'Item key'     | 'Unit'    | 'Store'       | 'Receipt basis'                 |
				| 'Dress'       | '20,000'      | 'M/White'      | 'pcs'     | 'Store 02'    | '$$PurchaseOrder0903N140$$'     |
				| 'Dress'       | '20,000'      | 'L/Green'      | 'pcs'     | 'Store 02'    | '$$PurchaseOrder0903N140$$'     |
				| 'Trousers'    | '30,000'      | '36/Yellow'    | 'pcs'     | 'Store 02'    | '$$PurchaseOrder0903N140$$'     |
	And I click the button named "FormPostAndClose"
	* Create Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And "List" table contains lines
			| 'Number'                            |
			| '$$NumberGoodsReceipt0903N142$$'    |
			| '$$NumberGoodsReceipt0903N143$$'    |
		And I close all client application windows



Scenario: _090314 create Goods receipt for several Purchase order with different partners of the same legal name, Purchase invoice after Goods receipt
# should be created 2 Goods receipt
	* Create first test PO 142
		When create the first test PO for a test on the creation mechanism based on
		* Filling in vendor info
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
				| Description         |
				| Vendor Ferron 1     |
			And I select current line in "List" table
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description     |
				| Store 02        |
			And I select current line in "List" table
			And I move to "Other" tab
			And I expand "More" group
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
			And I input "200" text in "Price" field of "ItemList" table
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'L/Green'     |
			And I input "210" text in "Price" field of "ItemList" table
			And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '36/Yellow'    |
			And I input "210" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder0903N142$$" variable
		And I delete "$$PurchaseOrder0903N142$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder0903N142$$"
		And I save the window as "$$PurchaseOrder0903N142$$"
		And I click the button named "FormPostAndClose"
	* Create second test PO 143
		When create the second test PO for a test on the creation mechanism based on
		* Filling in vendor info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description          |
				| Partner Ferron 2     |
			And I select current line in "List" table
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description                 |
				| Vendor Ferron Partner 2     |
			And I select current line in "List" table
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description     |
				| Store 02        |
			And I select current line in "List" table
			And I move to "Other" tab
			And I expand "More" group
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
			And I input "200" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder0903N143$$" variable
		And I delete "$$PurchaseOrder0903N143$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder0903N143$$"
		And I save the window as "$$PurchaseOrder0903N143$$"
		And I click the button named "FormPostAndClose"
	* Create based on Purchase order 142 and 143 Goods receipt (should be created 2)
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                             |
			| '$$NumberPurchaseOrder0903N142$$'    |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentGoodsReceiptGenerate"
		And I click "Ok" button	
	* Check filling in Goods receipt
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		If the field named "Partner" is equal to "Partner Ferron 2" Then
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903N154$$" variable
			And I delete "$$GoodsReceipt0903N154$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903N154$$"
			And I save the window as "$$GoodsReceipt0903N154$$"
			And "ItemList" table contains lines
				| 'Item'     | 'Quantity'    | 'Item key'    | 'Unit'    | 'Store'       | 'Receipt basis'                 |
				| 'Dress'    | '10,000'      | 'M/White'     | 'pcs'     | 'Store 02'    | '$$PurchaseOrder0903N143$$'     |
		If the field named "Partner" is equal to "Partner Ferron 1" Then
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903N155$$" variable
			And I delete "$$GoodsReceipt0903N155$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903N155$$"
			And I save the window as "$$GoodsReceipt0903N155$$"
			And "ItemList" table contains lines
				| 'Item'        | 'Quantity'    | 'Item key'     | 'Unit'    | 'Store'       | 'Receipt basis'                 |
				| 'Dress'       | '20,000'      | 'M/White'      | 'pcs'     | 'Store 02'    | '$$PurchaseOrder0903N142$$'     |
				| 'Dress'       | '20,000'      | 'L/Green'      | 'pcs'     | 'Store 02'    | '$$PurchaseOrder0903N142$$'     |
				| 'Trousers'    | '30,000'      | '36/Yellow'    | 'pcs'     | 'Store 02'    | '$$PurchaseOrder0903N142$$'     |
	And I click the button named "FormPostAndClose"
	When I click command interface button "Goods receipt (create)"	
	* Check filling in Goods receipt
		If the field named "Partner" is equal to "Partner Ferron 2" Then
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903N154$$" variable
			And I delete "$$GoodsReceipt0903N154$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903N154$$"
			And I save the window as "$$GoodsReceipt0903N154$$"
			And "ItemList" table contains lines
				| 'Item'     | 'Quantity'    | 'Item key'    | 'Unit'    | 'Store'       | 'Receipt basis'                 |
				| 'Dress'    | '10,000'      | 'M/White'     | 'pcs'     | 'Store 02'    | '$$PurchaseOrder0903N143$$'     |
		If the field named "Partner" is equal to "Partner Ferron 1" Then
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903N155$$" variable
			And I delete "$$GoodsReceipt0903N155$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903N155$$"
			And I save the window as "$$GoodsReceipt0903N155$$"
			And "ItemList" table contains lines
				| 'Item'        | 'Quantity'    | 'Item key'     | 'Unit'    | 'Store'       | 'Receipt basis'                 |
				| 'Dress'       | '20,000'      | 'M/White'      | 'pcs'     | 'Store 02'    | '$$PurchaseOrder0903N142$$'     |
				| 'Dress'       | '20,000'      | 'L/Green'      | 'pcs'     | 'Store 02'    | '$$PurchaseOrder0903N142$$'     |
				| 'Trousers'    | '30,000'      | '36/Yellow'    | 'pcs'     | 'Store 02'    | '$$PurchaseOrder0903N142$$'     |
	And I click the button named "FormPostAndClose"
	* Create Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And "List" table contains lines
			| 'Number'                            |
			| '$$NumberGoodsReceipt0903N154$$'    |
			| '$$NumberGoodsReceipt0903N155$$'    |
		And I close all client application windows

Scenario: _090315 create Goods receipt for several Purchase order with different partner terms, Purchase invoice after Goods receipt
# should be created 1 Goods receipt
	* Create first test PO 144
		When create the first test PO for a test on the creation mechanism based on
		* Filling in vendor info
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
				| Description         |
				| Vendor Ferron 1     |
			And I select current line in "List" table
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description     |
				| Store 02        |
			And I select current line in "List" table
			And I move to "Other" tab
			And I expand "More" group
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
			And I input "200" text in "Price" field of "ItemList" table
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'L/Green'     |
			And I input "210" text in "Price" field of "ItemList" table
			And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '36/Yellow'    |
			And I input "210" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder0903N144$$" variable
		And I delete "$$PurchaseOrder0903N144$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder0903N144$$"
		And I save the window as "$$PurchaseOrder0903N144$$"
		And I click the button named "FormPostAndClose"
	* Create second test PO 145 Partner Ferron 1 with partner term Vendor Ferron Discount
		When create the second test PO for a test on the creation mechanism based on
		* Filling in vendor info
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
				| Description                |
				| Vendor Ferron Discount     |
			And I select current line in "List" table
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description     |
				| Store 02        |
			And I select current line in "List" table
			And I move to "Other" tab
			And I expand "More" group
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
			And I input "200" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder0903N145$$" variable
		And I delete "$$PurchaseOrder0903N145$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder0903N145$$"
		And I save the window as "$$PurchaseOrder0903N145$$"
		And I click the button named "FormPostAndClose"
	* Create based on Purchase order 144 and 145 Goods receipt (should be created 2)
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                             |
			| '$$NumberPurchaseOrder0903N144$$'    |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentGoodsReceiptGenerate"
		And I click "Ok" button	
	* Check filling in Goods receipt
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And I save number of "ItemList" table lines as "N"
		And I click the button named "FormPost"
		And I delete "$$NumberGoodsReceipt0903N144$$" variable
		And I delete "$$GoodsReceipt0903N144$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt0903N144$$"
		And I save the window as "$$GoodsReceipt0903N144$$"
		And "ItemList" table contains lines
		| 'Item'      | 'Quantity'  | 'Item key'   | 'Unit'  | 'Store'     | 'Receipt basis'               |
		| 'Dress'     | '20,000'    | 'M/White'    | 'pcs'   | 'Store 02'  | '$$PurchaseOrder0903N144$$'   |
		| 'Dress'     | '20,000'    | 'L/Green'    | 'pcs'   | 'Store 02'  | '$$PurchaseOrder0903N144$$'   |
		| 'Trousers'  | '30,000'    | '36/Yellow'  | 'pcs'   | 'Store 02'  | '$$PurchaseOrder0903N144$$'   |
		| 'Dress'     | '10,000'    | 'M/White'    | 'pcs'   | 'Store 02'  | '$$PurchaseOrder0903N145$$'   |
	And I click the button named "FormPostAndClose"
	* Check created Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And "List" table contains lines
			| 'Number'                            |
			| '$$NumberGoodsReceipt0903N144$$'    |
		And I close all client application windows



Scenario: _090316 create Goods receipt for several Purchase order with different stores, Purchase invoice after Goods receipt
# should be created 1 Goods receipt
	* Create first test PO 146
		When create the first test PO for a test on the creation mechanism based on
		* Filling in vendor info
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
				| Description                |
				| Vendor Ferron Discount     |
			And I select current line in "List" table
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description     |
				| Store 03        |
			And I select current line in "List" table
			And I click "OK" button
			And I move to "Other" tab
			And I expand "More" group
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
			And I input "200" text in "Price" field of "ItemList" table
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'L/Green'     |
			And I input "210" text in "Price" field of "ItemList" table
			And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '36/Yellow'    |
			And I input "210" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder0903N146$$" variable
		And I delete "$$PurchaseOrder0903N146$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder0903N146$$"
		And I save the window as "$$PurchaseOrder0903N146$$"
		And I click the button named "FormPostAndClose"
	* Create second test PO 147
		When create the second test PO for a test on the creation mechanism based on
		* Filling in vendor info
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
				| Description                |
				| Vendor Ferron Discount     |
			And I select current line in "List" table
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description     |
				| Store 02        |
			And I select current line in "List" table
			And I move to "Other" tab
			And I expand "More" group
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
			And I input "200" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder0903N147$$" variable
		And I delete "$$PurchaseOrder0903N147$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder0903N147$$"
		And I save the window as "$$PurchaseOrder0903N147$$"
		And I click the button named "FormPostAndClose"
	* Create based on Purchase order 146 and 147 Goods receipt (should be created 2)
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                             |
			| '$$NumberPurchaseOrder0903N146$$'    |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentGoodsReceiptGenerate"
		And I click "Ok" button	
	* Check filling in Goods receipt
		Then the form attribute named "Company" became equal to "Main Company"
		And "ItemList" table contains lines
			| 'Item'       | 'Quantity'   | 'Item key'    | 'Unit'   | 'Store'      | 'Receipt basis'                |
			| 'Dress'      | '20,000'     | 'M/White'     | 'pcs'    | 'Store 03'   | '$$PurchaseOrder0903N146$$'    |
			| 'Dress'      | '20,000'     | 'L/Green'     | 'pcs'    | 'Store 03'   | '$$PurchaseOrder0903N146$$'    |
			| 'Trousers'   | '30,000'     | '36/Yellow'   | 'pcs'    | 'Store 03'   | '$$PurchaseOrder0903N146$$'    |
			| 'Dress'      | '10,000'     | 'M/White'     | 'pcs'    | 'Store 02'   | '$$PurchaseOrder0903N147$$'    |
		And I click the button named "FormPost"
		And I delete "$$NumberGoodsReceipt0903N146$$" variable
		And I delete "$$GoodsReceipt0903N146$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt0903N146$$"
		And I save the window as "$$GoodsReceipt0903N146$$"
	And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/AccumulationRegister.R4031B_GoodsInTransitIncoming"
		And "List" table contains lines
		| 'Quantity'  | 'Basis'                     | 'Store'     | 'Item key'    |
		| '20,000'    | '$$GoodsReceipt0903N146$$'  | 'Store 03'  | 'M/White'     |
		| '20,000'    | '$$GoodsReceipt0903N146$$'  | 'Store 03'  | 'L/Green'     |
		| '30,000'    | '$$GoodsReceipt0903N146$$'  | 'Store 03'  | '36/Yellow'   |
		| '10,000'    | '$$GoodsReceipt0903N146$$'  | 'Store 02'  | 'M/White'     |
		And Delay 5
	And I close all client application windows

Scenario: _090317 create Goods receipt for several Purchase order with different own companies using an indirect shipping scheme
# should be created 2 Goods receipt
	* Create first test PO 148
		When create the first test PO for a test on the creation mechanism based on
		* Filling in vendor info
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
				| Description                |
				| Vendor Ferron Discount     |
			And I select current line in "List" table
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description     |
				| Store 02        |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description        |
				| Second Company     |
			And I select current line in "List" table
			And I move to "Other" tab
			And I expand "More" group
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
			And I input "200" text in "Price" field of "ItemList" table
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'L/Green'     |
			And I input "210" text in "Price" field of "ItemList" table
			And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '36/Yellow'    |
			And I input "210" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder0903N148$$" variable
		And I delete "$$PurchaseOrder0903N148$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder0903N148$$"
		And I save the window as "$$PurchaseOrder0903N148$$"
		And I click the button named "FormPostAndClose"
	* Create second test PO 149
		When create the second test PO for a test on the creation mechanism based on
		* Filling in vendor info
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
				| Description                |
				| Vendor Ferron Discount     |
			And I select current line in "List" table
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description     |
				| Store 02        |
			And I select current line in "List" table
			And I move to "Other" tab
			And I expand "More" group
			And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
			And I input "200" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder0903N149$$" variable
		And I delete "$$PurchaseOrder0903N149$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder0903N149$$"
		And I save the window as "$$PurchaseOrder0903N149$$"
		And I click the button named "FormPostAndClose"
	* Create Goods receipt
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                             |
			| '$$NumberPurchaseOrder0903N149$$'    |
		And I move one line up in "List" table and select line
		And I click the button named "FormDocumentGoodsReceiptGenerate"
		And I click "Ok" button	
	* Check filling in Goods receipt
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "Company" is equal to "Main Company" Then
			And "ItemList" table contains lines
				| 'Item'     | 'Quantity'    | 'Item key'    | 'Unit'    | 'Store'       | 'Receipt basis'                 |
				| 'Dress'    | '10,000'      | 'M/White'     | 'pcs'     | 'Store 02'    | '$$PurchaseOrder0903N149$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903N149$$" variable
			And I delete "$$GoodsReceipt0903N149$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903N149$$"
			And I save the window as "$$GoodsReceipt0903N149$$"
		If the field named "Company" is equal to "Second Company" Then
			And "ItemList" table contains lines
			| 'Item'       | 'Quantity'   | 'Item key'    | 'Unit'   | 'Store'      | 'Receipt basis'                |
			| 'Dress'      | '20,000'     | 'M/White'     | 'pcs'    | 'Store 02'   | '$$PurchaseOrder0903N148$$'    |
			| 'Dress'      | '20,000'     | 'L/Green'     | 'pcs'    | 'Store 02'   | '$$PurchaseOrder0903N148$$'    |
			| 'Trousers'   | '30,000'     | '36/Yellow'   | 'pcs'    | 'Store 02'   | '$$PurchaseOrder0903N148$$'    |
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903N148$$" variable
			And I delete "$$GoodsReceipt0903N148$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903N148$$"
			And I save the window as "$$GoodsReceipt0903N148$$"
	And I click the button named "FormPostAndClose"
	When I click command interface button "Goods receipt (create)"
	* Check filling in second Goods receipt
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "Company" is equal to "Main Company" Then
			And "ItemList" table contains lines
				| 'Item'     | 'Quantity'    | 'Item key'    | 'Unit'    | 'Store'       | 'Receipt basis'                 |
				| 'Dress'    | '10,000'      | 'M/White'     | 'pcs'     | 'Store 02'    | '$$PurchaseOrder0903N149$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903N149$$" variable
			And I delete "$$GoodsReceipt0903N149$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903N149$$"
			And I save the window as "$$GoodsReceipt0903N149$$"
		If the field named "Company" is equal to "Second Company" Then
			And "ItemList" table contains lines
			| 'Item'       | 'Quantity'   | 'Item key'    | 'Unit'   | 'Store'      | 'Receipt basis'                |
			| 'Dress'      | '20,000'     | 'M/White'     | 'pcs'    | 'Store 02'   | '$$PurchaseOrder0903N148$$'    |
			| 'Dress'      | '20,000'     | 'L/Green'     | 'pcs'    | 'Store 02'   | '$$PurchaseOrder0903N148$$'    |
			| 'Trousers'   | '30,000'     | '36/Yellow'   | 'pcs'    | 'Store 02'   | '$$PurchaseOrder0903N148$$'    |
			And I click the button named "FormPost"
			And I delete "$$NumberGoodsReceipt0903N148$$" variable
			And I delete "$$GoodsReceipt0903N148$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt0903N148$$"
			And I save the window as "$$GoodsReceipt0903N148$$"
	And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/AccumulationRegister.R4031B_GoodsInTransitIncoming"
		And "List" table contains lines
		| 'Quantity'  | 'Basis'                     | 'Store'     | 'Item key'    |
		| '20,000'    | '$$GoodsReceipt0903N148$$'  | 'Store 02'  | 'M/White'     |
		| '20,000'    | '$$GoodsReceipt0903N148$$'  | 'Store 02'  | 'L/Green'     |
		| '30,000'    | '$$GoodsReceipt0903N148$$'  | 'Store 02'  | '36/Yellow'   |
		| '10,000'    | '$$GoodsReceipt0903N149$$'  | 'Store 02'  | 'M/White'     |
		And Delay 5
		And I close all client application windows


Scenario: _090318 create Purchase invoice for several Purchase order with different contractors according to an indirect shipping scheme
# should be created 2 Purchase invoice
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I go to line in "List" table
			| 'Number'                             |
			| '$$NumberPurchaseOrder0903N140$$'    |
	And I move one line down in "List" table and select line
	And I click the button named "FormDocumentPurchaseInvoiceGenerate"
	And I click "Ok" button
	* Check filling in Purchase invoice 142
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "LegalName" is equal to "Second Company Ferron BP" Then
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice0903N142$$" variable
			And I delete "$$PurchaseInvoice0903N142$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0903N142$$"
			And I save the window as "$$PurchaseInvoice0903N142$$"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Item'     | 'Price'     | 'Item key'    | 'Store'       | 'Unit'    | 'Quantity'    | 'Total amount'    | 'Purchase order'                |
				| 'Dress'    | '200,00'    | 'M/White'     | 'Store 02'    | 'pcs'     | '10,000'      | '2 000,00'        | '$$PurchaseOrder0903N141$$'     |
		If the field named "LegalName" is equal to "Company Ferron BP" Then
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice0903N143$$" variable
			And I delete "$$PurchaseInvoice0903N143$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0903N143$$"
			And I save the window as "$$PurchaseInvoice0903N143$$"
			And "ItemList" table contains lines
			| 'Item'       | 'Price'    | 'Item key'    | 'Quantity'   | 'Unit'   | 'Total amount'   | 'Store'      | 'Delivery date'   | 'Purchase order'               |
			| 'Trousers'   | '210,00'   | '36/Yellow'   | '30,000'     | 'pcs'    | '6 300,00'       | 'Store 02'   | '*'               | '$$PurchaseOrder0903N140$$'    |
			| 'Dress'      | '200,00'   | 'M/White'     | '20,000'     | 'pcs'    | '4 000,00'       | 'Store 02'   | '*'               | '$$PurchaseOrder0903N140$$'    |
			| 'Dress'      | '210,00'   | 'L/Green'     | '20,000'     | 'pcs'    | '4 200,00'       | 'Store 02'   | '*'               | '$$PurchaseOrder0903N140$$'    |
	And I click the button named "FormPostAndClose"
	When I click command interface button "Purchase invoice (create)"
	* Check filling in second Purchase invoice
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "LegalName" is equal to "Second Company Ferron BP" Then
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice0903N142$$" variable
			And I delete "$$PurchaseInvoice0903N142$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0903N142$$"
			And I save the window as "$$PurchaseInvoice0903N142$$"
			And "ItemList" table contains lines
				| 'Item'     | 'Price'     | 'Item key'    | 'Store'       | 'Unit'    | 'Quantity'    | 'Total amount'    | 'Purchase order'                |
				| 'Dress'    | '200,00'    | 'M/White'     | 'Store 02'    | 'pcs'     | '10,000'      | '2 000,00'        | '$$PurchaseOrder0903N141$$'     |
		If the field named "LegalName" is equal to "Company Ferron BP" Then
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice0903N143$$" variable
			And I delete "$$PurchaseInvoice0903N143$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0903N143$$"
			And I save the window as "$$PurchaseInvoice0903N143$$"
			And "ItemList" table contains lines
			| 'Item'       | 'Price'    | 'Item key'    | 'Quantity'   | 'Unit'   | 'Total amount'   | 'Store'      | 'Delivery date'   | 'Purchase order'               |
			| 'Trousers'   | '210,00'   | '36/Yellow'   | '30,000'     | 'pcs'    | '6 300,00'       | 'Store 02'   | '*'               | '$$PurchaseOrder0903N140$$'    |
			| 'Dress'      | '200,00'   | 'M/White'     | '20,000'     | 'pcs'    | '4 000,00'       | 'Store 02'   | '*'               | '$$PurchaseOrder0903N140$$'    |
			| 'Dress'      | '210,00'   | 'L/Green'     | '20,000'     | 'pcs'    | '4 200,00'       | 'Store 02'   | '*'               | '$$PurchaseOrder0903N140$$'    |
	And I click the button named "FormPostAndClose"
	And I close all client application windows
	* Create Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And "List" table contains lines
			| 'Number'                               |
			| '$$NumberPurchaseInvoice0903N142$$'    |
			| '$$NumberPurchaseInvoice0903N143$$'    |
		And I close all client application windows



Scenario: _090319 create Purchase invoice for several Purchase order with different partners of the same legal name, Purchase invoice after Goods receipt
	# should be created 2 Purchase invoice
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I go to line in "List" table
			| 'Number'                             |
			| '$$NumberPurchaseOrder0903N142$$'    |
	And I move one line down in "List" table and select line
	And I click the button named "FormDocumentPurchaseInvoiceGenerate"
	And I click "Ok" button
	* Check filling in Purchase invoice 145
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "Partner" is equal to "Partner Ferron 2" Then
			Then the form attribute named "Agreement" became equal to "Vendor Ferron Partner 2"
			And "ItemList" table contains lines
				| 'Item'     | 'Price'     | 'Item key'    | 'Store'       | 'Unit'    | 'Quantity'    | 'Total amount'    | 'Purchase order'                |
				| 'Dress'    | '200,00'    | 'M/White'     | 'Store 02'    | 'pcs'     | '10,000'      | '2 360,00'        | '$$PurchaseOrder0903N143$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice0903N154$$" variable
			And I delete "$$PurchaseInvoice0903N154$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0903N154$$"
			And I save the window as "$$PurchaseInvoice0903N154$$"
		If the field named "Partner" is equal to "Partner Ferron 1" Then
			Then the form attribute named "Agreement" became equal to "Vendor Ferron 1"
			And "ItemList" table contains lines
				| 'Item'        | 'Price'     | 'Item key'     | 'Store'       | 'Unit'    | 'Quantity'    | 'Total amount'    | 'Purchase order'                |
				| 'Dress'       | '200,00'    | 'M/White'      | 'Store 02'    | 'pcs'     | '20,000'      | '4 720,00'        | '$$PurchaseOrder0903N142$$'     |
				| 'Dress'       | '210,00'    | 'L/Green'      | 'Store 02'    | 'pcs'     | '20,000'      | '4 956,00'        | '$$PurchaseOrder0903N142$$'     |
				| 'Trousers'    | '210,00'    | '36/Yellow'    | 'Store 02'    | 'pcs'     | '30,000'      | '7 434,00'        | '$$PurchaseOrder0903N142$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice0903N155$$" variable
			And I delete "$$PurchaseInvoice0903N155$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0903N155$$"
			And I save the window as "$$PurchaseInvoice0903N155$$"
	And I click the button named "FormPostAndClose"
	When I click command interface button "Purchase invoice (create)"
	* Check filling in Purchase invoice 146
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "Partner" is equal to "Partner Ferron 2" Then
			Then the form attribute named "Agreement" became equal to "Vendor Ferron Partner 2"
			And "ItemList" table contains lines
				| 'Item'     | 'Price'     | 'Item key'    | 'Store'       | 'Unit'    | 'Quantity'    | 'Total amount'    | 'Purchase order'                |
				| 'Dress'    | '200,00'    | 'M/White'     | 'Store 02'    | 'pcs'     | '10,000'      | '2 360,00'        | '$$PurchaseOrder0903N143$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice0903N154$$" variable
			And I delete "$$PurchaseInvoice0903N154$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0903N154$$"
			And I save the window as "$$PurchaseInvoice0903N154$$"
		If the field named "Partner" is equal to "Partner Ferron 1" Then
			Then the form attribute named "Agreement" became equal to "Vendor Ferron 1"
			And "ItemList" table contains lines
				| 'Item'        | 'Price'     | 'Item key'     | 'Store'       | 'Unit'    | 'Quantity'    | 'Total amount'    | 'Purchase order'                |
				| 'Dress'       | '200,00'    | 'M/White'      | 'Store 02'    | 'pcs'     | '20,000'      | '4 720,00'        | '$$PurchaseOrder0903N142$$'     |
				| 'Dress'       | '210,00'    | 'L/Green'      | 'Store 02'    | 'pcs'     | '20,000'      | '4 956,00'        | '$$PurchaseOrder0903N142$$'     |
				| 'Trousers'    | '210,00'    | '36/Yellow'    | 'Store 02'    | 'pcs'     | '30,000'      | '7 434,00'        | '$$PurchaseOrder0903N142$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice0903N155$$" variable
			And I delete "$$PurchaseInvoice0903N155$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0903N155$$"
			And I save the window as "$$PurchaseInvoice0903N155$$"
	And I click the button named "FormPostAndClose"
	And I close all client application windows
	* Create Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click "Refresh" button
		And "List" table contains lines
			| 'Number'                               |
			| '$$NumberPurchaseInvoice0903N155$$'    |
			| '$$NumberPurchaseInvoice0903N154$$'    |
		And I close all client application windows

Scenario: _090320 create Purchase invoice for several Purchase order with different partner terms, Purchase invoice after Goods receipt
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I go to line in "List" table
			| 'Number'                             |
			| '$$NumberPurchaseOrder0903N144$$'    |
	And I move one line down in "List" table and select line
	And I click the button named "FormDocumentPurchaseInvoiceGenerate"
	And I click "Ok" button
	* Check filling in Purchase invoice 145
		Then the form attribute named "Partner" became equal to "Partner Ferron 1"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And I save number of "ItemList" table lines as "N"
		If "N" variable is equal to 1 Then
			Then the form attribute named "Agreement" became equal to "Vendor Ferron Discount"
			And "ItemList" table contains lines
			| 'Price'    | 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'   | 'Total amount'   | 'Store'      | 'Purchase order'               |
			| '200,00'   | 'Dress'   | 'M/White'    | '10,000'     | 'pcs'    | '2 360,00'       | 'Store 02'   | '$$PurchaseOrder0903N145$$'    |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice0903N148$$" variable
			And I delete "$$PurchaseInvoice0903N148$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0903N148$$"
			And I save the window as "$$PurchaseInvoice0903N148$$"
		If "N" variable is equal to 3 Then
			Then the form attribute named "Agreement" became equal to "Vendor Ferron 1"
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Tax amount'    | 'Net amount'    | 'Total amount'    | 'Store'       | 'Purchase order'                |
				| '200,00'    | 'Dress'       | '18%'    | 'M/White'      | '20,000'      | 'pcs'     | '720,00'        | '4 000,00'      | '4 720,00'        | 'Store 02'    | '$$PurchaseOrder0903N144$$'     |
				| '210,00'    | 'Dress'       | '18%'    | 'L/Green'      | '20,000'      | 'pcs'     | '756,00'        | '4 200,00'      | '4 956,00'        | 'Store 02'    | '$$PurchaseOrder0903N144$$'     |
				| '210,00'    | 'Trousers'    | '18%'    | '36/Yellow'    | '30,000'      | 'pcs'     | '1 134,00'      | '6 300,00'      | '7 434,00'        | 'Store 02'    | '$$PurchaseOrder0903N144$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice0903N147$$" variable
			And I delete "$$PurchaseInvoice0903N147$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0903N147$$"
			And I save the window as "$$PurchaseInvoice0903N147$$"
		And I click the button named "FormPostAndClose"
	When I click command interface button "Purchase invoice (create)"
	* Check filling in Purchase invoice 144
		Then the form attribute named "Partner" became equal to "Partner Ferron 1"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And I save number of "ItemList" table lines as "N"
		If "N" variable is equal to 1 Then
			Then the form attribute named "Agreement" became equal to "Vendor Ferron Discount"
			And "ItemList" table contains lines
			| 'Price'    | 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'   | 'Total amount'   | 'Store'      | 'Purchase order'              | 'Goods receipt'               |
			| '200,00'   | 'Dress'   | 'M/White'    | '10,000'     | 'pcs'    | '2 360,00'       | 'Store 02'   | '$$PurchaseOrder0903N145$$'   | '$$GoodsReceipt0903N145$$'    |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice0903N148$$" variable
			And I delete "$$PurchaseInvoice0903N148$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0903N148$$"
			And I save the window as "$$PurchaseInvoice0903N148$$"
		If "N" variable is equal to 3 Then
			Then the form attribute named "Agreement" became equal to "Vendor Ferron 1"
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Tax amount'    | 'Net amount'    | 'Total amount'    | 'Store'       | 'Purchase order'                |
				| '200,00'    | 'Dress'       | '18%'    | 'M/White'      | '20,000'      | 'pcs'     | '720,00'        | '4 000,00'      | '4 720,00'        | 'Store 02'    | '$$PurchaseOrder0903N144$$'     |
				| '210,00'    | 'Dress'       | '18%'    | 'L/Green'      | '20,000'      | 'pcs'     | '756,00'        | '4 200,00'      | '4 956,00'        | 'Store 02'    | '$$PurchaseOrder0903N144$$'     |
				| '210,00'    | 'Trousers'    | '18%'    | '36/Yellow'    | '30,000'      | 'pcs'     | '1 134,00'      | '6 300,00'      | '7 434,00'        | 'Store 02'    | '$$PurchaseOrder0903N144$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice0903N147$$" variable
			And I delete "$$PurchaseInvoice0903N147$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0903N147$$"
			And I save the window as "$$PurchaseInvoice0903N147$$"
		And I click the button named "FormPostAndClose"
	* Create Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click "Refresh" button
		And "List" table contains lines
			| 'Number'                               |
			| '$$NumberPurchaseInvoice0903N147$$'    |
			| '$$NumberPurchaseInvoice0903N148$$'    |
		And I close all client application windows



Scenario: _090322 create Purchase invoice for several Purchase order with different companies, Purchase invoice after Goods receipt
# should be created 2 Purchase invoice
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I go to line in "List" table
			| 'Number'                             |
			| '$$NumberPurchaseOrder0903N148$$'    |
	And I move one line down in "List" table and select line
	And I click the button named "FormDocumentPurchaseInvoiceGenerate"
	And I click "Ok" button
	* Check filling in Purchase invoice 148
		Then the form attribute named "Partner" became equal to "Partner Ferron 1"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron Discount"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "Company" is equal to "Main Company" Then
			And "ItemList" table contains lines
				| 'Item'     | 'Price'     | 'Item key'    | 'Store'       | 'Unit'    | 'Quantity'    | 'Total amount'    | 'Purchase order'                |
				| 'Dress'    | '200,00'    | 'M/White'     | 'Store 02'    | 'pcs'     | '10,000'      | '2 360,00'        | '$$PurchaseOrder0903N149$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice0903N149$$" variable
			And I delete "$$PurchaseInvoice0903N149$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0903N149$$"
			And I save the window as "$$PurchaseInvoice0903N149$$"
		If the field named "Company" is equal to "Second Company" Then
			And "ItemList" table contains lines
				| 'Item'        | 'Price'     | 'Item key'     | 'Store'       | 'Unit'    | 'Quantity'    | 'Offers amount'    | 'Total amount'    | 'Purchase order'                |
				| 'Dress'       | '200,00'    | 'M/White'      | 'Store 02'    | 'pcs'     | '20,000'      | ''                 | '4 000,00'        | '$$PurchaseOrder0903N148$$'     |
				| 'Dress'       | '210,00'    | 'L/Green'      | 'Store 02'    | 'pcs'     | '20,000'      | ''                 | '4 200,00'        | '$$PurchaseOrder0903N148$$'     |
				| 'Trousers'    | '210,00'    | '36/Yellow'    | 'Store 02'    | 'pcs'     | '30,000'      | ''                 | '6 300,00'        | '$$PurchaseOrder0903N148$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice0903N150$$" variable
			And I delete "$$PurchaseInvoice0903N150$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0903N150$$"
			And I save the window as "$$PurchaseInvoice0903N150$$"
	And I click the button named "FormPostAndClose"
	When I click command interface button "Purchase invoice (create)"
	* Check filling in second Purchase invoice 149
		Then the form attribute named "Partner" became equal to "Partner Ferron 1"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron Discount"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "Company" is equal to "Main Company" Then
			And "ItemList" table contains lines
				| 'Item'     | 'Price'     | 'Item key'    | 'Store'       | 'Unit'    | 'Quantity'    | 'Total amount'    | 'Purchase order'                |
				| 'Dress'    | '200,00'    | 'M/White'     | 'Store 02'    | 'pcs'     | '10,000'      | '2 360,00'        | '$$PurchaseOrder0903N149$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice0903N149$$" variable
			And I delete "$$PurchaseInvoice0903N149$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0903N149$$"
			And I save the window as "$$PurchaseInvoice0903N149$$"
		If the field named "Company" is equal to "Second Company" Then
			And "ItemList" table contains lines
				| 'Item'        | 'Price'     | 'Item key'     | 'Store'       | 'Unit'    | 'Quantity'    | 'Offers amount'    | 'Total amount'    | 'Purchase order'                |
				| 'Dress'       | '200,00'    | 'M/White'      | 'Store 02'    | 'pcs'     | '20,000'      | ''                 | '4 000,00'        | '$$PurchaseOrder0903N148$$'     |
				| 'Dress'       | '210,00'    | 'L/Green'      | 'Store 02'    | 'pcs'     | '20,000'      | ''                 | '4 200,00'        | '$$PurchaseOrder0903N148$$'     |
				| 'Trousers'    | '210,00'    | '36/Yellow'    | 'Store 02'    | 'pcs'     | '30,000'      | ''                 | '6 300,00'        | '$$PurchaseOrder0903N148$$'     |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice0903N150$$" variable
			And I delete "$$PurchaseInvoice0903N150$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0903N150$$"
			And I save the window as "$$PurchaseInvoice0903N150$$"
	And I click the button named "FormPostAndClose"
	* Create Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click "Refresh" button
		And "List" table contains lines
			| 'Number'                               |
			| '$$NumberPurchaseInvoice0903N149$$'    |
			| '$$NumberPurchaseInvoice0903N150$$'    |
		And I close all client application windows

Scenario: _090323 create one Purchase order - several Goods receipt - one Purchase invoice
	* Create Purchase order
		When create the first test PO for a test on the creation mechanism based on
		* Save the document number
			And I delete "$$NumberPurchaseOrder090323$$" variable
			And I delete "$$PurchaseOrder090323$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseOrder090323$$"
			And I save the window as "$$PurchaseOrder090323$$"
			And I click the button named "FormPostAndClose"
	* Create 3 Goods receipt
		* First GR
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			And I go to line in "List" table
				| Number                            |
				| $$NumberPurchaseOrder090323$$     |
			And I click the button named "FormDocumentGoodsReceiptGenerate"
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
			And I delete "$$NumberGoodsReceipte0903231$$" variable
			And I delete "$$GoodsReceipte0903231$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipte0903231$$"
			And I save the window as "$$GoodsReceipte0903231$$"
			And I click the button named "FormPostAndClose"
		* Second GR
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			And I go to line in "List" table
				| Number                            |
				| $$NumberPurchaseOrder090323$$     |
			And I click the button named "FormDocumentGoodsReceiptGenerate"
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
			And I delete "$$NumberGoodsReceipte0903232$$" variable
			And I delete "$$GoodsReceipte0903232$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipte0903232$$"
			And I save the window as "$$GoodsReceipte0903232$$"
			And I click the button named "FormPostAndClose"
		* Third GR
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			And I go to line in "List" table
				| Number                            |
				| $$NumberPurchaseOrder090323$$     |
			And I click the button named "FormDocumentGoodsReceiptGenerate"
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
			And I delete "$$NumberGoodsReceipte0903233$$" variable
			And I delete "$$GoodsReceipte0903233$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipte0903233$$"
			And I save the window as "$$GoodsReceipte0903233$$"
			And I click the button named "FormPostAndClose"
	* Create Purchase invoice for 3 Goods receipt
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| Number                           |
			| $$NumberPurchaseOrder090323$$    |
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Price'    | 'Detail'   | 'Item'       | 'VAT'   | 'Item key'    | 'Quantity'   | 'Offers amount'   | 'Price type'                | 'Unit'   | 'Dont calculate row'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Delivery date'   | 'Expense type'   | 'Profit loss center'   | 'Purchase order'             |
			| '200,00'   | ''         | 'Dress'      | '18%'   | 'M/White'     | '20,000'     | ''                | 'en description is empty'   | 'pcs'    | 'No'                   | '610,17'       | '3 389,83'     | '4 000,00'       | 'Store 02'   | '*'               | ''               | ''                     | '$$PurchaseOrder090323$$'    |
			| '210,00'   | ''         | 'Dress'      | '18%'   | 'L/Green'     | '20,000'     | ''                | 'en description is empty'   | 'pcs'    | 'No'                   | '640,68'       | '3 559,32'     | '4 200,00'       | 'Store 02'   | '*'               | ''               | ''                     | '$$PurchaseOrder090323$$'    |
			| '210,00'   | ''         | 'Trousers'   | '18%'   | '36/Yellow'   | '30,000'     | ''                | 'en description is empty'   | 'pcs'    | 'No'                   | '961,02'       | '5 338,98'     | '6 300,00'       | 'Store 02'   | '*'               | ''               | ''                     | '$$PurchaseOrder090323$$'    |
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseInvoice090323$$" variable
		And I delete "$$PurchaseInvoice090323$$" variable
		And I delete "$$DatePurchaseInvoice090323$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice090323$$"
		And I save the value of the field named "Date" as "$$DatePurchaseInvoice090323$$"
		And I save the window as "$$PurchaseInvoice090323$$"
	* Check movements
		And I click "Registrations report" button		
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$PurchaseInvoice090323$$'                | ''              | ''                                | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''                     | ''                            | ''                          | ''           | ''                       | ''                            |
			| 'Document registrations records'           | ''              | ''                                | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''                     | ''                            | ''                          | ''           | ''                       | ''                            |
			| 'Register  "R1021 Vendors transactions"'   | ''              | ''                                | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''                     | ''                            | ''                          | ''           | ''                       | ''                            |
			| ''                                         | 'Record type'   | 'Period'                          | 'Resources'   | 'Dimensions'     | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''                     | ''                            | ''                          | ''           | 'Attributes'             | ''                            |
			| ''                                         | ''              | ''                                | 'Amount'      | 'Company'        | 'Branch'   | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'          | 'Partner'     | 'Agreement'            | 'Basis'                       | 'Order'                     | 'Project'    | 'Deferred calculation'   | 'Vendors advances closing'    |
			| ''                                         | 'Receipt'       | '$$DatePurchaseInvoice090323$$'   | '2 482,4'     | 'Main Company'   | ''         | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Vendor Ferron, TRY'   | '$$PurchaseInvoice090323$$'   | '$$PurchaseOrder090323$$'   | ''           | 'No'                     | ''                            |
			| ''                                         | 'Receipt'       | '$$DatePurchaseInvoice090323$$'   | '14 500'      | 'Main Company'   | ''         | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Vendor Ferron, TRY'   | '$$PurchaseInvoice090323$$'   | '$$PurchaseOrder090323$$'   | ''           | 'No'                     | ''                            |
			| ''                                         | 'Receipt'       | '$$DatePurchaseInvoice090323$$'   | '14 500'      | 'Main Company'   | ''         | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Vendor Ferron, TRY'   | '$$PurchaseInvoice090323$$'   | '$$PurchaseOrder090323$$'   | ''           | 'No'                     | ''                            |

		And I close all client application windows
