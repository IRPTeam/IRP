#language: en
@tree
@Positive
@AgingAndCreditLimit

Feature: payment terms refill question

As an accountant
I want to be asked before the payment terms are refilled from the partner term
So that the schedule I entered by hand is never overwritten silently

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _1003000 preparation (payment terms refill question)
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
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Countries objects
		When Create catalog Stores objects
		When Create catalog Partners objects
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
		When Create information register Taxes records (VAT)
		And I close all client application windows
	* Create the payment schedule used by this feature
		Given I open hyperlink "e1cib/list/Catalog.PaymentSchedules"
		And I click the button named "FormCreate"
		And I input "PT question, 5 days" text in "ENG" field
		And I activate "Proportion of payment" field in "StagesOfPayment" table
		And in the table "StagesOfPayment" I click the button named "StagesOfPaymentAdd"
		And I select "Post-shipment credit" exact value from "Calculation type" drop-down list in "StagesOfPayment" table
		And I move to the next attribute
		And I input "100,00" text in "Proportion of payment" field of "StagesOfPayment" table
		And I finish line editing in "StagesOfPayment" table
		And I activate "Due period, days" field in "StagesOfPayment" table
		And I select current line in "StagesOfPayment" table
		And I input "5" text in "Due period, days" field of "StagesOfPayment" table
		And I finish line editing in "StagesOfPayment" table
		And I click "Save and close" button
	* Create the second payment schedule used by this feature
		And I click the button named "FormCreate"
		And I input "PT question, 14 days" text in "ENG" field
		And I activate "Proportion of payment" field in "StagesOfPayment" table
		And in the table "StagesOfPayment" I click the button named "StagesOfPaymentAdd"
		And I select "Post-shipment credit" exact value from "Calculation type" drop-down list in "StagesOfPayment" table
		And I move to the next attribute
		And I input "100,00" text in "Proportion of payment" field of "StagesOfPayment" table
		And I finish line editing in "StagesOfPayment" table
		And I activate "Due period, days" field in "StagesOfPayment" table
		And I select current line in "StagesOfPayment" table
		And I input "14" text in "Due period, days" field of "StagesOfPayment" table
		And I finish line editing in "StagesOfPayment" table
		And I click "Save and close" button
		And I close all client application windows
	* Attach the payment schedule to the customer partner term
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And I go to line in "List" table
			| 'Description'         |
			| 'Partner term DFC'    |
		And I select current line in "List" table
		And I move to "Credit limit & Aging" tab
		And I click Select button of "Payment term" field
		And I go to line in "List" table
			| 'Description'             |
			| 'PT question, 5 days'     |
		And I select current line in "List" table
		And I click "Save and close" button
	* Attach the payment schedule to the vendor partner term
		And I go to line in "List" table
			| 'Description'                  |
			| 'Partner term vendor DFC'      |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I move to "Credit limit & Aging" tab
		And I click Select button of "Payment term" field
		And I go to line in "List" table
			| 'Description'             |
			| 'PT question, 5 days'     |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I click "Save and close" button
	* Attach the second payment schedule to the NDB partner term
		And I go to line in "List" table
			| 'Description'         |
			| 'Partner term NDB'    |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I move to "Credit limit & Aging" tab
		And I click Select button of "Payment term" field
		And I go to line in "List" table
			| 'Description'              |
			| 'PT question, 14 days'     |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I click "Save and close" button
	* Attach the first payment schedule to the Retail partner term (identical schedule case)
		And I go to line in "List" table
			| 'Description'            |
			| 'Retail partner term'    |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I move to "Credit limit & Aging" tab
		And I click Select button of "Payment term" field
		And I go to line in "List" table
			| 'Description'             |
			| 'PT question, 5 days'     |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I click "Save and close" button
		And I close all client application windows


Scenario: _10030001 check preparation
	When check preparation


Scenario: _1003001 no question when the partner term has no payment schedule (Sales order)
	* The partner term has no payment schedule, nothing can be filled, so the question window must not be raised
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'    |
		| 'DFC'            |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'                       |
		| 'DFC Customer by Partner terms'     |
	And I select current line in "List" table
	And I move to "Aging" tab
	Then the number of "PaymentTerms" table lines is "equal" 0
	And I close all client application windows


Scenario: _1003002 no question when the partner term has no payment schedule (Sales invoice)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'    |
		| 'DFC'            |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'                       |
		| 'DFC Customer by Partner terms'     |
	And I select current line in "List" table
	And I move to "Aging" tab
	Then the number of "PaymentTerms" table lines is "equal" 0
	And I close all client application windows


Scenario: _1003003 no question when the partner term has no payment schedule (Purchase order)
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'    |
		| 'DFC'            |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'                     |
		| 'DFC Vendor by Partner terms'     |
	And I select current line in "List" table
	And I move to "Aging" tab
	Then the number of "PaymentTerms" table lines is "equal" 0
	And I close all client application windows


Scenario: _1003004 no question when the partner term has no payment schedule (Purchase invoice)
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'    |
		| 'DFC'            |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'                     |
		| 'DFC Vendor by Partner terms'     |
	And I select current line in "List" table
	And I move to "Aging" tab
	Then the number of "PaymentTerms" table lines is "equal" 0
	And I close all client application windows


Scenario: _1003011 question is raised and the payment terms are filled (Sales order)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'    |
		| 'DFC'            |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'         |
		| 'Partner term DFC'    |
	And I select current line in "List" table
	Then "Update item list info" window is opened
	And I click "OK" button
	And I move to "Aging" tab
	And "PaymentTerms" table contains lines
		| 'Calculation type'        | 'Due period, days'    | 'Proportion of payment'    |
		| 'Post-shipment credit'    | '5'                   | '100,00'                   |
	And I close all client application windows


Scenario: _1003012 question is raised and the payment terms are filled (Sales invoice)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	* A fixed document date makes the calculated payment date deterministic
	And I move to "Other" tab
	And I input "01.06.2026" text in "Date" field
	And I move to the next attribute
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'    |
		| 'DFC'            |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'         |
		| 'Partner term DFC'    |
	And I select current line in "List" table
	Then "Update item list info" window is opened
	And I click "OK" button
	And I move to "Aging" tab
	* The payment date must be the document date plus the due period
	And "PaymentTerms" table contains lines
		| 'Calculation type'        | 'Date'          | 'Due period, days'    | 'Proportion of payment'    |
		| 'Post-shipment credit'    | '06.06.2026'    | '5'                   | '100,00'                   |
	And I close all client application windows


Scenario: _1003013 question is raised and the payment terms are filled (Purchase order)
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'    |
		| 'DFC'            |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'                  |
		| 'Partner term vendor DFC'      |
	And I select current line in "List" table
	Then "Update item list info" window is opened
	And I click "OK" button
	And I move to "Aging" tab
	And "PaymentTerms" table contains lines
		| 'Calculation type'        | 'Due period, days'    | 'Proportion of payment'    |
		| 'Post-shipment credit'    | '5'                   | '100,00'                   |
	And I close all client application windows


Scenario: _1003014 question is raised and the payment terms are filled (Purchase invoice)
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'    |
		| 'DFC'            |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'                  |
		| 'Partner term vendor DFC'      |
	And I select current line in "List" table
	Then "Update item list info" window is opened
	And I click "OK" button
	And I move to "Aging" tab
	And "PaymentTerms" table contains lines
		| 'Calculation type'        | 'Due period, days'    | 'Proportion of payment'    |
		| 'Post-shipment credit'    | '5'                   | '100,00'                   |
	And I close all client application windows



Scenario: _1003021 the payment terms stay empty when the question is declined (Sales invoice)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'    |
		| 'DFC'            |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'         |
		| 'Partner term DFC'    |
	And I select current line in "List" table
	Then "Update item list info" window is opened
	And I remove checkbox named "PaymentTerm"
	And I click "OK" button
	* The declined question must not block the rest of the partner term data
	Then the form attribute named "Store" became equal to "Store 03"
	And I move to "Aging" tab
	Then the number of "PaymentTerms" table lines is "equal" 0
	And I close all client application windows


Scenario: _1003022 cancel of the question window rolls the whole change back (Sales invoice)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'    |
		| 'DFC'            |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'         |
		| 'Partner term DFC'    |
	And I select current line in "List" table
	Then "Update item list info" window is opened
	And I click "Cancel" button
	* Cancel rolls back the partner term change only, the partner chosen earlier stays
	Then the form attribute named "Agreement" became equal to ""
	And the form attribute named "Partner" became equal to "DFC"
	And I move to "Aging" tab
	Then the number of "PaymentTerms" table lines is "equal" 0
	And I close all client application windows


Scenario: _1003031 the filled payment terms are cleared by a partner term without a schedule (Sales invoice)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'    |
		| 'DFC'            |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'         |
		| 'Partner term DFC'    |
	And I select current line in "List" table
	Then "Update item list info" window is opened
	And I click "OK" button
	And I move to "Aging" tab
	Then the number of "PaymentTerms" table lines is "equal" 1
	* Switch to the partner term without a payment schedule
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'                       |
		| 'DFC Customer by Partner terms'     |
	And I select current line in "List" table
	Then "Update item list info" window is opened
	And I click "OK" button
	And I move to "Aging" tab
	Then the number of "PaymentTerms" table lines is "equal" 0
	And I close all client application windows


Scenario: _1003032 the filled payment terms are replaced by a partner term with a different schedule (Sales invoice)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'    |
		| 'DFC'            |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'         |
		| 'Partner term DFC'    |
	And I select current line in "List" table
	Then "Update item list info" window is opened
	And I click "OK" button
	And I move to "Aging" tab
	And "PaymentTerms" table contains lines
		| 'Calculation type'        | 'Due period, days'    | 'Proportion of payment'    |
		| 'Post-shipment credit'    | '5'                   | '100,00'                   |
	* Switching the partner cascades to a partner term with the 14-days schedule
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'    |
		| 'NDB'            |
	And I select current line in "List" table
	Then "Update item list info" window is opened
	And I click "OK" button
	And I move to "Aging" tab
	And "PaymentTerms" table contains lines
		| 'Calculation type'        | 'Due period, days'    | 'Proportion of payment'    |
		| 'Post-shipment credit'    | '14'                  | '100,00'                   |
	Then the number of "PaymentTerms" table lines is "equal" 1
	And I close all client application windows


Scenario: _1003033 the declined question keeps the old payment terms (Sales invoice)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'    |
		| 'DFC'            |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'         |
		| 'Partner term DFC'    |
	And I select current line in "List" table
	Then "Update item list info" window is opened
	And I click "OK" button
	* Switch to the 14-days partner term but decline the payment terms update
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'    |
		| 'NDB'            |
	And I select current line in "List" table
	Then "Update item list info" window is opened
	And I remove checkbox named "PaymentTerm"
	And I click "OK" button
	And I move to "Aging" tab
	And "PaymentTerms" table contains lines
		| 'Calculation type'        | 'Due period, days'    | 'Proportion of payment'    |
		| 'Post-shipment credit'    | '5'                   | '100,00'                   |
	Then the number of "PaymentTerms" table lines is "equal" 1
	And I close all client application windows


Scenario: _1003041 no question on the date change when the payment terms are empty (Sales invoice)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'    |
		| 'DFC'            |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'                       |
		| 'DFC Customer by Partner terms'     |
	And I select current line in "List" table
	And I move to "Other" tab
	And I input "08.04.2026" text in "Date" field
	And I move to the next attribute
	And I move to "Aging" tab
	Then the number of "PaymentTerms" table lines is "equal" 0
	And I close all client application windows


Scenario: _1003042 no question when only the document amount changes (Sales invoice)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'    |
		| 'DFC'            |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'         |
		| 'Partner term DFC'    |
	And I select current line in "List" table
	Then "Update item list info" window is opened
	And I click "OK" button
	* Adding a row changes the total amount, the schedule itself stays the same
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description'    |
		| 'Dress'          |
	And I select current line in "List" table
	And I activate "Item key" field in "ItemList" table
	And I click choice button of "Item key" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Item key'     |
		| 'L/Green'      |
	And I select current line in "List" table
	And I activate "Quantity" field in "ItemList" table
	And I input "2" text in "Quantity" field of "ItemList" table
	And I activate "Price" field in "ItemList" table
	And I input "100,00" text in "Price" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I move to "Aging" tab
	Then the number of "PaymentTerms" table lines is "equal" 1
	And I close all client application windows


Scenario: _1003043 no question when the new partner term has the identical schedule (Sales invoice)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'    |
		| 'DFC'            |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'         |
		| 'Partner term DFC'    |
	And I select current line in "List" table
	Then "Update item list info" window is opened
	And I click "OK" button
	* Switch to the partner whose term carries the same 5-days schedule - nothing differs, no question
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'        |
		| 'Retail customer'    |
	And I select current line in "List" table
	And I move to "Aging" tab
	And "PaymentTerms" table contains lines
		| 'Calculation type'        | 'Due period, days'    | 'Proportion of payment'    |
		| 'Post-shipment credit'    | '5'                   | '100,00'                   |
	Then the number of "PaymentTerms" table lines is "equal" 1
	And I close all client application windows


Scenario: _1003051 the store question does not carry the payment term question (Sales invoice)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'    |
		| 'DFC'            |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'         |
		| 'Partner term DFC'    |
	And I select current line in "List" table
	Then "Update item list info" window is opened
	And I click "OK" button
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description'    |
		| 'Dress'          |
	And I select current line in "List" table
	And I activate "Item key" field in "ItemList" table
	And I click choice button of "Item key" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Item key'     |
		| 'L/Green'      |
	And I select current line in "List" table
	And I finish line editing in "ItemList" table
	* The store change must raise the store question only
	And I click Select button of "Store" field
	And I go to line in "List" table
		| 'Description'    |
		| 'Store 01'       |
	And I select current line in "List" table
	Then "Update item list info" window is opened
	And checkbox named "PaymentTerm" is equal to "No"
	And I click "OK" button
	And I close all client application windows
