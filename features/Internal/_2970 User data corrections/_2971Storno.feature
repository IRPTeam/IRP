#language: en
@tree
@Positive
@UserDataCorrection

Functionality: Storno document - reverse register movements of a posted basis (user data correction)

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

# PR #2944 (#IRP-844): new Document.Storno reverses (negates) all register movements of its Basis
# on the Storno date WITHOUT unposting the basis. Created by the "Storno" command on ~33 documents
# (typeDocumentsWithStorno) or manually from the Storno list. The basis form shows a back-reference
# "This document has a Storno:" (DocStorno hyperlink).
# FillCheckProcessing rules:
#   Error_191 - another posted Storno already exists for the same Basis
#   Error_192 - Storno date < Basis date (strict, equal is allowed)
#   Error_193 - Basis is not posted
#   Company and Basis are required (fillChecking = ShowError).
# Command logic: posted storno exists -> ask "Storno already exists. Open existing document?";
#   basis not posted -> message "Posting document, before continue" (form does not open).
#
# This feature file is fully self-contained and runs on its own clean base: the preparation loads all
# its own data (same set as _2970EditOrderClosingDate.feature, plus cost calculation), so register
# movements are deterministic. Base documents are addressed by Number only, storno dates are far enough
# to always pass the date check, and the happy path stornoes a SalesInvoice (reversal increases stock,
# so the balance control on Store 1 is never violated). Linkage is proven by the saved storno number
# and the DocStorno link.
Scenario: _2971000 preparation (storno)
	When set True value to the constant
	* Load info
		When Create catalog ObjectStatuses objects (test data base)
		When Create catalog RowIDs objects (test data base)
		When Create catalog BusinessUnits objects (test data base)
		When Create catalog CancelReturnReasons objects (test data base)
		When Create catalog Companies objects (test data base)
		When Create catalog Countries objects (test data base)
		When Create catalog Currencies objects (test data base)
		When Create catalog ExpenseAndRevenueTypes objects (test data base)
		When Create catalog IntegrationSettings objects (test data base)
		When Create catalog ItemKeys objects (test data base)
		When Create catalog ItemTypes objects (test data base)
		When Create catalog Units objects (test data base)
		When Create catalog UnitsOfMeasurement objects (test data base)
		When Create catalog Items objects (test data base)
		When Create catalog CurrencyMovementSets objects (test data base)
		When Create catalog PartnerSegments objects (test data base)
		When Create catalog Agreements objects (test data base)
		When Create catalog Partners objects (test data base)
		When Create catalog PartnersBankAccounts objects (test data base)
		When Create catalog PriceTypes objects (test data base)
		When Create catalog SpecialOfferTypes objects (test data base)
		When Create catalog SpecialOffers objects (test data base)
		When Create catalog Specifications objects (test data base)
		When Create catalog Stores objects (test data base)
		When Create catalog TaxRates objects (test data base)
		When Create catalog Taxes objects (test data base)
		When Create information register Taxes records (test data base)
		When Create catalog LegalNameContracts objects (test data base)
		When Create catalog AccessGroups objects (test data base)
		When Create catalog AccessProfiles objects (test data base)
		When Create catalog UserGroups objects (test data base)
		When Create catalog Users objects (test data base)
		When Create chart of characteristic types AddAttributeAndProperty objects (test data base)
		When Create catalog AddAttributeAndPropertySets objects (test data base)
		When Create catalog AddAttributeAndPropertyValues objects (test data base)
		When Create chart of characteristic types CurrencyMovementType objects (test data base)
		When Create information register CurrencyRates records (test data base)
		When Create information register PartnerSegments records (test data base)
		When Create information register TaxSettings records (test data base)
	* Load documents
		When Create document OpeningEntry objects (test data base)
		When Create document GoodsReceipt objects (test data base)
		When Create document PurchaseOrder objects (test data base)
		When Create document PurchaseInvoice objects (test data base)
		When Create document SalesOrder objects (test data base)
		When Create document ShipmentConfirmation objects (test data base)
		When Create document SalesInvoice objects (test data base)
		When Create document SalesOrderClosing objects (test data base)
		When Create document BankReceipt objects (test data base)
		When Create document CustomersAdvancesClosing objects (test data base)
		When Create document CalculationMovementCosts objects (test data base)
	* Posting documents chain
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrderClosing.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		# Advance chain: BankReceipt 1 is a customer advance (Customer 2, 24.02.2023, 1000) and
		# CustomersAdvancesClosing 2 (Feb 2023) offsets it against the receivable of Sales invoice 1.
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.CustomersAdvancesClosing.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
	* Calculate cost of goods (produces R6010 Batch wise balance, R6020 Batch balance, R6060 COGS)
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
	* Enable linked rows integrity control
		When set False value to the constant DisableLinkedRowsIntegrity
	And I close all client application windows


Scenario: _2971001 check preparation
	When check preparation


# HAPPY PATH - create a Storno from a posted SalesInvoice via the Storno command, the header is filled
# from the basis, the storno posts, the basis keeps its posting and exposes the DocStorno back-reference.
Scenario: _2971002 check Storno is created from posted SalesInvoice and basis keeps posting
	And I close all client application windows
	* Open the basis Sales invoice 1 and run the Storno command
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I click the button named "FormDocumentStornoStorno"
	* Check the storno header is filled from the basis
		Then the form attribute named "Company" became equal to "Own company 2"
	* Set the storno date after the basis date and post
		And I input "01.01.2026" text in the field named "Date"
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		Then system warning window does not appear
		And I delete "$$NumberStornoSI2971$$" variable
		And I save the value of "Number" field as "$$NumberStornoSI2971$$"
		And I click the button named "FormPostAndClose"
	* Check the storno exists and is posted
		Given I open hyperlink "e1cib/list/Document.Storno"
		And "List" table contains lines
			| 'Number'                    |
			| '$$NumberStornoSI2971$$'    |
		And I close all client application windows
	* Check the basis keeps its posting and the DocStorno link opens the created storno
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I click the hyperlink named "DocStorno"
		Then the form attribute named "Number" became equal to "$$NumberStornoSI2971$$"
		Then the form attribute named "Company" became equal to "Own company 2"
	And I close all client application windows


# ADVANCE (user-level, by numbers) - a user checks the customer settlement via the R5020 Partners balance
# report. Sales invoice 1 (1210) was partly offset by the customer advance (1000) of BankReceipt 1 via
# CustomersAdvancesClosing 2. Stornoing Sales invoice 1 writes back its receivable, so the report shows
# the storno line returning the balance to the advance-only state for Customer 2.
Scenario: _2971025 check Storno effect on advance offsetting in the R5020 Partners balance report
	And I close all client application windows
	* Run the R5020 Partners balance report
		Given I open hyperlink "e1cib/app/Report.R5020_PartnersBalance"
		And I click "Generate" button
	* Check the whole report against the reference template (full data of the case): Customer 2 owes 210,00 after the
	* advance offset, and the storno of Sales invoice 1 turns the closing balance into a -1 000,00 advance credit
		Then "Result" spreadsheet document is equal to "Storno_R5020_Advance" by template
	And I close all client application windows


# LANDED COST (user-level, by numbers) - a user checks the inventory cost via the R6020 Batch balance
# report. Sales invoice 1 shipped goods out of the Opening entry 1 batch at their landed cost; the storno
# writes that batch movement back, so the report shows the stornoed quantity/cost returned to the batch.
Scenario: _2971026 check Storno effect on landed cost in the R6020 Batch balance report
	And I close all client application windows
	* Run the R6020 Batch balance report
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click "Generate" button
	* Check the whole batch balance against the reference template (full data of the case): Sales invoice 1 expensed
	* the S/Color 1 batch down to 17 300,00, and the storno writes the landed cost back, restoring it to 17 500,00
		Then "Result" spreadsheet document is equal to "Storno_R6020_LandedCost" by template
	And I close all client application windows


# COVERAGE - the storno reverses the basis movements in ALL registers at once. This compares the storno's
# full registrations report (every register it touches) against the reference template, so a change in ANY
# register - not only the ones pinned by the per-register scenarios above - is caught.
Scenario: _2971027 check Storno reverses the basis movements in all registers (full registration report)
	And I close all client application windows
	* Open the SalesInvoice storno via the basis back-reference
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I click the hyperlink named "DocStorno"
	* Generate the full registrations report (all registers) and compare it to the reference template
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal to "Storno_SI_AllRegisters" by template
	And I close all client application windows


# UndoPosting and repost the storno keep it consistent (uses the SalesInvoice storno from _2971002).
Scenario: _2971005 check Storno UndoPosting and repost stay consistent
	And I close all client application windows
	* Open the storno created in _2971002
		Given I open hyperlink "e1cib/list/Document.Storno"
		And I go to line in "List" table
			| 'Number'                    |
			| '$$NumberStornoSI2971$$'    |
		And I select current line in "List" table
	* Undo posting
		And I click the button named "FormUndoPosting"
		Then system warning window does not appear
	* Repost
		And I click the button named "FormPostAndClose"
		Then system warning window does not appear
	And I close all client application windows


# MOVEMENTS - the storno reverses the basis register records: SalesInvoice 1 shipped 4 of S/Color 1
# and 1 of the no-key item (Expense on R4010 Actual stocks). The storno writes the same Expense record
# type with the opposite quantity (-4 / -1) under itself on the storno date 01.01.2026 - proving the
# postings are stornoed. Opened via the DocStorno back-reference so the storno number stays dynamic.
Scenario: _2971006 check Storno reverses SalesInvoice movements in R4010 Actual stocks
	And I close all client application windows
	* Open the SalesInvoice storno via the basis back-reference
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I click the hyperlink named "DocStorno"
	* Generate the registrations report for R4010 Actual stocks
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
	* Check the whole R4010 register output equals the basis stock movements written back with the opposite sign
		Then "ResultTable" spreadsheet document is equal
			| 'Storno 1 dated 01.01.2026 12:00:00' | '' | '' | '' | '' | '' | '' | '' |
			| 'Document registrations records' | '' | '' | '' | '' | '' | '' | '' |
			| 'Register  "R4010 Actual stocks"' | '' | '' | '' | '' | '' | '' | '' |
			| '' | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | '' | '' | '' |
			| '' | '' | '' | 'Quantity' | 'Store' | 'Item key' | 'Serial lot number' | 'Source of origin' |
			| '' | 'Expense' | '01.01.2026 12:00:00' | '-4' | 'Store 1 (with balance control)' | 'S/Color 1' | '' | '' |
			| '' | 'Expense' | '01.01.2026 12:00:00' | '-1' | 'Store 1 (with balance control)' | 'Item without item key' | '' | '' |
	And I close all client application windows


# MOVEMENTS - R4012 Stock Reservation is reversed too: Sales invoice 1 consumed the reservation made by
# Sales order 1, so the storno frees that reserved quantity back (R4011 Free stocks nets to zero and is
# therefore not touched - actual and reservation move together).
Scenario: _2971017 check Storno reverses SalesInvoice movements in R4012 Stock Reservation
	And I close all client application windows
	* Open the SalesInvoice storno via the basis back-reference
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I click the hyperlink named "DocStorno"
	* Generate the registrations report for R4012 Stock Reservation
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
	* Check the whole R4012 register output equals the reserved quantity written back with the opposite sign
		Then "ResultTable" spreadsheet document is equal
			| 'Storno 1 dated 01.01.2026 12:00:00' | '' | '' | '' | '' | '' | '' |
			| 'Document registrations records' | '' | '' | '' | '' | '' | '' |
			| 'Register  "R4012 Stock Reservation"' | '' | '' | '' | '' | '' | '' |
			| '' | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | '' | '' |
			| '' | '' | '' | 'Quantity' | 'Store' | 'Item key' | 'Order' |
			| '' | 'Expense' | '01.01.2026 12:00:00' | '-4' | 'Store 1 (with balance control)' | 'S/Color 1' | 'Sales order 1 dated 24.02.2023 10:13:53' |
			| '' | 'Expense' | '01.01.2026 12:00:00' | '-1' | 'Store 1 (with balance control)' | 'Item without item key' | 'Sales order 1 dated 24.02.2023 10:13:53' |
	And I close all client application windows


# MOVEMENTS - the reversal is not limited to stock: the storno also reverses the turnover/financial
# registers. Here R2001 Sales is written back with negated quantity and amounts (legal currency rows).
Scenario: _2971010 check Storno reverses SalesInvoice movements in R2001 Sales
	And I close all client application windows
	* Open the SalesInvoice storno via the basis back-reference
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I click the hyperlink named "DocStorno"
	* Generate the registrations report for R2001 Sales
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		* Check the whole R2001 register output equals the sales turnover written back with the opposite sign
			Then "ResultTable" spreadsheet document is equal
				| 'Storno 1 dated 01.01.2026 12:00:00' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' |
				| 'Document registrations records' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' |
				| 'Register  "R2001 Sales"' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' |
				| '' | 'Period' | 'Resources' | '' | '' | '' | 'Dimensions' | '' | '' | '' | '' | '' | '' | '' | '' |
				| '' | '' | 'Quantity' | 'Amount' | 'Net amount' | 'Offers amount' | 'Company' | 'Branch' | 'Multi currency movement type' | 'Currency' | 'Invoice' | 'Item key' | 'Serial lot number' | 'Row key' | 'Sales person' |
				| '' | '01.01.2026 12:00:00' | '-4' | '-760' | '-633,33' | '' | 'Own company 2' | 'Business unit 1' | 'Legal currency, TRY' | 'TRY' | 'Sales invoice 1 dated 24.02.2023 10:14:47' | 'S/Color 1' | '' | 'dcdcbe9e-5743-49b6-8ca8-8e95b7ac6b89' | '' |
				| '' | '01.01.2026 12:00:00' | '-4' | '-760' | '-633,33' | '' | 'Own company 2' | 'Business unit 1' | 'en description is empty' | 'TRY' | 'Sales invoice 1 dated 24.02.2023 10:14:47' | 'S/Color 1' | '' | 'dcdcbe9e-5743-49b6-8ca8-8e95b7ac6b89' | '' |
				| '' | '01.01.2026 12:00:00' | '-4' | '-37,93' | '-31,61' | '' | 'Own company 2' | 'Business unit 1' | 'Reporting currency, EUR' | 'EUR' | 'Sales invoice 1 dated 24.02.2023 10:14:47' | 'S/Color 1' | '' | 'dcdcbe9e-5743-49b6-8ca8-8e95b7ac6b89' | '' |
				| '' | '01.01.2026 12:00:00' | '-4' | '' | '' | '' | 'Own company 2' | 'Business unit 1' | 'Budgeting currency, EUR' | 'EUR' | 'Sales invoice 1 dated 24.02.2023 10:14:47' | 'S/Color 1' | '' | 'dcdcbe9e-5743-49b6-8ca8-8e95b7ac6b89' | '' |
				| '' | '01.01.2026 12:00:00' | '-1' | '-450' | '-375' | '' | 'Own company 2' | 'Business unit 1' | 'Legal currency, TRY' | 'TRY' | 'Sales invoice 1 dated 24.02.2023 10:14:47' | 'Item without item key' | '' | '223ddc1a-3180-4190-a0ab-9ac73b34ab8b' | '' |
				| '' | '01.01.2026 12:00:00' | '-1' | '-450' | '-375' | '' | 'Own company 2' | 'Business unit 1' | 'en description is empty' | 'TRY' | 'Sales invoice 1 dated 24.02.2023 10:14:47' | 'Item without item key' | '' | '223ddc1a-3180-4190-a0ab-9ac73b34ab8b' | '' |
				| '' | '01.01.2026 12:00:00' | '-1' | '-22,46' | '-18,71' | '' | 'Own company 2' | 'Business unit 1' | 'Reporting currency, EUR' | 'EUR' | 'Sales invoice 1 dated 24.02.2023 10:14:47' | 'Item without item key' | '' | '223ddc1a-3180-4190-a0ab-9ac73b34ab8b' | '' |
				| '' | '01.01.2026 12:00:00' | '-1' | '' | '' | '' | 'Own company 2' | 'Business unit 1' | 'Budgeting currency, EUR' | 'EUR' | 'Sales invoice 1 dated 24.02.2023 10:14:47' | 'Item without item key' | '' | '223ddc1a-3180-4190-a0ab-9ac73b34ab8b' | '' |
	And I close all client application windows


# DIALOG - running the command again on a basis that already has a posted storno asks to open it.
# Covers both branches: No (nothing happens) then Yes (the existing storno opens).
Scenario: _2971007 check Storno command on basis with existing storno asks to open it
	And I close all client application windows
	* Run the command again on Sales invoice 1 and answer No
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I click the button named "FormDocumentStornoStorno"
		Then "1C:Enterprise" window is opened
		And I click "No" button
		And I close all client application windows
	* Run the command again and answer Yes - the existing storno opens
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I click the button named "FormDocumentStornoStorno"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then the form attribute named "Number" became equal to "$$NumberStornoSI2971$$"
	And I close all client application windows


# NEGATIVE - Error_191: a second posted storno for the same basis is rejected.
# Both stornos are created via the command (basis auto-filled), so no composite Basis selection is needed:
# create A unposted, create B unposted, post A, then posting B must fail.
Scenario: _2971008 check second Storno for the same basis is blocked (Error_191)
	And I close all client application windows
	* Create first storno (A) for Purchase order 1 and write it unposted
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I click the button named "FormDocumentStornoStorno"
		And I input "01.01.2026" text in the field named "Date"
		And I click the button named "FormWrite"
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$NumberStornoA2971$$" variable
		And I save the value of "Number" field as "$$NumberStornoA2971$$"
		And I close all client application windows
	* Create second storno (B) for Purchase order 1 and write it unposted
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I click the button named "FormDocumentStornoStorno"
		And I input "01.01.2026" text in the field named "Date"
		And I click the button named "FormWrite"
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$NumberStornoB2971$$" variable
		And I save the value of "Number" field as "$$NumberStornoB2971$$"
		And I close all client application windows
	* Post storno A
		Given I open hyperlink "e1cib/list/Document.Storno"
		And I go to line in "List" table
			| 'Number'                   |
			| '$$NumberStornoA2971$$'    |
		And I select current line in "List" table
		And I click the button named "FormPostAndClose"
		Then system warning window does not appear
		And I close all client application windows
	* Post storno B - rejected because a posted storno already exists for the basis
		Given I open hyperlink "e1cib/list/Document.Storno"
		And I go to line in "List" table
			| 'Number'                   |
			| '$$NumberStornoB2971$$'    |
		And I select current line in "List" table
		And I click the button named "FormPost"
		When TestClient log message contains "already exists for document" string
	And I close all client application windows


# BOUNDARY - Error_192: Storno date strictly earlier than the basis date is rejected;
# a date equal to the basis date is allowed (the check uses strict "less than").
# Sales order 1 keeps its fixture date 24.02.2023 10:13:53 in both files (only closings are added to it).
Scenario: _2971009 check Storno date before basis is blocked, equal date is allowed
	And I close all client application windows
	* Create storno for Sales order 1 via the command
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I click the button named "FormDocumentStornoStorno"
	* Try a date earlier than the basis date - rejected
		And I input "01.01.2020" text in the field named "Date"
		And I click the button named "FormPost"
		When TestClient log message contains "less than Basis date" string
	* Set the date equal to the basis date - allowed
		And I input "24.02.2023 10:13:53" text in the field named "Date"
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		Then system warning window does not appear
		And I click the button named "FormPostAndClose"
	And I close all client application windows


# NEGATIVE - Error_193: posting a storno whose basis is not posted is rejected.
# Create the storno from a posted Purchase invoice, then unpost the basis and try to post the storno.
Scenario: _2971011 check Storno with not posted basis is blocked (Error_193)
	And I close all client application windows
	* Create storno for the posted Purchase invoice 1 and write it unposted
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I click the button named "FormDocumentStornoStorno"
		And I input "01.01.2026" text in the field named "Date"
		And I click the button named "FormWrite"
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$NumberStornoPI2971$$" variable
		And I save the value of "Number" field as "$$NumberStornoPI2971$$"
		And I close all client application windows
	* Unpost the basis Purchase invoice 1
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I click the button named "FormUndoPosting"
		If "1C:Enterprise" window is opened Then
			And I click "Yes" button
		And I close all client application windows
	* Try to post the storno - rejected because the basis is not posted
		Given I open hyperlink "e1cib/list/Document.Storno"
		And I go to line in "List" table
			| 'Number'                    |
			| '$$NumberStornoPI2971$$'    |
		And I select current line in "List" table
		And I click the button named "FormPost"
		When TestClient log message contains "not posted" string
		And I close all client application windows
	* Restore - post the basis Purchase invoice 1 back
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		Then user message window does not contain messages
	And I close all client application windows


# NEGATIVE - the command on a NOT posted basis shows "Posting document, before continue"
# and does not open the storno form. Unpost Shipment confirmation 1, run the command, then restore it.
Scenario: _2971013 check Storno command on not posted basis shows the posting message
	And I close all client application windows
	* Unpost Shipment confirmation 1
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I click the button named "FormUndoPosting"
		If "1C:Enterprise" window is opened Then
			And I click "Yes" button
		And I close all client application windows
	* Run the command on the not posted basis - message appears, no storno form opens
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I click the button named "FormDocumentStornoStorno"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I close all client application windows
	* Restore - post the basis Shipment confirmation 1 back
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		Then user message window does not contain messages
	And I close all client application windows


# NEGATIVE - required fields: a manually created storno without Company and Basis cannot be posted.
Scenario: _2971012 check Storno required fields validation on Post
	And I close all client application windows
	* Create a storno manually from the list, leave Company and Basis empty
		Given I open hyperlink "e1cib/list/Document.Storno"
		And I click the button named "FormCreate"
		And I click the button named "FormPost"
	* Check the required-field messages for Company and Basis
		When TestClient log message contains "Company" string
		When TestClient log message contains "Basis" string
	And I close all client application windows


# BOUNDARY/UI - copying a storno keeps the Company but clears the Basis (fill-once attribute).
# Self-contained: writes (no posting needed) a storno for Goods receipt 4, then copies it.
Scenario: _2971014 check copy Storno keeps Company and clears Basis
	And I close all client application windows
	* Create a storno for Goods receipt 4 and write it
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '4'      |
		And I select current line in "List" table
		And I click the button named "FormDocumentStornoStorno"
		And I input "01.01.2026" text in the field named "Date"
		And I click the button named "FormWrite"
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$NumberStornoCopy2971$$" variable
		And I save the value of "Number" field as "$$NumberStornoCopy2971$$"
		And I close all client application windows
	* Copy the storno from the list
		Given I open hyperlink "e1cib/list/Document.Storno"
		And I go to line in "List" table
			| 'Number'                      |
			| '$$NumberStornoCopy2971$$'    |
		And in the table "List" I click the button named "ListContextMenuCopy"
	* Check the copy inherited Company but not Basis
		Then the form attribute named "Company" became equal to "Own company 2"
		Then the form attribute named "Basis" became equal to ""
	And I close all client application windows


# READ ONLY + REPOST - a basis that has a posted Storno can still be reposted from the document list
# (the list Post command acts on the object directly), but once opened the whole form is read only
# (Form.ReadOnly = ValueIsFilled(DocStorno)) and nothing can be changed. Uses Sales invoice 17.
Scenario: _2971016 check basis with Storno reposts from the list but is read only when opened
	And I close all client application windows
	* Create and post a storno for Sales invoice 17 via the command
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '17'     |
		And I select current line in "List" table
		And I click the button named "FormDocumentStornoStorno"
		And I input "01.01.2026" text in the field named "Date"
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		Then system warning window does not appear
		And I click the button named "FormPostAndClose"
		And I close all client application windows
	* Repost Sales invoice 17 (which now has a posted storno) from the list - allowed
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '17'     |
		And in the table "List" I click the button named "ListContextMenuPost"
		Then user message window does not contain messages
	* Open the basis - the form is read only, a field cannot be changed
		And I select current line in "List" table
		When I Check the steps for Exception
			| 'And I input "USD" text in the field named "Currency"' |
	And I close all client application windows


# MOVEMENTS - the storno also reverses the partner-balance (financial) register R5020: the customer
# debt booked by Sales invoice 1 (1 210) is written back with the opposite sign on the storno date.
Scenario: _2971018 check Storno reverses SalesInvoice movements in R5020 Partners balance
	And I close all client application windows
	* Open the SalesInvoice storno via the basis back-reference
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I click the hyperlink named "DocStorno"
	* Generate the registrations report for R5020 Partners balance
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		* Check the whole R5020 register output equals the partner balance written back with the opposite sign
			Then "ResultTable" spreadsheet document is equal
				| 'Storno 1 dated 01.01.2026 12:00:00' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' |
				| 'Document registrations records' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' |
				| 'Register  "R5020 Partners balance"' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' |
				| '' | 'Record type' | 'Period' | 'Resources' | '' | '' | '' | '' | '' | 'Dimensions' | '' | '' | '' | '' | '' | '' | '' | '' | 'Attributes' |
				| '' | '' | '' | 'Amount' | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company' | 'Branch' | 'Partner' | 'Legal name' | 'Agreement' | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
				| '' | 'Receipt' | '01.01.2026 12:00:00' | '-1 210' | '-1 210' | '' | '' | '' | '' | 'Own company 2' | 'Business unit 1' | 'Customer 2 (2 partner term)' | 'Client 2' | 'Individual partner term 1 (by partner term)' | '' | 'TRY' | 'Legal currency, TRY' | 'TRY' | '' |
				| '' | 'Receipt' | '01.01.2026 12:00:00' | '-1 210' | '-1 210' | '' | '' | '' | '' | 'Own company 2' | 'Business unit 1' | 'Customer 2 (2 partner term)' | 'Client 2' | 'Individual partner term 1 (by partner term)' | '' | 'TRY' | 'en description is empty' | 'TRY' | '' |
				| '' | 'Receipt' | '01.01.2026 12:00:00' | '-60,39' | '-60,39' | '' | '' | '' | '' | 'Own company 2' | 'Business unit 1' | 'Customer 2 (2 partner term)' | 'Client 2' | 'Individual partner term 1 (by partner term)' | '' | 'EUR' | 'Reporting currency, EUR' | 'TRY' | '' |
				| '' | 'Receipt' | '01.01.2026 12:00:00' | '' | '' | '' | '' | '' | '' | 'Own company 2' | 'Business unit 1' | 'Customer 2 (2 partner term)' | 'Client 2' | 'Individual partner term 1 (by partner term)' | '' | 'EUR' | 'Budgeting currency, EUR' | 'TRY' | '' |
	And I close all client application windows


# MOVEMENTS - cost: the storno reverses R6060 Cost of goods sold (the cost of the shipped goods,
# calculated by CalculationMovementCosts) with the opposite sign on the storno date.
Scenario: _2971019 check Storno reverses SalesInvoice movements in R6060 Cost of goods sold
	And I close all client application windows
	* Open the SalesInvoice storno via the basis back-reference
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I click the hyperlink named "DocStorno"
	* Generate the registrations report for R6060 Cost of goods sold
		And I click "Registrations report" button
		And I select "R6060 Cost of goods sold" exact value from "Register" drop-down list
		And I click "Generate report" button
		* Check the whole R6060 register output equals the cost of goods sold written back with the opposite sign
			Then "ResultTable" spreadsheet document is equal
				| 'Storno 1 dated 01.01.2026 12:00:00' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' |
				| 'Document registrations records' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' |
				| 'Register  "R6060 Cost of goods sold"' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' |
				| '' | 'Period' | 'Resources' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | 'Dimensions' | '' | '' | '' | '' | '' | '' | 'Attributes' |
				| '' | '' | 'Quantity' | 'Invoice amount' | 'Invoice tax amount' | 'Indirect cost amount' | 'Indirect cost tax amount' | 'Extra cost amount by ratio' | 'Extra cost tax amount by ratio' | 'Extra direct cost amount' | 'Extra direct cost tax amount' | 'Allocated cost amount' | 'Allocated cost tax amount' | 'Allocated revenue amount' | 'Allocated revenue tax amount' | 'Total amount' | 'Total net amount' | 'Total tax amount' | 'Preliminary quantity' | 'Preliminary amount' | 'Preliminary tax amount' | 'Company' | 'Sales invoice' | 'Item key' | 'Currency movement type' | 'Currency' | 'Serial lot number' | 'Source of origin' | 'Calculation movement cost' |
				| '' | '01.01.2026 12:00:00' | '-4' | '-200' | '-33,33' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '-233,33' | '-200' | '-33,33' | '' | '' | '' | 'Own company 2' | 'Sales invoice 1 dated 24.02.2023 10:14:47' | 'S/Color 1' | 'Legal currency, TRY' | 'TRY' | '' | '' | '' |
				| '' | '01.01.2026 12:00:00' | '-4' | '-200' | '-33,33' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '-233,33' | '-200' | '-33,33' | '' | '' | '' | 'Own company 2' | 'Sales invoice 1 dated 24.02.2023 10:14:47' | 'S/Color 1' | 'en description is empty' | 'TRY' | '' | '' | '' |
				| '' | '01.01.2026 12:00:00' | '-4' | '-9,98' | '-1,66' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '-11,64' | '-9,98' | '-1,66' | '' | '' | '' | 'Own company 2' | 'Sales invoice 1 dated 24.02.2023 10:14:47' | 'S/Color 1' | 'Reporting currency, EUR' | 'EUR' | '' | '' | '' |
				| '' | '01.01.2026 12:00:00' | '-4' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | 'Own company 2' | 'Sales invoice 1 dated 24.02.2023 10:14:47' | 'S/Color 1' | 'Budgeting currency, EUR' | 'EUR' | '' | '' | '' |
				| '' | '01.01.2026 12:00:00' | '-1' | '-50' | '-8,33' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '-58,33' | '-50' | '-8,33' | '' | '' | '' | 'Own company 2' | 'Sales invoice 1 dated 24.02.2023 10:14:47' | 'Item without item key' | 'Legal currency, TRY' | 'TRY' | '' | '' | '' |
				| '' | '01.01.2026 12:00:00' | '-1' | '-50' | '-8,33' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '-58,33' | '-50' | '-8,33' | '' | '' | '' | 'Own company 2' | 'Sales invoice 1 dated 24.02.2023 10:14:47' | 'Item without item key' | 'en description is empty' | 'TRY' | '' | '' | '' |
				| '' | '01.01.2026 12:00:00' | '-1' | '-2,5' | '-0,42' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '-2,92' | '-2,5' | '-0,42' | '' | '' | '' | 'Own company 2' | 'Sales invoice 1 dated 24.02.2023 10:14:47' | 'Item without item key' | 'Reporting currency, EUR' | 'EUR' | '' | '' | '' |
				| '' | '01.01.2026 12:00:00' | '-1' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | 'Own company 2' | 'Sales invoice 1 dated 24.02.2023 10:14:47' | 'Item without item key' | 'Budgeting currency, EUR' | 'EUR' | '' | '' | '' |
	And I close all client application windows


# MOVEMENTS - cost: the storno reverses R6020 Batch balance - the on-hand batch (sourced from
# Opening entry 1) is written back with the opposite sign and cost on the storno date.
Scenario: _2971020 check Storno reverses SalesInvoice movements in R6020 Batch balance
	And I close all client application windows
	* Open the SalesInvoice storno via the basis back-reference
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I click the hyperlink named "DocStorno"
	* Generate the registrations report for R6020 Batch balance
		And I click "Registrations report" button
		And I select "R6020 Batch balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		* Check the whole R6020 register output equals the batch balance written back with the opposite sign
			Then "ResultTable" spreadsheet document is equal
				| 'Storno 1 dated 01.01.2026 12:00:00' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' |
				| 'Document registrations records' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' |
				| 'Register  "R6020 Batch balance"' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' |
				| '' | 'Record type' | 'Period' | 'Resources' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | 'Dimensions' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | 'Attributes' |
				| '' | '' | '' | 'Quantity' | 'Invoice amount' | 'Invoice tax amount' | 'Indirect cost amount' | 'Indirect cost tax amount' | 'Extra cost amount by ratio' | 'Extra cost tax amount by ratio' | 'Extra direct cost amount' | 'Extra direct cost tax amount' | 'Allocated cost amount' | 'Allocated cost tax amount' | 'Allocated revenue amount' | 'Allocated revenue tax amount' | 'Total amount' | 'Total net amount' | 'Total tax amount' | 'Preliminary quantity' | 'Preliminary amount' | 'Preliminary tax amount' | 'Company' | 'Store' | 'Item key' | 'Batch' | 'Batch key' | 'Inventory origin' | 'Source of origin' | 'Serial lot number' | 'Partner' | 'Agreement' | 'Legal name' | 'Calculation movement cost' |
				| '' | 'Expense' | '01.01.2026 12:00:00' | '-4' | '-200' | '-33,33' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '-233,33' | '-200' | '-33,33' | '' | '' | '' | 'Own company 2' | 'Store 1 (with balance control)' | 'S/Color 1' | 'Opening entry 1 dated 31.01.2023 10:30:29' | 'S/Color 1 - Store 1 (with balance control)' | 'Own stocks' | '' | '' | '' | '' | '' | '' |
				| '' | 'Expense' | '01.01.2026 12:00:00' | '-1' | '-50' | '-8,33' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '-58,33' | '-50' | '-8,33' | '' | '' | '' | 'Own company 2' | 'Store 1 (with balance control)' | 'Item without item key' | 'Opening entry 1 dated 31.01.2023 10:30:29' | 'Item without item key - Store 1 (with balance control)' | 'Own stocks' | '' | '' | '' | '' | '' | '' |
	And I close all client application windows


# ADVANCE - the storno also reverses R2021 Customer transactions of Sales invoice 1. This invoice
# took part in advance offsetting: BankReceipt 1 (a Customer 2 advance) was offset against it by
# CustomersAdvancesClosing 2 (Feb 2023). Stornoing the invoice writes back the whole customer
# receivable with the opposite sign (the "Customers advances closing" attribute is carried over).
Scenario: _2971022 check Storno reverses SalesInvoice movements in R2021 Customer transactions
	And I close all client application windows
	* Open the SalesInvoice storno via the basis back-reference
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I click the hyperlink named "DocStorno"
	* Generate the registrations report for R2021 Customer transactions
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
	* Check the whole R2021 register output equals the customer transaction written back with the opposite sign
		Then "ResultTable" spreadsheet document is equal
			| 'Storno 1 dated 01.01.2026 12:00:00' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' |
			| 'Document registrations records' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' |
			| 'Register  "R2021 Customer transactions"' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' |
			| '' | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | 'Attributes' | '' |
			| '' | '' | '' | 'Amount' | 'Company' | 'Branch' | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name' | 'Partner' | 'Agreement' | 'Basis' | 'Order' | 'Project' | 'Deferred calculation' | 'Customers advances closing' |
			| '' | 'Receipt' | '01.01.2026 12:00:00' | '-1 210' | 'Own company 2' | 'Business unit 1' | 'Legal currency, TRY' | 'TRY' | 'TRY' | 'Client 2' | 'Customer 2 (2 partner term)' | 'Individual partner term 1 (by partner term)' | '' | '' | '' | 'No' | '' |
			| '' | 'Receipt' | '01.01.2026 12:00:00' | '-1 210' | 'Own company 2' | 'Business unit 1' | 'en description is empty' | 'TRY' | 'TRY' | 'Client 2' | 'Customer 2 (2 partner term)' | 'Individual partner term 1 (by partner term)' | '' | '' | '' | 'No' | '' |
			| '' | 'Receipt' | '01.01.2026 12:00:00' | '-60,39' | 'Own company 2' | 'Business unit 1' | 'Reporting currency, EUR' | 'EUR' | 'TRY' | 'Client 2' | 'Customer 2 (2 partner term)' | 'Individual partner term 1 (by partner term)' | '' | '' | '' | 'No' | '' |
			| '' | 'Receipt' | '01.01.2026 12:00:00' | '' | 'Own company 2' | 'Business unit 1' | 'Budgeting currency, EUR' | 'EUR' | 'TRY' | 'Client 2' | 'Customer 2 (2 partner term)' | 'Individual partner term 1 (by partner term)' | '' | '' | '' | 'Yes' | '' |
	And I close all client application windows


# ADVANCE - the advance side: BankReceipt 1 is the customer advance that CustomersAdvancesClosing 2
# offset against Sales invoice 1. The advance payment is storno-eligible, so it can be reversed by a
# Storno. _2971023 creates that storno, _2971024 checks the advance is written back in R5020.
Scenario: _2971023 check Storno is created from the customer advance BankReceipt 1
	And I close all client application windows
	* Open the advance BankReceipt 1 and run the Storno command
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I click the button named "FormDocumentStornoStorno"
	* Set the storno date after the basis date and post
		And I input "01.01.2026" text in the field named "Date"
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		Then system warning window does not appear
		And I delete "$$NumberStornoBR2971$$" variable
		And I save the value of "Number" field as "$$NumberStornoBR2971$$"
		And I click the button named "FormPostAndClose"
	* Check the storno exists and is posted
		Given I open hyperlink "e1cib/list/Document.Storno"
		And "List" table contains lines
			| 'Number'                  |
			| '$$NumberStornoBR2971$$'  |
	And I close all client application windows


# ADVANCE - stornoing the customer advance writes back its R5020 Partners balance movement with the
# opposite sign (the advance was offset into a customer transaction by CustomersAdvancesClosing 2, so it
# shows in the "Customer transaction" resource). The storno's own number/date is non-deterministic in a
# full run (it depends on how many stornos precede it), so the document-presentation and period cells
# are matched with the "*" wildcard; the reversed amounts and dimensions are matched exactly.
Scenario: _2971024 check Storno reverses BankReceipt advance movements in R5020 Partners balance
	And I close all client application windows
	* Open the BankReceipt storno via the basis back-reference
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I click the hyperlink named "DocStorno"
	* Generate the registrations report for R5020 Partners balance
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
	* Check the whole R5020 register output equals the advance written back with the opposite sign
		Then "ResultTable" spreadsheet document is equal
			| '*' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' |
			| 'Document registrations records' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' |
			| 'Register  "R5020 Partners balance"' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' | '' |
			| '' | 'Record type' | 'Period' | 'Resources' | '' | '' | '' | '' | '' | 'Dimensions' | '' | '' | '' | '' | '' | '' | '' | '' | 'Attributes' |
			| '' | '' | '' | 'Amount' | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company' | 'Branch' | 'Partner' | 'Legal name' | 'Agreement' | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| '' | 'Expense' | '*' | '-1 000' | '-1 000' | '' | '' | '' | '' | 'Own company 2' | 'Business unit 1' | 'Customer 2 (2 partner term)' | 'Client 2' | 'Individual partner term 1 (by partner term)' | '' | 'TRY' | 'Legal currency, TRY' | 'TRY' | '' |
			| '' | 'Expense' | '*' | '-1 000' | '-1 000' | '' | '' | '' | '' | 'Own company 2' | 'Business unit 1' | 'Customer 2 (2 partner term)' | 'Client 2' | 'Individual partner term 1 (by partner term)' | '' | 'TRY' | 'en description is empty' | 'TRY' | '' |
			| '' | 'Expense' | '*' | '-49,91' | '-49,91' | '' | '' | '' | '' | 'Own company 2' | 'Business unit 1' | 'Customer 2 (2 partner term)' | 'Client 2' | 'Individual partner term 1 (by partner term)' | '' | 'EUR' | 'Reporting currency, EUR' | 'TRY' | '' |
			| '' | 'Expense' | '*' | '' | '' | '' | '' | '' | '' | 'Own company 2' | 'Business unit 1' | 'Customer 2 (2 partner term)' | 'Client 2' | 'Individual partner term 1 (by partner term)' | '' | 'EUR' | 'Budgeting currency, EUR' | 'TRY' | '' |
	And I close all client application windows


# MOVEMENTS - cost recalculation after storno: re-running CalculationMovementCosts over the storno
# period must succeed - the batch balance recalc excludes the storno's R6010B records
# (R6020B: "not Recorder refs Document.Storno") and T6030S tolerates the missing point-in-time, so the
# stornoed batch is not double-counted and the calculation posts without errors.
Scenario: _2971021 check cost recalculation after storno excludes the stornoed batch and posts clean
	And I close all client application windows
	* Run cost calculation over the storno period (Jan 2026), where Sales invoice 1 has a posted storno
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I click the button named "FormCreate"
		And I input "31.01.2026" text in the field named "Date"
		And I select from the drop-down list named "Company" by "Own company 2" string
		And I select from the drop-down list named "CalculationMode" by "Landed cost" string
		And I input "01.01.2026" text in the field named "BeginDate"
		And I input "31.01.2026" text in the field named "EndDate"
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "60" seconds
	* Check the recalculation posted without warnings or errors
		Then system warning window does not appear
		Then user message window does not contain messages
		And I click the button named "FormPostAndClose"
	And I close all client application windows
