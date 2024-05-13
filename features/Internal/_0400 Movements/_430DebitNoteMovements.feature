#language: en
@tree
@Positive
@Movements2
@MovementsDebitNote

Feature: check Debit note movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _043000 preparation (Debit note)
	When set True value to the constant
	When set False value to the constant Use commission trading
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
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
		When Create catalog LegalNameContracts objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
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
		When Create catalog PartnersBankAccounts objects
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
		When Create OtherPartners objects
		When Create catalog Projects objects
		When Create information register Taxes records (VAT)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
	* Load documents
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		If "List" table does not contain lines Then
			| 'Number'    |
			| '1'         |
			| '3'         |
			When Create document SalesOrder objects (check movements, SC before SI, Use shipment sheduling)
			When Create document SalesOrder objects (check movements, SI before SC, not Use shipment sheduling)
			And I execute 1C:Enterprise script at server
				| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Write);"       |
				| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"     |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Write);"       |
				| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		If "List" table does not contain lines Then
			| 'Number'    |
			| '2'         |
			| '3'         |
			When Create document ShipmentConfirmation objects (check movements)
			And I execute 1C:Enterprise script at server
				| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"     |
			And I execute 1C:Enterprise script at server
				| "Documents.ShipmentConfirmation.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"     |
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
			| 'Number'    |
			| '1'         |
			| '3'         |
			When Create document SalesInvoice objects (check movements)
			And I execute 1C:Enterprise script at server
				| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Write);"       |
				| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"     |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Write);"       |
				| "Documents.SalesInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"     |
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		If "List" table does not contain lines Then
			| 'Number'    |
			| '102'       |
			When Create document SalesReturnOrder objects (check movements)
			And I execute 1C:Enterprise script at server
				| "Documents.SalesReturnOrder.FindByNumber(102).GetObject().Write(DocumentWriteMode.Write);"       |
				| "Documents.SalesReturnOrder.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);"     |
			And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		If "List" table does not contain lines Then
			| 'Number'    |
			| '101'       |
			| '104'       |
			When Create document SalesReturn objects (check movements)
			And I execute 1C:Enterprise script at server
					| "Documents.SalesReturn.FindByNumber(101).GetObject().Write(DocumentWriteMode.Write);"        |
					| "Documents.SalesReturn.FindByNumber(101).GetObject().Write(DocumentWriteMode.Posting);"      |
			And I execute 1C:Enterprise script at server
					| "Documents.SalesReturn.FindByNumber(104).GetObject().Write(DocumentWriteMode.Write);"        |
					| "Documents.SalesReturn.FindByNumber(104).GetObject().Write(DocumentWriteMode.Posting);"      |
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		If "List" table does not contain lines Then
			| 'Number'    |
			| '115'       |
			When Create document PurchaseOrder objects (check movements, GR before PI, Use receipt sheduling)
			And I execute 1C:Enterprise script at server
				| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Write);"       |
				| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"     |
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
			| 'Number'    |
			| '115'       |
			| '116'       |
			When Create document PurchaseInvoice objects (check movements)
			And I execute 1C:Enterprise script at server
				| "Documents.PurchaseInvoice.FindByNumber(115).GetObject().Write(DocumentWriteMode.Write);"       |
				| "Documents.PurchaseInvoice.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"     |
			And I execute 1C:Enterprise script at server
				| "Documents.PurchaseInvoice.FindByNumber(116).GetObject().Write(DocumentWriteMode.Write);"       |
				| "Documents.PurchaseInvoice.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"     |
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		If "List" table does not contain lines Then
			| 'Number'    |
			| '115'       |
			| '116'       |
			When Create document GoodsReceipt objects (check movements)
			And I execute 1C:Enterprise script at server
				| "Documents.GoodsReceipt.FindByNumber(115).GetObject().Write(DocumentWriteMode.Write);"       |
				| "Documents.GoodsReceipt.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"     |
			And I execute 1C:Enterprise script at server
				| "Documents.GoodsReceipt.FindByNumber(116).GetObject().Write(DocumentWriteMode.Write);"       |
				| "Documents.GoodsReceipt.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"     |
		When Create document DebitNote objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.DebitNote.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.DebitNote.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.DebitNote.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.DebitNote.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"    |
		When create DebitNote (OtherPartnersTransactions)
		And I execute 1C:Enterprise script at server
			| "Documents.DebitNote.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows

Scenario: _043000 check preparation
	When check preparation

Scenario: _043001 check Debit note movements by the Register "R5010 Reconciliation statement"
	* Select Debit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit note 1 dated 05.04.2021 09:30:36'       | ''              | ''                      | ''            | ''               | ''               | ''           | ''                    | ''                          |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''               | ''           | ''                    | ''                          |
			| 'Register  "R5010 Reconciliation statement"'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                    | ''                          |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                    | ''                          |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Currency'   | 'Legal name'          | 'Legal name contract'       |
			| ''                                             | 'Receipt'       | '05.04.2021 09:30:36'   | '2 300'       | 'Main Company'   | 'Front office'   | 'TRY'        | 'Company Ferron BP'   | 'Contract Ferron BP New'    |
	And I close all client application windows

Scenario: _043002 check Debit note movements by the Register "R2021 Customer transactions" (with customer without basis document)
	* Select Debit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R2021 Customer transactions" 
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit note 2 dated 05.04.2021 09:31:09'    | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                         | ''        | ''        | ''                       | ''                              |
			| 'Document registrations records'            | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                         | ''        | ''        | ''                       | ''                              |
			| 'Register  "R2021 Customer transactions"'   | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                         | ''        | ''        | ''                       | ''                              |
			| ''                                          | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                         | ''        | ''        | 'Attributes'             | ''                              |
			| ''                                          | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'          | 'Partner'     | 'Agreement'                  | 'Basis'                                    | 'Order'   | 'Project' | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                          | 'Receipt'       | '05.04.2021 09:31:09'   | '17,12'       | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Debit note 2 dated 05.04.2021 09:31:09'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                          | 'Receipt'       | '05.04.2021 09:31:09'   | '100'         | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Debit note 2 dated 05.04.2021 09:31:09'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                          | 'Receipt'       | '05.04.2021 09:31:09'   | '100'         | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Debit note 2 dated 05.04.2021 09:31:09'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                          | 'Receipt'       | '05.04.2021 09:31:09'   | '100'         | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Debit note 2 dated 05.04.2021 09:31:09'   | ''        | ''        | 'No'                     | ''                              |
	And I close all client application windows
	

Scenario: _043003 check absence Debit note movements by the Register "R1021 Vendors transactions" (with customer)
	* Select Debit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R1021 Vendors transactions" 
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R1021 Vendors transactions'    |
	And I close all client application windows


Scenario: _043004 check Debit note movements by the Register "R1021 Vendors transactions" (with vendor without basis document)
	* Select Debit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R1021 Vendors transactions" 
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit note 1 dated 05.04.2021 09:30:36' | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                       | ''      | ''           | ''                     | ''                         |
			| 'Document registrations records'         | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                       | ''      | ''           | ''                     | ''                         |
			| 'Register  "R1021 Vendors transactions"' | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                       | ''      | ''           | ''                     | ''                         |
			| ''                                       | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                       | ''      | ''           | 'Attributes'           | ''                         |
			| ''                                       | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Agreement'          | 'Basis'                                  | 'Order' | 'Project'    | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                       | 'Receipt'     | '05.04.2021 09:30:36' | '-2 300'    | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Debit note 1 dated 05.04.2021 09:30:36' | ''      | 'Project 01' | 'No'                   | ''                         |
			| ''                                       | 'Receipt'     | '05.04.2021 09:30:36' | '-2 300'    | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Debit note 1 dated 05.04.2021 09:30:36' | ''      | 'Project 01' | 'No'                   | ''                         |
			| ''                                       | 'Receipt'     | '05.04.2021 09:30:36' | '-2 300'    | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Debit note 1 dated 05.04.2021 09:30:36' | ''      | 'Project 01' | 'No'                   | ''                         |
			| ''                                       | 'Receipt'     | '05.04.2021 09:30:36' | '-393,76'   | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Debit note 1 dated 05.04.2021 09:30:36' | ''      | 'Project 01' | 'No'                   | ''                         |	
	And I close all client application windows

Scenario: _043005 check absence Debit note movements by the Register "R2021 Customer transactions" (with vendor)
	* Select Debit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R2021 Customer transactions" 
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2021 Customer transactions'    |
	And I close all client application windows

Scenario: _043006 check Debit note movements by the Register "R5021 Revenues" (with vendor) 
	* Select Debit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R5021 Revenues" 
		And I click "Registrations report" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit note 1 dated 05.04.2021 09:30:36' | ''                    | ''          | ''                  | ''             | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                             | ''           |
			| 'Document registrations records'         | ''                    | ''          | ''                  | ''             | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                             | ''           |
			| 'Register  "R5021 Revenues"'             | ''                    | ''          | ''                  | ''             | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                             | ''           |
			| ''                                       | 'Period'              | 'Resources' | ''                  | 'Dimensions'   | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                             | ''           |
			| ''                                       | ''                    | 'Amount'    | 'Amount with taxes' | 'Company'      | 'Branch'       | 'Profit loss center'      | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project'    |
			| ''                                       | '05.04.2021 09:30:36' | '393,76'    | '393,76'            | 'Main Company' | 'Front office' | 'Distribution department' | 'Software'     | ''         | 'USD'      | ''                    | 'Reporting currency'           | 'Project 01' |
			| ''                                       | '05.04.2021 09:30:36' | '2 300'     | '2 300'             | 'Main Company' | 'Front office' | 'Distribution department' | 'Software'     | ''         | 'TRY'      | ''                    | 'Local currency'               | 'Project 01' |
			| ''                                       | '05.04.2021 09:30:36' | '2 300'     | '2 300'             | 'Main Company' | 'Front office' | 'Distribution department' | 'Software'     | ''         | 'TRY'      | ''                    | 'en description is empty'      | 'Project 01' |
	And I close all client application windows

Scenario: _043007 check Debit note movements by the Register "R5021 Revenues" (with customer)
	And I close all client application windows
	* Select Debit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R5021 Revenues" 
		And I click "Registrations report" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit note 2 dated 05.04.2021 09:31:09'   | ''                      | ''            | ''                    | ''               | ''               | ''                          | ''               | ''           | ''           | ''                      | ''                                | ''           |
			| 'Document registrations records'           | ''                      | ''            | ''                    | ''               | ''               | ''                          | ''               | ''           | ''           | ''                      | ''                                | ''           |
			| 'Register  "R5021 Revenues"'               | ''                      | ''            | ''                    | ''               | ''               | ''                          | ''               | ''           | ''           | ''                      | ''                                | ''           |
			| ''                                         | 'Period'                | 'Resources'   | ''                    | 'Dimensions'     | ''               | ''                          | ''               | ''           | ''           | ''                      | ''                                | ''           |
			| ''                                         | ''                      | 'Amount'      | 'Amount with taxes'   | 'Company'        | 'Branch'         | 'Profit loss center'        | 'Revenue type'   | 'Item key'   | 'Currency'   | 'Additional analytic'   | 'Multi currency movement type'    | 'Project'    |
			| ''                                         | '05.04.2021 09:31:09'   | '17,12'       | '17,12'               | 'Main Company'   | 'Front office'   | 'Distribution department'   | 'Software'       | ''           | 'USD'        | ''                      | 'Reporting currency'              | ''           |
			| ''                                         | '05.04.2021 09:31:09'   | '100'         | '100'                 | 'Main Company'   | 'Front office'   | 'Distribution department'   | 'Software'       | ''           | 'TRY'        | ''                      | 'Local currency'                  | ''           |
			| ''                                         | '05.04.2021 09:31:09'   | '100'         | '100'                 | 'Main Company'   | 'Front office'   | 'Distribution department'   | 'Software'       | ''           | 'TRY'        | ''                      | 'en description is empty'         | ''           |
	And I close all client application windows

Scenario: _043008 check Debit note movements by the Register "R5021 Revenues" (OtherPartnersTransactions)
	And I close all client application windows
	* Select Debit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R5021 Revenues" 
		And I click "Registrations report" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit note 3 dated 12.06.2023 14:52:33'   | ''                      | ''            | ''                    | ''               | ''               | ''                          | ''               | ''           | ''           | ''                      | ''                                | ''           |
			| 'Document registrations records'           | ''                      | ''            | ''                    | ''               | ''               | ''                          | ''               | ''           | ''           | ''                      | ''                                | ''           |
			| 'Register  "R5021 Revenues"'               | ''                      | ''            | ''                    | ''               | ''               | ''                          | ''               | ''           | ''           | ''                      | ''                                | ''           |
			| ''                                         | 'Period'                | 'Resources'   | ''                    | 'Dimensions'     | ''               | ''                          | ''               | ''           | ''           | ''                      | ''                                | ''           |
			| ''                                         | ''                      | 'Amount'      | 'Amount with taxes'   | 'Company'        | 'Branch'         | 'Profit loss center'        | 'Revenue type'   | 'Item key'   | 'Currency'   | 'Additional analytic'   | 'Multi currency movement type'    | 'Project'    |
			| ''                                         | '12.06.2023 14:52:33'   | '17,12'       | '17,12'               | 'Main Company'   | 'Front office'   | 'Distribution department'   | 'Revenue'        | ''           | 'USD'        | ''                      | 'Reporting currency'              | ''           |
			| ''                                         | '12.06.2023 14:52:33'   | '100'         | '100'                 | 'Main Company'   | 'Front office'   | 'Distribution department'   | 'Revenue'        | ''           | 'TRY'        | ''                      | 'Local currency'                  | ''           |
			| ''                                         | '12.06.2023 14:52:33'   | '100'         | '100'                 | 'Main Company'   | 'Front office'   | 'Distribution department'   | 'Revenue'        | ''           | 'TRY'        | ''                      | 'en description is empty'         | ''           |
	And I close all client application windows

Scenario: _043009 check Debit note movements by the Register "R5015 Other partners transactions" (OtherPartnersTransactions)
	And I close all client application windows
	* Select Debit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R5015 Other partners transactions" 
		And I click "Registrations report" button
		And I select "R5015 Other partners transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit note 3 dated 12.06.2023 14:52:33'          | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                  | ''                  | ''                  | ''                        | ''                        |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                  | ''                  | ''                  | ''                        |''                        |
			| 'Register  "R5015 Other partners transactions"'   | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                  | ''                  | ''                  | ''                        | ''                        |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                               | ''           | ''                       | ''                  | ''                  | ''                  | ''                        | 'Attributes'              |
			| ''                                                | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'        | 'Partner'           | 'Agreement'         | 'Basis'                   | 'Deferred calculation'    |
			| ''                                                | 'Receipt'       | '12.06.2023 14:52:33'   | '17,12'       | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Other partner 1'   | 'Other partner 1'   | 'Other partner 1'   | ''                        | 'No'                      |
			| ''                                                | 'Receipt'       | '12.06.2023 14:52:33'   | '100'         | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Other partner 1'   | 'Other partner 1'   | 'Other partner 1'   | ''                        | 'No'                      |
			| ''                                                | 'Receipt'       | '12.06.2023 14:52:33'   | '100'         | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'TRY'                    | 'Other partner 1'   | 'Other partner 1'   | 'Other partner 1'   | ''                        | 'No'                      |
			| ''                                                | 'Receipt'       | '12.06.2023 14:52:33'   | '100'         | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Other partner 1'   | 'Other partner 1'   | 'Other partner 1'   | ''                        | 'No'                      |
	And I close all client application windows

Scenario: _043010 check Debit note movements by the Register "R5010 Reconciliation statement" (OtherPartnersTransactions)
	And I close all client application windows
	* Select Debit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report info" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit note 3 dated 12.06.2023 14:52:33'     | ''                    | ''           | ''             | ''             | ''         | ''                | ''                    | ''       |
			| 'Register  "R5010 Reconciliation statement"' | ''                    | ''           | ''             | ''             | ''         | ''                | ''                    | ''       |
			| ''                                           | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Currency' | 'Legal name'      | 'Legal name contract' | 'Amount' |
			| ''                                           | '12.06.2023 14:52:33' | 'Receipt'    | 'Main Company' | 'Front office' | 'TRY'      | 'Other partner 1' | ''                    | '100'    |	
	And I close all client application windows

Scenario: _043011 check absence Debit note movements by the Register "R2021 Customer transactions" (customer with basis document)
	* Select Debit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "R2021 Customer transactions" 
		And I click "Registrations report info" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit note 4 dated 16.04.2024 13:50:26'  | ''                    | ''           | ''             | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''                         | ''                                          | ''      | ''        | ''       | ''                     | ''                           |
			| 'Register  "R2021 Customer transactions"' | ''                    | ''           | ''             | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''                         | ''                                          | ''      | ''        | ''       | ''                     | ''                           |
			| ''                                        | 'Period'              | 'RecordType' | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Agreement'                | 'Basis'                                     | 'Order' | 'Project' | 'Amount' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                        | '16.04.2024 13:50:26' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''      | ''        | '100'    | 'No'                   | ''                           |
			| ''                                        | '16.04.2024 13:50:26' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''      | ''        | '17,12'  | 'No'                   | ''                           |
			| ''                                        | '16.04.2024 13:50:26' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''      | ''        | '100'    | 'No'                   | ''                           |
			| ''                                        | '16.04.2024 13:50:26' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''      | ''        | '100'    | 'No'                   | ''                           |		
	And I close all client application windows

Scenario: _043012 check absence Debit note movements by the Register "R1021 Vendors transactions" (vendor with basis document)
	* Select Debit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'    |
			| '5'         |
	* Check movements by the Register  "R1021 Vendors transactions" 
		And I click "Registrations report info" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit note 5 dated 16.04.2024 14:09:47' | ''                    | ''           | ''             | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                               | ''      | ''        | ''       | ''                     | ''                         |
			| 'Register  "R1021 Vendors transactions"' | ''                    | ''           | ''             | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                               | ''      | ''        | ''       | ''                     | ''                         |
			| ''                                       | 'Period'              | 'RecordType' | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Agreement'          | 'Basis'                                          | 'Order' | 'Project' | 'Amount' | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                       | '16.04.2024 14:09:47' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | ''      | ''        | '-100'   | 'No'                   | ''                         |
			| ''                                       | '16.04.2024 14:09:47' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | ''      | ''        | '-17,12' | 'No'                   | ''                         |
			| ''                                       | '16.04.2024 14:09:47' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | ''      | ''        | '-100'   | 'No'                   | ''                         |
			| ''                                       | '16.04.2024 14:09:47' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | ''      | ''        | '-100'   | 'No'                   | ''                         |		
	And I close all client application windows


Scenario: _043013 check Debit note movements by the Register "R5020 Partners balance" (OtherPartnersTransactions)
	And I close all client application windows
	* Select Debit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report info" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit note 3 dated 12.06.2023 14:52:33' | ''                    | ''           | ''             | ''             | ''                | ''                | ''                | ''         | ''         | ''                             | ''                     | ''       | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| 'Register  "R5020 Partners balance"'     | ''                    | ''           | ''             | ''             | ''                | ''                | ''                | ''         | ''         | ''                             | ''                     | ''       | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                       | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Partner'         | 'Legal name'      | 'Agreement'       | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Amount' | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Advances closing' |
			| ''                                       | '12.06.2023 14:52:33' | 'Receipt'    | 'Main Company' | 'Front office' | 'Other partner 1' | 'Other partner 1' | 'Other partner 1' | ''         | 'TRY'      | 'Local currency'               | 'TRY'                  | '100'    | ''                     | ''                 | ''                   | ''               | '100'               | ''                 |
			| ''                                       | '12.06.2023 14:52:33' | 'Receipt'    | 'Main Company' | 'Front office' | 'Other partner 1' | 'Other partner 1' | 'Other partner 1' | ''         | 'TRY'      | 'TRY'                          | 'TRY'                  | '100'    | ''                     | ''                 | ''                   | ''               | '100'               | ''                 |
			| ''                                       | '12.06.2023 14:52:33' | 'Receipt'    | 'Main Company' | 'Front office' | 'Other partner 1' | 'Other partner 1' | 'Other partner 1' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | '100'    | ''                     | ''                 | ''                   | ''               | '100'               | ''                 |
			| ''                                       | '12.06.2023 14:52:33' | 'Receipt'    | 'Main Company' | 'Front office' | 'Other partner 1' | 'Other partner 1' | 'Other partner 1' | ''         | 'USD'      | 'Reporting currency'           | 'TRY'                  | '17,12'  | ''                     | ''                 | ''                   | ''               | '17,12'             | ''                 |		
	And I close all client application windows


Scenario: _043014 check DebitNote movements by the Register  "T2015 Transactions info" (with vendor)
	And I close all client application windows
	* Select DN
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'|
			| '1'     |
	* Check movements by the Register  "T2015 Transactions info" 
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Debit note 1 dated 05.04.2021 09:30:36' | ''             | ''             | ''      | ''                    | ''    | ''         | ''          | ''                  | ''                   | ''                      | ''                        | ''                                       | ''          | ''           | ''       | ''       | ''        |
			| 'Register  "T2015 Transactions info"'    | ''             | ''             | ''      | ''                    | ''    | ''         | ''          | ''                  | ''                   | ''                      | ''                        | ''                                       | ''          | ''           | ''       | ''       | ''        |
			| ''                                       | 'Company'      | 'Branch'       | 'Order' | 'Date'                | 'Key' | 'Currency' | 'Partner'   | 'Legal name'        | 'Agreement'          | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis'                      | 'Unique ID' | 'Project'    | 'Amount' | 'Is due' | 'Is paid' |
			| ''                                       | 'Main Company' | 'Front office' | ''      | '05.04.2021 09:30:36' | '*'   | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Yes'                   | 'No'                      | 'Debit note 1 dated 05.04.2021 09:30:36' | '*'         | 'Project 01' | '-2 300' | 'Yes'    | 'No'      |	
	And I close all client application windows

Scenario: _043015 check absence DebitNote movements by the Register  "T2014 Advances info" (with vendor)
	* Select DN
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'  |
			| '1'       |
	* Check movements by the Register  "T2014 Advances info"
		And I click "Registrations report info" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "T2014 Advances info"'    |
		And I close all client application windows

Scenario: _043016 check DebitNote movements by the Register  "T2015 Transactions info" (with customer)
	And I close all client application windows
	* Select DN
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'|
			| '2'     |
	* Check movements by the Register  "T2015 Transactions info" 
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Debit note 2 dated 05.04.2021 09:31:09' | ''             | ''             | ''      | ''                    | ''    | ''         | ''          | ''                  | ''                         | ''                      | ''                        | ''                                       | ''          | ''        | ''       | ''       | ''        |
			| 'Register  "T2015 Transactions info"'    | ''             | ''             | ''      | ''                    | ''    | ''         | ''          | ''                  | ''                         | ''                      | ''                        | ''                                       | ''          | ''        | ''       | ''       | ''        |
			| ''                                       | 'Company'      | 'Branch'       | 'Order' | 'Date'                | 'Key' | 'Currency' | 'Partner'   | 'Legal name'        | 'Agreement'                | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis'                      | 'Unique ID' | 'Project' | 'Amount' | 'Is due' | 'Is paid' |
			| ''                                       | 'Main Company' | 'Front office' | ''      | '05.04.2021 09:31:09' | '*'   | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'No'                    | 'Yes'                     | 'Debit note 2 dated 05.04.2021 09:31:09' | '*'         | ''        | '100'    | 'Yes'    | 'No'      |
	And I close all client application windows

Scenario: _043017 check absence DebitNote movements by the Register  "T2014 Advances info" (Return to customer, with customer)
	* Select DN
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'  |
			| '2'       |
	* Check movements by the Register  "T2014 Advances info"
		And I click "Registrations report info" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "T2014 Advances info"'    |
		And I close all client application windows

Scenario: _043030 Debit note clear posting/mark for deletion
	And I close all client application windows
	* Select Debit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit note 1 dated 05.04.2021 09:30:36'    |
			| 'Document registrations records'            |
		And I close current window
	* Post Debit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R5010 Reconciliation statement'    |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit note 1 dated 05.04.2021 09:30:36'    |
			| 'Document registrations records'            |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R5010 Reconciliation statement'    |
		And I close all client application windows
