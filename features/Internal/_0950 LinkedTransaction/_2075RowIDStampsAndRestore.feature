#language: en
@tree
@Positive
@LinkedTransaction

# RowIDStamps register + Catalog.RowIDs state restore on undo posting (PR IRPTeam/IRP#2947).
# Regression coverage AFTER the fix (commit 9a9dc8d9e1 — stamps are written
# unconditionally on every real RowIDs write):
#   - posting a document writes its state stamps into InformationRegister.RowIDStamps;
#   - unpost + repost RESTORES the stamps (fix for the "stamps lost forever" bug 6);
#   - editing one row and reposting KEEPS the sibling rows' stamps (fix for bug 7);
#   - undo posting of an executing document restores the passport (releases a fixed variable key).
#
# The file also covers the document types NEWLY registered as RowIDStamps recorders in
# PR #2947 (each got a <registerRecords>InformationRegister.RowIDStamps line):
# SalesReturnOrder, PurchaseReturnOrder, InventoryTransferOrder (_2075007.._2075009 -
# ex _2085). All stamp checks are EXACT (is equal on the full "Row IDStamps" report
# layout); '*' masks only the period, the row-ref UUID and the basis presentation.
# An extra / missing / duplicated stamp row fails the check.
#
# DATA ISOLATION (sequential @LinkedTransaction tag, no cleanup between files):
# this file runs AFTER _2060..._2070. Every scenario creates its OWN documents with
# a file-unique Comment marker (LT2075-* / LT2085-*) and scenario-local variables;
# it never touches fixture documents of the earlier files. Shared catalog loaders
# are idempotent (check-or-create).

Feature: RowID stamps register and RowIDs state restore on undo posting

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _2075001 preparation (RowID stamps and restore)
	When set True value to the constant
	When set False value to the constant DisableLinkedRowsIntegrity
	* Load info
		When Create catalog Companies objects (own Second company)
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
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
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create information register Taxes records (VAT)
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog CancelReturnReasons objects
	And I close all client application windows

Scenario: _20750011 check preparation
	When check preparation


Scenario: _2075002 posting Sales order writes its state stamps into the RowIDStamps register
	And I close all client application windows
	* Create SO_LT2075_02 (Ferron BP, Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2075-02" text in the field named "Text"
		And I click "OK" button
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
		And I activate field named "ItemListStore" in "ItemList" table
		And I click choice button of the attribute named "ItemListStore" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* The RowIDStamps register holds the FULL row-attribute snapshot (exact set of rows)
		And I click "Registrations report" button
		And I select "Row IDStamps" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                              | ''       | ''                         | ''           | ''                         |
			| 'Document registrations records' | ''       | ''                         | ''           | ''                         |
			| 'Register  "Row IDStamps"'       | ''       | ''                         | ''           | ''                         |
			| ''                               | 'Period' | 'Resources'                | 'Dimensions' | ''                         |
			| ''                               | ''       | 'Value'                    | 'Row ref'    | 'Attribute'                |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsFixedItemKey'           |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsFixedStore'             |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsVariableItemKey'        |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsVariableStore'          |
			| ''                               | '*'      | 'No'                       | '*'          | 'PriceIncludeTaxPurchases' |
			| ''                               | '*'      | 'Yes'                      | '*'          | 'PriceIncludeTaxSales'     |
			| ''                               | '*'      | 'Basic Partner terms, TRY' | '*'          | 'AgreementSales'           |
			| ''                               | '*'      | 'Main Company'             | '*'          | 'Company'                  |
			| ''                               | '*'      | 'Company Ferron BP'        | '*'          | 'LegalNameSales'           |
			| ''                               | '*'      | 'TRY'                      | '*'          | 'CurrencySales'            |
			| ''                               | '*'      | 'XS/Blue'                  | '*'          | 'ItemKey'                  |
			| ''                               | '*'      | 'Ferron BP'                | '*'          | 'PartnerSales'             |
			| ''                               | '*'      | 'Store 02'                 | '*'          | 'Store'                    |
			| ''                               | '*'      | 'pcs'                      | '*'          | 'Unit'                     |
			| ''                               | '*'      | '*'                        | '*'          | 'Basis'                    |
			| ''                               | '*'      | '*'                        | '*'          | 'Requester'                |
			| ''                               | '*'      | 'Return from customer'     | '*'          | 'TransactionTypeGRReturn'  |
			| ''                               | '*'      | 'Stock'                    | '*'          | 'ProcurementMethod'        |
			| ''                               | '*'      | 'Return from customer'     | '*'          | 'TransactionTypeSR'        |
			| ''                               | '*'      | 'Sales'                    | '*'          | 'TransactionTypeSales'     |
			| ''                               | '*'      | 'Sales'                    | '*'          | 'TransactionTypeSC'        |
		And I close all client application windows


Scenario: _2075003 reposting a Sales order without changes keeps its RowIDStamps records
	And I close all client application windows
	* Create and post SO_LT2075_03 (Ferron BP, Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2075-03" text in the field named "Text"
		And I click "OK" button
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
		And I activate field named "ItemListStore" in "ItemList" table
		And I click choice button of the attribute named "ItemListStore" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* Repost without any change
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* The FULL stamp snapshot is still present after the plain repost (exact set of rows)
		And I click "Registrations report" button
		And I select "Row IDStamps" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                              | ''       | ''                         | ''           | ''                         |
			| 'Document registrations records' | ''       | ''                         | ''           | ''                         |
			| 'Register  "Row IDStamps"'       | ''       | ''                         | ''           | ''                         |
			| ''                               | 'Period' | 'Resources'                | 'Dimensions' | ''                         |
			| ''                               | ''       | 'Value'                    | 'Row ref'    | 'Attribute'                |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsFixedItemKey'           |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsFixedStore'             |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsVariableItemKey'        |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsVariableStore'          |
			| ''                               | '*'      | 'No'                       | '*'          | 'PriceIncludeTaxPurchases' |
			| ''                               | '*'      | 'Yes'                      | '*'          | 'PriceIncludeTaxSales'     |
			| ''                               | '*'      | 'Basic Partner terms, TRY' | '*'          | 'AgreementSales'           |
			| ''                               | '*'      | 'Main Company'             | '*'          | 'Company'                  |
			| ''                               | '*'      | 'Company Ferron BP'        | '*'          | 'LegalNameSales'           |
			| ''                               | '*'      | 'TRY'                      | '*'          | 'CurrencySales'            |
			| ''                               | '*'      | 'XS/Blue'                  | '*'          | 'ItemKey'                  |
			| ''                               | '*'      | 'Ferron BP'                | '*'          | 'PartnerSales'             |
			| ''                               | '*'      | 'Store 02'                 | '*'          | 'Store'                    |
			| ''                               | '*'      | 'pcs'                      | '*'          | 'Unit'                     |
			| ''                               | '*'      | '*'                        | '*'          | 'Basis'                    |
			| ''                               | '*'      | '*'                        | '*'          | 'Requester'                |
			| ''                               | '*'      | 'Return from customer'     | '*'          | 'TransactionTypeGRReturn'  |
			| ''                               | '*'      | 'Stock'                    | '*'          | 'ProcurementMethod'        |
			| ''                               | '*'      | 'Return from customer'     | '*'          | 'TransactionTypeSR'        |
			| ''                               | '*'      | 'Sales'                    | '*'          | 'TransactionTypeSales'     |
			| ''                               | '*'      | 'Sales'                    | '*'          | 'TransactionTypeSC'        |
		And I close all client application windows


# Regression for the "stamps lost forever on unpost+repost" bug (bug 6, fixed in
# 9a9dc8d9e1). Before the fix a repost after an undo left the RowIDStamps register
# EMPTY (hash unchanged -> stamps not rewritten). After the fix the repost restores
# them. This scenario must stay GREEN on the fixed build and turns red if the fix
# regresses.
Scenario: _2075004 undo posting then reposting a Sales order restores its RowIDStamps records
	And I close all client application windows
	* Create and post SO_LT2075_04 (Ferron BP, Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2075-04" text in the field named "Text"
		And I click "OK" button
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
		And I activate field named "ItemListStore" in "ItemList" table
		And I click choice button of the attribute named "ItemListStore" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* Undo posting, then repost (the fix must re-write the stamps)
		And I click the button named "FormUndoPosting"
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* The FULL RowIDStamps snapshot is present again after the repost (exact set of rows)
		And I click "Registrations report" button
		And I select "Row IDStamps" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                              | ''       | ''                         | ''           | ''                         |
			| 'Document registrations records' | ''       | ''                         | ''           | ''                         |
			| 'Register  "Row IDStamps"'       | ''       | ''                         | ''           | ''                         |
			| ''                               | 'Period' | 'Resources'                | 'Dimensions' | ''                         |
			| ''                               | ''       | 'Value'                    | 'Row ref'    | 'Attribute'                |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsFixedItemKey'           |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsFixedStore'             |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsVariableItemKey'        |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsVariableStore'          |
			| ''                               | '*'      | 'No'                       | '*'          | 'PriceIncludeTaxPurchases' |
			| ''                               | '*'      | 'Yes'                      | '*'          | 'PriceIncludeTaxSales'     |
			| ''                               | '*'      | 'Basic Partner terms, TRY' | '*'          | 'AgreementSales'           |
			| ''                               | '*'      | 'Main Company'             | '*'          | 'Company'                  |
			| ''                               | '*'      | 'Company Ferron BP'        | '*'          | 'LegalNameSales'           |
			| ''                               | '*'      | 'TRY'                      | '*'          | 'CurrencySales'            |
			| ''                               | '*'      | 'XS/Blue'                  | '*'          | 'ItemKey'                  |
			| ''                               | '*'      | 'Ferron BP'                | '*'          | 'PartnerSales'             |
			| ''                               | '*'      | 'Store 02'                 | '*'          | 'Store'                    |
			| ''                               | '*'      | 'pcs'                      | '*'          | 'Unit'                     |
			| ''                               | '*'      | '*'                        | '*'          | 'Basis'                    |
			| ''                               | '*'      | '*'                        | '*'          | 'Requester'                |
			| ''                               | '*'      | 'Return from customer'     | '*'          | 'TransactionTypeGRReturn'  |
			| ''                               | '*'      | 'Stock'                    | '*'          | 'ProcurementMethod'        |
			| ''                               | '*'      | 'Return from customer'     | '*'          | 'TransactionTypeSR'        |
			| ''                               | '*'      | 'Sales'                    | '*'          | 'TransactionTypeSales'     |
			| ''                               | '*'      | 'Sales'                    | '*'          | 'TransactionTypeSC'        |
		And I close all client application windows


# Regression for the "editing one row wipes the sibling rows' stamps" bug (bug 7,
# fixed in 9a9dc8d9e1). A two-row SO is posted; only row 2's item key is changed and
# the document reposted. Row 1's stamp (ItemKey = XS/Blue) MUST survive — before the
# fix the whole recorder record set was replaced by only the changed row.
Scenario: _2075005 editing one row and reposting keeps the sibling rows RowIDStamps
	And I close all client application windows
	* Create and post SO_LT2075_05 with TWO rows (Dress XS/Blue 3 + Dress M/White 2)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2075-05" text in the field named "Text"
		And I click "OK" button
		* Row 1 - Dress XS/Blue, qty 3
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			And I select current line in "List" table
			And I activate field named "ItemListStore" in "ItemList" table
			And I click choice button of the attribute named "ItemListStore" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'    |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "3,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I activate field named "ItemListPrice" in "ItemList" table
			And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
		* Row 2 - Dress M/White, qty 2
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
			And I select current line in "List" table
			And I activate field named "ItemListStore" in "ItemList" table
			And I click choice button of the attribute named "ItemListStore" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'    |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I activate field named "ItemListPrice" in "ItemList" table
			And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* Change ONLY row 2's item key (M/White -> L/Green) and repost
		And I go to line in "ItemList" table
			| 'Item key' |
			| 'M/White'  |
		And I select current line in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* Row 1 (XS/Blue) stamp survived in full; row 2 now shows the new key (L/Green);
	* M/White is gone - the exact table tolerates no leftover or duplicated stamp rows
		And I click "Registrations report" button
		And I select "Row IDStamps" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                              | ''       | ''                         | ''           | ''                         |
			| 'Document registrations records' | ''       | ''                         | ''           | ''                         |
			| 'Register  "Row IDStamps"'       | ''       | ''                         | ''           | ''                         |
			| ''                               | 'Period' | 'Resources'                | 'Dimensions' | ''                         |
			| ''                               | ''       | 'Value'                    | 'Row ref'    | 'Attribute'                |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsFixedItemKey'           |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsFixedStore'             |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsVariableItemKey'        |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsVariableStore'          |
			| ''                               | '*'      | 'No'                       | '*'          | 'PriceIncludeTaxPurchases' |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsFixedItemKey'           |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsFixedStore'             |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsVariableItemKey'        |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsVariableStore'          |
			| ''                               | '*'      | 'No'                       | '*'          | 'PriceIncludeTaxPurchases' |
			| ''                               | '*'      | 'Yes'                      | '*'          | 'PriceIncludeTaxSales'     |
			| ''                               | '*'      | 'Yes'                      | '*'          | 'PriceIncludeTaxSales'     |
			| ''                               | '*'      | 'Basic Partner terms, TRY' | '*'          | 'AgreementSales'           |
			| ''                               | '*'      | 'Basic Partner terms, TRY' | '*'          | 'AgreementSales'           |
			| ''                               | '*'      | 'Main Company'             | '*'          | 'Company'                  |
			| ''                               | '*'      | 'Main Company'             | '*'          | 'Company'                  |
			| ''                               | '*'      | 'Company Ferron BP'        | '*'          | 'LegalNameSales'           |
			| ''                               | '*'      | 'Company Ferron BP'        | '*'          | 'LegalNameSales'           |
			| ''                               | '*'      | 'TRY'                      | '*'          | 'CurrencySales'            |
			| ''                               | '*'      | 'TRY'                      | '*'          | 'CurrencySales'            |
			| ''                               | '*'      | 'XS/Blue'                  | '*'          | 'ItemKey'                  |
			| ''                               | '*'      | 'L/Green'                  | '*'          | 'ItemKey'                  |
			| ''                               | '*'      | 'Ferron BP'                | '*'          | 'PartnerSales'             |
			| ''                               | '*'      | 'Ferron BP'                | '*'          | 'PartnerSales'             |
			| ''                               | '*'      | 'Store 02'                 | '*'          | 'Store'                    |
			| ''                               | '*'      | 'Store 02'                 | '*'          | 'Store'                    |
			| ''                               | '*'      | 'pcs'                      | '*'          | 'Unit'                     |
			| ''                               | '*'      | 'pcs'                      | '*'          | 'Unit'                     |
			| ''                               | '*'      | '*'                        | '*'          | 'Basis'                    |
			| ''                               | '*'      | '*'                        | '*'          | 'Requester'                |
			| ''                               | '*'      | '*'                        | '*'          | 'Basis'                    |
			| ''                               | '*'      | '*'                        | '*'          | 'Requester'                |
			| ''                               | '*'      | 'Return from customer'     | '*'          | 'TransactionTypeGRReturn'  |
			| ''                               | '*'      | 'Return from customer'     | '*'          | 'TransactionTypeGRReturn'  |
			| ''                               | '*'      | 'Stock'                    | '*'          | 'ProcurementMethod'        |
			| ''                               | '*'      | 'Stock'                    | '*'          | 'ProcurementMethod'        |
			| ''                               | '*'      | 'Return from customer'     | '*'          | 'TransactionTypeSR'        |
			| ''                               | '*'      | 'Return from customer'     | '*'          | 'TransactionTypeSR'        |
			| ''                               | '*'      | 'Sales'                    | '*'          | 'TransactionTypeSales'     |
			| ''                               | '*'      | 'Sales'                    | '*'          | 'TransactionTypeSales'     |
			| ''                               | '*'      | 'Sales'                    | '*'          | 'TransactionTypeSC'        |
			| ''                               | '*'      | 'Sales'                    | '*'          | 'TransactionTypeSC'        |
		And I close all client application windows


# The stamp Period follows the document Date. The SO is back-dated (date set before
# the row is added, so no price-recalculation dialog fires) and posted; the stamp
# must carry that exact document date as its Period.
Scenario: _2075006 the RowIDStamps Period equals the Sales order document date
	And I close all client application windows
	* Create back-dated SO_LT2075_06 (Ferron BP, Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2075-06" text in the field named "Text"
		And I click "OK" button
		And I activate the field named "Date"
		And I input "01.06.2026 10:00:00" text in the field named "Date"
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
		And I activate field named "ItemListStore" in "ItemList" table
		And I click choice button of the attribute named "ItemListStore" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* Every stamp row carries the exact document date as its Period (full exact table)
		And I click "Registrations report" button
		And I select "Row IDStamps" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                              | ''                    | ''                         | ''           | ''                         |
			| 'Document registrations records' | ''                    | ''                         | ''           | ''                         |
			| 'Register  "Row IDStamps"'       | ''                    | ''                         | ''           | ''                         |
			| ''                               | 'Period'              | 'Resources'                | 'Dimensions' | ''                         |
			| ''                               | ''                    | 'Value'                    | 'Row ref'    | 'Attribute'                |
			| ''                               | '01.06.2026 10:00:00' | 'No'                       | '*'          | 'IsFixedItemKey'           |
			| ''                               | '01.06.2026 10:00:00' | 'No'                       | '*'          | 'IsFixedStore'             |
			| ''                               | '01.06.2026 10:00:00' | 'No'                       | '*'          | 'IsVariableItemKey'        |
			| ''                               | '01.06.2026 10:00:00' | 'No'                       | '*'          | 'IsVariableStore'          |
			| ''                               | '01.06.2026 10:00:00' | 'No'                       | '*'          | 'PriceIncludeTaxPurchases' |
			| ''                               | '01.06.2026 10:00:00' | 'Yes'                      | '*'          | 'PriceIncludeTaxSales'     |
			| ''                               | '01.06.2026 10:00:00' | 'Basic Partner terms, TRY' | '*'          | 'AgreementSales'           |
			| ''                               | '01.06.2026 10:00:00' | 'Main Company'             | '*'          | 'Company'                  |
			| ''                               | '01.06.2026 10:00:00' | 'Company Ferron BP'        | '*'          | 'LegalNameSales'           |
			| ''                               | '01.06.2026 10:00:00' | 'TRY'                      | '*'          | 'CurrencySales'            |
			| ''                               | '01.06.2026 10:00:00' | 'XS/Blue'                  | '*'          | 'ItemKey'                  |
			| ''                               | '01.06.2026 10:00:00' | 'Ferron BP'                | '*'          | 'PartnerSales'             |
			| ''                               | '01.06.2026 10:00:00' | 'Store 02'                 | '*'          | 'Store'                    |
			| ''                               | '01.06.2026 10:00:00' | 'pcs'                      | '*'          | 'Unit'                     |
			| ''                               | '01.06.2026 10:00:00' | '*'                        | '*'          | 'Basis'                    |
			| ''                               | '01.06.2026 10:00:00' | '*'                        | '*'          | 'Requester'                |
			| ''                               | '01.06.2026 10:00:00' | 'Return from customer'     | '*'          | 'TransactionTypeGRReturn'  |
			| ''                               | '01.06.2026 10:00:00' | 'Stock'                    | '*'          | 'ProcurementMethod'        |
			| ''                               | '01.06.2026 10:00:00' | 'Return from customer'     | '*'          | 'TransactionTypeSR'        |
			| ''                               | '01.06.2026 10:00:00' | 'Sales'                    | '*'          | 'TransactionTypeSales'     |
			| ''                               | '01.06.2026 10:00:00' | 'Sales'                    | '*'          | 'TransactionTypeSC'        |
		And I close all client application windows



# A posted Sales return order (newly RowID-enabled) writes its row-attribute snapshot
# into the RowIDStamps register, exactly like a Sales order does.
Scenario: _2075007 posting a Sales return order writes its state stamps into RowIDStamps
	And I close all client application windows
	* Create and post SRO_LT2085_02 (Ferron BP, Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I select from the drop-down list named "Status" by "Approved" string
		And I click the hyperlink named "Comment"
		And I input "LT2085-02" text in the field named "Text"
		And I click "OK" button
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
		And I activate field named "ItemListStore" in "ItemList" table
		And I click choice button of the attribute named "ItemListStore" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* The RowIDStamps register holds the full row-attribute snapshot of the return order
		And I click "Registrations report" button
		And I select "Row IDStamps" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                              | ''       | ''                         | ''           | ''                         |
			| 'Document registrations records' | ''       | ''                         | ''           | ''                         |
			| 'Register  "Row IDStamps"'       | ''       | ''                         | ''           | ''                         |
			| ''                               | 'Period' | 'Resources'                | 'Dimensions' | ''                         |
			| ''                               | ''       | 'Value'                    | 'Row ref'    | 'Attribute'                |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsFixedItemKey'           |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsFixedStore'             |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsVariableItemKey'        |
			| ''                               | '*'      | 'No'                       | '*'          | 'IsVariableStore'          |
			| ''                               | '*'      | 'No'                       | '*'          | 'PriceIncludeTaxPurchases' |
			| ''                               | '*'      | 'Yes'                      | '*'          | 'PriceIncludeTaxSales'     |
			| ''                               | '*'      | 'Basic Partner terms, TRY' | '*'          | 'AgreementSales'           |
			| ''                               | '*'      | 'Main Company'             | '*'          | 'Company'                  |
			| ''                               | '*'      | 'Company Ferron BP'        | '*'          | 'LegalNameSales'           |
			| ''                               | '*'      | 'TRY'                      | '*'          | 'CurrencySales'            |
			| ''                               | '*'      | 'XS/Blue'                  | '*'          | 'ItemKey'                  |
			| ''                               | '*'      | 'Dress'                    | '*'          | 'Item'                     |
			| ''                               | '*'      | 'Ferron BP'                | '*'          | 'PartnerSales'             |
			| ''                               | '*'      | 'Store 02'                 | '*'          | 'Store'                    |
			| ''                               | '*'      | 'pcs'                      | '*'          | 'Unit'                     |
			| ''                               | '*'      | '*'                        | '*'          | 'Basis'                    |
			| ''                               | '*'      | 'Return from customer'     | '*'          | 'TransactionTypeGRReturn'  |
			| ''                               | '*'      | 'Return from customer'     | '*'          | 'TransactionTypeSR'        |
		And I close all client application windows


# Mirror on the purchase side: a posted (approved) Purchase return order writes its
# purchase-side row-attribute snapshot into RowIDStamps.
Scenario: _2075008 posting a Purchase return order writes its state stamps into RowIDStamps
	And I close all client application windows
	* Create and post PRO_LT2085_03 (Ferron BP, Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Vendor Ferron, TRY" string
		And I select from the drop-down list named "Status" by "Approved" string
		And I click the hyperlink named "Comment"
		And I input "LT2085-03" text in the field named "Text"
		And I click "OK" button
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
		And I activate field named "ItemListStore" in "ItemList" table
		And I click choice button of the attribute named "ItemListStore" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* The RowIDStamps register holds the full purchase-side snapshot of the return order
		And I click "Registrations report" button
		And I select "Row IDStamps" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                              | ''       | ''                   | ''           | ''                         |
			| 'Document registrations records' | ''       | ''                   | ''           | ''                         |
			| 'Register  "Row IDStamps"'       | ''       | ''                   | ''           | ''                         |
			| ''                               | 'Period' | 'Resources'          | 'Dimensions' | ''                         |
			| ''                               | ''       | 'Value'              | 'Row ref'    | 'Attribute'                |
			| ''                               | '*'      | 'No'                 | '*'          | 'IsFixedItemKey'           |
			| ''                               | '*'      | 'No'                 | '*'          | 'IsFixedStore'             |
			| ''                               | '*'      | 'No'                 | '*'          | 'IsVariableItemKey'        |
			| ''                               | '*'      | 'No'                 | '*'          | 'IsVariableStore'          |
			| ''                               | '*'      | 'No'                 | '*'          | 'PriceIncludeTaxSales'     |
			| ''                               | '*'      | 'Yes'                | '*'          | 'PriceIncludeTaxPurchases' |
			| ''                               | '*'      | 'Vendor Ferron, TRY' | '*'          | 'AgreementPurchases'       |
			| ''                               | '*'      | 'Main Company'       | '*'          | 'Company'                  |
			| ''                               | '*'      | 'Company Ferron BP'  | '*'          | 'LegalNamePurchases'       |
			| ''                               | '*'      | 'TRY'                | '*'          | 'CurrencyPurchases'        |
			| ''                               | '*'      | 'XS/Blue'            | '*'          | 'ItemKey'                  |
			| ''                               | '*'      | 'Dress'              | '*'          | 'Item'                     |
			| ''                               | '*'      | 'Ferron BP'          | '*'          | 'PartnerPurchases'         |
			| ''                               | '*'      | 'Store 02'           | '*'          | 'Store'                    |
			| ''                               | '*'      | 'pcs'                | '*'          | 'Unit'                     |
			| ''                               | '*'      | '*'                  | '*'          | 'Basis'                    |
			| ''                               | '*'      | 'Return to vendor'   | '*'          | 'TransactionTypePR'        |
			| ''                               | '*'      | 'Return to vendor'   | '*'          | 'TransactionTypeSCReturn'  |
		And I close all client application windows


# Internal document (no partner -> Company must be set by hand): a posted approved
# Inventory transfer order writes its transfer row-attribute snapshot into RowIDStamps.
Scenario: _2075009 posting an Inventory transfer order writes its state stamps into RowIDStamps
	And I close all client application windows
	* Create and post ITO_LT2085_04 (Main Company, Store 02 -> Store 01, Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from the drop-down list named "StoreSender" by "Store 02" string
		And I select from the drop-down list named "StoreReceiver" by "Store 01" string
		And I select from the drop-down list named "Status" by "Approved" string
		And I click the hyperlink named "Comment"
		And I input "LT2085-04" text in the field named "Text"
		And I click "OK" button
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* The RowIDStamps register holds the full transfer snapshot (StoreSender/StoreReceiver)
		And I click "Registrations report" button
		And I select "Row IDStamps" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                              | ''       | ''                   | ''           | ''                         |
			| 'Document registrations records' | ''       | ''                   | ''           | ''                         |
			| 'Register  "Row IDStamps"'       | ''       | ''                   | ''           | ''                         |
			| ''                               | 'Period' | 'Resources'          | 'Dimensions' | ''                         |
			| ''                               | ''       | 'Value'              | 'Row ref'    | 'Attribute'                |
			| ''                               | '*'      | 'No'                 | '*'          | 'IsFixedItemKey'           |
			| ''                               | '*'      | 'No'                 | '*'          | 'IsFixedStore'             |
			| ''                               | '*'      | 'No'                 | '*'          | 'IsVariableItemKey'        |
			| ''                               | '*'      | 'No'                 | '*'          | 'IsVariableStore'          |
			| ''                               | '*'      | 'No'                 | '*'          | 'PriceIncludeTaxPurchases' |
			| ''                               | '*'      | 'No'                 | '*'          | 'PriceIncludeTaxSales'     |
			| ''                               | '*'      | 'Main Company'       | '*'          | 'Company'                  |
			| ''                               | '*'      | 'XS/Blue'            | '*'          | 'ItemKey'                  |
			| ''                               | '*'      | 'Dress'              | '*'          | 'Item'                     |
			| ''                               | '*'      | 'Store 01'           | '*'          | 'StoreReceiver'            |
			| ''                               | '*'      | 'Store 02'           | '*'          | 'StoreSender'              |
			| ''                               | '*'      | 'pcs'                | '*'          | 'Unit'                     |
			| ''                               | '*'      | '*'                  | '*'          | 'Basis'                    |
			| ''                               | '*'      | 'Inventory transfer' | '*'          | 'TransactionTypeGR'        |
			| ''                               | '*'      | 'Inventory transfer' | '*'          | 'TransactionTypeSC'        |
		And I close all client application windows
