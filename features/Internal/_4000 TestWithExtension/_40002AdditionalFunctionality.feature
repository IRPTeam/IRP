#language: en
@tree
@Positive
@ExtensionReportForm

Feature: additional functionality


Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


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
		When Create catalog Countries objects
		When Create information register Barcodes records
		When Create catalog Users objects
		When Create catalog AccessGroups objects
		When Create catalog AccessProfiles objects
		When Create catalog CashAccounts objects
		When update ItemKeys
	* Add test extension
		Given I open hyperlink "e1cib/list/Catalog.Extensions"
		If "List" table does not contain lines Then
				| "Description" |
				| "AdditionalFunctionality" |
			When add Additional Functionality extension
	When create Workstation				

Scenario: _40002001 check preparation
	When check preparation 

Scenario: _4000201 driver install
	Given I open hyperlink "e1cib/list/Catalog.EquipmentDrivers"
	And I click the button named "FormCreate"
	* Check info message if driver was not loaded before
		And I input "barcode" text in "Description" field
		And I input "AddIn.InputDevice" text in "AddIn ID" field
		And I click "Install" button
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Given Recent TestClient message contains "Before install driver - it has to be loaded." string by template
	* Instal driver
		And I select external file "C:/AddComponents/barcode"
		And I click "Add file" button	
		And Delay 10
		And I click the button named "FormWrite"	
		And I click "Install" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I click the button named "FormWriteAndClose"		
		And I close all client application windows
		
		

				
Scenario: _4000202 hardware
	Given I open hyperlink "e1cib/list/Catalog.Hardware"
	And I click the button named "FormCreate"
	And I input "Test input device" text in "Description" field
	And I select "Input device" exact value from "Types of Equipment" drop-down list
	And I click Select button of "Driver" field
	And I go to line in "List" table
		| 'Description' |
		| 'barcode'     |
	And I select current line in "List" table
	And I click "Save" button
	And I move to "Driver settings" tab
	And in the table "DriverParameter" I click "Reload settings" button
	And I move to "Predefined settings" tab
	And in the table "ConnectParameters" I click "Load settings" button
	And "ConnectParameters" table contains lines
		| '#'  | 'Name'           | 'Value'                 |
		| '1'  | 'Port'           | '0'                     |
		| '2'  | 'Prefix'         | '-1'                    |
		| '3'  | 'Suffix'         | '3 338'                 |
		| '4'  | 'OutputDataType' | ''                      |
		| '5'  | 'GSSymbolKey'    | '7'                     |
		| '6'  | 'Timeout'        | '35'                    |
		| '7'  | 'DataBits'       | '8'                     |
		| '8'  | 'StopBits'       | ''                      |
		| '9'  | 'Parity'         | ''                      |
		| '10' | 'Speed'          | '9 600'                 |
		| '11' | 'COMEncoding'    | 'UTF-8'                 |
		| '12' | 'LogType'        | '-1'                    |
		| '13' | 'LogFilePath'    | 'C:\temp\scan_opos.txt' |
	And I click "Save" button		
	And I click the button named "FormWriteAndClose"

	
Scenario: _4000203 add hardware	to the workstation
	Given I open hyperlink "e1cib/list/Catalog.Workstations"
	* Select workstation
		And I go to line in "List" table
			| 'Description' |
			| 'Workstation 01'     |
		And I select current line in "List" table	
	* Check add hardware
		And in the table "HardwareList" I click the button named "HardwareListAdd"
		And I click choice button of "Hardware" attribute in "HardwareList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Test input device'     |
		And I select current line in "List" table
		And I activate "Enable" field in "HardwareList" table
		And I finish line editing in "HardwareList" table
		And I set "Enable" checkbox in "HardwareList" table
		And I finish line editing in "HardwareList" table
		And I click "Save" button
		And "HardwareList" table became equal
			| 'Enable' | 'Hardware'          |
			| 'Yes'    | 'Test input device' |
		And I close all client application windows
		
		
		
		
				

		
				


	
		
