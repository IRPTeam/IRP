#language: en
@tree
@Positive
@Salary

Feature: Сheck payroll

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _097700 preparation (Сheck payroll)
	When set True value to the constant
	When set True value to the constant Use salary
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog Countries objects
		When Create catalog PlanningPeriods objects
		When Create catalog Agreements objects
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
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog PartnersBankAccounts objects
		When update ItemKeys
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
		When Create catalog PlanningPeriods objects
		When Create catalog BankTerms objects
		When Create catalog PaymentTerminals objects
		When Create catalog PaymentTypes objects
		When Create catalog CashAccounts objects (POS)
	* Data for salary
		When Create catalog EmployeePositions objects
		When Create catalog AccrualAndDeductionTypes objects
		When Create information register T9500S_AccrualAndDeductionValues records
		When Create information register Taxes records (VAT)
		When Create catalog EmployeeSchedule objects
		When Create document EmployeeHiring objects
		And I execute 1C:Enterprise script at server
			| "Documents.EmployeeHiring.FindByNumber(2).GetObject().Write(DocumentWriteMode.Write);"   |
			| "Documents.EmployeeHiring.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.EmployeeHiring.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);" |
	
Scenario: _097701 check preparation
	When check preparation


Scenario: _097704 check Employee hiring
	And I close all client application windows
	* Create EmployeeHiring (David Romanov)
		Given I open hyperlink "e1cib/list/Document.EmployeeHiring"
		And I click the button named "FormCreate"
	* Filling main info
		And I select from the drop-down list named "Company" by "Main Company" string
		And I move to the next attribute
		And I select from the drop-down list named "Employee" by "David Romanov" string
		And I move to the next attribute
		And I select from the drop-down list named "Position" by "Manager" string
		And I move to the next attribute
		And I select from "Employee schedule" drop-down list by "5 working days / 2 days off (day)" string
		And I select from "Profit loss center" drop-down list by "shop 01" string
		And I move to "Other" tab
		And I move to "More" tab
		And I select from the drop-down list named "Branch" by "shop 01" string
		And I move to "Employee hiring" tab
		And I input "01.11.2023 00:00:00" text in the field named "Date"	
		And I click the button named "FormPostAndClose"
	* Check
		And "List" table contains lines
			| 'Date'                | 'Company'      | 'Employee'      | 'Position' | 'Branch'  |
			| '01.11.2023 12:00:00' | 'Main Company' | 'David Romanov' | 'Manager'  | 'Shop 01' |
		
				
Scenario: _097705 check Employee firings
	And I close all client application windows
	* Create EmployeeFiring (Arina Brown)
		Given I open hyperlink "e1cib/list/Document.EmployeeFiring"
		And I click the button named "FormCreate"
	* Filling main info
		And I select from the drop-down list named "Company" by "Main Company" string
		And I move to the next attribute
		And I select from the drop-down list named "Employee" by "Arina Brown" string
		Then the form attribute named "Position" became equal to "Sales person"
		Then the form attribute named "EmployeeSchedule" became equal to "5 working days / 2 days off (hours)"
		Then the form attribute named "ProfitLossCenter" became equal to "Shop 01"
		Then the form attribute named "Branch" became equal to "Shop 01"								
		And I move to "Other" tab
		And I move to "More" tab
		And I input "20.11.2023 00:00:00" text in the field named "Date"	
		And I click "Post" button	
		And I save the value of "Number" field as "NumberEmployeeFiring"
		And I click "Post and close" button
	* Check
		And "List" table contains lines
			| 'Number'                 |
			| '$NumberEmployeeFiring$' |
				
Scenario: _097706 check Employee sick leave
	And I close all client application windows
	* Create EmployeeSickLeave (Arina Brown, David Romanov)
		Given I open hyperlink "e1cib/list/Document.EmployeeSickLeave"
		And I click the button named "FormCreate"
	* Filling main info
		And I select from the drop-down list named "Company" by "Main Company" string
		And in the table "EmployeeList" I click the button named "EmployeeListAdd"
		And I click choice button of "Employee" attribute in "EmployeeList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Arina Brown' |
		And I select current line in "List" table
		And I activate "Begin date" field in "EmployeeList" table
		And I input "01.11.2023" text in "Begin date" field of "EmployeeList" table
		And I activate "End date" field in "EmployeeList" table
		And I input "05.11.2023" text in "End date" field of "EmployeeList" table
		And I finish line editing in "EmployeeList" table
		And in the table "EmployeeList" I click the button named "EmployeeListAdd"
		And I click choice button of "Employee" attribute in "EmployeeList" table
		And I go to line in "List" table
			| 'Description'   |
			| 'David Romanov' |
		And I select current line in "List" table
		And I activate "Begin date" field in "EmployeeList" table
		And I input "04.11.2023" text in "Begin date" field of "EmployeeList" table
		And I activate "End date" field in "EmployeeList" table
		And I input "08.11.2023" text in "End date" field of "EmployeeList" table
		And I finish line editing in "EmployeeList" table
		And I move to "Other" tab
		And I move to "More" tab
		And I select from the drop-down list named "Branch" by "shop 01" string
		And I move to "Employee sick leave" tab
		And I click "Post" button	
		And I save the value of "Number" field as "NumberEmployeeSickLeave"
		And I click "Post and close" button
	* Check
		And "List" table contains lines
			| 'Number'                    |
			| '$NumberEmployeeSickLeave$' |

Scenario: _097707 check Employee vacation
	And I close all client application windows
	* Create EmployeeVacation (Arina Brown, Anna Petrova)
		Given I open hyperlink "e1cib/list/Document.EmployeeVacation"
		And I click the button named "FormCreate"
	* Filling main info
		And I select from the drop-down list named "Company" by "Main Company" string
		And in the table "EmployeeList" I click the button named "EmployeeListAdd"
		And I click choice button of "Employee" attribute in "EmployeeList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Arina Brown' |
		And I select current line in "List" table
		And I activate "Begin date" field in "EmployeeList" table
		And I input "06.11.2023" text in "Begin date" field of "EmployeeList" table
		And I activate "End date" field in "EmployeeList" table
		And I input "15.11.2023" text in "End date" field of "EmployeeList" table
		And I finish line editing in "EmployeeList" table
		And in the table "EmployeeList" I click the button named "EmployeeListAdd"
		And I click choice button of "Employee" attribute in "EmployeeList" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Anna Petrova' |
		And I select current line in "List" table
		And I activate "Begin date" field in "EmployeeList" table
		And I input "04.11.2023" text in "Begin date" field of "EmployeeList" table
		And I activate "End date" field in "EmployeeList" table
		And I input "08.11.2023" text in "End date" field of "EmployeeList" table
		And I finish line editing in "EmployeeList" table
		And I move to "Other" tab
		And I move to "More" tab
		And I select from the drop-down list named "Branch" by "shop 01" string
		And I click "Post" button	
		And I save the value of "Number" field as "NumberEmployeeVacation"
		And I click "Post and close" button
	* Check
		And "List" table contains lines
			| 'Number'                   |
			| '$NumberEmployeeVacation$' |

Scenario: _097708 check Employee transfer
	And I close all client application windows
	* Create EmployeeTransfer (Arina Brown)
		Given I open hyperlink "e1cib/list/Document.EmployeeTransfer"
		And I click the button named "FormCreate" 
	* Filling main info
		And I select from the drop-down list named "Company" by "Main Company" string
		And I click Choice button of the field named "Employee"
		And I go to line in "List" table
			| 'Description' |
			| 'Arina Brown' |
		And I select current line in "List" table
		And I input "17.11.2023" text in "End of date" field
		And I move to "Other" tab
		And I move to "More" tab
		And I input "16.11.2023 00:00:00" text in the field named "Date"
		And I move to "Employee transfer" tab
		And I click Select button of "To position" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Sales person' |
		And I select current line in "List" table
		And I click Select button of "To employee schedule" field
		And I go to line in "List" table
			| 'Description'             |
			| '5 working days / 2 days off (day)' |
		And I select current line in "List" table
		And I click Select button of "To branch" field
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And I click Select button of "To profit loss center" field
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
	* Check filling
		Then the form attribute named "Author" became equal to "en description is empty"
		Then the form attribute named "Branch" became equal to "Shop 01"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Date" became equal to "16.11.2023 00:00:00"
		Then the form attribute named "Employee" became equal to "Arina Brown"
		And the editing text of form attribute named "EndOfDate" became equal to "17.11.2023"
		Then the form attribute named "FromEmployeeSchedule" became equal to "5 working days / 2 days off (hours)"
		Then the form attribute named "FromPosition" became equal to "Sales person"
		Then the form attribute named "FromProfitLossCenter" became equal to "Shop 01"
		Then the form attribute named "ToBranch" became equal to "Distribution department"
		Then the form attribute named "ToEmployeeSchedule" became equal to "5 working days / 2 days off (day)"
		Then the form attribute named "ToPosition" became equal to "Sales person"
		Then the form attribute named "ToProfitLossCenter" became equal to "Distribution department"
		And I click "Post" button	
		And I save the value of "Number" field as "NumberEmployeeTransfer"
		And I click "Post and close" button
	* Check
		And "List" table contains lines
			| 'Number'                   |
			| '$NumberEmployeeTransfer$' |
			
				



Scenario: _097709 create Accrual and deduction values records (T9500)
	And I close all client application windows
	* Open  Accrual and deduction values records register
		Given I open hyperlink "e1cib/list/InformationRegister.T9500S_AccrualAndDeductionValues"
		* For partner
			And I click the button named "FormCreate"
			And I click Select button of "Employee or position" field
			Then "Select data type" window is opened
			And I go to line in "" table
				| ''           |
				| 'Partner'    |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Description'    |
				| 'Arina Brown'    |
			And I select current line in "List" table
			And I input "01.10.2023" text in the field named "Period"			
			And I click Select button of "Accual or deduction type" field
			And I go to line in "List" table
				| 'Description'    |
				| 'Salary'         |
			And I select current line in "List" table
			And I input "1 000,00" text in the field named "Value"
			And I click "Save and close" button
		* Check creation
			And "List" table contains lines
				| 'Employee or position'   | 'Value'       |
				| 'Arina Brown'            | '1 000,00'    |
		* For position
			And I click the button named "FormCreate"
			And I click Select button of "Employee or position" field
			Then "Select data type" window is opened
			And I go to line in "" table
				| ''                         |
				| 'Expense and revenue type' |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Description'    |
				| 'Accountant'     |
			And I select current line in "List" table
			And I click Select button of "Accual or deduction type" field
			And I go to line in "List" table
				| 'Description'    |
				| 'Salary'         |
			And I select current line in "List" table
			And I input "12 000,00" text in the field named "Value"
			And I click "Save and close" button
		* Check creation
			And "List" table contains lines
				| 'Employee or position'   | 'Value'        |
				| 'Accountant'             | '12 000,00'    |
			And I close all client application windows

Scenario: _097710 create Employee position
	And I close all client application windows
	* Create Employee position
		Given I open hyperlink "e1cib/list/Catalog.EmployeePositions"
		And I click the button named "FormCreate"
		And I click Open button of "ENG" field
		And I input "Director" text in "ENG" field
		And I input "Director TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
	* Check
		And "List" table contains lines
			| 'Description' |
			| 'Director'    |
	And I close all client application windows
	
// Scenario: _097715 create work days
		
				
						