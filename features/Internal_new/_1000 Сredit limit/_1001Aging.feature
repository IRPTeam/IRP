#language: en
@tree
@Positive
@CreditLimit

Feature: payment terms



Background:
	Given I launch TestClient opening script or connect the existing one
	

Scenario: _1000000 preparation (payment terms)
	* Constants
		When set True value to the constant
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
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
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	

Scenario: _1000001 filling in payment terms
	Given I open hyperlink "e1cib/list/Catalog.PaymentSchedules"
	* Post-shipment credit (7 days)
		And I click the button named "FormCreate"
		And I input "7 days" text in "ENG" field
		And I activate "Proportion of payment" field in "StagesOfPayment" table
		And I select current line in "StagesOfPayment" table
		And I input "100,00" text in "Proportion of payment" field of "StagesOfPayment" table
		And I finish line editing in "StagesOfPayment" table
		And I activate "Due period, days" field in "StagesOfPayment" table
		And I select current line in "StagesOfPayment" table
		And I input "7" text in "Due period, days" field of "StagesOfPayment" table
		And I finish line editing in "StagesOfPayment" table
		And I click "Save and close" button		
	* Post-shipment credit (14 days)
		And I click the button named "FormCreate"
		And I input "14 days" text in "ENG" field
		And in the table "StagesOfPayment" I click the button named "StagesOfPaymentAdd"
		And I select "Post-shipment credit" exact value from "Calculation type" drop-down list in "StagesOfPayment" table
		And I move to the next attribute
		And I input "100,00" text in "Proportion of payment" field of "StagesOfPayment" table
		And I activate "Due period, days" field in "StagesOfPayment" table
		And I input "14" text in "Due period, days" field of "StagesOfPayment" table
		And I finish line editing in "StagesOfPayment" table
		And I click "Save and close" button


Scenario: _1000002 filling in payment terms in the Partner term
	Given I open hyperlink "e1cib/list/Catalog.Agreements"
	* Basic Partner terms, TRY (7 days)
		And I go to line in "List" table
			| 'Description'              |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I move to "Credit limit & Aging" tab				
		And I click Select button of "Payment term" field
		And I go to line in "List" table
			| 'Description' |
			| '7 days'      |
		And I select current line in "List" table
		And I click "Save and close" button
	* Basic Partner terms, without VAT (14 days)
		And I go to line in "List" table
			| 'Description'                      |
			| 'Basic Partner terms, without VAT' |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I move to "Credit limit & Aging" tab
		And I click Select button of "Payment term" field
		And I go to line in "List" table
			| 'Description' |
			| '14 days'     |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I click "Save and close" button

Scenario: _1000003 create Sales invoice and check Aging tab
	When create SalesInvoice024016 (Shipment confirmation does not used)
	* Check aging tab
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
				| 'Number' |
				| '$$NumberSalesInvoice024016$$'|
		And I select current line in "List" table
		And I move to "Aging" tab
		And "PaymentTerms" table contains lines
			| 'Calculation type'     | 'Date'       | 'Due period, days' | 'Proportion of payment' | 'Amount' |
			| 'Post-shipment credit' | '*'          | '14'               | '100,00'                | '554,66' |
	* Check payment date calculation
		And I move to "Other" tab
		And I input "20.10.2020 00:00:00" text in "Date" field
		And I move to "Aging" tab
		Then "Update item list info" window is opened
		And I click "OK" button
		And "PaymentTerms" table contains lines
			| 'Calculation type'     | 'Date'         | 'Due period, days' | 'Proportion of payment' | 'Amount' |
			| 'Post-shipment credit' | '03.11.2020'   | '14'               | '100,00'                | '554,66' |
	* Manualy change payment date
		And I move to "Aging" tab
		And I select current line in "PaymentTerms" table
		And I input "04.11.2020" text in "Date" field of "PaymentTerms" table
		And I finish line editing in "PaymentTerms" table
		And "PaymentTerms" table contains lines
			| 'Calculation type'     | 'Date'         | 'Due period, days' | 'Proportion of payment' | 'Amount' |
			| 'Post-shipment credit' | '04.11.2020'   | '15'               | '100,00'                | '554,66' |
	* Manualy change 'Due period, days
		And I select current line in "PaymentTerms" table
		And I input "16" text in "Due period, days" field of "PaymentTerms" table
		And I finish line editing in "PaymentTerms" table
		And "PaymentTerms" table contains lines
			| 'Calculation type'     | 'Date'         | 'Due period, days' | 'Proportion of payment' | 'Amount' |
			| 'Post-shipment credit' | '05.11.2020'   | '16'               | '100,00'                | '554,66' |
		And I click the button named "FormPostAndClose"
		
				
		
				
		
			

		
				
	