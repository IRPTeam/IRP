#language: en
@tree
@Positive


Feature: access rights system roles for documents



Scenario: _964000 preparation (access rights roles for documents)
	And I connect "Этот клиент" TestClient using "CI" login and "CI" password
	When set True value to the constant
	When set True value to the constant Use commission trading
	When set True value to the constant Use accounting
	When set True value to the constant Use consolidated retail sales
	When set True value to the constant Use object access
	When set True value to the constant Use salary
	When set True value to the constant Use fixed assets
	* Add VA extension
		Given I open hyperlink "e1cib/list/Catalog.Extensions"
		If "List" table does not contain lines Then
				| "Description"     |
				| "VAExtension"     |
			When add VAExtension
	And I close TestClient session
	And I connect "Этот клиент" TestClient using "CI" login and "CI" password
	When Create catalog Users and AccessProfiles objects (LimitedAccess)
	When Create catalog AccessGroups objects (roles for documents)
	When Create catalog AccessProfiles objects (roles for documents)
	When Create catalog Users objects (roles for documents)
	Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
	And I go to line in "List" table
		| 'Description'          |
		| 'Unit access group'    |
	And I select current line in "List" table	
	If "Profiles" table does not contain lines Then
		| 'Profile'      |
		| 'Unit profile' |
		And in the table "Profiles" I click "Add" button
		And I click choice button of "Profile" attribute in "Profiles" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Unit profile'    |
		And I select current line in "List" table
		And I move to "Users" tab
		And I finish line editing in "Profiles" table
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And I go to line in "List" table
			| 'Description'   |
			| 'LimitedAccess' |
		And I select current line in "List" table
		And I finish line editing in "Users" table
	* Check ObjectAccess table
		When filling Access key in the AccessGroups
	And I click "Save and close" button
	When import data for access rights
	And I close all client application windows

Scenario: _964001 check preparation
	When check preparation

Scenario: _964002 check role use Document Additional cost allocation
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "AddCostAllocation" login and "" password
	Given I open hyperlink "e1cib/list/Document.AdditionalCostAllocation"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964003 check role use Document AdditionalAccrual
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocAdditionalAccrual" login and "" password
	Given I open hyperlink "e1cib/list/Document.AdditionalAccrual"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964004 check role use Document Additional deduction
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocAdditionalDeduction" login and "" password
	Given I open hyperlink "e1cib/list/Document.AdditionalDeduction"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964005 check role use Document Additional revenue allocation
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocAdditionalRevenueAlloc" login and "" password
	Given I open hyperlink "e1cib/list/Document.AdditionalRevenueAllocation"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964006 check role use Document Bank payment
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocBankPayment" login and "" password
	Given I open hyperlink "e1cib/list/Document.BankPayment"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964007 check role use Document Bank receipt
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocBankReceipt" login and "" password
	Given I open hyperlink "e1cib/list/Document.BankReceipt"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964008 check role use Document Batch reallocate incoming
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocBatchReallocateIncomin" login and "" password
	Given I open hyperlink "e1cib/list/Document.BatchReallocateIncoming"	
	And I click the button named "FormCreate"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964009 check role use Document Batch reallocate outgoing
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocBatchReallocateOutgoin" login and "" password
	Given I open hyperlink "e1cib/list/Document.BatchReallocateOutgoing"	
	And I click the button named "FormCreate"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964010 check role use Document Bundling
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocBundling" login and "" password
	Given I open hyperlink "e1cib/list/Document.Bundling"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964011 check role use Document Calculation movement cost
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocCalculationMovementCos" login and "" password
	Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964012 check role use Document Cash expense
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocCashExpense" login and "" password
	Given I open hyperlink "e1cib/list/Document.CashExpense"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964013 check role use Document Cash payment
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocCashPayment" login and "" password
	Given I open hyperlink "e1cib/list/Document.CashPayment"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964014 check role use Document Cash receipt
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocCashReceipt" login and "" password
	Given I open hyperlink "e1cib/list/Document.CashReceipt"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964015 check role use Document Cash revenue
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocCashRevenue" login and "" password
	Given I open hyperlink "e1cib/list/Document.CashRevenue"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964016 check role use Document Cash statement
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocCashStatement" login and "" password
	Given I open hyperlink "e1cib/list/Document.CashStatement"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964017 check role use Document Cash transfer order
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocCashTransferOrder" login and "" password
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964018 check role use Document Cheque bond transaction
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocChequeBondTransaction" login and "" password
	Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964019 check role use Document Cheque bond trans item
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocChequeBondTransItem" login and "" password
	Given I open hyperlink "e1cib/list/Document.ChequeBondTransactionItem"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964020 check role use Document Commissioning of fixed asset
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocCommissioningOfFixedAs" login and "" password
	Given I open hyperlink "e1cib/list/Document.CommissioningOfFixedAsset"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964021 check role use Document Consolidated retail sales
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocConsolidatedRetailSale" login and "" password
	Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964022 check role use Document Credit note
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocCreditNote" login and "" password
	Given I open hyperlink "e1cib/list/Document.CreditNote"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964023 check role use Document Customers advances closing
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocCustomersAdvancesClos" login and "" password
	Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964024 check role use Document Debit note
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocDebitNote" login and "" password
	Given I open hyperlink "e1cib/list/Document.DebitNote"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964025 check role use Document Decommissioning of fixed asset
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocDecommissioningOfFixed" login and "" password
	Given I open hyperlink "e1cib/list/Document.DecommissioningOfFixedAsset"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964026 check role use Document Depreciation calculation
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocDepreciationCalculatio" login and "" password
	Given I open hyperlink "e1cib/list/Document.DepreciationCalculation"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964027 check role use Document Employee cash advance
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocEmployeeCashAdvance" login and "" password
	Given I open hyperlink "e1cib/list/Document.EmployeeCashAdvance"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964028 check role use Document Employee firing
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocEmployeeFiring" login and "" password
	Given I open hyperlink "e1cib/list/Document.EmployeeFiring"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964029 check role use Document Employee hiring
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocEmployeeHiring" login and "" password
	Given I open hyperlink "e1cib/list/Document.EmployeeHiring"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964030 check role use Document Employee sick leave
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocEmployeeSickLeave" login and "" password
	Given I open hyperlink "e1cib/list/Document.EmployeeSickLeave"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964031 check role use Document Employee transfer
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocEmployeeTransfer" login and "" password
	Given I open hyperlink "e1cib/list/Document.EmployeeTransfer"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964032 check role use Document Employee vacation
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocEmployeeVacation" login and "" password
	Given I open hyperlink "e1cib/list/Document.EmployeeVacation"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |


Scenario: _964033 check role use Document Fixed asset transfer
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocFixedAssetTransfer" login and "" password
	Given I open hyperlink "e1cib/list/Document.FixedAssetTransfer"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964034 check role use Document Foreign currency revaluation
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocForeignCurrencyRevalua" login and "" password
	Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964035 check role use Document Goods receipt
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocGoodsReceipt" login and "" password
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964036 check role use Document IncomingPaymentOrder
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocIncomingPaymentOrder" login and "" password
	Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964037 check role use Document InternalSupplyRequest
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocInternalSupplyRequest" login and "" password
	Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964038 check role use Document Inventory transfer
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocInventoryTransfer" login and "" password
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964039 check role use Document Inventory transfer order
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocInventoryTransferOrder" login and "" password
	Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964040 check role use Document Item stock adjustment
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocItemStockAdjustment" login and "" password
	Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964041 check role use Document Journal entry
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocJournalEntry" login and "" password
	Given I open hyperlink "e1cib/list/Document.JournalEntry"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964042 check role use Document Labeling
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocLabeling" login and "" password
	Given I open hyperlink "e1cib/list/Document.Labeling"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964043 check role use Document Manual register entry
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocManualRegisterEntry" login and "" password
	Given I open hyperlink "e1cib/list/Document.ManualRegisterEntry"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964044 check role use Document Modernization of fixed asset
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocModernizationOfFixedAs" login and "" password
	Given I open hyperlink "e1cib/list/Document.ModernizationOfFixedAsset"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964045 check role use Document Money transfer
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocMoneyTransfer" login and "" password
	Given I open hyperlink "e1cib/list/Document.MoneyTransfer"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964046 check role use Document Opening entry
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocOpeningEntry" login and "" password
	Given I open hyperlink "e1cib/list/Document.OpeningEntry"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964047 check role use Document Outgoing payment order
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocOutgoingPaymentOrder" login and "" password
	Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964048 check role use Document Payroll
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocPayroll" login and "" password
	Given I open hyperlink "e1cib/list/Document.Payroll"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964049 check role use Document Physical count by location
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocPhysicalCountByLocat" login and "" password
	Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964050 check role use Document Physical inventory
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocPhysicalInventory" login and "" password
	Given I open hyperlink "e1cib/list/Document.PhysicalInventory"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |


Scenario: _964051 check role use Document Planned receipt reservation
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocPlannedReceiptReservat" login and "" password
	Given I open hyperlink "e1cib/list/Document.PlannedReceiptReservation"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964052 check role use Document Price list
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocPriceList" login and "" password
	Given I open hyperlink "e1cib/list/Document.PriceList"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964053 check role use Document Production
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocProduction" login and "" password
	Given I open hyperlink "e1cib/list/Document.Production"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964054 check role use Document Production costs allocation
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocProductionCostsAllocat" login and "" password
	Given I open hyperlink "e1cib/list/Document.ProductionCostsAllocation"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964055 check role use Document Production planning
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocProductionPlanning" login and "" password
	Given I open hyperlink "e1cib/list/Document.ProductionPlanning"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964056 check role use Document Production planning closing
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocProductionPlanningClos" login and "" password
	Given I open hyperlink "e1cib/list/Document.ProductionPlanningClosing"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964057 check role use Document Production planning correction
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocProductionPlanningCorr" login and "" password
	Given I open hyperlink "e1cib/list/Document.ProductionPlanningCorrection"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964058 check role use Document Purchase invoice
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocPurchaseInvoice" login and "" password
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964059 check role use Document Purchase order
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocPurchaseOrder" login and "" password
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964060 check role use Document Purchase order closing
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocPurchaseOrderClosing" login and "" password
	Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964061 check role use Document Purchase return
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocPurchaseReturn" login and "" password
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964062 check role use Document Purchase return order
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocPurchaseReturnOrder" login and "" password
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |


Scenario: _964063 check role use Document Reconciliation statement
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocReconciliationStatemen" login and "" password
	Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964064 check role use Document Retail goods receipt
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocRetailGoodsReceipt" login and "" password
	Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964065 check role use Document Retail receipt correction
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocRetailReceiptCorrectio" login and "" password
	Given I open hyperlink "e1cib/list/Document.RetailReceiptCorrection"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964066 check role use Document Retail return receipt
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocRetailReturnReceipt" login and "" password
	Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964067 check role use Document Retail sales receipt
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocRetailSalesReceipt" login and "" password
	Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964068 check role use Document Retail shipment confirmation
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocRetailShipmentConfirma" login and "" password
	Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964069 check role use Document Sales invoice
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocSalesInvoice" login and "" password
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964070 check role use Document Sales order
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocSalesOrder" login and "" password
	Given I open hyperlink "e1cib/list/Document.SalesOrder"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964071 check role use Document Sales order closing
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocSalesOrderClosing" login and "" password
	Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |


Scenario: _964072 check role use Document Sales report from trade agent
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocSalesReportFromTradeAg" login and "" password
	Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964073 check role use Document Sales report to consignor
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocSalesReportToConsignor" login and "" password
	Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964074 check role use Document Sales return
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocSalesReturn" login and "" password
	Given I open hyperlink "e1cib/list/Document.SalesReturn"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964075 check role use Document Sales return order
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocSalesReturnOrder" login and "" password
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964076 check role use Document Shipment confirmation
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocShipmentConfirmation" login and "" password
	Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964077 check role use Document Stock adjustment as surplus
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocStockAdjustmentAsSurpl" login and "" password
	Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964078 check role use Document Stock adjustment as write off
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocStockAdjustmentAsWrite" login and "" password
	Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964079 check role use Document Time sheet
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocTimeSheet" login and "" password
	Given I open hyperlink "e1cib/list/Document.TimeSheet"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964080 check role use Document Unbundling
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocUnbundling" login and "" password
	Given I open hyperlink "e1cib/list/Document.Unbundling"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964081 check role use Document Vendors advances closing
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocVendorsAdvancesClosing" login and "" password
	Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964082 check role use Document Visitor counter
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocVisitorCounter" login and "" password
	Given I open hyperlink "e1cib/list/Document.VisitorCounter"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |


Scenario: _964083 check role use Document Work order
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocWorkOrder" login and "" password
	Given I open hyperlink "e1cib/list/Document.WorkOrder"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964084 check role use Document Work order closing
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocWorkOrderClosing" login and "" password
	Given I open hyperlink "e1cib/list/Document.WorkOrderClosing"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |

Scenario: _964085 check role use Document Work sheet
	And I close TestClient session
	And I connect "TestAdmin" TestClient using "DocWorkSheet" login and "" password
	Given I open hyperlink "e1cib/list/Document.WorkSheet"	
	And I click the button named "FormCreate"
	And I click the button named "FormWrite"
	When I Check the steps for Exception
		| 'Then "1C:Enterprise" window is opened'    |