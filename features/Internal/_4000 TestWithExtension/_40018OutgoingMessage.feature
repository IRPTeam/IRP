#language: en
@tree
@Positive
@ExtensionReportForm

Feature: Outging messages



Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _4001801 preparation (Outging messages)
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
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register Taxes records (VAT)
		When Create catalog Workstations objects
		When Create chart of characteristic types AddAttributeAndProperty objects (Attach File Control)
		When Create catalog BusinessUnits objects
		When Create document SalesInvoice objects
		When Create catalog AccessGroups and AccessProfiles objects (audit lock)
		When Create catalog IntegrationSettings objects (Email)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(15).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Default picture storage
		And In the command interface I select "Settings" "Edit constants"
		And I click Select button of "Default files storage volume" field
		And I go to line in "List" table
			| 'Description'              |
			| 'DEFAULT DOCUMENT STORAGE' |
		And I select current line in "List" table
		And I click "Save and close" button
		And Delay 3
	And I close TestClient session
	Given I open new TestClient session or connect the existing one	

Scenario: _4001802 check preparation
	When check preparation 

Scenario: _4001803 test connection (Email)
	And I close all client application windows
	* Select Email integration settings
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I go to line in "List" table
			| "Description" |
			| "Email"       |
		And I select current line in "List" table
	* Check connection
		And in the table "ConnectionSetting" I click "Test" button
		Then there are lines in TestClient message log
			|'Success'|
	And I close all client application windows

Scenario: _4001804 send email (SI)
	And I close all client application windows
	Try
		And the previous scenario executed successfully
	Except
		Then I stop the execution of scripts for this feature
	* Select SI
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
	* Print
		And I click "Sales invoice" button		
	* Send message
		And I click "Send by message" button
		And I select from "Mail account" drop-down list by "Email" string
		And "Attachments" table became equal
			| 'Presentation in letter' | 'File'                  |
			| 'SalesInvoicePrint.pdf'  | 'SalesInvoicePrint.pdf' |
	* Save 
		And I click "Save" button
		And I click "Send" button
		When I Check the steps for Exception
			| 'And I click "Save" button'    |
		And I delete "$$OutgoingMessage4001804$$" variable
		And I save the window as "$$OutgoingMessage4001804$$"
		And I close all client application windows
	* Check related documents structure
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
		And I click "Related documents" button
		And "DocumentsTree" table became equal
			| 'Presentation'                               | 'Amount' |
			| 'Sales invoice 15 dated 07.10.2020 01:19:02' | '800,00' |
			| '$$OutgoingMessage4001804$$'                 | ''       |
		And I close all client application windows
	* Create one more email (same SI)
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
		* Print
			And I click "Sales invoice" button		
		* Send message
			And I click "Send by message" button
			And I select from "Mail account" drop-down list by "Email" string
			And "Attachments" table became equal
				| 'Presentation in letter' | 'File'                  |
				| 'SalesInvoicePrint.pdf'  | 'SalesInvoicePrint.pdf' |
			And I click "Save" button
			And I click "Send" button
			When I Check the steps for Exception
				| 'And I click "Save" button'    |
			And I delete "$$OutgoingMessage40018041$$" variable
			And I save the window as "$$OutgoingMessage40018041$$"
			And I close all client application windows
		* Check
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
				| 'Number'    |
				| '15'        |
			And I click "Related documents" button
			And "DocumentsTree" table became equal
				| 'Presentation'                               | 'Amount' |
				| 'Sales invoice 15 dated 07.10.2020 01:19:02' | '800,00' |
				| '$$OutgoingMessage4001804$$'                 | ''       |
				| '$$OutgoingMessage40018041$$'                | ''       |
			And I close all client application windows
		* Check attached files
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
				| 'Number'    |
				| '15'        |
			And I click "Attached files" button
			And "FileList" table became equal
				| 'File'                  | 'Extension' | 'Volume'                   |
				| 'SalesInvoicePrint.pdf' | 'pdf'       | 'DEFAULT DOCUMENT STORAGE' |
			And I close all client application windows
	* Change SI and send mail
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
		And I select current line in "List" table
		And I go to line in "ItemList" table
			| "Item"     | "Item key"  | "Quantity" |
			| "Trousers" | "38/Yellow" | "1,000"    |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And I click "Sales invoice" button
		Then "Print form" window is opened
		And I click "Send by message" button
		And I select from "Mail account" drop-down list by "email" string
		And I click "Save" button
		And I click "Send" button
		And I delete "$$OutgoingMessage40018042$$" variable
		And I save the window as "$$OutgoingMessage40018042$$"
		And I close all client application windows
	* Check
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
		And I click "Related documents" button
		And "DocumentsTree" table became equal
			| 'Presentation'                               | 'Amount'   |
			| 'Sales invoice 15 dated 07.10.2020 01:19:02' | '1 199,99' |
			| '$$OutgoingMessage4001804$$'                 | ''         |
			| '$$OutgoingMessage40018041$$'                | ''         |
			| '$$OutgoingMessage40018042$$'                | ''         |
		And I close all client application windows
	* Check attached files
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
		And I click "Attached files" button
		And "FileList" table became equal
			| 'File'                  | 'Extension' | 'Volume'                   |
			| 'SalesInvoicePrint.pdf' | 'pdf'       | 'DEFAULT DOCUMENT STORAGE' |
			| 'SalesInvoicePrint.pdf' | 'pdf'       | 'DEFAULT DOCUMENT STORAGE' |
		And I close all client application windows

Scenario: _4001805 check message que to send
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.MessagesQueueToSend"
	And "List" table became equal
		| 'Message'                     | 'Sent' | 'Date sent' | 'Number attempts' | 'Last warning' |
		| '$$OutgoingMessage4001804$$'  | 'Yes'  | '*'         | '1'               | ''             |
		| '$$OutgoingMessage40018041$$' | 'Yes'  | '*'         | '1'               | ''             |
		| '$$OutgoingMessage40018042$$' | 'Yes'  | '*'         | '1'               | ''             |
	And I close all client application windows