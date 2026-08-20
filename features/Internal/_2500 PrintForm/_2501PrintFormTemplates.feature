#language: en
@tree
@Positive
@PrintForm


Feature: print form templates (types, tables, print info, saved forms, access)

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _251100 preparation (print form templates)
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
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
	And I close all client application windows


Scenario: _2511001 check preparation
	When check preparation


Scenario: _25011 create and print MXL template
	And I close all client application windows
	* Create the template
		Given I open hyperlink "e1cib/list/Catalog.PrintFormTemplates"
		And I click "Create" button
		And I input "MXL print SO" text in "ENG" field
		And I select from the drop-down list named "PrintFormType" by "MXL" string
		And I click the button named "EditMXL"
		And in "TemplateMXL" spreadsheet document I input text "MXL BODY TEST"
		And I click the button named "SaveMXL"
	* Bind the template to Sales order
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
	* Restart the session so that the new print command is built
		And I close TestClient session
		Given I open new TestClient session or connect the existing one
	* Print a Sales order with the new template
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| "Number" |
			| "1"      |
		And I click "MXL print SO" button
		Then "Result" spreadsheet document contains lines
			| 'MXL BODY TEST' |
	And I close all client application windows


Scenario: _25012 create and print formatted text template
	And I close all client application windows
	* Create the template of the type added by this PR
		Given I open hyperlink "e1cib/list/Catalog.PrintFormTemplates"
		And I click "Create" button
		And I input "FT print SO" text in "ENG" field
		And I select from the drop-down list named "PrintFormType" by "Formatted text" string
		And I click the button named "EditFT"
		And I input "FT BODY TEST" text in the field named "TemplateFT"
		And I click the button named "SaveFT"
	* Bind the template to Sales order
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
	* Restart the session so that the new print command is built
		And I close TestClient session
		Given I open new TestClient session or connect the existing one
	* Print a Sales order with the new template
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| "Number" |
			| "1"      |
		And I click "FT print SO" button
		Then "Result" spreadsheet document contains lines
			| 'FT BODY TEST' |
	And I close all client application windows


Scenario: _25013 create and print template with a repeating table area
	And I close all client application windows
	* Create the template with one repeating line
		// the line is static: the repeating area itself multiplies it per ItemList row (SO 1 has 5 rows);
		// binding a parameter to a table is not covered - the MoveToTable chooser is not reachable for VA
		Given I open hyperlink "e1cib/list/Catalog.PrintFormTemplates"
		And I click "Create" button
		And I input "Table print SO" text in "ENG" field
		And I click "Start editing" button
		And I input "Item row." text in the field named "TemplateTXT"
		And I click the button named "SaveTXT"
	* Describe the repeating area
		And I set checkbox named "UseTables"
		And in the table "Tables" I click "Add" button
		And I input "Items" text in the field named "TablesName" of "Tables" table
		And I input "Result = Source.ItemList;" text in the field named "TablesExpression" of "Tables" table
		And I set checkbox named "TablesRepeatingArea" in "Tables" table
		And I input "1" text in the field named "TablesLineStart" of "Tables" table
		And I input "1" text in the field named "TablesLineEnd" of "Tables" table
		And I finish line editing in "Tables" table
	* Bind the template to Sales order
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
	* Restart the session so that the new print command is built
		And I close TestClient session
		Given I open new TestClient session or connect the existing one
	* Print a Sales order and check the repeated rows
		// red until fixed: the print form window stays empty for a TXT template with a
		// repeating table area, while the server assembly is correct - a direct call of
		// Catalogs.PrintFormTemplates.GetPrintForm returns the expected five rows.
		// MXL, formatted text and TXT-without-tables templates print fine
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| "Number" |
			| "1"      |
		And I click "Table print SO" button
		And I wait for "Result" spreadsheet document filling for "15" seconds
		Then "Result" spreadsheet document contains lines
			| 'Item row.' |
			| 'Item row.' |
			| 'Item row.' |
			| 'Item row.' |
			| 'Item row.' |
	And I close all client application windows


Scenario: _25014 create and print template with print information
	And I close all client application windows
	* Create the print info element and assign it to the company
		Given I open hyperlink "e1cib/list/Catalog.PrintInfo"
		And I click "Create" button
		And I input "Template print info" text in the field named "Description"
		And I input "PRINT INFO TEXT" text in "Additional print info" field
		And I click "Save and close" button
		Given I open hyperlink "e1cib/data/Catalog.Companies?ref=aa78120ed92fbced11eaf113ba6c185c"
		And I select from "Print info" drop-down list by "Template print info" string
		And I click "Save and close" button
	* Create the template using print information
		Given I open hyperlink "e1cib/list/Catalog.PrintFormTemplates"
		And I click "Create" button
		And I input "Info print SO" text in "ENG" field
		And I click "Start editing" button
		And I input "INFO BODY <PrintInfo.Text>" text in the field named "TemplateTXT"
		And I click the button named "SaveTXT"
		And I set checkbox named "UsePrintInformations"
		And I click the button named "OpenPrintInfoPath"
		And I input "Result = Source.Company.PrintInfo;" text in the field named "FormulaText"
		And I click "Save" button
	* Bind the template to Sales order
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
	* Restart the session so that the new print command is built
		And I close TestClient session
		Given I open new TestClient session or connect the existing one
	* Print a Sales order and check the print info text
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| "Number" |
			| "1"      |
		And I click "Info print SO" button
		Then "Result" spreadsheet document contains lines by template
			| '*INFO BODY*' |
		And "Result" spreadsheet document contains lines by template
			| '*PRINT INFO TEXT*' |
	And I close all client application windows


Scenario: _25016 check saved print form is offered from history
	And I close all client application windows
	* Switch the saved print forms option on
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		And I set checkbox "Use saved print forms"
		And I click "Save" button
		And I close current window
	* Save a print form into the register
		// saving through the UI needs a visible PrintFormConfig row (several documents at once),
		// which this VA build cannot select - the write side is exercised through the register
		// API added by the PR, the read side below is pure UI
		And I execute 1C:Enterprise script at server
			| 'TD = New SpreadsheetDocument; TD.Area("R1C1").Text = "SAVED FORM MARK"; InformationRegisters.SavedPrintForms.SaveToSavedPrintForms(Documents.SalesOrder.FindByNumber(1), "SalesOrderPrint", Catalogs.PrintFormTemplates.EmptyRef(), TD);' |
	* The saved form is shown when the print source is switched to history
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| "Number" |
			| "1"      |
		And I click the button named "FormDocumentSalesOrderSalesOrderPrint"
		And I change the radio button named "PrintSource" value to "From history"
		// red until fixed: switching the print source to the history leaves the Result
		// spreadsheet empty, while the saved form is present in the register with the
		// expected content (verified via GetSavedPrintForm) - same UI display root as
		// the repeating-table template above
		Then "Result" spreadsheet document contains lines
			| 'SAVED FORM MARK' |
	And I close all client application windows


Scenario: _25018 check print form is rebuilt when the option is off
	And I close all client application windows
	* Switch the saved print forms option off
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		And I remove checkbox "Use saved print forms"
		And I click "Save" button
		And I close current window
	* The saved form is not offered anymore
		// this is the branch discriminator: with the option on this command opens the saved
		// form from the history (see _25016); with the option off the history source is gone
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| "Number" |
			| "1"      |
		And I click the button named "FormDocumentSalesOrderSalesOrderPrint"
		And I expect the form element named "PrintSource" to be absent from the form for "10" seconds.
		And "Result" spreadsheet document does not contain values
			| 'SAVED FORM MARK' |
		And I close current window	* Change the template body
		Given I open hyperlink "e1cib/list/Catalog.PrintFormTemplates"
		And I go to line in "List" table
			| 'Description'  |
			| 'MXL print SO' |
		And I select current line in "List" table
		And I click the button named "EditMXL"
		And in "TemplateMXL" spreadsheet document I input text "CHANGED MXL BODY"
		And I click the button named "SaveMXL"
		And I click "Save and close" button
	* Print now rebuilds the form from the changed template
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| "Number" |
			| "1"      |
		And I click "MXL print SO" button
		Then "Result" spreadsheet document contains lines
			| 'CHANGED MXL BODY' |
	And I close all client application windows


Scenario: _25015 check limited access template hides its print command
	And I close all client application windows
	* Limit the template access without granting any group
		Given I open hyperlink "e1cib/list/Catalog.PrintFormTemplates"
		And I go to line in "List" table
			| 'Description' |
			| 'FT print SO' |
		And I select current line in "List" table
		And I move to the tab named "PageAccess"
		And I set checkbox named "LimitedAccess"
		And I click "Save and close" button
	* Restart the session so that the command list is rebuilt
		And I close TestClient session
		Given I open new TestClient session or connect the existing one
	* The print command of the limited template is not built anymore
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| "Number" |
			| "1"      |
		When I Check the steps for Exception
			| 'And I click "FT print SO" button' |
	And I close all client application windows
