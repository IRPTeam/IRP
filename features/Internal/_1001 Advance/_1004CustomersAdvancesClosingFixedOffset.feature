#language: en
@tree
@Positive
@Advance


Feature: customers advances closing - fixed offset of advances

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _1004000 preparation (customers advances closing fixed offset)
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
	* Load documents
		When Create document BankReceipt objects (advance)
		When Create document BankReceipt objects (advance, BR-SI)
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(6).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document CashReceipt objects (advance)
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"    |
		# Load SO
		When Create document SalesOrder objects (check movements, SC before SI, Use shipment sheduling)
		When Create document SalesOrder objects (advance, movements)
		When Create document SalesOrder objects (check movements, SC before SI, not Use shipment sheduling)
		When Create document SalesOrder objects (check movements, SI before SC, not Use shipment sheduling)
		And I execute 1C:Enterprise script at server
				| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
				| "Documents.SalesOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
				| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"     |
		# Load SC
		When Create document ShipmentConfirmation objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		# Load SI
		When Create document SalesInvoice objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		# Load customers advances (full block as in _1003 - CR 6 refers to Sales return 12)
		When Create document BankReceipt objects (advance, customers)
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document CashReceipt objects (advance, customers)
		When Create document CreditNote objects (advance, customers)
		When Create document DebitNote objects (advance, customers)
		When Create document SalesReturn objects (advance, customers)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(6).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Second advance key for bug 1 - copy of Cash receipt 6 with Order filled
		And I execute 1C:Enterprise script at server
			| "Doc = Documents.CashReceipt.FindByNumber(6).GetObject().Copy(); Doc.Date = Date(2021,1,27,20,0,0); Doc.PaymentList[0].Order = Documents.SalesOrder.FindByNumber(1); Doc.Write(DocumentWriteMode.Posting);"    |
	* Unpost advance closings covering 27-28.01.2021 (left posted by _1003) - the overlapping-period control would block posting the pinned closing over them
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I go to line in "List" table
			| 'Date'          |
			| '27.01.2021'    |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I go to line in "List" table
			| 'Number'    |
			| '9'         |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I close all client application windows

Scenario: _10040001 check preparation
	When check preparation


Scenario: _1004002 add fixed offset row prompts to write unsaved document
	* Create a new closing document but do not save it yet (empty period 13.01 - no offsets)
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I click the button named "FormCreate"
		And I input "13.01.2021 12:00:00" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Main Company'   |
		And I select current line in "List" table
		And I click Select button of "Begin of period" field
		And I input "13.01.2021" text in "Begin of period" field
		And I input "13.01.2021" text in "End of period" field
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'               |
			| 'Distribution department'   |
		And I select current line in "List" table
	* Adding a row on the unsaved document raises the write prompt
		And in the table "FixedOffsetOfAdvances" I click the button named "FixedOffsetOfAdvancesAdd"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
	* After writing, the new row appears prefilled (Company from the document header)
		And "FixedOffsetOfAdvances" table contains lines
			| 'Company'        |
			| 'Main Company'   |
		And I delete "$$NumberFOClosingUI$$" variable
		And I save the value of "Number" field as "$$NumberFOClosingUI$$"
		And I click "Post and close" button
		And I close all client application windows


Scenario: _1004003 fill and save a fixed offset row to the register
	* Open the closing document created above
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$NumberFOClosingUI$$'   |
		And I select current line in "List" table
	* Add and fill a fixed offset row (document is already saved -> no prompt)
		# IMPORTANT (bug 7): the Agreement is selected BEFORE the Partner is filled - the agreement
		# list filter by CurrentData.Partner hides segment agreements with an empty partner
		# ('Basic Partner terms, TRY'). With an empty Partner the filter shows exactly those.
		And in the table "FixedOffsetOfAdvances" I click the button named "FixedOffsetOfAdvancesAdd"
		And I click choice button of "Currency" attribute in "FixedOffsetOfAdvances" table
		And I go to line in "List" table
			| 'Code'          |
			| 'TRY'           |
		And I select current line in "List" table
		And I activate "Agreement" field in "FixedOffsetOfAdvances" table
		And I click choice button of "Agreement" attribute in "FixedOffsetOfAdvances" table
		And I go to line in "List" table
			| 'Description'                |
			| 'Basic Partner terms, TRY'   |
		And I select current line in "List" table
		And I activate "Partner" field in "FixedOffsetOfAdvances" table
		And I click choice button of "Partner" attribute in "FixedOffsetOfAdvances" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Ferron BP'     |
		And I select current line in "List" table
		And I activate "Legal name" field in "FixedOffsetOfAdvances" table
		And I click choice button of "Legal name" attribute in "FixedOffsetOfAdvances" table
		And I go to line in "List" table
			| 'Description'         |
			| 'Company Ferron BP'   |
		And I select current line in "List" table
		And I activate "Transaction document" field in "FixedOffsetOfAdvances" table
		And I click choice button of "Transaction document" attribute in "FixedOffsetOfAdvances" table
		Then "Select data type" window is opened
		And I go to line in "" table
			| ''                |
			| 'Sales invoice'   |
		And I select current line in "" table
		And I go to line in "List" table
			| 'Number'   |
			| '3'        |
		And I select current line in "List" table
		And I finish line editing in "FixedOffsetOfAdvances" table
	* Save fixed offset to the register
		And I click the button named "FixedOffsetOfAdvancesSaveFixedOffset"
		And I click "Post and close" button
	* Verify the pin was written to InformationRegister.T2018S_FixedOffsetOfAdvances
		Given I open hyperlink "e1cib/list/InformationRegister.T2018S_FixedOffsetOfAdvances"
		And "List" table contains lines
			| 'Is fixed'   | 'Company'        | 'Partner'     | 'Currency'   |
			| 'Yes'        | 'Main Company'   | 'Ferron BP'   | 'TRY'        |
		And I close all client application windows


Scenario: _1004004 create closing with a pinned invoice (SI 2)
	# Intent: pin Sales invoice 2 to an advance. The user does NOT enter the pin amount -
	# an advance cannot be offset by a partial amount (rule: advance 1 000 + invoice 600 ->
	# offset exactly 600; you cannot "drop" an arbitrary 500 onto the invoice). Amount is filled
	# by the mechanism on posting.
	# Ferron BP advances as of 28.01: Cash receipt 6 (3 900, no order) + its copy (3 900, Order SO 1).
	# Chronological order without a pin: SI 1 (18:48) first, then SI 2 (18:49), SI 3 (18:50).
	* Create and write the closing document
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I click the button named "FormCreate"
		And I input "29.01.2021 12:00:00" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Main Company'   |
		And I select current line in "List" table
		And I click Select button of "Begin of period" field
		And I input "27.01.2021" text in "Begin of period" field
		And I input "28.01.2021" text in "End of period" field
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'               |
			| 'Distribution department'   |
		And I select current line in "List" table
		And I click the button named "FormWrite"
	* Add the pin row: Ferron BP, TRY, Sales invoice 2, Amount 500
		# IMPORTANT (bug 7): Agreement is selected BEFORE Partner - see the comment in _1004003.
		And in the table "FixedOffsetOfAdvances" I click the button named "FixedOffsetOfAdvancesAdd"
		And I click choice button of "Currency" attribute in "FixedOffsetOfAdvances" table
		And I go to line in "List" table
			| 'Code'          |
			| 'TRY'           |
		And I select current line in "List" table
		And I activate "Agreement" field in "FixedOffsetOfAdvances" table
		And I click choice button of "Agreement" attribute in "FixedOffsetOfAdvances" table
		And I go to line in "List" table
			| 'Description'                |
			| 'Basic Partner terms, TRY'   |
		And I select current line in "List" table
		And I activate "Partner" field in "FixedOffsetOfAdvances" table
		And I click choice button of "Partner" attribute in "FixedOffsetOfAdvances" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Ferron BP'     |
		And I select current line in "List" table
		And I activate "Legal name" field in "FixedOffsetOfAdvances" table
		And I click choice button of "Legal name" attribute in "FixedOffsetOfAdvances" table
		And I go to line in "List" table
			| 'Description'         |
			| 'Company Ferron BP'   |
		And I select current line in "List" table
		And I activate "Transaction document" field in "FixedOffsetOfAdvances" table
		And I click choice button of "Transaction document" attribute in "FixedOffsetOfAdvances" table
		Then "Select data type" window is opened
		And I go to line in "" table
			| ''                |
			| 'Sales invoice'   |
		And I select current line in "" table
		And I go to line in "List" table
			| 'Number'   |
			| '2'        |
		And I select current line in "List" table
		And I finish line editing in "FixedOffsetOfAdvances" table
	* Save the pin and post
		And I click the button named "FixedOffsetOfAdvancesSaveFixedOffset"
		And I click the button named "FormPost"
		And I delete "$$NumberFixedOffsetClosing$$" variable
		And I save the value of "Number" field as "$$NumberFixedOffsetClosing$$"
		And I click "Post and close" button
	* WORKAROUND for bug 7 - remove after the agreement filter fix
		# Bug 7: a segment agreement ('Basic Partner terms, TRY', empty Partner) cannot be
		# set in the pin row through the UI - the list filter on CurrentData.Partner hides it
		# both when picking from the list and when typing text, and an Agreement filled before Partner
		# is overwritten by the handler when the partner is selected. We set Agreement on the saved
		# pin via script and re-post the document so the pin takes effect. REMOVE AFTER THE FIX.
		And I execute 1C:Enterprise script at server
			| 'Q = New Query("SELECT Ref AS R FROM Document.CustomersAdvancesClosing WHERE Date = DATETIME(2021,1,29,12,0,0)"); S = Q.Execute().Select(); If S.Next() Then QA = New Query("SELECT TOP 1 A.Ref AS R FROM Catalog.Agreements AS A WHERE A.Description_en = ""Basic Partner terms, TRY"""); SA = QA.Execute().Select(); SA.Next(); RS = InformationRegisters.T2018S_FixedOffsetOfAdvances.CreateRecordSet(); RS.Filter.Document.Set(S.R); RS.Read(); For Each Rec In RS Do If Rec.IsFixed And Not ValueIsFilled(Rec.Agreement) Then Rec.Agreement = SA.R; EndIf; EndDo; RS.Write(); S.R.GetObject().Write(DocumentWriteMode.Posting); EndIf;' |
	* Check the document is posted
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And "List" table contains lines
			| 'Number'                        | 'Date'         | 'Company'        |
			| '$$NumberFixedOffsetClosing$$'  | '29.01.2021'   | 'Main Company'   |
		And I close all client application windows


Scenario: _1004005 pinned invoice is offset first with the full available advance
	# INTENT: the pin fixes SI 2 first as a whole (Priority 0 - ahead of the chronological order,
	# in which SI 1 would have come first). The SI 2 rows (SO 2 + no order) only match the
	# no-order advance 3 900 -> the pin offsets 3 900 (capped by the available advance).
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2021B_CustomersTransactions"
	And "List" table contains lines
		| 'Recorder'                                  | 'Multi currency movement type' | 'Basis'                                     | 'Customers advances closing'                                              |
		| 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Local currency'               | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Customers advance closing $$NumberFixedOffsetClosing$$ dated 29.01.2021 12:00:00' |
	And I close all client application windows


Scenario: _1004006 BUG 1 repro - SI 1 must receive its order advance
	# INTENT: SI 1 (3 914, Order SO 1) has its own advance with Order SO 1 for 3 900 - the SI 2 pin
	# spent a DIFFERENT (no-order) key, the order-bound advance is free -> SI 1 must
	# be closed by 3 914 (3 900 of the order advance + the remainder of the no-order one).
	# WITH THE BUG: AlreadyWriteoff (the pin amount) is subtracted from EVERY advance key,
	# including the untouched order-bound one -> the available remainder is understated -> SI 1 gets
	# substantially less (or 0) -> there is no row with amount 3 914 -> the step fails.
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2021B_CustomersTransactions"
	And "List" table contains lines
		| 'Recorder'                                  | 'Multi currency movement type' | 'Basis'                                     | 'Amount'     | 'Customers advances closing'                                              |
		| 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Local currency'               | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '3 914,00'   | 'Customers advance closing $$NumberFixedOffsetClosing$$ dated 29.01.2021 12:00:00' |
	And I close all client application windows


Scenario: _1004008 BUG 8 repro - duplicate pin rows must not crash Save fixed offset
	# INTENT: two identical rows -> either duplicate control with a clear message,
	# or a correct write. WITH THE BUG: RecordSet.Write() fails with an unhandled
	# exception "a record with such key fields already exists" -> the scenario fails
	# at the Save fixed offset step.
	* Open the closing document
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberFixedOffsetClosing$$'  |
		And I select current line in "List" table
	* Add two identical rows (Lomaniti, TRY)
		And in the table "FixedOffsetOfAdvances" I click the button named "FixedOffsetOfAdvancesAdd"
		And I click choice button of "Currency" attribute in "FixedOffsetOfAdvances" table
		And I go to line in "List" table
			| 'Code'          |
			| 'TRY'           |
		And I select current line in "List" table
		And I activate "Partner" field in "FixedOffsetOfAdvances" table
		And I click choice button of "Partner" attribute in "FixedOffsetOfAdvances" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Lomaniti'      |
		And I select current line in "List" table
		And I finish line editing in "FixedOffsetOfAdvances" table
		And in the table "FixedOffsetOfAdvances" I click the button named "FixedOffsetOfAdvancesAdd"
		And I click choice button of "Currency" attribute in "FixedOffsetOfAdvances" table
		And I go to line in "List" table
			| 'Code'          |
			| 'TRY'           |
		And I select current line in "List" table
		And I activate "Partner" field in "FixedOffsetOfAdvances" table
		And I click choice button of "Partner" attribute in "FixedOffsetOfAdvances" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Lomaniti'      |
		And I select current line in "List" table
		And I finish line editing in "FixedOffsetOfAdvances" table
	* Duplicate rows are handled gracefully - a friendly dup-control warning, not a raw crash.
	# Previously this reproduced bug 8 (an unhandled exception on Write). Now the duplicate
	# control shows a clear warning and does NOT write the duplicate - which is correct behavior.
		And I click the button named "FixedOffsetOfAdvancesSaveFixedOffset"
		And I close warning window
	* The duplicate pin is NOT written to the register (dup control blocked it)
		Given I open hyperlink "e1cib/list/InformationRegister.T2018S_FixedOffsetOfAdvances"
		And "List" table does not contain lines
			| 'Is fixed'   | 'Partner'    |
			| 'Yes'        | 'Lomaniti'   |
		And I close all client application windows


Scenario: _1004009 unpost drops only the automatic records and keeps the user pins
	# Intended behavior of Clear_SelfRecords: on unposting, only the automatic records
	# (IsFixed = No) are removed; the user pins (IsFixed = Yes) stay.
	# Re-posting restores the automatic records.
	* Unpost the pinned closing
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberFixedOffsetClosing$$'  |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I close all client application windows
	* The user pin survives, this document's automatic records are cleared
		Given I open hyperlink "e1cib/list/InformationRegister.T2018S_FixedOffsetOfAdvances"
		And "List" table contains lines
			| 'Is fixed'   | 'Document'                                                                          | 'Partner'     |
			| 'Yes'        | 'Customers advance closing $$NumberFixedOffsetClosing$$ dated 29.01.2021 12:00:00' | 'Ferron BP'   |
		And "List" table does not contain lines
			| 'Is fixed'   | 'Document'                                                                          |
			| 'No'         | 'Customers advance closing $$NumberFixedOffsetClosing$$ dated 29.01.2021 12:00:00' |
		And I close all client application windows
	* Repost regenerates the automatic records while honouring the pin
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberFixedOffsetClosing$$'  |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/list/InformationRegister.T2018S_FixedOffsetOfAdvances"
		And "List" table contains lines
			| 'Is fixed'   | 'Document'                                                                          | 'Partner'     |
			| 'No'         | 'Customers advance closing $$NumberFixedOffsetClosing$$ dated 29.01.2021 12:00:00' | 'Ferron BP'   |
		And I close all client application windows


Scenario: _1004010 deletion mark keeps the user pin (only automatic records are cleared)
	# Unposting and marking for deletion do NOT touch the user pins (IsFixed = Yes) -
	# this is correct behavior: the pin stays while the automatic records (IsFixed = No) are cleared.
	* Unpost and mark the closing document for deletion
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberFixedOffsetClosing$$'  |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberFixedOffsetClosing$$'  |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		If "1C:Enterprise" window is opened Then
			And I click "Yes" button
		And I close all client application windows
	* The user pin (IsFixed = Yes) survives; automatic records (IsFixed = No) of this document are cleared
		Given I open hyperlink "e1cib/list/InformationRegister.T2018S_FixedOffsetOfAdvances"
		And "List" table contains lines
			| 'Is fixed'   | 'Document'                                                                          | 'Partner'     |
			| 'Yes'        | 'Customers advance closing $$NumberFixedOffsetClosing$$ dated 29.01.2021 12:00:00' | 'Ferron BP'   |
		And "List" table does not contain lines
			| 'Is fixed'   | 'Document'                                                                          |
			| 'No'         | 'Customers advance closing $$NumberFixedOffsetClosing$$ dated 29.01.2021 12:00:00' |
		And I close all client application windows
