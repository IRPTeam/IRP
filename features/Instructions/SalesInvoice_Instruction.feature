#language: en

@tree

Functionality: Sales Invoice

Scenario: 01_Create Sales Invoice
* Firstly, go to Sales Invoices from Sales - A/R subsystem
	When in sections panel I select "Sales - A/R"
	And I make dimming effect on UI Automation form elements "" as prompted
		| 'Hint' |
		| 'Sales - A/R' |
	
		| 'Name' | 'Value' |
		| 'text' | 'Firstly go to Sales - A/R subsystem' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 4000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 20 |
	And delay 5
	And I dim UI Automation form items ""
		| 'Name / ID' | 'Type' |
		| 'Sales invoices' | 'MenuItem(50011)' |
			
		| 'Name' | 'Value' |
		| 'text' | 'Here are Sales Invoices, click on it' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 4000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 20 |
	And Delay 5
	And in functions panel I select "Sales invoices"
	Then "Sales invoices" window is opened
* to create new Sales Invoice document click on "Create" button
	And I dim UI Automation form items ""
		| 'Name / ID' | 'Type' |
		| 'Create' | 'Button' |
	
		| 'Name' | 'Value' |
		| 'text' | 'To create new Sales Invoice document click on "Create" button' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 4000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 20 |
	And Delay 5
	And I click the button named "FormCreate"
* New document form will open
	Then "Sales invoice (create)" window is opened
	And I dim UI Automation form items ""
		| 'Name / ID' | 'Type' |
		| 'Partner:' | 'Text(50020)' |
		| 'Description' | 'Text(50020)' |
		| 'Company:' | 'ComboBox(50003)' |
		| 'Legal name contract:' | 'ComboBox(50003)' |

		| 'Name' | 'Value' |
		| 'text' | 'Now, new document opened and we will enter the basic details as partner, legal name, term and warehouse' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 8000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 40 |
	And Delay 8
* In Partner field you can select the client name from the list.
	And I dim UI Automation form items ""
		| 'Name / ID' | 'Type' |
		| 'Partner:' | 'ComboBox(50003)' |
	
		| 'Name' | 'Value' |
		| 'text' | 'Partner - the field is for entering the name of the partner' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' |4000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 20 |
	And	Delay 5
	And I click Choice button of the field named "Partner"
	Then "Partners" window is opened
	And I activate field named "Description" in "List" table
	And I go to line in "List" table
		| 'Description'                  |
		| 'Customer 1 (3 partner terms)' |		
	And Delay 2
	And I select current line in "List" table
* The Legal Name field is filled in automatically, as system takes this information from Partner's Details catalog	
	And I dim UI Automation form items ""
		| 'Name / ID' | 'Type' |
		| 'Legal Name:' | 'ComboBox(50003)' |
	
		| 'Name' | 'Value' |
		| 'text' | 'Legal Name - the official legal name of the customer, which may differ from the trading name. If there is only one legal name, it will be automatically filled in by the system using information from the Partner Terms Details catalog. If multiple legal names exist, manual selection is required' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 10000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 80 |
	And Delay 15
	Then the form attribute named "LegalName" became equal to "Client 1"
* Next, need to select partner term 
	And I dim UI Automation form items ""
		| 'Name / ID' | 'Type' |
		| 'Partner term:' | 'ComboBox(50003)' |
	
		| 'Name' | 'Value' |
		| 'text' | 'Partner Term - the terms of sale agreed upon with the customer, such as payment terms, delivery terms, and any special conditions. If it has only one then its filled in automatically, the system takes this information from Partners Details catalog.  Otherwise, you will need to select it manually.' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 15000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 120 |
	And Delay 19
	And I click Choice button of the field named "Agreement"
	Then "Partner terms" window is opened
	And I activate field named "Description" in "List" table
	And I go to line in "List" table
		| 'Description'                                             |
		| 'Partner term with customer (by document + credit limit)' |
	And Delay 2	
	And I select current line in "List" table
* Fullfill the Company and Store fields
	And I dim UI Automation form items ""
		| 'Name / ID' | 'Type' |
		| 'Company' | 'ComboBox(50003)' |
		| 'Store'   | 'ComboBox(50003)' |
	
		| 'Name' | 'Value' |
		| 'text' | 'The Company and Store name fields will be automatically populated if only one name is defined in the Partner Terms Details catalog. Otherwise, manual selection will be required' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 6000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 30 |
	And Delay 5	
	Then the form attribute named "Company" became equal to "Own company 2"
	Then the form attribute named "Store" became equal to "Store 1 (with balance control)"
	And delay 2
* Next you need to fill in the Items for the order by Add button
	And I dim UI Automation form items ""
		| 'Name / ID' | 'Type'   |
		| 'Add'       | 'Button' |
					
		| 'Name'         | 'Value' |
		| 'text'         | 'Next you need to fill in the Items for the order by Add button'|
		| 'color'        | 32768   |
		| 'transparency' | 127     |
		| 'duration'     | 6000    |
		| 'thickness'    | 6       |
		| 'frameDelay'   | 30      |
	And Delay 7
	And in the table "ItemList" I click the button named "ItemListAdd"
	And Delay 2
	And I activate field named "ItemListItem" in "ItemList" table
	And I select current line in "ItemList" table
	And I dim UI Automation form items ""
		| 'Name / ID' | 'Type' |
		| 'Item' | 'Custom(50025)' |
	
		| 'Name' | 'Value' |
		| 'text' | 'This field is for entering the name or description of the item' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 4000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 20 |
	And Delay 5
	And I click choice button of the attribute named "ItemListItem" in "ItemList" table
	Then "Items" window is opened
	And I activate field named "Description" in "List" table
	And I go to line in "List" table
		| 'Description'        |
		| 'Item with item key' |
	And Delay 2
	And I select current line in "List" table
* And the Item key if necessary, if not it is filled in automatically
	And I activate field named "ItemListItemKey" in "ItemList" table
	And I dim UI Automation form items ""
		| 'Name / ID' | 'Type' |
		| 'Item key' | 'Custom(50025)' |
			
		| 'Name' | 'Value' |
		| 'text' | 'This field is for entering specific details or characteristics of the item. If no specific details are required, this field is filled in automatically.' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 6000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 30 |
	And Delay 10	
	And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
	Then "Item keys" window is opened
	And I activate field named "Item" in "List" table
	And I go to line in "List" table
		| 'Item key'  |
		| 'S/Color 1' |
	And Delay 2
	And I select current line in "List" table
* The Inventory origin, Price Type, Price, Unit, VAT, Store field is filled in automatically
	And "ItemList" table became equal
		| 'Item'               | 'Item key'  | 'Inventory origin' | 'Serial lot numbers' | 'Source of origins' | 'Quantity' | 'Price type' | 'Unit' | 'Price'  | 'VAT' | 'Offers amount' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Use work sheet' | 'Use shipment confirmation' | 'Store'                          | 'Project' | 'Delivery date' | 'Sales order' | 'Work order' | 'Profit loss center' | 'Revenue type' | 'Detail' | 'Additional analytic' | 'Other period revenue type' | 'Sales person' |
		| 'Item with item key' | 'S/Color 1' | 'Own stocks'       | ''                   | ''                  | '1,000'    | 'Wholesale'  | 'pcs'  | '190,00' | '20%' | ''              | 'No'                 | '31,67'      | '158,33'     | '190,00'       | 'No'             | 'Yes'                       | 'Store 1 (with balance control)' | ''        | ''              | ''            | ''           | ''                   | ''             | ''       | ''                    | ''                          | ''             |
* Enter the quantity of item and all other VAT, NET, Total amounts are calculated automatically
	And Delay 2
	And I activate field named "ItemListQuantity" in "ItemList" table
	And I select current line in "ItemList" table
	And I dim UI Automation form items ""
		| 'Name / ID' | 'Type' |
		| 'Quantity' | 'Custom(50025)' |
		
		| 'Name' | 'Value' |
		| 'text' | 'Enter the quantity of the item and all other VAT, NET, Total amounts are calculated automatically' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 6000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 30 |
	And Delay 5
	And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
	And I finish line editing in "ItemList" table
	And Delay 2
	And "ItemList" table became equal
		| 'Inventory origin' | 'Sales person' | 'Price type' | 'Item'               | 'Item key'  | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Source of origins' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Use work sheet' | 'Additional analytic' | 'Project' | 'Store'                          | 'Delivery date' | 'Other period revenue type' | 'Use shipment confirmation' | 'Detail' | 'Sales order' | 'Work order' | 'Revenue type' |
		| 'Own stocks'       | ''             | 'Wholesale'  | 'Item with item key' | 'S/Color 1' | ''                   | 'No'                 | '316,67'     | 'pcs'  | ''                   | ''                  | '10,000'   | '190,00' | '20%' | ''              | '1 583,33'   | '1 900,00'     | 'No'             | ''                    | ''        | 'Store 1 (with balance control)' | ''              | ''                          | 'Yes'                       | ''       | ''            | ''           | ''             |
* Finally, review all the details and save the Sales Order to complete the process
* You may firstly save document
	And I dim UI Automation form items ""
		| 'Name / ID'      | 'Type'   |
		| 'Save' | 'Button' |
			
		| 'Name'         | 'Value' |
		| 'text'         | 'You may save your document before posting' |
		| 'color'        | 32768   |
		| 'transparency' | 127     |
		| 'duration'     | 4000    |
		| 'thickness'    | 6       |
		| 'frameDelay'   | 20      |
	And Delay 3
//	And I click the button named "FormWrite"
* Then post and close, but you can direcly post and close, document will be saved anyway
	And I dim UI Automation form items ""
		| 'Name / ID'      | 'Type'   |
		| 'Post And Close' | 'Button' |
			
		| 'Name'         | 'Value' |
		| 'text'         | 'By clicking this button, your document will be automatically saved and posted, then closed'      |
		| 'color'        | 32768   |
		| 'transparency' | 127     |
		| 'duration'     | 4000    |
		| 'thickness'    | 6       |
		| 'frameDelay'   | 20      |
	And Delay 3
//	And I click the button named "FormPostAndClose"
	And I wait "Sales invoice * dated *" window closing in 20 seconds

Scenario: 02_Create Sales Invoice based on Sales Order document
* Firstly, go to Sales Orders
	Then I open hyperlink "e1cib/list/Document.SalesOrder"
	And I make dimming effect on UI Automation form elements "" as prompted
		| 'Hint' |
		| 'Sales Orders' |
	
		| 'Name' | 'Value' |
		| 'text' | 'Firstly, go to Sales Orders list and select your order' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 4000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 20 |
	And Delay 5
	And I go to the last line in "List" table
	And I select current line in "List" table
* Sales Order document opened
	Then "Sales order * dated *" window is opened
* Click on Generate button to create Sales Invoice document
	And I dim UI Automation form items ""
		| 'Name / ID' | 'Type' |
		| 'Generate' | 'Button' |
	
		| 'Name' | 'Value' |
		| 'text' | 'Click on Generate button and select Sales Invoice option from the list' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 6000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 30 |
	And Delay 7
	And I click the button named "FormDocumentSalesInvoiceGenerate"
	Then "Add linked document rows" window is opened
	And I dim UI Automation form items ""
		| 'Name / ID' | 'Type' |
		| 'Ok' | 'Button' |
	
		| 'Name' | 'Value' |
		| 'text' | 'By clicking the "OK" button, a new Sales Invoice document will be created and linked to the current Order document' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 6000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 30 |
	And Delay 7
	And I click the button named "FormOk"
	And Delay 1
* Now, new Sales Invoice document created
	And I dim UI Automation form items ""
		| 'Name / ID'      | 'Type'   |
		| 'Sales invoice (create)' | 'Pane(50033)' |
	
		| 'Name'         | 'Value' |
		| 'text'         | 'New Sales Invoice Document opened' |
		| 'color'        | 32768   |
		| 'transparency' | 127     |
		| 'duration'     | 4000    |
		| 'thickness'    | 6       |
		| 'frameDelay'   | 20      |
	And Delay 3
* All data imported to document accordingly
	And I dim UI Automation form items ""
		| 'Name / ID' | 'Type' |
		| 'Partner:' | 'Text(50020)' |
		| 'Description' | 'Text(50020)' |
		| 'Company:' | 'ComboBox(50003)' |
		| 'Legal name contract:' | 'ComboBox(50003)' |

		| 'Name' | 'Value' |
		| 'text' | 'The basic details as partner, legal name, term and warehouse are imported' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 6000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 30 |
	And Delay 5
* Also, Item table is imported as well
	And I dim UI Automation form items ""
		| 'Name / ID' | 'Type' |
		| 'Item list' | 'Tab(50018)' |
	
		| 'Name' | 'Value' |
		| 'text' | 'Additionally, the item list has been imported; however, the lines remain editable.' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 6000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 30 |
	And Delay 5
* The document can be saved before posting
	And I dim UI Automation form items ""
		| 'Name / ID'      | 'Type'   |
		| 'Save' | 'Button' |
			
		| 'Name'         | 'Value' |
		| 'text'         | 'You may save your document before posting' |
		| 'color'        | 32768   |
		| 'transparency' | 127     |
		| 'duration'     | 4000    |
		| 'thickness'    | 6       |
		| 'frameDelay'   | 20      |
	And Delay 5
	And I click the button named "FormWrite"
* Then post and close, but you can direcly post and close, document will be saved anyway
	And I dim UI Automation form items ""
		| 'Name / ID'      | 'Type'   |
		| 'Post And Close' | 'Button' |
			
		| 'Name'         | 'Value' |
		| 'text'         | 'By clicking this button, your document will be automatically saved and posted, then closed'      |
		| 'color'        | 32768   |
		| 'transparency' | 127     |
		| 'duration'     | 4000    |
		| 'thickness'    | 6       |
		| 'frameDelay'   | 20      |
	And Delay 5
	And I click the button named "FormPostAndClose"
	And I wait "Sales invoice * dated *" window closing in 20 seconds

Scenario: 03_Create Sales Invoice based on Shipment Confirmation document
* Firstly, go to Shipment Confirmations list
	Then I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
	And I make dimming effect on UI Automation form elements "" as prompted
		| 'Hint' |
		| 'Shipment confirmations' |
	
		| 'Name' | 'Value' |
		| 'text' | 'Firstly, go to Shipment confirmations list and select your shipment' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 4000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 20 |
	And Delay 5
	And I go to the last line in "List" table
	And I select current line in "List" table
* The Shipment Confirmation document opened
	Then "Shipment confirmation * dated *" window is opened
* Click on Generate button to create Sales Invoice document
	And I dim UI Automation form items ""
		| 'Name / ID' | 'Type' |
		| 'Generate' | 'Button' |
	
		| 'Name' | 'Value' |
		| 'text' | 'Click on Generate button and select Sales Invoice option from the list' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 6000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 30 |
	And Delay 7
	And I click the button named "FormDocumentSalesInvoiceGenerate"
	Then "Add linked document rows" window is opened
	And I dim UI Automation form items ""
		| 'Name / ID' | 'Type' |
		| 'Ok' | 'Button' |
	
		| 'Name' | 'Value' |
		| 'text' | 'By clicking the "OK" button, a new Sales Invoice document will be created and linked to the current Shipment document' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 6000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 30 |
	And Delay 7
	And I click the button named "FormOk"
	And Delay 1
* Now, new Sales Invoice document created
	And I dim UI Automation form items ""
		| 'Name / ID'      | 'Type'   |
		| 'Sales invoice (create)' | 'Pane(50033)' |
	
		| 'Name'         | 'Value' |
		| 'text'         | 'New Sales Invoice Document opened' |
		| 'color'        | 32768   |
		| 'transparency' | 127     |
		| 'duration'     | 4000    |
		| 'thickness'    | 6       |
		| 'frameDelay'   | 20      |
	And Delay 3
* All data imported to document accordingly
	And I dim UI Automation form items ""
		| 'Name / ID' | 'Type' |
		| 'Partner:' | 'Text(50020)' |
		| 'Description' | 'Text(50020)' |
		| 'Company:' | 'ComboBox(50003)' |
		| 'Legal name contract:' | 'ComboBox(50003)' |

		| 'Name' | 'Value' |
		| 'text' | 'The basic details, such as partner, legal name, term, and warehouse, are imported accordingly.' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 6000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 30 |
	And Delay 5
	And I dim UI Automation form items ""
		| 'Name / ID' | 'Type' |
		| 'Partner term:' | 'Text(50020)' |
	
		| 'Name' | 'Value' |
		| 'text' | 'However, some information may be missing, and in such cases, you will need to enter it manually.' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 6000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 30 |
	And Delay 7
	And I click Choice button of the field named "Agreement"
	Then "Partner terms" window is opened
	And I activate field named "Description" in "List" table
	And Delay 1
	And I go to line in "List" table
		| 'Description'                                             |
		| 'Partner term with customer (by document + credit limit)' |
	And delay 3
	And I select current line in "List" table
* According to selected Partner term the item details will be updated
	Then "Update item list info" window is opened
	And I dim UI Automation form items ""
		| 'Name / ID' | 'Type' |
		| 'OK' | 'Button' |
	
		| 'Name' | 'Value' |
		| 'text' | 'By clicling "OK" button the item details will be updated in accordance with the terms selected for the specified partner' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 6000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 30 |
	And Delay 6
	And I click the button named "FormOK"	
	And Delay 3
* Also, Item table is imported as well
	And I dim UI Automation form items ""
		| 'Name / ID' | 'Type' |
		| 'Item list' | 'Tab(50018)' |
	
		| 'Name' | 'Value' |
		| 'text' | 'Additionally, the item list has been imported; however, the lines remain editable.' |
		| 'color' | 32768 |
		| 'transparency' | 127 |
		| 'duration' | 6000 |
		| 'thickness' | 6 |
		| 'frameDelay' | 30 |
	And Delay 5
* The document can be saved before posting
	And I dim UI Automation form items ""
		| 'Name / ID'      | 'Type'   |
		| 'Save' | 'Button' |
			
		| 'Name'         | 'Value' |
		| 'text'         | 'You may save your document before posting' |
		| 'color'        | 32768   |
		| 'transparency' | 127     |
		| 'duration'     | 4000    |
		| 'thickness'    | 6       |
		| 'frameDelay'   | 20      |
	And Delay 5
	And I click the button named "FormWrite"
* Then post and close, but you can direcly post and close, document will be saved anyway
	And I dim UI Automation form items ""
		| 'Name / ID'      | 'Type'   |
		| 'Post And Close' | 'Button' |
			
		| 'Name'         | 'Value' |
		| 'text'         | 'By clicking this button, your document will be automatically saved and posted, then closed'      |
		| 'color'        | 32768   |
		| 'transparency' | 127     |
		| 'duration'     | 4000    |
		| 'thickness'    | 6       |
		| 'frameDelay'   | 20      |
	And Delay 5
	And I click the button named "FormPostAndClose"
	And I wait "Sales invoice * dated *" window closing in 20 seconds
