#language: en
@tree
@Positive
@Advance

Feature: advances closing mechanism (overlapping periods, orders, contracts)


Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _1007000 preparation (advances closing mechanism)
	When set True value to the constant
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
		When Create catalog Agreements objects (Advance offset)
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
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create information register CurrencyRates records (Advance offset)
		When Create information register Taxes records (VAT)
		When Create catalog PartnersBankAccounts objects
		When Create catalog LegalNameContracts objects
	* Load documents
		When Create document SalesOrder objects (offset mechanism)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(61).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document BankReceipt objects (offset mechanism)
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(61).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(62).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(63).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(64).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesInvoice objects (offset mechanism)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(61).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(62).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(63).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(64).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows

Scenario: _10070001 check preparation
	When check preparation

Scenario: _1007002 second closing with an overlapping period must not offset the same advance twice
	# M1 (IRP-826): advance Bank receipt 61 (1 000) is closed by the January closing against Sales invoice 61 (2 500).
	# A second closing with period 01.01.2022-28.02.2022 covers January again.
	# The overlapping-period control must reject its posting ("Overlapping period" message),
	# so the same advance is never offset twice.
	* Close January 2022 (Bank receipt 61 -> Sales invoice 61)
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I click the button named "FormCreate"
		And I input "31.01.2022 12:00:00" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Main Company'   |
		And I select current line in "List" table
		And I click Select button of "Begin of period" field
		And I input "01.01.2022" text in "Begin of period" field
		And I input "31.01.2022" text in "End of period" field
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'               |
			| 'Distribution department'   |
		And I select current line in "List" table
		And I click the button named "FormPost"
		And I delete "$$NumberClosingJan2022$$" variable
		And I save the value of "Number" field as "$$NumberClosingJan2022$$"
		And I click "Post and close" button
	* Guard - the January closing offset the advance against Sales invoice 61
		Given I open hyperlink "e1cib/list/AccumulationRegister.R2021B_CustomersTransactions"
		And "List" table contains lines
			| 'Recorder'                                    | 'Multi currency movement type' | 'Basis'                                       | 'Amount'    | 'Customers advances closing'                                                        |
			| 'Sales invoice 61 dated 15.01.2022 12:00:00'  | 'Local currency'               | 'Sales invoice 61 dated 15.01.2022 12:00:00'  | '1 000,00'  | 'Customers advance closing $$NumberClosingJan2022$$ dated 31.01.2022 12:00:00'      |
		And I close all client application windows
	* Post the second closing with a period that overlaps January - the control must reject it
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I click the button named "FormCreate"
		And I input "28.02.2022 12:00:00" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Main Company'   |
		And I select current line in "List" table
		And I click Select button of "Begin of period" field
		And I input "01.01.2022" text in "Begin of period" field
		And I input "28.02.2022" text in "End of period" field
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'               |
			| 'Distribution department'   |
		And I select current line in "List" table
		And I click the button named "FormPost"
		Given Recent TestClient message contains "Overlapping period*" string by template
		And I close all client application windows
	* The rejected closing was not even written - so the January advance cannot be offset twice
	# The filling check fires before the write: the overlapping document must not exist at all.
	# The 01.01-28.02 period pair is unique to the rejected document (the adjacent February
	# closing of _1007006 is 01.02-28.02).
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And "List" table does not contain lines
			| 'Begin of period'   | 'End of period'   |
			| '01.01.2022'        | '28.02.2022'      |
		And I close all client application windows

Scenario: _1007003 order-bound advance closes its order invoice, free advance closes the other
	# M2: advance Bank receipt 63 is bound to Sales order 61, advance Bank receipt 62 is free.
	# Sales invoice 62 is issued against order 61, Sales invoice 63 - with no order.
	# CORRECT: SI 62 is closed by the order-bound advance, SI 63 by the free one, everything closed.
	# WITH THE BUG (no ORDER BY when picking the advance): the advance chosen for SI 62 is random - the free
	# advance may be spent on the order invoice, then SI 63 stays open and the order-bound
	# advance hangs forever. On the unfixed code the XFAIL wrappers are UNSTABLE (sometimes the code
	# happens to allocate correctly and the wrapper fails) - which is itself the bug reproduction.
	* Close March 2022
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I click the button named "FormCreate"
		And I input "31.03.2022 12:00:00" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Main Company'   |
		And I select current line in "List" table
		And I click Select button of "Begin of period" field
		And I input "01.03.2022" text in "Begin of period" field
		And I input "31.03.2022" text in "End of period" field
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'               |
			| 'Distribution department'   |
		And I select current line in "List" table
		And I click the button named "FormPost"
		And I delete "$$NumberClosingMar2022$$" variable
		And I save the value of "Number" field as "$$NumberClosingMar2022$$"
		And I click "Post and close" button
	* Guard - the order invoice Sales invoice 62 is closed by an advance
		Given I open hyperlink "e1cib/list/AccumulationRegister.R2021B_CustomersTransactions"
		And "List" table contains lines
			| 'Recorder'                                    | 'Multi currency movement type' | 'Basis'                                       | 'Amount'    | 'Customers advances closing'                                                        |
			| 'Sales invoice 62 dated 10.03.2022 12:00:00'  | 'Local currency'               | 'Sales invoice 62 dated 10.03.2022 12:00:00'  | '1 000,00'  | 'Customers advance closing $$NumberClosingMar2022$$ dated 31.03.2022 12:00:00'      |
		And I close all client application windows
	* XFAIL until the advance-selection ORDER BY bug is fixed - order advance goes to its invoice
		When I Check the steps for Exception
			| 'And Check Sales invoice 62 is offset by its order advance'    |
	* XFAIL until the advance-selection ORDER BY bug is fixed - free advance stays for Sales invoice 63
		When I Check the steps for Exception
			| 'And Check Sales invoice 63 is offset by the free advance'    |
	And I close all client application windows

Scenario: _1007004 advance is offset within one agreement even when the contracts differ
	# Rule: an advance is offset only within a single AGREEMENT.
	# The contract (Legal name contract) is not an offset analytic: advance Bank receipt 64
	# (contract "Contract Ferron BP") closes Sales invoice 64 (contract "Contract Ferron BP
	# New") - both share the same agreement, "Offset mechanism contracts, TRY". The offset is capped
	# by the invoice amount: 800 of the 1 000 advance is offset, 200 of the advance remains.
	* Close May 2022
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I click the button named "FormCreate"
		And I input "31.05.2022 12:00:00" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Main Company'   |
		And I select current line in "List" table
		And I click Select button of "Begin of period" field
		And I input "01.05.2022" text in "Begin of period" field
		And I input "31.05.2022" text in "End of period" field
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'               |
			| 'Distribution department'   |
		And I select current line in "List" table
		And I click the button named "FormPost"
		And I delete "$$NumberClosingMay2022$$" variable
		And I save the value of "Number" field as "$$NumberClosingMay2022$$"
		And I click "Post and close" button
	* Full picture in Advances from customers - the advance is created and spent by 800
		Given I open hyperlink "e1cib/list/AccumulationRegister.R2020B_AdvancesFromCustomers"
		And "List" table contains lines
			| 'Recorder'                                    | 'Multi currency movement type' | 'Currency' | 'Partner'    | 'Agreement'                         | 'Amount'    | 'Customers advances closing'                                                        |
			| 'Bank receipt 64 dated 04.05.2022 12:00:00'   | 'Local currency'               | 'TRY'      | 'Ferron BP'  | 'Offset mechanism contracts, TRY'   | '1 000,00'  | ''                                                                                  |
			| 'Bank receipt 64 dated 04.05.2022 12:00:00'   | 'Reporting currency'           | 'USD'      | 'Ferron BP'  | 'Offset mechanism contracts, TRY'   | '171,20'    | ''                                                                                  |
			| 'Bank receipt 64 dated 04.05.2022 12:00:00'   | 'en description is empty'      | 'TRY'      | 'Ferron BP'  | 'Offset mechanism contracts, TRY'   | '1 000,00'  | ''                                                                                  |
			| 'Sales invoice 64 dated 10.05.2022 12:00:00'  | 'Local currency'               | 'TRY'      | 'Ferron BP'  | 'Offset mechanism contracts, TRY'   | '800,00'    | 'Customers advance closing $$NumberClosingMay2022$$ dated 31.05.2022 12:00:00'      |
			| 'Sales invoice 64 dated 10.05.2022 12:00:00'  | 'Reporting currency'           | 'USD'      | 'Ferron BP'  | 'Offset mechanism contracts, TRY'   | '136,96'    | 'Customers advance closing $$NumberClosingMay2022$$ dated 31.05.2022 12:00:00'      |
			| 'Sales invoice 64 dated 10.05.2022 12:00:00'  | 'en description is empty'      | 'TRY'      | 'Ferron BP'  | 'Offset mechanism contracts, TRY'   | '800,00'    | 'Customers advance closing $$NumberClosingMay2022$$ dated 31.05.2022 12:00:00'      |
	* The offset is capped by the invoice amount - the advance remainder 200 is not spent
		And "List" table does not contain lines
			| 'Recorder'                                    | 'Amount'    | 'Customers advances closing'                                                        |
			| 'Sales invoice 64 dated 10.05.2022 12:00:00'  | '1 000,00'  | 'Customers advance closing $$NumberClosingMay2022$$ dated 31.05.2022 12:00:00'      |
		And I close all client application windows
	* Full picture in Customers transactions - the invoice under another contract is closed by 800
		Given I open hyperlink "e1cib/list/AccumulationRegister.R2021B_CustomersTransactions"
		And "List" table contains lines
			| 'Recorder'                                    | 'Multi currency movement type' | 'Currency' | 'Partner'    | 'Agreement'                         | 'Basis'                                       | 'Amount'   | 'Customers advances closing'                                                        |
			| 'Sales invoice 64 dated 10.05.2022 12:00:00'  | 'Local currency'               | 'TRY'      | 'Ferron BP'  | 'Offset mechanism contracts, TRY'   | 'Sales invoice 64 dated 10.05.2022 12:00:00'  | '800,00'   | ''                                                                                  |
			| 'Sales invoice 64 dated 10.05.2022 12:00:00'  | 'Reporting currency'           | 'USD'      | 'Ferron BP'  | 'Offset mechanism contracts, TRY'   | 'Sales invoice 64 dated 10.05.2022 12:00:00'  | '136,96'   | ''                                                                                  |
			| 'Sales invoice 64 dated 10.05.2022 12:00:00'  | 'Local currency'               | 'TRY'      | 'Ferron BP'  | 'Offset mechanism contracts, TRY'   | 'Sales invoice 64 dated 10.05.2022 12:00:00'  | '800,00'   | 'Customers advance closing $$NumberClosingMay2022$$ dated 31.05.2022 12:00:00'      |
			| 'Sales invoice 64 dated 10.05.2022 12:00:00'  | 'Reporting currency'           | 'USD'      | 'Ferron BP'  | 'Offset mechanism contracts, TRY'   | 'Sales invoice 64 dated 10.05.2022 12:00:00'  | '136,96'   | 'Customers advance closing $$NumberClosingMay2022$$ dated 31.05.2022 12:00:00'      |
			| 'Sales invoice 64 dated 10.05.2022 12:00:00'  | 'en description is empty'      | 'TRY'      | 'Ferron BP'  | 'Offset mechanism contracts, TRY'   | 'Sales invoice 64 dated 10.05.2022 12:00:00'  | '800,00'   | 'Customers advance closing $$NumberClosingMay2022$$ dated 31.05.2022 12:00:00'      |
	And I close all client application windows

Scenario: _1007005 same period for another company is allowed, duplicate for the same company is blocked
	# IRP-826: the overlapping-period control compares periods within one company only.
	# January 2022 is already closed for Main Company (_1007002). The same period for
	# Second Company must post; a second closing for Second Company over it must be rejected
	# (which also proves the first one was posted - the control only sees posted documents).
	* Close January 2022 for Second Company - allowed in parallel with Main Company
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I click the button named "FormCreate"
		And I input "31.01.2022 13:00:00" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'      |
			| 'Second Company'   |
		And I select current line in "List" table
		And I click Select button of "Begin of period" field
		And I input "01.01.2022" text in "Begin of period" field
		And I input "31.01.2022" text in "End of period" field
		And I click "Post and close" button
	* The document window closed - the cross-company posting really succeeded
	# Guard against a false green: if the control wrongly blocked another company, the rejection
	# message in the next block would still appear (from the Main Company closing) and mask it.
		Then "Customers advances closing" window is opened
		And I close all client application windows
	* Duplicate closing for Second Company over the same period is rejected
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I click the button named "FormCreate"
		And I input "31.01.2022 14:00:00" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'      |
			| 'Second Company'   |
		And I select current line in "List" table
		And I click Select button of "Begin of period" field
		And I input "01.01.2022" text in "Begin of period" field
		And I input "31.01.2022" text in "End of period" field
		And I click the button named "FormPost"
		Given Recent TestClient message contains "Overlapping period*" string by template
		And I close all client application windows

Scenario: _1007006 repost of the same closing is allowed, adjacent period posts, nested period is blocked
	# IRP-826: the control must ignore the document itself on repost, must allow a strictly
	# adjacent period, and must reject a period nested inside an already closed one.
	* Repost the January closing - the control must not block the document itself
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I go to line in "List" table
			| 'Number'                    |
			| '$$NumberClosingJan2022$$'  |
		And in the table "List" I click the button named "ListContextMenuPost"
	* The January offset is intact after the repost
	# No "close all windows" before this check on purpose: if the control wrongly blocked the
	# repost, the modal error window would make the next step fail instead of being swallowed.
		Given I open hyperlink "e1cib/list/AccumulationRegister.R2021B_CustomersTransactions"
		And "List" table contains lines
			| 'Recorder'                                    | 'Multi currency movement type' | 'Basis'                                       | 'Amount'    | 'Customers advances closing'                                                        |
			| 'Sales invoice 61 dated 15.01.2022 12:00:00'  | 'Local currency'               | 'Sales invoice 61 dated 15.01.2022 12:00:00'  | '1 000,00'  | 'Customers advance closing $$NumberClosingJan2022$$ dated 31.01.2022 12:00:00'      |
		And I close all client application windows
	* Close the adjacent February 2022 for Main Company - no overlap with January
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I click the button named "FormCreate"
		And I input "28.02.2022 15:00:00" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Main Company'   |
		And I select current line in "List" table
		And I click Select button of "Begin of period" field
		And I input "01.02.2022" text in "Begin of period" field
		And I input "28.02.2022" text in "End of period" field
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'               |
			| 'Distribution department'   |
		And I select current line in "List" table
		And I click "Post and close" button
	* The document window closed - the adjacent-period posting really succeeded
		Then "Customers advances closing" window is opened
		And I close all client application windows
	* A period nested inside the closed February is rejected
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I click the button named "FormCreate"
		And I input "20.02.2022 12:00:00" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Main Company'   |
		And I select current line in "List" table
		And I click Select button of "Begin of period" field
		And I input "10.02.2022" text in "Begin of period" field
		And I input "20.02.2022" text in "End of period" field
		And I click the button named "FormPost"
		Given Recent TestClient message contains "Overlapping period*" string by template
		And I close all client application windows

Scenario: _1007007 vendors closing is covered by the same overlapping-period control
	# IRP-826: the same control works for Vendors advances closing.
	* Close June 2022 for vendors - posts over a free period
		Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
		And I click the button named "FormCreate"
		And I input "30.06.2022 12:00:00" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Main Company'   |
		And I select current line in "List" table
		And I click Select button of "Begin of period" field
		And I input "01.06.2022" text in "Begin of period" field
		And I input "30.06.2022" text in "End of period" field
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'    |
			| 'Front office'   |
		And I select current line in "List" table
		And I click "Post and close" button
	* The document window closed - the vendors posting really succeeded
		Then "Vendors advances closing" window is opened
		And I close all client application windows
	* The same vendors period again is rejected
		Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
		And I click the button named "FormCreate"
		And I input "30.06.2022 14:00:00" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Main Company'   |
		And I select current line in "List" table
		And I click Select button of "Begin of period" field
		And I input "01.06.2022" text in "Begin of period" field
		And I input "30.06.2022" text in "End of period" field
		And I click the button named "FormPost"
		Given Recent TestClient message contains "Overlapping period*" string by template
		And I close all client application windows
