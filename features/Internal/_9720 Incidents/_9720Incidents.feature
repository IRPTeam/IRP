#language: en
@tree
@Positive
@Incidents

Functionality: check an Incidents process

Variables:
import "Variables.feature"

Background:
Given I open new TestClient session or connect the existing one


Scenario: _972001 preparetion
	When set True value to the constant
	When set True value to the constant Use consolidated retail sales
	When set True value to the constant Use commission trading
	When set True value to the constant Use accounting
	When set True value to the constant Use salary
	When set True value to the constant Use retail orders
	When set True value to the constant Use fixed assets
	When Create catalog AddAttributeAndPropertySets objects (test data base)
	When Create catalog AddAttributeAndPropertyValues objects (test data base)
	When Create catalog IDInfoAddresses objects (test data base)
	When Create catalog RowIDs objects (test data base)
	When Create catalog BankTerms objects (test data base)
	When Create catalog BusinessUnits objects (test data base)
	When Create catalog CancelReturnReasons objects (test data base)
	When Create catalog CashStatementStatuses objects (test data base)
	When Create catalog CashAccounts objects (test data base)
	When Create catalog BillOfMaterials objects (test data base)
	When Create catalog Cities objects(test data base)
	When Create catalog Companies objects (test data base)
	When Create catalog ConfigurationMetadata objects (test data base)
	When Create catalog IDInfoSets objects (test data base)
	When Create catalog Countries objects (test data base)
	When Create catalog Currencies objects (test data base)
	When Create catalog DataBaseStatus objects (test data base)
	When Create catalog ExpenseAndRevenueTypes objects (test data base)
	When Create catalog IntegrationSettings objects (test data base)
	When Create catalog ItemKeys objects (test data base)
	When Create catalog ItemTypes objects (test data base)
	When Create catalog Units objects (test data base)
	When Create catalog Items objects (test data base)
	When Create catalog CurrencyMovementSets objects (test data base)
	When Create catalog ObjectStatuses objects (test data base)
	When Create catalog PartnerSegments objects (test data base)
	When Create catalog Agreements objects (test data base)
	When Create catalog Agreements objects (Incidents)
	When Create catalog FileStorage and IntegrationSettings objects (Incidents)
	* FileStorage
		And In the command interface I select "Settings" "Edit constants"
		And I click Choice button of the field named "DefaultFilesStorageVolume"
		And I go to line in "List" table
			| 'Description' |
			| 'Documents'   |
		And I click the button named "FormChoose"
		And I click Choice button of the field named "DefaultPictureStorageVolume"
		And I go to line in "List" table
			| "Description" |
			| "Pictures"    |
		And I click the button named "FormChoose"
		And I click the button named "FormWriteAndClose"	
	When Create catalog Partners objects (test data base)
	When Create catalog PartnersBankAccounts objects (test data base)
	When Create catalog PaymentTerminals objects (test data base)
	When Create catalog PaymentSchedules objects (test data base)
	When Create catalog PaymentTypes objects (test data base)
	When Create catalog PriceTypes objects (test data base)
	When Create catalog RetailCustomers objects (test data base)	
	When Create catalog SpecialOfferTypes objects (test data base)
	When Create catalog SpecialOffers objects (test data base)
	When Create catalog Specifications objects (test data base)
	When Create catalog Stores objects (test data base)
	When Create catalog TaxRates objects (test data base)
	When Create catalog Taxes objects (test data base)
	When Create catalog SerialLotNumbers objects (test data base)
	When Create information register Taxes records (test data base)
	When Create catalog AccrualAndDeductionTypes objects (test data base)
	When Create catalog EmployeePositions objects (test data base)
	When Create catalog FixedAssetsLedgerTypes objects (test data base)
	When Create catalog DepreciationSchedules objects (test data base)
	When Create catalog FixedAssets objects (test data base)
	When Create catalog ItemSegments objects (test data base)
	When Create catalog EmployeeSchedule objects (test data base)
	When Create catalog LegalNameContracts objects (test data base)
	When Create catalog Projects objects (test data base)
	When Create catalog IssueTypes objects (test data base)
	When Create catalog ObjectLocations objects (test data base)
	When Create catalog UnitsOfMeasurement objects (test data base)
	When Create catalog Vehicles objects (test data base)
	* Tax settings
		Given I open hyperlink "e1cib/list/Catalog.Companies"
		And I go to line in "List" table
						| 'Description'         |
						| 'Own company 2'       |
		And I select current line in "List" table
		And I move to "Tax types" tab
		And I go to line in "CompanyTaxes" table
						| 'Tax'       |
						| 'VAT'       |
		And I select current line in "CompanyTaxes" table
		And I click Open button of "Tax" field
		And I select "VAT" exact value from the drop-down list named "Kind"
		And I click "Save and close" button
		And I close all client application windows
	When Create catalog InterfaceGroups objects (test data base)
	When Create catalog AccessGroups objects (test data base)
	When Create catalog AccessProfiles objects (test data base)
	When Create catalog UserGroups objects (test data base)
	When Create catalog Users objects (test data base)
	When Create catalog Workstations objects (test data base)
	When Create catalog PlanningPeriods objects (test data base)
	When Create chart of characteristic types AddAttributeAndProperty objects (test data base)
	When Create chart of characteristic types IDInfoTypes objects (test data base)
	When Create chart of characteristic types CustomUserSettings objects (test data base)
	When Create chart of characteristic types CurrencyMovementType objects (test data base)
	When Create information register BundleContents records (test data base)
	When Create information register BranchBankTerms records (test data base)
	When Create information register CurrencyRates records (test data base)
	When Create information register Barcodes records (test data base)
	When Create information register PartnerSegments records (test data base)
	When Create information register TaxSettings records (test data base)
	When Create information register UserSettings records (test data base)
	When Create catalog PartnerItems objects (test data base)
	When set False value to the constant DisableLinkedRowsIntegrity
	And I close all client application windows


Scenario: _972002 check preparation
	When check preparation


Scenario: _972003 create an Issue
	And I close all client application windows	
* Create an Issue
	Given I open hyperlink "e1cib/list/Document.Issue"
	And I click the button named "FormCreate"
* Filling main details 
	And I click Choice button of the field named "Country"
	And I go to line in "List" table
		| "Description" |
		| "Country 1"   |
	And I click the button named "FormChoose"
	And I click Choice button of the field named "City"
	And I go to line in "List" table
		| "Description" |
		| "City2"       |
	And I click the button named "FormChoose"
	And I click Choice button of the field named "Location"
	And I go to line in "List" table
		| 'Description' | 'City'  |
		| 'CITY 2'      | 'City2' |
	And I select current line in "List" table	
	And I go to line in "List" table
		| "Description" |
		| "Store3"      |
	And I click the button named "FormChoose"
	And I click Choice button of the field named "IssueType"
	And I go to line in "List" table
		| 'Description'       |
		| 'Technical Service' |
	And I select current line in "List" table	
	And I go to line in "List" table
		| "Description" |
		| "Repair"      |
	And I click the button named "FormChoose"
	And I click Choice button of the field named "DueDate"
	And I input "10.12.2024  0:00:00" text in the field named "DueDate"
* Filling Info tab
	And I input "  Repair Product xxx" text in the field named "IssueDetails"
* Check 
	And I click the button named "FormWrite"
	And I delete "$$NumberIssue$$" variable
	And I delete "$$Issue$$" variable
	And I save the value of "Number" field as "$$NumberIssue$$"
	And I save the window as "$$Issue$$"
	And I click the button named "FormPostAndClose"
	And "List" table contains lines
		| 'Number'          |
		| '$$NumberIssue$$' |
	And I close all client application windows	


Scenario: _972004 create WorkOrder
	And I close all client application windows
* Open ann Issue
	Given I open hyperlink "e1cib/list/Document.Issue"
	And I go to line in "List" table
		| 'Number'          |
		| '$$NumberIssue$$' |
	And I select current line in "List" table
* Create WorkOrder
	And I click the button named "FormDocumentWorkOrderGenerate"
	And I click Choice button of the field named "Partner"
	And I go to line in "List" table
		| "Description" |
		| "Vendor 6"    |
	And I click the button named "FormChoose"
	And I click Choice button of the field named "Agreement"
	And I go to line in "List" table
		| 'Description' |
		| 'Vendor 6'    |
	And I click the button named "FormChoose"
	And I click Choice button of the field named "Company"
	And I go to line in "List" table
		| "Description"   |
		| "Own company 1" |
	And I click the button named "FormChoose"
* Filling Worker
	And I move to the tab named "GroupWorkers"
	And in the table "Workers" I click the button named "WorkersAdd"
	And I activate field named "WorkersEmployee" in "Workers" table
	And I select current line in "Workers" table
	And I click choice button of the attribute named "WorkersEmployee" in "Workers" table
	And I go to line in "List" table
		| 'Description' |
		| 'Employee 1'  |
	And I click the button named "FormChoose"
	And I click choice button of the attribute named "WorkersUnit" in "Workers" table
	And I go to line in "List" table
		| "Description" |
		| "hours"       |
	And I click the button named "FormChoose"
	And I activate field named "WorkersQuantity" in "Workers" table
	And I input "5,000" text in the field named "WorkersQuantity" of "Workers" table
	And I finish line editing in "Workers" table
	And I move to the tab named "GroupIssueList"
	And "IssueList" table became equal
		| 'Issue'     |
		| '$$Issue$$' |		
* Check 
	And I click the button named "FormWrite"
	And I delete "$$NumberWorkOrder$$" variable
	And I delete "$$WorkOrder$$" variable
	And I save the value of "Number" field as "$$NumberWorkOrder$$"
	And I save the window as "$$WorkOrder$$"
	And I click the button named "FormPostAndClose"
	Given I open hyperlink "e1cib/list/Document.WorkOrder"
	And "List" table contains lines
		| 'Number'              |
		| '$$NumberWorkOrder$$' |
	And I close all client application windows	


Scenario: _972005 create WorkSheet
	And I close all client application windows	
* Create an Issue
	Given I open hyperlink "e1cib/list/Document.WorkSheet"
	And I click the button named "FormCreate"
* Filling main details
	And I click Choice button of the field named "Partner"
	And I go to line in "List" table
		| "Description" |
		| "Vendor 6"    |
	And I click the button named "FormChoose"
	Then the form attribute named "LegalName" became equal to "Vendor 6"
	And I click Choice button of the field named "Company"
	And I go to line in "List" table
		| "Description"   |
		| "Own company 1" |
	And I click the button named "FormChoose"
* Filling work details
	And I move to the tab named "GroupWorkers"
	And in the table "Workers" I click the button named "WorkersAdd"
	And I activate field named "WorkersEmployee" in "Workers" table
	And I select current line in "Workers" table
	And I click choice button of the attribute named "WorkersEmployee" in "Workers" table
	And I go to line in "List" table
		| 'Description' |
		| 'Employee 1'  |
	And I click the button named "FormChoose"
	And I activate field named "WorkersUnit" in "Workers" table
	And I click choice button of the attribute named "WorkersUnit" in "Workers" table
	And I go to line in "List" table
		| "Description" |
		| "hours"       |
	And I click the button named "FormChoose"
	And I activate field named "WorkersQuantity" in "Workers" table
	And I input "5,000" text in the field named "WorkersQuantity" of "Workers" table
	And I finish line editing in "Workers" table
	And I move to the tab named "GroupOther"
	And I click Choice button of the field named "Currency"
	And I go to line in "List" table
		| 'Description' |
		| 'TRY '        |
	And I click the button named "FormChoose"
	And in the table "IssueList" I click the button named "IssueListAdd"
	And I click choice button of the attribute named "IssueListIssue" in "IssueList" table
	And I go to line in "List" table
		| "Number"          |
		| "$$NumberIssue$$" |
	And I click the button named "FormChoose"
	And "IssueList" table became equal
		| '#' | 'Issue'     | 'Comment' | 'Start job' | 'Start job latitude' | 'Start job longitude' | 'End job' | 'End job latitude' | 'End job longitude' |
		| '1' | '$$Issue$$' | ''        | ''          | ''                   | ''                    | ''        | ''                 | ''                  |
* Check 
	And I click the button named "FormWrite"
	And I delete "$$NumberWorkSheet$$" variable
	And I delete "$$WorkSheet$$" variable
	And I save the value of "Number" field as "$$NumberWorkSheet$$"
	And I save the window as "$$WorkSheet$$"
	And I click the button named "FormPostAndClose"
	And "List" table contains lines
		| 'Number'              |
		| '$$NumberWorkSheet$$' |
	And I close all client application windows	


Scenario: _972006 check Issue tracker
	And I close all client application windows
	And delay 5
* Open an Issue tracker
	And In the command interface I select "Incidents" "Issue tracker"
	And I go to line in "IssueList" table
		| 'Reference' |
		| '$$Issue$$' |
	And I select current line in "IssueList" table
* Check Issue
	Then the form attribute named "Issue" became equal to "$$Issue$$"
	Then the form attribute named "IssueIssueDetails" became equal to "  Repair Product xxx"
	Then the form attribute named "IssueIssueType" became equal to "Repair"
	Then the form attribute named "IssueLocation" became equal to "Store3"
	Then the form attribute named "WorkOrder" became equal to "$$WorkOrder$$"
	Then the form attribute named "WorkSheet" became equal to "$$WorkSheet$$"
	And I close all client application windows


Scenario: _972007 create an Issue within Project
	And I close all client application windows	
* Create an Issue
	Given I open hyperlink "e1cib/list/Document.Issue"
	And I click the button named "FormCreate"
* Filling main details 
	And I click Choice button of the field named "Country"
	And I go to line in "List" table
		| "Description" |
		| "Country 2"   |
	And I click the button named "FormChoose"
	And I click Choice button of the field named "City"
	And I go to line in "List" table
		| "Description" |
		| "City1"       |
	And I click the button named "FormChoose"
	And I click Choice button of the field named "Location"
	And I go to line in "List" table
		| 'Description' | 'City'  |
		| 'CITY 1'      | 'City1' |
	And I select current line in "List" table	
	And I go to line in "List" table
		| "Description" |
		| "Store2"      |
	And I click the button named "FormChoose"
	And I click Choice button of the field named "IssueType"
	And I go to line in "List" table
		| 'Description'             |
		| 'Upgrades & Replacements' |
	And I select current line in "List" table	
	And I go to line in "List" table
		| 'Description' |
		| 'Upgrade'     |
	And I click the button named "FormChoose"
	And I click Choice button of the field named "DueDate"
	And I input "30.12.2024  0:00:00" text in the field named "DueDate"
* Filling Info tab
	And I input "Upgrade CashPoints" text in the field named "IssueDetails"
	And I move to the tab named "GroupOther"
	And I click Choice button of the field named "Project"
	And I go to line in "List" table
		| 'Description' |
		| 'Project 3'   |
	And I click the button named "FormChoose"
	And I click the button named "FormWrite"
	And I click the button named "FormPost"	
* Add attachment
	And I click the button named "FormCommonCommandAttachedFiles"
	And I select "Pictures" exact value from the drop-down list named "DefaultFilesStorageVolume"
	And I input "$Path$/features/Internal/_9720 Incidents/picture3.jpg" text in the field named "dragFile"
	And I click the button named "dragFileBtn"
	Then "1C:Enterprise" window is opened
	And I click the button named "Button0"	
	And I close current window
* Check 
	And I delete "$$NumberIssue1$$" variable
	And I delete "$$Issue1$$" variable
	And I save the value of "Number" field as "$$NumberIssue1$$"
	And I save the window as "$$Issue1$$"
	And I click the button named "FormPostAndClose"
	And "List" table contains lines
		| 'Number'           |
		| '$$NumberIssue1$$' |
	And I close all client application windows	


Scenario: _972008 create WorkOrder within Project
	And I close all client application windows
* Open ann Issue
	Given I open hyperlink "e1cib/list/Document.Issue"
	And I go to line in "List" table
		| 'Number'           |
		| '$$NumberIssue1$$' |
	And I select current line in "List" table
* Create WorkOrder
	And I click the button named "FormDocumentWorkOrderGenerate"
	And I click Choice button of the field named "Partner"
	And I go to line in "List" table
		| "Description" |
		| "Vendor 6"    |
	And I click the button named "FormChoose"
	And I click Choice button of the field named "Agreement"
	And I go to line in "List" table
		| 'Description' |
		| 'Vendor 6'    |
	And I click the button named "FormChoose"
	And I click Choice button of the field named "Company"
	And I go to line in "List" table
		| "Description"   |
		| "Own company 1" |
	And I click the button named "FormChoose"
* Filling Worker
	And I move to the tab named "GroupWorkers"
	And in the table "Workers" I click the button named "WorkersAdd"
	And I activate field named "WorkersEmployee" in "Workers" table
	And I select current line in "Workers" table
	And I click choice button of the attribute named "WorkersEmployee" in "Workers" table
	And I go to line in "List" table
		| 'Description' |
		| 'Employee 1'  |
	And I click the button named "FormChoose"
	And I click choice button of the attribute named "WorkersUnit" in "Workers" table
	And I go to line in "List" table
		| "Description" |
		| "hours"       |
	And I click the button named "FormChoose"
	And I activate field named "WorkersQuantity" in "Workers" table
	And I input "5,000" text in the field named "WorkersQuantity" of "Workers" table
	And I finish line editing in "Workers" table
	And I move to the tab named "GroupIssueList"
	And "IssueList" table became equal
		| 'Issue'      |
		| '$$Issue1$$' |
* Check 
	And I click the button named "FormWrite"
	And I delete "$$NumberWorkOrder1$$" variable
	And I delete "$$WorkOrder1$$" variable
	And I save the value of "Number" field as "$$NumberWorkOrder1$$"
	And I save the window as "$$WorkOrder1$$"
	And I click the button named "FormPostAndClose"
	Given I open hyperlink "e1cib/list/Document.WorkOrder"
	And I go to line in "List" table
		| 'Number'               |
		| '$$NumberWorkOrder1$$' |
	And I close all client application windows	

Scenario: _972009 add attachments to Project
	And I close all client application windows	
* Choose a Project
	Given I open hyperlink "e1cib/list/Catalog.Projects"
	And I go to line in "List" table
		| 'Description' |
		| 'Project 3'   |
	And I select current line in "List" table
* Add attachments
	And I click the button named "FormCommonCommandAttachedFiles"
	And I select "Pictures" exact value from the drop-down list named "DefaultFilesStorageVolume"
	And I input "$Path$/features/Internal/_9720 Incidents/picture1.png" text in the field named "dragFile"
	And I click the button named "dragFileBtn"
	Then "1C:Enterprise" window is opened
	And I click the button named "Button0"
	And I input "$Path$/features/Internal/_9720 Incidents/picture2.jpg" text in the field named "dragFile"
	And I click the button named "dragFileBtn"
	Then "1C:Enterprise" window is opened
	And I click the button named "Button0"
	And I select "Documents" exact value from the drop-down list named "DefaultFilesStorageVolume"
	And I input "$Path$/features/Internal/_9720 Incidents/pdftext.pdf" text in the field named "dragFile"
	And I click the button named "dragFileBtn"
	Then "1C:Enterprise" window is opened
	And I click the button named "Button0"	
	And "FileList" table became equal
		| 'File'         |
		| 'picture1.png' |
		| 'picture2.jpg' |
		| 'pdftext.pdf'  |
* Check preview
	And I move to the tab named "PagePreview"
	And I activate field named "FileListFile" in "FileList" table
	And I go to line in "FileList" table
		| "File"         |
		| "picture1.png" |
	And the field named "ImagePreview" is filled
	And I go to line in "FileList" table
		| "File"         |
		| "picture2.jpg" |
	And the field named "ImagePreview" is filled
	And I go to line in "FileList" table
		| "File"        |
		| "pdftext.pdf" |
	And the field named "PDFPreview" is filled
	And I close all client application windows	
* Check attachments from roject list
	Given I open hyperlink "e1cib/list/Catalog.Projects"
	And I go to line in "List" table
		| 'Description' |
		| 'Project 3'   |
	And I click the button named "FormCommonCommandAttachedFiles"
	And "FileList" table became equal
		| 'File'         |
		| 'picture1.png' |
		| 'picture2.jpg' |
		| 'pdftext.pdf'  |
	And I close all client application windows	


Scenario: _972010 check Issue tracker within Project
	And I close all client application windows
* Open an Issue tracker
	And In the command interface I select "Incidents" "Issue tracker"
	And I go to line in "IssueList" table
		| 'Reference'  |
		| '$$Issue1$$' |
	And I select current line in "IssueList" table
* Check Issue
	And "AttachedFiles" table became equal
		| 'Reference'    |
		| 'pdftext.pdf'  |
		| 'picture1.png' |
		| 'picture2.jpg' |
		| 'picture3.jpg' |
	Then the form attribute named "Issue" became equal to "$$Issue1$$"
	Then the form attribute named "IssueIssueDetails" became equal to "Upgrade CashPoints"
	Then the form attribute named "IssueIssueType" became equal to "Upgrade"
	Then the form attribute named "IssueLocation" became equal to "Store2"
	Then the form attribute named "WorkOrder" became equal to "$$WorkOrder1$$"
	And I close all client application windows


Scenario: _972011 create an Issue from Tools
	And I close all client application windows	
* Create an Issue
	Given I open hyperlink "e1cib/app/DataProcessor.CreateNewIssue"
	And I click Choice button of the field named "Country"
	Then "Countries" window is opened
	And I go to line in "List" table
		| "Description" |
		| "Country 2"   |
	And I click the button named "FormChoose"
	And I click Choice button of the field named "City"
	And I go to line in "List" table
		| 'Description' |
		| 'City1'       |		
	And I click the button named "FormChoose"
	And I click Choice button of the field named "Location"
	And I go to line in "List" table
		| 'Description' |
		| 'CITY 1'      |
	And I select current line in "List" table
	And I go to line in "List" table
		| "Description" |
		| "Store1"      |
	And I click the button named "FormChoose"
	And I click Choice button of the field named "IssueType"
	And I go to line in "List" table
		| 'Description'          |
		| 'Installation & Setup' |
	And I select current line in "List" table	
	And I go to line in "List" table
		| "Description"  |
		| "Installation" |
	And I click the button named "FormChoose"
	And I click Choice button of the field named "DueDate"
	And I input "09.12.2024  0:00:00" text in the field named "DueDate"
	And I input "Installation" text in the field named "Comment"
//	And I click the button named "AddAttachments"
//	And I select "$Path$/features/Internal/_9720 Incidents/picture2.jpg" file
	And I click the button named "FormCreateIssue"
	And I close all client application windows				

Scenario: _972012 create an Issue from Project
//	And I close all client application windows	
//* Choose a Project
//	Given I open hyperlink "e1cib/list/Catalog.Projects"
//	And I go to line in "List" table
//		| 'Description' |
//		| 'Project 3'   |
//	And I select current line in "List" table
//* Create an Issue		
//	And I click the button named "FormDocumentIssueCreateIssues"
//	Then "1C:Enterprise" window is opened
//	And I click the button named "Button0"
//
//	And I activate "Basis document" field in "PaymentList" table
//	And I select current line in "PaymentList" table



