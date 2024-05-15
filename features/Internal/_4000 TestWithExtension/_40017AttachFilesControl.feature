#language: en
@tree
@Positive
@ExtensionReportForm

Feature: Attach Files Control

As a Developer
I want to create an image subsystem


Variables:
import "Variables.feature"

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
		When Create catalog CashAccounts objects (Attach File Control)
		When Create catalog PaymentTypes objects (Attach File Control)
		When Create catalog Workstations objects (Attch File Control)
		When Create chart of characteristic types AddAttributeAndProperty objects (Attach File Control)
		When Create catalog BusinessUnits objects (Attach File Control)
		When Create document PurchaseOrder objects (PO Attach File Control)
		When Create document RetailReturnReceipt objects (RRR Attach File Control)
		
Scenario: _4001702 check preparation
	When check preparation 

Scenario: _4001703 check file attachment to document
	And I open hyperlink "e1cib/app/DataProcessor.AttachedFilesToDocumentsControl"
	And I go to the first line in "DocumentList" table
	And I select "C:\Users\G.BASUSTA\Documents\TEST docs\rabbit.jpg" file
	And Delay 5
	And I click the button named "AddNewDocument"
	And "CurrentFilesTable" table contains lines:
		| 'File'      |
		| 'rabbit.jpg' |

Scenario: _4001704 check attached file in document	
	And I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
	Then "Retail return receipts" window is opened
	And I go to line in "List" table
		| 'Number' | 'Partner'   |
		| '1'      | 'Ferron BP' |
	And I select current line in "List" table
	And I click "Attached files" button
	Then "Attach file" window is opened
	And I activate "File" field in "FileList" table
	And "FileList" table contains lines:
		| 'File'       |
		| 'rabbit.jpg' |
	
Scenario: _4001705 check attach file with undefined extensions
	And I open hyperlink "e1cib/app/DataProcessor.AttachedFilesToDocumentsControl"
	And I go to the first line in "DocumentList" table
	And I select "C:\Users\G.BASUSTA\Documents\TEST docs\Purchase Order Instruction.pdf" file
	And Delay 10
	And I click the button named "AddNewDocument"
	And "CurrentFilesTable" table contains lines:
		| 'File'                           |
		| 'Purchase Order Instruction.pdf' |

Scenario: _4001706 check Attach Mode and Check Mode
	* Check Attach Mode
		And I open hyperlink "e1cib/app/DataProcessor.AttachedFilesToDocumentsControl"
		Then the form attribute named "CheckMode" became equal to "No"
		And "DocumentsAttachedFiles" table became equal
			| 'File presention' | 'Required' | 'Extension'            |
			| 'RRR'             | 'Yes'      | '*.jpeg; *.png; *.jpg' |
		
	*Check Check Mode
		And I change checkbox "Check mode"
		Then the form attribute named "CheckMode" became equal to "Yes"
		
Scenario: _4001707 check Date, Company and Branch filters
	And I open hyperlink "e1cib/app/DataProcessor.AttachedFilesToDocumentsControl"
	And I click Choice button of the field named "Period"
	Then "Select period" window is opened
	And I click "Clear period" button
	And I input "01.01.2023" text in the field named "DateBegin"
	And I input "31.12.2023" text in the field named "DateEnd"
	And I click the button named "Select"
	Then "Attached files to documents control" window is opened
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
		| 'Description' |
		| 'Branch_02'   |
	And I click "Select" button
	And I click the button named "OK"
	And I change checkbox "Check mode"
	And "DocumentList" table became equal
		| 'Document'                                   | 'Author'                  | 'Branch'    |
		| 'Purchase order 1 dated 09.05.2023 12:29:59' | 'en description is empty' | 'Branch_02' |
		| 'Purchase order 4 dated 09.05.2023 13:10:09' | 'en description is empty' | 'Branch_02' |
	