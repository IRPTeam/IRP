#language: en
@tree
@Positive
@Advance


Feature: vendors advances closing - fixed offset of advances

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _1005000 preparation (vendors advances closing fixed offset)
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
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
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
		When Create catalog SerialLotNumbers objects
		When Create catalog Projects objects
		When Create information register Taxes records (VAT)
		When Create catalog ReportOptions objects (R5020_PartnersBalance)
	* Load documents
		When Create document BankPayment objects (check movements, advance)
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(10).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
		# Load PO
		When Create document PurchaseOrder objects (check movements, PI before GR, not Use receipt sheduling)
		And I execute 1C:Enterprise script at server
				| "Documents.PurchaseOrder.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);"     |
		# Load PI
		When Create document PurchaseInvoice objects (advance)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(121).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(122).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(123).GetObject().Write(DocumentWriteMode.Posting);"    |
		# Load PI Ferron BP (fixed offset) - the invoice pinned by _1005, on the isolated agreement "Offset mechanism vendor, TRY"
		When Create document PurchaseInvoice objects (Ferron BP, fixed offset)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(128).GetObject().Write(DocumentWriteMode.Posting);"    |
		# Load the dedicated advance Bank payment 129 (same isolated agreement) so the pin has exactly one advance to offset
		When Create document BankPayment objects (Ferron BP, fixed offset)
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(129).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document CashPayment objects (advance)
		And I execute 1C:Enterprise script at server
			| "Documents.CashPayment.FindByNumber(21).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashPayment.FindByNumber(22).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Unpost advance closings covering 11-12.02.2021 (left posted by _1002) - the overlapping-period control would block posting the pinned closing over them
		Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
		And I go to line in "List" table
			| 'Date'          |
			| '11.02.2021'    |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I close all client application windows

Scenario: _10050001 check preparation
	When check preparation


Scenario: _1005002 add fixed offset row prompts to write unsaved document
	* Create a new closing document but do not save it yet
		Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
		And I click the button named "FormCreate"
		And I input "12.02.2021 23:00:00" text in "Date" field
		And I select "Main Company" exact value from "Company" drop-down list
		And I click Select button of "Begin of period" field
		And I input "11.02.2021" text in "Begin of period" field
		And I input "12.02.2021" text in "End of period" field
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'    |
			| 'Front office'   |
		And I select current line in "List" table
	* Adding a row on the unsaved document raises the write prompt
		And in the table "FixedOffsetOfAdvances" I click the button named "FixedOffsetOfAdvancesAdd"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
	* After writing, the new row appears prefilled (Company from the document header)
		And "FixedOffsetOfAdvances" table contains lines
			| 'Company'        |
			| 'Main Company'   |
		And I delete "$$FONumberV$$" variable
		And I save the value of "Number" field as "$$FONumberV$$"
		And I click "Post and close" button
		And I close all client application windows


Scenario: _1005003 fill and save a fixed offset row to the register
	* Open the closing document created above
		Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
		And I go to line in "List" table
			| 'Number'        |
			| '$$FONumberV$$' |
		And I select current line in "List" table
	* Add and fill a fixed offset row (document is already saved -> no prompt)
		And in the table "FixedOffsetOfAdvances" I click the button named "FixedOffsetOfAdvancesAdd"
		And I click choice button of "Currency" attribute in "FixedOffsetOfAdvances" table
		And I go to line in "List" table
			| 'Code'   |
			| 'TRY'    |
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
		And I activate "Agreement" field in "FixedOffsetOfAdvances" table
		And I click choice button of "Agreement" attribute in "FixedOffsetOfAdvances" table
		And I go to line in "List" table
			| 'Description'                    |
			| 'Offset mechanism vendor, TRY'   |
		And I select current line in "List" table
		And I activate "Transaction document" field in "FixedOffsetOfAdvances" table
		And I click choice button of "Transaction document" attribute in "FixedOffsetOfAdvances" table
		Then "Select data type" window is opened
		And I go to line in "" table
			| ''                  |
			| 'Purchase invoice'  |
		And I select current line in "" table
		And I go to line in "List" table
			| 'Number'   |
			| '128'      |
		And I select current line in "List" table
	* Save fixed offset to the register
		And I click the button named "FixedOffsetOfAdvancesSaveFixedOffset"
		And I click "Post and close" button
	* Verify the pin was written to InformationRegister.T2018S_FixedOffsetOfAdvances
		Given I open hyperlink "e1cib/list/InformationRegister.T2018S_FixedOffsetOfAdvances"
		And "List" table contains lines
			| 'Is fixed'   | 'Company'        | 'Currency'   |
			| 'Yes'        | 'Main Company'   | 'TRY'        |
		And I close all client application windows


Scenario: _1005004 fixed offset takes posting priority over automatic order
	* Post the closing document with the fixed pin
		Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
		And I go to line in "List" table
			| 'Number'        |
			| '$$FONumberV$$' |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I close all client application windows
	* Check the vendors transactions register - the pinned invoice is offset first
		Given I open hyperlink "e1cib/list/AccumulationRegister.R1021B_VendorsTransactions"
		And "List" table contains lines
			| 'Recorder'                                  | 'Partner'    | 'Basis'                                          | 'Amount'   | 'Vendors advances closing'                                         |
			| 'Bank payment 129 dated 12.02.2021 11:00:00' | 'Ferron BP'  | 'Purchase invoice 128 dated 12.02.2021 10:00:00' | '1 000,00' | 'Vendors advances closing $$FONumberV$$ dated 12.02.2021 23:00:00' |
		And I close current window
	* Check the advances-to-vendors register
		Given I open hyperlink "e1cib/list/AccumulationRegister.R1020B_AdvancesToVendors"
		And "List" table contains lines
			| 'Recorder'                                  | 'Partner'    | 'Amount'   | 'Vendors advances closing'                                         |
			| 'Bank payment 129 dated 12.02.2021 11:00:00' | 'Ferron BP'  | '1 000,00' | 'Vendors advances closing $$FONumberV$$ dated 12.02.2021 23:00:00' |
		And I close all client application windows


Scenario: _1005005 unpost keeps the pin and drops only the auto records
	* Unpost the closing document
		Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
		And I go to line in "List" table
			| 'Number'        |
			| '$$FONumberV$$' |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I close all client application windows
	* The user pin (IsFixed = Yes) survives, this document's auto records (IsFixed = No) are cleared
		Given I open hyperlink "e1cib/list/InformationRegister.T2018S_FixedOffsetOfAdvances"
		And "List" table contains lines
			| 'Is fixed'   | 'Document'                                                           |
			| 'Yes'        | 'Vendors advances closing $$FONumberV$$ dated 12.02.2021 23:00:00'  |
		And "List" table does not contain lines
			| 'Is fixed'   | 'Document'                                                           |
			| 'No'         | 'Vendors advances closing $$FONumberV$$ dated 12.02.2021 23:00:00'  |
		And I close all client application windows
	* Repost honours the pin - the user pin (IsFixed = Yes) is kept
	# In this fixture the offset is pin-only; there are no automatic records (IsFixed = No) to regenerate.
		Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
		And I go to line in "List" table
			| 'Number'        |
			| '$$FONumberV$$' |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/list/InformationRegister.T2018S_FixedOffsetOfAdvances"
		And "List" table contains lines
			| 'Is fixed'   | 'Document'                                                           |
			| 'Yes'        | 'Vendors advances closing $$FONumberV$$ dated 12.02.2021 23:00:00'  |
		And I close all client application windows
