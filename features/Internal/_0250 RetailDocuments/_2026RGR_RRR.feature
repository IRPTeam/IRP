#language: en
@tree
@Positive
@RetailDocuments

Feature: retail sales return (using Retail goods receipt)

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _0202600 preparation (RGR-RRR)
	When set True value to the constant
	* Load info
		When Create catalog BusinessUnits objects
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
		When Create catalog Partners objects (Customer)
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Countries objects
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Partners and Payment type (Bank)
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create PaymentType (advance)
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog Users objects
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers, with batch balance details)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create catalog Partners objects and Companies objects (Customer)
		When Create catalog Agreements objects (Customer)
		When Create information register Taxes records (VAT)
		When Create information register UserSettings records (Retail document)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog RetailCustomers objects (check POS)
		When Create catalog UserGroups objects
	* Create payment terminal
		When Create catalog PaymentTerminals objects
	* Create PaymentTypes
		When Create catalog PaymentTypes objects
	* Create BankTerms
		When Create catalog BankTerms objects (for retail)	
	* Workstation
		When create Workstation
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
	* Load RSR
		When create RetailSalesReceipt objects for RGR
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(1203).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(1204).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load RGR
		When create RetailGoodsReceipt objects with Retail return receipt
		And I execute 1C:Enterprise script at server
			| "Documents.RetailGoodsReceipt.FindByNumber(1204).GetObject().Write(DocumentWriteMode.Posting);"    |
		
	
Scenario: _0202601 create RGR based on RSR
	And I close all client application windows
	* Select RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '1 203'  |
		And I click the button named "FormDocumentRetailGoodsReceiptGenerate"
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '520,00' | '1,000'    | 'Dress (XS/Blue)'  | 'pcs'  | 'Yes' |
		And I remove "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
	* Check RGR
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "RetailCustomer" became equal to "Sam Jons"
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "TransactionType" became equal to "Return from customer"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#' | 'Retail sales receipt'                                 | 'Item'  | 'Item key' | 'Serial lot numbers' | 'Unit' | 'Source of origins' | 'Quantity' | 'Store'    | 'Sales order' |
			| '1' | 'Retail sales receipt 1 203 dated 02.08.2023 14:36:25' | 'Shirt' | '38/Black' | ''                   | 'pcs'  | ''                  | '2,000'    | 'Store 01' | ''            |
			| '2' | 'Retail sales receipt 1 203 dated 02.08.2023 14:36:25' | 'Dress' | 'L/Green'  | ''                   | 'pcs'  | ''                  | '1,000'    | 'Store 01' | ''            |
	* Filling branch
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
	* Check linked documents
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I set checkbox "Linked documents"
		And "ResultsTree" table became equal
			| 'Row presentation'                                     | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Retail sales receipt 1 203 dated 02.08.2023 14:36:25' | ''         | ''     | ''       | ''         |
			| 'Shirt (38/Black)'                                     | '2,000'    | 'pcs'  | '350,00' | 'TRY'      |
			| 'Dress (L/Green)'                                      | '1,000'    | 'pcs'  | '550,00' | 'TRY'      |
	* Unlink 
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table became equal
			| '#' | 'Retail sales receipt' | 'Item'  | 'Item key' | 'Serial lot numbers' | 'Unit' | 'Source of origins' | 'Quantity' | 'Store'    | 'Sales order' |
			| '1' | ''                     | 'Shirt' | '38/Black' | ''                   | 'pcs'  | ''                  | '2,000'    | 'Store 01' | ''            |
			| '2' | ''                     | 'Dress' | 'L/Green'  | ''                   | 'pcs'  | ''                  | '1,000'    | 'Store 01' | ''            |
	* Link back
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '2' | '1,000'    | 'Dress (L/Green)'  | 'Store 01' | 'pcs'  |
		And I go to line in "BasisesTree" table
			| 'Row presentation'                                     |
			| 'Retail sales receipt 1 203 dated 02.08.2023 14:36:25' |	
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '550,00' | '1,000'    | 'Dress (L/Green)'  | 'pcs'  |
		And I click the button named "Link"
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '1' | '2,000'    | 'Shirt (38/Black)' | 'Store 01' | 'pcs'  |
		And I go to line in "BasisesTree" table
			| 'Row presentation'                                     |
			| 'Retail sales receipt 1 203 dated 02.08.2023 14:36:25' |
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '350,00' | '2,000'    | 'Shirt (38/Black)' | 'pcs'  |
		And I click the button named "Link"
		And I click "Ok" button
		And "ItemList" table became equal
			| '#' | 'Retail sales receipt'                                 | 'Item'  | 'Item key' | 'Serial lot numbers' | 'Unit' | 'Source of origins' | 'Quantity' | 'Store'    | 'Sales order' |
			| '1' | 'Retail sales receipt 1 203 dated 02.08.2023 14:36:25' | 'Shirt' | '38/Black' | ''                   | 'pcs'  | ''                  | '2,000'    | 'Store 01' | ''            |
			| '2' | 'Retail sales receipt 1 203 dated 02.08.2023 14:36:25' | 'Dress' | 'L/Green'  | ''                   | 'pcs'  | ''                  | '1,000'    | 'Store 01' | ''            |
	* Select items from another RSR
		And in the table "ItemList" I click "Add basis documents" button
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation'         | 'Unit' | 'Use' |
			| 'TRY'      | '400,00' | '2,000'    | 'Product 1 with SLN (PZU)' | 'pcs'  | 'No'  |
		And I set "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
	* Check
		And "ItemList" table became equal
			| '#' | 'Retail sales receipt'                                 | 'Item'               | 'Item key' | 'Serial lot numbers' | 'Unit' | 'Source of origins' | 'Quantity' | 'Store'    | 'Sales order' |
			| '1' | 'Retail sales receipt 1 203 dated 02.08.2023 14:36:25' | 'Shirt'              | '38/Black' | ''                   | 'pcs'  | ''                  | '2,000'    | 'Store 01' | ''            |
			| '2' | 'Retail sales receipt 1 203 dated 02.08.2023 14:36:25' | 'Dress'              | 'L/Green'  | ''                   | 'pcs'  | ''                  | '1,000'    | 'Store 01' | ''            |
			| '3' | 'Retail sales receipt 1 204 dated 02.08.2023 14:37:42' | 'Product 1 with SLN' | 'PZU'      | '8908899879'         | 'pcs'  | ''                  | '2,000'    | 'Store 01' | ''            |
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberRGR1$$" variable
		And I delete "$$RGR1$$" variable
		And I save the value of "Number" field as "$$NumberRGR1$$"
		And I save the window as "$$RGR1$$"
		And I close current window
	* Check creation
		Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"
		And I go to line in "List" table
			| 'Number'         |
			| '$$NumberRGR1$$' |
		And I select current line in "List" table
		And "ItemList" table became equal
			| '#' | 'Retail sales receipt'                                 | 'Item'               | 'Item key' | 'Serial lot numbers' | 'Unit' | 'Source of origins' | 'Quantity' | 'Store'    | 'Sales order' |
			| '1' | 'Retail sales receipt 1 203 dated 02.08.2023 14:36:25' | 'Shirt'              | '38/Black' | ''                   | 'pcs'  | ''                  | '2,000'    | 'Store 01' | ''            |
			| '2' | 'Retail sales receipt 1 203 dated 02.08.2023 14:36:25' | 'Dress'              | 'L/Green'  | ''                   | 'pcs'  | ''                  | '1,000'    | 'Store 01' | ''            |
			| '3' | 'Retail sales receipt 1 204 dated 02.08.2023 14:37:42' | 'Product 1 with SLN' | 'PZU'      | '8908899879'         | 'pcs'  | ''                  | '2,000'    | 'Store 01' | ''            |
		And I close all client application windows
		

Scenario: _0202602 create RRR based on RGR (with RSR)
	And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"
		If "List" table does not contain lines Then
			| 'Number'         |
			| '$$NumberRGR1$$' |
			Then I stop script execution "ScriptStatus"
	* Select RGR and create RRR
		And I go to line in "List" table
			| 'Number'         |
			| '$$NumberRGR1$$' |
		And I click "Sales return" button
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '550,00' | '1,000'    | 'Dress (L/Green)'  | 'pcs'  | 'Yes' |
		And I remove "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
	* Filling branch
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description' |
			| 'Shop 01'     |
		And I select current line in "List" table
	* Check
		And "ItemList" table became equal
			| '#' | 'Retail sales receipt'                                 | 'Item'               | 'Sales person'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Serial lot numbers' | 'Unit' | 'Return reason' | 'Source of origins' | 'Quantity' | 'Price'  | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Revenue type' | 'Detail' | 'VAT' | 'Offers amount' | 'Landed cost' | 'Landed cost tax' |
			| '1' | 'Retail sales receipt 1 203 dated 02.08.2023 14:36:25' | 'Shirt'              | 'David Romanov' | '38/Black' | 'Shop 01'            | 'No'                 | '96,10'      | ''                   | 'pcs'  | ''              | ''                  | '2,000'    | '350,00' | '533,90'     | '630,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | '70,00'         | ''            | ''                |
			| '2' | 'Retail sales receipt 1 204 dated 02.08.2023 14:37:42' | 'Product 1 with SLN' | ''              | 'PZU'      | 'Shop 01'            | 'No'                 | '109,83'     | '8908899879'         | 'pcs'  | ''              | ''                  | '2,000'    | '400,00' | '610,17'     | '720,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | '80,00'         | ''            | ''                |
	* Check linked documents
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I set checkbox "Linked documents"
		And "ResultsTree" table contains lines
			| 'Row presentation'                                     | 'Company'      | 'Branch'                  | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Retail sales receipt 1 203 dated 02.08.2023 14:36:25' | 'Main Company' | 'Shop 01'                 | ''         | ''     | ''       | ''         |
			| 'Retail goods receipt*'                                | 'Main Company' | 'Distribution department' | ''         | ''     | ''       | ''         |
			| 'Shirt (38/Black)'                                     | 'Main Company' | 'Distribution department' | '2,000'    | 'pcs'  | '350,00' | 'TRY'      |
			| 'Retail sales receipt 1 204 dated 02.08.2023 14:37:42' | 'Main Company' | 'Shop 01'                 | ''         | ''     | ''       | ''         |
			| 'Retail goods receipt*'                                | 'Main Company' | 'Distribution department' | ''         | ''     | ''       | ''         |
			| 'Product 1 with SLN (PZU)'                             | 'Main Company' | 'Distribution department' | '2,000'    | 'pcs'  | '400,00' | 'TRY'      |
	* Unlink 
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button	
		And "ItemList" table became equal
			| '#' | 'Retail sales receipt' | 'Item'               | 'Sales person'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Serial lot numbers' | 'Unit' | 'Return reason' | 'Source of origins' | 'Quantity' | 'Price'  | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Revenue type' | 'Detail' | 'VAT' | 'Offers amount' | 'Landed cost' | 'Landed cost tax' |
			| '1' | ''                     | 'Shirt'              | 'David Romanov' | '38/Black' | 'Shop 01'            | 'No'                 | '96,10'      | ''                   | 'pcs'  | ''              | ''                  | '2,000'    | '350,00' | '533,90'     | '630,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | '70,00'         | ''            | ''                |
			| '2' | ''                     | 'Product 1 with SLN' | ''              | 'PZU'      | 'Shop 01'            | 'No'                 | '109,83'     | '8908899879'         | 'pcs'  | ''              | ''                  | '2,000'    | '400,00' | '610,17'     | '720,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | '80,00'         | ''            | ''                |
	* Link back
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
			| '1' | '2,000'    | 'Shirt (38/Black)' | 'Store 01' | 'pcs'  |
		And I go to line in "BasisesTree" table
			| 'Branch'  | 'Company'      | 'Row presentation'            |
			| 'Shop 01' | 'Main Company' | 'Retail sales receipt 1 203 dated 02.08.2023 14:36:25' |
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '350,00' | '2,000'    | 'Shirt (38/Black)' | 'pcs'  |
		And I click the button named "Link"
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation'         | 'Store'    | 'Unit' |
			| '2' | '2,000'    | 'Product 1 with SLN (PZU)' | 'Store 01' | 'pcs'  |
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation'         | 'Unit' |
			| 'TRY'      | '400,00' | '2,000'    | 'Product 1 with SLN (PZU)' | 'pcs'  |
		And I click the button named "Link"	
		And I click "Ok" button
		And "ItemList" table became equal
			| '#' | 'Retail sales receipt'                                 | 'Item'               | 'Sales person'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Serial lot numbers' | 'Unit' | 'Return reason' | 'Source of origins' | 'Quantity' | 'Price'  | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Revenue type' | 'Detail' | 'VAT' | 'Offers amount' | 'Landed cost' | 'Landed cost tax' |
			| '1' | 'Retail sales receipt 1 203 dated 02.08.2023 14:36:25' | 'Shirt'              | 'David Romanov' | '38/Black' | 'Shop 01'            | 'No'                 | '96,10'      | ''                   | 'pcs'  | ''              | ''                  | '2,000'    | '350,00' | '533,90'     | '630,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | '70,00'         | ''            | ''                |
			| '2' | 'Retail sales receipt 1 204 dated 02.08.2023 14:37:42' | 'Product 1 with SLN' | ''              | 'PZU'      | 'Shop 01'            | 'No'                 | '109,83'     | '8908899879'         | 'pcs'  | ''              | ''                  | '2,000'    | '400,00' | '610,17'     | '720,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | '80,00'         | ''            | ''                |		
	* Select items from another RSR
		And in the table "ItemList" I click "Add basis documents" button
		And I go to line in "BasisesTree" table
			| 'Row presentation' | 'Use' |
			| '$$RGR1$$'         | 'No'  |
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '550,00' | '1,000'    | 'Dress (L/Green)'  | 'pcs'  | 'No'  |
		And I set "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '550,00' | '1,000'    | 'Dress (L/Green)'  | 'pcs'  | 'No'  |
		And I set "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
	* Check
		And "ItemList" table became equal
			| '#' | 'Retail sales receipt'                                 | 'Item'               | 'Sales person'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Serial lot numbers' | 'Unit' | 'Return reason' | 'Source of origins' | 'Quantity' | 'Price'  | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Revenue type' | 'Detail' | 'VAT' | 'Offers amount' | 'Landed cost' | 'Landed cost tax' |
			| '1' | 'Retail sales receipt 1 203 dated 02.08.2023 14:36:25' | 'Shirt'              | 'David Romanov' | '38/Black' | 'Shop 01'            | 'No'                 | '96,10'      | ''                   | 'pcs'  | ''              | ''                  | '2,000'    | '350,00' | '533,90'     | '630,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | '70,00'         | ''            | ''                |
			| '2' | 'Retail sales receipt 1 204 dated 02.08.2023 14:37:42' | 'Product 1 with SLN' | ''              | 'PZU'      | 'Shop 01'            | 'No'                 | '109,83'     | '8908899879'         | 'pcs'  | ''              | ''                  | '2,000'    | '400,00' | '610,17'     | '720,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | '80,00'         | ''            | ''                |
			| '3' | 'Retail sales receipt 1 203 dated 02.08.2023 14:36:25' | 'Dress'              | ''              | 'L/Green'  | 'Shop 01'            | 'No'                 | '75,51'      | ''                   | 'pcs'  | ''              | ''                  | '1,000'    | '550,00' | '419,49'     | '495,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | '55,00'         | ''            | ''                |
			| '4' | 'Retail sales receipt 1 204 dated 02.08.2023 14:37:42' | 'Dress'              | ''              | 'L/Green'  | 'Shop 01'            | 'No'                 | '75,51'      | ''                   | 'pcs'  | ''              | ''                  | '1,000'    | '550,00' | '419,49'     | '495,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | '55,00'         | ''            | ''                |		
		And in the table "ItemList" I click "Goods receipts" button
		And Delay 3
		And "DocumentsTree" table became equal
			| 'Presentation'             | 'Invoice' | 'QuantityInDocument' | 'Quantity' |
			| 'Shirt (38/Black)'         | '2,000'   | '2,000'              | '2,000'    |
			| '$$RGR1$$'                 | ''        | '2,000'              | '2,000'    |
			| 'Product 1 with SLN (PZU)' | '2,000'   | '2,000'              | '2,000'    |
			| '$$RGR1$$'                 | ''        | '2,000'              | '2,000'    |
			| 'Dress (L/Green)'          | '1,000'   | '1,000'              | '1,000'    |
			| '$$RGR1$$'                 | ''        | '1,000'              | '1,000'    |
		And I close "Linked documents" window
	* Payment
		And I move to "Payments" tab
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "2 340,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberRRR1$$" variable
		And I delete "$$RRR1$$" variable
		And I save the value of "Number" field as "$$NumberRRR1$$"
		And I save the window as "$$RRR1$$"
		And I close current window
	* Check creation
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'         |
			| '$$NumberRRR1$$' |
		And I select current line in "List" table	
		And "ItemList" table became equal
			| '#' | 'Retail sales receipt'                                 | 'Item'               | 'Sales person'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Serial lot numbers' | 'Unit' | 'Return reason' | 'Source of origins' | 'Quantity' | 'Price'  | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Revenue type' | 'Detail' | 'VAT' | 'Offers amount' | 'Landed cost' | 'Landed cost tax' |
			| '1' | 'Retail sales receipt 1 203 dated 02.08.2023 14:36:25' | 'Shirt'              | 'David Romanov' | '38/Black' | 'Shop 01'            | 'No'                 | '96,10'      | ''                   | 'pcs'  | ''              | ''                  | '2,000'    | '350,00' | '533,90'     | '630,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | '70,00'         | ''            | ''                |
			| '2' | 'Retail sales receipt 1 204 dated 02.08.2023 14:37:42' | 'Product 1 with SLN' | ''              | 'PZU'      | 'Shop 01'            | 'No'                 | '109,83'     | '8908899879'         | 'pcs'  | ''              | ''                  | '2,000'    | '400,00' | '610,17'     | '720,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | '80,00'         | ''            | ''                |
			| '3' | 'Retail sales receipt 1 203 dated 02.08.2023 14:36:25' | 'Dress'              | ''              | 'L/Green'  | 'Shop 01'            | 'No'                 | '75,51'      | ''                   | 'pcs'  | ''              | ''                  | '1,000'    | '550,00' | '419,49'     | '495,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | '55,00'         | ''            | ''                |
			| '4' | 'Retail sales receipt 1 204 dated 02.08.2023 14:37:42' | 'Dress'              | ''              | 'L/Green'  | 'Shop 01'            | 'No'                 | '75,51'      | ''                   | 'pcs'  | ''              | ''                  | '1,000'    | '550,00' | '419,49'     | '495,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | '55,00'         | ''            | ''                |		
		And I close all client application windows
		
				
Scenario: _0202603 create RRR based on RGR (without RSR)
//	needs to be finalized
	And I close all client application windows	
	* Select RGR
		Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"
		And I go to line in "List" table
			| 'Date'                | 'Number' | 'Retail customer' | 'Transaction type'     |
			| '03.08.2023 10:54:07' | '1 204'  | 'Sam Jons'        | 'Return from customer' |
		And I click the button named "FormDocumentRetailReturnReceiptGenerate"
		And I click "Ok" button
	* Filling branch
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
	* Check creation
		And I go to line in "ItemList" table
			| 'Item'               | 'Item key' |
			| 'Product 1 with SLN' | 'PZU'      |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'               | 'Item key' |
			| 'Product 3 with SLN' | 'UNIQ'     |
		And I select current line in "ItemList" table
		And I input "110,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'               | 'Item key' |
			| 'Product 4 with SLN' | 'UNIQ'     |
		And I select current line in "ItemList" table
		And I input "120,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table became equal
			| '#' | 'Retail sales receipt' | 'Item'               | 'Sales person' | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Serial lot numbers' | 'Unit' | 'Return reason' | 'Source of origins' | 'Quantity' | 'Price'  | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Revenue type' | 'Detail' | 'VAT' | 'Offers amount' | 'Landed cost' | 'Landed cost tax' |
			| '1' | ''                     | 'Shirt'              | ''             | '38/Black' | ''                   | 'No'                 | '106,78'     | ''                   | 'pcs'  | ''              | ''                  | '2,000'    | '350,00' | '593,22'     | '700,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | ''              | ''            | ''                |
			| '2' | ''                     | 'Dress'              | ''             | 'L/Green'  | ''                   | 'No'                 | '83,90'      | ''                   | 'pcs'  | ''              | ''                  | '1,000'    | '550,00' | '466,10'     | '550,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | ''              | ''            | ''                |
			| '3' | ''                     | 'Product 1 with SLN' | ''             | 'PZU'      | ''                   | 'No'                 | '30,51'      | '8908899879'         | 'pcs'  | ''              | ''                  | '2,000'    | '100,00' | '169,49'     | '200,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | ''              | ''            | ''                |
			| '4' | ''                     | 'Product 3 with SLN' | ''             | 'UNIQ'     | ''                   | 'No'                 | '33,56'      | '09987897977891'     | 'pcs'  | ''              | ''                  | '2,000'    | '110,00' | '186,44'     | '220,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | ''              | ''            | ''                |
			| '5' | ''                     | 'Product 4 with SLN' | ''             | 'UNIQ'     | ''                   | 'No'                 | '18,31'      | '899007790088'       | 'pcs'  | ''              | ''                  | '1,000'    | '120,00' | '101,69'     | '120,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | ''              | ''            | ''                |
		And in the table "ItemList" I click "Goods receipts" button
		And Delay 2
		And "DocumentsTree" table became equal
			| 'Presentation'                                         | 'Invoice' | 'QuantityInDocument' | 'Quantity' |
			| 'Shirt (38/Black)'                                     | '2,000'   | '2,000'              | '2,000'    |
			| 'Retail goods receipt 1 204 dated 03.08.2023 10:54:07' | ''        | '2,000'              | '2,000'    |
			| 'Dress (L/Green)'                                      | '1,000'   | '1,000'              | '1,000'    |
			| 'Retail goods receipt 1 204 dated 03.08.2023 10:54:07' | ''        | '1,000'              | '1,000'    |
			| 'Product 1 with SLN (PZU)'                             | '2,000'   | '2,000'              | '2,000'    |
			| 'Retail goods receipt 1 204 dated 03.08.2023 10:54:07' | ''        | '2,000'              | '2,000'    |
			| 'Product 3 with SLN (UNIQ)'                            | '2,000'   | '2,000'              | '2,000'    |
			| 'Retail goods receipt 1 204 dated 03.08.2023 10:54:07' | ''        | '2,000'              | '2,000'    |
			| 'Product 4 with SLN (UNIQ)'                            | '1,000'   | '1,000'              | '1,000'    |
			| 'Retail goods receipt 1 204 dated 03.08.2023 10:54:07' | ''        | '1,000'              | '1,000'    |
		And I close "Linked documents" window
	* Unlink 
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I set checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		Then the number of "ResultsTree" table lines is "равно" 0
		And I click "Ok" button	
	* Link back
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
		And in the table "ItemList" I click "Goods receipts" button
		And Delay 2
		And "DocumentsTree" table became equal
			| 'Presentation'                                         | 'Invoice' | 'QuantityInDocument' | 'Quantity' |
			| 'Dress (L/Green)'                                      | '1,000'   | '1,000'              | '1,000'    |
			| 'Retail goods receipt 1 204 dated 03.08.2023 10:54:07' | ''        | '1,000'              | '1,000'    |
			| 'Product 1 with SLN (PZU)'                             | '2,000'   | '2,000'              | '2,000'    |
			| 'Retail goods receipt 1 204 dated 03.08.2023 10:54:07' | ''        | '2,000'              | '2,000'    |
			| 'Product 3 with SLN (UNIQ)'                            | '2,000'   | '2,000'              | '2,000'    |
			| 'Retail goods receipt 1 204 dated 03.08.2023 10:54:07' | ''        | '2,000'              | '2,000'    |
			| 'Product 4 with SLN (UNIQ)'                            | '1,000'   | '1,000'              | '1,000'    |
			| 'Retail goods receipt 1 204 dated 03.08.2023 10:54:07' | ''        | '1,000'              | '1,000'    |
		And I close "Linked documents" window
	* Payment
		And I move to "Payments" tab
		And in the table "Payments" I click the button named "PaymentsAdd"
		And I select current line in "Payments" table
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description' |
			| 'Cash'        |
		And I select current line in "List" table
		And I activate "Account" field in "Payments" table
		And I click choice button of "Account" attribute in "Payments" table
		And I go to line in "List" table
			| 'Currency' | 'Description'  |
			| 'TRY'      | 'Cash desk №4' |
		And I select current line in "List" table
		And I activate field named "PaymentsAmount" in "Payments" table
		And I input "1 790,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table	
	* Filling landed cost
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Landed cost" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'               | 'Item key' |
			| 'Product 1 with SLN' | 'PZU'      |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Landed cost" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'               | 'Item key' |
			| 'Product 3 with SLN' | 'UNIQ'     |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Landed cost" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'               | 'Item key' |
			| 'Product 4 with SLN' | 'UNIQ'     |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Landed cost" field of "ItemList" table
		And I finish line editing in "ItemList" table	
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberRRR2$$" variable
		And I delete "$$RRR2$$" variable
		And I save the value of "Number" field as "$$NumberRRR2$$"
		And I save the window as "$$RRR2$$"
		And I close current window
	* Check creation
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'         |
			| '$$NumberRRR2$$' |
		And I close all client application windows