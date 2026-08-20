#language: en
@tree
@Positive
@Other


Feature: find and replace references

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _608700 preparation (find and replace)
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
		When Create information register CurrencyRates records
		When Create information register Taxes records (VAT)
	* Load SO
		When Create catalog CancelReturnReasons objects
		When Create document SalesOrder objects (check movements, SC before SI, Use shipment sheduling)
		When Create document SalesOrder objects (check movements, SC before SI, not Use shipment sheduling)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
	And I close all client application windows


Scenario: _6087001 check preparation
	When check preparation


Scenario: _608701 check find values
	And I close all client application windows
	* Search for all references to a partner
		Given I open hyperlink "e1cib/app/DataProcessor.FindAndReplace"
		And in the table "ReplaceValues" I click "Add" button
		And I click choice button of "Find value" attribute in "ReplaceValues" table
		Then "Select data type" window is opened
		And I go to line in "TypeTree" table
			| '' |
			| 'Partner' |
		And I select current line in "TypeTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP' |
		And I select current line in "List" table
		And I finish line editing in "ReplaceValues" table
		And I click "Find values" button
	* The references table shows the documents and register records
		And "References" table contains lines
			| 'Use' | 'Data'                 | 'Metadata'                            |
			| 'Yes' | 'Sales order 1 dated*' | 'Document.SalesOrder'                 |
			| 'Yes' | 'Sales order 2 dated*' | 'Document.SalesOrder'                 |
			| 'Yes' | '*'                    | 'InformationRegister.PartnerSegments' |
	And I close all client application windows


Scenario: _608702 check selective replace in a document header attribute
	And I close all client application windows
	* Search for all references to a partner
		Given I open hyperlink "e1cib/app/DataProcessor.FindAndReplace"
		And in the table "ReplaceValues" I click "Add" button
		And I click choice button of "Find value" attribute in "ReplaceValues" table
		Then "Select data type" window is opened
		And I go to line in "TypeTree" table
			| '' |
			| 'Partner' |
		And I select current line in "TypeTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP' |
		And I select current line in "List" table
		And I click choice button of "Replace value" attribute in "ReplaceValues" table
		Then "Select data type" window is opened
		And I go to line in "TypeTree" table
			| '' |
			| 'Partner' |
		And I select current line in "TypeTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso' |
		And I select current line in "List" table
		And I finish line editing in "ReplaceValues" table
		And I click "Find values" button
	* Keep only Sales order 2 checked
		And I click the button named "ReferencesUncheckAll"
		And I go to line in "References" table
			| 'Data' |
			| 'Sales order 2 dated*' |
		And I set checkbox named "ReferencesUse" in "References" table
		And I finish line editing in "References" table
	* Replace
		And I click "Replace values" button
		Given Recent TestClient message contains "Completed" string by template
	* Only the checked document is changed
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And "List" table contains lines
			| 'Number' | 'Partner' |
			| '1'      | 'Ferron BP' |
			| '2'      | 'Kalipso' |
	And I close all client application windows


Scenario: _608703 check replace in a document tabular section
	And I close all client application windows
	// Sales order 2 has the Dress item in two rows - both must be replaced
	* Search for all references to an item
		Given I open hyperlink "e1cib/app/DataProcessor.FindAndReplace"
		And in the table "ReplaceValues" I click "Add" button
		And I click choice button of "Find value" attribute in "ReplaceValues" table
		Then "Select data type" window is opened
		And I go to line in "TypeTree" table
			| '' |
			| 'Item' |
		And I select current line in "TypeTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress' |
		And I select current line in "List" table
		And I click choice button of "Replace value" attribute in "ReplaceValues" table
		Then "Select data type" window is opened
		And I go to line in "TypeTree" table
			| '' |
			| 'Item' |
		And I select current line in "TypeTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers' |
		And I select current line in "List" table
		And I finish line editing in "ReplaceValues" table
		And I click "Find values" button
	* Keep only Sales order 2 checked
		And I click the button named "ReferencesUncheckAll"
		And I go to line in "References" table
			| 'Data' |
			| 'Sales order 2 dated*' |
		And I set checkbox named "ReferencesUse" in "References" table
		And I finish line editing in "References" table
	* Replace
		And I click "Replace values" button
		Given Recent TestClient message contains "Completed" string by template
	* Both Dress rows of Sales order 2 are replaced, Sales order 1 is untouched
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number' |
			| '2'      |
		And I select current line in "List" table
		And "ItemList" table does not contain rows by template:
			| 'Item'  |
			| 'Dress' |
		And I close current window
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Item'  |
			| 'Dress' |
		And I close current window
	And I close all client application windows


Scenario: _608704 check replace in an information register record
	And I close all client application windows
	* Search for all references to a partner with a segment record
		Given I open hyperlink "e1cib/app/DataProcessor.FindAndReplace"
		And in the table "ReplaceValues" I click "Add" button
		And I click choice button of "Find value" attribute in "ReplaceValues" table
		Then "Select data type" window is opened
		And I go to line in "TypeTree" table
			| '' |
			| 'Partner' |
		And I select current line in "TypeTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'David Romanov' |
		And I select current line in "List" table
		And I click choice button of "Replace value" attribute in "ReplaceValues" table
		Then "Select data type" window is opened
		And I go to line in "TypeTree" table
			| '' |
			| 'Partner' |
		And I select current line in "TypeTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Nicoletta' |
		And I select current line in "List" table
		And I finish line editing in "ReplaceValues" table
		And I click "Find values" button
	* Keep only the partner segments record checked
		And I click the button named "ReferencesUncheckAll"
		And I go to line in "References" table
			| 'Metadata' |
			| 'InformationRegister.PartnerSegments' |
		And I set checkbox named "ReferencesUse" in "References" table
		And I finish line editing in "References" table
	* Replace
		And I click "Replace values" button
		Given Recent TestClient message contains "Completed" string by template
	* The register record is re-keyed to the new partner
		Given I open hyperlink "e1cib/list/InformationRegister.PartnerSegments"
		And "List" table contains lines
			| 'Partner'   | 'Segment'  |
			| 'Nicoletta' | 'Region 1' |
		And "List" table does not contain rows by template:
			| 'Partner'       | 'Segment'  |
			| 'David Romanov' | 'Region 1' |
	And I close all client application windows


Scenario: _608705 check replace does not silently merge information register records
	And I close all client application windows
	// documents a PR2965 defect: when the target key already exists, the replacement
	// in an independent information register silently deletes the source record and
	// overwrites the existing target record (Module.bsl, information registers branch:
	// RecordSet.Clear + Write, then Load + Write on the new filter without any check).
	// Expected: the operation must refuse the row or warn - the source record must survive
	* Search for all references to a partner whose segment pair exists for another partner
		Given I open hyperlink "e1cib/app/DataProcessor.FindAndReplace"
		And in the table "ReplaceValues" I click "Add" button
		And I click choice button of "Find value" attribute in "ReplaceValues" table
		Then "Select data type" window is opened
		And I go to line in "TypeTree" table
			| '' |
			| 'Partner' |
		And I select current line in "TypeTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Lomaniti' |
		And I select current line in "List" table
		And I click choice button of "Replace value" attribute in "ReplaceValues" table
		Then "Select data type" window is opened
		And I go to line in "TypeTree" table
			| '' |
			| 'Partner' |
		And I select current line in "TypeTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Big foot' |
		And I select current line in "List" table
		And I finish line editing in "ReplaceValues" table
		And I click "Find values" button
	* Keep only the partner segments record checked
		And I click the button named "ReferencesUncheckAll"
		And I go to line in "References" table
			| 'Metadata' |
			| 'InformationRegister.PartnerSegments' |
		And I set checkbox named "ReferencesUse" in "References" table
		And I finish line editing in "References" table
	* Replace
		And I click "Replace values" button
	* The source record must not be silently merged into the existing target record
		Given I open hyperlink "e1cib/list/InformationRegister.PartnerSegments"
		And "List" table contains lines
			| 'Partner'  | 'Segment' |
			| 'Lomaniti' | 'Retail'  |
	And I close all client application windows


// Scenario: _608706 check replace with equal find and replace values
// Documents the PR2965 defect D6: when FindValue = ReplaceValue the replacement loop
// (While TableRow <> Undefined ... Find on the same value) never terminates and hangs
// the server session, taking the whole test run with it. The scenario must stay
// commented out until the defect is fixed; then uncomment and expect an error message
// (or a no-op) instead of a hang:
//	* Set equal find and replace values (any referenced partner) and one checked row
//	* Click "Replace values"
//	* Expect: the data processor reports an error, the session stays alive
