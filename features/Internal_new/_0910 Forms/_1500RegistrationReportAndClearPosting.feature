#language: en
@tree
@Positive
@Group11
Feature: check the output of the document movement report



Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _017002 check the output of the document movement report for Purchase Order
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseOrder017001$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$PurchaseOrder017001$$'            | ''            | ''       | ''          | ''             | ''                        | ''          | ''          | ''        | ''              |
		| 'Document registrations records'     | ''            | ''       | ''          | ''             | ''                        | ''          | ''          | ''        | ''              |
		| 'Register  "Goods receipt schedule"' | ''            | ''       | ''          | ''             | ''                        | ''          | ''          | ''        | ''              |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                        | ''          | ''          | ''        | 'Attributes'    |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                   | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                   | 'Receipt'     | '*'      | '100'       | 'Main Company' | '$$PurchaseOrder017001$$' | 'Store 01'  | 'M/White'   | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '200'       | 'Main Company' | '$$PurchaseOrder017001$$' | 'Store 01'  | 'L/Green'   | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '300'       | 'Main Company' | '$$PurchaseOrder017001$$' | 'Store 01'  | '36/Yellow' | '*'       | '*'             |
		| ''                                   | ''            | ''       | ''          | ''             | ''                        | ''          | ''          | ''        | ''              |
		| 'Register  "Order balance"'          | ''            | ''       | ''          | ''             | ''                        | ''          | ''          | ''        | ''              |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                        | ''          | ''          | ''        | ''              |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Store'        | 'Order'                   | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '100'       | 'Store 01'     | '$$PurchaseOrder017001$$' | 'M/White'   | '*'         | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '200'       | 'Store 01'     | '$$PurchaseOrder017001$$' | 'L/Green'   | '*'         | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '300'       | 'Store 01'     | '$$PurchaseOrder017001$$' | '36/Yellow' | '*'         | ''        | ''              |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseOrder017001$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$PurchaseOrder017001$$'            | ''            | ''       | ''          | ''             | ''                        | ''          | ''          | ''        | ''              |
		| 'Document registrations records'     | ''            | ''       | ''          | ''             | ''                        | ''          | ''          | ''        | ''              |
		| 'Register  "Goods receipt schedule"' | ''            | ''       | ''          | ''             | ''                        | ''          | ''          | ''        | ''              |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                        | ''          | ''          | ''        | 'Attributes'    |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                   | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                   | 'Receipt'     | '*'      | '100'       | 'Main Company' | '$$PurchaseOrder017001$$' | 'Store 01'  | 'M/White'   | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '200'       | 'Main Company' | '$$PurchaseOrder017001$$' | 'Store 01'  | 'L/Green'   | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '300'       | 'Main Company' | '$$PurchaseOrder017001$$' | 'Store 01'  | '36/Yellow' | '*'       | '*'             |
		| ''                                   | ''            | ''       | ''          | ''             | ''                        | ''          | ''          | ''        | ''              |
		| 'Register  "Order balance"'          | ''            | ''       | ''          | ''             | ''                        | ''          | ''          | ''        | ''              |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                        | ''          | ''          | ''        | ''              |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Store'        | 'Order'                   | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '100'       | 'Store 01'     | '$$PurchaseOrder017001$$' | 'M/White'   | '*'         | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '200'       | 'Store 01'     | '$$PurchaseOrder017001$$' | 'L/Green'   | '*'         | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '300'       | 'Store 01'     | '$$PurchaseOrder017001$$' | '36/Yellow' | '*'         | ''        | ''              |
	And I close all client application windows

Scenario: _0170020 clear movements Purchase Order and check that there is no movements on the registers
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseOrder017001$$'      |
	* Clear movements Purchase Order and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
		| Register  "Goods receipt schedule" |
		| Register  "Order balance" |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseOrder017001$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		Then "ResultTable" spreadsheet document is equal by template
		| '$$PurchaseOrder017001$$'            | ''            | ''       | ''          | ''             | ''                        | ''          | ''          | ''        | ''              |
		| 'Document registrations records'     | ''            | ''       | ''          | ''             | ''                        | ''          | ''          | ''        | ''              |
		| 'Register  "Goods receipt schedule"' | ''            | ''       | ''          | ''             | ''                        | ''          | ''          | ''        | ''              |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                        | ''          | ''          | ''        | 'Attributes'    |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                   | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                   | 'Receipt'     | '*'      | '100'       | 'Main Company' | '$$PurchaseOrder017001$$' | 'Store 01'  | 'M/White'   | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '200'       | 'Main Company' | '$$PurchaseOrder017001$$' | 'Store 01'  | 'L/Green'   | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '300'       | 'Main Company' | '$$PurchaseOrder017001$$' | 'Store 01'  | '36/Yellow' | '*'       | '*'             |
		| ''                                   | ''            | ''       | ''          | ''             | ''                        | ''          | ''          | ''        | ''              |
		| 'Register  "Order balance"'          | ''            | ''       | ''          | ''             | ''                        | ''          | ''          | ''        | ''              |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                        | ''          | ''          | ''        | ''              |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Store'        | 'Order'                   | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '100'       | 'Store 01'     | '$$PurchaseOrder017001$$' | 'M/White'   | '*'         | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '200'       | 'Store 01'     | '$$PurchaseOrder017001$$' | 'L/Green'   | '*'         | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '300'       | 'Store 01'     | '$$PurchaseOrder017001$$' | '36/Yellow' | '*'         | ''        | ''              |
	And I close all client application windows



Scenario: _016502 check the output of the document movement report for Internal Supply Request
	* Open list form Internal Supply Request
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
	* Check the report generation
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberInternalSupplyRequest016501$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		Then "ResultTable" spreadsheet document is equal by template
		| '$$InternalSupplyRequest016501$$' | ''            | ''       | ''          | ''           | ''                                | ''          | ''        |
		| 'Document registrations records'  | ''            | ''       | ''          | ''           | ''                                | ''          | ''        |
		| 'Register  "Order balance"'       | ''            | ''       | ''          | ''           | ''                                | ''          | ''        |
		| ''                                | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                                | ''          | ''        |
		| ''                                | ''            | ''       | 'Quantity'  | 'Store'      | 'Order'                           | 'Item key'  | 'Row key' |
		| ''                                | 'Receipt'     | '*'      | '10'        | 'Store 01'   | '$$InternalSupplyRequest016501$$' | '36/Yellow' | '*'       |
		| ''                                | 'Receipt'     | '*'      | '20'        | 'Store 01'   | '$$InternalSupplyRequest016501$$' | '38/Black'  | '*'       |
		| ''                                | 'Receipt'     | '*'      | '25'        | 'Store 01'   | '$$InternalSupplyRequest016501$$' | '36/Red'    | '*'       |
		And I close all client application windows
	* Check the report generation from document
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberInternalSupplyRequest016501$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		Then "ResultTable" spreadsheet document is equal by template
		| '$$InternalSupplyRequest016501$$' | ''            | ''       | ''          | ''           | ''                                | ''          | ''        |
		| 'Document registrations records'  | ''            | ''       | ''          | ''           | ''                                | ''          | ''        |
		| 'Register  "Order balance"'       | ''            | ''       | ''          | ''           | ''                                | ''          | ''        |
		| ''                                | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                                | ''          | ''        |
		| ''                                | ''            | ''       | 'Quantity'  | 'Store'      | 'Order'                           | 'Item key'  | 'Row key' |
		| ''                                | 'Receipt'     | '*'      | '10'        | 'Store 01'   | '$$InternalSupplyRequest016501$$' | '36/Yellow' | '*'       |
		| ''                                | 'Receipt'     | '*'      | '20'        | 'Store 01'   | '$$InternalSupplyRequest016501$$' | '38/Black'  | '*'       |
		| ''                                | 'Receipt'     | '*'      | '25'        | 'Store 01'   | '$$InternalSupplyRequest016501$$' | '36/Red'    | '*'       |
		And I close all client application windows

Scenario: _0170021 clear movements Internal Supply Request and check that there is no movements on the registers 
	* Open list form Internal Supply Request
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
	* Check the report generation
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberInternalSupplyRequest016501$$'      |
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| Register  "Order balance" |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberInternalSupplyRequest016501$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		Then "ResultTable" spreadsheet document is equal by template
		| '$$InternalSupplyRequest016501$$' | ''            | ''       | ''          | ''           | ''                                | ''          | ''        |
		| 'Document registrations records'  | ''            | ''       | ''          | ''           | ''                                | ''          | ''        |
		| 'Register  "Order balance"'       | ''            | ''       | ''          | ''           | ''                                | ''          | ''        |
		| ''                                | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                                | ''          | ''        |
		| ''                                | ''            | ''       | 'Quantity'  | 'Store'      | 'Order'                           | 'Item key'  | 'Row key' |
		| ''                                | 'Receipt'     | '*'      | '10'        | 'Store 01'   | '$$InternalSupplyRequest016501$$' | '36/Yellow' | '*'       |
		| ''                                | 'Receipt'     | '*'      | '20'        | 'Store 01'   | '$$InternalSupplyRequest016501$$' | '38/Black'  | '*'       |
		| ''                                | 'Receipt'     | '*'      | '25'        | 'Store 01'   | '$$InternalSupplyRequest016501$$' | '36/Red'    | '*'       |
		And I close all client application windows




Scenario: _018019 check the output of the document movement report for Purchase Invoice
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseInvoice018001$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$PurchaseInvoice018001$$'                  | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Document registrations records'       | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Inventory balance"'        | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Company'      | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Main Company' | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Main Company' | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Main Company' | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Purchase turnovers"'       | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | ''              | ''             | 'Dimensions'          | ''                    | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                     | ''            | 'Quantity'  | 'Amount'        | 'Net amount'   | 'Company'             | 'Purchase invoice'    | 'Currency'          | 'Item key'           | 'Row key'                 | 'Multi currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '3 424,66'      | '2 902,25'     | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'USD'               | 'M/White'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'M/White'            | '*'                       | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'M/White'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'M/White'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '7 191,78'      | '6 094,73'     | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'USD'               | 'L/Green'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'L/Green'            | '*'                       | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'L/Green'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'L/Green'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '12 842,47'     | '10 883,45'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'USD'               | '36/Yellow'          | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | '36/Yellow'          | '*'                       | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | '36/Yellow'          | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | '36/Yellow'          | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Taxes turnovers"'          | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | ''              | ''             | 'Dimensions'          | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | 'Attributes'           |
		| ''                                     | ''            | 'Amount'    | 'Manual amount' | 'Net amount'   | 'Document'            | 'Tax'                 | 'Analytics'         | 'Tax rate'           | 'Include to total amount' | 'Row key'                  | 'Currency'             | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                     | '*'           | '522,41'    | '522,41'        | '2 902,25'     | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '1 097,05'  | '1 097,05'      | '6 094,73'     | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '1 959,02'  | '1 959,02'      | '10 883,45'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en description is empty' | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en description is empty' | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en description is empty' | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Accounts statement"'               | ''                    | ''                    | ''                    | ''               | ''                                             | ''                                             | ''                                     | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| ''                                             | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                             | ''                                             | 'Dimensions'                           | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| ''                                             | ''                    | ''                    | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'                       | 'Transaction AR'                               | 'Company'                              | 'Partner'                              | 'Legal name'                           | 'Basis document'                       | 'Currency'             | ''                         | ''                     |
		| ''                                             | 'Receipt'             | '*'                   | ''                    | '137 000'        | ''                                             | ''                                             | 'Main Company'                         | 'Ferron BP'                            | 'Company Ferron BP'                    | '$$PurchaseInvoice018001$$'                  | 'TRY'                  | ''                         | ''                     |
		| ''                                             | ''                    | ''                    | ''                    | ''               | ''                                             | ''                                             | ''                                     | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| 'Register  "Stock reservation"'        | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Store 01'     | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Store 01'     | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Store 01'     | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Reconciliation statement"' | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'        | 'Company'      | 'Legal name'          | 'Currency'            | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '137 000'       | 'Main Company' | 'Company Ferron BP'   | 'TRY'                 | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Goods receipt schedule"'   | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | 'Attributes'              | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Company'      | 'Order'               | 'Store'               | 'Item key'          | 'Row key'            | 'Delivery date'           | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '100'           | 'Main Company' | '$$PurchaseOrder017001$$'   | 'Store 01'            | 'M/White'           | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '200'           | 'Main Company' | '$$PurchaseOrder017001$$'   | 'Store 01'            | 'L/Green'           | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '300'           | 'Main Company' | '$$PurchaseOrder017001$$'   | 'Store 01'            | '36/Yellow'         | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Partner AP transactions"'  | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'        | 'Company'      | 'Basis document'      | 'Partner'             | 'Legal name'        | 'Partner term'          | 'Currency'                | 'Multi currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '23 458,9'      | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'USD'                     | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Order balance"'            | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Order'               | 'Item key'            | 'Row key'           | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '100'           | 'Store 01'     | '$$PurchaseOrder017001$$'   | 'M/White'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '200'           | 'Store 01'     | '$$PurchaseOrder017001$$'   | 'L/Green'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '300'           | 'Store 01'     | '$$PurchaseOrder017001$$'   | '36/Yellow'           | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Stock balance"'            | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Store 01'     | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Store 01'     | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Store 01'     | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseInvoice018001$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$PurchaseInvoice018001$$'                  | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Document registrations records'       | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Inventory balance"'        | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Company'      | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Main Company' | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Main Company' | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Main Company' | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Purchase turnovers"'       | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | ''              | ''             | 'Dimensions'          | ''                    | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                     | ''            | 'Quantity'  | 'Amount'        | 'Net amount'   | 'Company'             | 'Purchase invoice'    | 'Currency'          | 'Item key'           | 'Row key'                 | 'Multi currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '3 424,66'      | '2 902,25'     | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'USD'               | 'M/White'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'M/White'            | '*'                       | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'M/White'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'M/White'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '7 191,78'      | '6 094,73'     | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'USD'               | 'L/Green'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'L/Green'            | '*'                       | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'L/Green'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'L/Green'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '12 842,47'     | '10 883,45'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'USD'               | '36/Yellow'          | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | '36/Yellow'          | '*'                       | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | '36/Yellow'          | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | '36/Yellow'          | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Taxes turnovers"'          | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | ''              | ''             | 'Dimensions'          | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | 'Attributes'           |
		| ''                                     | ''            | 'Amount'    | 'Manual amount' | 'Net amount'   | 'Document'            | 'Tax'                 | 'Analytics'         | 'Tax rate'           | 'Include to total amount' | 'Row key'                  | 'Currency'             | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                     | '*'           | '522,41'    | '522,41'        | '2 902,25'     | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '1 097,05'  | '1 097,05'      | '6 094,73'     | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '1 959,02'  | '1 959,02'      | '10 883,45'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en description is empty' | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en description is empty' | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en description is empty' | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Accounts statement"'               | ''                    | ''                    | ''                    | ''               | ''                                             | ''                                             | ''                                     | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| ''                                             | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                             | ''                                             | 'Dimensions'                           | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| ''                                             | ''                    | ''                    | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'                       | 'Transaction AR'                               | 'Company'                              | 'Partner'                              | 'Legal name'                           | 'Basis document'                       | 'Currency'             | ''                         | ''                     |
		| ''                                             | 'Receipt'             | '*'                   | ''                    | '137 000'        | ''                                             | ''                                             | 'Main Company'                         | 'Ferron BP'                            | 'Company Ferron BP'                    | '$$PurchaseInvoice018001$$'                  | 'TRY'                  | ''                         | ''                     |
		| ''                                             | ''                    | ''                    | ''                    | ''               | ''                                             | ''                                             | ''                                     | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| 'Register  "Stock reservation"'        | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Store 01'     | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Store 01'     | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Store 01'     | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Reconciliation statement"' | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'        | 'Company'      | 'Legal name'          | 'Currency'            | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '137 000'       | 'Main Company' | 'Company Ferron BP'   | 'TRY'                 | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Goods receipt schedule"'   | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | 'Attributes'              | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Company'      | 'Order'               | 'Store'               | 'Item key'          | 'Row key'            | 'Delivery date'           | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '100'           | 'Main Company' | '$$PurchaseOrder017001$$'   | 'Store 01'            | 'M/White'           | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '200'           | 'Main Company' | '$$PurchaseOrder017001$$'   | 'Store 01'            | 'L/Green'           | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '300'           | 'Main Company' | '$$PurchaseOrder017001$$'   | 'Store 01'            | '36/Yellow'         | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Partner AP transactions"'  | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'        | 'Company'      | 'Basis document'      | 'Partner'             | 'Legal name'        | 'Partner term'          | 'Currency'                | 'Multi currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '23 458,9'      | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'USD'                     | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Order balance"'            | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Order'               | 'Item key'            | 'Row key'           | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '100'           | 'Store 01'     | '$$PurchaseOrder017001$$'   | 'M/White'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '200'           | 'Store 01'     | '$$PurchaseOrder017001$$'   | 'L/Green'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '300'           | 'Store 01'     | '$$PurchaseOrder017001$$'   | '36/Yellow'           | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Stock balance"'            | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Store 01'     | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Store 01'     | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Store 01'     | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
	And I close all client application windows

Scenario: _01801901 clear movements Purchase invoice and check that there is no movements on the registers 
	* Open list form Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	* Check the report generation
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseInvoice018001$$'      |
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| Register  "Purchase turnovers" |
			| 'Register  "Inventory balance"'        |
			| 'Register  "Taxes turnovers"'          |
			| 'Register  "Stock reservation"'        |
			| 'Register  "Reconciliation statement"' |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseInvoice018001$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		Then "ResultTable" spreadsheet document is equal by template
		| '$$PurchaseInvoice018001$$'                  | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Document registrations records'       | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Inventory balance"'        | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Company'      | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Main Company' | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Main Company' | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Main Company' | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Purchase turnovers"'       | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | ''              | ''             | 'Dimensions'          | ''                    | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                     | ''            | 'Quantity'  | 'Amount'        | 'Net amount'   | 'Company'             | 'Purchase invoice'    | 'Currency'          | 'Item key'           | 'Row key'                 | 'Multi currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '3 424,66'      | '2 902,25'     | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'USD'               | 'M/White'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'M/White'            | '*'                       | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'M/White'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'M/White'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '7 191,78'      | '6 094,73'     | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'USD'               | 'L/Green'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'L/Green'            | '*'                       | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'L/Green'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'L/Green'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '12 842,47'     | '10 883,45'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'USD'               | '36/Yellow'          | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | '36/Yellow'          | '*'                       | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | '36/Yellow'          | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | '36/Yellow'          | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Taxes turnovers"'          | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | ''              | ''             | 'Dimensions'          | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | 'Attributes'           |
		| ''                                     | ''            | 'Amount'    | 'Manual amount' | 'Net amount'   | 'Document'            | 'Tax'                 | 'Analytics'         | 'Tax rate'           | 'Include to total amount' | 'Row key'                  | 'Currency'             | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                     | '*'           | '522,41'    | '522,41'        | '2 902,25'     | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '1 097,05'  | '1 097,05'      | '6 094,73'     | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '1 959,02'  | '1 959,02'      | '10 883,45'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en description is empty' | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en description is empty' | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en description is empty' | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Accounts statement"'               | ''                    | ''                    | ''                    | ''               | ''                                             | ''                                             | ''                                     | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| ''                                             | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                             | ''                                             | 'Dimensions'                           | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| ''                                             | ''                    | ''                    | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'                       | 'Transaction AR'                               | 'Company'                              | 'Partner'                              | 'Legal name'                           | 'Basis document'                       | 'Currency'             | ''                         | ''                     |
		| ''                                             | 'Receipt'             | '*'                   | ''                    | '137 000'        | ''                                             | ''                                             | 'Main Company'                         | 'Ferron BP'                            | 'Company Ferron BP'                    | '$$PurchaseInvoice018001$$'                  | 'TRY'                  | ''                         | ''                     |
		| ''                                             | ''                    | ''                    | ''                    | ''               | ''                                             | ''                                             | ''                                     | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| 'Register  "Stock reservation"'        | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Store 01'     | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Store 01'     | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Store 01'     | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Reconciliation statement"' | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'        | 'Company'      | 'Legal name'          | 'Currency'            | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '137 000'       | 'Main Company' | 'Company Ferron BP'   | 'TRY'                 | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Goods receipt schedule"'   | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | 'Attributes'              | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Company'      | 'Order'               | 'Store'               | 'Item key'          | 'Row key'            | 'Delivery date'           | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '100'           | 'Main Company' | '$$PurchaseOrder017001$$'   | 'Store 01'            | 'M/White'           | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '200'           | 'Main Company' | '$$PurchaseOrder017001$$'   | 'Store 01'            | 'L/Green'           | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '300'           | 'Main Company' | '$$PurchaseOrder017001$$'   | 'Store 01'            | '36/Yellow'         | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Partner AP transactions"'  | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'        | 'Company'      | 'Basis document'      | 'Partner'             | 'Legal name'        | 'Partner term'          | 'Currency'                | 'Multi currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '23 458,9'      | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'USD'                     | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Order balance"'            | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Order'               | 'Item key'            | 'Row key'           | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '100'           | 'Store 01'     | '$$PurchaseOrder017001$$'   | 'M/White'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '200'           | 'Store 01'     | '$$PurchaseOrder017001$$'   | 'L/Green'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '300'           | 'Store 01'     | '$$PurchaseOrder017001$$'   | '36/Yellow'           | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Stock balance"'            | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Store 01'     | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Store 01'     | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Store 01'     | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		And I close all client application windows






Scenario: _022011 check the output of the document movement report for Purchase return order
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseReturnOrder022001$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$PurchaseReturnOrder022001$$'       | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Document registrations records' | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Purchase turnovers"' | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''          | ''           | 'Dimensions'               | ''                    | ''         | ''         | ''        | ''                         | 'Attributes'           |
		| ''                               | ''            | 'Quantity'  | 'Amount'    | 'Net amount' | 'Company'                  | 'Purchase invoice'    | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                               | '*'           | '-2'        | '-451,98'   | ''           | 'Main Company'             | '$$PurchaseInvoice018006$$' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'           | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | ''           | 'Main Company'             | '$$PurchaseInvoice018006$$' | 'USD'      | 'L/Green'  | '*'       | 'en description is empty' | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | ''           | 'Main Company'             | '$$PurchaseInvoice018006$$' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | ''           | 'Main Company'             | '$$PurchaseInvoice018006$$' | 'USD'      | 'L/Green'  | '*'       | 'USD'                      | 'No'                   |
		| ''                               | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'  | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Item key'                 | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Receipt'     | '*'         | '2'         | 'Store 02'   | 'L/Green'                  | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Item key'                 | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Expense'     | '*'         | '2'         | 'Store 02'   | 'L/Green'                  | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'      | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Order'                    | 'Item key'            | 'Row key'  | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Receipt'     | '*'         | '2'         | 'Store 02'   | '$$PurchaseReturnOrder022001$$' | 'L/Green'             | '*'        | ''         | ''        | ''                         | ''                     |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseReturnOrder022001$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$PurchaseReturnOrder022001$$'       | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Document registrations records' | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Purchase turnovers"' | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''          | ''           | 'Dimensions'               | ''                    | ''         | ''         | ''        | ''                         | 'Attributes'           |
		| ''                               | ''            | 'Quantity'  | 'Amount'    | 'Net amount' | 'Company'                  | 'Purchase invoice'    | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                               | '*'           | '-2'        | '-451,98'   | ''           | 'Main Company'             | '$$PurchaseInvoice018006$$' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'           | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | ''           | 'Main Company'             | '$$PurchaseInvoice018006$$' | 'USD'      | 'L/Green'  | '*'       | 'en description is empty' | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | ''           | 'Main Company'             | '$$PurchaseInvoice018006$$' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | ''           | 'Main Company'             | '$$PurchaseInvoice018006$$' | 'USD'      | 'L/Green'  | '*'       | 'USD'                      | 'No'                   |
		| ''                               | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'  | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Item key'                 | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Receipt'     | '*'         | '2'         | 'Store 02'   | 'L/Green'                  | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Item key'                 | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Expense'     | '*'         | '2'         | 'Store 02'   | 'L/Green'                  | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'      | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Order'                    | 'Item key'            | 'Row key'  | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Receipt'     | '*'         | '2'         | 'Store 02'   | '$$PurchaseReturnOrder022001$$' | 'L/Green'             | '*'        | ''         | ''        | ''                         | ''                     |
	And I close all client application windows

Scenario: _02201101 clear movements Purchase Return Order and check that there is no movements on the registers 
	* Open list form Purchase Return Order
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	* Check the report generation
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseReturnOrder022001$$'      |
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "Purchase turnovers"' |
			| 'Register  "Order reservation"'  |
			| 'Register  "Stock reservation"'  |
			| 'Register  "Order balance"'      |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseReturnOrder022001$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		Then "ResultTable" spreadsheet document is equal by template
		| '$$PurchaseReturnOrder022001$$'       | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Document registrations records' | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Purchase turnovers"' | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''          | ''           | 'Dimensions'               | ''                    | ''         | ''         | ''        | ''                         | 'Attributes'           |
		| ''                               | ''            | 'Quantity'  | 'Amount'    | 'Net amount' | 'Company'                  | 'Purchase invoice'    | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                               | '*'           | '-2'        | '-451,98'   | ''           | 'Main Company'             | '$$PurchaseInvoice018006$$' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'           | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | ''           | 'Main Company'             | '$$PurchaseInvoice018006$$' | 'USD'      | 'L/Green'  | '*'       | 'en description is empty' | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | ''           | 'Main Company'             | '$$PurchaseInvoice018006$$' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | ''           | 'Main Company'             | '$$PurchaseInvoice018006$$' | 'USD'      | 'L/Green'  | '*'       | 'USD'                      | 'No'                   |
		| ''                               | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'  | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Item key'                 | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Receipt'     | '*'         | '2'         | 'Store 02'   | 'L/Green'                  | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Item key'                 | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Expense'     | '*'         | '2'         | 'Store 02'   | 'L/Green'                  | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'      | ''            | ''          | ''          | ''           | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                         | ''                    | ''         | ''         | ''        | ''                         | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Order'                    | 'Item key'            | 'Row key'  | ''         | ''        | ''                         | ''                     |
		| ''                               | 'Receipt'     | '*'         | '2'         | 'Store 02'   | '$$PurchaseReturnOrder022001$$' | 'L/Green'             | '*'        | ''         | ''        | ''                         | ''                     |
		And I close all client application windows






Scenario: _022336 check the output of the document movement report for Purchase Return
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseReturn022301$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$PurchaseReturn022301$$'                    | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Document registrations records'        | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Partner AR transactions"'   | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | 'Attributes'           |
		| ''                                      | ''            | ''          | 'Amount'    | 'Company'      | 'Basis document'           | 'Partner'   | 'Legal name'        | 'Partner term'          | 'Currency'                 | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                      | 'en description is empty' | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                      | 'USD'                      | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '451,98'    | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Purchase return turnovers"' | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Purchase invoice'         | 'Currency'  | 'Item key'          | 'Row key'            | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | '*'           | '-2'        | '-451,98'   | 'Main Company' | '$$PurchaseInvoice018006$$'      | 'TRY'       | 'L/Green'           | '*'                  | 'Local currency'           | 'No'                       | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'       | 'Main Company' | '$$PurchaseInvoice018006$$'      | 'USD'       | 'L/Green'           | '*'                  | 'en description is empty' | 'No'                       | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'       | 'Main Company' | '$$PurchaseInvoice018006$$'      | 'USD'       | 'L/Green'           | '*'                  | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'       | 'Main Company' | '$$PurchaseInvoice018006$$'      | 'USD'       | 'L/Green'           | '*'                  | 'USD'                      | 'No'                       | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Inventory balance"'         | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Company'      | 'Item key'                 | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'         | 'Main Company' | 'L/Green'                  | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Goods in transit outgoing"' | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Store'        | 'Shipment basis'           | 'Item key'  | 'Row key'           | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '2'         | 'Store 02'     | '$$PurchaseReturn022301$$'       | 'L/Green'   | '*'                 | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Order reservation"'         | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'                 | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'         | 'Store 02'     | 'L/Green'                  | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'              | ''                    | ''                    | ''                    | ''               | ''                                                  | ''               | ''                                     | ''                                     | ''                         | ''                         | ''                     |
		| ''                                            | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                                  | ''               | 'Dimensions'                           | ''                                     | ''                         | ''                         | ''                     |
		| ''                                            | ''                    | ''                    | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'                            | 'Transaction AR' | 'Company'                              | 'Partner'                              | 'Legal name'               | 'Basis document'           | 'Currency'             |
		| ''                                            | 'Receipt'             | '*'                   | ''                    | '-80'            | ''                                                  | ''               | 'Main Company'                         | 'Ferron BP'                            | 'Company Ferron BP'        | ''                         | 'USD'                  |
		| ''                                            | ''                    | ''                    | ''                    | ''               | ''                                                  | ''               | ''                                     | ''                                     | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"'  | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Amount'    | 'Company'      | 'Legal name'               | 'Currency'  | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | 'Company Ferron BP'        | 'USD'       | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Order balance"'             | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'                    | 'Item key'  | 'Row key'           | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'         | 'Store 02'     | '$$PurchaseReturnOrder022001$$' | 'L/Green'   | '*'                 | ''                   | ''                         | ''                         | ''                     |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseReturn022301$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$PurchaseReturn022301$$'                    | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Document registrations records'        | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Partner AR transactions"'   | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | 'Attributes'           |
		| ''                                      | ''            | ''          | 'Amount'    | 'Company'      | 'Basis document'           | 'Partner'   | 'Legal name'        | 'Partner term'          | 'Currency'                 | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                      | 'en description is empty' | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                      | 'USD'                      | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '451,98'    | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Purchase return turnovers"' | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Purchase invoice'         | 'Currency'  | 'Item key'          | 'Row key'            | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | '*'           | '-2'        | '-451,98'   | 'Main Company' | '$$PurchaseInvoice018006$$'      | 'TRY'       | 'L/Green'           | '*'                  | 'Local currency'           | 'No'                       | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'       | 'Main Company' | '$$PurchaseInvoice018006$$'      | 'USD'       | 'L/Green'           | '*'                  | 'en description is empty' | 'No'                       | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'       | 'Main Company' | '$$PurchaseInvoice018006$$'      | 'USD'       | 'L/Green'           | '*'                  | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'       | 'Main Company' | '$$PurchaseInvoice018006$$'      | 'USD'       | 'L/Green'           | '*'                  | 'USD'                      | 'No'                       | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Inventory balance"'         | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Company'      | 'Item key'                 | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'         | 'Main Company' | 'L/Green'                  | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Goods in transit outgoing"' | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Store'        | 'Shipment basis'           | 'Item key'  | 'Row key'           | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '2'         | 'Store 02'     | '$$PurchaseReturn022301$$'       | 'L/Green'   | '*'                 | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Order reservation"'         | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'                 | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'         | 'Store 02'     | 'L/Green'                  | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'              | ''                    | ''                    | ''                    | ''               | ''                                                  | ''               | ''                                     | ''                                     | ''                         | ''                         | ''                     |
		| ''                                            | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                                  | ''               | 'Dimensions'                           | ''                                     | ''                         | ''                         | ''                     |
		| ''                                            | ''                    | ''                    | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'                            | 'Transaction AR' | 'Company'                              | 'Partner'                              | 'Legal name'               | 'Basis document'           | 'Currency'             |
		| ''                                            | 'Receipt'             | '*'                   | ''                    | '-80'            | ''                                                  | ''               | 'Main Company'                         | 'Ferron BP'                            | 'Company Ferron BP'        | ''                         | 'USD'                  |
		| ''                                            | ''                    | ''                    | ''                    | ''               | ''                                                  | ''               | ''                                     | ''                                     | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"'  | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Amount'    | 'Company'      | 'Legal name'               | 'Currency'  | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | 'Company Ferron BP'        | 'USD'       | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Order balance"'             | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'                    | 'Item key'  | 'Row key'           | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'         | 'Store 02'     | '$$PurchaseReturnOrder022001$$' | 'L/Green'   | '*'                 | ''                   | ''                         | ''                         | ''                     |
	And I close all client application windows


Scenario: _02233601 clear movements Purchase Return and check that there is no movements on the registers 
	* Open list form Purchase Return Order
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	* Check the report generation
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseReturn022301$$'      |
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "Partner AR transactions"'   |
			| 'Register  "Inventory balance"'         |
			| 'Register  "Goods in transit outgoing"' |
			| 'Register  "Order reservation"'         |
			| 'Register  "Reconciliation statement"'  |
			| 'Register  "Order balance"'             |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseReturn022301$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		Then "ResultTable" spreadsheet document is equal by template
		| '$$PurchaseReturn022301$$'              | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| 'Document registrations records'        | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Partner AR transactions"'   | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | 'Attributes'           |
		| ''                                      | ''            | ''          | 'Amount'               | 'Company'        | 'Basis document'                | 'Partner'        | 'Legal name'        | 'Partner term'       | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                      | 'Receipt'     | '*'         | '80'                   | 'Main Company'   | ''                              | 'Ferron BP'      | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                          | 'en description is empty'      | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '80'                   | 'Main Company'   | ''                              | 'Ferron BP'      | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                          | 'Reporting currency'           | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '80'                   | 'Main Company'   | ''                              | 'Ferron BP'      | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                          | 'USD'                          | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '451,98'               | 'Main Company'   | ''                              | 'Ferron BP'      | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'TRY'                          | 'Local currency'               | 'No'                   |
		| ''                                      | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Purchase return turnovers"' | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Period'      | 'Resources' | ''                     | 'Dimensions'     | ''                              | ''               | ''                  | ''                   | ''                             | 'Attributes'                   | ''                     |
		| ''                                      | ''            | 'Quantity'  | 'Amount'               | 'Company'        | 'Purchase invoice'              | 'Currency'       | 'Item key'          | 'Row key'            | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
		| ''                                      | '*'           | '-2'        | '-451,98'              | 'Main Company'   | '$$PurchaseInvoice018006$$'     | 'TRY'            | 'L/Green'           | '*'                  | 'Local currency'               | 'No'                           | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'                  | 'Main Company'   | '$$PurchaseInvoice018006$$'     | 'USD'            | 'L/Green'           | '*'                  | 'en description is empty'      | 'No'                           | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'                  | 'Main Company'   | '$$PurchaseInvoice018006$$'     | 'USD'            | 'L/Green'           | '*'                  | 'Reporting currency'           | 'No'                           | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'                  | 'Main Company'   | '$$PurchaseInvoice018006$$'     | 'USD'            | 'L/Green'           | '*'                  | 'USD'                          | 'No'                           | ''                     |
		| ''                                      | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Inventory balance"'         | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'             | 'Company'        | 'Item key'                      | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'                    | 'Main Company'   | 'L/Green'                       | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Goods in transit outgoing"' | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'             | 'Store'          | 'Shipment basis'                | 'Item key'       | 'Row key'           | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '2'                    | 'Store 02'       | '$$PurchaseReturn022301$$'      | 'L/Green'        | '*'                 | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Order reservation"'         | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'             | 'Store'          | 'Item key'                      | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'                    | 'Store 02'       | 'L/Green'                       | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Accounts statement"'        | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'            | ''               | ''                              | ''               | 'Dimensions'        | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''          | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'        | 'Transaction AR' | 'Company'           | 'Partner'            | 'Legal name'                   | 'Basis document'               | 'Currency'             |
		| ''                                      | 'Receipt'     | '*'         | ''                     | '-80'            | ''                              | ''               | 'Main Company'      | 'Ferron BP'          | 'Company Ferron BP'            | ''                             | 'USD'                  |
		| ''                                      | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Reconciliation statement"'  | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''          | 'Amount'               | 'Company'        | 'Legal name'                    | 'Currency'       | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '80'                   | 'Main Company'   | 'Company Ferron BP'             | 'USD'            | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Order balance"'             | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'             | 'Store'          | 'Order'                         | 'Item key'       | 'Row key'           | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'                    | 'Store 02'       | '$$PurchaseReturnOrder022001$$' | 'L/Green'        | '*'                 | ''                   | ''                             | ''                             | ''                     |
		And I close all client application windows






Scenario: _021048 check the output of the document movement report for Inventory transfer
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberInventoryTransfer021001$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$InventoryTransfer021001$$'                 | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Document registrations records'        | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Transfer order balance"'    | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store sender' | 'Store receiver'        | 'Order'                         | 'Item key' | 'Row key' |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 01'     | 'Store 02'              | '$$InventoryTransferOrder020001$$' | 'S/Yellow' | '*'       |
		| ''                                      | 'Expense'     | '*'      | '50'        | 'Store 01'     | 'Store 02'              | '$$InventoryTransferOrder020001$$' | 'M/White'  | '*'       |
		| ''                                      | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Receipt basis'         | 'Item key'                      | 'Row key'  | ''        |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'     | '$$InventoryTransfer021001$$' | 'S/Yellow'                      | '*'        | ''        |
		| ''                                      | 'Receipt'     | '*'      | '50'        | 'Store 02'     | '$$InventoryTransfer021001$$' | 'M/White'                       | '*'        | ''        |
		| ''                                      | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'              | ''                              | ''         | ''        |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 01'     | 'S/Yellow'              | ''                              | ''         | ''        |
		| ''                                      | 'Expense'     | '*'      | '50'        | 'Store 01'     | 'M/White'               | ''                              | ''         | ''        |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberInventoryTransfer021001$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$InventoryTransfer021001$$'                 | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Document registrations records'        | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Transfer order balance"'    | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store sender' | 'Store receiver'        | 'Order'                         | 'Item key' | 'Row key' |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 01'     | 'Store 02'              | '$$InventoryTransferOrder020001$$' | 'S/Yellow' | '*'       |
		| ''                                      | 'Expense'     | '*'      | '50'        | 'Store 01'     | 'Store 02'              | '$$InventoryTransferOrder020001$$' | 'M/White'  | '*'       |
		| ''                                      | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Receipt basis'         | 'Item key'                      | 'Row key'  | ''        |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'     | '$$InventoryTransfer021001$$' | 'S/Yellow'                      | '*'        | ''        |
		| ''                                      | 'Receipt'     | '*'      | '50'        | 'Store 02'     | '$$InventoryTransfer021001$$' | 'M/White'                       | '*'        | ''        |
		| ''                                      | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'              | ''                              | ''         | ''        |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 01'     | 'S/Yellow'              | ''                              | ''         | ''        |
		| ''                                      | 'Expense'     | '*'      | '50'        | 'Store 01'     | 'M/White'               | ''                              | ''         | ''        |
	And I close all client application windows



Scenario: _02104801 clear movements Inventory transfer and check that there is no movements on the registers 
	* Open list form Inventory transfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	* Check the report generation
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberInventoryTransfer021001$$'      |
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "Transfer order balance"'    |
			| 'Register  "Goods in transit incoming"' |
			| 'Register  "Stock balance"'             |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberInventoryTransfer021001$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		Then "ResultTable" spreadsheet document is equal by template
		| '$$InventoryTransfer021001$$'                 | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Document registrations records'        | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Transfer order balance"'    | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store sender' | 'Store receiver'        | 'Order'                         | 'Item key' | 'Row key' |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 01'     | 'Store 02'              | '$$InventoryTransferOrder020001$$' | 'S/Yellow' | '*'       |
		| ''                                      | 'Expense'     | '*'      | '50'        | 'Store 01'     | 'Store 02'              | '$$InventoryTransferOrder020001$$' | 'M/White'  | '*'       |
		| ''                                      | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Receipt basis'         | 'Item key'                      | 'Row key'  | ''        |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'     | '$$InventoryTransfer021001$$' | 'S/Yellow'                      | '*'        | ''        |
		| ''                                      | 'Receipt'     | '*'      | '50'        | 'Store 02'     | '$$InventoryTransfer021001$$' | 'M/White'                       | '*'        | ''        |
		| ''                                      | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'              | ''                              | ''         | ''        |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 01'     | 'S/Yellow'              | ''                              | ''         | ''        |
		| ''                                      | 'Expense'     | '*'      | '50'        | 'Store 01'     | 'M/White'               | ''                              | ''         | ''        |
		And I close all client application windows



Scenario: _024043 check the output of the document movement report for Sales Invoice
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesInvoice024001$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$SalesInvoice024001$$'                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Partner AR transactions"'        | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | 'Attributes'                   | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Amount'               | 'Company'        | 'Basis document'         | 'Partner'        | 'Legal name'        | 'Partner term'             | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation'         | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '744,86'               | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'USD'                          | 'Reporting currency'           | 'No'                           | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'                          | 'en description is empty'      | 'No'                           | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'                          | 'Local currency'               | 'No'                           | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'                          | 'TRY'                          | 'No'                           | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Inventory balance"'              | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Company'        | 'Item key'               | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Main Company'   | '36/Yellow'              | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Main Company'   | 'L/Green'                | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Store'          | 'Item key'               | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Store 01'       | '36/Yellow'              | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Store 01'       | 'L/Green'                | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Taxes turnovers"'                | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''                     | ''               | 'Dimensions'             | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | 'Attributes'           |
		| ''                                           | ''            | 'Amount'    | 'Manual amount'        | 'Net amount'     | 'Document'               | 'Tax'            | 'Analytics'         | 'Tax rate'                 | 'Include to total amount'      | 'Row key'                      | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                           | '*'           | '41,79'     | '41,79'                | '232,18'         | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'USD'                          | 'Reporting currency'           | 'No'                   |
		| ''                                           | '*'           | '71,83'     | '71,83'                | '399,06'         | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'USD'                          | 'Reporting currency'           | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'               | '1 355,93'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'en description is empty'      | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'               | '1 355,93'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'Local currency'               | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'               | '1 355,93'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'TRY'                          | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'               | '2 330,51'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'en description is empty'      | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'               | '2 330,51'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'Local currency'               | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'               | '2 330,51'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'TRY'                          | 'No'                   |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Accounts statement"'             | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'        | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'           | 'Partner'                  | 'Legal name'                   | 'Basis document'               | 'Currency'                     | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | ''                     | ''               | ''                       | '4 350'          | 'Main Company'      | 'Ferron BP'                | 'Company Ferron BP'            | '$$SalesInvoice024001$$'             | 'TRY'                          | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Sales turnovers"'                | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''                     | ''               | ''                       | 'Dimensions'     | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'               | 'Net amount'     | 'Offers amount'          | 'Company'        | 'Sales invoice'     | 'Currency'                 | 'Item key'                     | 'Row key'                      | 'Multi currency movement type' | 'Serial lot number'            | 'Deferred calculation' |
		| ''                                           | '*'           | '4'         | '273,97'               | '232,18'         | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'USD'                      | '36/Yellow'                    | '*'                            | 'Reporting currency'           | ''                             | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'                | '1 355,93'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | '36/Yellow'                    | '*'                            | 'en description is empty'      | ''                             | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'                | '1 355,93'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | '36/Yellow'                    | '*'                            | 'Local currency'               | ''                             | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'                | '1 355,93'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | '36/Yellow'                    | '*'                            | 'TRY'                          | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '470,89'               | '399,06'         | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'USD'                      | 'L/Green'                      | '*'                            | 'Reporting currency'           | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'                | '2 330,51'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | 'L/Green'                      | '*'                            | 'en description is empty'      | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'                | '2 330,51'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | 'L/Green'                      | '*'                            | 'Local currency'               | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'                | '2 330,51'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | 'L/Green'                      | '*'                            | 'TRY'                          | ''                             | 'No'                   |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Reconciliation statement"'       | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Amount'               | 'Company'        | 'Legal name'             | 'Currency'       | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | 'Company Ferron BP'      | 'TRY'            | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Revenues turnovers"'             | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Period'      | 'Resources' | 'Dimensions'           | ''               | ''                       | ''               | ''                  | ''                         | ''                             | 'Attributes'                   | ''                             | ''                             | ''                     |
		| ''                                           | ''            | 'Amount'    | 'Company'              | 'Business unit'  | 'Revenue type'           | 'Item key'       | 'Currency'          | 'Additional analytic'      | 'Multi currency movement type' | 'Deferred calculation'         | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '232,18'    | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'USD'               | ''                         | 'Reporting currency'           | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '399,06'    | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'USD'               | ''                         | 'Reporting currency'           | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'TRY'               | ''                         | 'en description is empty'      | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'TRY'               | ''                         | 'Local currency'               | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'TRY'               | ''                         | 'TRY'                          | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'TRY'               | ''                         | 'en description is empty'      | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'TRY'               | ''                         | 'Local currency'               | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'TRY'               | ''                         | 'TRY'                          | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Store'          | 'Order'                  | 'Item key'       | 'Row key'           | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Store 01'       | '$$SalesOrder023001$$'         | '36/Yellow'      | '*'                 | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Store 01'       | '$$SalesOrder023001$$'         | 'L/Green'        | '*'                 | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Stock balance"'                  | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Store'          | 'Item key'               | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Store 01'       | '36/Yellow'              | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Store 01'       | 'L/Green'                | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | 'Attributes'                   | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Company'        | 'Order'                  | 'Store'          | 'Item key'          | 'Row key'                  | 'Delivery date'                | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Main Company'   | '$$SalesOrder023001$$'         | 'Store 01'       | '36/Yellow'         | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Main Company'   | '$$SalesOrder023001$$'         | 'Store 01'       | 'L/Green'           | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |

	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesInvoice024001$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$SalesInvoice024001$$'                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Partner AR transactions"'        | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | 'Attributes'                   | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Amount'               | 'Company'        | 'Basis document'         | 'Partner'        | 'Legal name'        | 'Partner term'             | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation'         | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '744,86'               | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'USD'                          | 'Reporting currency'           | 'No'                           | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'                          | 'en description is empty'      | 'No'                           | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'                          | 'Local currency'               | 'No'                           | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'                          | 'TRY'                          | 'No'                           | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Inventory balance"'              | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Company'        | 'Item key'               | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Main Company'   | '36/Yellow'              | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Main Company'   | 'L/Green'                | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Store'          | 'Item key'               | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Store 01'       | '36/Yellow'              | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Store 01'       | 'L/Green'                | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Taxes turnovers"'                | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''                     | ''               | 'Dimensions'             | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | 'Attributes'           |
		| ''                                           | ''            | 'Amount'    | 'Manual amount'        | 'Net amount'     | 'Document'               | 'Tax'            | 'Analytics'         | 'Tax rate'                 | 'Include to total amount'      | 'Row key'                      | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                           | '*'           | '41,79'     | '41,79'                | '232,18'         | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'USD'                          | 'Reporting currency'           | 'No'                   |
		| ''                                           | '*'           | '71,83'     | '71,83'                | '399,06'         | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'USD'                          | 'Reporting currency'           | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'               | '1 355,93'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'en description is empty'      | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'               | '1 355,93'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'Local currency'               | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'               | '1 355,93'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'TRY'                          | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'               | '2 330,51'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'en description is empty'      | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'               | '2 330,51'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'Local currency'               | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'               | '2 330,51'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'TRY'                          | 'No'                   |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Accounts statement"'             | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'        | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'           | 'Partner'                  | 'Legal name'                   | 'Basis document'               | 'Currency'                     | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | ''                     | ''               | ''                       | '4 350'          | 'Main Company'      | 'Ferron BP'                | 'Company Ferron BP'            | '$$SalesInvoice024001$$'             | 'TRY'                          | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Sales turnovers"'                | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''                     | ''               | ''                       | 'Dimensions'     | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'               | 'Net amount'     | 'Offers amount'          | 'Company'        | 'Sales invoice'     | 'Currency'                 | 'Item key'                     | 'Row key'                      | 'Multi currency movement type' | 'Serial lot number'            | 'Deferred calculation' |
		| ''                                           | '*'           | '4'         | '273,97'               | '232,18'         | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'USD'                      | '36/Yellow'                    | '*'                            | 'Reporting currency'           | ''                             | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'                | '1 355,93'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | '36/Yellow'                    | '*'                            | 'en description is empty'      | ''                             | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'                | '1 355,93'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | '36/Yellow'                    | '*'                            | 'Local currency'               | ''                             | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'                | '1 355,93'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | '36/Yellow'                    | '*'                            | 'TRY'                          | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '470,89'               | '399,06'         | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'USD'                      | 'L/Green'                      | '*'                            | 'Reporting currency'           | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'                | '2 330,51'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | 'L/Green'                      | '*'                            | 'en description is empty'      | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'                | '2 330,51'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | 'L/Green'                      | '*'                            | 'Local currency'               | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'                | '2 330,51'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | 'L/Green'                      | '*'                            | 'TRY'                          | ''                             | 'No'                   |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Reconciliation statement"'       | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Amount'               | 'Company'        | 'Legal name'             | 'Currency'       | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | 'Company Ferron BP'      | 'TRY'            | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Revenues turnovers"'             | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Period'      | 'Resources' | 'Dimensions'           | ''               | ''                       | ''               | ''                  | ''                         | ''                             | 'Attributes'                   | ''                             | ''                             | ''                     |
		| ''                                           | ''            | 'Amount'    | 'Company'              | 'Business unit'  | 'Revenue type'           | 'Item key'       | 'Currency'          | 'Additional analytic'      | 'Multi currency movement type' | 'Deferred calculation'         | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '232,18'    | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'USD'               | ''                         | 'Reporting currency'           | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '399,06'    | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'USD'               | ''                         | 'Reporting currency'           | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'TRY'               | ''                         | 'en description is empty'      | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'TRY'               | ''                         | 'Local currency'               | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'TRY'               | ''                         | 'TRY'                          | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'TRY'               | ''                         | 'en description is empty'      | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'TRY'               | ''                         | 'Local currency'               | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'TRY'               | ''                         | 'TRY'                          | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Store'          | 'Order'                  | 'Item key'       | 'Row key'           | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Store 01'       | '$$SalesOrder023001$$'         | '36/Yellow'      | '*'                 | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Store 01'       | '$$SalesOrder023001$$'         | 'L/Green'        | '*'                 | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Stock balance"'                  | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Store'          | 'Item key'               | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Store 01'       | '36/Yellow'              | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Store 01'       | 'L/Green'                | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | 'Attributes'                   | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Company'        | 'Order'                  | 'Store'          | 'Item key'          | 'Row key'                  | 'Delivery date'                | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Main Company'   | '$$SalesOrder023001$$'         | 'Store 01'       | '36/Yellow'         | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Main Company'   | '$$SalesOrder023001$$'         | 'Store 01'       | 'L/Green'           | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |

	And I close all client application windows


Scenario: __02404301 clear movements Sales invoice and check that there is no movements on the registers 
	* Open list form Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	* Check the report generation
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberSalesInvoice024001$$'      |
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "Partner AR transactions"'        |
			| 'Register  "Inventory balance"'              |
			| 'Register  "Order reservation"'              |
			| 'Register  "Taxes turnovers"'                |
			| 'Register  "Sales turnovers"'                |
			| 'Register  "Reconciliation statement"'       |
			| 'Register  "Order balance"'                  |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesInvoice024001$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		Then "ResultTable" spreadsheet document is equal by template
		| '$$SalesInvoice024001$$'                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Partner AR transactions"'        | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | 'Attributes'                   | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Amount'               | 'Company'        | 'Basis document'         | 'Partner'        | 'Legal name'        | 'Partner term'             | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation'         | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '744,86'               | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'USD'                          | 'Reporting currency'           | 'No'                           | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'                          | 'en description is empty'      | 'No'                           | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'                          | 'Local currency'               | 'No'                           | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'                          | 'TRY'                          | 'No'                           | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Inventory balance"'              | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Company'        | 'Item key'               | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Main Company'   | '36/Yellow'              | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Main Company'   | 'L/Green'                | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Store'          | 'Item key'               | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Store 01'       | '36/Yellow'              | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Store 01'       | 'L/Green'                | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Taxes turnovers"'                | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''                     | ''               | 'Dimensions'             | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | 'Attributes'           |
		| ''                                           | ''            | 'Amount'    | 'Manual amount'        | 'Net amount'     | 'Document'               | 'Tax'            | 'Analytics'         | 'Tax rate'                 | 'Include to total amount'      | 'Row key'                      | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                           | '*'           | '41,79'     | '41,79'                | '232,18'         | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'USD'                          | 'Reporting currency'           | 'No'                   |
		| ''                                           | '*'           | '71,83'     | '71,83'                | '399,06'         | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'USD'                          | 'Reporting currency'           | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'               | '1 355,93'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'en description is empty'      | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'               | '1 355,93'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'Local currency'               | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'               | '1 355,93'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'TRY'                          | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'               | '2 330,51'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'en description is empty'      | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'               | '2 330,51'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'Local currency'               | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'               | '2 330,51'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'TRY'                          | 'No'                   |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Accounts statement"'             | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'        | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'           | 'Partner'                  | 'Legal name'                   | 'Basis document'               | 'Currency'                     | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | ''                     | ''               | ''                       | '4 350'          | 'Main Company'      | 'Ferron BP'                | 'Company Ferron BP'            | '$$SalesInvoice024001$$'             | 'TRY'                          | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Sales turnovers"'                | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''                     | ''               | ''                       | 'Dimensions'     | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'               | 'Net amount'     | 'Offers amount'          | 'Company'        | 'Sales invoice'     | 'Currency'                 | 'Item key'                     | 'Row key'                      | 'Multi currency movement type' | 'Serial lot number'            | 'Deferred calculation' |
		| ''                                           | '*'           | '4'         | '273,97'               | '232,18'         | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'USD'                      | '36/Yellow'                    | '*'                            | 'Reporting currency'           | ''                             | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'                | '1 355,93'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | '36/Yellow'                    | '*'                            | 'en description is empty'      | ''                             | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'                | '1 355,93'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | '36/Yellow'                    | '*'                            | 'Local currency'               | ''                             | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'                | '1 355,93'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | '36/Yellow'                    | '*'                            | 'TRY'                          | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '470,89'               | '399,06'         | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'USD'                      | 'L/Green'                      | '*'                            | 'Reporting currency'           | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'                | '2 330,51'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | 'L/Green'                      | '*'                            | 'en description is empty'      | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'                | '2 330,51'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | 'L/Green'                      | '*'                            | 'Local currency'               | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'                | '2 330,51'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | 'L/Green'                      | '*'                            | 'TRY'                          | ''                             | 'No'                   |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Reconciliation statement"'       | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Amount'               | 'Company'        | 'Legal name'             | 'Currency'       | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | 'Company Ferron BP'      | 'TRY'            | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Revenues turnovers"'             | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Period'      | 'Resources' | 'Dimensions'           | ''               | ''                       | ''               | ''                  | ''                         | ''                             | 'Attributes'                   | ''                             | ''                             | ''                     |
		| ''                                           | ''            | 'Amount'    | 'Company'              | 'Business unit'  | 'Revenue type'           | 'Item key'       | 'Currency'          | 'Additional analytic'      | 'Multi currency movement type' | 'Deferred calculation'         | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '232,18'    | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'USD'               | ''                         | 'Reporting currency'           | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '399,06'    | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'USD'               | ''                         | 'Reporting currency'           | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'TRY'               | ''                         | 'en description is empty'      | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'TRY'               | ''                         | 'Local currency'               | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'TRY'               | ''                         | 'TRY'                          | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'TRY'               | ''                         | 'en description is empty'      | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'TRY'               | ''                         | 'Local currency'               | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'TRY'               | ''                         | 'TRY'                          | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Store'          | 'Order'                  | 'Item key'       | 'Row key'           | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Store 01'       | '$$SalesOrder023001$$'         | '36/Yellow'      | '*'                 | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Store 01'       | '$$SalesOrder023001$$'         | 'L/Green'        | '*'                 | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Stock balance"'                  | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Store'          | 'Item key'               | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Store 01'       | '36/Yellow'              | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Store 01'       | 'L/Green'                | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | 'Attributes'                   | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Company'        | 'Order'                  | 'Store'          | 'Item key'          | 'Row key'                  | 'Delivery date'                | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Main Company'   | '$$SalesOrder023001$$'         | 'Store 01'       | '36/Yellow'         | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Main Company'   | '$$SalesOrder023001$$'         | 'Store 01'       | 'L/Green'           | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |
		And I close all client application windows






Scenario: _028013 check the output of the document movement report for Sales Return Order
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesReturnOrder028001$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$SalesReturnOrder028001$$'          | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| 'Document registrations records' | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| 'Register  "Sales turnovers"'    | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''          | ''           | ''                      | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                             | ''                  | 'Attributes'           |
		| ''                               | ''            | 'Quantity'  | 'Amount'    | 'Net amount' | 'Offers amount'         | 'Company'      | 'Sales invoice'    | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type' | 'Serial lot number' | 'Deferred calculation' |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'TRY'      | 'L/Green'  | '*'       | 'en description is empty'      | ''                  | 'No'                   |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'               | ''                  | 'No'                   |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'TRY'      | 'L/Green'  | '*'       | 'TRY'                          | ''                  | 'No'                   |
		| ''                               | '*'           | '-1'        | '-94,18'    | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'           | ''                  | 'No'                   |
		| ''                               | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| 'Register  "Order balance"'      | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Order'                 | 'Item key'     | 'Row key'          | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | 'Receipt'     | '*'         | '1'         | 'Store 02'   | '$$SalesReturnOrder028001$$' | 'L/Green'      | '*'                | ''         | ''         | ''        | ''                             | ''                  | ''                     |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesReturnOrder028001$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$SalesReturnOrder028001$$'          | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| 'Document registrations records' | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| 'Register  "Sales turnovers"'    | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''          | ''           | ''                      | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                             | ''                  | 'Attributes'           |
		| ''                               | ''            | 'Quantity'  | 'Amount'    | 'Net amount' | 'Offers amount'         | 'Company'      | 'Sales invoice'    | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type' | 'Serial lot number' | 'Deferred calculation' |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'TRY'      | 'L/Green'  | '*'       | 'en description is empty'      | ''                  | 'No'                   |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'               | ''                  | 'No'                   |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'TRY'      | 'L/Green'  | '*'       | 'TRY'                          | ''                  | 'No'                   |
		| ''                               | '*'           | '-1'        | '-94,18'    | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'           | ''                  | 'No'                   |
		| ''                               | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| 'Register  "Order balance"'      | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Order'                 | 'Item key'     | 'Row key'          | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | 'Receipt'     | '*'         | '1'         | 'Store 02'   | '$$SalesReturnOrder028001$$' | 'L/Green'      | '*'                | ''         | ''         | ''        | ''                             | ''                  | ''                     |
	And I close all client application windows


Scenario: _02801301 clear movements Sales Return Order and check that there is no movements on the registers 
	* Open list form Sales Return Order
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	* Check the report generation
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesReturnOrder028001$$'      |
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "Sales turnovers"'    |
			| 'Register  "Order balance"'      |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesReturnOrder028001$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		Then "ResultTable" spreadsheet document is equal by template
		| '$$SalesReturnOrder028001$$'          | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| 'Document registrations records' | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| 'Register  "Sales turnovers"'    | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''          | ''           | ''                      | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                             | ''                  | 'Attributes'           |
		| ''                               | ''            | 'Quantity'  | 'Amount'    | 'Net amount' | 'Offers amount'         | 'Company'      | 'Sales invoice'    | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type' | 'Serial lot number' | 'Deferred calculation' |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'TRY'      | 'L/Green'  | '*'       | 'en description is empty'      | ''                  | 'No'                   |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'               | ''                  | 'No'                   |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'TRY'      | 'L/Green'  | '*'       | 'TRY'                          | ''                  | 'No'                   |
		| ''                               | '*'           | '-1'        | '-94,18'    | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'           | ''                  | 'No'                   |
		| ''                               | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| 'Register  "Order balance"'      | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Order'                 | 'Item key'     | 'Row key'          | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | 'Receipt'     | '*'         | '1'         | 'Store 02'   | '$$SalesReturnOrder028001$$' | 'L/Green'      | '*'                | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		And I close all client application windows






Scenario: _028811 check the output of the document movement report for Shipment Confirmation
	Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberShipmentConfirmation0028801$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$ShipmentConfirmation0028801$$'                  | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Document registrations records'             | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Goods in transit outgoing"'      | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Store'        | 'Shipment basis'   | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'     | '$$SalesInvoice024008$$' | 'L/Green'   | '*'         | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Store 02'     | '$$SalesInvoice024008$$' | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Stock balance"'                  | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'         | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'     | 'L/Green'          | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Store 02'     | '36/Yellow'        | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | 'Attributes'    |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'            | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$SalesInvoice024008$$' | 'Store 02'  | 'L/Green'   | '*'       | '*'             |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Main Company' | '$$SalesInvoice024008$$' | 'Store 02'  | '36/Yellow' | '*'       | '*'             |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberShipmentConfirmation0028801$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$ShipmentConfirmation0028801$$'                  | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Document registrations records'             | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Goods in transit outgoing"'      | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Store'        | 'Shipment basis'   | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'     | '$$SalesInvoice024008$$' | 'L/Green'   | '*'         | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Store 02'     | '$$SalesInvoice024008$$' | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Stock balance"'                  | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'         | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'     | 'L/Green'          | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Store 02'     | '36/Yellow'        | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | 'Attributes'    |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'            | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$SalesInvoice024008$$' | 'Store 02'  | 'L/Green'   | '*'       | '*'             |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Main Company' | '$$SalesInvoice024008$$' | 'Store 02'  | '36/Yellow' | '*'       | '*'             |
	And I close all client application windows


Scenario: _02881101 clear movements Shipment confirmation and check that there is no movements on the registers 
	* Open list form Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
	* Check the report generation
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberShipmentConfirmation0028801$$'      |
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "Goods in transit outgoing"'      |
			| 'Register  "Stock balance"'                  |
			| 'Register  "Shipment confirmation schedule"' |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberShipmentConfirmation0028801$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		Then "ResultTable" spreadsheet document is equal by template
		| '$$ShipmentConfirmation0028801$$'                  | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Document registrations records'             | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Goods in transit outgoing"'      | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Store'        | 'Shipment basis'   | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'     | '$$SalesInvoice024008$$' | 'L/Green'   | '*'         | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Store 02'     | '$$SalesInvoice024008$$' | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Stock balance"'                  | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'         | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'     | 'L/Green'          | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Store 02'     | '36/Yellow'        | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | 'Attributes'    |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'            | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$SalesInvoice024008$$' | 'Store 02'  | 'L/Green'   | '*'       | '*'             |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Main Company' | '$$SalesInvoice024008$$' | 'Store 02'  | '36/Yellow' | '*'       | '*'             |
		And I close all client application windows





Scenario: _028905 check the output of the document movement report for Goods Receipt
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberGoodsReceipt028901$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$GoodsReceipt028901$$'                    | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Document registrations records'        | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Receipt basis'       | 'Item key' | 'Row key'  | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '500'       | 'Store 02'     | '$$PurchaseInvoice018006$$' | 'L/Green'  | '*'        | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'            | ''         | ''         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '500'       | 'Store 02'     | 'L/Green'             | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Goods receipt schedule"'    | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | 'Attributes'    |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'               | 'Store'    | 'Item key' | 'Row key' | 'Delivery date' |
		| ''                                      | 'Expense'     | '*'      | '500'       | 'Main Company' | '$$PurchaseInvoice018006$$' | 'Store 02' | 'L/Green'  | '*'       | '*'             |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'            | ''         | ''         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '500'       | 'Store 02'     | 'L/Green'             | ''         | ''         | ''        | ''              |


	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberGoodsReceipt028901$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$GoodsReceipt028901$$'                    | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Document registrations records'        | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Receipt basis'       | 'Item key' | 'Row key'  | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '500'       | 'Store 02'     | '$$PurchaseInvoice018006$$' | 'L/Green'  | '*'        | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'            | ''         | ''         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '500'       | 'Store 02'     | 'L/Green'             | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Goods receipt schedule"'    | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | 'Attributes'    |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'               | 'Store'    | 'Item key' | 'Row key' | 'Delivery date' |
		| ''                                      | 'Expense'     | '*'      | '500'       | 'Main Company' | '$$PurchaseInvoice018006$$' | 'Store 02' | 'L/Green'  | '*'       | '*'             |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'            | ''         | ''         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '500'       | 'Store 02'     | 'L/Green'             | ''         | ''         | ''        | ''              |


	And I close all client application windows


Scenario: _02890501 clear movements Goods receipt and check that there is no movements on the registers 
	* Open list form Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	* Check the report generation
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberGoodsReceipt028901$$'      |
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "Goods in transit incoming"' |
			| 'Register  "Stock reservation"'         |
			| 'Register  "Goods receipt schedule"'    |
			| 'Register  "Stock balance"'             |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberGoodsReceipt028901$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		Then "ResultTable" spreadsheet document is equal by template
		| '$$GoodsReceipt028901$$'                    | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Document registrations records'        | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Receipt basis'       | 'Item key' | 'Row key'  | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '500'       | 'Store 02'     | '$$PurchaseInvoice018006$$' | 'L/Green'  | '*'        | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'            | ''         | ''         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '500'       | 'Store 02'     | 'L/Green'             | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Goods receipt schedule"'    | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | 'Attributes'    |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'               | 'Store'    | 'Item key' | 'Row key' | 'Delivery date' |
		| ''                                      | 'Expense'     | '*'      | '500'       | 'Main Company' | '$$PurchaseInvoice018006$$' | 'Store 02' | 'L/Green'  | '*'       | '*'             |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'            | ''         | ''         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '500'       | 'Store 02'     | 'L/Green'             | ''         | ''         | ''        | ''              |
		And I close all client application windows






Scenario: _029519 check the output of the document movement report for Bundling
	Given I open hyperlink "e1cib/list/Document.Bundling"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberBundling0029501$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$Bundling0029501$$'                    | ''            | ''          | ''                              | ''           | ''                              |
		| 'Document registrations records' | ''            | ''          | ''                              | ''           | ''                              |
		| 'Register  "Bundles content"'    | ''            | ''          | ''                              | ''           | ''                              |
		| ''                               | 'Period'      | 'Resources' | 'Dimensions'                    | ''           | ''                              |
		| ''                               | ''            | 'Quantity'  | 'Item key bundle'               | 'Item key'   | ''                              |
		| ''                               | '*'           | '1'         | 'Bound Dress+Shirt/Dress+Shirt' | 'XS/Blue'    | ''                              |
		| ''                               | '*'           | '1'         | 'Bound Dress+Shirt/Dress+Shirt' | '36/Red'     | ''                              |
		| ''                               | ''            | ''          | ''                              | ''           | ''                              |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''                              | ''           | ''                              |
		| ''                               | 'Record type' | 'Period'    | 'Resources'                     | 'Dimensions' | ''                              |
		| ''                               | ''            | ''          | 'Quantity'                      | 'Store'      | 'Item key'                      |
		| ''                               | 'Receipt'     | '*'         | '10'                            | 'Store 01'   | 'Bound Dress+Shirt/Dress+Shirt' |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | 'XS/Blue'                       |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | '36/Red'                        |
		| ''                               | ''            | ''          | ''                              | ''           | ''                              |
		| 'Register  "Stock balance"'      | ''            | ''          | ''                              | ''           | ''                              |
		| ''                               | 'Record type' | 'Period'    | 'Resources'                     | 'Dimensions' | ''                              |
		| ''                               | ''            | ''          | 'Quantity'                      | 'Store'      | 'Item key'                      |
		| ''                               | 'Receipt'     | '*'         | '10'                            | 'Store 01'   | 'Bound Dress+Shirt/Dress+Shirt' |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | 'XS/Blue'                       |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | '36/Red'                        |

	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Bundling"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberBundling0029501$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$Bundling0029501$$'                    | ''            | ''          | ''                              | ''           | ''                              |
		| 'Document registrations records' | ''            | ''          | ''                              | ''           | ''                              |
		| 'Register  "Bundles content"'    | ''            | ''          | ''                              | ''           | ''                              |
		| ''                               | 'Period'      | 'Resources' | 'Dimensions'                    | ''           | ''                              |
		| ''                               | ''            | 'Quantity'  | 'Item key bundle'               | 'Item key'   | ''                              |
		| ''                               | '*'           | '1'         | 'Bound Dress+Shirt/Dress+Shirt' | 'XS/Blue'    | ''                              |
		| ''                               | '*'           | '1'         | 'Bound Dress+Shirt/Dress+Shirt' | '36/Red'     | ''                              |
		| ''                               | ''            | ''          | ''                              | ''           | ''                              |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''                              | ''           | ''                              |
		| ''                               | 'Record type' | 'Period'    | 'Resources'                     | 'Dimensions' | ''                              |
		| ''                               | ''            | ''          | 'Quantity'                      | 'Store'      | 'Item key'                      |
		| ''                               | 'Receipt'     | '*'         | '10'                            | 'Store 01'   | 'Bound Dress+Shirt/Dress+Shirt' |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | 'XS/Blue'                       |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | '36/Red'                        |
		| ''                               | ''            | ''          | ''                              | ''           | ''                              |
		| 'Register  "Stock balance"'      | ''            | ''          | ''                              | ''           | ''                              |
		| ''                               | 'Record type' | 'Period'    | 'Resources'                     | 'Dimensions' | ''                              |
		| ''                               | ''            | ''          | 'Quantity'                      | 'Store'      | 'Item key'                      |
		| ''                               | 'Receipt'     | '*'         | '10'                            | 'Store 01'   | 'Bound Dress+Shirt/Dress+Shirt' |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | 'XS/Blue'                       |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | '36/Red'                        |

	And I close all client application windows


Scenario: _02951901 clear movements Bundling and check that there is no movements on the registers 
	* Open list form Bundling
		Given I open hyperlink "e1cib/list/Document.Bundling"
	* Check the report generation
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberBundling0029501$$'      |
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "Bundles content"'    |
			| 'Register  "Stock reservation"'  |
			| 'Register  "Stock balance"'      |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberBundling0029501$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		Then "ResultTable" spreadsheet document is equal by template
		| '$$Bundling0029501$$'                    | ''            | ''          | ''                              | ''           | ''                              |
		| 'Document registrations records' | ''            | ''          | ''                              | ''           | ''                              |
		| 'Register  "Bundles content"'    | ''            | ''          | ''                              | ''           | ''                              |
		| ''                               | 'Period'      | 'Resources' | 'Dimensions'                    | ''           | ''                              |
		| ''                               | ''            | 'Quantity'  | 'Item key bundle'               | 'Item key'   | ''                              |
		| ''                               | '*'           | '1'         | 'Bound Dress+Shirt/Dress+Shirt' | 'XS/Blue'    | ''                              |
		| ''                               | '*'           | '1'         | 'Bound Dress+Shirt/Dress+Shirt' | '36/Red'     | ''                              |
		| ''                               | ''            | ''          | ''                              | ''           | ''                              |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''                              | ''           | ''                              |
		| ''                               | 'Record type' | 'Period'    | 'Resources'                     | 'Dimensions' | ''                              |
		| ''                               | ''            | ''          | 'Quantity'                      | 'Store'      | 'Item key'                      |
		| ''                               | 'Receipt'     | '*'         | '10'                            | 'Store 01'   | 'Bound Dress+Shirt/Dress+Shirt' |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | 'XS/Blue'                       |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | '36/Red'                        |
		| ''                               | ''            | ''          | ''                              | ''           | ''                              |
		| 'Register  "Stock balance"'      | ''            | ''          | ''                              | ''           | ''                              |
		| ''                               | 'Record type' | 'Period'    | 'Resources'                     | 'Dimensions' | ''                              |
		| ''                               | ''            | ''          | 'Quantity'                      | 'Store'      | 'Item key'                      |
		| ''                               | 'Receipt'     | '*'         | '10'                            | 'Store 01'   | 'Bound Dress+Shirt/Dress+Shirt' |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | 'XS/Blue'                       |
		| ''                               | 'Expense'     | '*'         | '10'                            | 'Store 01'   | '36/Red'                        |
		And I close all client application windows








Scenario: _029612 check the output of the document movement report for Unbundling
	Given I open hyperlink "e1cib/list/Document.Unbundling"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberUnBundling0029501$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| 'UnBundling0029501$$'                  | ''            | ''       | ''          | ''           | ''          |
		| 'Document registrations records' | ''            | ''       | ''          | ''           | ''          |
		| 'Register  "Stock reservation"'  | ''            | ''       | ''          | ''           | ''          |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'S/Yellow'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'XS/Blue'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'L/Green'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'M/Brown'   |
		| ''                               | 'Expense'     | '*'      | '2'         | 'Store 01'   | 'Dress/A-8' |
		| ''                               | ''            | ''       | ''          | ''           | ''          |
		| 'Register  "Stock balance"'      | ''            | ''       | ''          | ''           | ''          |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'S/Yellow'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'XS/Blue'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'L/Green'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'M/Brown'   |
		| ''                               | 'Expense'     | '*'      | '2'         | 'Store 01'   | 'Dress/A-8' |

	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Unbundling"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberUnBundling0029501$$' |    
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| 'Un$$Bundling0029501$$'                  | ''            | ''       | ''          | ''           | ''          |
		| 'Document registrations records' | ''            | ''       | ''          | ''           | ''          |
		| 'Register  "Stock reservation"'  | ''            | ''       | ''          | ''           | ''          |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'S/Yellow'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'XS/Blue'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'L/Green'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'M/Brown'   |
		| ''                               | 'Expense'     | '*'      | '2'         | 'Store 01'   | 'Dress/A-8' |
		| ''                               | ''            | ''       | ''          | ''           | ''          |
		| 'Register  "Stock balance"'      | ''            | ''       | ''          | ''           | ''          |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'S/Yellow'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'XS/Blue'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'L/Green'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'M/Brown'   |
		| ''                               | 'Expense'     | '*'      | '2'         | 'Store 01'   | 'Dress/A-8' |

	And I close all client application windows

Scenario: _02961201 clear movements Unbundling and check that there is no movements on the registers 
	* Open list form Unbundling
		Given I open hyperlink "e1cib/list/Document.Unbundling"
	* Check the report generation
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberUnBundling0029501$$$$'  |    
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "Stock reservation"'  |
			| 'Register  "Stock balance"'      |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberUnBundling0029501$$' |     
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		Then "ResultTable" spreadsheet document is equal by template
		| 'Un$$Bundling0029501$$'                  | ''            | ''       | ''          | ''           | ''          |
		| 'Document registrations records' | ''            | ''       | ''          | ''           | ''          |
		| 'Register  "Stock reservation"'  | ''            | ''       | ''          | ''           | ''          |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'S/Yellow'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'XS/Blue'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'L/Green'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'M/Brown'   |
		| ''                               | 'Expense'     | '*'      | '2'         | 'Store 01'   | 'Dress/A-8' |
		| ''                               | ''            | ''       | ''          | ''           | ''          |
		| 'Register  "Stock balance"'      | ''            | ''       | ''          | ''           | ''          |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'S/Yellow'  |
		| ''                               | 'Receipt'     | '*'      | '2'         | 'Store 01'   | 'XS/Blue'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'L/Green'   |
		| ''                               | 'Receipt'     | '*'      | '4'         | 'Store 01'   | 'M/Brown'   |
		| ''                               | 'Expense'     | '*'      | '2'         | 'Store 01'   | 'Dress/A-8' |
		And I close all client application windows




Scenario: _023023 check the output of the document movement report for Sales Order
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberSalesOrder023001$$' |   
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$SalesOrder023001$$'                             | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'       | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4'         | 'Store 01'     | '36/Yellow'      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Store 01'     | 'L/Green'        | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'              | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'       | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'         | 'Store 01'     | '36/Yellow'      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'         | 'Store 01'     | 'L/Green'        | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Sales order'    | 'Currency'  | 'Item key'  | 'Row key' | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '4'         | '273,97'    | 'Main Company' | '$$SalesOrder023001$$' | 'USD'       | '36/Yellow' | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'     | 'Main Company' | '$$SalesOrder023001$$' | 'TRY'       | '36/Yellow' | '*'       | 'en description is empty' | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'     | 'Main Company' | '$$SalesOrder023001$$' | 'TRY'       | '36/Yellow' | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'     | 'Main Company' | '$$SalesOrder023001$$' | 'TRY'       | '36/Yellow' | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '5'         | '470,89'    | 'Main Company' | '$$SalesOrder023001$$' | 'USD'       | 'L/Green'   | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'     | 'Main Company' | '$$SalesOrder023001$$' | 'TRY'       | 'L/Green'   | '*'       | 'en description is empty' | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'     | 'Main Company' | '$$SalesOrder023001$$' | 'TRY'       | 'L/Green'   | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'     | 'Main Company' | '$$SalesOrder023001$$' | 'TRY'       | 'L/Green'   | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'          | 'Item key'  | 'Row key'   | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4'         | 'Store 01'     | '$$SalesOrder023001$$' | '36/Yellow' | '*'         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Store 01'     | '$$SalesOrder023001$$' | 'L/Green'   | '*'         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | 'Attributes'               | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'          | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date'            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4'         | 'Main Company' | '$$SalesOrder023001$$' | 'Store 01'  | '36/Yellow' | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Main Company' | '$$SalesOrder023001$$' | 'Store 01'  | 'L/Green'   | '*'       | '*'                        | ''                     |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$SalesOrder023001$$' |   
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		Then "ResultTable" spreadsheet document is equal by template
		| '$$SalesOrder023001$$'                             | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'       | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4'         | 'Store 01'     | '36/Yellow'      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Store 01'     | 'L/Green'        | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'              | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'       | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'         | 'Store 01'     | '36/Yellow'      | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'         | 'Store 01'     | 'L/Green'        | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Sales order'    | 'Currency'  | 'Item key'  | 'Row key' | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '4'         | '273,97'    | 'Main Company' | '$$SalesOrder023001$$' | 'USD'       | '36/Yellow' | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'     | 'Main Company' | '$$SalesOrder023001$$' | 'TRY'       | '36/Yellow' | '*'       | 'en description is empty' | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'     | 'Main Company' | '$$SalesOrder023001$$' | 'TRY'       | '36/Yellow' | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'     | 'Main Company' | '$$SalesOrder023001$$' | 'TRY'       | '36/Yellow' | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '5'         | '470,89'    | 'Main Company' | '$$SalesOrder023001$$' | 'USD'       | 'L/Green'   | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'     | 'Main Company' | '$$SalesOrder023001$$' | 'TRY'       | 'L/Green'   | '*'       | 'en description is empty' | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'     | 'Main Company' | '$$SalesOrder023001$$' | 'TRY'       | 'L/Green'   | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'     | 'Main Company' | '$$SalesOrder023001$$' | 'TRY'       | 'L/Green'   | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'          | 'Item key'  | 'Row key'   | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4'         | 'Store 01'     | '$$SalesOrder023001$$' | '36/Yellow' | '*'         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Store 01'     | '$$SalesOrder023001$$' | 'L/Green'   | '*'         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''             | ''               | ''          | ''          | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''               | ''          | ''          | ''        | 'Attributes'               | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'          | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date'            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4'         | 'Main Company' | '$$SalesOrder023001$$' | 'Store 01'  | '36/Yellow' | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Main Company' | '$$SalesOrder023001$$' | 'Store 01'  | 'L/Green'   | '*'       | '*'                        | ''                     |
	And I close all client application windows
