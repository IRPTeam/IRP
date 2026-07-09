#language: en
@tree
@Positive
@Advance

Feature: advances offset - settlements specification cases (overpayment, returns, currencies)

// Textbook scenarios as-is from the "Settlements" documentation (sections 4.2, 4.4, 4.9):
//   _1008002 - invoice overpayment: the surplus stays "hanging" on the payment document,
//              does NOT become an advance and is NOT touched by advances closing;
//   _1008003 - return against a fully paid invoice: negative transaction,
//              manual transfer to a customer advance via Debit/Credit note, the advance closes another invoice;
//   _1008004 - the settlement currency (USD) differs from the document currency (TRY):
//              the invoice is closed and the exchange difference is recorded in Customer transactions.
// Data: partner Ferron BP, dedicated "Offset mechanism*" agreements (Jul/Sep/Nov 2022),
// not overlapping with the 2021 data of _1002/_1003 nor with the _1007 periods (Jan/Mar/May).
// USD rate: 0.1712 until 08.11.2022, 0.16 from 08.11.2022 through 30.11.2022, then 0.1712 again
// (rows in Create information register CurrencyRates records).

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _1008000 preparation (advances offset specification cases)
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
		When Create information register Taxes records (VAT)
	* Load documents
		When Create document SalesInvoice objects (offset mechanism, spec cases)
		When Create document BankReceipt objects (offset mechanism, spec cases)
		When Create document SalesReturn objects (offset mechanism, spec cases)
		When Create document DebitCreditNote objects (offset mechanism, spec cases)
		# Posting in chain order (July: SI 75 -> BR 71; September: SI 76 -> BR 72 -> SR 71 -> DCN 71 -> SI 77; November: SI 78 -> BR 73)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(75).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(71).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(76).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(72).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(71).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.DebitCreditNote.FindByNumber(71).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(77).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(78).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(73).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows

Scenario: _10080001 check preparation
	When check preparation

Scenario: _1008002 overpayment stays hanging on the payment and is not turned into an advance
	# Spec 4.2: Bank receipt 71 (1 500) based on Sales invoice 75 (1 000).
	# The invoice is closed by the payment; the surplus 500 stays "hanging" on the payment document:
	# no advance is created, advances closing offsets nothing and does not touch the surplus.
	* Close July 2022
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I click the button named "FormCreate"
		And I input "31.07.2022 12:00:00" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Main Company'   |
		And I select current line in "List" table
		And I click Select button of "Begin of period" field
		And I input "01.07.2022" text in "Begin of period" field
		And I input "31.07.2022" text in "End of period" field
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'               |
			| 'Distribution department'   |
		And I select current line in "List" table
		And I click the button named "FormPost"
		And I delete "$$NumberClosingJul2022$$" variable
		And I save the value of "Number" field as "$$NumberClosingJul2022$$"
		And I click "Post and close" button
	* Full picture in Customers transactions - invoice due 1000, payment expense 1500, both without closing
		Given I open hyperlink "e1cib/list/AccumulationRegister.R2021B_CustomersTransactions"
		And "List" table contains lines
			| 'Recorder'                                    | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'         | 'Partner'    | 'Agreement'                          | 'Basis'                                       | 'Amount'    | 'Customers advances closing' |
			| 'Sales invoice 75 dated 05.07.2022 12:00:00'  | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP'  | 'Ferron BP'  | 'Offset mechanism overpayment, TRY'  | 'Sales invoice 75 dated 05.07.2022 12:00:00'  | '1 000,00'  | ''                           |
			| 'Sales invoice 75 dated 05.07.2022 12:00:00'  | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP'  | 'Ferron BP'  | 'Offset mechanism overpayment, TRY'  | 'Sales invoice 75 dated 05.07.2022 12:00:00'  | '171,20'    | ''                           |
			| 'Sales invoice 75 dated 05.07.2022 12:00:00'  | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP'  | 'Ferron BP'  | 'Offset mechanism overpayment, TRY'  | 'Sales invoice 75 dated 05.07.2022 12:00:00'  | '1 000,00'  | ''                           |
			| 'Bank receipt 71 dated 10.07.2022 12:00:00'   | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP'  | 'Ferron BP'  | 'Offset mechanism overpayment, TRY'  | 'Sales invoice 75 dated 05.07.2022 12:00:00'  | '1 500,00'  | ''                           |
			| 'Bank receipt 71 dated 10.07.2022 12:00:00'   | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP'  | 'Ferron BP'  | 'Offset mechanism overpayment, TRY'  | 'Sales invoice 75 dated 05.07.2022 12:00:00'  | '256,80'    | ''                           |
			| 'Bank receipt 71 dated 10.07.2022 12:00:00'   | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP'  | 'Ferron BP'  | 'Offset mechanism overpayment, TRY'  | 'Sales invoice 75 dated 05.07.2022 12:00:00'  | '1 500,00'  | ''                           |
	* The advances closing must not touch the overpaid pair
		And "List" table does not contain lines
			| 'Recorder'                                    | 'Customers advances closing'                                                        |
			| 'Sales invoice 75 dated 05.07.2022 12:00:00'  | 'Customers advance closing $$NumberClosingJul2022$$ dated 31.07.2022 12:00:00'      |
		And "List" table does not contain lines
			| 'Recorder'                                    | 'Customers advances closing'                                                        |
			| 'Bank receipt 71 dated 10.07.2022 12:00:00'   | 'Customers advance closing $$NumberClosingJul2022$$ dated 31.07.2022 12:00:00'      |
		And I close all client application windows
	* No advance is created from the excess - the payment has no rows in the advances register
		Given I open hyperlink "e1cib/list/AccumulationRegister.R2020B_AdvancesFromCustomers"
		And "List" table does not contain lines
			| 'Recorder'                                   |
			| 'Bank receipt 71 dated 10.07.2022 12:00:00'  |
		And I close all client application windows

Scenario: _1008003 return on a fully paid invoice is moved to an advance by Debit credit note and closes another invoice
	# Spec 4.4: Sales invoice 76 (1 000) fully paid by Bank receipt 72 (1 000, based on it).
	# Sales return 71 (300) against the closed invoice -> negative transaction on the return.
	# Debit/Credit note 71 transfers it into a customer advance (300). Sales invoice 77 (500) is open.
	# September closing: the advance 300 closes SI 77 by 300, remaining debt 200.
	* Close September 2022
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I click the button named "FormCreate"
		And I input "30.09.2022 12:00:00" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Main Company'   |
		And I select current line in "List" table
		And I click Select button of "Begin of period" field
		And I input "01.09.2022" text in "Begin of period" field
		And I input "30.09.2022" text in "End of period" field
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'               |
			| 'Distribution department'   |
		And I select current line in "List" table
		And I click the button named "FormPost"
		And I delete "$$NumberClosingSep2022$$" variable
		And I save the value of "Number" field as "$$NumberClosingSep2022$$"
		And I click "Post and close" button
	* Full picture in Customers transactions - paid invoice, negative return transaction, DCN transfer, offset of SI 77
		Given I open hyperlink "e1cib/list/AccumulationRegister.R2021B_CustomersTransactions"
		And "List" table contains lines
			| 'Recorder'                                    | 'Multi currency movement type' | 'Currency' | 'Partner'    | 'Agreement'                      | 'Basis'                                       | 'Amount'    | 'Customers advances closing' |
			| 'Sales invoice 76 dated 01.09.2022 12:00:00'  | 'Local currency'               | 'TRY'      | 'Ferron BP'  | 'Offset mechanism returns, TRY'  | 'Sales invoice 76 dated 01.09.2022 12:00:00'  | '1 000,00'  | ''                           |
			| 'Bank receipt 72 dated 05.09.2022 12:00:00'   | 'Local currency'               | 'TRY'      | 'Ferron BP'  | 'Offset mechanism returns, TRY'  | 'Sales invoice 76 dated 01.09.2022 12:00:00'  | '1 000,00'  | ''                           |
			| 'Sales return 71 dated 10.09.2022 12:00:00'   | 'Local currency'               | 'TRY'      | 'Ferron BP'  | 'Offset mechanism returns, TRY'  | 'Sales return 71 dated 10.09.2022 12:00:00'   | '-300,00'   | ''                           |
			| 'Sales return 71 dated 10.09.2022 12:00:00'   | 'Reporting currency'           | 'USD'      | 'Ferron BP'  | 'Offset mechanism returns, TRY'  | 'Sales return 71 dated 10.09.2022 12:00:00'   | '-51,36'    | ''                           |
		# The Debit/Credit note records a single settlement-currency row (movement type
		# "en description is empty"): it clears the negative return transaction, Amount -300,00.
		And "List" table contains lines
			| 'Recorder'                                       | 'Multi currency movement type' | 'Partner'    | 'Agreement'                      | 'Basis'                                      | 'Amount'   |
			| 'Debit/Credit note 71 dated 15.09.2022 12:00:00' | 'en description is empty'      | 'Ferron BP'  | 'Offset mechanism returns, TRY'  | 'Sales return 71 dated 10.09.2022 12:00:00'  | '-300,00'  |
		And "List" table contains lines
			| 'Recorder'                                    | 'Multi currency movement type' | 'Currency' | 'Partner'    | 'Agreement'                      | 'Basis'                                       | 'Amount'   | 'Customers advances closing'                                                        |
			| 'Sales invoice 77 dated 20.09.2022 12:00:00'  | 'Local currency'               | 'TRY'      | 'Ferron BP'  | 'Offset mechanism returns, TRY'  | 'Sales invoice 77 dated 20.09.2022 12:00:00'  | '300,00'   | 'Customers advance closing $$NumberClosingSep2022$$ dated 30.09.2022 12:00:00'      |
			| 'Sales invoice 77 dated 20.09.2022 12:00:00'  | 'Reporting currency'           | 'USD'      | 'Ferron BP'  | 'Offset mechanism returns, TRY'  | 'Sales invoice 77 dated 20.09.2022 12:00:00'  | '51,36'    | 'Customers advance closing $$NumberClosingSep2022$$ dated 30.09.2022 12:00:00'      |
	* SI 77 is closed only by 300 - the remaining 200 stays open
		And "List" table does not contain lines
			| 'Recorder'                                    | 'Amount'   | 'Customers advances closing'                                                        |
			| 'Sales invoice 77 dated 20.09.2022 12:00:00'  | '500,00'   | 'Customers advance closing $$NumberClosingSep2022$$ dated 30.09.2022 12:00:00'      |
		And I close all client application windows
	* Full picture in Advances from customers - DCN created the advance, the closing spent it
		Given I open hyperlink "e1cib/list/AccumulationRegister.R2020B_AdvancesFromCustomers"
		And "List" table contains lines
			| 'Recorder'                                       | 'Multi currency movement type' | 'Currency' | 'Partner'    | 'Agreement'                      | 'Amount'   | 'Customers advances closing'                                                        |
			| 'Debit/Credit note 71 dated 15.09.2022 12:00:00' | 'Local currency'               | 'TRY'      | 'Ferron BP'  | 'Offset mechanism returns, TRY'  | '-300,00'  | ''                                                                                  |
			| 'Debit/Credit note 71 dated 15.09.2022 12:00:00' | 'Reporting currency'           | 'USD'      | 'Ferron BP'  | 'Offset mechanism returns, TRY'  | '-51,36'   | ''                                                                                  |
			| 'Sales invoice 77 dated 20.09.2022 12:00:00'     | 'Local currency'               | 'TRY'      | 'Ferron BP'  | 'Offset mechanism returns, TRY'  | '300,00'   | 'Customers advance closing $$NumberClosingSep2022$$ dated 30.09.2022 12:00:00'      |
			| 'Sales invoice 77 dated 20.09.2022 12:00:00'     | 'Reporting currency'           | 'USD'      | 'Ferron BP'  | 'Offset mechanism returns, TRY'  | '51,36'    | 'Customers advance closing $$NumberClosingSep2022$$ dated 30.09.2022 12:00:00'      |
		And I close all client application windows

Scenario: _1008004 payment in local currency under a USD settlement agreement - invoice closes with an exchange difference
	# Spec 4.9: agreement "Offset mechanism settlement, USD" (settlement currency USD),
	# documents in TRY. Sales invoice 78 (1 000 TRY = 171,20 USD at rate 0,1712 on 05.11.2022),
	# advance Bank receipt 73 (1 000 TRY = 160,00 USD at rate 0,16 on 10.11.2022).
	# Closing: the invoice is closed, the 11,20 USD difference is an exchange difference (management accounting).
	* Close November 2022
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I click the button named "FormCreate"
		And I input "30.11.2022 12:00:00" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Main Company'   |
		And I select current line in "List" table
		And I click Select button of "Begin of period" field
		And I input "01.11.2022" text in "Begin of period" field
		And I input "30.11.2022" text in "End of period" field
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'               |
			| 'Distribution department'   |
		And I select current line in "List" table
		And I click the button named "FormPost"
		And I delete "$$NumberClosingNov2022$$" variable
		And I save the value of "Number" field as "$$NumberClosingNov2022$$"
		And I click "Post and close" button
	* Full picture before offset - advance 1000 TRY / 160 USD, invoice 1000 TRY / 171.20 USD
		# The settlement agreement currency is USD, so Transaction currency is USD on every row.
		Given I open hyperlink "e1cib/list/AccumulationRegister.R2020B_AdvancesFromCustomers"
		And "List" table contains lines
			| 'Recorder'                                   | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Partner'    | 'Agreement'                        | 'Amount'    |
			| 'Bank receipt 73 dated 10.11.2022 12:00:00'  | 'Local currency'               | 'TRY'      | 'USD'                  | 'Ferron BP'  | 'Offset mechanism settlement, USD' | '1 000,00'  |
			| 'Bank receipt 73 dated 10.11.2022 12:00:00'  | 'Reporting currency'           | 'USD'      | 'USD'                  | 'Ferron BP'  | 'Offset mechanism settlement, USD' | '160,00'    |
			| 'Bank receipt 73 dated 10.11.2022 12:00:00'  | 'en description is empty'      | 'USD'      | 'USD'                  | 'Ferron BP'  | 'Offset mechanism settlement, USD' | '160,00'    |
		And I close all client application windows
		Given I open hyperlink "e1cib/list/AccumulationRegister.R2021B_CustomersTransactions"
		And "List" table contains lines
			| 'Recorder'                                    | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Partner'    | 'Agreement'                        | 'Basis'                                       | 'Amount'    |
			| 'Sales invoice 78 dated 05.11.2022 12:00:00'  | 'Local currency'               | 'TRY'      | 'USD'                  | 'Ferron BP'  | 'Offset mechanism settlement, USD' | 'Sales invoice 78 dated 05.11.2022 12:00:00'  | '1 000,00'  |
			| 'Sales invoice 78 dated 05.11.2022 12:00:00'  | 'Reporting currency'           | 'USD'      | 'USD'                  | 'Ferron BP'  | 'Offset mechanism settlement, USD' | 'Sales invoice 78 dated 05.11.2022 12:00:00'  | '171,20'    |
			| 'Sales invoice 78 dated 05.11.2022 12:00:00'  | 'en description is empty'      | 'USD'      | 'USD'                  | 'Ferron BP'  | 'Offset mechanism settlement, USD' | 'Sales invoice 78 dated 05.11.2022 12:00:00'  | '171,20'    |
	* The closing offsets the advance against the invoice - local amount closes in full
		# The offset is recorded on the advance recorder (Bank receipt 73) with the invoice as
		# Basis: locally it closes 900,40 TRY, in the settlement currency 160,00 USD.
		And "List" table contains lines
			| 'Recorder'                                   | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Basis'                                       | 'Amount'  | 'Customers advances closing'                                                        |
			| 'Bank receipt 73 dated 10.11.2022 12:00:00'  | 'Local currency'               | 'TRY'      | 'USD'                  | 'Sales invoice 78 dated 05.11.2022 12:00:00'  | '900,40'  | 'Customers advance closing $$NumberClosingNov2022$$ dated 30.11.2022 12:00:00'      |
			| 'Bank receipt 73 dated 10.11.2022 12:00:00'  | 'Reporting currency'           | 'USD'      | 'USD'                  | 'Sales invoice 78 dated 05.11.2022 12:00:00'  | '160,00'  | 'Customers advance closing $$NumberClosingNov2022$$ dated 30.11.2022 12:00:00'      |
		And I close all client application windows
		Given I open hyperlink "e1cib/list/AccumulationRegister.R2020B_AdvancesFromCustomers"
		And "List" table contains lines
			| 'Recorder'                                   | 'Multi currency movement type' | 'Amount'  | 'Customers advances closing'                                                        |
			| 'Bank receipt 73 dated 10.11.2022 12:00:00'  | 'Local currency'               | '900,40'  | 'Customers advance closing $$NumberClosingNov2022$$ dated 30.11.2022 12:00:00'      |
		And I close all client application windows
