#language: en
@tree
@Positive
@ChequeBondTransaction
Feature: create cheque bond transaction


Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


		
Scenario: _070000 preparation (Cheque bond transaction)
	When set True value to the constant
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
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog CashAccounts objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog BusinessUnits objects
		When Create catalog Partners objects
		When Create catalog ObjectStatuses objects (cheque bond)
		When Create catalog ChequeBonds objects
		When Create catalog PlanningPeriods objects
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Check or create SalesOrder023001
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesOrder023001$$" |
			When create SalesOrder023001
	* Check or create SalesInvoice024001
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesInvoice024001$$" |
			When create SalesInvoice024001
	* Check or create SalesOrder023005
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesOrder023005$$" |
			When create SalesOrder023005
	* Check or create SalesInvoice024008
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesInvoice024008$$" |
			When create SalesInvoice024008	
	When Create document PurchaseReturn objects (creation based on)
	And I execute 1C:Enterprise script at server
 			| "Documents.PurchaseReturn.FindByNumber(351).GetObject().Write(DocumentWriteMode.Posting);" |
	* Check or create PurchaseOrder017001
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseOrder017001$$" |
			When create PurchaseOrder017001
	* Check or create PurchaseInvoice018001
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseInvoice018001$$" |
			When create PurchaseInvoice018001 based on PurchaseOrder017001
	* Check or create PurchaseInvoice29604
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseInvoice29604$$" |
			When create a purchase invoice for the purchase of sets and dimensional grids at the tore 02
	When Create document SalesReturn objects (advance, customers)
	And I execute 1C:Enterprise script at server
 			| "Documents.SalesReturn.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);" |
	When Create document PI, SI (AP-AR by agreement)
	And I execute 1C:Enterprise script at server
 		| "Documents.SalesInvoice.FindByNumber(1212).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
 		| "Documents.PurchaseInvoice.FindByNumber(1212).GetObject().Write(DocumentWriteMode.Posting);" |
	

Scenario: _0700001 check preparation
	When check preparation	

Scenario: _0700002 create Cheque bond transaction (AP-AR by agreement), receipt and given check
	And I close all client application windows
	* Open Cheque bond transaction form
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I click the button named "FormCreate"
	* Filling Company, Currency and Branch
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Description'  |
			| 'Turkish lira' |
		And I select current line in "List" table
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I move to "Cheques" tab
	* Select own cheque
		And in the table "ChequeBonds" I click "Pickup cheques" button
		And I change the radio button named "ChequeBondType" value to "Own"
		And I go to line in "List" table
			| 'Amount'   | 'Cheque No'    | 'Cheque serial No' | 'Currency' | 'Due date'   | 'Type'       |
			| '5 000,00' | 'Own cheque 2' | 'AL'               | 'TRY'      | '30.09.2023' | 'Own cheque' |
		And I select current line in "List" table
		And I click "Transfer to document" button
		And I activate "Partner" field in "ChequeBonds" table
		And I select current line in "ChequeBonds" table
		And I click choice button of "Partner" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
		And I finish line editing in "ChequeBonds" table
		And in "ChequeBonds" table "Legal name" field is set to "DFC"
		And I click choice button of "Agreement" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'AP/AR posting detail' | 'Description'                 | 'Kind'    |
			| 'By agreements'        | 'DFC Vendor by Partner terms' | 'Regular' |
		And I select current line in "List" table
		And I activate "Account" field in "ChequeBonds" table
		And I select current line in "ChequeBonds" table
		And I click choice button of "Account" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, TRY' |
		And I select current line in "List" table
		And I activate "Financial movement type" field in "ChequeBonds" table
		And I click choice button of "Financial movement type" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Movement type 1' |
		And I select current line in "List" table
		And I activate "Planning period" field in "ChequeBonds" table
		And I click choice button of "Planning period" attribute in "ChequeBonds" table
		Then "Planning periods" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Second'      |
		And I select current line in "List" table
	* Select partner cheque
		And in the table "ChequeBonds" I click "Pickup cheques" button
		And I change the radio button named "ChequeBondType" value to "Partner"
		And I go to line in "List" table
			| 'Amount'   | 'Cheque No'        | 'Cheque serial No' | 'Currency' | 'Due date'   | 'Type'           |
			| '2 000,00' | 'Partner cheque 1' | 'AA'               | 'TRY'      | '30.09.2024' | 'Partner cheque' |
		And I select current line in "List" table
		And I click "Transfer to document" button
		And I activate "Partner" field in "ChequeBonds" table
		And I select current line in "ChequeBonds" table
		And I click choice button of "Partner" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
		And I finish line editing in "ChequeBonds" table
		And in "ChequeBonds" table "Legal name" field is set to "DFC"
		And I click choice button of "Agreement" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'AP/AR posting detail' | 'Description'                   | 'Kind'    |
			| 'By agreements'        | 'DFC Customer by Partner terms' | 'Regular' |
		And I select current line in "List" table
		And I activate "Account" field in "ChequeBonds" table
		And I select current line in "ChequeBonds" table
		And I click choice button of "Account" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, TRY' |
		And I select current line in "List" table
		And I activate "Financial movement type" field in "ChequeBonds" table
		And I click choice button of "Financial movement type" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Movement type 1' |
		And I select current line in "List" table
		And I activate "Planning period" field in "ChequeBonds" table
		And I click choice button of "Planning period" attribute in "ChequeBonds" table
		Then "Planning periods" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Second'      |
		And I select current line in "List" table
	* Check filling
		And I click "Post" button
		And "ChequeBonds" table contains lines
			| '#' | 'Amount'   | 'Partner' | 'Cheque'           | 'Status' | 'New status'           | 'Order' | 'Currency' | 'Legal name' | 'Planning period' | 'Agreement'                     | 'Legal name contract' | 'Basis document' | 'Account'           | 'Financial movement type' |
			| '1' | '5 000,00' | 'DFC'     | 'Own cheque 2'     | ''       | '01. GivenToPartner'   | ''      | 'TRY'      | 'DFC'        | 'Second'          | 'DFC Vendor by Partner terms'   | ''                    | ''               | 'Bank account, TRY' | 'Movement type 1'         |
			| '2' | '2 000,00' | 'DFC'     | 'Partner cheque 1' | ''       | '01. TakenFromPartner' | ''      | 'TRY'      | 'DFC'        | 'Second'          | 'DFC Customer by Partner terms' | ''                    | ''               | 'Bank account, TRY' | 'Movement type 1'         |
	* Check creation
		And I delete "$$NumberChequeBondTransaction1$$" variable
		And I delete "$$ChequeBondTransaction1$$" variable
		And I save the value of "Number" field as "$$NumberChequeBondTransaction1$$"
		And I save the window as "$$ChequeBondTransaction1$$"
		And I click the button named "FormPostAndClose"
		And "List" table contains lines
			| 'Number' |
			| '$$NumberChequeBondTransaction1$$'    |
		And I close all client application windows
		
		
Scenario: _0700003 create Cheque bond transaction (AP-AR by agreement), payed status
	And I close all client application windows
	* Open Cheque bond transaction form
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I click the button named "FormCreate"
	* Filling Company, Currency and Branch
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Description'  |
			| 'Turkish lira' |
		And I select current line in "List" table
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I move to "Cheques" tab
	* Select own cheque
		And in the table "ChequeBonds" I click the button named "ChequeBondsAdd"
		And I activate "Cheque" field in "ChequeBonds" table
		And I select current line in "ChequeBonds" table
		And I click choice button of "Cheque" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Amount'   | 'Cheque No'    | 'Cheque serial No' | 'Currency' | 'Due date'   | 'Type'       |
			| '5 000,00' | 'Own cheque 2' | 'AL'               | 'TRY'      | '30.09.2023' | 'Own cheque' |
		And I select current line in "List" table
		And "ChequeBonds" table became equal
			| '#' | 'Amount'   | 'Cheque'       | 'Status'             | 'Currency' |
			| '1' | '5 000,00' | 'Own cheque 2' | '01. GivenToPartner' | 'TRY'      |
		And I activate "Partner" field in "ChequeBonds" table
		And I select current line in "ChequeBonds" table
		And I click choice button of "Partner" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
		And I finish line editing in "ChequeBonds" table
		And in "ChequeBonds" table "Legal name" field is set to "DFC"
		And I click choice button of "Agreement" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'AP/AR posting detail' | 'Description'                 | 'Kind'    |
			| 'By agreements'        | 'DFC Vendor by Partner terms' | 'Regular' |
		And I select current line in "List" table
		And I activate "Account" field in "ChequeBonds" table
		And I select current line in "ChequeBonds" table
		And I click choice button of "Account" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, TRY' |
		And I select current line in "List" table
		And I activate "Financial movement type" field in "ChequeBonds" table
		And I click choice button of "Financial movement type" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Movement type 1' |
		And I select current line in "List" table
		And I activate "Planning period" field in "ChequeBonds" table
		And I click choice button of "Planning period" attribute in "ChequeBonds" table
		Then "Planning periods" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Second'      |
		And I select current line in "List" table
	* Select new status
		And I activate "New status" field in "ChequeBonds" table
		And I select current line in "ChequeBonds" table
		And I select "02. Payed" exact value from "New status" drop-down list in "ChequeBonds" table
		And I finish line editing in "ChequeBonds" table
	* Select partner cheque
		And in the table "ChequeBonds" I click the button named "ChequeBondsAdd"
		And I activate "Cheque" field in "ChequeBonds" table
		And I select current line in "ChequeBonds" table
		And I click choice button of "Cheque" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Amount'   | 'Cheque No'        | 'Cheque serial No' | 'Currency' | 'Due date'   | 'Type'           |
			| '2 000,00' | 'Partner cheque 1' | 'AA'               | 'TRY'      | '30.09.2024' | 'Partner cheque' |
		And I select current line in "List" table
		And I go to line in "ChequeBonds" table
			| 'Amount'   | 'Cheque'           | 'Status'               | 'Currency' |
			| '2 000,00' | 'Partner cheque 1' | '01. TakenFromPartner' | 'TRY'      |
		And I select current line in "ChequeBonds" table
		And I click choice button of "Partner" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
		And I finish line editing in "ChequeBonds" table
		And in "ChequeBonds" table "Legal name" field is set to "DFC"
		And I click choice button of "Agreement" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'AP/AR posting detail' | 'Description'                   | 'Kind'    |
			| 'By agreements'        | 'DFC Customer by Partner terms' | 'Regular' |
		And I select current line in "List" table
		And I activate "Account" field in "ChequeBonds" table
		And I select current line in "ChequeBonds" table
		And I click choice button of "Account" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, TRY' |
		And I select current line in "List" table
		And I activate "Financial movement type" field in "ChequeBonds" table
		And I click choice button of "Financial movement type" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Movement type 1' |
		And I select current line in "List" table
		And I activate "Planning period" field in "ChequeBonds" table
		And I click choice button of "Planning period" attribute in "ChequeBonds" table
		Then "Planning periods" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Second'      |
		And I select current line in "List" table
	* Select new status
		And I activate "New status" field in "ChequeBonds" table
		And I select current line in "ChequeBonds" table
		And I select "03. PaymentReceived" exact value from "New status" drop-down list in "ChequeBonds" table
		And I finish line editing in "ChequeBonds" table
	* Check filling
		And I click "Post" button
		And "ChequeBonds" table contains lines
			| '#' | 'Amount'   | 'Partner' | 'Cheque'           | 'Status'              | 'New status'           | 'Order' | 'Currency' | 'Legal name' | 'Planning period' | 'Agreement'                     | 'Legal name contract' | 'Basis document' | 'Account'           | 'Financial movement type' |
			| '1' | '5 000,00' | 'DFC'     | 'Own cheque 2'     | '02. Payed'           | '01. GivenToPartner'   | ''      | 'TRY'      | 'DFC'        | 'Second'          | 'DFC Vendor by Partner terms'   | ''                    | ''               | 'Bank account, TRY' | 'Movement type 1'         |
			| '2' | '2 000,00' | 'DFC'     | 'Partner cheque 1' | '03. PaymentReceived' | '01. TakenFromPartner' | ''      | 'TRY'      | 'DFC'        | 'Second'          | 'DFC Customer by Partner terms' | ''                    | ''               | 'Bank account, TRY' | 'Movement type 1'         |
	* Check creation
		And I delete "$$NumberChequeBondTransaction2$$" variable
		And I delete "$$ChequeBondTransaction2$$" variable
		And I save the value of "Number" field as "$$NumberChequeBondTransaction2$$"
		And I save the window as "$$ChequeBondTransaction2$$"
		And I click the button named "FormPostAndClose"
		And "List" table contains lines
			| 'Number'                           |
			| '$$NumberChequeBondTransaction2$$' |
		And I close all client application windows
				
		
				

				
		
				
		
				
		
				

		
				
		
				

				
	