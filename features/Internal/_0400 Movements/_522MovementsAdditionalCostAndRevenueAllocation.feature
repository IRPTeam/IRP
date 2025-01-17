#language: en
@tree
@Positive
@Movements3
@MovementsAdditionalCostAndRevenueAllocation

Functionality: check Additional cost and revenue allocation movements

Variables:
import "Variables.feature"

Scenario: _052200 preparation (Additional cost and revenue allocation)
	When set True value to the constant
	When set True value to the constant Use commission trading
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Partners objects (trade agent and consignor)
		When Create catalog Stores (trade agent)
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Countries objects
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
		When Create catalog PartnersBankAccounts objects
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create information register Taxes records (VAT)
		When Create catalog Projects objects
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
	When Create catalog LegalNameContracts objects
	When Create catalog CancelReturnReasons objects
	When Create catalog CashAccounts objects
	When Create catalog SerialLotNumbers objects
	When settings for Main Company (commission trade)
	* Load documents
	When data preparation for Additional cost and revenue allocation movements
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(2203).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(2204).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesInvoice.FindByNumber(2203).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
		| "Documents.AdditionalCostAllocation.FindByNumber(2203).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
		| "Documents.AdditionalRevenueAllocation.FindByNumber(2203).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I close all client application windows
	

Scenario: _052201 check preparation
	When check preparation

Scenario: _052202 check Additional cost allocation movements by the Register  "R6070 Other periods expenses"
	* Select Additional cost allocation
		Given I open hyperlink "e1cib/list/Document.AdditionalCostAllocation"
		And I go to line in "List" table
			| 'Number'    |
			| '2 203'     |
	* Check movements by the Register  "R6070 Other periods expenses"
		And I click "Registrations report" button
		And I select "R6070 Other periods expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Additional cost allocation 2 203 dated 14.01.2025 09:50:56' | ''            | ''                    | ''          | ''           | ''             | ''             | ''                                     | ''                                                 | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                   |
			| 'Document registrations records'                             | ''            | ''                    | ''          | ''           | ''             | ''             | ''                                     | ''                                                 | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                   |
			| 'Register  "R6070 Other periods expenses"'                   | ''            | ''                    | ''          | ''           | ''             | ''             | ''                                     | ''                                                 | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                   |
			| ''                                                           | 'Record type' | 'Period'              | 'Resources' | ''           | 'Dimensions'   | ''             | ''                                     | ''                                                 | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                   |
			| ''                                                           | ''            | ''                    | 'Amount'    | 'Amount tax' | 'Company'      | 'Branch'       | 'Row ID'                               | 'Basis'                                            | 'Item key' | 'Currency' | 'Transaction currency' | 'Currency movement type'  | 'Other period expense type' | 'Expense type' | 'Profit loss center' |
			| ''                                                           | 'Expense'     | '14.01.2025 09:50:56' | '17,12'     | '3,08'       | 'Main Company' | 'Front office' | '437f6354-7e91-4515-b576-87ac4eb85596' | 'Purchase invoice 2 204 dated 14.01.2025 09:49:27' | 'Internet' | 'USD'      | 'TRY'                  | 'Reporting currency'      | 'Items cost'                | ''             | ''                   |
			| ''                                                           | 'Expense'     | '14.01.2025 09:50:56' | '100'       | '18'         | 'Main Company' | 'Front office' | '437f6354-7e91-4515-b576-87ac4eb85596' | 'Purchase invoice 2 204 dated 14.01.2025 09:49:27' | 'Internet' | 'TRY'      | 'TRY'                  | 'Local currency'          | 'Items cost'                | ''             | ''                   |
			| ''                                                           | 'Expense'     | '14.01.2025 09:50:56' | '100'       | '18'         | 'Main Company' | 'Front office' | '437f6354-7e91-4515-b576-87ac4eb85596' | 'Purchase invoice 2 204 dated 14.01.2025 09:49:27' | 'Internet' | 'TRY'      | 'TRY'                  | 'en description is empty' | 'Items cost'                | ''             | ''                   |
			| ''                                                           | 'Expense'     | '14.01.2025 09:50:56' | '102,72'    | '18,49'      | 'Main Company' | 'Front office' | 'b98ff319-037a-4b57-9619-451216e3dc09' | 'Purchase invoice 2 204 dated 14.01.2025 09:49:27' | 'Rent'     | 'USD'      | 'TRY'                  | 'Reporting currency'      | 'Items cost'                | ''             | ''                   |
			| ''                                                           | 'Expense'     | '14.01.2025 09:50:56' | '600'       | '108'        | 'Main Company' | 'Front office' | 'b98ff319-037a-4b57-9619-451216e3dc09' | 'Purchase invoice 2 204 dated 14.01.2025 09:49:27' | 'Rent'     | 'TRY'      | 'TRY'                  | 'Local currency'          | 'Items cost'                | ''             | ''                   |
			| ''                                                           | 'Expense'     | '14.01.2025 09:50:56' | '600'       | '108'        | 'Main Company' | 'Front office' | 'b98ff319-037a-4b57-9619-451216e3dc09' | 'Purchase invoice 2 204 dated 14.01.2025 09:49:27' | 'Rent'     | 'TRY'      | 'TRY'                  | 'en description is empty' | 'Items cost'                | ''             | ''                   |		
		And I close all client application windows


Scenario: _052204 check Additional cost allocation movements by the Register  "T1040 Accounting amounts"
	* Select Additional cost allocation
		Given I open hyperlink "e1cib/list/Document.AdditionalCostAllocation"
		And I go to line in "List" table
			| 'Number'    |
			| '2 203'     |
	* Check movements by the Register  "T1040 Accounting amounts"
		And I click "Registrations report" button
		And I select "T1040 Accounting amounts" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Additional cost allocation 2 203 dated 14.01.2025 09:50:56' | ''                    | ''          | ''                   | ''                   | ''           | ''                        | ''                             | ''         | ''                    | ''            | ''            | ''                     | ''                 |
			| 'Document registrations records'                             | ''                    | ''          | ''                   | ''                   | ''           | ''                        | ''                             | ''         | ''                    | ''            | ''            | ''                     | ''                 |
			| 'Register  "T1040 Accounting amounts"'                       | ''                    | ''          | ''                   | ''                   | ''           | ''                        | ''                             | ''         | ''                    | ''            | ''            | ''                     | ''                 |
			| ''                                                           | 'Period'              | 'Resources' | ''                   | ''                   | 'Dimensions' | ''                        | ''                             | ''         | ''                    | ''            | ''            | 'Attributes'           | ''                 |
			| ''                                                           | ''                    | 'Amount'    | 'Dr currency amount' | 'Cr currency amount' | 'Row key'    | 'Operation'               | 'Multi currency movement type' | 'Currency' | 'Revaluated currency' | 'Dr currency' | 'Cr currency' | 'Deferred calculation' | 'Advances closing' |
			| ''                                                           | '14.01.2025 09:50:56' | '0,97'      | '5,65'               | '5,65'               | '*'          | 'en description is empty' | 'Reporting currency'           | 'USD'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '0,97'      | '5,65'               | '5,65'               | '*'          | 'en description is empty' | 'Reporting currency'           | 'USD'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '1,45'      | '8,47'               | '8,47'               | '*'          | 'en description is empty' | 'Reporting currency'           | 'USD'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '1,74'      | '10,17'              | '10,17'              | '*'          | 'en description is empty' | 'Reporting currency'           | 'USD'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '2,32'      | '13,56'              | '13,56'              | '*'          | 'en description is empty' | 'Reporting currency'           | 'USD'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '5,65'      | '5,65'               | '5,65'               | '*'          | 'en description is empty' | 'Local currency'               | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '5,65'      | '5,65'               | '5,65'               | '*'          | 'en description is empty' | 'en description is empty'      | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '5,65'      | '5,65'               | '5,65'               | '*'          | 'en description is empty' | 'Local currency'               | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '5,65'      | '5,65'               | '5,65'               | '*'          | 'en description is empty' | 'en description is empty'      | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '5,8'       | '33,9'               | '33,9'               | '*'          | 'en description is empty' | 'Reporting currency'           | 'USD'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '5,8'       | '33,9'               | '33,9'               | '*'          | 'en description is empty' | 'Reporting currency'           | 'USD'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '8,47'      | '8,47'               | '8,47'               | '*'          | 'en description is empty' | 'Local currency'               | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '8,47'      | '8,47'               | '8,47'               | '*'          | 'en description is empty' | 'en description is empty'      | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '8,71'      | '50,85'              | '50,85'              | '*'          | 'en description is empty' | 'Reporting currency'           | 'USD'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '9,67'      | '56,5'               | '56,5'               | '*'          | 'en description is empty' | 'Reporting currency'           | 'USD'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '10,17'     | '10,17'              | '10,17'              | '*'          | 'en description is empty' | 'Local currency'               | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '10,17'     | '10,17'              | '10,17'              | '*'          | 'en description is empty' | 'en description is empty'      | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '10,45'     | '61,02'              | '61,02'              | '*'          | 'en description is empty' | 'Reporting currency'           | 'USD'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '13,56'     | '13,56'              | '13,56'              | '*'          | 'en description is empty' | 'Local currency'               | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '13,56'     | '13,56'              | '13,56'              | '*'          | 'en description is empty' | 'en description is empty'      | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '13,93'     | '81,36'              | '81,36'              | '*'          | 'en description is empty' | 'Reporting currency'           | 'USD'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '33,9'      | '33,9'               | '33,9'               | '*'          | 'en description is empty' | 'Local currency'               | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '33,9'      | '33,9'               | '33,9'               | '*'          | 'en description is empty' | 'en description is empty'      | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '33,9'      | '33,9'               | '33,9'               | '*'          | 'en description is empty' | 'Local currency'               | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '33,9'      | '33,9'               | '33,9'               | '*'          | 'en description is empty' | 'en description is empty'      | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '50,85'     | '50,85'              | '50,85'              | '*'          | 'en description is empty' | 'Local currency'               | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '50,85'     | '50,85'              | '50,85'              | '*'          | 'en description is empty' | 'en description is empty'      | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '56,5'      | '56,5'               | '56,5'               | '*'          | 'en description is empty' | 'Local currency'               | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '56,5'      | '56,5'               | '56,5'               | '*'          | 'en description is empty' | 'en description is empty'      | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '58,03'     | '338,97'             | '338,97'             | '*'          | 'en description is empty' | 'Reporting currency'           | 'USD'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '61,02'     | '61,02'              | '61,02'              | '*'          | 'en description is empty' | 'Local currency'               | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '61,02'     | '61,02'              | '61,02'              | '*'          | 'en description is empty' | 'en description is empty'      | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '81,36'     | '81,36'              | '81,36'              | '*'          | 'en description is empty' | 'Local currency'               | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '81,36'     | '81,36'              | '81,36'              | '*'          | 'en description is empty' | 'en description is empty'      | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '338,97'    | '338,97'             | '338,97'             | '*'          | 'en description is empty' | 'Local currency'               | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                           | '14.01.2025 09:50:56' | '338,97'    | '338,97'             | '338,97'             | '*'          | 'en description is empty' | 'en description is empty'      | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
		And I close all client application windows

Scenario: _052205 check Additional cost allocation movements by the Register  "T6020 Batch keys info"
	* Select Additional cost allocation
		Given I open hyperlink "e1cib/list/Document.AdditionalCostAllocation"
		And I go to line in "List" table
			| 'Number'    |
			| '2 203'     |
	* Check movements by the Register  "T6020 Batch keys info"
		And I click "Registrations report" button
		And I select "T6020 Batch keys info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Additional cost allocation 2 203 dated 14.01.2025 09:50:56' | ''                    | ''          | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | ''                         | ''                             | ''             | ''       | ''         | ''          | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''     | ''           | ''                       | ''                  | ''                 | ''                    | ''                                                 | ''            |
			| 'Document registrations records'                             | ''                    | ''          | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | ''                         | ''                             | ''             | ''       | ''         | ''          | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''     | ''           | ''                       | ''                  | ''                 | ''                    | ''                                                 | ''            |
			| 'Register  "T6020 Batch keys info"'                          | ''                    | ''          | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | ''                         | ''                             | ''             | ''       | ''         | ''          | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''     | ''           | ''                       | ''                  | ''                 | ''                    | ''                                                 | ''            |
			| ''                                                           | 'Period'              | 'Resources' | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | ''                         | ''                             | 'Dimensions'   | ''       | ''         | ''          | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''     | ''           | ''                       | ''                  | ''                 | ''                    | ''                                                 | ''            |
			| ''                                                           | ''                    | 'Quantity'  | 'Invoice amount' | 'Invoice tax amount' | 'Indirect cost amount' | 'Indirect cost tax amount' | 'Extra cost amount by ratio' | 'Extra cost tax amount by ratio' | 'Extra direct cost amount' | 'Extra direct cost tax amount' | 'Allocated cost amount' | 'Allocated cost tax amount' | 'Allocated revenue amount' | 'Allocated revenue tax amount' | 'Company'      | 'Branch' | 'Store'    | 'Item key'  | 'Direction' | 'Currency movement type' | 'Currency' | 'Batch document' | 'Sales invoice' | 'Row ID'                               | 'Profit loss center' | 'Expense type' | 'Work' | 'Work sheet' | 'DELETE batch consignor' | 'Serial lot number' | 'Source of origin' | 'Production document' | 'Purchase invoice document'                        | 'Fixed asset' |
			| ''                                                           | '14.01.2025 09:50:56' | ''          | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | '39,55'                 | '7,12'                      | ''                         | ''                             | 'Main Company' | ''       | 'Store 03' | 'ODS'       | 'Receipt'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''     | ''           | ''                       | ''                  | ''                 | ''                    | 'Purchase invoice 2 203 dated 12.01.2025 12:00:00' | ''            |
			| ''                                                           | '14.01.2025 09:50:56' | ''          | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | '39,55'                 | '7,12'                      | ''                         | ''                             | 'Main Company' | ''       | 'Store 03' | 'PZU'       | 'Receipt'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''     | ''           | ''                       | ''                  | ''                 | ''                    | 'Purchase invoice 2 203 dated 12.01.2025 12:00:00' | ''            |
			| ''                                                           | '14.01.2025 09:50:56' | ''          | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | '59,32'                 | '10,68'                     | ''                         | ''                             | 'Main Company' | ''       | 'Store 03' | 'PZU'       | 'Receipt'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''     | ''           | ''                       | '89088088989'       | ''                 | ''                    | 'Purchase invoice 2 203 dated 12.01.2025 12:00:00' | ''            |
			| ''                                                           | '14.01.2025 09:50:56' | ''          | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | '71,19'                 | '12,81'                     | ''                         | ''                             | 'Main Company' | ''       | 'Store 03' | 'PZU'       | 'Receipt'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''     | ''           | ''                       | '8908899877'        | ''                 | ''                    | 'Purchase invoice 2 203 dated 12.01.2025 12:00:00' | ''            |
			| ''                                                           | '14.01.2025 09:50:56' | ''          | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | '94,92'                 | '17,08'                     | ''                         | ''                             | 'Main Company' | ''       | 'Store 03' | 'PZU'       | 'Receipt'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''     | ''           | ''                       | '8908899879'        | ''                 | ''                    | 'Purchase invoice 2 203 dated 12.01.2025 12:00:00' | ''            |
			| ''                                                           | '14.01.2025 09:50:56' | ''          | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | '395,47'                | '71,19'                     | ''                         | ''                             | 'Main Company' | ''       | 'Store 03' | '36/Yellow' | 'Receipt'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''     | ''           | ''                       | ''                  | ''                 | ''                    | 'Purchase invoice 2 203 dated 12.01.2025 12:00:00' | ''            |
		And I close all client application windows

Scenario: _052206 check Additional cost allocation movements by the Register  "T6060 Batch cost allocation info"
	* Select Additional cost allocation
		Given I open hyperlink "e1cib/list/Document.AdditionalCostAllocation"
		And I go to line in "List" table
			| 'Number'    |
			| '2 203'     |
	* Check movements by the Register  "T6060 Batch cost allocation info"
		And I click "Registrations report" button
		And I select "T6060 Batch cost allocation info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Additional cost allocation 2 203 dated 14.01.2025 09:50:56' | ''                    | ''          | ''           | ''             | ''         | ''                                                 | ''          | ''                       | ''         | ''                  |
			| 'Document registrations records'                             | ''                    | ''          | ''           | ''             | ''         | ''                                                 | ''          | ''                       | ''         | ''                  |
			| 'Register  "T6060 Batch cost allocation info"'               | ''                    | ''          | ''           | ''             | ''         | ''                                                 | ''          | ''                       | ''         | ''                  |
			| ''                                                           | 'Period'              | 'Resources' | ''           | 'Dimensions'   | ''         | ''                                                 | ''          | ''                       | ''         | ''                  |
			| ''                                                           | ''                    | 'Amount'    | 'Amount tax' | 'Company'      | 'Store'    | 'Document'                                         | 'Item key'  | 'Currency movement type' | 'Currency' | 'Serial lot number' |
			| ''                                                           | '14.01.2025 09:50:56' | '39,55'     | '7,12'       | 'Main Company' | 'Store 03' | 'Purchase invoice 2 203 dated 12.01.2025 12:00:00' | 'ODS'       | 'Local currency'         | 'TRY'      | ''                  |
			| ''                                                           | '14.01.2025 09:50:56' | '39,55'     | '7,12'       | 'Main Company' | 'Store 03' | 'Purchase invoice 2 203 dated 12.01.2025 12:00:00' | 'PZU'       | 'Local currency'         | 'TRY'      | ''                  |
			| ''                                                           | '14.01.2025 09:50:56' | '59,32'     | '10,68'      | 'Main Company' | 'Store 03' | 'Purchase invoice 2 203 dated 12.01.2025 12:00:00' | 'PZU'       | 'Local currency'         | 'TRY'      | '89088088989'       |
			| ''                                                           | '14.01.2025 09:50:56' | '71,19'     | '12,81'      | 'Main Company' | 'Store 03' | 'Purchase invoice 2 203 dated 12.01.2025 12:00:00' | 'PZU'       | 'Local currency'         | 'TRY'      | '8908899877'        |
			| ''                                                           | '14.01.2025 09:50:56' | '94,92'     | '17,08'      | 'Main Company' | 'Store 03' | 'Purchase invoice 2 203 dated 12.01.2025 12:00:00' | 'PZU'       | 'Local currency'         | 'TRY'      | '8908899879'        |
			| ''                                                           | '14.01.2025 09:50:56' | '395,47'    | '71,19'      | 'Main Company' | 'Store 03' | 'Purchase invoice 2 203 dated 12.01.2025 12:00:00' | '36/Yellow' | 'Local currency'         | 'TRY'      | ''                  |
		And I close all client application windows


Scenario: _052207 check Additional revenue allocation movements by the Register  "T6060 Batch cost allocation info"
	* Select Additional cost allocation
		Given I open hyperlink "e1cib/list/Document.AdditionalRevenueAllocation"
		And I go to line in "List" table
			| 'Number'    |
			| '2 203'     |
	* Check movements by the Register  "R6080 Other periods revenues"
		And I click "Registrations report" button
		And I select "R6080 Other periods revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Additional revenue allocation 2 203 dated 14.01.2025 10:11:39' | ''            | ''                    | ''          | ''           | ''             | ''             | ''                                     | ''                                              | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                   |
			| 'Document registrations records'                                | ''            | ''                    | ''          | ''           | ''             | ''             | ''                                     | ''                                              | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                   |
			| 'Register  "R6080 Other periods revenues"'                      | ''            | ''                    | ''          | ''           | ''             | ''             | ''                                     | ''                                              | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                   |
			| ''                                                              | 'Record type' | 'Period'              | 'Resources' | ''           | 'Dimensions'   | ''             | ''                                     | ''                                              | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                   |
			| ''                                                              | ''            | ''                    | 'Amount'    | 'Amount tax' | 'Company'      | 'Branch'       | 'Row ID'                               | 'Basis'                                         | 'Item key' | 'Currency' | 'Transaction currency' | 'Currency movement type'  | 'Other period revenue type' | 'Revenue type' | 'Profit loss center' |
			| ''                                                              | 'Expense'     | '14.01.2025 10:11:39' | '34,24'     | '6,16'       | 'Main Company' | 'Front office' | '0b3fcd62-3e47-4535-b4f2-558f05f2944c' | 'Sales invoice 2 203 dated 14.01.2025 10:02:20' | 'Internet' | 'USD'      | 'TRY'                  | 'Reporting currency'      | 'Items revenue'             | ''             | ''                   |
			| ''                                                              | 'Expense'     | '14.01.2025 10:11:39' | '34,24'     | '6,16'       | 'Main Company' | 'Front office' | 'c9f1e7ed-4283-4ec6-a65c-2262ed008f97' | 'Sales invoice 2 203 dated 14.01.2025 10:02:20' | 'Rent'     | 'USD'      | 'TRY'                  | 'Reporting currency'      | 'Items revenue'             | ''             | ''                   |
			| ''                                                              | 'Expense'     | '14.01.2025 10:11:39' | '200'       | '36'         | 'Main Company' | 'Front office' | '0b3fcd62-3e47-4535-b4f2-558f05f2944c' | 'Sales invoice 2 203 dated 14.01.2025 10:02:20' | 'Internet' | 'TRY'      | 'TRY'                  | 'Local currency'          | 'Items revenue'             | ''             | ''                   |
			| ''                                                              | 'Expense'     | '14.01.2025 10:11:39' | '200'       | '36'         | 'Main Company' | 'Front office' | '0b3fcd62-3e47-4535-b4f2-558f05f2944c' | 'Sales invoice 2 203 dated 14.01.2025 10:02:20' | 'Internet' | 'TRY'      | 'TRY'                  | 'en description is empty' | 'Items revenue'             | ''             | ''                   |
			| ''                                                              | 'Expense'     | '14.01.2025 10:11:39' | '200'       | '36'         | 'Main Company' | 'Front office' | 'c9f1e7ed-4283-4ec6-a65c-2262ed008f97' | 'Sales invoice 2 203 dated 14.01.2025 10:02:20' | 'Rent'     | 'TRY'      | 'TRY'                  | 'Local currency'          | 'Items revenue'             | ''             | ''                   |
			| ''                                                              | 'Expense'     | '14.01.2025 10:11:39' | '200'       | '36'         | 'Main Company' | 'Front office' | 'c9f1e7ed-4283-4ec6-a65c-2262ed008f97' | 'Sales invoice 2 203 dated 14.01.2025 10:02:20' | 'Rent'     | 'TRY'      | 'TRY'                  | 'en description is empty' | 'Items revenue'             | ''             | ''                   |		
		And I close all client application windows

Scenario: _052208 check Additional revenue allocation movements by the Register  "T1040 Accounting amounts"
	* Select Additional cost allocation
		Given I open hyperlink "e1cib/list/Document.AdditionalRevenueAllocation"
		And I go to line in "List" table
			| 'Number'    |
			| '2 203'     |
	* Check movements by the Register  "T1040 Accounting amounts"
		And I click "Registrations report" button
		And I select "T1040 Accounting amounts" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Additional revenue allocation 2 203 dated 14.01.2025 10:11:39' | ''                    | ''          | ''                   | ''                   | ''           | ''                        | ''                             | ''         | ''                    | ''            | ''            | ''                     | ''                 |
			| 'Document registrations records'                                | ''                    | ''          | ''                   | ''                   | ''           | ''                        | ''                             | ''         | ''                    | ''            | ''            | ''                     | ''                 |
			| 'Register  "T1040 Accounting amounts"'                          | ''                    | ''          | ''                   | ''                   | ''           | ''                        | ''                             | ''         | ''                    | ''            | ''            | ''                     | ''                 |
			| ''                                                              | 'Period'              | 'Resources' | ''                   | ''                   | 'Dimensions' | ''                        | ''                             | ''         | ''                    | ''            | ''            | 'Attributes'           | ''                 |
			| ''                                                              | ''                    | 'Amount'    | 'Dr currency amount' | 'Cr currency amount' | 'Row key'    | 'Operation'               | 'Multi currency movement type' | 'Currency' | 'Revaluated currency' | 'Dr currency' | 'Cr currency' | 'Deferred calculation' | 'Advances closing' |
			| ''                                                              | '14.01.2025 10:11:39' | '13,17'     | '76,92'              | '76,92'              | '*'          | 'en description is empty' | 'Reporting currency'           | 'USD'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                              | '14.01.2025 10:11:39' | '21,07'     | '123,08'             | '123,08'             | '*'          | 'en description is empty' | 'Reporting currency'           | 'USD'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                              | '14.01.2025 10:11:39' | '34,24'     | '200'                | '200'                | '*'          | 'en description is empty' | 'Reporting currency'           | 'USD'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                              | '14.01.2025 10:11:39' | '76,92'     | '76,92'              | '76,92'              | '*'          | 'en description is empty' | 'Local currency'               | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                              | '14.01.2025 10:11:39' | '76,92'     | '76,92'              | '76,92'              | '*'          | 'en description is empty' | 'en description is empty'      | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                              | '14.01.2025 10:11:39' | '123,08'    | '123,08'             | '123,08'             | '*'          | 'en description is empty' | 'Local currency'               | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                              | '14.01.2025 10:11:39' | '123,08'    | '123,08'             | '123,08'             | '*'          | 'en description is empty' | 'en description is empty'      | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                              | '14.01.2025 10:11:39' | '200'       | '200'                | '200'                | '*'          | 'en description is empty' | 'Local currency'               | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
			| ''                                                              | '14.01.2025 10:11:39' | '200'       | '200'                | '200'                | '*'          | 'en description is empty' | 'en description is empty'      | 'TRY'      | ''                    | 'TRY'         | 'TRY'         | 'No'                   | ''                 |
		And I close all client application windows

Scenario: _052209 check Additional revenue allocation movements by the Register  "T6020 Batch keys info"
	* Select Additional cost allocation
		Given I open hyperlink "e1cib/list/Document.AdditionalRevenueAllocation"
		And I go to line in "List" table
			| 'Number'    |
			| '2 203'     |
	* Check movements by the Register  "T6020 Batch keys info"
		And I click "Registrations report" button
		And I select "T6020 Batch keys info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Additional revenue allocation 2 203 dated 14.01.2025 10:11:39' | ''                    | ''          | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | ''                         | ''                             | ''             | ''       | ''         | ''         | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''     | ''           | ''                       | ''                  | ''                 | ''                    | ''                                                 | ''            |
			| 'Document registrations records'                                | ''                    | ''          | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | ''                         | ''                             | ''             | ''       | ''         | ''         | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''     | ''           | ''                       | ''                  | ''                 | ''                    | ''                                                 | ''            |
			| 'Register  "T6020 Batch keys info"'                             | ''                    | ''          | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | ''                         | ''                             | ''             | ''       | ''         | ''         | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''     | ''           | ''                       | ''                  | ''                 | ''                    | ''                                                 | ''            |
			| ''                                                              | 'Period'              | 'Resources' | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | ''                         | ''                             | 'Dimensions'   | ''       | ''         | ''         | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''     | ''           | ''                       | ''                  | ''                 | ''                    | ''                                                 | ''            |
			| ''                                                              | ''                    | 'Quantity'  | 'Invoice amount' | 'Invoice tax amount' | 'Indirect cost amount' | 'Indirect cost tax amount' | 'Extra cost amount by ratio' | 'Extra cost tax amount by ratio' | 'Extra direct cost amount' | 'Extra direct cost tax amount' | 'Allocated cost amount' | 'Allocated cost tax amount' | 'Allocated revenue amount' | 'Allocated revenue tax amount' | 'Company'      | 'Branch' | 'Store'    | 'Item key' | 'Direction' | 'Currency movement type' | 'Currency' | 'Batch document' | 'Sales invoice' | 'Row ID'                               | 'Profit loss center' | 'Expense type' | 'Work' | 'Work sheet' | 'DELETE batch consignor' | 'Serial lot number' | 'Source of origin' | 'Production document' | 'Purchase invoice document'                        | 'Fixed asset' |
			| ''                                                              | '14.01.2025 10:11:39' | ''          | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | '76,92'                    | '13,85'                        | 'Main Company' | ''       | 'Store 03' | 'PZU'      | 'Receipt'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''     | ''           | ''                       | '89088088989'       | ''                 | ''                    | 'Purchase invoice 2 203 dated 12.01.2025 12:00:00' | ''            |
			| ''                                                              | '14.01.2025 10:11:39' | ''          | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | '123,08'                   | '22,15'                        | 'Main Company' | ''       | 'Store 03' | 'PZU'      | 'Receipt'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''     | ''           | ''                       | '8908899879'        | ''                 | ''                    | 'Purchase invoice 2 203 dated 12.01.2025 12:00:00' | ''            |
			| ''                                                              | '14.01.2025 10:11:39' | ''          | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | '200'                      | '36'                           | 'Main Company' | ''       | 'Store 03' | 'PZU'      | 'Receipt'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''     | ''           | ''                       | '8908899877'        | ''                 | ''                    | 'Purchase invoice 2 203 dated 12.01.2025 12:00:00' | ''            |		
		And I close all client application windows

Scenario: _052210 check Additional revenue allocation movements by the Register  "T6070 Batch revenue allocation info"
	* Select Additional cost allocation
		Given I open hyperlink "e1cib/list/Document.AdditionalRevenueAllocation"
		And I go to line in "List" table
			| 'Number'    |
			| '2 203'     |
	* Check movements by the Register  "T6070 Batch revenue allocation info"
		And I click "Registrations report" button
		And I select "T6070 Batch revenue allocation info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Additional revenue allocation 2 203 dated 14.01.2025 10:11:39' | ''                    | ''          | ''           | ''             | ''         | ''                                                 | ''         | ''                       | ''         | ''                  |
			| 'Document registrations records'                                | ''                    | ''          | ''           | ''             | ''         | ''                                                 | ''         | ''                       | ''         | ''                  |
			| 'Register  "T6070 Batch revenue allocation info"'               | ''                    | ''          | ''           | ''             | ''         | ''                                                 | ''         | ''                       | ''         | ''                  |
			| ''                                                              | 'Period'              | 'Resources' | ''           | 'Dimensions'   | ''         | ''                                                 | ''         | ''                       | ''         | ''                  |
			| ''                                                              | ''                    | 'Amount'    | 'Amount tax' | 'Company'      | 'Store'    | 'Document'                                         | 'Item key' | 'Currency movement type' | 'Currency' | 'Serial lot number' |
			| ''                                                              | '14.01.2025 10:11:39' | '76,92'     | '13,85'      | 'Main Company' | 'Store 03' | 'Purchase invoice 2 203 dated 12.01.2025 12:00:00' | 'PZU'      | 'Local currency'         | 'TRY'      | '89088088989'       |
			| ''                                                              | '14.01.2025 10:11:39' | '123,08'    | '22,15'      | 'Main Company' | 'Store 03' | 'Purchase invoice 2 203 dated 12.01.2025 12:00:00' | 'PZU'      | 'Local currency'         | 'TRY'      | '8908899879'        |
			| ''                                                              | '14.01.2025 10:11:39' | '200'       | '36'         | 'Main Company' | 'Store 03' | 'Purchase invoice 2 203 dated 12.01.2025 12:00:00' | 'PZU'      | 'Local currency'         | 'TRY'      | '8908899877'        |		
		And I close all client application windows