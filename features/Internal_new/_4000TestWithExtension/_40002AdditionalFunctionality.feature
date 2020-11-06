#language: en
@tree
@Positive
@Other
@ExtensionReportForm

Feature: additional functionality



Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _4000200 preparation
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Companies objects (Main company)
		When Create information register Barcodes records
		When Create catalog Users objects
		When Create catalog AccessGroups objects
		When Create catalog AccessProfiles objects
		When Create catalog CashAccounts objects
	* Add test extension
		Given I open hyperlink "e1cib/list/Catalog.Extensions"
		If "List" table does not contain lines Then
				| "Description" |
				| "AdditionalFunctionality" |
			When add Additional Functionality extension
	When create Workstation				

Scenario: _4000201 hardware
	Given I open hyperlink "e1cib/list/Catalog.Hardware"
	And I click the button named "FormCreate"
	And I input "Test input device" text in "Description" field
	And I select "Input device" exact value from "Types of Equipment" drop-down list
	And I click Select button of "Workstation" field
	And I go to line in "List" table
		| 'Description'  |
		| 'Workstation 01' |
	And I select current line in "List" table
	And I click the button named "FormWrite"
	And in the table "ConnectParameters" I click "Load settings" button
	And "ConnectParameters" table contains lines
		| '#'  | 'Name'                | 'Value' |
		| '1'  | 'COMEncoding'         | 'UTF-8' |
		| '2'  | 'DataBits'            | '8'     |
		| '3'  | 'GSSymbolKey'         | '-1'    |
		| '4'  | 'IgnoreKeyboardState' | 'Yes'   |
		| '5'  | 'OutputDataType'      | ''      |
		| '6'  | 'Port'                | '3'     |
		| '7'  | 'Prefix'              | '-1'    |
		| '8'  | 'Speed'               | '9 600' |
		| '9'  | 'StopBit'             | ''      |
		| '10' | 'Suffix'              | '13'    |
		| '11' | 'Timeout'             | '75'    |
		| '12' | 'TimeoutCOM'          | '5'     |
		| '13' | 'COMEncoding'         | 'UTF-8' |
		| '14' | 'DataBits'            | '8'     |
		| '15' | 'GSSymbolKey'         | '-1'    |
		| '16' | 'IgnoreKeyboardState' | 'Yes'   |
		| '17' | 'OutputDataType'      | ''      |
		| '18' | 'Port'                | '3'     |
		| '19' | 'Prefix'              | '-1'    |
		| '20' | 'Speed'               | '9 600' |
		| '21' | 'StopBit'             | ''      |
		| '22' | 'Suffix'              | '13'    |
		| '23' | 'Timeout'             | '75'    |
		| '24' | 'TimeoutCOM'          | '5'     |
	And I click the button named "FormWriteAndClose"

	
		

	
		
