#language: en
@tree
@Positive
@Other


Feature: edit documents movements

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"
Tag = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Tag")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Tag"), "#Tag#")}"
webPort = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("webPort")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("webPort"), "#webPort#")}"
Publication = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Publication")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Publication"), "#Publication#")}"


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _605700 preparation (edit documents movements)
	When set True value to the constant
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog BusinessUnits objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Partners objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertySets objects for ITO and item
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog PartnersBankAccounts objects
		When Create catalog CancelReturnReasons objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create catalog IntegrationSettings objects (db connection)
		When Create catalog Users objects
		When Create information register CurrencyRates records
		When Create information register Barcodes records
		When Create catalog ExternalFunctions objects
		When Create information register Taxes records (VAT)
	When Create document PurchaseOrder objects (check movements, GR before PI, not Use receipt sheduling)
	When Create document PurchaseOrder objects (check movements, GR before PI, Use receipt sheduling)
	When Create document InventoryTransferOrder objects (check movements)
	When Create document InternalSupplyRequest objects (check movements)
	When Create document PurchaseInvoice objects
	* PI posting
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I close all client application windows


Scenario: _605701 check preparation
	When check preparation



Scenario: _605703 change movements for PI
	And I close all client application windows
	* Select PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '12'     |
	* Change movements
		And I click "Registrations report info" button
		And I click "Edit" button
		And I set checkbox "Manual edit"
		* Change movements for R1021B_VendorsTransactions
			And I move to "R1021B_VendorsTransactions (3)" tab
			And I activate field named "R1021B_VendorsTransactionsRecordType" in "R1021B_VendorsTransactions" table
			And I select current line in "R1021B_VendorsTransactions" table
			And I select "Expense" exact value from the drop-down list named "R1021B_VendorsTransactionsRecordType" in "R1021B_VendorsTransactions" table
			And I finish line editing in "R1021B_VendorsTransactions" table
			And I go to line in "R1021B_VendorsTransactions" table
				| 'Active' | 'Agreement'          | 'Amount'     | 'Basis'                                         | 'Company'      | 'Currency' | 'CurrencyMovementType' | 'DeferredCalculation' | 'LegalName'         | 'LineNumber' | 'Partner'   | 'Period'              | 'RecordType' | 'TransactionCurrency' |
				| 'Yes'    | 'Vendor Ferron, TRY' | '137 000,00' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | 'Main Company' | 'TRY'      | 'Local currency'       | 'No'                  | 'Company Ferron BP' | '1'          | 'Ferron BP' | '07.09.2020 17:53:38' | 'Expense'    | 'TRY'                 |
			And I select current line in "R1021B_VendorsTransactions" table
			And I select "Expense" exact value from the drop-down list named "R1021B_VendorsTransactionsRecordType" in "R1021B_VendorsTransactions" table
			And I finish line editing in "R1021B_VendorsTransactions" table
			And I go to line in "R1021B_VendorsTransactions" table
				| 'Active' | 'Agreement'          | 'Amount'   | 'Basis'                                         | 'Company'      | 'Currency' | 'CurrencyMovementType' | 'DeferredCalculation' | 'LegalName'         | 'LineNumber' | 'Partner'   | 'Period'              | 'RecordType' | 'TransactionCurrency' |
				| 'Yes'    | 'Vendor Ferron, TRY' | '23 454,40' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | 'Main Company' | 'USD'      | 'Reporting currency'   | 'No'                  | 'Company Ferron BP' | '2'          | 'Ferron BP' | '07.09.2020 17:53:38' | 'Receipt'    | 'TRY'                 |
			And I select current line in "R1021B_VendorsTransactions" table
			And I select "Expense" exact value from the drop-down list named "R1021B_VendorsTransactionsRecordType" in "R1021B_VendorsTransactions" table
			And I finish line editing in "R1021B_VendorsTransactions" table
			And I go to line in "R1021B_VendorsTransactions" table
				| 'Active' | 'Agreement'          | 'Amount'     | 'Basis'                                         | 'Company'      | 'Currency' | 'CurrencyMovementType'    | 'DeferredCalculation' | 'LegalName'         | 'LineNumber' | 'Partner'   | 'Period'              | 'RecordType' | 'TransactionCurrency' |
				| 'Yes'    | 'Vendor Ferron, TRY' | '137 000,00' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | 'Main Company' | 'TRY'      | 'en description is empty' | 'No'                  | 'Company Ferron BP' | '3'          | 'Ferron BP' | '07.09.2020 17:53:38' | 'Receipt'    | 'TRY'                 |
			And I select current line in "R1021B_VendorsTransactions" table
			And I select "Expense" exact value from the drop-down list named "R1021B_VendorsTransactionsRecordType" in "R1021B_VendorsTransactions" table
			And I finish line editing in "R1021B_VendorsTransactions" table
			And I go to line in "R1021B_VendorsTransactions" table
				| 'Active' | 'Agreement'          | 'Amount'    | 'Basis'                                         | 'Company'      | 'Currency' | 'CurrencyMovementType' | 'DeferredCalculation' | 'LegalName'         | 'LineNumber' | 'Partner'   | 'Period'              | 'RecordType' | 'TransactionCurrency' |
				| 'Yes'    | 'Vendor Ferron, TRY' | '23 454,40' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | 'Main Company' | 'USD'      | 'Reporting currency'   | 'No'                  | 'Company Ferron BP' | '2'          | 'Ferron BP' | '07.09.2020 17:53:38' | 'Expense'    | 'TRY'                 |
			And I activate field named "R1021B_VendorsTransactionsCompany" in "R1021B_VendorsTransactions" table
		* Change movements for R1040B_TaxesOutgoing
			And I move to "R1040B_TaxesOutgoing *" tab
			And I go to line in "R1040B_TaxesOutgoing" table
				| 'Active' | 'Company'      | 'Period'              | 'RecordType' | 'Tax' | 'Amount'   | 'TaxRate' |
				| 'Yes'    | 'Main Company' | '07.09.2020 17:53:38' | 'Receipt'    | 'VAT' | '3 577,79' | '18%'     |
			And I activate "Amount" field in "R1040B_TaxesOutgoing" table
			And I select current line in "R1040B_TaxesOutgoing" table
			And I input "35 593,23" text in "Amount" field of "R1040B_TaxesOutgoing" table
			And I finish line editing in "R1040B_TaxesOutgoing" table
		* Change movements for R5020B_PartnersBalance
			And I move to "R5020B_PartnersBalance (3)" tab
			And I activate field named "R5020B_PartnersBalanceRecordType" in "R5020B_PartnersBalance" table
			And I select current line in "R5020B_PartnersBalance" table
			And I select "Receipt" exact value from the drop-down list named "R5020B_PartnersBalanceRecordType" in "R5020B_PartnersBalance" table
			And I finish line editing in "R5020B_PartnersBalance" table
			And I go to line in "R5020B_PartnersBalance" table
				| 'Active' | 'Agreement'          | 'Amount'     | 'Company'      | 'Currency' | 'CurrencyMovementType' | 'Document'                                      | 'LegalName'         | 'LineNumber' | 'Partner'   | 'Period'              | 'RecordType' | 'TransactionCurrency' | 'VendorTransaction' |
				| 'Yes'    | 'Vendor Ferron, TRY' | '137 000,00' | 'Main Company' | 'TRY'      | 'Local currency'       | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | 'Company Ferron BP' | '1'          | 'Ferron BP' | '07.09.2020 17:53:38' | 'Receipt'    | 'TRY'                 | '137 000,00'        |			
			And I select "Receipt" exact value from the drop-down list named "R5020B_PartnersBalanceRecordType" in "R5020B_PartnersBalance" table
			And I finish line editing in "R5020B_PartnersBalance" table
			And I go to line in "R5020B_PartnersBalance" table
				| 'Active' | 'Agreement'          | 'Amount'    | 'Company'      | 'Currency' | 'CurrencyMovementType' | 'Document'                                      | 'LegalName'         | 'LineNumber' | 'Partner'   | 'Period'              | 'RecordType' | 'TransactionCurrency' | 'VendorTransaction' |
				| 'Yes'    | 'Vendor Ferron, TRY' | '23 454,40' | 'Main Company' | 'USD'      | 'Reporting currency'   | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | 'Company Ferron BP' | '2'          | 'Ferron BP' | '07.09.2020 17:53:38' | 'Expense'    | 'TRY'                 | '23 454,40'         |
			And I select current line in "R5020B_PartnersBalance" table
			And I select "Receipt" exact value from the drop-down list named "R5020B_PartnersBalanceRecordType" in "R5020B_PartnersBalance" table
			And I finish line editing in "R5020B_PartnersBalance" table
			And I go to line in "R5020B_PartnersBalance" table
				| 'Active' | 'Agreement'          | 'Amount'     | 'Company'      | 'Currency' | 'CurrencyMovementType'    | 'Document'                                      | 'LegalName'         | 'LineNumber' | 'Partner'   | 'Period'              | 'RecordType' | 'TransactionCurrency' | 'VendorTransaction' |
				| 'Yes'    | 'Vendor Ferron, TRY' | '137 000,00' | 'Main Company' | 'TRY'      | 'en description is empty' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | 'Company Ferron BP' | '3'          | 'Ferron BP' | '07.09.2020 17:53:38' | 'Expense'    | 'TRY'                 | '137 000,00'        |
			And I select current line in "R5020B_PartnersBalance" table
			And I select "Receipt" exact value from the drop-down list named "R5020B_PartnersBalanceRecordType" in "R5020B_PartnersBalance" table
			And I finish line editing in "R5020B_PartnersBalance" table
			And I go to line in "R5020B_PartnersBalance" table
				| 'Active' | 'Agreement'          | 'Amount'     | 'Company'      | 'Currency' | 'CurrencyMovementType' | 'Document'                                      | 'LegalName'         | 'LineNumber' | 'Partner'   | 'Period'              | 'RecordType' | 'TransactionCurrency' | 'VendorTransaction' |
				| 'Yes'    | 'Vendor Ferron, TRY' | '137 000,00' | 'Main Company' | 'TRY'      | 'Local currency'       | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | 'Company Ferron BP' | '1'          | 'Ferron BP' | '07.09.2020 17:53:38' | 'Receipt'    | 'TRY'                 | '137 000,00'        |
			And I activate "VendorTransaction" field in "R5020B_PartnersBalance" table
			And I select current line in "R5020B_PartnersBalance" table
			And I input "-137 000" text in "VendorTransaction" field of "R5020B_PartnersBalance" table
			And I finish line editing in "R5020B_PartnersBalance" table
			And I go to line in "R5020B_PartnersBalance" table
				| 'Active' | 'Agreement'          | 'Amount'    | 'Company'      | 'Currency' | 'CurrencyMovementType' | 'Document'                                      | 'LegalName'         | 'LineNumber' | 'Partner'   | 'Period'              | 'RecordType' | 'TransactionCurrency' | 'VendorTransaction' |
				| 'Yes'    | 'Vendor Ferron, TRY' | '23 454,40' | 'Main Company' | 'USD'      | 'Reporting currency'   | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | 'Company Ferron BP' | '2'          | 'Ferron BP' | '07.09.2020 17:53:38' | 'Receipt'    | 'TRY'                 | '23 454,40'         |
			And I select current line in "R5020B_PartnersBalance" table
			And I input "-23 454,4" text in "VendorTransaction" field of "R5020B_PartnersBalance" table
			And I finish line editing in "R5020B_PartnersBalance" table
			And I go to line in "R5020B_PartnersBalance" table
				| 'Active' | 'Agreement'          | 'Amount'     | 'Company'      | 'Currency' | 'CurrencyMovementType'    | 'Document'                                      | 'LegalName'         | 'LineNumber' | 'Partner'   | 'Period'              | 'RecordType' | 'TransactionCurrency' | 'VendorTransaction' |
				| 'Yes'    | 'Vendor Ferron, TRY' | '137 000,00' | 'Main Company' | 'TRY'      | 'en description is empty' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | 'Company Ferron BP' | '3'          | 'Ferron BP' | '07.09.2020 17:53:38' | 'Receipt'    | 'TRY'                 | '137 000,00'        |
			And I select current line in "R5020B_PartnersBalance" table
			And I input "-137 000" text in "VendorTransaction" field of "R5020B_PartnersBalance" table
			And I finish line editing in "R5020B_PartnersBalance" table
			And I click "Write movements (register self-control)" button			
	* Check
		Then there are lines in TestClient message log
			|'Movements successfully recorded'|
	* Try post/unpost document with manual modification
		When in opened panel I select "Purchase invoices"
		And I go to line in "List" table
			| 'Number' |
			| '12'     |
		And I select current line in "List" table
		And I click "Post" button
		Then there are lines in TestClient message log
			|'Document`s movements had been modified manually. Reposting or undoposting is disabled due to manual adjustments.'|		
		And I click the button named "FormUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"		
		Then there are lines in TestClient message log
			|'The document has manual entries and cannot be canceled.'|
	* Check manual modifications
		When in opened panel I select "Purchase invoice 12 dated 07.09.2020 17:53:38: Document registrations report"
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I expand "Filters" group
		And I set checkbox "Show technical columns"
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 12 dated 07.09.2020 17:53:38'       | ''           | ''          | ''                    | ''           | ''             | ''       | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                              | ''      | ''        | ''         | ''                     | ''                         |
			| 'Register  "R1021 Vendors transactions !Manual edit"' | ''           | ''          | ''                    | ''           | ''             | ''       | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                              | ''      | ''        | ''         | ''                     | ''                         |
			| ''                                                    | 'ManualEdit' | 'Potential' | 'Period'              | 'RecordType' | 'Company'      | 'Branch' | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Agreement'          | 'Basis'                                         | 'Order' | 'Project' | 'Amount'   | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                                    | 'No'         | 'Yes'       | '07.09.2020 17:53:38' | 'Receipt'    | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | ''      | ''        | '137 000'  | 'No'                   | ''                         |
			| ''                                                    | 'No'         | 'Yes'       | '07.09.2020 17:53:38' | 'Receipt'    | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | ''      | ''        | '137 000'  | 'No'                   | ''                         |
			| ''                                                    | 'No'         | 'Yes'       | '07.09.2020 17:53:38' | 'Receipt'    | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | ''      | ''        | '23 454,4' | 'No'                   | ''                         |
			| ''                                                    | 'Yes'        | 'No'        | '07.09.2020 17:53:38' | 'Expense'    | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | ''      | ''        | '137 000'  | 'No'                   | ''                         |
			| ''                                                    | 'Yes'        | 'No'        | '07.09.2020 17:53:38' | 'Expense'    | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | ''      | ''        | '137 000'  | 'No'                   | ''                         |
			| ''                                                    | 'Yes'        | 'No'        | '07.09.2020 17:53:38' | 'Expense'    | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | ''      | ''        | '23 454,4' | 'No'                   | ''                         |
		And I select "R1040 Taxes outgoing" exact value from "Register" drop-down list
		
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 12 dated 07.09.2020 17:53:38'   | ''           | ''          | ''                    | ''           | ''             | ''       | ''          | ''                  | ''                   | ''                                              | ''         | ''                             | ''                     | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| 'Register  "R5020 Partners balance !Manual edit"' | ''           | ''          | ''                    | ''           | ''             | ''       | ''          | ''                  | ''                   | ''                                              | ''         | ''                             | ''                     | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                                | 'ManualEdit' | 'Potential' | 'Period'              | 'RecordType' | 'Company'      | 'Branch' | 'Partner'   | 'Legal name'        | 'Agreement'          | 'Document'                                      | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Advances closing' |
			| ''                                                | 'No'         | 'Yes'       | '07.09.2020 17:53:38' | 'Expense'    | 'Main Company' | ''       | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | 'TRY'      | 'en description is empty'      | 'TRY'                  | '137 000'   | ''                     | ''                 | '137 000'            | ''               | ''                  | ''                 |
			| ''                                                | 'No'         | 'Yes'       | '07.09.2020 17:53:38' | 'Expense'    | 'Main Company' | ''       | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | 'TRY'      | 'Local currency'               | 'TRY'                  | '137 000'   | ''                     | ''                 | '137 000'            | ''               | ''                  | ''                 |
			| ''                                                | 'No'         | 'Yes'       | '07.09.2020 17:53:38' | 'Expense'    | 'Main Company' | ''       | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | 'USD'      | 'Reporting currency'           | 'TRY'                  | '23 454,4'  | ''                     | ''                 | '23 454,4'           | ''               | ''                  | ''                 |
			| ''                                                | 'Yes'        | 'No'        | '07.09.2020 17:53:38' | 'Receipt'    | 'Main Company' | ''       | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | 'TRY'      | 'en description is empty'      | 'TRY'                  | '-137 000'  | ''                     | ''                 | '-137 000'           | ''               | ''                  | ''                 |
			| ''                                                | 'Yes'        | 'No'        | '07.09.2020 17:53:38' | 'Receipt'    | 'Main Company' | ''       | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | 'TRY'      | 'Local currency'               | 'TRY'                  | '-137 000'  | ''                     | ''                 | '-137 000'           | ''               | ''                  | ''                 |
			| ''                                                | 'Yes'        | 'No'        | '07.09.2020 17:53:38' | 'Receipt'    | 'Main Company' | ''       | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | 'USD'      | 'Reporting currency'           | 'TRY'                  | '-23 454,4' | ''                     | ''                 | '-23 454,4'          | ''               | ''                  | ''                 |
		And I close all client application windows
	* Cancel manual changes
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '12'     |
		And I click "Registrations report info" button
		And I click "Edit" button
		And I remove checkbox "Manual edit"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then there are lines in TestClient message log
			|'Movements successfully recorded'|
	* Check
		When in opened panel I select "Purchase invoice 12 dated 07.09.2020 17:53:38: Document registrations report"
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I expand "Filters" group
		And I set checkbox "Show technical columns"
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 12 dated 07.09.2020 17:53:38' | ''                    | ''           | ''             | ''       | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                              | ''      | ''        | ''         | ''                     | ''                         |
			| 'Register  "R1021 Vendors transactions"'        | ''                    | ''           | ''             | ''       | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                              | ''      | ''        | ''         | ''                     | ''                         |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch' | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Agreement'          | 'Basis'                                         | 'Order' | 'Project' | 'Amount'   | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                              | '07.09.2020 17:53:38' | 'Receipt'    | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | ''      | ''        | '137 000'  | 'No'                   | ''                         |
			| ''                                              | '07.09.2020 17:53:38' | 'Receipt'    | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | ''      | ''        | '23 454,4' | 'No'                   | ''                         |
			| ''                                              | '07.09.2020 17:53:38' | 'Receipt'    | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | ''      | ''        | '137 000'  | 'No'                   | ''                         |
		And I select "R1040 Taxes outgoing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 12 dated 07.09.2020 17:53:38' | ''                    | ''           | ''             | ''       | ''    | ''         | ''             | ''                             | ''         | ''                     | ''          |
			| 'Register  "R1040 Taxes outgoing"'              | ''                    | ''           | ''             | ''       | ''    | ''         | ''             | ''                             | ''         | ''                     | ''          |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch' | 'Tax' | 'Tax rate' | 'Invoice type' | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Amount'    |
			| ''                                              | '07.09.2020 17:53:38' | 'Receipt'    | 'Main Company' | ''       | 'VAT' | '18%'      | 'Invoice'      | 'Local currency'               | 'TRY'      | 'TRY'                  | '20 898,31' |
			| ''                                              | '07.09.2020 17:53:38' | 'Receipt'    | 'Main Company' | ''       | 'VAT' | '18%'      | 'Invoice'      | 'Reporting currency'           | 'USD'      | 'TRY'                  | '3 577,79'  |
			| ''                                              | '07.09.2020 17:53:38' | 'Receipt'    | 'Main Company' | ''       | 'VAT' | '18%'      | 'Invoice'      | 'en description is empty'      | 'TRY'      | 'TRY'                  | '20 898,31' |		
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 12 dated 07.09.2020 17:53:38' | ''                    | ''           | ''             | ''       | ''          | ''                  | ''                   | ''                                              | ''         | ''                             | ''                     | ''         | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| 'Register  "R5020 Partners balance"'            | ''                    | ''           | ''             | ''       | ''          | ''                  | ''                   | ''                                              | ''         | ''                             | ''                     | ''         | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch' | 'Partner'   | 'Legal name'        | 'Agreement'          | 'Document'                                      | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Amount'   | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Advances closing' |
			| ''                                              | '07.09.2020 17:53:38' | 'Expense'    | 'Main Company' | ''       | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | 'TRY'      | 'Local currency'               | 'TRY'                  | '137 000'  | ''                     | ''                 | '137 000'            | ''               | ''                  | ''                 |
			| ''                                              | '07.09.2020 17:53:38' | 'Expense'    | 'Main Company' | ''       | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | 'TRY'      | 'en description is empty'      | 'TRY'                  | '137 000'  | ''                     | ''                 | '137 000'            | ''               | ''                  | ''                 |
			| ''                                              | '07.09.2020 17:53:38' | 'Expense'    | 'Main Company' | ''       | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | 'USD'      | 'Reporting currency'           | 'TRY'                  | '23 454,4' | ''                     | ''                 | '23 454,4'           | ''               | ''                  | ''                 |
		And I close all client application windows
		
Scenario: _605704 check Reread button in the Data processor Edit documents movements
	And I close all client application windows
	* Select PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '12'     |
	* Change movements
		And I click "Registrations report info" button
		And I click "Edit" button
		And I set checkbox "Manual edit"
		And I move to "R4011B_FreeStocks (3)" tab
		And I go to line in "R4011B_FreeStocks" table
			| 'Active' | 'ItemKey'   | 'Quantity' | 'RecordType' | 'Store'    |
			| 'Yes'    | '36/Yellow' | '300,000'  | 'Receipt'    | 'Store 01' |
		And I select current line in "R4011B_FreeStocks" table
		And I click choice button of the attribute named "R4011B_FreeStocksStore" in "R4011B_FreeStocks" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I finish line editing in "R4011B_FreeStocks" table
		And "R4011B_FreeStocks" table became equal
			| 'Period'              | 'LineNumber' | 'Active' | 'RecordType' | 'Store'    | 'ItemKey'   | 'Quantity' |
			| '07.09.2020 17:53:38' | '1'          | 'Yes'    | 'Receipt'    | 'Store 01' | 'M/White'   | '100,000'  |
			| '07.09.2020 17:53:38' | '2'          | 'Yes'    | 'Receipt'    | 'Store 01' | 'L/Green'   | '200,000'  |
			| '07.09.2020 17:53:38' | '3'          | 'Yes'    | 'Receipt'    | 'Store 02' | '36/Yellow' | '300,000'  |
	* Reread movements
		And I click "Reread posting data" button
		And "R4011B_FreeStocks" table became equal
			| 'Active' | 'RecordType' | 'Store'    | 'ItemKey'   | 'Quantity' |
			| 'Yes'    | 'Receipt'    | 'Store 01' | 'M/White'   | '100,000'  |
			| 'Yes'    | 'Receipt'    | 'Store 01' | 'L/Green'   | '200,000'  |
			| 'Yes'    | 'Receipt'    | 'Store 01' | '36/Yellow' | '300,000'  |
	And I close all client application windows
	


				


