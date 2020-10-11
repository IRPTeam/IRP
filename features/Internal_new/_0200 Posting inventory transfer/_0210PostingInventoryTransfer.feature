#language: en
@tree
@Positive
@Group4
@InventoryTransfer

Feature: create document Inventory transfer

As a procurement manager
I want to create a Inventory transfer order
To transfer items from one store to another

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _0201000 preparation
	* Constants
		When set True value to the constant
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Check or create InventoryTransferOrder020001
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberInventoryTransferOrder020001$$" |
			When create InventoryTransferOrder020001
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberInventoryTransferOrder020004$$" |
			When create InventoryTransferOrder020004
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberInventoryTransferOrder020007$$" |
			When create InventoryTransferOrder020007
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberInventoryTransferOrder020010$$" |
			When create InventoryTransferOrder020010

# 1







# 1
Scenario: _021001 create document Inventory Transfer - Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	* Opening Inventory transfer order to create Inventory transfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'                                 | 'Store sender' | 'Store receiver' |
			| '$$NumberInventoryTransferOrder020001$$' | 'Store 01'     | 'Store 02'       |
		And I select current line in "List" table
		And I click the button named "FormDocumentInventoryTransferGenerateInventoryTransfer"
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I move to "Items" tab
		And "ItemList" table contains lines
		| 'Inventory transfer order'         | 'Item'  | 'Quantity' | 'Item key' | 'Unit' |
		| '$$InventoryTransferOrder020001$$' | 'Dress' | '50,000'   | 'M/White'  | 'pcs'  |
		| '$$InventoryTransferOrder020001$$' | 'Dress' | '10,000'   | 'S/Yellow' | 'pcs'  |
		And I click the button named "FormPost"
		And I save the value of "Number" field as "$$NumberInventoryTransfer021001$$"
		And I save the window as "$$InventoryTransfer021001$$"
		And I click the button named "FormPostAndClose"
		And I close current window

Scenario: _021002 check Inventory transfer (based on order) posting by register TransferOrderBalance (-) (Store sender doesn't use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                    | 'Store sender' | 'Store receiver' | 'Order'                            | 'Item key' |
		| '10,000'   | '$$InventoryTransfer021001$$' | 'Store 01'     | 'Store 02'       | '$$InventoryTransferOrder020001$$' | 'S/Yellow' |
		| '50,000'   | '$$InventoryTransfer021001$$' | 'Store 01'     | 'Store 02'       | '$$InventoryTransferOrder020001$$' | 'M/White'  |

Scenario: _021002 check Inventory transfer (based on order) posting by register StockReservation (Store sender doesn't use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'                    | 'Item key' |
		| '10,000'   | '$$InventoryTransfer021001$$' | 'S/Yellow' |
		| '50,000'   | '$$InventoryTransfer021001$$' | 'M/White'  |

Scenario: _021003 check Inventory transfer (based on order) posting by register GoodsInTransitOutgoing (Store sender doesn't use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table does not contain lines
	| 'Recorder'              |
	| '$$InventoryTransfer021001$$' |


Scenario: _021004 check Inventory transfer (based on order) posting by register GoodsInTransitIncoming (+)  (Store sender doesn't use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                    | 'Receipt basis'               | 'Store'    | 'Item key' |
	| '10,000'   | '$$InventoryTransfer021001$$' | '$$InventoryTransfer021001$$' | 'Store 02' | 'S/Yellow' |
	| '50,000'   | '$$InventoryTransfer021001$$' | '$$InventoryTransfer021001$$' | 'Store 02' | 'M/White'  |


Scenario: _021005 check Inventory transfer (based on order) posting by register StockBalance (-) (Store sender doesn't use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                    | 'Store'    | 'Item key' |
	| '10,000'   | '$$InventoryTransfer021001$$' | 'Store 01' | 'S/Yellow' |
	| '50,000'   | '$$InventoryTransfer021001$$' | 'Store 01' | 'M/White'  |


	# 2
Scenario: _021006 create document Inventory Transfer - Store sender use Shipment confirmation, Store receiver use Goods receipt
	* Opening Inventory transfer order to create Inventory transfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number' | 'Store sender'  | 'Store receiver' |
			| '$$NumberInventoryTransferOrder020004$$'      |  'Store 02'     | 'Store 03'       |
		And I select current line in "List" table
		And I click the button named "FormDocumentInventoryTransferGenerateInventoryTransfer"
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 03'  |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I move to "Items" tab
		And "ItemList" table contains lines
		| '#' | 'Inventory transfer order'         | 'Item'  | 'Quantity' | 'Item key' | 'Unit' |
		| '1' | '$$InventoryTransferOrder020004$$' | 'Dress' | '20,000'   | 'L/Green'  | 'pcs'  |
		And I click the button named "FormPost"
		And I save the value of "Number" field as "$$NumberInventoryTransfer021006$$"
		And I save the window as "$$InventoryTransfer021006$$"
		And I click the button named "FormPostAndClose"
		And I close current window

Scenario: _021007 check Inventory transfer (based on order) posting by register TransferOrderBalance (-) (Store sender use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Order'                            | 'Item key' |
		| '20,000'   | '$$InventoryTransfer021006$$' | '1'           | 'Store 02'     | 'Store 03'       | '$$InventoryTransferOrder020004$$' | 'L/Green'  |

Scenario: _021008 check Inventory transfer (based on order) posting by register StockReservation (Store sender use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Item key' |
		| '20,000'   | '$$InventoryTransfer021006$$' | '1'           | 'L/Green'  |


Scenario: _021009 check Inventory transfer (based on order) posting by register GoodsInTransitOutgoing (Store sender use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                    | 'Shipment basis'              | 'Line number' | 'Store'    | 'Item key' |
	| '20,000'   | '$$InventoryTransfer021006$$' | '$$InventoryTransfer021006$$' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _021010 check Inventory transfer (based on order) posting by register GoodsInTransitIncoming (+) (Store sender use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                    | 'Receipt basis'               | 'Line number' | 'Store'    | 'Item key' |
	| '20,000'   | '$$InventoryTransfer021006$$' | '$$InventoryTransfer021006$$' | '1'           | 'Store 03' | 'L/Green'  |


Scenario: _021011 check Inventory transfer (based on order) posting by register StockBalance (-) (Store sender use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table does not contain lines
	| 'Recorder'              |
	| '$$InventoryTransfer021006$$' |


	# 3
Scenario: _021012 create document Inventory Transfer - Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt
	* Opening Inventory transfer order to create Inventory transfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'                                 | 'Store sender' | 'Store receiver' |
			| '$$NumberInventoryTransferOrder020007$$' | 'Store 02'     | 'Store 01'       |
		And I select current line in "List" table
		And I click the button named "FormDocumentInventoryTransferGenerateInventoryTransfer"
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I move to "Items" tab
		And "ItemList" table contains lines
		| '#' | 'Inventory transfer order'         | 'Item'  | 'Quantity' | 'Item key' | 'Unit' |
		| '1' | '$$InventoryTransferOrder020007$$' | 'Dress' | '17,000'   | 'L/Green'  | 'pcs'  |
		And I click the button named "FormPost"
		And I save the value of "Number" field as "$$NumberInventoryTransfer021012$$"
		And I save the window as "$$InventoryTransfer021012$$"
		And I click the button named "FormPostAndClose"
		And I close current window
	
Scenario: _021013 check Inventory transfer (based on order) posting by register TransferOrderBalance (-) (Store sender use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Order'                            | 'Item key' |
		| '17,000'   | '$$InventoryTransfer021012$$' | '1'           | 'Store 02'     | 'Store 01'       | '$$InventoryTransferOrder020007$$' | 'L/Green'  |

Scenario: _021014 check Inventory transfer (based on order) posting by register StockReservation (+) (Store sender use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store'    | 'Item key' |
		| '17,000'   | '$$InventoryTransfer021012$$' | '1'           | 'Store 01' | 'L/Green'  |

Scenario: _021015 check Inventory transfer (based on order) posting by register GoodsInTransitOutgoing (Store sender use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                    | 'Shipment basis'              | 'Line number' | 'Store'    | 'Item key' |
	| '17,000'   | '$$InventoryTransfer021012$$' | '$$InventoryTransfer021012$$' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _021016 check the absence posting of Inventory transfer (based on order) by register GoodsInTransitIncoming (Store sender use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table does not contain lines
	| 'Quantity' | 'Recorder'                    | 'Receipt basis'               | 'Line number' | 'Store'    | 'Item key' |
	| '20,000'   | '$$InventoryTransfer021012$$' | '$$InventoryTransfer021012$$' | '1'           | 'Store 03' | 'L/Green'  |


Scenario: _021017 check posting of Inventory transfer (based on order) by register StockBalance (Store sender use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
	| 'Recorder'              |
	| '$$InventoryTransfer021012$$' |



	# 4
Scenario: _021018 create document Inventory Transfer - Store sender doesn't use Shipment confirmation, Store receiver doesn't use Goods receipt
	* Opening Inventory transfer order to create Inventory transfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'                                 | 'Store sender' | 'Store receiver' |
			| '$$NumberInventoryTransferOrder020010$$' | 'Store 01'     | 'Store 04'       |
		And I select current line in "List" table
		And I click the button named "FormDocumentInventoryTransferGenerateInventoryTransfer"
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 04'  |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I move to "Items" tab
		And "ItemList" table contains lines
		| '#' | 'Inventory transfer order'         | 'Item'     | 'Quantity' | 'Item key'  | 'Unit' |
		| '1' | '$$InventoryTransferOrder020010$$' | 'Trousers' | '10,000'   | '36/Yellow' | 'pcs'  |
		And I click the button named "FormPost"
		And I save the value of "Number" field as "$$NumberInventoryTransfer021018$$"
		And I save the window as "$$InventoryTransfer021018$$"
		And I click the button named "FormPostAndClose"
		And I close current window

Scenario: _021019  check Inventory transfer (without order) posting by register TransferOrderBalance (-) (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)	
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Order'                            | 'Item key'  |
		| '10,000'   | '$$InventoryTransfer021018$$' | '1'           | 'Store 01'     | 'Store 04'       | '$$InventoryTransferOrder020010$$' | '36/Yellow' |

Scenario: _021020  check Inventory transfer (without order) posting by register StockReservation (+) Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt

	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                    | 'Store'    | 'Item key'  |
		| '10,000'   | '$$InventoryTransfer021018$$' | 'Store 04' | '36/Yellow' |



Scenario: _021021 check the absence posting of Inventory transfer (without order) posting by register GoodsInTransitOutgoing (+) (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table does not contain lines
	| 'Recorder'                    |
	| '$$InventoryTransfer021018$$' |


Scenario: _021022 check the absence posting of Inventory transfer (without order) posting by register GoodsInTransitIncoming (+) (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table does not contain lines
	| 'Recorder'                    |
	| '$$InventoryTransfer021018$$' |

Scenario: _021023 check Inventory transfer (without order) posting by register StockBalance (+/-) (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                    | 'Store'    | 'Item key'  |
	| '10,000'   | '$$InventoryTransfer021018$$' | 'Store 04' | '36/Yellow' |
	| '10,000'   | '$$InventoryTransfer021018$$' | 'Store 01' | '36/Yellow' |




	# 5
Scenario: _021024 create document Inventory Transfer - Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt (without Purchase order)
	
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I click the button named "FormCreate"
	And I click Select button of "Store sender" field
	And I go to line in "List" table
		| Description |
		| Store 01    |
	And I select current line in "List" table
	And I click Select button of "Store receiver" field
	And I go to line in "List" table
		| Description |
		| Store 02    |
	And I select current line in "List" table
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'  |
		| 'Main Company' |
	And I select current line in "List" table
	And I move to "Items" tab
	And I click the button named "Add"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description' |
		| 'Dress'       |
	And I select current line in "List" table
	And I activate "Item key" field in "ItemList" table
	And I click choice button of "Item key" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Item key' |
		| 'S/Yellow' |
	And I select current line in "List" table
	And I activate "Unit" field in "ItemList" table
	And I click choice button of "Unit" attribute in "ItemList" table
	And I select current line in "List" table
	And I activate "Quantity" field in "ItemList" table
	And I input "7,000" text in "Quantity" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And I save the value of "Number" field as "$$NumberInventoryTransfer021024$$"
	And I save the window as "$$InventoryTransfer021024$$"
	And I click the button named "FormPostAndClose"

Scenario: _021025 check the absence posting of Inventory transfer (without order) posting by register TransferOrderBalance Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Item key' |
		| '7,000'    | '$$InventoryTransfer021024$$' | '1'           | 'Store 01'     | 'Store 02'       | 'S/Yellow' |

Scenario: _021026  check Inventory transfer (without order) posting by register StockReservation (-) Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                                       | 'Line number' | 'Store'    | 'Item key'  |
		| '7,000'    | '$$InventoryTransfer021024$$' | '1'           | 'Store 01' | 'S/Yellow'  |


Scenario: _021027 check the absence posting of Inventory transfer (without order) posting by register GoodsInTransitOutgoing Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table does not contain lines
	| 'Recorder'                    |
	| '$$InventoryTransfer021024$$' |


Scenario: _021028 check Inventory transfer (without order) posting by register GoodsInTransitIncoming (+) Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                    | 'Receipt basis'               | 'Line number' | 'Store'    | 'Item key' |
	| '7,000'    | '$$InventoryTransfer021024$$' | '$$InventoryTransfer021024$$' | '1'           | 'Store 02' | 'S/Yellow' |

Scenario: _021029 check Inventory transfer (without order) posting by register StockBalance (-) Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store'    | 'Item key' |
	| '7,000'    | '$$InventoryTransfer021024$$' | '1'           | 'Store 01' | 'S/Yellow' |



	# 6
Scenario: _021030 create document Inventory Transfer - Store sender use Shipment confirmation, Store receiver use Goods receipt (without Purchase order)
	
	When create InventoryTransfer021030

Scenario: _021031 check the absence posting of Inventory transfer (InventoryTransfer) in the register TransferOrderBalanceStore sender use Shipment confirmation, Store receiver use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Item key' |
		| '3,000'    | '$$InventoryTransfer021030$$' | '1'           | 'Store 02'     | 'Store 03'       | 'L/Green'  |

Scenario: _021032 check Inventory transfer (without order) posting by register StockReservation (-)Store sender use Shipment confirmation, Store receiver use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store'    | 'Item key' |
		| '3,000'    | '$$InventoryTransfer021030$$' | '1'           | 'Store 02' | 'L/Green'  |


Scenario: _021033 check Inventory transfer (without order) posting by register GoodsInTransitOutgoing Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                    | 'Shipment basis'              | 'Line number' | 'Store'    | 'Item key' |
	| '3,000'    | '$$InventoryTransfer021030$$' | '$$InventoryTransfer021030$$' | '1'           | 'Store 02' | 'L/Green'  |


Scenario: _021034 check Inventory transfer (without order) posting by register GoodsInTransitIncoming (+) Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                    | 'Receipt basis'               | 'Line number' | 'Store'    | 'Item key' |
	| '3,000'    | '$$InventoryTransfer021030$$' | '$$InventoryTransfer021030$$' | '1'           | 'Store 03' | 'L/Green'  |

Scenario: _021035 check the absence posting of Inventory transfer (without order) posting by register StockBalance (-) Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table does not contain lines
	| 'Recorder'                    |
	| '$$InventoryTransfer021030$$' |



	# 7

Scenario: _021036 create document Inventory Transfer - Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt (without Purchase order)
	
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I click the button named "FormCreate"
	And I click Select button of "Store sender" field
	And I go to line in "List" table
		| Description |
		| Store 02    |
	And I select current line in "List" table
	And I click Select button of "Store receiver" field
	And I go to line in "List" table
		| Description |
		| Store 01    |
	And I select current line in "List" table
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'  |
		| 'Main Company' |
	And I select current line in "List" table
	And I move to "Items" tab
	And I click the button named "Add"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description' |
		| 'Dress'       |
	And I select current line in "List" table
	And I activate "Item key" field in "ItemList" table
	And I click choice button of "Item key" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Item key' |
		| 'L/Green' |
	And I select current line in "List" table
	And I activate "Unit" field in "ItemList" table
	And I click choice button of "Unit" attribute in "ItemList" table
	And I select current line in "List" table
	And I activate "Quantity" field in "ItemList" table
	And I input "4,000" text in "Quantity" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And I save the value of "Number" field as "$$NumberInventoryTransfer021036$$"
	And I save the window as "$$InventoryTransfer021036$$"
	And I click the button named "FormPostAndClose"

Scenario: _021037 check the absence posting of Inventory transfer (without order) posting by register TransferOrderBalance Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Item key' |
		| '4,000'    | '$$InventoryTransfer021036$$' | '1'           | 'Store 02'     | 'Store 01'       | 'L/Green'  |

Scenario: _021038  check Inventory transfer (without order) posting by register StockReservation Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt

	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                    | 'Store'    | 'Item key' |
		| '4,000'    | '$$InventoryTransfer021036$$' | 'Store 01' | 'L/Green'  |
		| '4,000'    | '$$InventoryTransfer021036$$' | 'Store 02' | 'L/Green'  |


Scenario: _021039 check Inventory transfer (without order) posting by register GoodsInTransitOutgoing Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                    | 'Shipment basis'              | 'Line number' | 'Store'    | 'Item key' |
	| '4,000'    | '$$InventoryTransfer021036$$' | '$$InventoryTransfer021036$$' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _021040 check the absence posting of Inventory transfer (without order) posting by register GoodsInTransitIncoming (+) Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table does not contain lines
	| 'Recorder'                    |
	| '$$InventoryTransfer021036$$' |


Scenario: _021041 check the absence posting of Inventory transfer (without order) posting by register StockBalance (+) Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
	| 'Recorder'                    |
	| '$$InventoryTransfer021036$$' |

	# 8

Scenario: _021042 create document Inventory Transfer - Store sender doesn't use Shipment confirmation, Store receiver doesn't use Goods receipt (without Purchase order)
	
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I click the button named "FormCreate"
	And I click Select button of "Store sender" field
	And I go to line in "List" table
		| Description |
		| Store 01    |
	And I select current line in "List" table
	And I click Select button of "Store receiver" field
	And I go to line in "List" table
		| Description |
		| Store 04    |
	And I select current line in "List" table
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'  |
		| 'Main Company' |
	And I select current line in "List" table
	And I move to "Items" tab
	And I click the button named "Add"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description'    |
		| 'Trousers'       |
	And I select current line in "List" table
	And I activate "Item key" field in "ItemList" table
	And I click choice button of "Item key" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Item key' |
		| '36/Yellow' |
	And I select current line in "List" table
	And I activate "Unit" field in "ItemList" table
	And I click choice button of "Unit" attribute in "ItemList" table
	And I select current line in "List" table
	And I activate "Quantity" field in "ItemList" table
	And I input "4,000" text in "Quantity" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And I save the value of "Number" field as "$$NumberInventoryTransfer021042$$"
	And I save the window as "$$InventoryTransfer021042$$"
	And I click the button named "FormPostAndClose"

Scenario: _021043 check the absence posting of Inventory transfer (without order) posting by register TransferOrderBalance (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Item key'  |
		| '4,000'    | '$$InventoryTransfer021042$$' | '1'           | 'Store 01'     | 'Store 04'       | '36/Yellow' |

Scenario: _021044  check Inventory transfer (without order) posting by register StockReservation (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)

	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                    | 'Store'    | 'Item key'  |
		| '4,000'    | '$$InventoryTransfer021042$$' | 'Store 04' | '36/Yellow' |
		| '4,000'    | '$$InventoryTransfer021042$$' | 'Store 01' | '36/Yellow' |

Scenario: _021045 check the absence posting of Inventory transfer (without order) posting by register GoodsInTransitOutgoing (+) (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table does not contain lines
	| 'Recorder'                    |
	| '$$InventoryTransfer021042$$' |

Scenario: _021046 check the absence posting of Inventory transfer (without order) posting by register GoodsInTransitIncoming (+) (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table does not contain lines
	| 'Recorder'                    |
	| '$$InventoryTransfer021042$$' |

Scenario: _021047 check Inventory transfer (without order) posting by register StockBalance (+/-) (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                    | 'Store'    | 'Item key'  |
	| '4,000'    | '$$InventoryTransfer021042$$' | 'Store 04' | '36/Yellow' |
	| '4,000'    | '$$InventoryTransfer021042$$' | 'Store 01' | '36/Yellow' |






Scenario: _021048 check the output of the document movement report for Inventory transfer
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberInventoryTransfer021001$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$InventoryTransfer021001$$'                 | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Document registrations records'        | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Transfer order balance"'    | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store sender' | 'Store receiver'        | 'Order'                         | 'Item key' | 'Row key' |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 01'     | 'Store 02'              | '$$InventoryTransferOrder020001$$' | 'S/Yellow' | '*'       |
		| ''                                      | 'Expense'     | '*'      | '50'        | 'Store 01'     | 'Store 02'              | '$$InventoryTransferOrder020001$$' | 'M/White'  | '*'       |
		| ''                                      | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Receipt basis'         | 'Item key'                      | 'Row key'  | ''        |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'     | '$$InventoryTransfer021001$$' | 'S/Yellow'                      | '*'        | ''        |
		| ''                                      | 'Receipt'     | '*'      | '50'        | 'Store 02'     | '$$InventoryTransfer021001$$' | 'M/White'                       | '*'        | ''        |
		| ''                                      | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'              | ''                              | ''         | ''        |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 01'     | 'S/Yellow'              | ''                              | ''         | ''        |
		| ''                                      | 'Expense'     | '*'      | '50'        | 'Store 01'     | 'M/White'               | ''                              | ''         | ''        |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberInventoryTransfer021001$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$InventoryTransfer021001$$'                 | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Document registrations records'        | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Transfer order balance"'    | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store sender' | 'Store receiver'        | 'Order'                         | 'Item key' | 'Row key' |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 01'     | 'Store 02'              | '$$InventoryTransferOrder020001$$' | 'S/Yellow' | '*'       |
		| ''                                      | 'Expense'     | '*'      | '50'        | 'Store 01'     | 'Store 02'              | '$$InventoryTransferOrder020001$$' | 'M/White'  | '*'       |
		| ''                                      | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Receipt basis'         | 'Item key'                      | 'Row key'  | ''        |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'     | '$$InventoryTransfer021001$$' | 'S/Yellow'                      | '*'        | ''        |
		| ''                                      | 'Receipt'     | '*'      | '50'        | 'Store 02'     | '$$InventoryTransfer021001$$' | 'M/White'                       | '*'        | ''        |
		| ''                                      | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'              | ''                              | ''         | ''        |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 01'     | 'S/Yellow'              | ''                              | ''         | ''        |
		| ''                                      | 'Expense'     | '*'      | '50'        | 'Store 01'     | 'M/White'               | ''                              | ''         | ''        |
	And I close all client application windows



Scenario: _02104801 clear movements Inventory transfer and check that there is no movements on the registers 
	* Open list form Inventory transfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	* Check the report generation
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberInventoryTransfer021001$$'      |
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "Transfer order balance"'    |
			| 'Register  "Goods in transit incoming"' |
			| 'Register  "Stock balance"'             |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberInventoryTransfer021001$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document contains lines:
		| '$$InventoryTransfer021001$$'                 | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Document registrations records'        | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Transfer order balance"'    | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store sender' | 'Store receiver'        | 'Order'                         | 'Item key' | 'Row key' |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 01'     | 'Store 02'              | '$$InventoryTransferOrder020001$$' | 'S/Yellow' | '*'       |
		| ''                                      | 'Expense'     | '*'      | '50'        | 'Store 01'     | 'Store 02'              | '$$InventoryTransferOrder020001$$' | 'M/White'  | '*'       |
		| ''                                      | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Receipt basis'         | 'Item key'                      | 'Row key'  | ''        |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'     | '$$InventoryTransfer021001$$' | 'S/Yellow'                      | '*'        | ''        |
		| ''                                      | 'Receipt'     | '*'      | '50'        | 'Store 02'     | '$$InventoryTransfer021001$$' | 'M/White'                       | '*'        | ''        |
		| ''                                      | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''             | ''                      | ''                              | ''         | ''        |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''                              | ''         | ''        |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'              | ''                              | ''         | ''        |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 01'     | 'S/Yellow'              | ''                              | ''         | ''        |
		| ''                                      | 'Expense'     | '*'      | '50'        | 'Store 01'     | 'M/White'               | ''                              | ''         | ''        |
		And I close all client application windows

Scenario: _999999 close TestClient session
	And I close TestClient session