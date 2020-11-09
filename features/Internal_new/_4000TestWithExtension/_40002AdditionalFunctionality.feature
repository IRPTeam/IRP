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


Scenario: _4000201 driver install
	Given I open hyperlink "e1cib/list/Catalog.EquipmentDrivers"
	And I click the button named "FormCreate"
	* Check info message if driver was not loaded before
		And I input "Test.driver" text in "AddIn ID" field
		And I click "Install" button
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Given Recent TestClient message contains "Before install driver - it has to be loaded." string by template
	* Instal driver
		And I select external file "C:\AddComponents\1Native"
		And I click "Add file" button	
		And I click the button named "FormWrite"	
		And I click "Install" button
		And I close all client application windows
		
		

				
Scenario: _4000202 hardware
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
		| 'Name'                | 'Value' |
		| 'COMEncoding'         | 'UTF-8' |
		| 'DataBits'            | '8'     |
		| 'GSSymbolKey'         | '-1'    |
		| 'IgnoreKeyboardState' | 'Yes'   |
		| 'OutputDataType'      | ''      |
		| 'Port'                | '3'     |
		| 'Prefix'              | '-1'    |
		| 'Speed'               | '9 600' |
		| 'StopBit'             | ''      |
		| 'Suffix'              | '13'    |
		| 'Timeout'             | '75'    |
		| 'TimeoutCOM'          | '5'     |
		| 'COMEncoding'         | 'UTF-8' |
		| 'DataBits'            | '8'     |
		| 'GSSymbolKey'         | '-1'    |
		| 'IgnoreKeyboardState' | 'Yes'   |
		| 'OutputDataType'      | ''      |
		| 'Port'                | '3'     |
		| 'Prefix'              | '-1'    |
		| 'Speed'               | '9 600' |
		| 'StopBit'             | ''      |
		| 'Suffix'              | '13'    |
		| 'Timeout'             | '75'    |
		| 'TimeoutCOM'          | '5'     |
	And I click the button named "FormWriteAndClose"

	
		

	
		
