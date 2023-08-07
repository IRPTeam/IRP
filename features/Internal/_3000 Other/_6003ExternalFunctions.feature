#language: en
@tree
@Positive
@ExternalFunctions


Feature: external functions

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"
Tag = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Tag")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Tag"), "#Tag#")}"
webPort = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("webPort")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("webPort"), "#webPort#")}"
Publication = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Publication")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Publication"), "#Publication#")}"


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _602700 preparation (external function)
	When set True value to the constant
	And I set "True" value to the constant "UseJobQueueForExternalFunctions"
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
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
		When Create catalog Stores objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create catalog IntegrationSettings objects (db connection)
		When Create information register CurrencyRates records
		When Create information register Barcodes records
		When update ItemKeys
		When Create catalog ExternalFunctions objects
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"            |
				| "TaxCalculateVAT_TR"     |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	When Create document PurchaseOrder objects (check movements, GR before PI, not Use receipt sheduling)
	* Add test extension
		Given I open hyperlink "e1cib/list/Catalog.Extensions"
		If "List" table does not contain lines Then
				| "Description"                 |
				| "AdditionalFunctionality"     |
			When add Additional Functionality extension
	And I close all client application windows

Scenario: _602701 check preparation
	When check preparation

Scenario: _602703 check reg exp
	* Open External functions
		Given I open hyperlink "e1cib/list/Catalog.ExternalFunctions"
	* Select function with reg exp
		And I go to line in "List" table
			| 'Description'   | 'Enable'    |
			| 'RegExp'        | 'No'        |
		And I select current line in "List" table
	* Check reg exp	
		And I click the button named "RunRegExp"	
		If "1C:Enterprise" window is opened Then
			And I click "OK" button
		And I move to the next attribute
		Then the form attribute named "RegExpResult" became equal to
			| '\'002236258 AX-MC AKPOS FZS ISK ODE 20220815 KS:81.12TL'    |
			| '[0]	> KS:81.12TL'                                           |
			| '[1]	> 81.12'                                                |
			| ''                                                           |
			| 'Result:'                                                    |
			| '[Value]	> 81,12'                                            |
			| '[Type]	> Number'                                            |


Scenario: _602704 check function date as name
	And I close all client application windows
	* Open External functions
		Given I open hyperlink "e1cib/list/Catalog.ExternalFunctions"
	* Select function
		And I go to line in "List" table
			| 'Description'    | 'Enable'    |
			| 'Date as name'   | 'Yes'       |
		And I select current line in "List" table	
	* Сheck for the current date update
		And I click the button named "Run"
		And I save the value of the field named "Result" as "CurrentDate1"	
		And Delay 5
		And I click the button named "Run"
		And I save the value of the field named "Result" as "CurrentDate2"
		When I Check the steps for Exception
			| "Then '$CurrentDate1$' variable is equal to '$CurrentDate2$'"          |
		And I close current window
		And I click "Refresh" button	
		And "List" table does not contain lines
			| 'Description'    | 'Reference'         |
			| 'Date as name'   | '$CurrentDate1$'    |

# Scenario: _602706 check user message
# 	Then I stop script execution "Skipped"
# 	And I close all client application windows
# 	* Open External functions
# 		Given I open hyperlink "e1cib/list/Catalog.ExternalFunctions"
# 	* Select function
# 		And I go to line in "List" table
# 			| 'Description'    | 'Enable'    |
# 			| 'User message'   | 'Yes'       |
# 		And I select current line in "List" table	
# 	* Сheck for the current date update		
# 		And I click the button named "Run"
# 		Then there are lines in TestClient message log
# 			| 'Some test'    |
		

// Scenario: _602710 sheduller settings (Normal test)
// 	And I close all client application windows
// 	* Open External functions
// 		Given I open hyperlink "e1cib/list/Catalog.ExternalFunctions"
// 	* Select function
// 		And I go to line in "List" table
// 			| 'Description' | 'Enable' | 'Type'    |
// 			| 'Normal test' | 'Yes'    | 'Execute' |
// 		And I select current line in "List" table	
// 	* Sheduller settings
// 		And I set checkbox "Use scheduler"
// 		And I move to "Scheduler" tab
// 		And I click "Edit schedule" button
// 		And I move to "Daily" tab
// 		And I input "10" text in "Repeat after" field
// 		And I click "OK" button
// 		And I click "Save and close" button
// 		And "List" table contains lines
// 			| 'Enable' | 'Safe mode' | 'Use scheduler' | 'Type'    | 'Reference'           | 'Description'    | 'Job add time' | 'Job start time' | 'Job status' | 'Job finish time' |
// 			| 'Yes'    | 'Yes'       | 'Yes'           | 'Execute' | 'Normal test'         | 'Normal test'    | ''             | ''               | ''           | ''                |
// 	* Check
// 		And Delay 30
// 		And I click "Refresh" button
// 		And "List" table contains lines
// 			| 'Enable' | 'Safe mode' | 'Use scheduler' | 'Type'    | 'Reference'   | 'Description' | 'Job add time' | 'Job start time' | 'Job status' | 'Job finish time' |
// 			| 'Yes'    | 'Yes'       | 'Yes'           | 'Execute' | 'Normal test' | 'Normal test' | '*'            | ''               | 'Wait'       | ''                |
// 		And Delay 50
// 		And I go to line in "List" table
// 			| 'Description' | 'Enable' | 'Type'    |
// 			| 'Normal test' | 'Yes'    | 'Execute' |
// 		And I select current line in "List" table
// 		And In this window I click command interface button "Job queue"
// 		And "List" table contains lines
// 			| 'Period' | 'Job'         | 'Start' | 'Status'    | 'User messages' | 'Description' | 'Finish' | 'Difficult level' |
// 			| '*'      | 'Normal test' | '*'     | 'Completed' | ''              | ''            | '*'      | ''                |
// 			| '*'      | 'Normal test' | ''      | 'Wait'      | ''              | ''            | ''       | ''                |
// 		And I close all client application windows


// 		Scenario: _602780 test data base connection
// 			Then I stop script execution "Skipped"
// 			And I close all client application windows
// 			* Сondition check
// 				If "$Publication$" variable is equal to "false" Then
// 					Then I stop script execution "Skipped"
// 			* Select integration settings
// 				Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
// 				And I go to line in "List" table
// 					| 'Description'    |
// 					| 'Test'           |
// 				And I select current line in "List" table
// 			* Test connection
// 				And in the table "ConnectionSetting" I click "Test" button
// 				Then I wait that in user messages the "Status code: 200" substring will appear in "30" seconds
// 				And I close all client application windows
		
				
		
		
				

		
				
			
