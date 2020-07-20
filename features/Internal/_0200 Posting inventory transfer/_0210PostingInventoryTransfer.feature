#language: en
@tree
@Positive
Feature: create document Inventory transfer

As a procurement manager
I want to create a Inventory transfer order
To transfer items from one store to another

Background:
	Given I launch TestClient opening script or connect the existing one

# 1
Scenario: _021001 create document Inventory Transfer - Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	* Opening Inventory transfer order to create Inventory transfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number' | 'Store sender' | 'Store receiver' |
			| '201'      |  'Store 01'     | 'Store 02'       |
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
		* Filling in the document number
			And I input "1" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "1" text in "Number" field
		And I move to "Items" tab
		And "ItemList" table contains lines
		| 'Inventory transfer order'    | 'Item'  | 'Quantity' | 'Item key'  | 'Unit' |
		| 'Inventory transfer order 201*' | 'Dress' | '50,000'   | 'M/White'  | 'pcs' |
		| 'Inventory transfer order 201*' | 'Dress' | '10,000'   | 'S/Yellow' | 'pcs' |
		And I click "Post and close" button
		And I close current window

Scenario: _021002 check Inventory transfer (based on order) posting by register TransferOrderBalance (-) (Store sender doesn't use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                    | 'Store sender' | 'Store receiver' | 'Order'                       | 'Item key'  |
		| '10,000'   | 'Inventory transfer 1*'       | 'Store 01'     | 'Store 02'       | 'Inventory transfer order 201*' | 'S/Yellow'  |
		| '50,000'   | 'Inventory transfer 1*'       | 'Store 01'     | 'Store 02'       | 'Inventory transfer order 201*' | 'M/White'   |

Scenario: _021002 check Inventory transfer (based on order) posting by register StockReservation (Store sender doesn't use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'               | 'Item key'  |
		| '10,000'    | 'Inventory transfer 1*' | 'S/Yellow'   |
		| '50,000'    | 'Inventory transfer 1*' | 'M/White'   |

Scenario: _021003 check Inventory transfer (based on order) posting by register GoodsInTransitOutgoing (Store sender doesn't use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table does not contain lines
	| 'Recorder'              |
	| 'Inventory transfer 1*' |


Scenario: _021004 check Inventory transfer (based on order) posting by register GoodsInTransitIncoming (+)  (Store sender doesn't use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'              | 'Receipt basis'         | 'Store'    | 'Item key' |
	| '10,000'   | 'Inventory transfer 1*' | 'Inventory transfer 1*' | 'Store 02' | 'S/Yellow' |
	| '50,000'   | 'Inventory transfer 1*' | 'Inventory transfer 1*' | 'Store 02' | 'M/White'  |


Scenario: _021005 check Inventory transfer (based on order) posting by register StockBalance (-) (Store sender doesn't use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'              | 'Store'    | 'Item key' |
	| '10,000'   | 'Inventory transfer 1*' | 'Store 01' | 'S/Yellow' |
	| '50,000'   | 'Inventory transfer 1*' | 'Store 01' | 'M/White'  |


	# 2
Scenario: _021006 create document Inventory Transfer - Store sender use Shipment confirmation, Store receiver use Goods receipt
	* Opening Inventory transfer order to create Inventory transfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number' | 'Store sender'  | 'Store receiver' |
			| '202'      |  'Store 02'     | 'Store 03'       |
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
		* Filling in the document number
			And I input "2" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2" text in "Number" field
		And I move to "Items" tab
		And "ItemList" table contains lines
		| '#' | 'Inventory transfer order'    | 'Item'  | 'Quantity' | 'Item key' | 'Unit' |
		| '1' | 'Inventory transfer order 2*' | 'Dress' | '20,000'   | 'L/Green'  | 'pcs' |
		And I click "Post and close" button
		And I close current window

Scenario: _021007 check Inventory transfer (based on order) posting by register TransferOrderBalance (-) (Store sender use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Order'                       | 'Item key'  |
		| '20,000'   | 'Inventory transfer 2*'       | '1'           | 'Store 02'     | 'Store 03'       | 'Inventory transfer order 2*' | 'L/Green'   |

Scenario: _021008 check Inventory transfer (based on order) posting by register StockReservation (Store sender use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'              | 'Line number' | 'Item key'  |
		| '20,000'    | 'Inventory transfer 2*' | '1'          | 'L/Green'   |


Scenario: _021009 check Inventory transfer (based on order) posting by register GoodsInTransitOutgoing (Store sender use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'              | 'Shipment basis'        | 'Line number' | 'Store'    | 'Item key' |
	| '20,000'   | 'Inventory transfer 2*' | 'Inventory transfer 2*' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _021010 check Inventory transfer (based on order) posting by register GoodsInTransitIncoming (+) (Store sender use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'              | 'Receipt basis'         | 'Line number' | 'Store'    | 'Item key' |
	| '20,000'   | 'Inventory transfer 2*' | 'Inventory transfer 2*' | '1'           | 'Store 03' | 'L/Green'  |


Scenario: _021011 check Inventory transfer (based on order) posting by register StockBalance (-) (Store sender use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table does not contain lines
	| 'Recorder'              |
	| 'Inventory transfer 2*' |


	# 3
Scenario: _021012 create document Inventory Transfer - Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt
	* Opening Inventory transfer order to create Inventory transfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number' | 'Store sender'  | 'Store receiver' |
			| '203'      |  'Store 02'     | 'Store 01'       |
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
		* Filling in the document number
			And I input "3" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "3" text in "Number" field
		And I move to "Items" tab
		And "ItemList" table contains lines
		| '#' | 'Inventory transfer order'    | 'Item'  | 'Quantity' | 'Item key' | 'Unit' |
		| '1' | 'Inventory transfer order 203*' | 'Dress' | '17,000'   | 'L/Green'  | 'pcs' |
		And I click "Post and close" button
		And I close current window
	
Scenario: _021013 check Inventory transfer (based on order) posting by register TransferOrderBalance (-) (Store sender use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Order'                       | 'Item key'  |
		| '17,000'   | 'Inventory transfer 3*'       | '1'           | 'Store 02'     | 'Store 01'       | 'Inventory transfer order 203*' | 'L/Green'   |

Scenario: _021014 check Inventory transfer (based on order) posting by register StockReservation (+) (Store sender use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity'  | 'Recorder'              | 'Line number' | 'Store'    | 'Item key'  |
		| '17,000'    | 'Inventory transfer 3*' | '1'           | 'Store 01' | 'L/Green'   |

Scenario: _021015 check Inventory transfer (based on order) posting by register GoodsInTransitOutgoing (Store sender use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'              | 'Shipment basis'        | 'Line number' | 'Store'    | 'Item key' |
	| '17,000'   | 'Inventory transfer 3*' | 'Inventory transfer 3*' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _021016 check the absence posting of Inventory transfer (based on order) by register GoodsInTransitIncoming (Store sender use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table does not contain lines
	| 'Quantity' | 'Recorder'              | 'Receipt basis'         | 'Line number' | 'Store'    | 'Item key' |
	| '20,000'   | 'Inventory transfer 2*' | 'Inventory transfer 2*' | '1'           | 'Store 03' | 'L/Green'  |


Scenario: _021017 check the absence posting of Inventory transfer (based on order) by register StockBalance (Store sender use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table does not contain lines
	| 'Recorder'              |
	| 'Inventory transfer 3*' |



	# 4
Scenario: _021018 create document Inventory Transfer - Store sender doesn't use Shipment confirmation, Store receiver doesn't use Goods receipt
	* Opening Inventory transfer order to create Inventory transfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number' | 'Store sender'  | 'Store receiver' |
			| '204'      |  'Store 01'     | 'Store 04'       |
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
		* Filling in the document number
			And I input "4" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "4" text in "Number" field
		And I move to "Items" tab
		And "ItemList" table contains lines
		| '#' | 'Inventory transfer order'    | 'Item'     | 'Quantity' | 'Item key'  | 'Unit' |
		| '1' | 'Inventory transfer order 204*' | 'Trousers' | '10,000'   | '36/Yellow' | 'pcs' |
		And I click "Post and close" button
		And I close current window

Scenario: _021019  check Inventory transfer (without order) posting by register TransferOrderBalance (-) (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)	
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Order'                       | 'Item key'  |
		| '10,000'   | 'Inventory transfer 4*'       | '1'           | 'Store 01'     | 'Store 04'       | 'Inventory transfer order 204*' | '36/Yellow' |

Scenario: _021020  check Inventory transfer (without order) posting by register StockReservation (+) Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt

	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity'  | 'Recorder'              | 'Store'    | 'Item key'  |
		| '10,000'    | 'Inventory transfer 4*' | 'Store 04' | '36/Yellow'   |



Scenario: _021021 check the absence posting of Inventory transfer (without order) posting by register GoodsInTransitOutgoing (+) (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table does not contain lines
	| 'Recorder'              |
	| 'Inventory transfer 4*' |


Scenario: _021022 check the absence posting of Inventory transfer (without order) posting by register GoodsInTransitIncoming (+) (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table does not contain lines
	| 'Recorder'              |
	| 'Inventory transfer 4*' |

Scenario: _021023 check Inventory transfer (without order) posting by register StockBalance (+/-) (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'              | 'Store'    | 'Item key'  |
	| '10,000'   | 'Inventory transfer 4*' | 'Store 04' | '36/Yellow' |
	| '10,000'   | 'Inventory transfer 4*' | 'Store 01' | '36/Yellow' |




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
	* Filling in the document number
			And I input "5" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "5" text in "Number" field
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
	And I click "Post and close" button

Scenario: _021025 check the absence posting of Inventory transfer (without order) posting by register TransferOrderBalance Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Item key'  |
		| '7,000'   | 'Inventory transfer 5*'       | '1'            | 'Store 01'     | 'Store 02'       | 'S/Yellow'  |

Scenario: _021026  check Inventory transfer (without order) posting by register StockReservation (-) Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                                       | 'Line number' | 'Store'    | 'Item key'  |
		| '7,000'    | 'Inventory transfer 5*' | '1'           | 'Store 01' | 'S/Yellow'  |


Scenario: _021027 check the absence posting of Inventory transfer (without order) posting by register GoodsInTransitOutgoing Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table does not contain lines
	| 'Recorder'              |
	| 'Inventory transfer 5*' |


Scenario: _021028 check Inventory transfer (without order) posting by register GoodsInTransitIncoming (+) Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'              | 'Receipt basis'         | 'Line number' | 'Store'    | 'Item key' |
	| '7,000'    | 'Inventory transfer 5*' | 'Inventory transfer 5*' | '1'           | 'Store 02' | 'S/Yellow' |

Scenario: _021029 check Inventory transfer (without order) posting by register StockBalance (-) Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'              | 'Line number' | 'Store'    | 'Item key' |
	| '7,000'    | 'Inventory transfer 5*' | '1'           | 'Store 01' | 'S/Yellow' |



	# 6
Scenario: _021030 create document Inventory Transfer - Store sender use Shipment confirmation, Store receiver use Goods receipt (without Purchase order)
	
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
		| Store 03    |
	And I select current line in "List" table
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'  |
		| 'Main Company' |
	And I select current line in "List" table
	* Filling in the document number
			And I input "6" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "6" text in "Number" field
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
	And I input "3,000" text in "Quantity" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click "Post and close" button

Scenario: _021031 check the absence posting of Inventory transfer (InventoryTransfer) in the register TransferOrderBalanceStore sender use Shipment confirmation, Store receiver use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Item key'  |
		| '3,000'    | 'Inventory transfer 6*'       | '1'            | 'Store 02'     | 'Store 03'       | 'L/Green'  |

Scenario: _021032 check Inventory transfer (without order) posting by register StockReservation (-)Store sender use Shipment confirmation, Store receiver use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'              | 'Line number' | 'Store'    | 'Item key'  |
		| '3,000'    | 'Inventory transfer 6*' | '1'           | 'Store 02' | 'L/Green'  |


Scenario: _021033 check Inventory transfer (without order) posting by register GoodsInTransitOutgoing Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'              | 'Shipment basis'        | 'Line number' | 'Store'    | 'Item key' |
	| '3,000'    | 'Inventory transfer 6*' | 'Inventory transfer 6*' | '1'           | 'Store 02' | 'L/Green'  |


Scenario: _021034 check Inventory transfer (without order) posting by register GoodsInTransitIncoming (+) Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'              | 'Receipt basis'         | 'Line number' | 'Store'    | 'Item key' |
	| '3,000'    | 'Inventory transfer 6*' | 'Inventory transfer 6*' | '1'           | 'Store 03' | 'L/Green'  |

Scenario: _021035 check the absence posting of Inventory transfer (without order) posting by register StockBalance (-) Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table does not contain lines
	| 'Recorder'              |
	| 'Inventory transfer 6*' |



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
	* Filling in the document number
			And I input "7" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "7" text in "Number" field
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
	And I click "Post and close" button

Scenario: _021037 check the absence posting of Inventory transfer (without order) posting by register TransferOrderBalance Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Item key'  |
		| '4,000'    | 'Inventory transfer 7*'       | '1'            | 'Store 02'     | 'Store 01'       | 'L/Green'  |

Scenario: _021038  check Inventory transfer (without order) posting by register StockReservation Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt

	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'              | 'Store'    | 'Item key'  |
		| '4,000'    | 'Inventory transfer 7*' | 'Store 01' | 'L/Green'   |
		| '4,000'    | 'Inventory transfer 7*' | 'Store 02' | 'L/Green'   |


Scenario: _021039 check Inventory transfer (without order) posting by register GoodsInTransitOutgoing Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'              | 'Shipment basis'        | 'Line number' | 'Store'    | 'Item key' |
	| '4,000'    | 'Inventory transfer 7*' | 'Inventory transfer 7*' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _021040 check the absence posting of Inventory transfer (without order) posting by register GoodsInTransitIncoming (+) Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table does not contain lines
	| 'Recorder'              |
	| 'Inventory transfer 7*' |


Scenario: _021041 check the absence posting of Inventory transfer (without order) posting by register StockBalance (+) Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table does not contain lines
	| 'Recorder'              |
	| 'Inventory transfer 7*' |

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
	* Filling in the document number
		And I input "8" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "8" text in "Number" field
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
	And I click "Post and close" button

Scenario: _021043 check the absence posting of Inventory transfer (without order) posting by register TransferOrderBalance (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'                    | 'Line number'  | 'Store sender' | 'Store receiver' | 'Item key'  |
		| '4,000'    | 'Inventory transfer 8*'       | '1'            | 'Store 01'     | 'Store 04'       | '36/Yellow'  |

Scenario: _021044  check Inventory transfer (without order) posting by register StockReservation (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)

	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'              | 'Store'    | 'Item key'  |
		| '4,000'    | 'Inventory transfer 8*' | 'Store 04' | '36/Yellow'   |
		| '4,000'    | 'Inventory transfer 8*' | 'Store 01' | '36/Yellow'   |

Scenario: _021045 check the absence posting of Inventory transfer (without order) posting by register GoodsInTransitOutgoing (+) (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table does not contain lines
	| 'Recorder'              |
	| 'Inventory transfer 8*' |

Scenario: _021046 check the absence posting of Inventory transfer (without order) posting by register GoodsInTransitIncoming (+) (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table does not contain lines
	| 'Recorder'              |
	| 'Inventory transfer 8*' |

Scenario: _021047 check Inventory transfer (without order) posting by register StockBalance (+/-) (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'              | 'Store'    | 'Item key'  |
	| '4,000'    | 'Inventory transfer 8*' | 'Store 04' | '36/Yellow' |
	| '4,000'    | 'Inventory transfer 8*' | 'Store 01' | '36/Yellow' |



