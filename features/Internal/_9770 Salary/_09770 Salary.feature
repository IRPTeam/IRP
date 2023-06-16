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
		When Create information register T9510S_Staffing records
		When Create information register T9530S_WorkDays records
		When Create catalog AccrualAndDeductionTypes objects
		When Create information register T9500S_AccrualAndDeductionValues records
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"            |
				| "TaxCalculateVAT_TR"     |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company


Scenario: _097705 create accrual and deduction values
	And I close all client application windows
	* Open new form element accrual and deduction values
		Given I open hyperlink "e1cib/list/InformationRegister.T9500S_AccrualAndDeductionValues"
		And I click the button named "FormCreate"
	* Filling details
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
		And I click Select button of "Accual or deduction type" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Salary'         |
		And I select current line in "List" table
		And I input "1 000,00" text in the field named "Value"
		And I click "Save and close" button
	* Check creation
		And "List" table contains lines
			| 'Employee or position'   | 'Value'       |
			| 'Arina Brown'            | '1 000,00'    |
		And I close all client application windows
		

Scenario: _097706 create staffing
	And I close all client application windows
	* Open new form element staffing
		Given I open hyperlink "e1cib/list/InformationRegister.T9510S_Staffing"
		And I click the button named "FormCreate"
	* Filling details
		And I input "01.01.2021" text in the field named "Period"
		And I click Choice button of the field named "Employee"
		And I go to line in "List" table
			| 'Description'    |
			| 'Arina Brown'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'    |
			| 'Shop 01'        |
		And I select current line in "List" table
		And I click Choice button of the field named "Position"
		And I go to line in "List" table
			| 'Description'    |
			| 'Accountant'     |
		And I select current line in "List" table
		And I click "Save and close" button		
	* Check creation
		And "List" table contains lines
			| 'Employee'      | 'Company'           |
			| 'Arina Brown'   | 'Second Company'    |
		And I close all client application windows
		

Scenario: _097707 create work days
	And I close all client application windows
	* Open new form work days
		Given I open hyperlink "e1cib/list/InformationRegister.T9530S_WorkDays"
		And I click the button named "FormCreate"
	* Filling details
		And I input "01.01.2022" text in "Begin date" field
		And I input "31.01.2022" text in "End date" field
		And I click Select button of "Accrual and deduction type" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Salary'         |
		And I select current line in "List" table
		And I input "20" text in "Count days" field
		And I click "Save and close" button
	* Check creation
		And "List" table contains lines
			| 'Begin date'   | 'End date'     | 'Accrual and deduction type'   | 'Count days'    |
			| '01.01.2022'   | '31.01.2022'   | 'Salary'                       | '20'            |
		And I close all client application windows
					
Scenario: _097710 create time sheet
	And I close all client application windows
	* Open new time sheet
		Given I open hyperlink "e1cib/list/Document.TimeSheet"
		And I click the button named "FormCreate"
	* Filling in the details
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I input "01.01.2023" text in the field named "BeginDate"
		And I input "31.01.2023" text in the field named "EndDate"
		And in the table "TimeSheetList" I click "Fill time sheet" button
	* Check filling
		And "Workers" table became equal
			| 'Employee'          | 'Begin date'   | 'End date'     | 'Position'       | 'Profit loss center'         |
			| 'Alexander Orlov'   | '01.01.2023'   | '19.01.2023'   | 'Manager'        | 'Accountants office'         |
			| 'Anna Petrova'      | '05.01.2023'   | '31.01.2023'   | 'Manager'        | 'Distribution department'    |
			| 'David Romanov'     | '01.01.2023'   | '31.01.2023'   | 'Sales person'   | 'Accountants office'         |
		And I go to line in "Workers" table
			| 'Begin date'   | 'Employee'          | 'End date'     | 'Position'    |
			| '01.01.2023'   | 'Alexander Orlov'   | '19.01.2023'   | 'Manager'     |
	* Select another period
		And I input "01.01.2023" text in the field named "BeginDate"
		And I input "04.01.2023" text in the field named "EndDate"
		And in the table "TimeSheetList" I click "Fill time sheet" button
		And I click "OK" button		
		And "Workers" table became equal
			| 'Employee'          | 'Begin date'   | 'End date'     | 'Position'       | 'Profit loss center'    |
			| 'Alexander Orlov'   | '01.01.2023'   | '04.01.2023'   | 'Manager'        | 'Accountants office'    |
			| 'David Romanov'     | '01.01.2023'   | '04.01.2023'   | 'Sales person'   | 'Accountants office'    |
	* Filling accrual and deduction type
		And I finish line editing in "TimeSheetList" table
		And I go to line in "Workers" table
			| 'Begin date'   | 'Employee'          | 'End date'     | 'Position'    |
			| '01.01.2023'   | 'Alexander Orlov'   | '04.01.2023'   | 'Manager'     |
		And I activate field named "WorkersBeginDate" in "Workers" table
		And I go to line in "TimeSheetList" table
			| 'Date'          |
			| '02.01.2023'    |
		And I select current line in "TimeSheetList" table
		And I click choice button of "Accrual and deduction type" attribute in "TimeSheetList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Salary'         |
		And I select current line in "List" table
		And I finish line editing in "TimeSheetList" table
		And I go to line in "TimeSheetList" table
			| 'Date'          |
			| '03.01.2023'    |
		And I select current line in "TimeSheetList" table
		And I click choice button of "Accrual and deduction type" attribute in "TimeSheetList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Salary'         |
		And I select current line in "List" table
		And I finish line editing in "TimeSheetList" table
		And I go to line in "TimeSheetList" table
			| 'Date'          |
			| '04.01.2023'    |
		And I select current line in "TimeSheetList" table
		And I click choice button of "Accrual and deduction type" attribute in "TimeSheetList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Salary'         |
		And I select current line in "List" table
		And I finish line editing in "TimeSheetList" table
		And I go to line in "Workers" table
			| 'Begin date'   | 'Employee'        | 'End date'     | 'Position'        |
			| '01.01.2023'   | 'David Romanov'   | '04.01.2023'   | 'Sales person'    |
		And I select current line in "TimeSheetList" table
		And I click choice button of "Accrual and deduction type" attribute in "TimeSheetList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Salary'         |
		And I select current line in "List" table
		And I finish line editing in "TimeSheetList" table
		And I go to line in "TimeSheetList" table
			| 'Date'          |
			| '03.01.2023'    |
		And I select current line in "TimeSheetList" table
		And I click choice button of "Accrual and deduction type" attribute in "TimeSheetList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Salary'         |
		And I select current line in "List" table
		And I finish line editing in "TimeSheetList" table
	* Check creation
		And I click "Post" button
		And I delete "$$NumberTS050003$$" variable
		And I save the value of "Number" field as "$$NumberTS050003$$"
		And I click "Post and close" button
	* Check creation
		And "List" table contains lines
			| 'Number'                |
			| '$$NumberTS050003$$'    |

					
Scenario: _097712 check payroll
	And I close all client application windows
	* Open new time sheet
		Given I open hyperlink "e1cib/list/Document.Payroll"
		And I click the button named "FormCreate"
	* Filling in the details
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code'    |
			| 'TRY'     |
		And I select current line in "List" table
		And I click Choice button of the field named "PaymentPeriod"
		And I go to line in "List" table
			| 'Description'            |
			| 'Third (only salary)'    |
		And I select current line in "List" table
		And the editing text of form attribute named "BeginDate" became equal to "01.02.2023"
		And the editing text of form attribute named "EndDate" became equal to "28.02.2023"
		And in the table "AccrualList" I click "Fill accrual" button
		Then the number of "AccrualList" table lines is "равно" "0"
		And I input "01.01.2023" text in the field named "BeginDate"
		And I input "04.01.2023" text in the field named "EndDate"
		And in the table "AccrualList" I click "Fill accrual" button
	* Check filling
		And "AccrualList" table became equal
			| '#'   | 'Amount'     | 'Employee'          | 'Position'       | 'Accrual type'   | 'Expense type'   | 'Profit loss center'    |
			| '1'   | '1 500,00'   | 'Alexander Orlov'   | 'Manager'        | 'Salary'         | 'Expense'        | 'Accountants office'    |
			| '2'   | ''           | 'David Romanov'     | 'Sales person'   | 'Salary'         | 'Expense'        | 'Accountants office'    |
	* Fill salary for Sales person
		And I go to line in "AccrualList" table
			| 'Employee'         |
			| 'David Romanov'    |
		And I activate "Amount" field in "AccrualList" table
		And I select current line in "AccrualList" table
		And I input "800,00" text in "Amount" field of "AccrualList" table
		And I finish line editing in "AccrualList" table
		And "AccrualList" table became equal
			| '#'   | 'Amount'     | 'Employee'          | 'Position'       | 'Accrual type'   | 'Expense type'   | 'Profit loss center'    |
			| '1'   | '1 500,00'   | 'Alexander Orlov'   | 'Manager'        | 'Salary'         | 'Expense'        | 'Accountants office'    |
			| '2'   | '800,00'     | 'David Romanov'     | 'Sales person'   | 'Salary'         | 'Expense'        | 'Accountants office'    |
		And I click "Post" button
	* Fill deductions
		And I move to "Deduction" tab
		And in the table "DeductionList" I click "Fill deduction" button
		And in the table "DeductionList" I click "Add" button
		And I activate "Employee" field in "DeductionList" table
		And I select current line in "DeductionList" table
		And I click choice button of "Employee" attribute in "DeductionList" table
		And I go to line in "List" table
			| 'Description'      |
			| 'David Romanov'    |
		And I select current line in "List" table
		And I activate "Position" field in "DeductionList" table
		And I select "sales" from "Position" drop-down list by string in "DeductionList" table
		And I activate "Deduction type" field in "DeductionList" table
		And I select "Deduction" from "Deduction type" drop-down list by string in "DeductionList" table
		And I activate "Is revenue" field in "DeductionList" table
		And I set "Is revenue" checkbox in "DeductionList" table
		And I finish line editing in "DeductionList" table
		And I activate "Profit loss center" field in "DeductionList" table
		And I select current line in "DeductionList" table
		And I select "Logistics department" from "Profit loss center" drop-down list by string in "DeductionList" table
		And I activate "Amount" field in "DeductionList" table
		And I input "50,00" text in "Amount" field of "DeductionList" table
		And I finish line editing in "DeductionList" table
		And in the table "DeductionList" I click "Add" button
		And I activate "Employee" field in "DeductionList" table
		And I select "ale" from "Employee" drop-down list by string in "DeductionList" table
		And I activate "Position" field in "DeductionList" table
		And I select "Manager" from "Position" drop-down list by string in "DeductionList" table
		And I activate "Deduction type" field in "DeductionList" table
		And I select "Deduction" from "Deduction type" drop-down list by string in "DeductionList" table
		And I activate "Profit loss center" field in "DeductionList" table
		And I select "Accountants office" from "Profit loss center" drop-down list by string in "DeductionList" table
		And I activate "Amount" field in "DeductionList" table
		And I input "30,00" text in "Amount" field of "DeductionList" table
		And I finish line editing in "DeductionList" table
	* Check
		And "DeductionList" table became equal
			| '#'   | 'Amount'   | 'Employee'          | 'Position'       | 'Deduction type'   | 'Profit loss center'     | 'Expense type'   | 'Is revenue'    |
			| '1'   | '50,00'    | 'David Romanov'     | 'Sales person'   | 'Deduction'        | 'Logistics department'   | 'Expense'        | 'Yes'           |
			| '2'   | '30,00'    | 'Alexander Orlov'   | 'Manager'        | 'Deduction'        | 'Accountants office'     | 'Expense'        | 'No'            |
	* Fill cash advance deductions
		And in the table "CashAdvanceDeductionList" I click "Fill cash advance deduction" button
		And in the table "CashAdvanceDeductionList" I click "Add" button
		And I activate "Employee" field in "CashAdvanceDeductionList" table
		And I select "david" from "Employee" drop-down list by string in "CashAdvanceDeductionList" table
		And I activate "Amount" field in "CashAdvanceDeductionList" table
		And I input "70,00" text in "Amount" field of "CashAdvanceDeductionList" table
		And I finish line editing in "CashAdvanceDeductionList" table
	* Check
		And "CashAdvanceDeductionList" table became equal
			| '#'   | 'Amount'   | 'Employee'         |
			| '1'   | '70,00'    | 'David Romanov'    |
	* Check totals
		And the editing text of form attribute named "TotalAccrualAmount" became equal to "2 300,00"
		And the editing text of form attribute named "TotalDeductionAmount" became equal to "80,00"
		And the editing text of form attribute named "TotalCashAdvanceDeductionAmount" became equal to "70,00"
		And the editing text of form attribute named "TotalPaymentAmount" became equal to "2 150,00"				
	* Check creation
		And I click "Post" button
		And I delete "$$NumberPL050003$$" variable
		And I save the value of "Number" field as "$$NumberPL050003$$"
		And I click "Post and close" button
	* Check creation
		And "List" table contains lines
			| 'Number'                |
			| '$$NumberPL050003$$'    |
	
