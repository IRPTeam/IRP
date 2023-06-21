#language: en
@tree
@Positive
@PrintForm

Feature: check print functionality (Sales order)


Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _092001 preparation (PrintFormSalesOrder)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
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
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"            |
				| "TaxCalculateVAT_TR"     |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Load SO
		When auto filling Configuration metadata catalog
		When Create catalog CancelReturnReasons objects
		When Create document SalesOrder objects (check movements, SC before SI, Use shipment sheduling)
		When Create document SalesOrder objects (check movements, SC before SI, not Use shipment sheduling)
		When Create document SalesOrder objects (with aging, prepaid)
		When Create document SalesOrder objects (with aging, post-shipment credit)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server	
			| "Documents.SalesOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(112).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(113).GetObject().Write(DocumentWriteMode.Posting);"    |

Scenario: _0920011 check preparation
	When check preparation


Scenario: _25003 check Sales order printing (different language)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesOrder"	
	* Select several SO
		And I go to line in "List" table and invert selection:
			| "Number"    |
			| "1"         |
		And I go to line in "List" table and invert selection:
			| "Number"    |
			| "112"       |
		And I click "SalesOrderPrint" button
	* Check print form
		And "PrintFormConfig" table became equal
			| 'Print'   | 'Object'                                      | 'Template'      | 'Count copy'    |
			| 'Yes'     | 'Sales order 112 dated 30.05.2021 12:24:18'   | 'Sales order'   | '1'             |
			| 'Yes'     | 'Sales order 113 dated 30.05.2021 12:32:01'   | 'Sales order'   | '1'             |
			| 'Yes'     | 'Sales order 1 dated 27.01.2021 19:50:45'     | 'Sales order'   | '1'             |
	* Hide
		And I click the button named "FormHide"
		When I Check the steps for Exception
			| 'And I go to the first line in "PrintFormConfig" table'    |
		And I click the button named "FormShow"
	* Check template
		And I go to line in "PrintFormConfig" table
			| 'Count copy'   | 'Object'                                    | 'Print'   | 'Template'       |
			| '1'            | 'Sales order 1 dated 27.01.2021 19:50:45'   | 'Yes'     | 'Sales order'    |
		Given "Result" spreadsheet document is equal to "Print1" by template
	* Check data language change
		And I click "Change lang" button
		And I select "Turkish" exact value from "Data" drop-down list
		Given "Result" spreadsheet document is equal to "Print2" by template
	* Check template language change
		And I select "Turkish" exact value from "Layout" drop-down list
		Given "Result" spreadsheet document is equal to "Print3" by template
	* Change language back
		And I select "English" exact value from "Layout" drop-down list
		And I select "English" exact value from "Data" drop-down list
		Given "Result" spreadsheet document is equal to "Print1" by template
		And I click "Change lang" button
		When I Check the steps for Exception
			| 'And I select "English" exact value from "Data" drop-down list'    |
	* Change language for several template
		And I go to line in "PrintFormConfig" table and invert selection:
			| "Object"                                     |
			| "Sales order 1 dated 27.01.2021 19:50:45"    |
		And I go to line in "PrintFormConfig" table and invert selection:
			| "Object"                                       |
			| "Sales order 113 dated 30.05.2021 12:32:01"    |
		And I go to line in "PrintFormConfig" table and invert selection:
			| "Object"                                       |
			| "Sales order 112 dated 30.05.2021 12:24:18"    |
		And I click "Change lang" button
		And I select "Turkish" exact value from "Data" drop-down list
		And I select "Turkish" exact value from "Layout" drop-down list
	* Check language change
		And "PrintFormConfig" table became equal
			| 'LL'       | 'Print'   | 'Object'                                      | 'Template'      | 'Count copy'    |
			| 'tr, tr'   | 'Yes'     | 'Sales order 112 dated 30.05.2021 12:24:18'   | 'Sales order'   | '1'             |
			| 'tr, tr'   | 'Yes'     | 'Sales order 113 dated 30.05.2021 12:32:01'   | 'Sales order'   | '1'             |
			| 'en, en'   | 'Yes'     | 'Sales order 1 dated 27.01.2021 19:50:45'     | 'Sales order'   | '1'             |
	* Check template
		And I go to line in "PrintFormConfig" table
			| 'Count copy'   | 'LL'       | 'Object'                                      | 'Print'   | 'Template'       |
			| '1'            | 'tr, tr'   | 'Sales order 113 dated 30.05.2021 12:32:01'   | 'Yes'     | 'Sales order'    |
		Given "Result" spreadsheet document is equal to "Print4" by template
		And I go to line in "PrintFormConfig" table
			| 'Count copy'   | 'LL'       | 'Object'                                      | 'Print'   | 'Template'       |
			| '1'            | 'tr, tr'   | 'Sales order 112 dated 30.05.2021 12:24:18'   | 'Yes'     | 'Sales order'    |
		Given "Result" spreadsheet document is equal to "Print5" by template	
		Then "Print form" window is opened
		And I go to line in "PrintFormConfig" table
			| 'Count copy'   | 'LL'       | 'Object'                                    | 'Print'   | 'Template'       |
			| '1'            | 'en, en'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | 'Yes'     | 'Sales order'    |
		Given "Result" spreadsheet document is equal to "Print1" by template				
		And I close all client application windows

Scenario: _25005 check Sales order printing (change template)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesOrder"				
	* Select several SO
		And I go to line in "List" table and invert selection:
			| "Number"    |
			| "1"         |
		And I go to line in "List" table and invert selection:
			| "Number"    |
			| "112"       |
		And I click "SalesOrderPrint" button
	* Change template
		And I go to line in "PrintFormConfig" table
			| 'Count copy'   | 'Object'                                      | 'Print'   | 'Template'       |
			| '1'            | 'Sales order 113 dated 30.05.2021 12:32:01'   | 'Yes'     | 'Sales order'    |
		And I click the button named "FormEditResult"	
		And I activate "Object" field in "PrintFormConfig" table
		And in "Result" spreadsheet document I move to "R8C3" cell
		And in "Result" spreadsheet document I double-click the current cell
		And in "Result" spreadsheet document I input text "Trousers2"
		And in "Result" spreadsheet document I move to "R9C3" cell
		And in "Result" spreadsheet document I double-click the current cell
		And in "Result" spreadsheet document I input text "5678899"
		And in "Result" spreadsheet document I move to "R11C3" cell
	* Check changes
		Given "Result" spreadsheet document is equal to "Print6" by template
	* Hiding the editing panel
		And I click the button named "FormEditResult"
		And in "Result" spreadsheet document I move to "R8C3" cell
		When I Check the steps for Exception
			| 'And in "Result" spreadsheet document I input text "Trousers3"'    |
		And I close all client application windows
				
				
		

				
						
				

						
		
				
				
					
		
				
				
				
				
				
				
