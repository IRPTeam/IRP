Function Strings(CodeLanguage) Export
	
	Strings = New Structure();
	
	#Region Service
	Strings.Insert("S_001", NStr("en = 'Unsupported type of request body'", CodeLanguage));
	
	// Can Not connect to: localhost:8080 Detail: There is no internet connection
	Strings.Insert("S_002", NStr("en = 'Can''t connect to: %1:%2 Detail: %3'", CodeLanguage));
	
	// Received response from: localhost:8080
	Strings.Insert("S_003", NStr("en = 'Received response from: %1:%2'", CodeLanguage));
	
	Strings.Insert("S_004", NStr("en = 'Resource address is empty'", CodeLanguage));
	
	// Integration setting Not found by name: connection_to_other_system
	Strings.Insert("S_005", NStr("en = 'Integration setting not found by name: %1'", CodeLanguage));
	
	Strings.Insert("S_006", NStr("en = 'Method unsupported on web client'", CodeLanguage));
	
	Strings.Insert("S_007", NStr("en = 'Metadata name is empty'", CodeLanguage));
	
	// Metadata name Not defined: Catalog_Items
	Strings.Insert("S_008", NStr("en = 'Metadata name not defined: %1'", CodeLanguage));
	
	Strings.Insert("S_009", NStr("en = 'JSON is empty'", CodeLanguage));
	
	Strings.Insert("S_010", NStr("en = 'External system is empty'", CodeLanguage));
	
	// External system Not defined: IRP
	Strings.Insert("S_011", NStr("en = 'External system not defined: %1'", CodeLanguage));
	Strings.Insert("S_012", NStr("en = 'Can''t retrive value for: Property[%1] Value[%2] Metadata[%3]'", CodeLanguage));
	
	// Special offers
	Strings.Insert("S_013", NStr("en = 'Not supperted type of object: %1'", CodeLanguage));
	
	// FileTransfer
	Strings.Insert("S_014", NStr("en = 'File name is empty'", CodeLanguage));
	Strings.Insert("S_015", NStr("en = 'Path for save not set'", CodeLanguage));
	
	// Test connection
	Strings.Insert("S_016", NStr("en = '%1 Status code: %2 %3'", CodeLanguage));
	// skipped "S_017"
	
	//	Barcode
	Strings.Insert("S_018", NStr("en = 'Item added'", CodeLanguage));
	Strings.Insert("S_019", NStr("en = 'Barcode %1 not found'", CodeLanguage));

	// 10 of 233 
	Strings.Insert("S_020", NStr("en = '%1 of %2'", CodeLanguage));
	
	
	Strings.Insert("S_021", NStr("en = 'Goods receipt'", CodeLanguage));
	Strings.Insert("S_022", NStr("en = 'Multicurrency receipt basises!'", CodeLanguage));
	
	Strings.Insert("S_023", NStr("en = 'Procurement method'", CodeLanguage));
	
	
	// name templates
	Strings.Insert("S_024", NStr("en = 'Customer Agreement, %1'", CodeLanguage));
	Strings.Insert("S_025", NStr("en = 'Vendor Agreement, %1'", CodeLanguage));
	Strings.Insert("S_026", NStr("en = 'Selected icon will be resized to 16x16 px'", CodeLanguage));
	
	Strings.Insert("S_027", NStr("en = '[Not filled]'", CodeLanguage));
	
	#EndRegion
	
	#Region Service
	Strings.Insert("Form_001", NStr("en = 'New page'", CodeLanguage));
	Strings.Insert("Form_002", NStr("en = 'Delete'", CodeLanguage));
	Strings.Insert("Form_003", NStr("en = 'Quantity'", CodeLanguage));
	Strings.Insert("Form_004", NStr("en = 'Customer agreements'", CodeLanguage));
	Strings.Insert("Form_005", NStr("en = 'Customers'", CodeLanguage));
	Strings.Insert("Form_006", NStr("en = 'Vendors'", CodeLanguage));
	Strings.Insert("Form_007", NStr("en = 'Vendor agreements'", CodeLanguage));
	Strings.Insert("Form_008", NStr("en = 'User'", CodeLanguage));
	Strings.Insert("Form_009", NStr("en = 'User group'", CodeLanguage));
	Strings.Insert("Form_010", NStr("en = 'Show all'", CodeLanguage));
	Strings.Insert("Form_011", NStr("en = 'Show selected (%1)'", CodeLanguage));
	Strings.Insert("Form_012", NStr("en = 'Load picture'", CodeLanguage));
	Strings.Insert("Form_013", NStr("en = 'Date'", CodeLanguage));
	Strings.Insert("Form_014", NStr("en = 'Number'", CodeLanguage));
	Strings.Insert("Form_015", NStr("en = 'Finish'", CodeLanguage));
	Strings.Insert("Form_016", NStr("en = 'Next'", CodeLanguage));
	 // change icon
	Strings.Insert("Form_017", NStr("en = 'Change'", CodeLanguage));
	 // clear icon
	Strings.Insert("Form_018", NStr("en = 'Clear'", CodeLanguage));
	 // cancel answer on question
	Strings.Insert("Form_019", NStr("en = 'Cancel'", CodeLanguage));
	Strings.Insert("Form_020", NStr("en = 'Retail, %1'", CodeLanguage));
	Strings.Insert("Form_021", NStr("en = 'Download currency rate type'", CodeLanguage));
	// PriceInfo report 
	Strings.Insert("Form_022", NStr("en = '1. By Item keys'", CodeLanguage));
	Strings.Insert("Form_023", NStr("en = '2. By Properties'", CodeLanguage));
	Strings.Insert("Form_024", NStr("en = '3. By Items'", CodeLanguage));
	#EndRegion
	
	#Region ErrorMessages
	Strings.Insert("Error_001", NStr("en = 'Unsupported type of barcode'", CodeLanguage));
	Strings.Insert("Error_002", NStr("en = '%1 descriptions is empty'", CodeLanguage));
	Strings.Insert("Error_003", NStr("en = 'Fill any description'", CodeLanguage));
	Strings.Insert("Error_004", NStr("en = 'Not supported medatada'", CodeLanguage));
	Strings.Insert("Error_005", NStr("en = 'Fill any additional attribute description %1'", CodeLanguage));
	Strings.Insert("Error_006", NStr("en = 'Recalculate offers'", CodeLanguage));
	Strings.Insert("Error_007", NStr("en = 'Not enough free balance: [%1][%2], In stock [%3]: free: %4 %5 necessary: %6 %7'", CodeLanguage));
	Strings.Insert("Error_008", NStr("en = 'Groups are created by administrator'", CodeLanguage));
	Strings.Insert("Error_009", NStr("en = 'Can`t write object: [%1]'", CodeLanguage));
	Strings.Insert("Error_010", NStr("en = 'Field: [%1] is empty'", CodeLanguage));
	Strings.Insert("Error_011", NStr("en = 'Need add any row'", CodeLanguage));
	Strings.Insert("Error_012", NStr("en = 'Not according rules for naming variable'", CodeLanguage));
	Strings.Insert("Error_013", NStr("en = 'Value is not unique'", CodeLanguage));
	Strings.Insert("Error_014", NStr("en = 'Password and password confirmation do not match'", CodeLanguage));
	Strings.Insert("Error_015", NStr("en = 'Webclient does not support this feature'", CodeLanguage));
	Strings.Insert("Error_016", NStr("en = 'Lines on which you need to order items from suppliers are missed in the Sales Order'", CodeLanguage));
	Strings.Insert("Error_017", NStr("en = 'Please, at first create Goods receipt or uncheck the box Goods receipt before Purchase invoice on the tab Other'", CodeLanguage));
	Strings.Insert("Error_018", NStr("en = 'Please, at first create Shipment confirmation or uncheck the box Shipment confirmation before Sales invoice on the tab Other'", CodeLanguage));
	Strings.Insert("Error_019", NStr("en = 'Lines on which you need to create %1 are missed In the %2.'", CodeLanguage));
	Strings.Insert("Error_020", NStr("en = 'Basis document is required on line %1'", CodeLanguage));
	Strings.Insert("Error_021", NStr("en = 'Lines on which you may create return are missed In the Purchase invoice. All products are already returned.'", CodeLanguage));
	Strings.Insert("Error_022", NStr("en = 'Lines on which you may create return are missed In the Sales invoice. All products are already returned.'", CodeLanguage));
	Strings.Insert("Error_023", NStr("en = 'Lines on which you need to order items from suppliers are missed In the Internal supply request'", CodeLanguage));
	Strings.Insert("Error_024", NStr("en = 'Please, at first create Sales invoice or check the box Shipment confirmation before Sales invoice on the tab Other'", CodeLanguage));
	Strings.Insert("Error_028", NStr("en = 'Please, check the box Goods receipt before Purche invoice on the tab ""Other""'", CodeLanguage));
	Strings.Insert("Error_029", NStr("en = 'Please, at first create Purchase invoice or check the box Goods receipt before Purchase invoice on the tab Other'", CodeLanguage));
	Strings.Insert("Error_030", NStr("en = 'The %1 is required on line %2 of the %3'", CodeLanguage));
	Strings.Insert("Error_031", NStr("en = 'Items were not received from supplier according to procurement method.'", CodeLanguage));
	Strings.Insert("Error_032", NStr("en = 'Action not completed'", CodeLanguage));
	Strings.Insert("Error_033", NStr("en = 'Dublicated attribute'", CodeLanguage));
	Strings.Insert("Error_034", NStr("en = '%1 is not picture storage volume'", CodeLanguage));
	Strings.Insert("Error_035", NStr("en = 'Cannot upload more than 1 file'", CodeLanguage));
	Strings.Insert("Error_036", NStr("en = 'Not found row by index In Files table'", CodeLanguage));
	Strings.Insert("Error_037", NStr("en = 'Unsupported data composition comparison type'", CodeLanguage));	
	Strings.Insert("Error_038", NStr("en = 'Thread have status [%1] but In register ThreadInfo set status [%2] Error info : [%3]'", CodeLanguage));
	Strings.Insert("Error_039", NStr("en = 'Job not found'", CodeLanguage));
	Strings.Insert("Error_040", NStr("en = 'Support picture files only'", CodeLanguage));
	Strings.Insert("Error_041", NStr("en = 'Tax table content more 1 row [key: %1] [tax: %2]'", CodeLanguage));
	Strings.Insert("Error_042", NStr("en = 'Cannot find tax by column name: %1'", CodeLanguage));
	Strings.Insert("Error_043", NStr("en = 'Unsupported document type'", CodeLanguage));
	Strings.Insert("Error_044", NStr("en = 'Not supported operation'", CodeLanguage));
	Strings.Insert("Error_045", NStr("en = 'Document is empty'", CodeLanguage));
	Strings.Insert("Error_046", NStr("en = 'An error occurred while connecting external barcode printing component.'", CodeLanguage));
	Strings.Insert("Error_047", NStr("en = '%1 is a required field'", CodeLanguage));
	Strings.Insert("Error_048", NStr("en = 'Select at least one %1 from %2'", CodeLanguage));
	Strings.Insert("Error_049", NStr("en = 'Default picture storage volume not set'", CodeLanguage));
	Strings.Insert("Error_050", NStr("en = 'Currency exchange is possible only through accounts with the same type (cash account or bank account).'", CodeLanguage));
	Strings.Insert("Error_051", NStr("en = 'Lines on which you may create %1 are missed. Or all %1 are already created.'", CodeLanguage));
	Strings.Insert("Error_052", NStr("en = 'Unchecking ""Use shipment confirmation"" isn`t posible. Shipment confirmations from store %1 have already been created previously.'", CodeLanguage));
	Strings.Insert("Error_053", NStr("en = 'Unchecking ""Use goods receipt"" isn`t posible. Goods receipts from store %1 have already been created previously.'", CodeLanguage));
	Strings.Insert("Error_054", NStr("en = 'Not properly status of sales order to proceed.'", CodeLanguage));
	Strings.Insert("Error_055", NStr("en = 'No lines with properly procurement method.'", CodeLanguage));
	Strings.Insert("Error_056", NStr("en = 'All items in sales order are already ordered by purchase order(s).'", CodeLanguage));
	Strings.Insert("Error_057", NStr("en = 'Don`t need to create a %1 for selected Cash transfer order(s).'", CodeLanguage));
	Strings.Insert("Error_058", NStr("en = 'Whole amount in Cash transfer order(s) are already payed by document %1(s).'", CodeLanguage));
	Strings.Insert("Error_059", NStr("en = 'In the selected documents there are Cash transfer order(s) by which %1(s) has already been created and those for which %1 doesn`t need to be created.'", CodeLanguage));
	Strings.Insert("Error_060", NStr("en = 'Whole amount in Cash transfer order(s) are already recieved by document %1(s).'", CodeLanguage));
	Strings.Insert("Error_061", NStr("en = 'Not posible to change box ""Shipment confirmation before sales invoice"" because for this Sales order already have been created %1(s).'", CodeLanguage));
	Strings.Insert("Error_062", NStr("en = 'There is no need to create shipment confirmation for the store(s) %1.'", CodeLanguage));
	Strings.Insert("Error_063", NStr("en = 'There is not possible to post Sales order for the store(s) %1.'", CodeLanguage));
	Strings.Insert("Error_064", NStr("en = 'There is no need to create Shipment confirmation for store(s) %1. Item will be shipped by Sales order'", CodeLanguage));
	Strings.Insert("Error_065", NStr("en = 'Item key is not unique'", CodeLanguage));
	Strings.Insert("Error_066", NStr("en = 'Specification is not unique'", CodeLanguage));
	Strings.Insert("Error_067", NStr("en = 'Not properly status of %1 to proceed.'", CodeLanguage));	
	Strings.Insert("Error_068", NStr("en = 'Line No. [%1] [%2 %3] %4 remains: %5 %8 Required: %6 %8 Lacks: %7 %8'", CodeLanguage));
	Strings.Insert("Error_071", NStr("en = 'External data processor ""%1"" was not connected'", CodeLanguage));
	Strings.Insert("Error_072", NStr("en = 'Store is required on line %1'", CodeLanguage));
	Strings.Insert("Error_073", NStr("en = 'All items in %1(s) are already received by %2(s).'", CodeLanguage));
	Strings.Insert("Error_074", NStr("en = 'Currency transfer is possible only when amounts is equal.'", CodeLanguage));
	Strings.Insert("Error_075", NStr("en = 'Not yet all Physical count by location is closed'", CodeLanguage));
	#EndRegion
	
	#Region InfoMessages
	Strings.Insert("InfoMessage_001", NStr("en = '%1 is not the same as the %2 will be due to the fact that there is already another %1 that partially closed this %2'", CodeLanguage));
	Strings.Insert("InfoMessage_002", NStr("en = 'Object %1 created'", CodeLanguage));
	Strings.Insert("InfoMessage_003", NStr("en = 'This is the service form.'", CodeLanguage));
	Strings.Insert("InfoMessage_004", NStr("en = 'Save object before continue'", CodeLanguage));
	Strings.Insert("InfoMessage_005", NStr("en = 'Done'", CodeLanguage));
	Strings.Insert("InfoMessage_006", NStr("en = 'Document Physical count by location already created, use update'", CodeLanguage));
	Strings.Insert("InfoMessage_007", NStr("en = '#%1 date: %2'", CodeLanguage));
	#EndRegion
	
	#Region QuestionToUser
	Strings.Insert("QuestionToUser_001", NStr("en = 'The object is not saved, you must write to continue. Continue?'", CodeLanguage));
	Strings.Insert("QuestionToUser_002", NStr("en = 'Would you like to switch to scan mode?'", CodeLanguage));
	Strings.Insert("QuestionToUser_003", NStr("en = 'Filled data on cheque bonds transactions will be deleted. Do you want to update %1?'", CodeLanguage));
	Strings.Insert("QuestionToUser_004", NStr("en = 'Change tax rates according agreement?'", CodeLanguage));
	Strings.Insert("QuestionToUser_005", NStr("en = 'Do you want to update filled stores?'", CodeLanguage));
	Strings.Insert("QuestionToUser_006", NStr("en = 'Do you want to update filled Currency?'", CodeLanguage));
	Strings.Insert("QuestionToUser_007", NStr("en = 'Transaction table will be cleared. Continue?'", CodeLanguage));
	Strings.Insert("QuestionToUser_008", NStr("en = 'When the currency is changed, rows with cash transfer documents will be cleared. Continue?'", CodeLanguage));
	Strings.Insert("QuestionToUser_009", NStr("en = 'Update filled stores on %1'", CodeLanguage));
	Strings.Insert("QuestionToUser_011", NStr("en = 'Update filled price types on %1'", CodeLanguage));
	Strings.Insert("QuestionToUser_012", NStr("en = 'Do you want to exit?'", CodeLanguage));
	Strings.Insert("QuestionToUser_013", NStr("en = 'Update filled prices.'", CodeLanguage));
	Strings.Insert("QuestionToUser_014", NStr("en = 'Transaction type changed. Do you want to update filled data?'", CodeLanguage));
	Strings.Insert("QuestionToUser_015", NStr("en = 'Filled data will be cleared. Proceed?'", CodeLanguage));
	Strings.Insert("QuestionToUser_016", NStr("en = 'Change or clear icon?'", CodeLanguage));
	#EndRegion
	
	#Region SuggestionToUser
	Strings.Insert("SuggestionToUser_1", NStr("en = 'Choice value'", CodeLanguage));
	Strings.Insert("SuggestionToUser_2", NStr("en = 'Enter barcode'", CodeLanguage));
	#EndRegion
	
	#Region UsersEvent
	Strings.Insert("UsersEvent_001", NStr("en = 'User not found by UUID: %1 Name: %2'", CodeLanguage));
	Strings.Insert("UsersEvent_002", NStr("en = 'User found by UUID: %1 Name: %2'", CodeLanguage));
	#EndRegion
	
	#Region Items
	
	// Interface
	Strings.Insert("I_1", NStr("en = 'Enter Description'", CodeLanguage));
	
	Strings.Insert("I_2", NStr("en = 'Click for input description'", CodeLanguage));
	
	Strings.Insert("I_3", NStr("en = 'Please, fill the document'", CodeLanguage));
	
	#EndRegion
	
	#Region Exceptions
	Strings.Insert("Exc_001", NStr("en = 'Not supported object type'", CodeLanguage));
	Strings.Insert("Exc_002", NStr("en = 'Not condition'", CodeLanguage));
	Strings.Insert("Exc_003", NStr("en = 'Not implemented method: %1'", CodeLanguage));
	Strings.Insert("Exc_004", NStr("en = 'Can not extract Currency from object'", CodeLanguage));
	Strings.Insert("Exc_005", NStr("en = 'Library name is empty'", CodeLanguage));
	Strings.Insert("Exc_006", NStr("en = 'Library data not contain version'", CodeLanguage));
	Strings.Insert("Exc_007", NStr("en = 'Not implemented for library version: %1'", CodeLanguage));
	Strings.Insert("Exc_008", NStr("en = 'Unknown row key'", CodeLanguage));
	Strings.Insert("Exc_009", NStr("en = 'Error: %1'", CodeLanguage));
	#EndRegion
	
	#Region Saas
	Strings.Insert("Saas_001", NStr("en = 'Area %1 not found!'", CodeLanguage));
	Strings.Insert("Saas_002", NStr("en = 'Area status: %1'", CodeLanguage));
	Strings.Insert("Saas_003", NStr("en = 'Company localization %1 is not available'", CodeLanguage));
	#EndRegion
	
	#Region FillingFromClassifiers
	// Do not modify "en" strings
	Strings.Insert("Class_001", NStr("en = 'Purchase price'", CodeLanguage));
	Strings.Insert("Class_002", NStr("en = 'Sales price'"   , CodeLanguage));
	Strings.Insert("Class_003", NStr("en = 'Prime cost'"    , CodeLanguage));
	Strings.Insert("Class_004", NStr("en = 'Service'"       , CodeLanguage));
	Strings.Insert("Class_005", NStr("en = 'Product'"       , CodeLanguage));
	Strings.Insert("Class_006", NStr("en = 'Main store'"    , CodeLanguage));
	Strings.Insert("Class_007", NStr("en = 'Main manager'"  , CodeLanguage));
	Strings.Insert("Class_008", NStr("en = 'pcs'"           , CodeLanguage));
	#EndRegion
	
	#Region Titles
	Strings.Insert("Title_00100", NStr("en = 'Select basis documents in Cheque bond transaction'", CodeLanguage));	// Form PickUpDocuments
	
	#EndRegion
	Return Strings;
EndFunction
