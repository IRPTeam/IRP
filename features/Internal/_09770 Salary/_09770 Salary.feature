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
		When Create information register T9510S_Staffing records
		When Create information register T9530S_WorkDays records
		When Create catalog AccrualAndDeductionTypes objects
		When Create information register T9500S_AccrualAndDeductionValues records
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company


Scenario: _097710 create time sheet
	And I close all client application windows
	* Open new time sheet
		Given I open hyperlink "e1cib/list/Document.TimeSheet"
		And I click the button named "FormCreate"
	* Filling in the details
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'   |
			| 'Main Company'  |
		And I select current line in "List" table
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'   |
			| 'Front office'  |
		And I select current line in "List" table
		And I input "01.01.2023" text in the field named "BeginDate"
		And I input "31.01.2023" text in the field named "EndDate"
		And in the table "TimeSheetList" I click "Fill time sheet" button
	* Check filling
		And "Workers" table became equal
			| 'Employee'        | 'Begin date' | 'End date'   | 'Position'     |
			| 'Alexander Orlov' | '01.01.2023' | '19.01.2023' | 'Manager'      |
			| 'Anna Petrova'    | '05.01.2023' | '31.01.2023' | 'Manager'      |
			| 'David Romanov'   | '01.01.2023' | '31.01.2023' | 'Sales person' |
		And I go to line in "Workers" table
			| 'Begin date' | 'Employee'        | 'End date'   | 'Position' |
			| '01.01.2023' | 'Alexander Orlov' | '19.01.2023' | 'Manager'  |
	* Select another period
		And I input "01.01.2023" text in the field named "BeginDate"
		And I input "04.01.2023" text in the field named "EndDate"
		And in the table "TimeSheetList" I click "Fill time sheet" button
		And "Workers" table became equal
			| 'Employee'        | 'Begin date' | 'End date'   | 'Position'     |
			| 'Alexander Orlov' | '01.01.2023' | '04.01.2023' | 'Manager'      |
			| 'David Romanov'   | '01.01.2023' | '04.01.2023' | 'Sales person' |
	* Filling accrual and deduction type
		And I finish line editing in "TimeSheetList" table
		And I go to line in "Workers" table
			| 'Begin date' | 'Employee'        | 'End date'   | 'Position' |
			| '01.01.2023' | 'Alexander Orlov' | '04.01.2023' | 'Manager'  |
		And I activate field named "WorkersBeginDate" in "Workers" table
		And I go to line in "TimeSheetList" table
			| 'Date'       |
			| '02.01.2023' |
		And I select current line in "TimeSheetList" table
		And I click choice button of "Accrual and deduction type" attribute in "TimeSheetList" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Salary'        |
		And I select current line in "List" table
		And I finish line editing in "TimeSheetList" table
		And I go to line in "TimeSheetList" table
			| 'Date'       |
			| '03.01.2023' |
		And I select current line in "TimeSheetList" table
		And I click choice button of "Accrual and deduction type" attribute in "TimeSheetList" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Salary'        |
		And I select current line in "List" table
		And I finish line editing in "TimeSheetList" table
		And I go to line in "TimeSheetList" table
			| 'Date'       |
			| '04.01.2023' |
		And I select current line in "TimeSheetList" table
		And I click choice button of "Accrual and deduction type" attribute in "TimeSheetList" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Salary'        |
		And I select current line in "List" table
		And I finish line editing in "TimeSheetList" table
		And I go to line in "Workers" table
			| 'Begin date' | 'Employee'      | 'End date'   | 'Position'     |
			| '01.01.2023' | 'David Romanov' | '04.01.2023' | 'Sales person' |
		And I select current line in "TimeSheetList" table
		And I click choice button of "Accrual and deduction type" attribute in "TimeSheetList" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Salary'        |
		And I select current line in "List" table
		And I finish line editing in "TimeSheetList" table
		And I go to line in "TimeSheetList" table
			| 'Date'       |
			| '03.01.2023' |
		And I select current line in "TimeSheetList" table
		And I click choice button of "Accrual and deduction type" attribute in "TimeSheetList" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Salary'        |
		And I select current line in "List" table
		And I finish line editing in "TimeSheetList" table
	* Check creation
		And I click "Post" button
		And I delete "$$NumberTS050003$$" variable
		And I save the value of "Number" field as "$$NumberTS050003$$"
		And I click "Post and close" button
	* Check creation
		And "List" table contains lines
			| 'Number'             |
			| '$$NumberTS050003$$' |

					
Scenario: _097712 check payroll
	And I close all client application windows
	* Open new time sheet
		Given I open hyperlink "e1cib/list/Document.Payroll"
		And I click the button named "FormCreate"
	* Filling in the details
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'   |
			| 'Main Company'  |
		And I select current line in "List" table
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'   |
			| 'Front office'  |
		And I select current line in "List" table
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code' |
			| 'TRY'  |
		And I select current line in "List" table
		And I input "01.01.2023" text in the field named "BeginDate"
		And I input "04.01.2023" text in the field named "EndDate"
		And in the table "PayrollList" I click "Fill payrolls" button	
	* Check filling
		And "PayrollList" table became equal
			| '#' | 'Amount'   | 'Employee'        | 'Position'     | 'Accrual and deduction type' |
			| '1' | '1 500,00' | 'Alexander Orlov' | 'Manager'      | 'Salary'                     |
			| '2' | ''         | 'David Romanov'   | 'Sales person' | 'Salary'                     |
	* Fill salary for Sales person
		And I go to line in "PayrollList" table
			| 'Employee'      |
			| 'David Romanov' |
		And I activate "Amount" field in "PayrollList" table
		And I select current line in "PayrollList" table
		And I input "800,00" text in "Amount" field of "PayrollList" table
		And I finish line editing in "PayrollList" table
		And "PayrollList" table became equal
			| '#' | 'Amount'   | 'Employee'        | 'Position'     | 'Accrual and deduction type' |
			| '1' | '1 500,00' | 'Alexander Orlov' | 'Manager'      | 'Salary'                     |
			| '2' | '800,00'   | 'David Romanov'   | 'Sales person' | 'Salary'                     |
		And I click "Post" button
	* Check creation
		And I click "Post" button
		And I delete "$$NumberPL050003$$" variable
		And I save the value of "Number" field as "$$NumberPL050003$$"
		And I click "Post and close" button
	* Check creation
		And "List" table contains lines
			| 'Number'             |
			| '$$NumberPL050003$$' |
				

						

				
		
		
				
				
		
				
					
			
