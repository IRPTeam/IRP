#language: en
@tree
@Positive
@ExtensionReportForm

Feature: Attach Files Control

As a Developer
I want to create an image subsystem


Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _4001701 preparation (Attach Files Control)
	When set True value to the constant
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
		When Create catalog Companies objects (Main company)
		When Create catalog Companies objects (own Second company)
		When Create catalog BusinessUnits objects
		When Create catalog Stores objects
		When Create catalog Users objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog InterfaceGroups objects
		When Create catalog Currencies objects
		When Create catalog IntegrationSettings objects (Attach File Control)
		When Create catalog AttachedDocumentSettings objects
		When Create catalog FileStorageVolumes objects (Attach File Control)
		When Create catalog CashAccounts objects
		When Create catalog PaymentTypes objects
		When Create catalog Workstations objects
		When Create chart of characteristic types AddAttributeAndProperty objects (Attach File Control)
		When Create catalog BusinessUnits objects
		When Create document PurchaseOrder objects (PO Attach File Control)
		When Create document RetailReturnReceipt objects (RRR Attach File Control)
		When Create catalog AccessGroups and AccessProfiles objects (audit lock)
	* Access group
		Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
		And I go to line in "List" table
			| 'Description'           |
			| 'Audit lock control'    |
		And I select current line in "List" table
		And I click "Save and close" button
	* Default picture storage
		And In the command interface I select "Settings" "Edit constants"
		And I click Select button of "Default files storage volume" field
		And I go to line in "List" table
			| 'Description'              |
			| 'DEFAULT DOCUMENT STORAGE' |
		And I select current line in "List" table
		And I click "Save and close" button
		And Delay 3
	* User settings
		Given I open hyperlink "e1cib/list/Catalog.Users"
		* CI
			And I go to line in "List" table
				| 'Login' |
				| 'CI'    |
			And I click "Settings" button
			And I go to line in "MetadataTree" table
				| "Group name"              | "Use" |
				| "Enable - Change filters" | "No"  |
			And I activate "Value" field in "MetadataTree" table
			And I select current line in "MetadataTree" table
			And I select "Yes" exact value from "Value" drop-down list in "MetadataTree" table
			And I finish line editing in "MetadataTree" table
			And I go to line in "MetadataTree" table
				| "Group name"          | "Use" |
				| "Enable - Check-mode" | "No"  |
			And I select current line in "MetadataTree" table
			And I select current line in "MetadataTree" table
			And I select "Yes" exact value from "Value" drop-down list in "MetadataTree" table
			And I finish line editing in "MetadataTree" table
			And I go to line in "MetadataTree" table
				| "Group name" | "Use" |
				| "Company"    | "No"  |
			And I select current line in "MetadataTree" table
			And I select "Main Company" from "Value" drop-down list by string in "MetadataTree" table
			And I finish line editing in "MetadataTree" table
			And I click "Ok" button
		*ABrown
			And I go to line in "List" table
				| 'Description'               |
				| 'Arina Brown (Financier 3)' |
			And I click "Settings" button
			And I go to line in "MetadataTree" table
				| "Group name"              | "Use" |
				| "Enable - Change filters" | "No"  |
			And I activate "Value" field in "MetadataTree" table
			And I select current line in "MetadataTree" table
			And I select "Yes" exact value from "Value" drop-down list in "MetadataTree" table
			And I finish line editing in "MetadataTree" table
			And I go to line in "MetadataTree" table
				| "Group name"          | "Use" |
				| "Enable - Check-mode" | "No"  |
			And I select current line in "MetadataTree" table
			And I select current line in "MetadataTree" table
			And I select "Yes" exact value from "Value" drop-down list in "MetadataTree" table
			And I finish line editing in "MetadataTree" table
			And I go to line in "MetadataTree" table
				| "Group name" | "Use" |
				| "Company"    | "No"  |
			And I select current line in "MetadataTree" table
			And I select "Main Company" from "Value" drop-down list by string in "MetadataTree" table
			And I finish line editing in "MetadataTree" table
			And I click "Ok" button
	And I close TestClient session
	Given I open new TestClient session or connect the existing one	
		
Scenario: _4001702 check preparation
	When check preparation 


Scenario: _4001705 setting for Attached document settings
	And I close all client application windows
	* Create new Attached document settings for SI
		Given I open hyperlink "e1cib/list/Catalog.AttachedDocumentSettings"		
		And I click the button named "FormCreate"
		And I click Choice button of the field named "Description"
		And I go to line in "DocumentsNames" table
			| "Name"         | "Synonym"       |
			| "SalesInvoice" | "Sales invoice" |
		And I select current line in "DocumentsNames" table		
		And I click Select button of "File storage volume" field
		And I go to line in "List" table
			| 'Description'              |
			| 'DEFAULT DOCUMENT STORAGE' |
		And I select current line in "List" table
		And in the table "FileSettings" I click the button named "FileSettingsAdd"
		And I select current line in "FileSettings" table
		And I click choice button of "File presentation" attribute in "FileSettings" table
		And I go to line in "List" table
			| 'Description' |
			| 'Type'        |
		And I select current line in "List" table
		And I set "Required" checkbox in "FileSettings" table
		And I activate "Naming format" field in "FileSettings" table
		And I input "%DocDate_Sales_Invoice_%DocNumber" text in "Naming format" field of "FileSettings" table
		And I finish line editing in "FileSettings" table
		And I activate "File extension" field in "FileSettings" table
		And I select current line in "FileSettings" table
		And I input "*.pdf, *.jpg" text in "File extension" field of "FileSettings" table
		And I finish line editing in "FileSettings" table
		And I click "Save" button
	* Check
		And "FileSettings" table became equal
			| 'Required' | 'File presentation' | 'Naming format'                     | 'File extension' |
			| 'Yes'      | 'Type'              | '%DocDate_Sales_Invoice_%DocNumber' | '*.pdf, *.jpg'   |
		And I click "Save and close" button
		And "List" table contains lines
			| 'Description'   |
			| 'SalesInvoice'  |	
	* Change Attached document setting
		And I go to line in "List" table
			| 'Description'         |
			| 'RetailReturnReceipt' |
		And I select current line in "List" table
		And I go to line in "FileSettings" table
			| "File presentation" |
			| "Return receipt"    |
		And I select current line in "FileSettings" table
		And I select external file "$Path$/features/Internal/_4000 TestWithExtension/testjpg1.jpg"
		And I click choice button of "File template" attribute in "FileSettings" table
		And "FileSettings" table contains lines
			| 'File template' |
			| 'testjpg1.jpg'  |
		And I click "Save and close" button
		
						
Scenario: _4001705 check the display of the document template in the AttachedFilesToDocumentsControl			
	And I open hyperlink "e1cib/app/DataProcessor.AttachedFilesToDocumentsControl"
	* Check documents display
		And I go to line in "DocumentList" table
			| "Doc type"              | "Doc date"   | "Doc number" | "Branch" |
			| "Retail return receipt" | "08.05.2024" | "223"        | ""       |
	* Check settings 
		And "DocumentsAttachedFiles" table contains lines
			| 'File type'       | 'Required' |
			| 'Return request'  | 'Yes'      |
			| 'Return receipt'  | 'No'       |
	* Check template
		And I go to line in "DocumentsAttachedFiles" table
			| 'File type'       | 'Required' |
			| 'Return receipt'  | 'No'       |
		And I activate "File" field in "CurrentFilesTable" table
		And I select current line in "DocumentsAttachedFiles" table
		Then the field named "Picture" is filled
		And I close current window
		And I go to line in "DocumentsAttachedFiles" table
			| 'File type'       | 'Required' |
			| 'Return request'  | 'Yes'      |
		And I activate "File" field in "CurrentFilesTable" table
		And I select current line in "DocumentsAttachedFiles" table
		When I Check the steps for Exception
			|'Then the field named "Picture" is filled'|		
		And I close current window		


				
Scenario: _4001711 check mandatory documents for RRR (jpg)
	And I close all client application windows
	* Open AttachedFilesToDocumentsControl
		And I open hyperlink "e1cib/app/DataProcessor.AttachedFilesToDocumentsControl"
		And I click Clear button of the field named "Branch"
		And I click Choice button of the field named "Period"
		And I click "Clear period" button			
		And I input "01.01.2023" text in the field named "DateBegin"
		And I input "09.05.2024" text in the field named "DateEnd"
		And I click the button named "Select"	
	* Add file
		And I go to line in "DocumentList" table
			| "Doc type"       | "Doc date"   | "Doc number" | "Branch"                  |
			| "Purchase order" | "09.05.2023" | "222"        | "Distribution department" |
		And I go to line in "DocumentList" table
			| "Doc type"              | "Doc date"   | "Doc number" | "Branch" |
			| "Retail return receipt" | "08.05.2024" | "223"        | ""       |
		And I go to line in "DocumentsAttachedFiles" table
			| 'File type'       | 'Required' |
			| 'Return request'  | 'Yes'      |	
		And I select external file "$Path$/features/Internal/_4000 TestWithExtension/testjpg3.jpg"
		And Delay 10
		And I click the button named "AddNewDocument"
		And "CurrentFilesTable" table contains lines:
			| 'File'                         |
			| '_20240508_Return_request_223' |

Scenario: _4001712 check attached file in document	
	And I close all client application windows
	And I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
	Then "Retail return receipts" window is opened
	And I go to line in "List" table
		| 'Number' | 'Partner'   |
		| '223'    | 'Ferron BP' |
	And I select current line in "List" table
	And I click "Attached files" button
	Then "Attach file" window is opened
	And I activate "File" field in "FileList" table
	And "FileList" table contains lines:
		| 'File'                         |
		| '_20240508_Return_request_223' |
	
Scenario: _4001713 check optional documents for RRR (pdf)
	And I close all client application windows
	* Open AttachedFilesToDocumentsControl
		And I open hyperlink "e1cib/app/DataProcessor.AttachedFilesToDocumentsControl"
		And I click Clear button of the field named "Branch"
		And I click Choice button of the field named "Period"
		And I click "Clear period" button			
		And I input "01.01.2023" text in the field named "DateBegin"
		And I input "08.05.2024" text in the field named "DateEnd"
		And I click the button named "Select"	
	* Add file
		And I go to line in "DocumentList" table
			| "Doc type"       | "Doc date"   | "Doc number" | "Branch"                  |
			| "Purchase order" | "09.05.2023" | "222"        | "Distribution department" |
		And I go to line in "DocumentList" table
			| "Doc type"              | "Doc date"   | "Doc number" | "Branch" |
			| "Retail return receipt" | "08.05.2024" | "223"        | ""       |
		And I go to line in "DocumentsAttachedFiles" table
			| 'File type'          | 'Required' |
			| 'Return receipt'     | 'No'       |
		And I select external file "$Path$/features/Internal/_4000 TestWithExtension/Test pdf 1 page.pdf"
		And Delay 10
		And I click the button named "AddNewDocument"
		And "CurrentFilesTable" table contains lines:
			| 'File'                        |
			| '20240508_Return_Receipt_223' |
	* Open pdf file
		And I go to line in "CurrentFilesTable" table
			| 'File'                        | 'File presentation' |
			| '20240508_Return_Receipt_223' | 'Return receipt'    |
		And I select current line in "CurrentFilesTable" table
		Then "20240508_Return_Receipt_223" window is opened
	And I close all client application windows
									
		
Scenario: _4001715 check Date, Company and Branch filters
	And I close all client application windows
	* Open AttachedFilesToDocumentsControl
		And I open hyperlink "e1cib/app/DataProcessor.AttachedFilesToDocumentsControl"
		And I click Clear button of the field named "Branch"
		And I click Choice button of the field named "Period"
		And I click "Clear period" button			
		And I input "01.01.2023" text in the field named "DateBegin"
		And I input "08.05.2024" text in the field named "DateEnd"
		And I click the button named "Select"	
	* Add filters for Period, Company and Business units
		And I click Choice button of the field named "Period"
		And I click "Clear period" button
		And I input "01.01.2023" text in the field named "DateBegin"
		And I input "31.12.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I click "Select" button
		And I click Choice button of the field named "Branch"
		Then "Value list" window is opened
		And I click the button named "Add"
		And I click choice button of the attribute named "Value" in "ValueList" table
		Then "Business units" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Front office'   |
		And I click "Select" button
		And I click the button named "OK"
		And "DocumentList" table became equal
			| "Doc type"       | "Doc date"   | "Doc number" | "Branch"       |
			| "Purchase order" | "09.05.2023" | "221"        | "Front office" |
	* Change Business units and check filter
		And I click Choice button of the field named "Branch"
		And I select current line in "ValueList" table
		And I click choice button of the attribute named "Value" in "ValueList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And I finish line editing in "ValueList" table
		And I click the button named "OK"
		And "DocumentList" table became equal
			| "Doc type"       | "Doc date"   | "Doc number" | "Branch"                  |
			| "Purchase order" | "09.05.2023" | "222"        | "Distribution department" |
			| "Purchase order" | "09.05.2023" | "224"        | "Distribution department" |
	* Change company and check filter
		And I select from the drop-down list named "Company" by "Second Company" string
		And in the table "DocumentList" I click "Fill documents" button
		Then the number of "DocumentList" table lines is "равно" "0"
	* Change filters		
		And I select from the drop-down list named "Company" by "Main Company" string
		And I click Clear button of the field named "Branch"			
		And I click Choice button of the field named "Period"
		And I click "Clear period" button			
		And I input "01.01.2023" text in the field named "DateBegin"
		And I input "08.05.2024" text in the field named "DateEnd"
		And I click the button named "Select"	
		And "DocumentList" table became equal
			| "Doc type"              | "Doc date"   | "Doc number" | "Branch"                  |
			| "Retail return receipt" | "08.05.2024" | "223"        | ""                        |
			| "Purchase order"        | "09.05.2023" | "221"        | "Front office"            |
			| "Purchase order"        | "09.05.2023" | "222"        | "Distribution department" |
			| "Purchase order"        | "09.05.2023" | "223"        | ""                        |
			| "Purchase order"        | "09.05.2023" | "224"        | "Distribution department" |
		And I close all client application windows
		

Scenario: _4001720 check audit lock from AttachedFilesToDocumentsControl data proc
	And I close all client application windows
	And I connect "Test" TestClient using "ABrown" login and "" password
	* Open AttachedFilesToDocumentsControl
		And I open hyperlink "e1cib/app/DataProcessor.AttachedFilesToDocumentsControl"
		And I click Clear button of the field named "Branch"
		And I click Choice button of the field named "Period"
		And I click "Clear period" button			
		And I input "01.01.2023" text in the field named "DateBegin"
		And I input "08.05.2024" text in the field named "DateEnd"
		And I click the button named "Select"	
	* Check mode
		And I set checkbox "Check mode"
		And I go to line in "DocumentList" table
			| "Doc type"              | "Doc date"   | "Doc number" | "Branch"                  |
			| "Retail return receipt" | "08.05.2024" | "223"        | ""                        |
		And in the table "DocumentList" I click "Lock selected" button
		And I go to line in "DocumentList" table
			| "Doc type"       | "Doc date"   | "Doc number" | "Branch"          |
			| "Purchase order" | "09.05.2023" | "221"        | "Front office TR" |
		And in the table "DocumentList" I click "Lock selected" button
	* Check
		And in the table "DocumentList" I click "Only unlocked" button
		And "DocumentList" table does not contain lines
			| "Doc type"              | "Doc date"   | "Doc number" | "Branch"          |
			| "Retail return receipt" | "08.05.2024" | "223"        | ""                |
			| "Purchase order"        | "09.05.2023" | "221"        | "Front office TR" |
		And in the table "DocumentList" I click "Only unlocked" button
	* Try unlock without permission
		And I go to line in "DocumentList" table
			| "Doc type"              | "Doc date"   | "Doc number" | "Branch"       |
			| "Retail return receipt" | "08.05.2024" | "223"        | ""             |
		And in the table "DocumentList" I click "Unlock selected" button
		Then there are lines in TestClient message log
			|'Access is denied'|
	And I close all client application windows
	

Scenario: _4001720 check audit unlock from AttachedFilesToDocumentsControl data proc
	And I close all client application windows
	And I connect "Этот клиент" TestClient using "CI" login and "CI" password
	* Preparation
		Given I open hyperlink "e1cib/data/Catalog.AccessGroups?ref=b8538749ae346f3011ef86dac21b0638"
		And in the table "Profiles" I click "Add" button
		And I select "Audit unlock" from "Profile" drop-down list by string in "Profiles" table
		And I finish line editing in "Profiles" table
		And I click "Save and close" button
		And I close "Test" TestClient
		And I connect "Test" TestClient using "ABrown" login and "" password
	* Open AttachedFilesToDocumentsControl
		And I open hyperlink "e1cib/app/DataProcessor.AttachedFilesToDocumentsControl"
	* Check mode
		And I click Choice button of the field named "Period"
		And I click "Clear period" button			
		And I input "01.01.2023" text in the field named "DateBegin"
		And I input "08.05.2024" text in the field named "DateEnd"
		And I click the button named "Select"	
		And I set checkbox "Check mode"
		And I go to line in "DocumentList" table
			| "Doc type"              | "Doc date"   | "Doc number" | "Branch"       |
			| "Retail return receipt" | "08.05.2024" | "223"        | ""             |
		And in the table "DocumentList" I click "Unlock selected" button
		And in the table "DocumentList" I click "Only unlocked" button
		And "DocumentList" table contains lines
			| "Doc type"              | "Doc date"   | "Doc number" | "Branch"       |
			| "Retail return receipt" | "08.05.2024" | "223"        | ""             |
	And I close all client application windows
	And I close "Test" TestClient