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
		When Create catalog BusinessUnits objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create information register Taxes records (VAT)
		When Create catalog PrintFormTemplates objects (for Sales order)
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
	* Add one more print form for SO
		Given I open hyperlink "e1cib/list/Catalog.ConfigurationMetadata"
		And I go to line in "List" table
			| 'Description' |
			| 'Sales order' |	
		And I select current line in "List" table
		And I move to "Print templates" tab
		And in the table "PrintTemplates" I click the button named "PrintTemplatesAdd"
		And I click choice button of "Value" attribute in "PrintTemplates" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Print form SO' |
		And I select current line in "List" table
		And I click "Save and close" button
	And I close TestClient session
	Given I open new TestClient session or connect the existing one	
				

			
Scenario: _0920011 check preparation
	When check preparation

Scenario: _25002 print settings for company, store, business unit
	And I close all client application windows
	* Open PrintInfo catalog
		Given I open hyperlink "e1cib/list/Catalog.PrintInfo"
		And I click "Create" button
	* Print settings
		And I input "Print settings" text in the field named "Description"
		And I click Select button of "Default color" field
		And I go to line in "" table
			| 'Column2'            |
			| 'Tooltip background' |
		And I click "OK" button
		And I select external file "$Path$/features/External/step_definitions/Logo.png"
		And I click the hyperlink named "Logo"
		And I select external file "$Path$/features/External/step_definitions/Seal.png"
		And I click the hyperlink named "Seal"
		And I input "Test" text in "Additional print info" field
		And I click "Save" button
		Then the form attribute named "AdditionalPrintInfo" became equal to "Test"
		Then the form attribute named "DefaultColor" became equal to "style: Tooltip background"
		Then the form attribute named "Description" became equal to "Print settings"
		Then the field named "Logo" is filled
		Then the field named "Seal" is filled
		And I click "Save and close" button
	* Check creation
		And "List" table contains lines
			| 'Description'    |
			| 'Print settings' |
	* Add print settings for Main company
		Given I open hyperlink "e1cib/data/Catalog.Companies?ref=aa78120ed92fbced11eaf113ba6c185c"
		And I click Select button of "Print info" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Print settings' |
		And I select current line in "List" table
		And I select from "Print info" drop-down list by "Print settings" string
		And I click "Save" button
		Then the field named "PrintInfo" is filled
	* Add print settings for Store 02
		Given I open hyperlink "e1cib/data/Catalog.Stores?ref=aa78120ed92fbced11eaf114c59ef00c"
		And I click Select button of "Print info" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Print settings' |
		And I select current line in "List" table
		And I select from "Print info" drop-down list by "Print settings" string
		And I click "Save" button
		Then the field named "PrintInfo" is filled
	* Add print settings for Front office
		Given I open hyperlink "e1cib/data/Catalog.BusinessUnits?ref=aa78120ed92fbced11eaf114c59ef023"
		And I click Select button of "Print info" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Print settings' |
		And I select current line in "List" table
		And I select from "Print info" drop-down list by "Print settings" string
		And I click "Save" button
		Then the field named "PrintInfo" is filled		
		And I close all client application windows
				
				


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
		And I click the button named "FormDocumentSalesOrderSalesOrderPrint"
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
		And I click the button named "FormDocumentSalesOrderSalesOrderPrint"
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


Scenario: _25006 check Sales order printing (use print template)
	And I close all client application windows
	* Select SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"				
		And I go to line in "List" table and invert selection:
			| "Number"    |
			| "1"         |
	* Print and check parameters filling
		And I click "Print form SO" button
		Then "Result" spreadsheet document is equal
			| 'Preconditions:'                          |
			| ''                                        |
			| 'Sales order 1 is created in the system.' |
			| ''                                        |
			| 'Sales order contains data for fields:'   |
			| ' '                                       |
			| 'Customer Ferron BP, '                    |
			| ''                                        |
			| 'Order Date 27.01.21, Items , '           |
			| ''                                        |
			| 'Quantity , Prices , Total Amount .'      |
	And I close all client application windows
	
Scenario: _25010 create Print form template
	And I close all client application windows
	* Open Print form template catalog and create new element
		Given I open hyperlink "e1cib/list/Catalog.PrintFormTemplates"				
		And I click "Create" button
		And I input "Print form for SO 2" text in "ENG" field
		And I click "Start editing" button
		And I input "Order Date <Order Date>, Items <Item List>, <Order Partner>" text in the field named "TemplateTXT"
		And I click the button named "SaveTXT"
		And I move to "Parameters" tab
		And "Parameters" table became equal
			| '#' | 'Name'            | 'Expression' |
			| '1' | '<Item List>'     | ''           |
			| '2' | '<Order Date>'    | ''           |
			| '3' | '<Order Partner>' | ''           |
	* Fill code for Parameters
		And I activate "Expression" field in "Parameters" table
		And I go to line in "Parameters" table
			| "Name"         |
			| "<Order Date>" |
		And I select current line in "Parameters" table
		And I click Open button of the field named "ParametersExpression"			
		And I input "Result = Source.Date;" text in the field named "FormulaText"
		And I click Choice button of the field named "Source"
		Then "Select data type" window is opened
		And I go to line in "" table
			| ""            |
			| "Sales order" |
		And I select current line in "" table
		Then "Sales orders" window is opened
		And I go to line in "List" table
			| "Date"                | "Number" |
			| "30.05.2021 12:24:18" | "112"    |
		And I activate field named "Date" in "List" table
		And I select current line in "List" table
		And I click the button named "Test"
		Then the form attribute named "Result" became equal to "30.05.2021 12:24:18"
		And I click "Save" button
		And I finish line editing in "Parameters" table
		And I go to line in "Parameters" table
			| "Name"            |
			| "<Order Partner>" |
		And I select current line in "Parameters" table
		And I click Open button of the field named "ParametersExpression"	
		And I input "Result = Source.Partner;" text in the field named "FormulaText"
		And I click "Save" button
		And I finish line editing in "Parameters" table
		And "Parameters" table became equal
			| '#' | 'Name'            | 'Expression'               |
			| '1' | '<Item List>'     | ''                         |
			| '2' | '<Order Date>'    | 'Result = Source.Date;'    |
			| '3' | '<Order Partner>' | 'Result = Source.Partner;' |
		And I move to "Objects" tab
		And in the table "ObjectsList" I click "Add" button
		And I click choice button of "Value" attribute in "ObjectsList" table
		And I click "List" button
		And I go to line in "List" table
			| "Description" |
			| "Sales order" |
		And I select current line in "List" table
		And I finish line editing in "ObjectsList" table
		And I click "Save and close" button
	* Check creation
		And "List" table contains lines
			| 'Description'         | 'Print form type' |
			| 'Print form for SO 2' | 'TXT'             |
		And I close all client application windows
		
		
				

				
		
				
				
				
				

				
		
						
				

		
			
		
				
				
	