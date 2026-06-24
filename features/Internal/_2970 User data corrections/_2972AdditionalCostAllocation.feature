#language: en
@tree
@Positive
@UserDataCorrection

Functionality: Storno effect on Additional cost allocation and landed cost (user data correction)

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

# PR #2944 (#IRP-844): how Document.Storno affects an additional cost that was allocated onto goods.
# Setup: a "cost" Purchase invoice 11 (a service item marked as ItemsCost, net 100) is allocated onto the
# goods of Purchase invoice 1 via Document.AdditionalCostAllocation 1. After the landed-cost calculation
# the 100 lands on Purchase invoice 1 batches (R6020 Batch balance "Allocated cost"). Stornoing the cost
# invoice writes its allocatable cost back in R6070 Other periods expenses (-100).
#
# This file is isolated from _2971Storno.feature on purpose: it adds its own cost invoice + allocation and
# runs the cost calculation OVER them, which would otherwise change Sales invoice 1 COGS that _2971 asserts.
# It is fully self-contained and runs on its own clean base.
Scenario: _2972000 preparation (additional cost allocation)
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
		When Create document CalculationMovementCosts objects (test data base)
	* Load the cost invoice (service item ItemsCost, net 100) that will be allocated onto Purchase invoice 1
		And I check or create document "PurchaseInvoice" objects:
			| 'Ref'                                                                      | 'DeletionMark' | 'Number' | 'Date'                | 'Posted'  | 'Agreement'                                                          | 'Company'                                                           | 'Currency'                                                           | 'DocDate'             | 'DocNumber' | 'LegalName'                                                         | 'Partner'                                                          | 'PriceIncludeTax' | 'LegalNameContract' | 'TransactionType'                        | 'RecordPurchasePrices' | 'Author'                                                        | 'Branch'                                                                | 'Comment' | 'DocumentAmount' | 'UniqueID' | 'SourceNodeID' | 'Editor'                                                        | 'CreateDate'          | 'ModifyDate'          | 'ManualMovementsEdit' |
			| 'e1cib/data/Document.PurchaseInvoice?ref=b72971aca11ce57d11ebeab0dfce2299' | 'False'        | 11       | '25.02.2023 12:00:00' | 'False'   | 'e1cib/data/Catalog.Agreements?ref=b762b13668d0905011eb76684b9f6870' | 'e1cib/data/Catalog.Companies?ref=b762b13668d0905011eb7663e35d7964' | 'e1cib/data/Catalog.Currencies?ref=b762b13668d0905011eb7663e35d795e' | '01.01.0001 00:00:00' | ''          | 'e1cib/data/Catalog.Companies?ref=b762b13668d0905011eb766bf96b276f' | 'e1cib/data/Catalog.Partners?ref=b762b13668d0905011eb7663e35d794d' | 'False'           | ''                  | 'Enum.PurchaseTransactionTypes.Purchase' | 'False'                | 'e1cib/data/Catalog.Users?ref=aa7f120ed92fbced11eb13d7279770c0' | 'e1cib/data/Catalog.BusinessUnits?ref=b762b13668d0905011eb7663e35d7958' | ''            | 100              | ''         | ''             | 'e1cib/data/Catalog.Users?ref=aa7f120ed92fbced11eb13d7279770c0' | '08.05.2024 16:06:34' | '08.05.2024 15:34:01' | 'False'               |
		And I refill object tabular section "ItemList":
			| 'Ref'                                                                      | 'Key'                                  | 'Item'                                                         | 'ItemKey'                                                         | 'Store' | 'PurchaseOrder' | 'Unit'                                                         | 'Quantity' | 'Price' | 'PriceType'                                            | 'TaxAmount' | 'TotalAmount' | 'NetAmount' | 'OffersAmount' | 'ProfitLossCenter' | 'ExpenseType' | 'DeliveryDate'        | 'SalesOrder' | 'Detail' | 'AdditionalAnalytic' | 'DontCalculateRow' | 'QuantityInBaseUnit' | 'UseGoodsReceipt' | 'InternalSupplyRequest' | 'DELETE_IsAdditionalItemCost' | 'OtherPeriodExpenseType'                | 'UseSerialLotNumber' | 'IsService' | 'QuantityIsFixed' | 'VatRate'                                                          | 'Project' |
			| 'e1cib/data/Document.PurchaseInvoice?ref=b72971aca11ce57d11ebeab0dfce2299' | 'c0a12971-fb0c-4243-8ca0-5ce44e275aaa' | 'e1cib/data/Catalog.Items?ref=b762b13668d0905011eb766bf96b2752' | 'e1cib/data/Catalog.ItemKeys?ref=b762b13668d0905011eb766bf96b2753' | ''      | ''              | 'e1cib/data/Catalog.Units?ref=b762b13668d0905011eb76684b9f687b' | 1          | 100     | 'e1cib/data/Catalog.PriceTypes?refName=ManualPriceType' | 0           | 100           | 100         |                | ''                 | ''            | '01.01.0001 00:00:00' | ''           | ''       | ''                   | 'True'             | 1                    | 'False'           | ''                      | 'False'                       | 'Enum.OtherPeriodExpenseType.ItemsCost' | 'False'              | 'True'      | 'False'           | 'e1cib/data/Catalog.TaxRates?ref=b762b13668d0905011eb7663e35d796c' | ''        |
		And I refill object tabular section "Currencies":
			| 'Ref'                                                                      | 'Key'                                  | 'CurrencyFrom'                                                       | 'Rate' | 'ReverseRate' | 'ShowReverseRate' | 'Multiplicity' | 'MovementType'                                                                                    | 'Amount' | 'IsFixed' |
			| 'e1cib/data/Document.PurchaseInvoice?ref=b72971aca11ce57d11ebeab0dfce2299' | '                                    ' | 'e1cib/data/Catalog.Currencies?ref=b762b13668d0905011eb7663e35d795e' | 1      | 1             | 'False'           | 1              | 'e1cib/data/ChartOfCharacteristicTypes.CurrencyMovementType?ref=b762b13668d0905011eb7663e35d796b' | 100      | 'False'   |
			| 'e1cib/data/Document.PurchaseInvoice?ref=b72971aca11ce57d11ebeab0dfce2299' | '                                    ' | 'e1cib/data/Catalog.Currencies?ref=b762b13668d0905011eb7663e35d795e' | 1      | 1             | 'False'           | 1              | 'e1cib/data/ChartOfCharacteristicTypes.CurrencyMovementType?ref=b762b13668d0905011eb7663e35d796a' | 100      | 'False'   |
			| 'e1cib/data/Document.PurchaseInvoice?ref=b72971aca11ce57d11ebeab0dfce2299' | '                                    ' | 'e1cib/data/Catalog.Currencies?ref=b762b13668d0905011eb7663e35d795e' | 1      | 1             | 'False'           | 1              | 'e1cib/data/ChartOfCharacteristicTypes.CurrencyMovementType?ref=b762b13668d0905011eb7663e35d7968' | 100      | 'False'   |
			| 'e1cib/data/Document.PurchaseInvoice?ref=b72971aca11ce57d11ebeab0dfce2299' | '                                    ' | 'e1cib/data/Catalog.Currencies?ref=b762b13668d0905011eb7663e35d795e' |        |               | 'False'           |                | 'e1cib/data/ChartOfCharacteristicTypes.CurrencyMovementType?ref=b762b13668d0905011eb7663e35d7969' |          | 'False'   |
	* Load the Additional cost allocation that distributes Purchase invoice 11 cost onto Purchase invoice 1
		And I check or create document "AdditionalCostAllocation" objects:
			| 'Ref'                                                                               | 'DeletionMark' | 'Number' | 'Date'                | 'Posted' | 'Company'                                                           | 'AllocationMode'                  | 'AllocationMethod'               | 'Author'                                                        | 'Branch' | 'Comment' |
			| 'e1cib/data/Document.AdditionalCostAllocation?ref=b72971aca11ce57d11ebeab0dfceaca1' | 'False'        | 1        | '26.02.2023 12:00:00' | 'False'  | 'e1cib/data/Catalog.Companies?ref=b762b13668d0905011eb7663e35d7964' | 'Enum.AllocationMode.ByDocuments' | 'Enum.AllocationMethod.ByAmount' | 'e1cib/data/Catalog.Users?ref=aa7f120ed92fbced11eb13d7279770c0' | ''       | ''        |
		And I refill object tabular section "CostList":
			| 'Ref'                                                                               | 'RowID'                                | 'Basis'                                                                    | 'ItemKey'                                                         | 'Currency'                                                          | 'Amount' | 'TaxAmount' |
			| 'e1cib/data/Document.AdditionalCostAllocation?ref=b72971aca11ce57d11ebeab0dfceaca1' | 'c0a12971-fb0c-4243-8ca0-5ce44e275aaa' | 'e1cib/data/Document.PurchaseInvoice?ref=b72971aca11ce57d11ebeab0dfce2299' | 'e1cib/data/Catalog.ItemKeys?ref=b762b13668d0905011eb766bf96b2753' | 'e1cib/data/Catalog.Currencies?ref=b762b13668d0905011eb7663e35d795e' | 100      |             |
		And I refill object tabular section "AllocationList":
			| 'Ref'                                                                               | 'BasisRowID'                           | 'RowID'                                | 'Document'                                                                 | 'Store'                                                          | 'ItemKey'                                                         | 'Amount' | 'TaxAmount' |
			| 'e1cib/data/Document.AdditionalCostAllocation?ref=b72971aca11ce57d11ebeab0dfceaca1' | 'c0a12971-fb0c-4243-8ca0-5ce44e275aaa' | '2ce7a713-e5f5-4b4c-b5b7-0bd4a98dff06' | 'e1cib/data/Document.PurchaseInvoice?ref=b76cbacb2511e57d11ebeab0dfce221b' | 'e1cib/data/Catalog.Stores?ref=b762b13668d0905011eb76684b9f6861' | 'e1cib/data/Catalog.ItemKeys?ref=b762b13668d0905011eb76684b9f687e' | 100      |             |
		And I refill object tabular section "CostDocuments":
			| 'Ref'                                                                               | 'Key'                                  | 'Document'                                                                 | 'Currency'                                                          | 'Amount' | 'TaxAmount' |
			| 'e1cib/data/Document.AdditionalCostAllocation?ref=b72971aca11ce57d11ebeab0dfceaca1' | '7f3a1c08-9d2e-4b6a-8e51-2c4f0a9b1d33' | 'e1cib/data/Document.PurchaseInvoice?ref=b72971aca11ce57d11ebeab0dfce2299' | 'e1cib/data/Catalog.Currencies?ref=b762b13668d0905011eb7663e35d795e' | 100      | 0           |
		And I refill object tabular section "AllocationDocuments":
			| 'Ref'                                                                               | 'Key'                                  | 'Document'                                                                 |
			| 'e1cib/data/Document.AdditionalCostAllocation?ref=b72971aca11ce57d11ebeab0dfceaca1' | '7f3a1c08-9d2e-4b6a-8e51-2c4f0a9b1d33' | 'e1cib/data/Document.PurchaseInvoice?ref=b76cbacb2511e57d11ebeab0dfce221b' |
	* Posting documents chain (goods invoice -> cost invoice -> allocation -> cost calculation)
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.AdditionalCostAllocation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
	* Calculate cost of goods AFTER the allocation, so the allocated cost lands on Purchase invoice 1 batches
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
	* Enable linked rows integrity control
		When set False value to the constant DisableLinkedRowsIntegrity
	And I close all client application windows


Scenario: _2972001 check preparation
	When check preparation


# ALLOCATION (user-level, by numbers) - after the landed-cost calculation the R6020 Batch balance report
# shows the 100 additional cost distributed across Purchase invoice 1 batches (by amount): S/Color 1
# 47,74 + 0,87, Item without item key 21,87, S/Color 2 23,98, XS/Color 2 5,54 (total 100,00).
Scenario: _2972002 check the allocated cost lands on Purchase invoice 1 batches in the R6020 report
	And I close all client application windows
	* Run the R6020 Batch balance report
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click "Generate" button
	* Check the allocated cost numbers on the goods batches
		Then "Result" spreadsheet document contains values:
			| '47,74'  |
			| '23,98'  |
			| '21,87'  |
			| '5,54'   |
			| 'Purchase invoice 1 dated 24.02.2023 10:04:33' |
	And I close all client application windows


# STORNO (user-level, by numbers) - stornoing the cost invoice writes its allocatable cost back in
# R6070 Other periods expenses with the opposite sign (-100,00 in the legal currency), i.e. the cost that
# fed the allocation is removed on the storno date.
Scenario: _2972003 check Storno of the cost invoice reverses its allocatable cost in R6070
	And I close all client application windows
	* Create a Storno for the cost invoice Purchase invoice 11
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '11'     |
		And I select current line in "List" table
		And I click the button named "FormDocumentStornoStorno"
		And I input "01.01.2026" text in the field named "Date"
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		Then system warning window does not appear
	* Generate the storno registrations report and check R6070 is written back with the opposite sign
		And I click "Registrations report" button
		And I select "R6070 Other periods expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains values:
			| '-100'                                                  |
			| 'Purchase invoice 11 dated 25.02.2023 12:00:00'         |
	And I close all client application windows
