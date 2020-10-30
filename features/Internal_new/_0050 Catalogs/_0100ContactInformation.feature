#language: en
@tree
@Positive
@ContactInformation


Feature: filling in customer contact information

As an owner
I want there to be a mechanism for entering customer contact information
To specify: address, phone, e-mail, gps coordinate on the map


Background:
	Given I open new TestClient session or connect the existing one


   

Scenario: _010004 create Contact info Type - Addresses
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Preparation
		When Create catalog Countries objects
	* Add Plugin sessing for entering addresses
		* Opening a form to add Plugin sessing
			Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
			And I click the button named "FormCreate"
		* Adding Plugin sessing 
			And I select external file "#workingDir#\DataProcessor\InputAddress.epf"
			And I click the button named "FormAddExtDataProc"
			And I input "" text in "Path to plugin for test" field
			And I input "ExternaInputAddress" text in "Name" field
			And I click Open button of the field named "Description_en"
			And I input "ExternalInputAddress" text in the field named "Description_en"
			And I input "ExternalInputAddress" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
			And Delay 5
		* Check adding Plugin sessing
			Then I check for the "ExternalDataProc" catalog element with the "Description_en" "ExternalInputAddress"
	* Opening a form to add Plugin sessing
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.IDInfoTypes"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Google Addreses" text in the field named "Description_en"
		And I input "Google Addreses TR" text in the field named "Description_tr"
		And I click "Ok" button
		And in the table "ExternalDataProcess" I click the button named "ExternalDataProcessAdd"
		And I input "Adr_10" text in "Unique ID" field
		And I change checkbox "Show on form"
		And I change checkbox "Read only"
	* Adding Plugin sessing for addresses
		And I click choice button of "Country" attribute in "ExternalDataProcess" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Ukraine'    |
		And I select current line in "List" table
		And I activate "Plugins" field in "ExternalDataProcess" table
		And I click choice button of "Plugins" attribute in "ExternalDataProcess" table
		Then "Plugins" window is opened
		And I go to line in "List" table
			| 'Description'                |
			| 'ExternalInputAddress' |
		And I select current line in "List" table
		And I click "Save and close" button
		And Delay 5
		And "List" table contains lines
		| 'Description' |
		| 'Google Addreses'  |

Scenario: _010005 verification of UNIQ ID uniqueness control in IDInfoTypes
	* Create one more item with ID Adr_10
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.IDInfoTypes"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Test" text in the field named "Description_en"
		And I input "Test" text in the field named "Description_tr"
		And I click "Ok" button
		And in the table "ExternalDataProcess" I click the button named "ExternalDataProcessAdd"
		And I input "Adr_10" text in "Unique ID" field
		And I change checkbox "Show on form"
		And I change checkbox "Read only"
		And I click "Save and close" button
		And I close warning window
	* Check message by non-unique ID
		Then I wait that in user messages the "Value is not unique." substring will appear in 30 seconds
		And I close all client application windows


Scenario: _010009 adding phones to Contact info type
	* Add Plugin sessing for phone
		* Opening a form to add Plugin sessing
			Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
			And I click the button named "FormCreate"
		* Filling in the 'External Input Phone Ukraine' and adding it to the database
			And I select external file "#workingDir#\DataProcessor\InputPhoneUkraine.epf"
			And I click the button named "FormAddExtDataProc"
			And I input "" text in "Path to plugin for test" field
			And I input "ExternalInputPhoneUkraine" text in "Name" field
			And I click Open button of the field named "Description_en"
			And I input "ExternalInputPhoneUkraine" text in the field named "Description_en"
			And I input "ExternalInputPhoneUkraine" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
			And Delay 5
			Then I check for the "ExternalDataProc" catalog element with the "Description_en" "ExternalInputPhoneUkraine"
		* Add processing Phone TR
			Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
			And I click the button named "FormCreate"
			And I select external file "#workingDir#\DataProcessor\InputPhoneUkraine.epf"
			And I click the button named "FormAddExtDataProc"
			And I input "" text in "Path to plugin for test" field
			And I input "PhoneTR" text in "Name" field
			And I click Open button of the field named "Description_en"
			And I input "Phone TR" text in the field named "Description_en"
			And I input "Phone TR" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
			And Delay 5
			Then I check for the "ExternalDataProc" catalog element with the "Description_en" "Phone TR"
	* Opening the form for filling in Contact info type
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.IDInfoTypes"
	* Creation Company phone
		And I click the button named "FormCreate"
		And I click Select button of "Value type" field
		* Filling in description and data type
			And I go to line in "" table
				| ''       |
				| 'String' |
			And I click "OK" button
			And I input "Phone_1" text in "Unique ID" field
			And I click Open button of the field named "Description_en"
			And I input "Company phone" text in the field named "Description_en"
			And I input "Company phone TR" text in the field named "Description_tr"
			And I click "Ok" button
			And I change checkbox "Show on form"
			And in the table "ExternalDataProcess" I click the button named "ExternalDataProcessAdd"
			And I click choice button of "Plugins" attribute in "ExternalDataProcess" table
			And I go to line in "List" table
				| 'Description'                      |
				| 'ExternalInputPhoneUkraine' |
			And I select current line in "List" table
			And I finish line editing in "ExternalDataProcess" table
			And I activate "Country" field in "ExternalDataProcess" table
			And I select current line in "ExternalDataProcess" table
			And I click choice button of "Country" attribute in "ExternalDataProcess" table
			And I go to line in "List" table
				| Description |
				| Ukraine   |
			And I select current line in "List" table
		And I finish line editing in "ExternalDataProcess" table
			And I click "Save and close" button
			And Delay 5
			And I enter a Unique ID String field type value for the phone
	* Check for created "Company phone"
		And "List" table contains lines
		| 'Description'     |
		| 'Company phone' |
	* Creation Partner phone
		And I click the button named "FormCreate"
		* Filling in description and data type
			Then "Contact info type (create)" window is opened
			And I click Select button of "Value type" field
			Then "Edit data type" window is opened
			And I go to line in "" table
				| ''       |
				| 'String' |
			And I click "OK" button
			And I input "Phone_2" text in "Unique ID" field
			And I click Open button of the field named "Description_en"
			And I input "Partner phone" text in the field named "Description_en"
			And I input "Partner phone" text in the field named "Description_tr"
			And I click "Ok" button
			And I change checkbox "Show on form"
			And in the table "ExternalDataProcess" I click the button named "ExternalDataProcessAdd"
			And I click choice button of "Plugins" attribute in "ExternalDataProcess" table
			And I go to line in "List" table
				| 'Description'                      |
				| 'ExternalInputPhoneUkraine' |
			And I select current line in "List" table
			And I finish line editing in "ExternalDataProcess" table
			And I activate "Country" field in "ExternalDataProcess" table
			And I select current line in "ExternalDataProcess" table
			And I click choice button of "Country" attribute in "ExternalDataProcess" table
			And I go to line in "List" table
				| Description |
				| Ukraine   |
			And I select current line in "List" table
			And I click "Save and close" button
			And Delay 5
			And I enter a Unique ID String field type value for the partner phone
	* Check for created Partner phone
		And "List" table contains lines
			| 'Description'     |
			| 'Partner phone' |

Scenario: _010010 adding addresses to a Contact info type
	* Opening the form for filling in Contact info type
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.IDInfoTypes"
	* Adding an actual address for partners
		And I click the button named "FormCreate"
		* Filling in data type
			And I click Select button of "Value type" field
			Then "Edit data type" window is opened
			And I go to line in "" table
				| ''                |
				| 'Address hierarchy' |
			And I click "OK" button
			And I input "Adr_1" text in "Unique ID" field
			And I change checkbox "Show on form"
		* Filling in the name of the address
			And I click Open button of the field named "Description_en"
			And I input "Location address (Partner)" text in the field named "Description_en"
			And I input "Location address (Partner) TR" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
			And Delay 5
	* Adding an actual address for company
		And I click the button named "FormCreate"
		* Filling in data type
			And I click Select button of "Value type" field
			Then "Edit data type" window is opened
			And I go to line in "" table
				| ''                |
				| 'Address hierarchy' |
			And I click "OK" button
			And I input "Adr_2" text in "Unique ID" field
			And I change checkbox "Show on form"
			And I set checkbox named "ReadOnly"
		* Filling in the name of the address
			And I click Open button of the field named "Description_en"
			And I input "Billing address (Company)" text in the field named "Description_en"
			And I input "Billing address (Company) TR" text in the field named "Description_tr"
			And I click "Ok" button
			And in the table "ExternalDataProcess" I click the button named "ExternalDataProcessAdd"
		* Adding Plugin sessing to specify the address for Ukraine
			And I click choice button of "Country" attribute in "ExternalDataProcess" table
			And I go to line in "List" table
				| Description |
				| Ukraine     |
			And I select current line in "List" table
			And I move to the next attribute
			And I click choice button of "Plugins" attribute in "ExternalDataProcess" table
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'                |
				| 'ExternalInputAddress' |
			And I select current line in "List" table
			And I finish line editing in "ExternalDataProcess" table
		* Adding Plugin sessing to specify the address for Turkey
			And in the table "ExternalDataProcess" I click the button named "ExternalDataProcessAdd"
			And I click choice button of "Country" attribute in "ExternalDataProcess" table
			And I go to line in "List" table
				| Description |
				| Turkey     |
			And I select current line in "List" table
			And I move to the next attribute
			And I click choice button of "Plugins" attribute in "ExternalDataProcess" table
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'                |
				| 'ExternalInputAddress' |
			And I select current line in "List" table
			And I finish line editing in "ExternalDataProcess" table
			And I click "Save and close" button
			And Delay 5
	* Adding a legal address for a company
		And I click the button named "FormCreate"
		* Filling in data type
			And I click Select button of "Value type" field
			Then "Edit data type" window is opened
			And I go to line in "" table
				| ''                |
				| 'Address hierarchy' |
			And I click "OK" button
			And I input "Adr_3" text in "Unique ID" field
			And I change checkbox "Show on form"
			And I set checkbox named "ReadOnly"
		* Filling in the name of the address detail
			And I click Open button of the field named "Description_en"
			And I input "Registered address  (Company)" text in the field named "Description_en"
			And I input "Registered address (Company) TR" text in the field named "Description_tr"
			And I click "Ok" button
			And in the table "ExternalDataProcess" I click the button named "ExternalDataProcessAdd"
		* Adding Plugin sessing to specify the address for Ukraine
			And I click choice button of "Country" attribute in "ExternalDataProcess" table
			And I go to line in "List" table
				| Description |
				| Ukraine     |
			And I select current line in "List" table
			And I move to the next attribute
			And I click choice button of "Plugins" attribute in "ExternalDataProcess" table
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'                |
				| 'ExternalInputAddress' |
			And I select current line in "List" table
			And I finish line editing in "ExternalDataProcess" table
		* Adding Plugin sessing to specify the address for Turkey
			And in the table "ExternalDataProcess" I click the button named "ExternalDataProcessAdd"
			And I click choice button of "Country" attribute in "ExternalDataProcess" table
			And I go to line in "List" table
				| Description |
				| Turkey     |
			And I select current line in "List" table
			And I move to the next attribute
			And I click choice button of "Plugins" attribute in "ExternalDataProcess" table
			Then "Plugins" window is opened
			And I go to line in "List" table
				| 'Description'                |
				| 'ExternalInputAddress' |
			And I select current line in "List" table
			And I finish line editing in "ExternalDataProcess" table
			And I click "Save and close" button
			And Delay 5
		* Specify an arbitrary structure at Location address (Partner)
			And I enter a Unique ID String field type value for the partner addresses
		* Check for created
			And "List" table contains lines
				| 'Description'                     |
				| 'Location address (Partner)'    |
				| 'Billing address (Company)'    |
				| 'Registered address  (Company)' |


Scenario: _010011 adding gps to a Contact info type
	* Add Plugin sessing for GPS
		* Opening a form to add Plugin sessing
			Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
			And I click the button named "FormCreate"
		* Adding Plugin sessing 
			And I select external file "#workingDir#\DataProcessor\Coordinates.epf"
			And I click the button named "FormAddExtDataProc"
			And I input "" text in "Path to plugin for test" field
			And I input "ExternalCoordinates" text in "Name" field
			And I click Open button of the field named "Description_en"
			And I input "ExternalCoordinates" text in the field named "Description_en"
			And I input "ExternalCoordinates" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
			And Delay 5
	* Check adding Plugin sessing
	* Opening the form for filling in Contact info type
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.IDInfoTypes"
	* Adding Contact info gps coordinates for partners in Ukraine
		And I click the button named "FormCreate"
		Then "Contact info type (create)" window is opened
		And I click Select button of "Value type" field
		Then "Edit data type" window is opened
		And I go to line in "" table
			| ''       |
			| 'String' |
		And I select current line in "" table
		And I click "OK" button
		And I input "GPS" text in "Unique ID" field
		And I change checkbox "Show on form"
		And I set checkbox named "ReadOnly"
		And I click Open button of the field named "Description_en"
		And I input "GPS Ukraine" text in the field named "Description_en"
		And I input "GPS Ukraine TR" text in the field named "Description_tr"
		And I click "Ok" button
		And in the table "ExternalDataProcess" I click the button named "ExternalDataProcessAdd"
		And I activate "Plugins" field in "ExternalDataProcess" table
		And I click choice button of "Plugins" attribute in "ExternalDataProcess" table
		And I go to line in "List" table
			| 'Description'                 |
			| 'ExternalCoordinates'  |
		And I select current line in "List" table
		And I select current line in "ExternalDataProcess" table
		And I click choice button of "Country" attribute in "ExternalDataProcess" table
		And I go to line in "List" table
			| Description |
			| Ukraine   |
		And I select current line in "List" table
		And I finish line editing in "ExternalDataProcess" table
	* Adding address structure by gps for Ukraine
		And in the table "ExternalDataProcess" I click "Set settings" button
		Then "Coordinates" window is opened
		* Specify the address that will be refilled when selecting gps
			And I click Select button of "Structured address" field
			Then "Contact info types" window is opened
			And I go to line in "List" table
				| Description       |
				| Google Addreses |
			And I select current line in "List" table
		And in the table "Levels" I click "Get all levels" button
		And I input "46,477400" text in "Lat" field
		And I input "30,732872" text in "Lng" field
		And I go to line in "AllLevels" table
			| Level     |
			| political |
		And I go to line in "AllLevels" table
			| Level   |
			| country |
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And I go to line in "AllLevels" table
			| Level    |
			| locality |
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And I go to line in "AllLevels" table
			| Level |
			| route |
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveDown"
		And I go to line in "AllLevels" table
			| Level     |
			| political |
		And I delete a line in "AllLevels" table
		And I delete a line in "AllLevels" table
		And I delete a line in "AllLevels" table
		And I delete a line in "AllLevels" table
		And I click "Ok" button
		Then "Coordinates" window is opened
		And I click "Ok" button
	* Filling in settings for gps coordinates
		And I move to "Related values" tab
		And in the table "RelatedValues" I click the button named "RelatedValuesAdd"
		And I click choice button of "Contact info type" attribute in "RelatedValues" table
		Then "Contact info types" window is opened
		And I go to line in "List" table
			| 'Description'                  |
			| 'Location address (Partner)' |
		And I select current line in "List" table
		And Delay 1
		And I finish line editing in "RelatedValues" table
		And I click "Save and close" button
		And Delay 5
		And I enter the UniqueID String field value type
	* Check for created items
		And "List" table contains lines
		| 'Description'                     |
		| 'GPS Ukraine'    |
	* Adding Contact info gps coordinates for partners in Turkey
		And I click the button named "FormCreate"
		And I click Select button of "Value type" field
		And I go to line in "" table
			| ''       |
			| 'String' |
		And I select current line in "" table
		And I click "OK" button
		And I input "GPSTurkey" text in "Unique ID" field
		And I change checkbox "Show on form"
		And I set checkbox named "ReadOnly"
		And I click Open button of the field named "Description_en"
		And I input "GPS Turkey" text in the field named "Description_en"
		And I input "GPS Turkey TR" text in the field named "Description_tr"
		And I click "Ok" button
		And in the table "ExternalDataProcess" I click the button named "ExternalDataProcessAdd"
		And I activate "Plugins" field in "ExternalDataProcess" table
		And I click choice button of "Plugins" attribute in "ExternalDataProcess" table
		And I go to line in "List" table
			| 'Description'                 |
			| 'ExternalCoordinates'  |
		And I select current line in "List" table
		And I select current line in "ExternalDataProcess" table
		And I click choice button of "Country" attribute in "ExternalDataProcess" table
		And I go to line in "List" table
			| Description |
			| Turkey   |
		And I select current line in "List" table
		And I finish line editing in "ExternalDataProcess" table
	* Adding gps address structure for Turkey
		And in the table "ExternalDataProcess" I click "Set settings" button
		* Specify the address that will be refilled when selecting gps
			And I click Select button of "Structured address" field
			Then "Contact info types" window is opened
			And I go to line in "List" table
				| Description       |
				| Google Addreses |
			And I select current line in "List" table
		And in the table "Levels" I click "Get all levels" button
		And I input "40,983577" text in "Lat" field
		And I input "29,078498" text in "Lng" field
		And I go to line in "AllLevels" table
		| Level   | Value  |
		| country | Turkey |
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And I go to line in "AllLevels" table
			| Level                       |
			| administrative_area_level_1 |
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And I go to line in "AllLevels" table
			| Level                       |
			| administrative_area_level_2 |
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And I go to line in "AllLevels" table
			| Level | Value            |
			| route | Hafız İmam Sokak |
		And in the table "AllLevels" I click the button named "AllLevelsMoveUp"
		And I go to line in "AllLevels" table
			| Level                       |
			| administrative_area_level_4 |
		And I delete a line in "AllLevels" table
		And I delete a line in "AllLevels" table
		And I delete a line in "AllLevels" table
		And I click "Ok" button
		And I click "Ok" button
	* Filling in gps coordinates settings
		And I move to "Related values" tab
		And in the table "RelatedValues" I click the button named "RelatedValuesAdd"
		And I click choice button of "Contact info type" attribute in "RelatedValues" table
		Then "Contact info types" window is opened
		And I go to line in "List" table
			| 'Description'                  |
			| 'Location address (Partner)' |
		And I select current line in "List" table
		And Delay 1
		And I finish line editing in "RelatedValues" table
		And I click "Save and close" button
		And Delay 5
		And I enter a Unique ID String field type value for the GPS Turkey String
	* Check for created items
		And "List" table contains lines
		| 'Description'                     |
		| 'GPS Turkey'    |



Scenario: _010012 adding additional details for partners "Division"
	* Preparation
		When Create catalog Partners objects (Kalipso)
		When Create catalog Partners objects (Ferron BP)
	* Opening a form for adding additional attributes for partners
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data item name |
			| Catalog_Partners          |
		And I select current line in "List" table
	* Filling in the name of the settings for adding additional details for partners
		And I click Open button of the field named "Description_en"
		And I input "Partners" text in the field named "Description_en"
		And I input "Partners TR" text in the field named "Description_tr"
		And I click "Ok" button
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
	* Adding additional attribute Division
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Division" text in the field named "Description_en"
		And I input "Division TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 5
		And I click the button named "FormChoose"
	* Create an UI group for additional attribute
		And I activate "UI group" field in "Attributes" table
		And I click choice button of "UI group" attribute in "Attributes" table
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Main information" text in the field named "Description_en"
		And I input "Main information TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I change "Form position" radio button value to "Left"
		And I click "Save and close" button
		And Delay 5
		And I click the button named "FormChoose"
		And I finish line editing in "Attributes" table
		And I click "Save and close" button
		And Delay 5
		And I close all client application windows
	* Filling in the created additional attribute for partners
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I go to line in "List" table
			| Description |
			| Ferron BP   |
		And I select current line in "List" table
		And I click Select button of "Division" field
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Region Turkey" text in the field named "Description_en"
		And I input "Turkey TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 5
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Region Ukraine" text in the field named "Description_en"
		And I input "Ukraine TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 5
		And I go to line in "List" table
			| Description |
			| Region Ukraine     |
		And I click the button named "FormChoose"
		And I click "Save and close" button
		And Delay 2
		And I go to line in "List" table
			| Description |
			| Kalipso   |
		And I select current line in "List" table
		And I click Select button of "Division" field
		And I go to line in "List" table
			| Description |
			| Region Turkey     |
		And I click the button named "FormChoose"
		And I click "Save and close" button



Scenario: _010013 settings for displaying contact information in Stores, Partners, Company
	And I close all client application windows
	* Complete settings to display contact information for Partners
		Given I open hyperlink "e1cib/list/Catalog.IDInfoSets"
		And I go to line in "List" table
		| 'Predefined data item name' |
		| 'Catalog_Partners'          |
		And I select current line in "List" table
		Then the form attribute named "PredefinedDataName" became equal to "Catalog_Partners"
		And I click Open button of the field named "Description_en"
		And I input "Partners" text in the field named "Description_en"
		And I input "Partners TR" text in the field named "Description_tr"
		And I click "OK" button
		And in the table "IDInfoTypes" I click the button named "IDInfoTypesAdd"
		And I click choice button of "Contact info type" attribute in "IDInfoTypes" table
		And I go to line in "List" table
			| Description                  |
			| Location address (Partner) |
		And I select current line in "List" table
		And I finish line editing in "IDInfoTypes" table
		And in the table "IDInfoTypes" I click the button named "IDInfoTypesAdd"
		And I click choice button of "Contact info type" attribute in "IDInfoTypes" table
		And I go to line in "List" table
			| Description                  |
			| Google Addreses |
		And I select current line in "List" table
		And I finish line editing in "IDInfoTypes" table
		And in the table "IDInfoTypes" I click the button named "IDInfoTypesAdd"
		And I click choice button of "Contact info type" attribute in "IDInfoTypes" table
		And I go to line in "List" table
			| Description   |
			| GPS Ukraine |
		And I select current line in "List" table
		And I finish line editing in "IDInfoTypes" table
		And in the table "IDInfoTypes" I click "Set condition" button
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And in the table "SettingsFilter" I click the button named "SettingsFilterAddFilterItem"
		And I click choice button of the attribute named "SettingsFilterLeftValue" in "SettingsFilter" table
		And I expand a line in "Source" table
			| Available fields |
			| Reference        |
		And I go to line in "Source" table
			| Available fields |
			| Division  |
		And I select current line in "Source" table
		And I click choice button of the attribute named "SettingsFilterRightValue" in "SettingsFilter" table	
		And I go to line in "List" table
			| 'Additional attribute' | 'Description' |
			| 'Division' 	| 'Region Ukraine'      |
		And I select current line in "List" table
		And I finish line editing in "SettingsFilter" table
		And I click "Ok" button
		And in the table "IDInfoTypes" I click "Add" button
		And I click choice button of "Contact info type" attribute in "IDInfoTypes" table
		Then "Contact info types" window is opened
		And I go to line in "List" table
			| Description  |
			| GPS Turkey |
		And I select current line in "List" table
		And I finish line editing in "IDInfoTypes" table
		And in the table "IDInfoTypes" I click "Set condition" button
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And in the table "SettingsFilter" I click the button named "SettingsFilterAddFilterItem"
		And I click choice button of the attribute named "SettingsFilterLeftValue" in "SettingsFilter" table
		Then "Select field" window is opened
		And I expand a line in "Source" table
			| Available fields |
			| Reference        |
		And I go to line in "Source" table
			| Available fields |
			| Division  |
		And I select current line in "Source" table
		And I click choice button of the attribute named "SettingsFilterRightValue" in "SettingsFilter" table	
		And I go to line in "List" table
			| 'Additional attribute' | 'Description' |
			| 'Division' 	| 'Region Turkey'      |
		And I select current line in "List" table
		And I finish line editing in "SettingsFilter" table
		And I click "Ok" button
		And in the table "IDInfoTypes" I click "Add" button
		And I click choice button of "Contact info type" attribute in "IDInfoTypes" table
		And I go to line in "List" table
			| Description     |
			| Partner phone |
		And I select current line in "List" table
		And I finish line editing in "IDInfoTypes" table
		And I click "Save and close" button
		And I wait "Partners (Contact info sets) *" window closing in 20 seconds
	* Fill in the settings for displaying Company contact information
		And I go to line in "List" table
			| 'Predefined data item name' |
			| 'Catalog_Companies'          |
		And I select current line in "List" table
		Then the form attribute named "PredefinedDataName" became equal to "Catalog_Companies"
		And I click Open button of the field named "Description_en"
		And I input "Company" text in the field named "Description_en"
		And I input "Company TR" text in the field named "Description_tr"
		And I click "OK" button
		And in the table "IDInfoTypes" I click the button named "IDInfoTypesAdd"
		And I click choice button of "Contact info type" attribute in "IDInfoTypes" table
		Then "Contact info types" window is opened
		And I select current line in "List" table
		And I finish line editing in "IDInfoTypes" table
		And in the table "IDInfoTypes" I click the button named "IDInfoTypesAdd"
		And I click choice button of "Contact info type" attribute in "IDInfoTypes" table
		Then "Contact info types" window is opened
		And I go to line in "List" table
			| 'Description'                  |
			| 'Billing address (Company)' |
		And I select current line in "List" table
		And I finish line editing in "IDInfoTypes" table
		And in the table "IDInfoTypes" I click the button named "IDInfoTypesAdd"
		And I click choice button of "Contact info type" attribute in "IDInfoTypes" table
		Then "Contact info types" window is opened
		And I go to line in "List" table
			| 'Description'                     |
			| 'Registered address  (Company)' |
		And I select current line in "List" table
		And I finish line editing in "IDInfoTypes" table
		And I click "Save and close" button
		And Delay 5
	* Fill in the settings for displaying Store contact information
		And I go to line in "List" table
			| 'Predefined data item name' |
			| 'Catalog_Stores'          |
		And I select current line in "List" table
		Then the form attribute named "PredefinedDataName" became equal to "Catalog_Stores"
		And I click Open button of the field named "Description_en"
		And I input "Stores" text in the field named "Description_en"
		And I input "Stores TR" text in the field named "Description_tr"
		And I click "OK" button
		And in the table "IDInfoTypes" I click the button named "IDInfoTypesAdd"
		And I click choice button of "Contact info type" attribute in "IDInfoTypes" table
		Then "Contact info types" window is opened
		And I go to line in "List" table
			| 'Description'                  |
			| 'Location address (Partner)' |
		And I select current line in "List" table
		And I finish line editing in "IDInfoTypes" table
		And I click "Save and close" button
		And I wait "en description is empty (Contact info sets) *" window closing in 20 seconds
		

Scenario: _010014 filling phones for partners
	* Preparation
		When Create catalog Partners objects (Ferron BP)
	* Opening a partner catalog form
		Given I open hyperlink "e1cib/list/Catalog.Partners"
	* Filling a phone for partner Ferron BP
		And I click the button named "FormList"
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP' |
		And I select current line in "List" table
		And I move to "Contact information" tab
		And I click Open button of "Partner phone" field
		And I input "+305500077043" text in "Phone" field
		And I click "Ok" button
		And I click "Save and close" button
	
	


Scenario: _010015 partner address filling
	* Preparation
		When Create catalog Partners objects (Kalipso)
	* Opening a partner catalog form
		Given I open hyperlink "e1cib/list/Catalog.Partners"
	* Filling address partner Kalipso
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso' |
		And I select current line in "List" table
		And I move to "Contact information" tab
	* Check the display of contact information
		And the field named "_Adr_1" exists on the form
		And the field named "_Adr_10" exists on the form
		And the field named "_GPSTurkey" exists on the form
		And the field named "_Phone_2" exists on the form
	* Address Filling
		And I input "Park sok, 15, Yenikapi, Antalya, Turkey" text in "Location address (Partner)" field
	* Check address display
		Then the form attribute named "_Adr_1" became equal to "Park sok, 15, Yenikapi, Antalya, Turkey"
		And I click "Save and close" button
		And Delay 5
	


Scenario: _010016 address structure input
	* Preparation
		When Create catalog Companies objects (partners company Almo, Sovelie)
	* Opening a company catalog form
		Given I open hyperlink "e1cib/list/Catalog.Companies"
	* Filling in address structure for companies
		And I go to line in "List" table
			| Description       |
			| Company Almo |
		And I select current line in "List" table
		And I move to "Contact information" tab
		And I click Open button of "Billing address (Company)" field
		And I go to line in "CountryTable" table
		| Country |
		| Ukraine |
		And I select current line in "CountryTable" table
		And I input "Country" text in "InputLevel_1" field
		And I click the button named "ButtonAdd_2"
		And I input "Region" text in "InputLevel_2" field
		And I click the button named "ButtonAdd_3"
		And I input "City" text in "InputLevel_3" field
		And I click the button named "ButtonAdd_4"
		And I input "Street" text in "InputLevel_4" field
		And I input "Ukraine" text in "InputValue_1" field
		And I input "Odesska oblast" text in "InputValue_2" field
		And I input "Odessa" text in "InputValue_3" field
		And I input "Kanatna" text in "InputValue_4" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 5
	* Check to save the address structure for Billing address (Company)
		And I go to line in "List" table
		| Description     |
		| Company Sovelie |
		And I select current line in "List" table
		And I move to "Contact information" tab
		And I click Open button of "Billing address (Company)" field
		And I go to line in "CountryTable" table
		| Country |
		| Ukraine |
		And I select current line in "CountryTable" table
		And I select from "InputLevel_1" drop-down list by "C" string
		And I click the button named "ButtonAdd_2"
		And I click the button named "ButtonAdd_3"
		And I click the button named "ButtonAdd_4"
		And I input "Bunina" text in "InputValue_4" field
		Then the form attribute named "InputLevel_1" became equal to "Country"
		Then the form attribute named "InputValue_1" became equal to "Ukraine"
		Then the form attribute named "InputLevel_2" became equal to "Region"
		Then the form attribute named "InputValue_2" became equal to "Odesska oblast"
		Then the form attribute named "InputLevel_3" became equal to "City"
		Then the form attribute named "InputValue_3" became equal to "Odessa"
		Then the form attribute named "InputLevel_4" became equal to "Street"
		Then the form attribute named "InputValue_4" became equal to "Bunina"
		And I click "Ok" button
		And I click "Save and close" button


Scenario: _010017 gps coordinates on the map for clients from different countries and filling in the address from Google map
	* Opening the catalog Partners
		Given I open hyperlink "e1cib/list/Catalog.Partners"
	* Filling in gps coordinates for Ferron BP client by searching for the address on the map (Ukraine)
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP' |
		And I select current line in "List" table
		And I move to "Contact information" tab
		And I input "Odessa, Bunina, 2, №32" text in "Location address (Partner)" field
		And I click "Save" button
		And I click Open button of "GPS Ukraine" field
		And Delay 5
		And I click "Update address by GPS" button
		And Delay 10
		And I click "Ok" button
		And Delay 10
	* Check gps coordinates saved
		Then the form attribute named "_GPS" became equal to "46.48082,30.748159"
		And the field named "_Adr_10" is filled
		And I click "Save and close" button
		And I close all client application windows
	* Filling in gps coordinates for Kalipso client by searching for the address on the map (Turkey)
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso' |
		And I select current line in "List" table
		And I move to "Contact information" tab
		And I click Open button of "GPS Turkey" field
		And I click "Update address by GPS" button
		And Delay 10
		And I click "Ok" button
		And Delay 10
	* Check gps coordinates saved
		And the field named "_GPSTurkey" is filled
		And the field named "_Adr_10" is filled
		And I click "Save and close" button
		And I close all client application windows


Scenario: _010018 command opening contact information in the partner list
	* Open catalog Partners and select partner
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso' |
		And I click "Contact info" button
	* Check the display of contact information
		And "IDInfo" table contains lines
			| 'Type'                       |
			| 'Location address (Partner)' |
			| 'GPS Ukraine'                |
			| 'Partner phone'              |
	And I close all client application windows


Scenario: _010019 check edit contact information from the Edit contact info form
	* Open catalog Partners and select partner
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso' |
		And I click "Contact info" button
	* Edit contact info
		And I input "Odessa, Bunina, 2, №33" text in "Value" field of "IDInfo" table
		And I finish line editing in "IDInfo" table
		And I click "Save and close" button
	* Check saving of changed contact information
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso' |
		And I select current line in "List" table
		And I move to "Contact information" tab
		Then the form attribute named "_Adr_1" became equal to "Odessa, Bunina, 2, №33"
	And I close all client application windows