﻿#language: en
@tree
@IgnoreOnCIMainBuild
@ExportScenarios

Feature: export scenarios (wrong data)

Background:
	Given I launch TestClient opening script or connect the existing one




Scenario: Create document RetailSalesReceipt objects (wrong data)

	And I check or create for document "RetailSalesReceipt" objects with Data Exchange Load parameter set to true:
		| 'Ref'                                                                         | 'DeletionMark' | 'Number' | 'Date'                | 'Posted' | 'Agreement'                                                          | 'BasisDocument' | 'Company'                                                           | 'Currency'                                                           | 'DateOfShipment'      | 'LegalName'                                                         | 'Manager' | 'ManagerSegment'                                                          | 'Partner'                                                          | 'PriceIncludeTax' | 'RetailCustomer' | 'UsePartnerTransactions' | 'LegalNameContract' | 'ConsolidatedRetailSales' | 'Workstation' | 'PaymentMethod'                              | 'Author'                                                        | 'Branch' | 'Description' | 'DocumentAmount' |
		| 'e1cib/data/Document.RetailSalesReceipt?ref=b797a0d6c37f8d9211edbcf6e64807e8' | 'False'        | 8811     | '07.03.2023 16:47:01' | 'True'   | 'e1cib/data/Catalog.Agreements?ref=aa78120ed92fbced11eaf118bdb7bb73' | ''              | 'e1cib/data/Catalog.Companies?ref=aa78120ed92fbced11eaf113ba6c185c' | 'e1cib/data/Catalog.Currencies?ref=aa78120ed92fbced11eaf113ba6c1855' | '01.01.0001 00:00:00' | 'e1cib/data/Catalog.Companies?ref=aa78120ed92fbced11eaf116b32709a3' | ''        | 'e1cib/data/Catalog.PartnerSegments?ref=aa78120ed92fbced11eaf116b327099c' | 'e1cib/data/Catalog.Partners?ref=aa78120ed92fbced11eaf113ba6c1871' | 'True'            | ''               | 'False'                  | ''                  | ''                        | ''            | 'Enum.ReceiptPaymentMethods.FullCalculation' | 'e1cib/data/Catalog.Users?ref=aa7f120ed92fbced11eb13d7279770c0' | ''       | ''            | 3154             |
		
	And I refill object tabular section "ItemList":
		| 'Ref'                                                                         | 'TotalAmount' | 'NetAmount' | 'Item'                                                          | 'ItemKey'                                                          | 'Store'                                                          | 'OffersAmount' | 'Price' | 'Quantity' | 'TaxAmount' | 'Key'                                  | 'Unit'                                                          | 'PriceType'                                                          | 'Detail' | 'ProfitLossCenter' | 'RevenueType'                                                                    | 'AdditionalAnalytic' | 'DontCalculateRow' | 'QuantityInBaseUnit' | 'SalesPerson' | 'UseSerialLotNumber' | 'IsService' | 'InventoryOrigin'                      | 'SalesOrder' |
		| 'e1cib/data/Document.RetailSalesReceipt?ref=b797a0d6c37f8d9211edbcf6e64807e8' | 988           | 836.29      | 'e1cib/data/Catalog.Items?ref=aa78120ed92fbced11eaf115bcc9c5f3' | 'e1cib/data/Catalog.ItemKeys?ref=aa78120ed92fbced11eaf115bcc9c5fc' | 'e1cib/data/Catalog.Stores?ref=aa78120ed92fbced11eaf114c59ef00b' | 52             | 520     | 2          | 150.71      | '47818d61-c053-44b3-b700-5d2d9b17b6a1' | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862' | 'e1cib/data/Catalog.PriceTypes?ref=aa78120ed92fbced11eaf114c59eeffe' | ''       | ''                 | 'e1cib/data/Catalog.ExpenseAndRevenueTypes?ref=aa78120ed92fbced11eaf114c59ef02a' | ''                   | 'False'            | 2                    | ''            | 'False'              | 'False'     | 'Enum.InventoryOriginTypes.OwnStocks' | ''           |
		| 'e1cib/data/Document.RetailSalesReceipt?ref=b797a0d6c37f8d9211edbcf6e64807e8' | 1976          | 1674.58     | 'e1cib/data/Catalog.Items?ref=aa78120ed92fbced11eaf115bcc9c5f3' | 'e1cib/data/Catalog.ItemKeys?ref=aa78120ed92fbced11eaf115bcc9c5fd' | 'e1cib/data/Catalog.Stores?ref=aa78120ed92fbced11eaf114c59ef00b' | 104            | 520     | 4          | 302.42      | 'fb1608f0-2ee3-4896-ac2c-9629b2d32eb2' | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862' | 'e1cib/data/Catalog.PriceTypes?ref=aa78120ed92fbced11eaf114c59eeffe' | ''       | ''                 | 'e1cib/data/Catalog.ExpenseAndRevenueTypes?ref=aa78120ed92fbced11eaf114c59ef02a' | ''                   | 'False'            | 4                    | ''            | 'False'              | 'False'     | 'Enum.InventoryOriginTypes.OwnStocks' | ''           |
		| 'e1cib/data/Document.RetailSalesReceipt?ref=b797a0d6c37f8d9211edbcf6e64807e8' | 190           | 161.02      | 'e1cib/data/Catalog.Items?ref=b780c87413d4c65f11ecd519fda7206f' | 'e1cib/data/Catalog.ItemKeys?ref=b780c87413d4c65f11ecd519fda72070' | 'e1cib/data/Catalog.Stores?ref=aa78120ed92fbced11eaf114c59ef00b' | 10             | 100     | 2          | 28.98       | '3668a422-cfe7-45f3-b408-32602e3d6cc4' | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862' | 'e1cib/data/Catalog.PriceTypes?refName=ManualPriceType'              | ''       | ''                 | 'e1cib/data/Catalog.ExpenseAndRevenueTypes?ref=aa78120ed92fbced11eaf114c59ef027' | ''                   | 'False'            | 2                    | ''            | 'True'               | 'False'     | 'Enum.InventoryOriginTypes.OwnStocks' | ''           |
		
	And I refill object tabular section "SpecialOffers":
		| 'Ref'                                                                         | 'Key'                                  | 'Offer'                                                                 | 'Amount' | 'Percent' |
		| 'e1cib/data/Document.RetailSalesReceipt?ref=b797a0d6c37f8d9211edbcf6e64807e8' | '47818d61-c053-44b3-b700-5d2d9b17b6a1' | 'e1cib/data/Catalog.SpecialOffers?ref=b76197e183b782dc11eb60c82e154a51' | 54       |           |
		| 'e1cib/data/Document.RetailSalesReceipt?ref=b797a0d6c37f8d9211edbcf6e64807e8' | 'fb1608f0-2ee3-4896-ac2c-9629b2d32eb2' | 'e1cib/data/Catalog.SpecialOffers?ref=b76197e183b782dc11eb60c82e154a51' | 104      |           |
		| 'e1cib/data/Document.RetailSalesReceipt?ref=b797a0d6c37f8d9211edbcf6e64807e8' | '3668a422-cfe7-45f3-b408-32602e3d6cc4' | 'e1cib/data/Catalog.SpecialOffers?ref=b76197e183b782dc11eb60c82e154a51' | 10       |           |
		
	And I refill object tabular section "TaxList":
		| 'Ref'                                                                         | 'Key'                                  | 'Tax'                                                           | 'Analytics' | 'TaxRate'                                                          | 'Amount' | 'IncludeToTotalAmount' | 'ManualAmount' |
		| 'e1cib/data/Document.RetailSalesReceipt?ref=b797a0d6c37f8d9211edbcf6e64807e8' | '47818d61-c053-44b3-b700-5d2d9b17b6a1' | 'e1cib/data/Catalog.Taxes?ref=aa78120ed92fbced11eaf116b32709c4' | ''          | 'e1cib/data/Catalog.TaxRates?ref=aa78120ed92fbced11eaf114c59ef010' | 150.71   | 'True'                 | 150.71         |
		| 'e1cib/data/Document.RetailSalesReceipt?ref=b797a0d6c37f8d9211edbcf6e64807e8' | 'fb1608f0-2ee3-4896-ac2c-9629b2d32eb2' | 'e1cib/data/Catalog.Taxes?ref=aa78120ed92fbced11eaf116b32709c4' | ''          | 'e1cib/data/Catalog.TaxRates?ref=aa78120ed92fbced11eaf114c59ef010' | 301.42   | 'True'                 | 301.42         |
		| 'e1cib/data/Document.RetailSalesReceipt?ref=b797a0d6c37f8d9211edbcf6e64807e8' | '3668a422-cfe7-45f3-b408-32602e3d6cc4' | 'e1cib/data/Catalog.Taxes?ref=aa78120ed92fbced11eaf116b32709c4' | ''          | 'e1cib/data/Catalog.TaxRates?ref=aa78120ed92fbced11eaf114c59ef010' | 28.98    | 'True'                 | 28.98          |
	
	And I refill object tabular section "Currencies":
		| 'Ref'                                                                         | 'Key'                                  | 'CurrencyFrom'                                                       | 'Rate' | 'ReverseRate' | 'ShowReverseRate' | 'Multiplicity' | 'MovementType'                                                                                    | 'Amount' | 'IsFixed' |
		| 'e1cib/data/Document.RetailSalesReceipt?ref=b797a0d6c37f8d9211edbcf6e64807e8' | '                                    ' | 'e1cib/data/Catalog.Currencies?ref=aa78120ed92fbced11eaf113ba6c1855' | 1      | 1             | 'False'           | 1              | 'e1cib/data/ChartOfCharacteristicTypes.CurrencyMovementType?ref=aa78120ed92fbced11eaf113ba6c185f' | 3154     | 'False'   |
		| 'e1cib/data/Document.RetailSalesReceipt?ref=b797a0d6c37f8d9211edbcf6e64807e8' | '                                    ' | 'e1cib/data/Catalog.Currencies?ref=aa78120ed92fbced11eaf113ba6c1855' | 1      | 1             | 'False'           | 1              | 'e1cib/data/ChartOfCharacteristicTypes.CurrencyMovementType?ref=aa78120ed92fbced11eaf113ba6c185d' | 3154     | 'False'   |
		| 'e1cib/data/Document.RetailSalesReceipt?ref=b797a0d6c37f8d9211edbcf6e64807e8' | '                                    ' | 'e1cib/data/Catalog.Currencies?ref=aa78120ed92fbced11eaf113ba6c1855' | 0.1712 | 5.8411        | 'False'           | 1              | 'e1cib/data/ChartOfCharacteristicTypes.CurrencyMovementType?ref=aa78120ed92fbced11eaf113ba6c185e' | 539.96   | 'False'   |
	
	And I refill object tabular section "Payments":
		| 'Ref'                                                                         | 'Key'                                  | 'PaymentType'                                                          | 'PaymentTerminal' | 'Account'                                                              | 'Amount' | 'Percent' | 'Commission' | 'BankTerm' | 'RRNCode' | 'PaymentInfo' |
		| 'e1cib/data/Document.RetailSalesReceipt?ref=b797a0d6c37f8d9211edbcf6e64807e8' | '58b57c83-b290-47cb-b56a-0f7ad49fa513' | 'e1cib/data/Catalog.PaymentTypes?ref=aa78120ed92fbced11eaf12effe70fcf' | ''                | 'e1cib/data/Catalog.CashAccounts?ref=aa78120ed92fbced11eaf113ba6c1868' | 3154     |           |              | ''         | ''        | ''            |
	
	And I refill object tabular section "SerialLotNumbers":
		| 'Ref'                                                                         | 'Key'                                  | 'SerialLotNumber'                                                          | 'Quantity' |
		| 'e1cib/data/Document.RetailSalesReceipt?ref=b797a0d6c37f8d9211edbcf6e64807e8' | '3668a422-cfe7-45f3-b408-32602e3d6cc4' | 'e1cib/data/Catalog.SerialLotNumbers?ref=b78db8d3fd6dff8b11ed7f756a377c11' | 2          |

Scenario: Create document GoodsReceipt objects (wrong data)


	And I check or create for document "GoodsReceipt" objects with Data Exchange Load parameter set to true:
		| 'Ref'                                                                   | 'DeletionMark' | 'Number' | 'Date'                | 'Posted' | 'Company'                                                           | 'LegalName'                                                         | 'Partner'                                                          | 'TransactionType'                            | 'Author'                                                        | 'Branch' | 'Description' |
		| 'e1cib/data/Document.GoodsReceipt?ref=b797a0d6c37f8d9211edbf4999f03222' | 'False'        | 8811     | '10.03.2023 15:43:56' | 'True'   | 'e1cib/data/Catalog.Companies?ref=aa78120ed92fbced11eaf113ba6c185c' | 'e1cib/data/Catalog.Companies?ref=aa78120ed92fbced11eaf116b32709a2' | 'e1cib/data/Catalog.Partners?ref=aa78120ed92fbced11eaf113ba6c1870' | 'Enum.GoodsReceiptTransactionTypes.Purchase' | 'e1cib/data/Catalog.Users?ref=aa7f120ed92fbced11eb13d7279770c0' | ''       | ''            |

	And I refill object tabular section "ItemList":
		| 'Ref'                                                                   | 'Key'                                  | 'Item'                                                          | 'ItemKey'                                                          | 'Store'                                                          | 'Unit'                                                          | 'Quantity' | 'ReceiptBasis' | 'SalesOrder' | 'QuantityInBaseUnit' | 'PurchaseInvoice' | 'PurchaseOrder' | 'InternalSupplyRequest' | 'InventoryTransferOrder' | 'SalesReturn' | 'SalesReturnOrder' | 'InventoryTransfer' | 'SalesInvoice' | 'UseSerialLotNumber' | 'ProductionPlanning' |
		| 'e1cib/data/Document.GoodsReceipt?ref=b797a0d6c37f8d9211edbf4999f03222' | 'c694e72f-6033-4ba0-8d48-316961c86c5b' | 'e1cib/data/Catalog.Items?ref=aa78120ed92fbced11eaf115bcc9c5f6' | 'e1cib/data/Catalog.ItemKeys?ref=aa78120ed92fbced11eaf115bcc9c604' | 'e1cib/data/Catalog.Stores?ref=aa78120ed92fbced11eaf114c59ef00d' | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862' | 2          | ''             | ''           | 3                    | ''                | ''              | ''                      | ''                       | ''            | ''                 | ''                  | ''             | 'False'              | ''                   |
		| 'e1cib/data/Document.GoodsReceipt?ref=b797a0d6c37f8d9211edbf4999f03222' | 'dc2f5b46-32dd-4d4d-bfae-540118534afc' | 'e1cib/data/Catalog.Items?ref=b780c87413d4c65f11ecd519fda7206f' | 'e1cib/data/Catalog.ItemKeys?ref=b780c87413d4c65f11ecd519fda72071' | 'e1cib/data/Catalog.Stores?ref=aa78120ed92fbced11eaf114c59ef00d' | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862' | 2          | ''             | ''           | 2                    | ''                | ''              | ''                      | ''                       | ''            | ''                 | ''                  | ''             | 'True'               | ''                   |

	And I refill object tabular section "RowIDInfo":
		| 'Ref'                                                                   | 'Key'                                  | 'RowID'                                | 'Quantity' | 'Basis' | 'CurrentStep' | 'NextStep'                                    | 'RowRef'                                                         | 'BasisKey'                             |
		| 'e1cib/data/Document.GoodsReceipt?ref=b797a0d6c37f8d9211edbf4999f03222' | 'c694e72f-6033-4ba0-8d48-316961c86c5b' | 'c694e72f-6033-4ba0-8d48-316961c86c5b' | 4          | ''      | ''            | 'e1cib/data/Catalog.MovementRules?refName=PI' | 'e1cib/data/Catalog.RowIDs?ref=b797a0d6c37f8d9211edbf4999f03220' | '                                    ' |
		| 'e1cib/data/Document.GoodsReceipt?ref=b797a0d6c37f8d9211edbf4999f03222' | 'dc2f5b46-32dd-4d4d-bfae-540118534afc' | 'dc2f5b46-32dd-4d4d-bfae-540118534afc' | 2          | ''      | ''            | 'e1cib/data/Catalog.MovementRules?refName=PI' | 'e1cib/data/Catalog.RowIDs?ref=b797a0d6c37f8d9211edbf4999f03221' | '                                    ' |

	And I refill object tabular section "SerialLotNumbers":
		| 'Ref'                                                                   | 'Key'                                  | 'SerialLotNumber'                                                          | 'Quantity' |
		| 'e1cib/data/Document.GoodsReceipt?ref=b797a0d6c37f8d9211edbf4999f03222' | 'dc2f5b46-32dd-4d4d-bfae-540118534afc' | 'e1cib/data/Catalog.SerialLotNumbers?ref=b781cf3f5e36b25611ecd8431212163a' | 2          |
	
	Scenario: Create document InventoryTransfer (wrong data)

	And I check or create for document "InventoryTransfer" objects with Data Exchange Load parameter set to true:
		| 'Ref'                                                                        | 'DeletionMark' | 'Number' | 'Date'                | 'Posted' | 'Company'                                                           | 'StoreReceiver'                                                  | 'StoreSender'                                                    | 'StoreTransit' | 'UseGoodsReceipt' | 'UseShipmentConfirmation' | 'Author'                                                        | 'Branch' | 'Description' |
		| 'e1cib/data/Document.InventoryTransfer?ref=b797a0d6c37f8d9211edbf552d66e509' | 'False'        | 8811     | '10.03.2023 17:06:48' | 'True'   | 'e1cib/data/Catalog.Companies?ref=aa78120ed92fbced11eaf113ba6c185c' | 'e1cib/data/Catalog.Stores?ref=aa78120ed92fbced11eaf114c59ef00d' | 'e1cib/data/Catalog.Stores?ref=aa78120ed92fbced11eaf114c59ef00c' | ''             | 'True'            | 'True'                    | 'e1cib/data/Catalog.Users?ref=aa7f120ed92fbced11eb13d7279770c0' | ''       | ''            |

	And I refill object tabular section "ItemList":
		| 'Ref'                                                                        | 'Key'                                  | 'Item'                                                          | 'ItemKey'                                                          | 'Unit'                                                          | 'Quantity' | 'InventoryTransferOrder' | 'QuantityInBaseUnit' | 'UseSerialLotNumber' | 'ProductionPlanning' | 'InventoryOrigin'                      |
		| 'e1cib/data/Document.InventoryTransfer?ref=b797a0d6c37f8d9211edbf552d66e509' | 'cc09621e-7c6a-4bc5-a396-dd01bccc7ccf' | 'e1cib/data/Catalog.Items?ref=aa78120ed92fbced11eaf115bcc9c5f5' | 'e1cib/data/Catalog.ItemKeys?ref=aa78120ed92fbced11eaf115bcc9c5fb' | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862' | 0          | ''                       | 2                    | 'False'              | ''                   | 'Enum.InventoryOriginTypes.OwnStocks' |
		| 'e1cib/data/Document.InventoryTransfer?ref=b797a0d6c37f8d9211edbf552d66e509' | '2dde443d-ad9e-4029-96f5-7210ecea26d2' | 'e1cib/data/Catalog.Items?ref=b780c87413d4c65f11ecd519fda7206f' | 'e1cib/data/Catalog.ItemKeys?ref=b780c87413d4c65f11ecd519fda72070' | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862' | 2          | ''                       | 2                    | 'True'               | ''                   | 'Enum.InventoryOriginTypes.OwnStocks' |
		| 'e1cib/data/Document.InventoryTransfer?ref=b797a0d6c37f8d9211edbf552d66e509' | '92f7acdb-3d1c-4c92-92de-17eed73ca382' | 'e1cib/data/Catalog.Items?ref=b780c87413d4c65f11ecd519fda7206f' | 'e1cib/data/Catalog.ItemKeys?ref=b780c87413d4c65f11ecd519fda72071' | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862' | 2          | ''                       | 2                    | 'True'               | ''                   | 'Enum.InventoryOriginTypes.OwnStocks' |

	And I refill object tabular section "SerialLotNumbers":
		| 'Ref'                                                                        | 'Key'                                  | 'SerialLotNumber'                                                          | 'Quantity' |
		| 'e1cib/data/Document.InventoryTransfer?ref=b797a0d6c37f8d9211edbf552d66e509' | '92f7acdb-3d1c-4c92-92de-17eed73ca382' | 'e1cib/data/Catalog.SerialLotNumbers?ref=b781cf3f5e36b25611ecd8431212163a' | 2          |

Scenario: Create document InventoryTransferOrder objects (wrong data)

	And I check or create for document "InventoryTransferOrder" objects with Data Exchange Load parameter set to true:
		| 'Ref'                                                                             | 'DeletionMark' | 'Number' | 'Date'                | 'Posted' | 'Company'                                                           | 'Status'                                                                 | 'StoreReceiver'                                                  | 'StoreSender'                                                    | 'Author'                                                        | 'Branch' | 'Description' |
		| 'e1cib/data/Document.InventoryTransferOrder?ref=b797a0d6c37f8d9211edbf570cfe1012' | 'False'        | 8811     | '10.03.2023 17:20:12' | 'True'   | 'e1cib/data/Catalog.Companies?ref=aa78120ed92fbced11eaf113ba6c185c' | 'e1cib/data/Catalog.ObjectStatuses?ref=aa78120ed92fbced11eaf114c59ef015' | 'e1cib/data/Catalog.Stores?ref=aa78120ed92fbced11eaf114c59ef00d' | 'e1cib/data/Catalog.Stores?ref=aa78120ed92fbced11eaf114c59ef00c' | 'e1cib/data/Catalog.Users?ref=aa7f120ed92fbced11eb13d7279770c0' | ''       | ''            |

	And I refill object tabular section "ItemList":
		| 'Ref'                                                                             | 'Key'                                  | 'Item'                                                          | 'ItemKey'                                                          | 'Unit'                                                          | 'Quantity' | 'InternalSupplyRequest' | 'QuantityInBaseUnit' | 'PurchaseOrder' |
		| 'e1cib/data/Document.InventoryTransferOrder?ref=b797a0d6c37f8d9211edbf570cfe1012' | '1c13a7f4-8528-4df0-821b-8d032df4c16a' | 'e1cib/data/Catalog.Items?ref=aa78120ed92fbced11eaf115bcc9c5f3' | 'e1cib/data/Catalog.ItemKeys?ref=aa78120ed92fbced11eaf115bcc9c5fc' | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862' | 3          | ''                      | 0                    | ''              |
		| 'e1cib/data/Document.InventoryTransferOrder?ref=b797a0d6c37f8d9211edbf570cfe1012' | '4904e035-b567-4d82-bf9a-7e8c25e279ff' | 'e1cib/data/Catalog.Items?ref=aa78120ed92fbced11eaf115bcc9c5f3' | 'e1cib/data/Catalog.ItemKeys?ref=aa78120ed92fbced11eaf115bcc9c5fd' | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862' | 3          | ''                      | 0                    | ''              |

Scenario: Create document InternalSupplyRequest objects (wrong data)

	And I check or create for document "InternalSupplyRequest" objects with Data Exchange Load parameter set to true:
		| 'Ref'                                                                            | 'DeletionMark' | 'Number' | 'Date'                | 'Posted' | 'Company'                                                           | 'Store'                                                          | 'ProcurementDate'    | 'Author'                                                        | 'Branch' | 'Description' |
		| 'e1cib/data/Document.InternalSupplyRequest?ref=b797a0d6c37f8d9211edbf570cfe1014' | 'False'        | 8811     | '10.03.2023 17:24:29' | 'True'   | 'e1cib/data/Catalog.Companies?ref=aa78120ed92fbced11eaf113ba6c185c' | 'e1cib/data/Catalog.Stores?ref=aa78120ed92fbced11eaf114c59ef00c' | '01.01.0001 0:00:00' | 'e1cib/data/Catalog.Users?ref=aa7f120ed92fbced11eb13d7279770c0' | ''       | ''            |

	And I refill object tabular section "ItemList":
		| 'Ref'                                                                            | 'Key'                                  | 'Item'                                                          | 'ItemKey'                                                          | 'Unit'                                                          | 'Quantity' | 'QuantityInBaseUnit' |
		| 'e1cib/data/Document.InternalSupplyRequest?ref=b797a0d6c37f8d9211edbf570cfe1014' | 'eed7336c-b56a-446e-9486-4b182c30d0ce' | 'e1cib/data/Catalog.Items?ref=aa78120ed92fbced11eaf115bcc9c5f3' | 'e1cib/data/Catalog.ItemKeys?ref=aa78120ed92fbced11eaf115bcc9c5fc' | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862' | 0          | 0                    |

	

Scenario: Create document SalesOrder objects (wrong data)

	And I check or create for document "SalesOrder" objects with Data Exchange Load parameter set to true:
		| 'Ref'                                                                 | 'DeletionMark' | 'Number' | 'Date'                | 'Posted' | 'Agreement'                                                          | 'Company'                                                           | 'Currency'                                                           | 'DateOfShipment'     | 'LegalName'                                                         | 'ManagerSegment'                                                          | 'Partner'                                                          | 'PriceIncludeTax' | 'Status'                                                                 | 'UseItemsShipmentScheduling' | 'TransactionType'                  | 'RetailCustomer' | 'Author'                                                        | 'Branch' | 'Description' | 'DocumentAmount' |
		| 'e1cib/data/Document.SalesOrder?ref=b797a0d6c37f8d9211edbf570cfe1017' | 'False'        | 8811     | '10.03.2023 17:32:00' | 'True'   | 'e1cib/data/Catalog.Agreements?ref=aa78120ed92fbced11eaf118bdb7bb73' | 'e1cib/data/Catalog.Companies?ref=aa78120ed92fbced11eaf113ba6c185c' | 'e1cib/data/Catalog.Currencies?ref=aa78120ed92fbced11eaf113ba6c1855' | '01.01.0001 0:00:00' | 'e1cib/data/Catalog.Companies?ref=aa78120ed92fbced11eaf116b32709a2' | 'e1cib/data/Catalog.PartnerSegments?ref=aa78120ed92fbced11eaf116b327099b' | 'e1cib/data/Catalog.Partners?ref=aa78120ed92fbced11eaf113ba6c1870' | 'True'            | 'e1cib/data/Catalog.ObjectStatuses?ref=aa78120ed92fbced11eaf114c59ef021' | 'False'                      | 'Enum.SalesTransactionTypes.Sales' | ''               | 'e1cib/data/Catalog.Users?ref=aa7f120ed92fbced11eb13d7279770c0' | ''       | ''            | 4000             |

	And I refill object tabular section "ItemList":
		| 'Ref'                                                                 | 'Key'                                  | 'Cancel' | 'Item'                                                          | 'ItemKey'                                                          | 'Store'                                                          | 'NetAmount' | 'OffersAmount' | 'Price' | 'PriceType'                                                          | 'Quantity' | 'TaxAmount' | 'TotalAmount' | 'Unit'                                                          | 'DeliveryDate'       | 'ProcurementMethod'             | 'Detail' | 'ProfitLossCenter' | 'RevenueType' | 'DontCalculateRow' | 'QuantityInBaseUnit' | 'CancelReason' | 'PartnerItem' | 'ReservationDate'    | 'SalesPerson' | 'IsService' |
		| 'e1cib/data/Document.SalesOrder?ref=b797a0d6c37f8d9211edbf570cfe1017' | '744a5c30-8468-4b6e-a457-dab9dcd8d7e8' | 'False'  | 'e1cib/data/Catalog.Items?ref=aa78120ed92fbced11eaf115bcc9c5f4' | 'e1cib/data/Catalog.ItemKeys?ref=aa78120ed92fbced11eaf115bcc9c601' | 'e1cib/data/Catalog.Stores?ref=aa78120ed92fbced11eaf114c59ef00b' | 2000.92     |                | 400     | 'e1cib/data/Catalog.PriceTypes?ref=aa78120ed92fbced11eaf114c59eeffe' | 5          | 305.08      | 2000          | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862' | '01.01.0001 0:00:00' | 'Enum.ProcurementMethods.Stock' | ''       | ''                 | ''            | 'False'            | 5                    | ''             | ''            | '01.01.0001 0:00:00' | ''            | 'False'     |
		| 'e1cib/data/Document.SalesOrder?ref=b797a0d6c37f8d9211edbf570cfe1017' | '73c7edce-e56b-424a-bd09-d8671d56d748' | 'False'  | 'e1cib/data/Catalog.Items?ref=aa78120ed92fbced11eaf115bcc9c5f4' | 'e1cib/data/Catalog.ItemKeys?ref=aa78120ed92fbced11eaf115bcc9c601' | 'e1cib/data/Catalog.Stores?ref=aa78120ed92fbced11eaf114c59ef00b' | 1694.92     |                | 400     | 'e1cib/data/Catalog.PriceTypes?ref=aa78120ed92fbced11eaf114c59eeffe' | 5          | 305.08      | 2000          | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862' | '01.01.0001 0:00:00' | 'Enum.ProcurementMethods.Stock' | ''       | ''                 | ''            | 'False'            | 5                    | ''             | ''            | '01.01.0001 0:00:00' | ''            | 'False'     |

	And I refill object tabular section "TaxList":
		| 'Ref'                                                                 | 'Key'                                  | 'Tax'                                                           | 'Analytics' | 'TaxRate'                                                          | 'Amount' | 'IncludeToTotalAmount' | 'ManualAmount' |
		| 'e1cib/data/Document.SalesOrder?ref=b797a0d6c37f8d9211edbf570cfe1017' | '744a5c30-8468-4b6e-a457-dab9dcd8d7e8' | 'e1cib/data/Catalog.Taxes?ref=aa78120ed92fbced11eaf116b32709c4' | ''          | 'e1cib/data/Catalog.TaxRates?ref=aa78120ed92fbced11eaf114c59ef010' | 305.08   | 'True'                 | 305.08         |
		| 'e1cib/data/Document.SalesOrder?ref=b797a0d6c37f8d9211edbf570cfe1017' | '73c7edce-e56b-424a-bd09-d8671d56d748' | 'e1cib/data/Catalog.Taxes?ref=aa78120ed92fbced11eaf116b32709c4' | ''          | 'e1cib/data/Catalog.TaxRates?ref=aa78120ed92fbced11eaf114c59ef010' | 305.08   | 'True'                 | 305.08         |

	And I refill object tabular section "Currencies":
		| 'Ref'                                                                 | 'Key'                                  | 'CurrencyFrom'                                                       | 'Rate' | 'ReverseRate' | 'ShowReverseRate' | 'Multiplicity' | 'MovementType'                                                                                    | 'Amount' | 'IsFixed' |
		| 'e1cib/data/Document.SalesOrder?ref=b797a0d6c37f8d9211edbf570cfe1017' | '                                    ' | 'e1cib/data/Catalog.Currencies?ref=aa78120ed92fbced11eaf113ba6c1855' | 1      | 1             | 'False'           | 1              | 'e1cib/data/ChartOfCharacteristicTypes.CurrencyMovementType?ref=aa78120ed92fbced11eaf113ba6c185f' | 4000     | 'False'   |
		| 'e1cib/data/Document.SalesOrder?ref=b797a0d6c37f8d9211edbf570cfe1017' | '                                    ' | 'e1cib/data/Catalog.Currencies?ref=aa78120ed92fbced11eaf113ba6c1855' | 1      | 1             | 'False'           | 1              | 'e1cib/data/ChartOfCharacteristicTypes.CurrencyMovementType?ref=aa78120ed92fbced11eaf113ba6c185d' | 4000     | 'False'   |
		| 'e1cib/data/Document.SalesOrder?ref=b797a0d6c37f8d9211edbf570cfe1017' | '                                    ' | 'e1cib/data/Catalog.Currencies?ref=aa78120ed92fbced11eaf113ba6c1855' | 0.1712 | 5.8411        | 'False'           | 1              | 'e1cib/data/ChartOfCharacteristicTypes.CurrencyMovementType?ref=aa78120ed92fbced11eaf113ba6c185e' | 684.8    | 'False'   |

	