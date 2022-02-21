// @strict-types

// Strings.
// 
// Parameters:
//  Lang - String - Lang
// 
// Returns:
// Structure - Localization strings:
//	* Eq_001 - String - Installed
//	* Eq_002 - String - Not installed
//	* Eq_003 - String - There are no errors.
//	* Eq_004 - String - Scanner is connected.
//	* Eq_005 - String - Error. Scanner not connected.
//	* Eq_006 - String - Installed on current PC.
//	* EqError_001 - String - The device is connected. The device must be disabled before the operation.
//	* EqError_002 - String - The device driver could not be downloaded. Check that the driver is correctly installed and registered in the system.
//	* EqError_003 - String - It has to be minimum one dot at Add ID.
//	* EqError_004 - String - Before install driver - it has to be loaded.
//	* EqError_005 - String - The equipment driver %1 has incorrect AddIn ID %2.
//	* POS_s1 - String - Amount paid is less than amount of the document
//	* POS_s2 - String - Card fees are more than the amount of the document
//	* POS_s3 - String - There is no need to use cash, as card payments are sufficient to pay
//	* POS_s4 - String - Amounts of payments are incorrect
//	* S_002 - String - Cannot connect to %1:%2. Details: %3
//	* S_003 - String - Received response from %1:%2
//	* S_004 - String - Resource address is empty.
//	* S_005 - String - Integration setting with name %1 is not found.
//	* S_006 - String - Method is not supported in Web Client.
//	* S_013 - String - Unsupported object type: %1.
//	* S_014 - String - File name is empty.
//	* S_015 - String - Path for saving is not set.
//	* S_016 - String - %1 Status code: %2 %3
//	* S_018 - String - Item added. 
//	* S_019 - String - Barcode %1 not found.
//	* S_022 - String - Currencies in the base documents must match.
//	* S_023 - String - Procurement method
//	* S_026 - String - Selected icon will be resized to 16x16 px.
//	* S_027 - String - [Not filled]
//	* S_028 - String - Success
//	* S_029 - String - Not supporting web client
//	* S_030 - String - Cashback
//	* S_031 - String - or
//	* S_032 - String - Add code, ex: CurrentSessionDate()
//	* Form_001 - String - New page
//	* Form_002 - String - Delete
//	* Form_003 - String - Quantity
//	* Form_004 - String - Customers terms
//	* Form_005 - String - Customers
//	* Form_006 - String - Vendors
//	* Form_007 - String - Vendors terms
//	* Form_008 - String - User
//	* Form_009 - String - User group
//	* Form_013 - String - Date
//	* Form_014 - String - Number
//	* Form_017 - String - Change
//	* Form_018 - String - Clear
//	* Form_019 - String - Cancel
//	* Form_022 - String - 1. By item keys
//	* Form_023 - String - 2. By properties
//	* Form_024 - String - 3. By items
//	* Form_025 - String - Create from classifier
//	* Form_026 - String - Item Bundle
//	* Form_027 - String - Item
//	* Form_028 - String - Item type
//	* Form_029 - String - External attributes
//	* Form_030 - String - Dimensions
//	* Form_031 - String - Weight information
//	* Form_032 - String - Period
//	* Form_033 - String - Show all
//	* Form_034 - String - Hide all
//	* Form_035 - String - Head
//	* Error_002 - String - %1 description is empty
//	* Error_003 - String - Fill any description.
//	* Error_004 - String - Metadata is not supported.
//	* Error_005 - String - Fill the description of an additional attribute %1.
//	* Error_008 - String - Groups are created by an administrator.
//	* Error_009 - String - Cannot write the object: [%1].
//	* Error_010 - String - Field [%1] is empty.
//	* Error_011 - String - Add at least one row.
//	* Error_012 - String - Variable is not named according to the rules.
//	* Error_013 - String - Value is not unique.
//	* Error_014 - String - Password and password confirmation do not match.
//	* Error_016 - String - There are no more items that you need to order from suppliers in the "%1" document.
//	* Error_017 - String - First, create a "%1" document or clear the "%1 before %2" check box on the "Other" tab.
//	* Error_018 - String - First, create a "%1" document or clear the "%1 before %2" check box on the "Other" tab.
//	* Error_019 - String - There are no lines for which you need to create a "%1" document in the "%2" document.
//	* Error_020 - String - Specify a base document for line %1.
//	* Error_021 - String - There are no products to return in the "%1" document. All products are already returned.
//	* Error_023 - String - There are no more items that you need to order from suppliers in the "%1" document.
//	* Error_028 - String - Select the "%1 before %2" check box on the "Other" tab.
//	* Error_030 - String - Specify %1 in line %2 of the %3.
//	* Error_031 - String - Items were not received from the supplier according to the procurement method.
//	* Error_032 - String - Action not completed.
//	* Error_033 - String - Duplicate attribute.
//	* Error_034 - String - %1 is not a picture storage volume.
//	* Error_035 - String - Cannot upload more than 1 file.
//	* Error_037 - String - Unsupported type of data composition comparison.
//	* Error_040 - String - Only picture files are supported.
//	* Error_041 - String - Tax table contains more than 1 row [key: %1] [tax: %2].
//	* Error_042 - String - Cannot find a tax by column name: %1.
//	* Error_043 - String - Unsupported document type.
//	* Error_044 - String - Operation is not supported.
//	* Error_045 - String - Document is empty.
//	* Error_047 - String - "%1" is a required field.
//	* Error_049 - String - Default picture storage volume is not set.
//	* Error_050 - String - Currency exchange is available only for the same-type accounts (cash accounts or bank accounts).'", Lang));
//	* Error_051 - String - There are no lines for which you can create a "%1" document, or all "%1" documents are already created.'", Lang));
//	* Error_052 - String - Cannot clear the "%2" check box. Documents "%3" from store %1 were already created.
//	* Error_053 - String - Cannot clear the "%2" check box. Documents "%3" from store %1 were already created.
//	* Error_054 - String - Cannot continue. The "%1"document has an incorrect status.
//	* Error_055 - String - There are no lines with a correct procurement method.
//	* Error_056 - String - All items in the "%1" document are already ordered using the "%2" document(s).
//	* Error_057 - String - You do not need to create a "%1" document for the selected "%2" document(s).
//	* Error_058 - String - The total amount of the "%2" document(s) is already paid on the basis of the "%1" document(s).
//	* Error_059 - String - In the selected documents, there are "%2" document(s) with existing "%1" document(s) and those that do not require a "%1" document.
//	* Error_060 - String - The total amount of the "%2" document(s) is already received on the basis of the "%1" document(s).
//	* Error_064 - String - You do not need to create a "%2" document for store(s) %1. The item will be shipped using the "%3" document.
//	* Error_065 - String - Item key is not unique.
//	* Error_066 - String - Specification is not unique.
//	* Error_067 - String - Fill Users or Group tables.
//	* Error_068 - String - Line No. [%1] [%2 %3] %4 remaining: %5 %8. Required: %6 %8. Lacking: %7 %8.
//	* Error_071 - String - Plugin "%1" is not connected.
//	* Error_072 - String - Specify a store in line %1.
//	* Error_073 - String - All items in the "%1" document(s) are already received using the "%2" document(s).
//	* Error_074 - String - Currency transfer is available only when amounts are equal.
//	* Error_075 - String - There are "%1" documents that are not closed.
//	* Error_077 - String - Basis document is empty in line %1.
//	* Error_078 - String - Quantity [%1] does not match the quantity [%2] by serial/lot numbers
//	* Error_079 - String - Payment amount [%1] and return amount [%2] not match
//	* Error_080 - String - In line %1 quantity by %2 %3 greater than %4
//	* Error_081 - String - In line %1 quantity by %2-%3 %4 less than quantity by goods receipt %5
//	* Error_082 - String - In line %1 quantity by %2-%3 %4 less than quantity by goods receipt %5
//	* Error_083 - String - Location with number `%1` not found.
//	* Error_085 - String - Credit limit exceeded. Limit: %1, limit balance: %2, transaction: %3, lack: %4 %5
//	* Error_086 - String - Amount : %1 not match Payment term amount: %2
//	* Error_087 - String - Parent can not be empty
//	* Error_088 - String - Basis unit has to be filled, if item filter used.
//	* Error_089 - String - Description%1 "%2" is already in use.
//	* Error_090 - String - [%1 %2] %3 remaining: %4 %7. Required: %5 %7. Lacking: %6 %7.
//	* Error_091 - String - Only Administrator can create users.
//	* Error_092 - String - Can not use %1 role in SaaS mode
//	* Error_093 - String - Cancel reason has to be filled if string was canceled
//	* Error_094 - String - Can not use confirmation of shipment without goods receipt
//	* Error_095 - String - Payment amount [%1] and sales amount [%2] not match
//	* Error_096 - String - Select any document
//	* Error_097 - String - Default file storage volume is not set.
//	* Error_098 - String - %1 is undefined.
//	* InfoMessage_001 - String - The "%1" document does not fully match the "%2" document because there is already another "%1" document that partially covered this "%2" document.
//	* InfoMessage_002 - String - Object %1 created.
//	* InfoMessage_003 - String - This is a service form.
//	* InfoMessage_004 - String - Save the object to continue.
//	* InfoMessage_005 - String - Done
//	* InfoMessage_006 - String - The "%1" document is already created. You can update the quantity.
//	* InfoMessage_007 - String - #%1 date: %2
//	* InfoMessage_008 - String - #%1 date: %2
//	* InfoMessage_009 - String - Total quantity doesnt match. Please count one more time. You have one more try.
//	* InfoMessage_010 - String - Total quantity doesnt match. Location need to be count again (current count is annulated).
//	* InfoMessage_011 - String - Total quantity is ok. Please scan and count next location.
//	* InfoMessage_012 - String - Current location #%1 was started by another user. User: %2
//	* InfoMessage_013 - String - Current location #%1 was linked to you. Other users will not be able to scan it.
//	* InfoMessage_014 - String - Current location #%1 was scanned and closed before. Please scan next location.
//	* InfoMessage_015 - String - Serial lot %1 was not found. Create new?
//	* InfoMessage_016 - String - Scanned barcode %1 is using for another items %2
//	* InfoMessage_017 - String - Scanned barcode %1 is not using set for serial numbers
//	* InfoMessage_018 - String - Add or scan serial lot number
//	* InfoMessage_019 - String - Data lock reasons:
//	* InfoMessage_020 - String - Created document: %1
//	* InfoMessage_021 - String - Can not unlock attributes, this is element used %1 times, ex.:
//	* InfoMessage_022 - String - This order is closed by %1
//	* InfoMessage_023 - String - Сan not use confirmation of shipment without goods receipt. Use goods receipt mode is enabled.
//	* InfoMessage_024 - String - Will be available after save.
//	* QuestionToUser_001 - String - Write the object to continue. Continue?
//	* QuestionToUser_002 - String - Do you want to switch to scan mode?
//	* QuestionToUser_003 - String - Filled data on cheque bonds transactions will be deleted. Do you want to update %1?
//	* QuestionToUser_004 - String - Do you want to change tax rates according to the partner term?
//	* QuestionToUser_005 - String - Do you want to update filled stores?
//	* QuestionToUser_006 - String - Do you want to update filled currency?
//	* QuestionToUser_007 - String - Transaction table will be cleared. Continue?
//	* QuestionToUser_008 - String - Changing the currency will clear the rows with cash transfer documents. Continue?
//	* QuestionToUser_009 - String - Do you want to replace filled stores with store %1?
//	* QuestionToUser_011 - String - Do you want to replace filled price types with price type %1?
//	* QuestionToUser_012 - String - Do you want to exit?
//	* QuestionToUser_013 - String - Do you want to update filled prices?
//	* QuestionToUser_014 - String - Transaction type is changed. Do you want to update filled data?
//	* QuestionToUser_015 - String - Filled data will be cleared. Continue?
//	* QuestionToUser_016 - String - Do you want to change or clear the icon?
//	* QuestionToUser_017 - String - How many documents to create?
//	* QuestionToUser_018 - String - Please enter total quantity
//	* QuestionToUser_019 - String - Do you want to update payment term?
//	* QuestionToUser_020 - String - Do you want to overwrite saved option?
//	* QuestionToUser_021 - String - Do you want to close this form? All changes will be lost.
//	* QuestionToUser_022 - String - Do you want to upload this files:
//	* SuggestionToUser_1 - String - Select a value
//	* SuggestionToUser_2 - String - Enter a barcode
//	* SuggestionToUser_3 - String - Enter an option name
//	* SuggestionToUser_4 - String - Enter a new option name
//	* UsersEvent_001 - String - User not found by UUID %1 and name %2.
//	* UsersEvent_002 - String - User found by UUID %1 and name %2.
//	* I_1 - String - Enter description
//	* I_2 - String - Click to enter description
//	* I_3 - String - Fill out the document
//	* I_4 - String - Find %1 rows in table by key %2
//	* I_5 - String - Not supported table
//	* I_6 - String - Ordered without ISR
//	* Exc_001 - String - Unsupported object type.
//	* Exc_002 - String - No conditions
//	* Exc_003 - String - Method is not implemented: %1.
//	* Exc_004 - String - Cannot extract currency from the object.
//	* Exc_005 - String - Library name is empty.
//	* Exc_006 - String - Library data does not contain a version.
//	* Exc_007 - String - Not applicable for library version %1.
//	* Exc_008 - String - Unknown row key.
//	* Exc_009 - String - Error: %1
//	* Saas_001 - String - Area %1 not found.
//	* Saas_002 - String - Area status: %1.
//	* Saas_003 - String - Localization %1 of the company is not available.
//	* Saas_004 - String - Area preparation completed
//	* Class_001 - String - Purchase price
//	* Class_002 - String - Sales price
//	* Class_003 - String - Prime cost
//	* Class_004 - String - Service
//	* Class_005 - String - Product
//	* Class_006 - String - Main store
//	* Class_007 - String - Main manager
//	* Class_008 - String - pcs
//	* Title_00100 - String - Select base documents in the "%1" document.	
//	* CLV_1 - String - All
//	* SOR_1 - String - Not enough items in free stock
Function Strings(Lang) Export

	Strings = New Structure();

#Region Equipment
	Strings.Insert("Eq_001", NStr("en = 'Installed'", Lang));
	Strings.Insert("Eq_002", NStr("en = 'Not installed'", Lang));
	Strings.Insert("Eq_003", NStr("en = 'There are no errors.'", Lang));
	Strings.Insert("Eq_004", NStr("en = 'Scanner is connected.'", Lang));
	Strings.Insert("Eq_005", NStr("en = 'Error. Scanner not connected.'", Lang));
	Strings.Insert("Eq_006", NStr("en = 'Installed on current PC.'", Lang));
	Strings.Insert("Eq_007", NStr("en = 'Can not connect device %1'", Lang));

	Strings.Insert("EqError_001", NStr(
		"en = 'The device is connected. The device must be disabled before the operation.'", Lang));

	Strings.Insert("EqError_002", NStr("en = 'The device driver could not be downloaded.
									   |Check that the driver is correctly installed and registered in the system.'",
		Lang));

	Strings.Insert("EqError_003", NStr("en = 'It has to be minimum one dot at Add ID.'", Lang));
	Strings.Insert("EqError_004", NStr("en = 'Before install driver - it has to be loaded.'", Lang));
	Strings.Insert("EqError_005", NStr("en = 'The equipment driver %1 has incorrect AddIn ID %2.'", Lang));
#EndRegion

#Region POS

	Strings.Insert("POS_s1", NStr("en = 'Amount paid is less than amount of the document'", Lang));
	Strings.Insert("POS_s2", NStr("en = 'Card fees are more than the amount of the document'", Lang));
	Strings.Insert("POS_s3", NStr("en = 'There is no need to use cash, as card payments are sufficient to pay'", Lang));
	Strings.Insert("POS_s4", NStr("en = 'Amounts of payments are incorrect'", Lang));
	Strings.Insert("POS_s5", NStr("en = 'Select sales person'", Lang));
#EndRegion

#Region Service
	
	// %1 - localhost
	// %2 - 8080 
	// %3 - There is no internet connection
	Strings.Insert("S_002", NStr("en = 'Cannot connect to %1:%2. Details: %3'", Lang));
	
	// %1 - localhost
	// %2 - 8080
	Strings.Insert("S_003", NStr("en = 'Received response from %1:%2'", Lang));
	Strings.Insert("S_004", NStr("en = 'Resource address is empty.'", Lang));
	
	// %1 - connection_to_other_system
	Strings.Insert("S_005", NStr("en = 'Integration setting with name %1 is not found.'", Lang));
	Strings.Insert("S_006", NStr("en = 'Method is not supported in Web Client.'", Lang));
	
	// Special offers
	Strings.Insert("S_013", NStr("en = 'Unsupported object type: %1.'", Lang));
	
	// FileTransfer
	Strings.Insert("S_014", NStr("en = 'File name is empty.'", Lang));
	Strings.Insert("S_015", NStr("en = 'Path for saving is not set.'", Lang));
	
	// Test connection
	// %1 - Method unsupported on web client
	// %2 - 404
	// %3 - Text frim site
	Strings.Insert("S_016", NStr("en = '%1 Status code: %2 %3'", Lang));
	
	//	scan barcode
	Strings.Insert("S_018", NStr("en = 'Item added.'", Lang)); 
	
	// %1 - 123123123123
	Strings.Insert("S_019", NStr("en = 'Barcode %1 not found.'", Lang));
	Strings.Insert("S_022", NStr("en = 'Currencies in the base documents must match.'", Lang));
	Strings.Insert("S_023", NStr("en = 'Procurement method'", Lang));

	Strings.Insert("S_026", NStr("en = 'Selected icon will be resized to 16x16 px.'", Lang));

	// presentation of empty value for query result
	Strings.Insert("S_027", NStr("en = '[Not filled]'", Lang));
	// operation is Success
	Strings.Insert("S_028", NStr("en = 'Success'", Lang));
	Strings.Insert("S_029", NStr("en = 'Not supporting web client'", Lang));
	Strings.Insert("S_030", NStr("en = 'Cashback'", Lang));
	Strings.Insert("S_031", NStr("en = 'or'", Lang));
	Strings.Insert("S_032", NStr("en = 'Add code, ex: CurrentSessionDate()'", Lang));
#EndRegion

#Region Service
	Strings.Insert("Form_001", NStr("en = 'New page'", Lang));
	Strings.Insert("Form_002", NStr("en = 'Delete'", Lang));
	Strings.Insert("Form_003", NStr("en = 'Quantity'", Lang));
	Strings.Insert("Form_004", NStr("en = 'Customers terms'", Lang));
	Strings.Insert("Form_005", NStr("en = 'Customers'", Lang));
	Strings.Insert("Form_006", NStr("en = 'Vendors'", Lang));
	Strings.Insert("Form_007", NStr("en = 'Vendors terms'", Lang));
	Strings.Insert("Form_008", NStr("en = 'User'", Lang));
	Strings.Insert("Form_009", NStr("en = 'User group'", Lang));
	Strings.Insert("Form_013", NStr("en = 'Date'", Lang));
	Strings.Insert("Form_014", NStr("en = 'Number'", Lang));
	
	// change icon
	Strings.Insert("Form_017", NStr("en = 'Change'", Lang));
	
	// clear icon
	Strings.Insert("Form_018", NStr("en = 'Clear'", Lang));
	
	// cancel answer on question
	Strings.Insert("Form_019", NStr("en = 'Cancel'", Lang));
	
	// PriceInfo report 
	Strings.Insert("Form_022", NStr("en = '1. By item keys'", Lang));
	Strings.Insert("Form_023", NStr("en = '2. By properties'", Lang));
	Strings.Insert("Form_024", NStr("en = '3. By items'", Lang));

	Strings.Insert("Form_025", NStr("en = 'Create from classifier'", Lang));

	Strings.Insert("Form_026", NStr("en = 'Item Bundle'", Lang));
	Strings.Insert("Form_027", NStr("en = 'Item'", Lang));
	Strings.Insert("Form_028", NStr("en = 'Item type'", Lang));
	Strings.Insert("Form_029", NStr("en = 'External attributes'", Lang));
	Strings.Insert("Form_030", NStr("en = 'Dimensions'", Lang));
	Strings.Insert("Form_031", NStr("en = 'Weight information'", Lang));
	Strings.Insert("Form_032", NStr("en = 'Period'", Lang));
	Strings.Insert("Form_033", NStr("en = 'Show all'", Lang));
	Strings.Insert("Form_034", NStr("en = 'Hide all'", Lang));
	Strings.Insert("Form_035", NStr("en = 'Head'", Lang));
#EndRegion

#Region ErrorMessages

	// %1 - en
	Strings.Insert("Error_002", NStr("en = '%1 description is empty'", Lang));
	Strings.Insert("Error_003", NStr("en = 'Fill any description.'", Lang));
	Strings.Insert("Error_004", NStr("en = 'Metadata is not supported.'", Lang));
	
	// %1 - en
	Strings.Insert("Error_005", NStr("en = 'Fill the description of an additional attribute %1.'", Lang));
	Strings.Insert("Error_008", NStr("en = 'Groups are created by an administrator.'", Lang));
	
	// %1 - Number 111 is not unique
	Strings.Insert("Error_009", NStr("en = 'Cannot write the object: [%1].'", Lang));
	
	// %1 - Number
	Strings.Insert("Error_010", NStr("en = 'Field [%1] is empty.'", Lang));
	Strings.Insert("Error_011", NStr("en = 'Add at least one row.'", Lang));
	Strings.Insert("Error_012", NStr("en = 'Variable is not named according to the rules.'", Lang));
	Strings.Insert("Error_013", NStr("en = 'Value is not unique.'", Lang));
	Strings.Insert("Error_014", NStr("en = 'Password and password confirmation do not match.'", Lang));

	// %1 - Sales order
	Strings.Insert("Error_016", NStr(
		"en = 'There are no more items that you need to order from suppliers in the ""%1"" document.'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_017", NStr(
		"en = 'First, create a ""%1"" document or clear the ""%1 before %2"" check box on the ""Other"" tab.'", Lang));

	// %1 - Shipment confirmation
	// %1 - Sales invoice
	Strings.Insert("Error_018", NStr(
		"en = 'First, create a ""%1"" document or clear the ""%1 before %2"" check box on the ""Other"" tab.'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_019", NStr(
		"en = 'There are no lines for which you need to create a ""%1"" document in the ""%2"" document.'", Lang));

	// %1 - 12
	Strings.Insert("Error_020", NStr("en = 'Specify a base document for line %1.'", Lang));

	// %1 - Purchase invoice
	Strings.Insert("Error_021", NStr(
		"en = 'There are no products to return in the ""%1"" document. All products are already returned.'", Lang));

	// %1 - Internal supply request
	Strings.Insert("Error_023", NStr(
		"en = 'There are no more items that you need to order from suppliers in the ""%1"" document.'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_028", NStr("en = 'Select the ""%1 before %2"" check box on the ""Other"" tab.'", Lang));
	
	// %1 - Cash account
	// %2 - 12
	// %3 - Cheque bonds
	Strings.Insert("Error_030", NStr("en = 'Specify %1 in line %2 of the %3.'", Lang));

	Strings.Insert("Error_031", NStr(
		"en = 'Items were not received from the supplier according to the procurement method.'", Lang));
	Strings.Insert("Error_032", NStr("en = 'Action not completed.'", Lang));
	Strings.Insert("Error_033", NStr("en = 'Duplicate attribute.'", Lang));
	// %1 - Google drive
	Strings.Insert("Error_034", NStr("en = '%1 is not a picture storage volume.'", Lang));
	Strings.Insert("Error_035", NStr("en = 'Cannot upload more than 1 file.'", Lang));
	Strings.Insert("Error_037", NStr("en = 'Unsupported type of data composition comparison.'", Lang));
	Strings.Insert("Error_040", NStr("en = 'Only picture files are supported.'", Lang));
	Strings.Insert("Error_041", NStr("en = 'Tax table contains more than 1 row [key: %1] [tax: %2].'", Lang));
	// %1 - Name
	Strings.Insert("Error_042", NStr("en = 'Cannot find a tax by column name: %1.'", Lang));
	Strings.Insert("Error_043", NStr("en = 'Unsupported document type.'", Lang));
	Strings.Insert("Error_044", NStr("en = 'Operation is not supported.'", Lang));
	Strings.Insert("Error_045", NStr("en = 'Document is empty.'", Lang));
	// %1 - Currency
	Strings.Insert("Error_047", NStr("en = '""%1"" is a required field.'", Lang));
	Strings.Insert("Error_049", NStr("en = 'Default picture storage volume is not set.'", Lang));
	Strings.Insert("Error_050", NStr(
		"en = 'Currency exchange is available only for the same-type accounts (cash accounts or bank accounts).'",
		Lang));
	// %1 - Bank payment
	Strings.Insert("Error_051", NStr(
		"en = 'There are no lines for which you can create a ""%1"" document, or all ""%1"" documents are already created.'",
		Lang));
	// %1 - Main store
	// %2 - Use shipment confirmation
	// %3 - Shipment confirmations
	Strings.Insert("Error_052", NStr("en = 'Cannot clear the ""%2"" check box. 
									 |Documents ""%3"" from store %1 were already created.'", Lang));
	
	// %1 - Main store
	// %2 - Use goods receipt
	// %3 - Goods receipts
	Strings.Insert("Error_053", NStr(
		"en = 'Cannot clear the ""%2"" check box. Documents ""%3"" from store %1 were already created.'", Lang));
	
	// %1 - sales order
	Strings.Insert("Error_054", NStr("en = 'Cannot continue. The ""%1""document has an incorrect status.'", Lang));

	Strings.Insert("Error_055", NStr("en = 'There are no lines with a correct procurement method.'", Lang));

	// %1 - sales order
	// %2 - purchase order
	Strings.Insert("Error_056", NStr(
		"en = 'All items in the ""%1"" document are already ordered using the ""%2"" document(s).'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_057", NStr(
		"en = 'You do not need to create a ""%1"" document for the selected ""%2"" document(s).'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_058", NStr(
		"en = 'The total amount of the ""%2"" document(s) is already paid on the basis of the ""%1"" document(s).'",
		Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_059", NStr("en = 'In the selected documents, there are ""%2"" document(s) with existing ""%1"" document(s)
									 | and those that do not require a ""%1"" document.'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_060", NStr(
		"en = 'The total amount of the ""%2"" document(s) is already received on the basis of the ""%1"" document(s).'",
		Lang));
	
	// %1 - Main store
	// %2 - Shipment confirmation
	// %3 - Sales order
	Strings.Insert("Error_064", NStr(
		"en = 'You do not need to create a ""%2"" document for store(s) %1. The item will be shipped using the ""%3"" document.'",
		Lang));

	Strings.Insert("Error_065", NStr("en = 'Item key is not unique.'", Lang));
	Strings.Insert("Error_066", NStr("en = 'Specification is not unique.'", Lang));
	Strings.Insert("Error_067", NStr("en = 'Fill Users or Group tables.'", Lang));

	// %1 - 12
	// %2 - Boots
	// %3 - Red XL
	// %4 - ordered
	// %5 - 11
	// %6 - 15
	// %7 - 4
	// %8 - pcs
	Strings.Insert("Error_068", NStr(
		"en = 'Line No. [%1] [%2 %3] %4 remaining: %5 %8. Required: %6 %8. Lacking: %7 %8.'", Lang));

	// %1 - some extention name
	Strings.Insert("Error_071", NStr("en = 'Plugin ""%1"" is not connected.'", Lang));
	
	// %1 - 12
	Strings.Insert("Error_072", NStr("en = 'Specify a store in line %1.'", Lang));

	// %1 - Sales order
	// %2 - Goods receipt
	Strings.Insert("Error_073", NStr(
		"en = 'All items in the ""%1"" document(s) are already received using the ""%2"" document(s).'", Lang));
	Strings.Insert("Error_074", NStr("en = 'Currency transfer is available only when amounts are equal.'", Lang));

	// %1 - Physical count by location
	Strings.Insert("Error_075", NStr("en = 'There are ""%1"" documents that are not closed.'", Lang));
	
	// %1 - 12
	Strings.Insert("Error_077", NStr("en = 'Basis document is empty in line %1.'", Lang));
	
	// %1 - 1 %2 - 2
	Strings.Insert("Error_078", NStr("en = 'Quantity [%1] does not match the quantity [%2] by serial/lot numbers'",
		Lang));
	
	// %1 - 100.00 
	// %2 - 120.00
	Strings.Insert("Error_079", NStr("en = 'Payment amount [%1] and return amount [%2] not match'", Lang));
	
	// %1 - 1 
	// %2 - Goods receipt 
	// %3 - 10 
	// %4 - 8
	Strings.Insert("Error_080", NStr("en = 'In line %1 quantity by %2 %3 greater than %4'", Lang));
	
	// %1 - 1 
	// %2 - Dress 
	// %3 - Red/38 
	// %4 - 8 
	// %5 - 10
	Strings.Insert("Error_081", NStr("en = 'In line %1 quantity by %2-%3 %4 less than quantity by goods receipt %5'",
		Lang));
	
	// %1 - 1 
	// %2 - Dress 
	// %3 - Red/38 
	// %4 - 10 
	// %5 - 8
	Strings.Insert("Error_082", NStr("en = 'In line %1 quantity by %2-%3 %4 less than quantity by goods receipt %5'",
		Lang));
	
	// %1 - 12 
	Strings.Insert("Error_083", NStr("en = 'Location with number `%1` not found.'", Lang));
	
	// %1 - 1000
	// %2 - 300
	// %3 - 350
	// %4 - 50
	// %5 - USD
	Strings.Insert("Error_085", NStr(
		"en = 'Credit limit exceeded. Limit: %1, limit balance: %2, transaction: %3, lack: %4 %5'", Lang));
	
	// %1 - 10
	// %2 - 20	
	Strings.Insert("Error_086", NStr("en = 'Amount : %1 not match Payment term amount: %2'", Lang));

	Strings.Insert("Error_087", NStr("en = 'Parent can not be empty'", Lang));
	Strings.Insert("Error_088", NStr("en = 'Basis unit has to be filled, if item filter used.'", Lang));

	Strings.Insert("Error_089", NStr("en = 'Description%1 ""%2"" is already in use.'", Lang));
	
	// %1 - Boots
	// %2 - Red XL
	// %3 - ordered
	// %4 - 11
	// %5 - 15
	// %6 - 4
	// %7 - pcs
	Strings.Insert("Error_090", NStr("en = '[%1 %2] %3 remaining: %4 %7. Required: %5 %7. Lacking: %6 %7.'", Lang));

	Strings.Insert("Error_091", NStr("en = 'Only Administrator can create users.'", Lang));

	Strings.Insert("Error_092", NStr("en = 'Can not use %1 role in SaaS mode'", Lang));
	Strings.Insert("Error_093", NStr("en = 'Cancel reason has to be filled if string was canceled'", Lang));
	Strings.Insert("Error_094", NStr("en = 'Can not use confirmation of shipment without goods receipt'", Lang));
	
	// %1 - 100.00 
	// %2 - 120.00
	Strings.Insert("Error_095", NStr("en = 'Payment amount [%1] and sales amount [%2] not match'", Lang));
	
	// %1 - 1
	// %2 - Boots
	// %3 - Red XL
	Strings.Insert("Error_096", NStr("en = 'Can not delete linked row [%1] [%2] [%3]'", Lang));

	// %1 - 1
	// %2 - Boots
	// %3 - Red XL
	Strings.Insert("Error_097", NStr("en = 'Wrong linked row [%1] [%2] [%3]'", Lang));
	
	// %1 - 1
	// %2 - Store
	// %3 - Store 01
	// %4 - Store 02
	Strings.Insert("Error_098", NStr("en = 'Wrong linked row [%1] for column [%2] used value [%3] wrong value [%4]'", Lang));
	
	// %1 - Partner
	// %2 - Partner 01
	// %3 - Partner 02
	Strings.Insert("Error_099", NStr("en = 'Wrong linked data [%1] used value [%2] wrong value [%3]'", Lang));
	
	// %1 - Value 01
	// %2 - Value 02
	Strings.Insert("Error_100", NStr("en = 'Wrong linked data, used value [%1] wrong value [%2]'", Lang));
	
	Strings.Insert("Error_101", NStr("en = 'Select any document'", Lang));
	Strings.Insert("Error_102", NStr("en = 'Default file storage volume is not set.'", Lang));
	Strings.Insert("Error_103", NStr("en = '%1 is undefined.'", Lang));
	Strings.Insert("Error_104", NStr("en = 'Document [%1] have negative stock balance'", Lang));
	Strings.Insert("Error_105", NStr("en = 'Document [%1] already have related documents'", Lang));
#EndRegion

#Region InfoMessages
	// %1 - Purchase invoice
	// %2 - Purchase order
	Strings.Insert("InfoMessage_001", NStr("en = 'The ""%1"" document does not fully match the ""%2"" document because 
										   |there is already another ""%1"" document that partially covered this ""%2"" document.'",
		Lang));
	// %1 - Boots
	Strings.Insert("InfoMessage_002", NStr("en = 'Object %1 created.'", Lang));
	Strings.Insert("InfoMessage_003", NStr("en = 'This is a service form.'", Lang));
	Strings.Insert("InfoMessage_004", NStr("en = 'Save the object to continue.'", Lang));
	Strings.Insert("InfoMessage_005", NStr("en = 'Done'", Lang));
	
	// %1 - Physical count by location
	Strings.Insert("InfoMessage_006", NStr(
		"en = 'The ""%1"" document is already created. You can update the quantity.'", Lang));

	Strings.Insert("InfoMessage_007", NStr("en = '#%1 date: %2'", Lang));
	// %1 - 12
	// %2 - 20.02.2020
	Strings.Insert("InfoMessage_008", NStr("en = '#%1 date: %2'", Lang));

	Strings.Insert("InfoMessage_009", NStr(
		"en = 'Total quantity doesnt match. Please count one more time. You have one more try.'", Lang));
	Strings.Insert("InfoMessage_010", NStr(
		"en = 'Total quantity doesnt match. Location need to be count again (current count is annulated).'", Lang));
	Strings.Insert("InfoMessage_011", NStr("en = 'Total quantity is ok. Please scan and count next location.'", Lang));
	
	// %1 - 12
	// %2 - Vasiya Pupkin
	Strings.Insert("InfoMessage_012", NStr("en = 'Current location #%1 was started by another user. User: %2'", Lang));
	
	// %1 - 12
	Strings.Insert("InfoMessage_013", NStr(
		"en = 'Current location #%1 was linked to you. Other users will not be able to scan it.'", Lang));
	
	// %1 - 12
	Strings.Insert("InfoMessage_014", NStr(
		"en = 'Current location #%1 was scanned and closed before. Please scan next location.'", Lang));
	
	// %1 - 123456
	Strings.Insert("InfoMessage_015", NStr("en = 'Serial lot %1 was not found. Create new?'", Lang));

	// %1 - 123456
	// %2 - Some item
	Strings.Insert("InfoMessage_016", NStr("en = 'Scanned barcode %1 is using for another items %2'", Lang));
	
	// %1 - 123456
	Strings.Insert("InfoMessage_017", NStr("en = 'Scanned barcode %1 is not using set for serial numbers'", Lang));
	Strings.Insert("InfoMessage_018", NStr("en = 'Add or scan serial lot number'", Lang));

	Strings.Insert("InfoMessage_019", NStr("en = 'Data lock reasons:'", Lang));

	Strings.Insert("InfoMessage_020", NStr("en = 'Created document: %1'", Lang));
  
  	// %1 - 42
	Strings.Insert("InfoMessage_021", NStr("en = 'Can not unlock attributes, this is element used %1 times, ex.:'",
		Lang));
  	// %1 - 
	Strings.Insert("InfoMessage_022", NStr("en = 'This order is closed by %1'", Lang));
	Strings.Insert("InfoMessage_023", NStr(
		"en = 'Can not use confirmation of shipment without goods receipt. Use goods receipt mode is enabled.'", Lang));
	Strings.Insert("InfoMessage_024", NStr("en = 'Will be available after save.'", Lang));
#EndRegion

#Region QuestionToUser
	Strings.Insert("QuestionToUser_001", NStr("en = 'Write the object to continue. Continue?'", Lang));
	Strings.Insert("QuestionToUser_002", NStr("en = 'Do you want to switch to scan mode?'", Lang));
	Strings.Insert("QuestionToUser_003", NStr(
		"en = 'Filled data on cheque bonds transactions will be deleted. Do you want to update %1?'", Lang));
	Strings.Insert("QuestionToUser_004", NStr("en = 'Do you want to change tax rates according to the partner term?'",
		Lang));
	Strings.Insert("QuestionToUser_005", NStr("en = 'Do you want to update filled stores?'", Lang));
	Strings.Insert("QuestionToUser_006", NStr("en = 'Do you want to update filled currency?'", Lang));
	Strings.Insert("QuestionToUser_007", NStr("en = 'Transaction table will be cleared. Continue?'", Lang));
	Strings.Insert("QuestionToUser_008", NStr(
		"en = 'Changing the currency will clear the rows with cash transfer documents. Continue?'", Lang));
	Strings.Insert("QuestionToUser_009", NStr("en = 'Do you want to replace filled stores with store %1?'", Lang));
	Strings.Insert("QuestionToUser_011", NStr("en = 'Do you want to replace filled price types with price type %1?'",
		Lang));
	Strings.Insert("QuestionToUser_012", NStr("en = 'Do you want to exit?'", Lang));
	Strings.Insert("QuestionToUser_013", NStr("en = 'Do you want to update filled prices?'", Lang));
	Strings.Insert("QuestionToUser_014", NStr("en = 'Transaction type is changed. Do you want to update filled data?'",
		Lang));
	Strings.Insert("QuestionToUser_015", NStr("en = 'Filled data will be cleared. Continue?'", Lang));
	Strings.Insert("QuestionToUser_016", NStr("en = 'Do you want to change or clear the icon?'", Lang));
	Strings.Insert("QuestionToUser_017", NStr("en = 'How many documents to create?'", Lang));
	Strings.Insert("QuestionToUser_018", NStr("en = 'Please enter total quantity'", Lang));
	Strings.Insert("QuestionToUser_019", NStr("en = 'Do you want to update payment term?'", Lang));
	Strings.Insert("QuestionToUser_020", NStr("en = 'Do you want to overwrite saved option?'", Lang));
	Strings.Insert("QuestionToUser_021", NStr("en = 'Do you want to close this form? All changes will be lost.'", Lang));
	Strings.Insert("QuestionToUser_022", NStr("en = 'Do you want to upload this files'", Lang) + ": " + Chars.LF + "%1");
	Strings.Insert("QuestionToUser_023", NStr("en = 'Do you want to fill according to cash transfer order?'", Lang));
#EndRegion

#Region SuggestionToUser
	Strings.Insert("SuggestionToUser_1", NStr("en = 'Select a value'", Lang));
	Strings.Insert("SuggestionToUser_2", NStr("en = 'Enter a barcode'", Lang));
	Strings.Insert("SuggestionToUser_3", NStr("en = 'Enter an option name'", Lang));
	Strings.Insert("SuggestionToUser_4", NStr("en = 'Enter a new option name'", Lang));
#EndRegion

#Region UsersEvent
	Strings.Insert("UsersEvent_001", NStr("en = 'User not found by UUID %1 and name %2.'", Lang));
	Strings.Insert("UsersEvent_002", NStr("en = 'User found by UUID %1 and name %2.'", Lang));
#EndRegion

#Region Items
	
	// Interface
	Strings.Insert("I_1", NStr("en = 'Enter description'", Lang));
	Strings.Insert("I_2", NStr("en = 'Click to enter description'", Lang));
	Strings.Insert("I_3", NStr("en = 'Fill out the document'", Lang));
	Strings.Insert("I_4", NStr("en = 'Find %1 rows in table by key %2'", Lang));
	Strings.Insert("I_5", NStr("en = 'Not supported table'", Lang));
	Strings.Insert("I_6", NStr("en = 'Ordered without ISR'", Lang));

#EndRegion

#Region Exceptions
	Strings.Insert("Exc_001", NStr("en = 'Unsupported object type.'", Lang));
	Strings.Insert("Exc_002", NStr("en = 'No conditions'", Lang));
	Strings.Insert("Exc_003", NStr("en = 'Method is not implemented: %1.'", Lang));
	Strings.Insert("Exc_004", NStr("en = 'Cannot extract currency from the object.'", Lang));
	Strings.Insert("Exc_005", NStr("en = 'Library name is empty.'", Lang));
	Strings.Insert("Exc_006", NStr("en = 'Library data does not contain a version.'", Lang));
	Strings.Insert("Exc_007", NStr("en = 'Not applicable for library version %1.'", Lang));
	Strings.Insert("Exc_008", NStr("en = 'Unknown row key.'", Lang));
	Strings.Insert("Exc_009", NStr("en = 'Error: %1'", Lang));
#EndRegion

#Region Saas
	// %1 - 12
	Strings.Insert("Saas_001", NStr("en = 'Area %1 not found.'", Lang));
	
	// %1 - closed
	Strings.Insert("Saas_002", NStr("en = 'Area status: %1.'", Lang));
	
	// %1 - en
	Strings.Insert("Saas_003", NStr("en = 'Localization %1 of the company is not available.'", Lang));

	Strings.Insert("Saas_004", NStr("en = 'Area preparation completed'", Lang));
#EndRegion

#Region FillingFromClassifiers
    // Do not modify "en" strings
	Strings.Insert("Class_001", NStr("en = 'Purchase price'", Lang));
	Strings.Insert("Class_002", NStr("en = 'Sales price'", Lang));
	Strings.Insert("Class_003", NStr("en = 'Prime cost'", Lang));
	Strings.Insert("Class_004", NStr("en = 'Service'", Lang));
	Strings.Insert("Class_005", NStr("en = 'Product'", Lang));
	Strings.Insert("Class_006", NStr("en = 'Main store'", Lang));
	Strings.Insert("Class_007", NStr("en = 'Main manager'", Lang));
	Strings.Insert("Class_008", NStr("en = 'pcs'", Lang));
#EndRegion

#Region PredefinedObjectDescriptions
	PredefinedDescriptions(Strings, Lang);
#EndRegion

#Region Titles
	// %1 - Cheque bond transaction
	Strings.Insert("Title_00100", NStr("en = 'Select base documents in the ""%1"" document.'", Lang));	// Form PickUpDocuments
#EndRegion

#Region ChoiceListValues
	Strings.Insert("CLV_1", NStr("en = 'All'", Lang));
#EndRegion

#Region SalesOrderStatusReport
	Strings.Insert("SOR_1", NStr("en = 'Not enough items in free stock'", Lang));
#EndRegion

#Region Report
	Strings.Insert("R_001", NStr("en = 'Item key'", Lang) + " = ");
	Strings.Insert("R_002", NStr("en = 'Property'", Lang) + " = ");
	Strings.Insert("R_003", NStr("en = 'Item'", Lang) + " = ");
	Strings.Insert("R_004", NStr("en = 'Specification'", Lang) + " = ");
#EndRegion

	Return Strings;
EndFunction

// Predefined descriptions.
// 
// Parameters:
//  Strings - Structure - Strings
//  CodeLanguage - String - Code language
Procedure PredefinedDescriptions(Strings, CodeLanguage)
	Strings.Insert("Description_A001", NStr("en = 'Catalog Partner terms'", CodeLanguage));
	Strings.Insert("Description_A003", NStr("en = 'Catalog Business units'", CodeLanguage));
	Strings.Insert("Description_A004", NStr("en = 'Catalog Cash accounts'", CodeLanguage));
	Strings.Insert("Description_A005", NStr("en = 'Catalog Cheque bonds'", CodeLanguage));
	Strings.Insert("Description_A006", NStr("en = 'Catalog Companies'", CodeLanguage));
	Strings.Insert("Description_A007", NStr("en = 'Catalog Company types'", CodeLanguage));
	Strings.Insert("Description_A008", NStr("en = 'Catalog Countries'", CodeLanguage));
	Strings.Insert("Description_A009", NStr("en = 'Catalog Currencies'", CodeLanguage));
	Strings.Insert("Description_A010", NStr("en = 'Catalog Expense and revenue types'", CodeLanguage));
	Strings.Insert("Description_A011", NStr("en = 'Catalog Item keys'", CodeLanguage));
	Strings.Insert("Description_A012", NStr("en = 'Catalog Items'", CodeLanguage));
	Strings.Insert("Description_A013", NStr("en = 'Catalog Item types'", CodeLanguage));
	Strings.Insert("Description_A014", NStr("en = 'Catalog Partners'", CodeLanguage));
	Strings.Insert("Description_A015", NStr("en = 'Catalog Price keys'", CodeLanguage));
	Strings.Insert("Description_A016", NStr("en = 'Catalog Price types'", CodeLanguage));
	Strings.Insert("Description_A017", NStr("en = 'Catalog Serial lot numbers'", CodeLanguage));
	Strings.Insert("Description_A018", NStr("en = 'Catalog Specifications'", CodeLanguage));
	Strings.Insert("Description_A019", NStr("en = 'Catalog Stores'", CodeLanguage));
	Strings.Insert("Description_A020", NStr("en = 'Catalog Taxes'", CodeLanguage));
	Strings.Insert("Description_A021", NStr("en = 'Catalog Units'", CodeLanguage));
	Strings.Insert("Description_A022", NStr("en = 'Catalog Users'", CodeLanguage));
	Strings.Insert("Description_A023", NStr("en = 'Document Bank payment'", CodeLanguage));
	Strings.Insert("Description_A024", NStr("en = 'Document Bank receipt'", CodeLanguage));
	Strings.Insert("Description_A025", NStr("en = 'Document Bundling'", CodeLanguage));
	Strings.Insert("Description_A026", NStr("en = 'Document Cash expense'", CodeLanguage));
	Strings.Insert("Description_A027", NStr("en = 'Document Cash payment'", CodeLanguage));
	Strings.Insert("Description_A028", NStr("en = 'Document Cash receipt'", CodeLanguage));
	Strings.Insert("Description_A029", NStr("en = 'Document Cash revenue'", CodeLanguage));
	Strings.Insert("Description_A030", NStr("en = 'Document Cash transfer order'", CodeLanguage));
	Strings.Insert("Description_A031", NStr("en = 'Document Cheque bond transaction'", CodeLanguage));
	Strings.Insert("Description_A032", NStr("en = 'Document Goods receipt'", CodeLanguage));
	Strings.Insert("Description_A033", NStr("en = 'Document Incoming payment order'", CodeLanguage));
	Strings.Insert("Description_A034", NStr("en = 'Document Inventory transfer'", CodeLanguage));
	Strings.Insert("Description_A035", NStr("en = 'Document Inventory transfer order'", CodeLanguage));
	Strings.Insert("Description_A036", NStr("en = 'Document Invoice match'", CodeLanguage));
	Strings.Insert("Description_A037", NStr("en = 'Document Labeling'", CodeLanguage));
	Strings.Insert("Description_A038", NStr("en = 'Document Opening entry'", CodeLanguage));
	Strings.Insert("Description_A039", NStr("en = 'Document Outgoing payment order'", CodeLanguage));
	Strings.Insert("Description_A040", NStr("en = 'Document Physical count by location'", CodeLanguage));
	Strings.Insert("Description_A041", NStr("en = 'Document Physical inventory'", CodeLanguage));
	Strings.Insert("Description_A042", NStr("en = 'Document Price list'", CodeLanguage));
	Strings.Insert("Description_A043", NStr("en = 'Document Purchase invoice'", CodeLanguage));
	Strings.Insert("Description_A044", NStr("en = 'Document Purchase order'", CodeLanguage));
	Strings.Insert("Description_A045", NStr("en = 'Document Purchase return'", CodeLanguage));
	Strings.Insert("Description_A046", NStr("en = 'Document Purchase return order'", CodeLanguage));
	Strings.Insert("Description_A047", NStr("en = 'Document Reconciliation statement'", CodeLanguage));
	Strings.Insert("Description_A048", NStr("en = 'Document Sales invoice'", CodeLanguage));
	Strings.Insert("Description_A049", NStr("en = 'Document Sales order'", CodeLanguage));
	Strings.Insert("Description_A050", NStr("en = 'Document Sales return'", CodeLanguage));
	Strings.Insert("Description_A051", NStr("en = 'Document Sales return order'", CodeLanguage));
	Strings.Insert("Description_A052", NStr("en = 'Document Shipment confirmation'", CodeLanguage));
	Strings.Insert("Description_A053", NStr("en = 'Document Stock adjustment as surplus'", CodeLanguage));
	Strings.Insert("Description_A054", NStr("en = 'Document Stock adjustment as write off'", CodeLanguage));
	Strings.Insert("Description_A056", NStr("en = 'Document Unbundling'", CodeLanguage));
	Strings.Insert("Description_A057", NStr("en = 'User defined'", CodeLanguage));
	Strings.Insert("Description_A058", NStr("en = 'Cheque bond incoming'", CodeLanguage));
	Strings.Insert("Description_A059", NStr("en = 'Cheque bond outgoing'", CodeLanguage));
	Strings.Insert("Description_A060", NStr("en = 'Document Credit debit note'", CodeLanguage));
	Strings.Insert("Description_A061", NStr("en = 'Settlement currency'", CodeLanguage));
	Strings.Insert("Description_A062", NStr("en = 'Credit note'", CodeLanguage));
	Strings.Insert("Description_A063", NStr("en = 'Debit note'", CodeLanguage));

EndProcedure