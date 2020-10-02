#language: en
@tree
@Positive
@Catalogs

Feature: filling in Integration settings catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one
	And I set "True" value to the constant "ShowBetaTesting"
	And I set "True" value to the constant "ShowAlphaTestingSaas"
	And I set "True" value to the constant "UseItemKey"
	And I set "True" value to the constant "UseCompanies"




Scenario: _005012 filling in the "Integration settings" catalog
	* Create setting with integration type local file storage
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I click the button named "FormCreate"
		And I input "LOCAL STORAGE" text in "Description" field
		And I select "Local file storage" exact value from "Integration type" drop-down list
		And in the table "ConnectionSetting" I click the button named "ConnectionSettingFillByDefault"
		And I go to line in "ConnectionSetting" table
			| 'Key'         |
			| 'AddressPath' |
		And I activate "Value" field in "ConnectionSetting" table
		And I select current line in "ConnectionSetting" table
		And I input "#workingDir#\DataProcessor\Picture\Source" text in "Value" field of "ConnectionSetting" table
		And I finish line editing in "ConnectionSetting" table
		And I go to line in "ConnectionSetting" table
			| 'Key'       | 'Value' |
			| 'QueryType' | 'POST'  |
		And I activate "Key" field in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I delete a line in "ConnectionSetting" table
		And I click "Save and close" button
	* Create setting with integration type file storage
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I click the button named "FormCreate"
		And I input "FILE STORAGE" text in "Description" field
		And I select "File storage" exact value from "Integration type" drop-down list
		And in the table "ConnectionSetting" I click the button named "ConnectionSettingFillByDefault"
		And I activate "Value" field in "ConnectionSetting" table
		And I input "GET" text in "Value" field of "ConnectionSetting" table
		And I finish line editing in "ConnectionSetting" table
		And I go to line in "ConnectionSetting" table
			| 'Key'             |
			| 'ResourceAddress' |
		And I select current line in "ConnectionSetting" table
		And I input "/hs/filetransfer" text in "Value" field of "ConnectionSetting" table
		And I finish line editing in "ConnectionSetting" table
		And I go to line in "ConnectionSetting" table
			| 'Key' | 'Value'     |
			| 'Ip'  | 'localhost' |
		And I select current line in "ConnectionSetting" table
		And I input "localhost" text in "Value" field of "ConnectionSetting" table
		And I finish line editing in "ConnectionSetting" table
		And I go to line in "ConnectionSetting" table
			| 'Key'  | 'Value' |
			| 'Port' | '8 080' |
		And I select current line in "ConnectionSetting" table
		And I input "8 080" text in "Value" field of "ConnectionSetting" table
		And I finish line editing in "ConnectionSetting" table
		And I go to line in "ConnectionSetting" table
			| 'Key'  |
			| 'User' |
		And I select current line in "ConnectionSetting" table
		And I input "Admin" text in "Value" field of "ConnectionSetting" table
		And I finish line editing in "ConnectionSetting" table
		And I go to line in "ConnectionSetting" table
			| 'Key'      |
			| 'Password' |
		And I select current line in "ConnectionSetting" table
		And I input "123" text in "Value" field of "ConnectionSetting" table
		And I finish line editing in "ConnectionSetting" table
		And I go to line in "ConnectionSetting" table
			| 'Key'              |
			| 'SecureConnection' |
		And I select current line in "ConnectionSetting" table
		And I click choice button of "Value" attribute in "ConnectionSetting" table
		Then "Select data type" window is opened
		And I go to line in "" table
			| ''        |
			| 'Boolean' |
		And I select current line in "" table
		Then "Integration setting (create) *" window is opened
		And I select "Yes" exact value from "Value" drop-down list in "ConnectionSetting" table
		And I click "Save" button
		Then the form attribute named "Description" became equal to "FILE STORAGE"
		And I wait the field named "UniqueID" will be filled in "10" seconds
		Then the form attribute named "IntegrationType" became equal to "File storage"
		And "ConnectionSetting" table became equal
			| '#'  | 'Key'                 | 'Value'            |
			| '1'  | 'QueryType'           | 'GET'              |
			| '2'  | 'ResourceAddress'     | '/hs/filetransfer' |
			| '3'  | 'Ip'                  | 'localhost'        |
			| '4'  | 'Port'                | '8 080'            |
			| '5'  | 'User'                | 'Admin'            |
			| '6'  | 'Password'            | '123'              |
			| '7'  | 'Proxy'               | ''                 |
			| '8'  | 'TimeOut'             | '60'               |
			| '9'  | 'SecureConnection'    | 'Yes'              |
			| '10' | 'UseOSAuthentication' | 'No'               |
			| '11' | 'Headers'             | 'Map'              |
		Then the form attribute named "ExternalDataProc" became equal to ""
		And I click "Save and close" button
	* Create setting with integration type Google drive (without connection)
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I click the button named "FormCreate"
		And I input "Google drive" text in "Description" field
		And I select "Google drive" exact value from "Integration type" drop-down list
		And I click "Save and close" button
	* Create setting with integration type Other (without connection)
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I click the button named "FormCreate"
		And I input "Other" text in "Description" field
		And I select "Other" exact value from "Integration type" drop-down list
		And I click "Save and close" button
	* Create setting to download the course (bank.gov.ua)
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I click the button named "FormCreate"
		And I input "Bank UA" text in "Description" field
		And I click "Save" button
		And I select "Currency rates" exact value from "Integration type" drop-down list
		And I click Select button of "Plugins" field
		And I go to line in "List" table
			| 'Description'    |
			| 'ExternalBankUa' |
		And I select current line in "List" table
		And I click "Save and close" button
	* Check data save
		And "List" table contains lines
			| 'Description'     |
			| 'Bank UA'         |
			| 'FILE STORAGE'    |
			| 'Google drive'    |
			| 'LOCAL STORAGE'   |
			| 'Other'           |
		And I close all client application windows
		