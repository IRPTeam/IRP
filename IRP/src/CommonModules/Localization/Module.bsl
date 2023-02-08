// @strict-types

// Strings.
// 
// Parameters:
//  Lang - String - Lang
// 
// Returns:
// Structure:
//  * Class_001 - String - Purchase price
//  * Class_002 - String - Sales price
//  * Class_003 - String - Prime cost
//  * Class_004 - String - Service
//  * Class_005 - String - Product
//  * Class_006 - String - Main store
//  * Class_007 - String - Main manager
//  * Class_008 - String - pcs
//  * CLV_1 - String - All
//  * Default_001 - String - pcs
//  * Default_002 - String - Customer standard term
//  * Default_003 - String - Vendor standard term
//  * Default_004 - String - Customer price type
//  * Default_005 - String - Vendor price type
//  * Default_006 - String - Partner term currency type
//  * Default_007 - String - Legal currency type
//  * Default_008 - String - American dollar
//  * Default_009 - String - USD
//  * Default_010 - String - $
//  * Default_011 - String - My Company
//  * Default_012 - String - My Store
//  * Eq_001 - String - Installed
//  * Eq_002 - String - Not installed
//  * Eq_003 - String - There are no errors.
//  * Eq_004 - String - Scanner is connected.
//  * Eq_005 - String - Error. Scanner not connected.
//  * Eq_006 - String - Installed on current PC.
//  * Eq_007 - String - Can not connect device %1
//  * EqError_001 - String - The device is connected. The device must be disabled before the operation.
//  * EqError_002 - String - The device driver could not be downloaded. Check that the driver is correctly installed and registered in the system.
//  * EqError_003 - String - It has to be minimum one dot at Add ID.
//  * EqError_004 - String - Before install driver - it has to be loaded.
//  * EqError_005 - String - The equipment driver %1 has incorrect AddIn ID %2.
//  * Error_002 - String - %1 description is empty
//  * Error_003 - String - Fill any description.
//  * Error_004 - String - Metadata is not supported.
//  * Error_005 - String - Fill the description of an additional attribute %1.
//  * Error_008 - String - Groups are created by an administrator.
//  * Error_009 - String - Cannot write the object: [%1].
//  * Error_010 - String - Field [%1] is empty.
//  * Error_011 - String - Add at least one row.
//  * Error_012 - String - Variable is not named according to the rules.
//  * Error_013 - String - Value is not unique.
//  * Error_014 - String - Password and password confirmation do not match.
//  * Error_015 - String - Password cannot be empty.
//  * Error_016 - String - There are no more items that you need to order from suppliers in the "Sales order" document.
//  * Error_017 - String - First, create a "Goods receipt" document or clear the "Goods receipt before Purchase invoice" check box on the "Other" tab.
//  * Error_018 - String - First, create a "Shipment confirmation" document or clear the "Shipment confirmation before Sales invoice" check box on the "Other" tab.
//  * Error_019 - String - There are no lines for which you need to create a "%1" document in the "%2" document.
//  * Error_020 - String - Specify a base document for line %1.
//  * Error_021 - String - There are no products to return in the "%1" document. All products are already returned.
//  * Error_023 - String - There are no more items that you need to order from suppliers in the "Internal supply request" document.
//  * Error_028 - String - Select the "Goods receipt before Purchase invoice" check box on the "Other" tab.
//  * Error_030 - String - Specify %1 in line %2 of the %3.
//  * Error_031 - String - Items were not received from the supplier according to the procurement method.
//  * Error_032 - String - Action not completed.
//  * Error_033 - String - Duplicate attribute.
//  * Error_034 - String - %1 is not a picture storage volume.
//  * Error_035 - String - Cannot upload more than 1 file.
//  * Error_037 - String - Unsupported type of data composition comparison.
//  * Error_040 - String - Only picture files are supported.
//  * Error_041 - String - Tax table contains more than 1 row [key: %1] [tax: %2].
//  * Error_042 - String - Cannot find a tax by column name: %1.
//  * Error_043 - String - Unsupported document type.
//  * Error_044 - String - Operation is not supported.
//  * Error_045 - String - Document is empty.
//  * Error_047 - String - "%1" is a required field.
//  * Error_049 - String - Default picture storage volume is not set.
//  * Error_050 - String - Currency exchange is available only for the same-type accounts (cash accounts or bank accounts).
//  * Error_051 - String - There are no lines for which you can create a "%1" document, or all "%1" documents are already created.
//  * Error_052 - String - Cannot clear the "Use shipment confirmation" check box. Documents "Shipment confirmation" from store %1 were already created. 
//  * Error_053 - String - Cannot clear the "Use goods receipt" check box. Documents "Goods receipt" from store %1 were already created.
//  * Error_054 - String - Cannot continue. The "%1"document has an incorrect status.
//  * Error_055 - String - There are no lines with a correct procurement method.
//  * Error_056 - String - All items in the "Sales order" document are already ordered using the "Purchase order" document(s).
//  * Error_057 - String - You do not need to create a "%1" document for the selected "Cash transfer order" document(s).
//  * Error_058 - String - The total amount of the "Cash transfer order" document(s) is already paid on the basis of the "%1" document(s).
//  * Error_059 - String - In the selected documents, there are "Cash transfer order" document(s) with existing "%1" document(s) and those that do not require a "%1" document.
//  * Error_060 - String - The total amount of the "Cash transfer order" document(s) is already received on the basis of the "%1" document(s).
//  * Error_064 - String - You do not need to create a "Shipment confirmation" document for store(s) %1. The item will be shipped using the "Sales order" document.
//  * Error_065 - String - Item key is not unique.
//  * Error_066 - String - Specification is not unique.
//  * Error_067 - String - Fill Users or Group tables.
//  * Error_068 - String - Line No. [%1] [%2 %3] %4 remaining: %5 %8. Required: %6 %8. Lacking: %7 %8.
//  * Error_068_2 - String - Line No. [%1] [%2 %3] Serial lot number [%4] %5 remaining: %6 %9. Required: %7 %9. Lacking: %8 %9.
//  * Error_071 - String - Plugin "%1" is not connected.
//  * Error_072 - String - Specify a store in line %1.
//  * Error_073 - String - All items in the "%1" document(s) are already received using the "%2" document(s).
//  * Error_074 - String - Currency transfer is available only when amounts are equal.
//  * Error_075 - String - There are "Physical count by location" documents that are not closed.
//  * Error_077 - String - Basis document is empty in line %1.
//  * Error_078 - String - Quantity [%1] does not match the quantity [%2] by serial/lot numbers
//  * Error_079 - String - Payment amount [%1] and return amount [%2] not match
//  * Error_080 - String - In line %1 quantity by %2 %3 greater than %4
//  * Error_081 - String - In line %1 quantity by %2-%3 %4 less than quantity by goods receipt %5
//  * Error_082 - String - In line %1 quantity by %2-%3 %4 less than quantity by goods receipt %5
//  * Error_083 - String - Location with number `%1` not found.
//  * Error_085 - String - Credit limit exceeded. Limit: %1, limit balance: %2, transaction: %3, lack: %4 %5
//  * Error_086 - String - Amount : %1 not match Payment term amount: %2
//  * Error_087 - String - Parent can not be empty
//  * Error_088 - String - Basis unit has to be filled, if item filter used.
//  * Error_089 - String - Description%1 "%2" is already in use.
//  * Error_090 - String - [%1 %2] %3 remaining: %4 %7. Required: %5 %7. Lacking: %6 %7.
//  * Error_090_2 - String - [%1 %2] Serial lot number [%3] %4 remaining: %5 %8. Required: %6 %8. Lacking: %7 %8.
//  * Error_091 - String - Only Administrator can create users.
//  * Error_092 - String - Can not use %1 role in SaaS mode
//  * Error_093 - String - Cancel reason has to be filled if string was canceled
//  * Error_094 - String - Can not use confirmation of shipment without goods receipt
//  * Error_095 - String - Payment amount [%1] and sales amount [%2] not match
//  * Error_096 - String - Can not delete linked row [%1] [%2] [%3]
//  * Error_097 - String - Wrong linked row [%1] [%2] [%3]
//  * Error_098 - String - Wrong linked row [%1] for column [%2] used value [%3] wrong value [%4]
//  * Error_099 - String - Wrong linked data [%1] used value [%2] wrong value [%3]
//  * Error_100 - String - Wrong linked data, used value [%1] wrong value [%2]
//  * Error_101 - String - Select any document
//  * Error_102 - String - Default file storage volume is not set.
//  * Error_103 - String - %1 is undefined.
//  * Error_104 - String - Document [%1] have negative stock balance
//  * Error_105 - String - Document [%1] already have related documents
//  * Error_106 - String - Can not lock data
//  * Error_107 - String - You try to call deleted service %1.
//  * Error_108 - String - Field is filled, but it has to be empty.
//  * Error_109 - String - 
//  * Error_110 - String - 
//  * Error_111 - String -
//  * Exc_001 - String - Unsupported object type.
//  * Exc_002 - String - No conditions
//  * Exc_003 - String - Method is not implemented: %1.
//  * Exc_004 - String - Cannot extract currency from the object.
//  * Exc_005 - String - Library name is empty.
//  * Exc_006 - String - Library data does not contain a version.
//  * Exc_007 - String - Not applicable for library version %1.
//  * Exc_008 - String - Unknown row key.
//  * Exc_009 - String - Error: %1
//  * Form_001 - String - New page
//  * Form_002 - String - Delete
//  * Form_003 - String - Quantity
//  * Form_004 - String - Customers terms
//  * Form_005 - String - Customers
//  * Form_006 - String - Vendors
//  * Form_007 - String - Vendors terms
//  * Form_008 - String - User
//  * Form_009 - String - User group
//  * Form_013 - String - Date
//  * Form_014 - String - Number
//  * Form_017 - String - Change
//  * Form_018 - String - Clear
//  * Form_019 - String - Cancel
//  * Form_022 - String - 1. By item keys
//  * Form_023 - String - 2. By properties
//  * Form_024 - String - 3. By items
//  * Form_025 - String - Create from classifier
//  * Form_026 - String - Item Bundle
//  * Form_027 - String - Item
//  * Form_028 - String - Item type
//  * Form_029 - String - External attributes
//  * Form_030 - String - Dimensions
//  * Form_031 - String - Weight information
//  * Form_032 - String - Period
//  * Form_033 - String - Show all
//  * Form_034 - String - Hide all
//  * Form_035 - String - Head
//  * I_1 - String - Enter description
//  * I_2 - String - Click to enter description
//  * I_3 - String - Fill out the document
//  * I_4 - String - Find %1 rows in table by key %2
//  * I_5 - String - Not supported table
//  * I_6 - String - Ordered without ISR
//  * InfoMessage_001 - String - The "%1" document does not fully match the "%2" document because there is already another "%1" document that partially covered this "%2" document.
//  * InfoMessage_002 - String - Object %1 created.
//  * InfoMessage_003 - String - This is a service form.
//  * InfoMessage_004 - String - Save the object to continue.
//  * InfoMessage_005 - String - Done
//  * InfoMessage_006 - String - The "Physical count by location" document is already created. You can update the quantity.
//  * InfoMessage_007 - String - #%1 date: %2
//  * InfoMessage_008 - String - #%1 date: %2
//  * InfoMessage_009 - String - Total quantity doesnt match. Please count one more time. You have one more try.
//  * InfoMessage_010 - String - Total quantity doesnt match. Location need to be count again (current count is annulated).
//  * InfoMessage_011 - String - Total quantity is ok. Please scan and count next location.
//  * InfoMessage_012 - String - Current location #%1 was started by another user. User: %2
//  * InfoMessage_013 - String - Current location #%1 was linked to you. Other users will not be able to scan it.
//  * InfoMessage_014 - String - Current location #%1 was scanned and closed before. Please scan next location.
//  * InfoMessage_015 - String - Serial lot %1 was not found. Create new?
//  * InfoMessage_016 - String - Scanned barcode %1 is using for another items %2
//  * InfoMessage_017 - String - Scanned barcode %1 is not using set for serial numbers
//  * InfoMessage_018 - String - Add or scan serial lot number
//  * InfoMessage_019 - String - Data lock reasons:
//  * InfoMessage_020 - String - Created document: %1
//  * InfoMessage_021 - String - Can not unlock attributes, this is element used %1 times, ex.:
//  * InfoMessage_022 - String - This order is closed by %1
//  * InfoMessage_023 - String - Can not use confirmation of shipment without goods receipt. Use goods receipt mode is enabled.
//  * InfoMessage_024 - String - Will be available after save.
//  * InfoMessage_025 - String - Before start to scan - choose location
//  * InfoMessage_026 - String - Can not count Service item type
//  * InfoMessage_027 - String - Barcode [%1] is exists for item: %2 [%3] %4
//  * InfoMessage_028 - String -
//  * InfoMessage_029 - String -  
//  * POS_s1 - String - Amount paid is less than amount of the document
//  * POS_s2 - String - Card fees are more than the amount of the document
//  * POS_s3 - String - There is no need to use cash, as card payments are sufficient to pay
//  * POS_s4 - String - Amounts of payments are incorrect
//  * POS_s5 - String - Select sales person
//  * QuestionToUser_001 - String - Write the object to continue. Continue?
//  * QuestionToUser_002 - String - Do you want to switch to scan mode?
//  * QuestionToUser_003 - String - Filled data on cheque bonds transactions will be deleted. Do you want to update %1?
//  * QuestionToUser_004 - String - Do you want to change tax rates according to the partner term?
//  * QuestionToUser_005 - String - Do you want to update filled stores?
//  * QuestionToUser_006 - String - Do you want to update filled currency?
//  * QuestionToUser_007 - String - Transaction table will be cleared. Continue?
//  * QuestionToUser_008 - String - Changing the currency will clear the rows with cash transfer documents. Continue?
//  * QuestionToUser_009 - String - Do you want to replace filled stores with store %1?
//  * QuestionToUser_011 - String - Do you want to replace filled price types with price type %1?
//  * QuestionToUser_012 - String - Do you want to exit?
//  * QuestionToUser_013 - String - Do you want to update filled prices?
//  * QuestionToUser_014 - String - Transaction type is changed. Do you want to update filled data?
//  * QuestionToUser_015 - String - Filled data will be cleared. Continue?
//  * QuestionToUser_016 - String - Do you want to change or clear the icon?
//  * QuestionToUser_017 - String - How many documents to create?
//  * QuestionToUser_018 - String - Please enter total quantity
//  * QuestionToUser_019 - String - Do you want to update payment term?
//  * QuestionToUser_020 - String - Do you want to overwrite saved option?
//  * QuestionToUser_021 - String - Do you want to close this form? All changes will be lost.
//  * QuestionToUser_022 - String - Do you want to upload this files: %1
//  * QuestionToUser_023 - String - Do you want to fill according to cash transfer order?
//  * R_001 - String - Item key = 
//  * R_002 - String - Property = 
//  * R_003 - String - Item = 
//  * R_004 - String - Specification = 
//  * S_002 - String - Cannot connect to %1:%2. Details: %3
//  * S_003 - String - Received response from %1:%2
//  * S_004 - String - Resource address is empty.
//  * S_005 - String - Integration setting with name %1 is not found.
//  * S_006 - String - Method is not supported in Web Client.
//  * S_013 - String - Unsupported object type: %1.
//  * S_014 - String - File name is empty.
//  * S_015 - String - Path for saving is not set.
//  * S_016 - String - %1 Status code: %2 %3
//  * S_018 - String - Item added.
//  * S_019 - String - Barcode %1 not found.
//  * S_022 - String - Currencies in the base documents must match.
//  * S_023 - String - Procurement method
//  * S_026 - String - Selected icon will be resized to 16x16 px.
//  * S_027 - String - [Not filled]
//  * S_028 - String - Success
//  * S_029 - String - Not supporting web client
//  * S_030 - String - Cashback
//  * S_031 - String - or
//  * S_032 - String - Add code, ex: CurrentSessionDate()
//  * Saas_001 - String - Area %1 not found.
//  * Saas_002 - String - Area status: %1.
//  * Saas_003 - String - Localization %1 of the company is not available.
//  * Saas_004 - String - Area preparation completed
//  * SOR_1 - String - Not enough items in free stock
//  * SuggestionToUser_1 - String - Select a value
//  * SuggestionToUser_2 - String - Enter a barcode
//  * SuggestionToUser_3 - String - Enter an option name
//  * SuggestionToUser_4 - String - Enter a new option name
//  * Title_00100 - String - Select base documents in the "%1" document.
//  * UsersEvent_001 - String - User not found by UUID %1 and name %2.
//  * UsersEvent_002 - String - User found by UUID %1 and name %2.
//	* Str_Catalog - String - Catalog
//	* Str_Catalogs - String - Catalogs
//	* Str_Document - String - Document
//	* Str_Documents - String - Documents
Function Strings(Lang) Export

	Strings = New Structure();

#Region Equipment
	Strings.Insert("Eq_001", NStr("en='Installed';
		|ru='Установлен';
		|tr='Kuruldu'", Lang));
	Strings.Insert("Eq_002", NStr("en='Not installed';
		|ru='Не установлен';
		|tr='Kurulmadı'", Lang));
	Strings.Insert("Eq_003", NStr("en='There are no errors.';
		|ru='Ошибок нет.';
		|tr='Bir hata tespit edilemedi.'", Lang));
	Strings.Insert("Eq_004", NStr("en='%1 connected.';
		|ru='%1 успешно присоединен.';
		|tr='%1 başarıyla bağlandı.'", Lang));
	Strings.Insert("Eq_005", NStr("en='%1 NOT connected.';
		|ru='%1 НЕ присоединен.';
		|tr='%1 bağlanamadı.'", Lang));
	Strings.Insert("Eq_006", NStr("en='Installed on current PC.';
		|ru='Установить на текущий компьютер';
		|tr='Bu bilgisayara kurulmuştu.'", Lang));
	Strings.Insert("Eq_007", NStr("en='Can not connect device %1';
		|ru='Не получилось подключить оборудование %1';
		|tr='Cihaz bağlanamadı %1'", Lang));
	Strings.Insert("Eq_008", NStr("en='%1 disconnected.'", Lang));
	Strings.Insert("Eq_009", NStr("en='%1 NOT disconnected.'", Lang));
	Strings.Insert("Eq_010", NStr("en='Can not disconnect device %1'", Lang));
	Strings.Insert("Eq_011", NStr("en='Already connected'", Lang));
	Strings.Insert("Eq_012", NStr("en='Already disconnected'", Lang));
	
	Strings.Insert("EqError_001", NStr("en='The device is connected. The device must be disabled before the operation.';
		|ru='Устройство подключено. Устройство должно быть отключено перед началом работы.';
		|tr='Cihaz bağlandı. İşlemden önce cihaz devre dışı bırakılmalı.'", Lang));

	Strings.Insert("EqError_002", NStr("en='The device driver could not be downloaded.
		|Check that the driver is correctly installed and registered in the system.';
		|ru='Драйвер устройства не может быть загружен. 
		|Проверьте, что драйвер правильно установлен и зарегистрирован в системе.';
		|tr='Cihaz sürücüsü yüklenemedi.
		|Sürücünün düzgün kurulduğundan ve sistemde kayıtlı (registered) olduğundan emin olunuz.'",
		Lang));

	Strings.Insert("EqError_003", NStr("en='It has to be minimum one dot at Add ID.';
		|ru='Необходимо иметь минимум одну точку в доп. ID.';
		|tr='Ek ID''de minimum bir nokta olmalıdır.'", Lang));
	Strings.Insert("EqError_004", NStr("en='Before install driver - it has to be loaded.';
		|ru='Перед тем как установить драйвер, он должен быть загружен.';
		|tr='Sürücü yükemeden öncesi indirmek lazım.'", Lang));
	Strings.Insert("EqError_005", NStr("en='The equipment driver %1 has incorrect AddIn ID %2.';
		|ru='У драйвера оборудования %1 неправильный AddIn ID %2.';
		|tr='Donanım %1 sürücüsü yanlış AddIn ID %2 bilgisine sahiptir.'", Lang));
	
	Strings.Insert("EqFP_ShiftAlreadyOpened", NStr("en='Shift already opened.';
		|ru='Смена уже открыта.';
		|tr='Vardya artık açılmış.'", Lang));
	Strings.Insert("EqFP_ShiftIsNotOpened", NStr("en='Shift is not opened.';
		|ru='Смена не открыта.';
		|tr='Vardya açılmamıştı.'", Lang));
	Strings.Insert("EqFP_ShiftAlreadyClosed", NStr("en='Shift already closed.';
		|ru='Смена уже закрыта.';
		|tr='Vardya kapanmıştı.'", Lang));
	Strings.Insert("EqFP_DocumentAlreadyPrinted", NStr("en='The document is already printed.';
		|ru='Документ уже пробит';
		|tr='Evrak önceden yazdırılmıştı'", Lang));
	
	Strings.Insert("EqAc_AlreadyhasTransaction", NStr("en='The document is already has transaction code. Transaction already was done. Else clear RRN code.'", Lang));
	
#EndRegion

#Region POS

	Strings.Insert("POS_s1", NStr("en='Amount paid is less than amount of the document';
		|ru='Сумма оплаты меньше суммы документа';
		|tr='Ödeme tutarı satış tutarından daha küçüktür'", Lang));
	Strings.Insert("POS_s2", NStr("en='Card fees are more than the amount of the document';
		|ru='Сумма оплат по безналичному расчету больше суммы документа';
		|tr='Kart ile ödeme tutarı satış tutarından daha büyüktür'", Lang));
	Strings.Insert("POS_s3", NStr("en='There is no need to use cash, as card payments are sufficient to pay';
		|ru='Суммы по безналичному расчету для оплаты достаточно. Нет необходимости дополнительно использовать наличный расчет. ';
		|tr='Nakit tutar girmenize gerek yok, çünkü kart ile alınan ödeme yeterlidir'", Lang));
	Strings.Insert("POS_s4", NStr("en='Amounts of payments are incorrect';
		|ru='Суммы оплат некорректны';
		|tr='Ödeme tutarlarda hata var'", Lang));
	Strings.Insert("POS_s5", NStr("en='Select sales person';
		|ru='Выбрать продавца';
		|tr='Satış elemanı seç'", Lang));
	Strings.Insert("POS_s6", NStr("en='Clear all Items before closing POS'", Lang));
	
	Strings.Insert("POS_Error_ErrorOnClosePayment", NStr("en='Cancel all payment before close form.'", Lang));
	Strings.Insert("POS_Error_ErrorOnPayment", NStr("en='There some problem to do payment with %1. Retry?'", Lang));
	Strings.Insert("POS_Error_CancelPayment", NStr("en='Operation with %1 by amount: %2 will be canceled.'", Lang));
	Strings.Insert("POS_Error_CancelPaymentProblem", NStr("en='Cancle payment problem [%1: %2]. Payment not canceled.
		|Copy message and send it to administrator'", Lang));
	Strings.Insert("POS_Error_ReturnAmountLess", NStr("en='There are %2 of ""%1"", which is more than the available %3 for return in document ""%4"" .'", Lang));
	
#EndRegion

#Region Service
	
	// %1 - localhost
	// %2 - 8080 
	// %3 - There is no internet connection
	Strings.Insert("S_002", NStr("en='Cannot connect to %1:%2. Details: %3';
		|ru='Не получается подключиться к %1:%2. Подробности: %3.';
		|tr='%1:%2 ile bağlantı kurulamıyor. Ayrıntılar:%3'", Lang));
	
	// %1 - localhost
	// %2 - 8080
	Strings.Insert("S_003", NStr("en='Received response from %1:%2';
		|ru='Полученный ответ от %1:%2';
		|tr='%1:%2 tarafından yanıt alındı'", Lang));
	Strings.Insert("S_004", NStr("en='Resource address is empty.';
		|ru='Адрес ресурса не заполнен.';
		|tr='Kaynak adresi boş.'", Lang));
	
	// %1 - connection_to_other_system
	Strings.Insert("S_005", NStr("en='Integration setting with name %1 is not found.';
		|ru='Настройки интеграции с наименованием %1 не найдены.';
		|tr='%1 adıyla entegrasyon ayarı bulunamadı.'", Lang));
	Strings.Insert("S_006", NStr("en='Method is not supported in Web Client.';
		|ru='В web клиенте метод не поддерживается.';
		|tr='Yöntem Web İstemcisinde desteklenmiyor'", Lang));
	
	// Special offers
	Strings.Insert("S_013", NStr("en='Unsupported object type: %1.';
		|ru='Неподдерживаемый тип объекта: %1.';
		|tr='Desteklenmeyen nesne türü: %1.'", Lang));
	
	// FileTransfer
	Strings.Insert("S_014", NStr("en='File name is empty.';
		|ru='Имя файла не заполнено';
		|tr='Dosya adı boş.'", Lang));
	Strings.Insert("S_015", NStr("en='Path for saving is not set.';
		|ru='Путь сохранения не установлен.';
		|tr='Kaydetme yolu belirlenmemiş.'", Lang));
	
	// Test connection
	// %1 - Method unsupported on web client
	// %2 - 404
	// %3 - Text frim site
	Strings.Insert("S_016", NStr("en='%1 Status code: %2 %3';
		|ru='%1 Статус код: %2 %3';
		|tr='%1 Durum kodu: %2 %3'", Lang));
	
	//	scan barcode
	Strings.Insert("S_018", NStr("en='Item added.';
		|ru='Номенклатура добавлена.';
		|tr='Malzeme eklendi.'", Lang)); 
	
	// %1 - 123123123123
	Strings.Insert("S_019", NStr("en='Barcode %1 not found.';
		|ru='Штрихкод %1 не найден.';
		|tr='%1 barkodu bulunamadı.'", Lang));
	Strings.Insert("S_022", NStr("en='Currencies in the base documents must match.';
		|ru='Валюты в документах-основания должны совпадать.';
		|tr='Ana belgelerdeki para birimleri eşleşmelidir.'", Lang));
	Strings.Insert("S_023", NStr("en='Procurement method';
		|ru='Метод обеспечения';
		|tr='Tedarik şekli'", Lang));

	Strings.Insert("S_026", NStr("en='Selected icon will be resized to 16x16 px.';
		|ru='Размер выбранной иконки будет изменен до 16x16 px.';
		|tr='Seçilen simge 16x16 piksel olarak yeniden boyutlandırılacaktır.'", Lang));

	// presentation of empty value for query result
	Strings.Insert("S_027", NStr("en='[Not filled]';
		|ru='[не заполнено]';
		|tr='[ Doldurulmamış ]'", Lang));
	// operation is Success
	Strings.Insert("S_028", NStr("en='Success';
		|ru='Успешно';
		|tr='Başarılı'", Lang));
	Strings.Insert("S_029", NStr("en='Not supporting web client';
		|ru='Не поддерживаемый wreb клиент';
		|tr='Desteklenmeyen web istemci'", Lang));
	Strings.Insert("S_030", NStr("en='Cashback';
		|ru='Сдача';
		|tr='Para üstü'", Lang));
	Strings.Insert("S_031", NStr("en='or';
		|ru='или';
		|tr='veya'", Lang));
	Strings.Insert("S_032", NStr("en='Add code, ex: CurrentSessionDate()';
		|ru='Добавить код, например: ТекущаяДатаСеанса ()';
		|tr='Kod ekle, örneğin: CurrentSessionDate()'", Lang));
#EndRegion

#Region Service
	Strings.Insert("Form_001", NStr("en='New page';
		|ru='Новая страница';
		|tr='Yeni sayfa'", Lang));
	Strings.Insert("Form_002", NStr("en='Delete';
		|ru='Пометить на удаление/Снять пометку';
		|tr='Kaldır'", Lang));
	Strings.Insert("Form_003", NStr("en='Quantity';
		|ru='Количество';
		|tr='Miktar'", Lang));
	Strings.Insert("Form_004", NStr("en='Customers terms';
		|ru='Соглашения с клиентами';
		|tr='Müşteri anlaşmaları'", Lang));
	Strings.Insert("Form_005", NStr("en='Customers';
		|ru='Клиенты';
		|tr='Müşteriler'", Lang));
	Strings.Insert("Form_006", NStr("en='Vendors';
		|ru='Поставщики';
		|tr='Tedarikçiler'", Lang));
	Strings.Insert("Form_007", NStr("en='Vendors terms';
		|ru='Соглашения с поставщиками';
		|tr='Tedarikçi anlaşması'", Lang));
	Strings.Insert("Form_008", NStr("en='User';
		|ru='Пользователь';
		|tr='Kullanıcı'", Lang));
	Strings.Insert("Form_009", NStr("en='User group';
		|ru='Группа пользователей';
		|tr='Kullanıcı grubu'", Lang));
	Strings.Insert("Form_013", NStr("en='Date';
		|ru='Дата';
		|tr='Tarih'", Lang));
	Strings.Insert("Form_014", NStr("en='Number';
		|ru='Номер';
		|tr='Numara'", Lang));
	
	// change icon
	Strings.Insert("Form_017", NStr("en='Change';
		|ru='Изменить';
		|tr='Değiştir'", Lang));
	
	// clear icon
	Strings.Insert("Form_018", NStr("en='Clear';
		|ru='Очистить';
		|tr='Temizle'", Lang));
	
	// cancel answer on question
	Strings.Insert("Form_019", NStr("en='Cancel';
		|ru='Отмена';
		|tr='İptal'", Lang));
	
	// PriceInfo report 
	Strings.Insert("Form_022", NStr("en='1. By item keys';
		|ru='1. По характеристике номенклатуры';
		|tr='1. Varyantlara göre'", Lang));
	Strings.Insert("Form_023", NStr("en='2. By properties';
		|ru='2. По свойствам';
		|tr='2. Özelliklere göre'", Lang));
	Strings.Insert("Form_024", NStr("en='3. By items';
		|ru='3. По номенклатуре';
		|tr='3. Malzemelere göre'", Lang));

	Strings.Insert("Form_025", NStr("en='Create from classifier';
		|ru='Создать по классификатору';
		|tr='Sınıflandırıcıdan oluştur'", Lang));

	Strings.Insert("Form_026", NStr("en='Item Bundle';
		|ru='Номенклатура набора';
		|tr='Malzeme Paketi'", Lang));
	Strings.Insert("Form_027", NStr("en='Item';
		|ru='Номенклатура';
		|tr='Malzeme'", Lang));
	Strings.Insert("Form_028", NStr("en='Item type';
		|ru='Вид номенклатуры';
		|tr='Malzeme tipi'", Lang));
	Strings.Insert("Form_029", NStr("en='External attributes';
		|ru='Внешние реквизиты';
		|tr='Dış özellikler'", Lang));
	Strings.Insert("Form_030", NStr("en='Dimensions';
		|ru='Измерения';
		|tr='Boyutlar'", Lang));
	Strings.Insert("Form_031", NStr("en='Weight information';
		|ru='Информация о весе';
		|tr='Ağırlık bilgisi'", Lang));
	Strings.Insert("Form_032", NStr("en='Period';
		|ru='Период';
		|tr='Dönem'", Lang));
	Strings.Insert("Form_033", NStr("en='Show all';
		|ru='Показать все';
		|tr='Tümü göster'", Lang));
	Strings.Insert("Form_034", NStr("en='Hide all';
		|ru='Скрыть все';
		|tr='Tümü sakla'", Lang));
	Strings.Insert("Form_035", NStr("en='Head';
		|ru='Шапка';
		|tr='Başlık'", Lang));
	Strings.Insert("Form_036", NStr("en='Set as default';
		|ru='Установить как основной';
		|tr='Varsayılan olarak işaretle'", Lang));
	Strings.Insert("Form_037", NStr("en='Unset as default';
		|ru='Убрать как основной';
		|tr='Varsayılan olarak kaldır'", Lang));
	Strings.Insert("Form_038", NStr("en='Employee'", Lang));
#EndRegion

#Region ErrorMessages

	// %1 - en
	Strings.Insert("Error_002", NStr("en='%1 description is empty';
		|ru='%1 наименование не заполнено';
		|tr='%1 açıklaması boş'", Lang));
	Strings.Insert("Error_003", NStr("en='Fill any description.';
		|ru='Заполните наименование.';
		|tr='Herhangi bir açıklama girininiz.'", Lang));
	Strings.Insert("Error_004", NStr("en='Metadata is not supported.';
		|ru='Метаданные не поддерживаются.';
		|tr='Meta veriler desteklenmiyor.'", Lang));
	
	// %1 - en
	Strings.Insert("Error_005", NStr("en='Fill the description of an additional attribute %1.';
		|ru='Заполните наименование дополнительного реквизита %1.';
		|tr='Ek bir %1 özniteliğinin açıklamasını doldurunuz.'", Lang));
	Strings.Insert("Error_008", NStr("en='Groups are created by an administrator.';
		|ru='Группы создаются администратором.';
		|tr='Gruplar bir yönetici tarafından oluşturulur.'", Lang));
	
	// %1 - Number 111 is not unique
	Strings.Insert("Error_009", NStr("en='Cannot write the object: [%1].';
		|ru='Ошибка при записи объекта: [%1].';
		|tr='Nesne yazılamıyor: [%1].'", Lang));
	
	// %1 - Number
	Strings.Insert("Error_010", NStr("en='Field [%1] is empty.';
		|ru='Поле [%1] не заполнено.';
		|tr='[%1] alanı boş.'", Lang));
	Strings.Insert("Error_011", NStr("en='Add at least one row.';
		|ru='Нужно добавить хоть одну строку.';
		|tr='En az bir satır ekleyin.'", Lang));
	Strings.Insert("Error_012", NStr("en='Variable is not named according to the rules.';
		|ru='Переменная названа не в соответствии с правилами.';
		|tr='Değişken, kurallara göre adlandırılmaz.'", Lang));
	Strings.Insert("Error_013", NStr("en='Value is not unique.';
		|ru='Значение не уникально.';
		|tr='Değer benzersiz değil.'", Lang));
	Strings.Insert("Error_014", NStr("en='Password and password confirmation do not match.';
		|ru='Пароль и подтверждение пароля не совпадают.';
		|tr='Parola ve parola onayı eşleşmiyor.'", Lang));
	Strings.Insert("Error_015", NStr("en='Password cannot be empty.';
		|ru='Пароль не может быть пустым.';
		|tr='Şifre boş olamaz'", Lang));

	// %1 - Sales order
	Strings.Insert("Error_016", NStr("en='There are no more items that you need to order from suppliers in the ""%1"" document.';
		|ru='В документе ""%1"" не осталось товаров по которым необходимо сделать заказ поставщику.';
		|tr='""%1"" belgesinde tedarikçilerden sipariş etmeniz gereken başka ürün yok.'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_017", NStr("en='First, create a ""%1"" document or clear the ""%1 before %2"" check box on the ""Other"" tab.';
		|ru='Вначале необходимо создать документ ""%1"" или снять галочку ""%1 перед документом %2"" на вкладке ""Дополнительно"".';
		|tr='İlk olarak, bir ""%1"" belgesi oluşturun veya ""Diğer"" sekmesindeki ""%1 %2''den önce"" onay kutusunu temizleyin.'", Lang));

	// %1 - Shipment confirmation
	// %1 - Sales invoice
	Strings.Insert("Error_018", NStr("en='First, create a ""%1"" document or clear the ""%1 before %2"" check box on the ""Other"" tab.';
		|ru='Вначале необходимо создать документ ""%1"" или снять галочку ""%1 перед документом %2"" на вкладке ""Дополнительно"".';
		|tr='İlk olarak, bir ""%1"" belgesi oluşturun veya ""Diğer"" sekmesindeki ""%1 %2''den önce"" onay kutusunu temizleyin.'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_019", NStr("en='There are no lines for which you need to create a ""%1"" document in the ""%2"" document.';
		|ru='Строки по которым необходимо создать документ ""%1"" отсутствуют в документе ""%2"".';
		|tr='""%2"" belgesinde ""%1"" belgesi oluşturmanız gereken satır yok.'", Lang));

	// %1 - 12
	Strings.Insert("Error_020", NStr("en='Specify a base document for line %1.';
		|ru='Необходимо заполнить документ-основания по строке %1.';
		|tr='%1 satırı için bir ana belge belirtin.'", Lang));

	// %1 - Purchase invoice
	Strings.Insert("Error_021", NStr("en='There are no products to return in the ""%1"" document. All products are already returned.';
		|ru='По всем товарам из выбранного документа ""%1"" уже был оформлен возврат.';
		|tr='""%1"" belgesinde iade edilecek ürün yok. Tüm ürünler zaten iade edildi.'", Lang));

	// %1 - Internal supply request
	Strings.Insert("Error_023", NStr("en='There are no more items that you need to order from suppliers in the ""%1"" document.';
		|ru='В документе ""%1"" не осталось товаров по которым необходимо сделать заказ поставщику.';
		|tr='""%1"" belgesinde tedarikçilerden sipariş etmeniz gereken başka ürün yok.'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_028", NStr("en='Select the ""%1 before %2"" check box on the ""Other"" tab.';
		|ru='Необходимо установить галочку ""%1 перед документом %2"" на вкладке ""Дополнительно"".';
		|tr='""Diğer"" sekmesinde ""%2''den %1 önce"" onay kutusunu seçin.'", Lang));
	
	// %1 - Cash account
	// %2 - 12
	// %3 - Cheque bonds
	Strings.Insert("Error_030", NStr("en='Specify %1 in line %2 of the %3.';
		|ru='Поле %1 обязателено для заполнения в строке %2 %3.';
		|tr='%3''ün %2 satırında %1 belirtin.'", Lang));

	Strings.Insert("Error_031", NStr("en='Items were not received from the supplier according to the procurement method.';
		|ru='Заказанные товары у поставщика для обеспечения заказа не были получены.';
		|tr='Tedarik yöntemine göre malzemeler tedarikçiden alınmadı.'", Lang));
	Strings.Insert("Error_032", NStr("en='Action not completed.';
		|ru='Действие не завершено.';
		|tr='Eylem tamamlanmadı.'", Lang));
	Strings.Insert("Error_033", NStr("en='Duplicate attribute.';
		|ru='Реквизит дублируется.';
		|tr='Yinelenen özellik.'", Lang));
	// %1 - Google drive
	Strings.Insert("Error_034", NStr("en='%1 is not a picture storage volume.';
		|ru='%1 не является томом для хранения изображений.';
		|tr='%1 bir resim depolama birimi değil.'", Lang));
	Strings.Insert("Error_035", NStr("en='Cannot upload more than 1 file.';
		|ru='Невозможно загрузить более 1 файла.';
		|tr='1''den fazla dosya yüklenemez.'", Lang));
	Strings.Insert("Error_037", NStr("en='Unsupported type of data composition comparison.';
		|ru='Неподдерживаемый тип сравнения состава данных.';
		|tr='Desteklenmeyen veri bileşimi karşılaştırması türü.'", Lang));
	Strings.Insert("Error_040", NStr("en='Only picture files are supported.';
		|ru='Поддерживается только тип файла - картинка.';
		|tr='Yalnızca resim dosyaları desteklenir.'", Lang));
	Strings.Insert("Error_041", NStr("en='Tax table contains more than 1 row [key: %1] [tax: %2].';
		|ru='Таблица налогов содержит больше 1 строки [ключ: %1] [налог: %2].';
		|tr='Vergi tablosu 1''den fazla satır içeriyor [anahtar: %1] [vergi: %2].'", Lang));
	// %1 - Name
	Strings.Insert("Error_042", NStr("en='Cannot find a tax by column name: %1.';
		|ru='Не найден налог по наименованию колонки: %1.';
		|tr='Sütun adına göre bir vergi bulunamıyor: %1.'", Lang));
	Strings.Insert("Error_043", NStr("en='Unsupported document type.';
		|ru='Неподдерживаемый тип документа.';
		|tr='Desteklenmeyen belge türü.'", Lang));
	Strings.Insert("Error_044", NStr("en='Operation is not supported.';
		|ru='Недопустимая операция.';
		|tr='İşlem desteklenmiyor.'", Lang));
	Strings.Insert("Error_045", NStr("en='Document is empty.';
		|ru='Документ не заполнен.';
		|tr='Belge boş.'", Lang));
	// %1 - Currency
	Strings.Insert("Error_047", NStr("en='""%1"" is a required field.';
		|ru='Поле ""%1"" обязательное для заполнения.';
		|tr='""%1"" zorunlu bir alandır.'", Lang));
	Strings.Insert("Error_049", NStr("en='Default picture storage volume is not set.';
		|ru='Том хранения файлов по умолчанию не заполнен.';
		|tr='Varsayılan resim saklama hacmi ayarlanmamıştır.'", Lang));
	Strings.Insert("Error_050", NStr("en='Currency exchange is available only for the same-type accounts (cash accounts or bank accounts).';
		|ru='Обмен валюты возможен только между счетами одного типа (между двумя кассами или между двумя банковскими счетами).';
		|tr='Döviz değişimi yalnızca aynı türdeki hesaplar için (kasa hesapları veya banka hesapları) kullanılabilir.'",
		Lang));
	// %1 - Bank payment
	Strings.Insert("Error_051", NStr("en='There are no lines for which you can create a ""%1"" document, or all ""%1"" documents are already created.';
		|ru='Отсутствуют строки по которым необходимо создать ""%1"" или же все документы ""%1"" уже были созданы ранее.';
		|tr='Kendisi için bir ""%1"" belgesi oluşturabileceğiniz satır yok veya tüm ""%1"" belgeleri zaten oluşturulmuş.'",
		Lang));
	// %1 - Main store
	// %2 - Use shipment confirmation
	// %3 - Shipment confirmations
	Strings.Insert("Error_052", NStr("en='Cannot clear the ""%2"" check box. 
		|Documents ""%3"" from store %1 were already created.';
		|ru='Снять галочку ""%2"" невозможно. 
		|Ранее со склада %1 уже были созданы документы ""%3"".';
		|tr='""%2"" onay kutusu temizlenemiyor.
		|%1 mağazasından ""%3"" belgeleri zaten oluşturulmuş.'", Lang));
	
	// %1 - Main store
	// %2 - Use goods receipt
	// %3 - Goods receipts
	Strings.Insert("Error_053", NStr("en='Cannot clear the ""%2"" check box. Documents ""%3"" from store %1 were already created.';
		|ru='Невозможно снять галочку ""%2"". Ранее со склада %1 уже были созданы документы ""%3"".';
		|tr='""%2"" onay kutusu temizlenemiyor. %1 mağazasından ""%3"" belgeleri zaten oluşturulmuş.'", Lang));
	
	// %1 - sales order
	Strings.Insert("Error_054", NStr("en='Cannot continue. The ""%1""document has an incorrect status.';
		|ru='Невозможно продолжить. Статус документа ""%1"" для продолжения неверный.';
		|tr='Devam edilemez. ""%1"" belgesinin durumu yanlış.'", Lang));

	Strings.Insert("Error_055", NStr("en='There are no lines with a correct procurement method.';
		|ru='Отсутствуют строки с нужным способом обеспечения.';
		|tr='Doğru tedarik yöntemine sahip hatlar yoktur.'", Lang));

	// %1 - sales order
	// %2 - purchase order
	Strings.Insert("Error_056", NStr("en='All items in the ""%1"" document are already ordered using the ""%2"" document(s).';
		|ru='Все товары в документе ""%1"" уже заказаны документом ""%2"".';
		|tr='""%1"" belgesindeki tüm öğeler ""%2"" belgeleri kullanılarak zaten sıralanmıştır.'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_057", NStr("en='You do not need to create a ""%1"" document for the selected ""%2"" document(s).';
		|ru='Для выбранного документа ""%1"" не нужно создавать документ ""%2"".';
		|tr='Seçili ""%2"" dokümanlar için ""%1"" doküman oluşturmanıza gerek yoktur.'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_058", NStr("en='The total amount of the ""%2"" document(s) is already paid on the basis of the ""%1"" document(s).';
		|ru='Вся сумма по документу ""%2"" уже была выдана по документу ""%1"".';
		|tr='""%2"" belgelerinin toplam tutarı, ""%1"" belgeleri temelinde zaten ödendi.'",
		Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_059", NStr("en='In the selected documents, there are ""%2"" document(s) with existing ""%1"" document(s)
		| and those that do not require a ""%1"" document.';
		|ru='В списке выбранных документов ""%2"" есть те по которым уже был создан документ ""%1""
		| и те по которым документ ""%1"" создавать не нужно.';
		|tr='Seçilen belgelerde, mevcut ""%1"" belgelerine sahip ""%2"" belgeler var
		|  ve ""%1"" belgesi gerektirmeyenler.'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_060", NStr("en='The total amount of the ""%2"" document(s) is already received on the basis of the ""%1"" document(s).';
		|ru='Вся сумма по документу ""%2"" уже была получена по документу ""%1"".';
		|tr='""%2"" belgelerinin toplam miktarı, ""%1"" belgeleri temelinde zaten alındı.'",
		Lang));
	
	// %1 - Main store
	// %2 - Shipment confirmation
	// %3 - Sales order
	Strings.Insert("Error_064", NStr("en='You do not need to create a ""%2"" document for store(s) %1. The item will be shipped using the ""%3"" document.';
		|ru='Для склада %1 нет необходимости создавать документ ""%2"". Товар будет отгружен по документу ""%3"".';
		|tr='%1 mağazaları için ""%2"" belgesi oluşturmanıza gerek yok. Ürün, ""%3"" belgesi kullanılarak gönderilecek.'",
		Lang));

	Strings.Insert("Error_065", NStr("en='Item key is not unique.';
		|ru='Характеристика не уникальна.';
		|tr='Varyant benzersiz değil.'", Lang));
	Strings.Insert("Error_066", NStr("en='Specification is not unique.';
		|ru='Спецификация товара не уникальна.';
		|tr='Spesifikasyon benzersiz değil.'", Lang));
	Strings.Insert("Error_067", NStr("en='Fill Users or Group tables.';
		|ru='Для таблиц пользователей или групп пользователей';
		|tr='Kullanıcı ve Grup tabloları doldur'", Lang));

	// %1 - 12
	// %2 - Boots
	// %3 - Red XL
	// %4 - ordered
	// %5 - 11
	// %6 - 15
	// %7 - 4
	// %8 - pcs
	Strings.Insert("Error_068", NStr("en='Line No. [%1] [%2 %3] %4 remaining: %5 %8. Required: %6 %8. Lacking: %7 %8.';
		|ru='Строка № [%1] [%2%3] %4 остаток: %5%8 Требуется: %6%8 Разница: %7%8.';
		|tr='Satır No. [%1] [%2 %3] %4aldı: %5 %8. Gerekli: %6 %8. Eksik: %7 %8.'", Lang));

	// %1 - 12
	// %2 - Boots
	// %3 - Red XL
	// %4 - 00001
	// %5 - ordered
	// %6 - 11
	// %7 - 15
	// %8 - 4
	// %9 - pcs
	Strings.Insert("Error_068_2", NStr("en='Line No. [%1] [%2 %3] Serial lot number [%4] %5 remaining: %6 %9. Required: %7 %9. Lacking: %8 %9.';
		|ru='Номер строки [%1] [%2 %3] Серийный номер [%4] %5 остаток: %6 %9. Требуется: %7 %9. Недостача: %8 %9.';
		|tr='Satır numarası [%1] [%2 %3] Seri lot numarası [%4] %5 kalan: %6 %9. İhtiyaç duyulan: %7 %9. Eksik: %8 %9.'", Lang));

	// %1 - some extention name
	Strings.Insert("Error_071", NStr("en='Plugin ""%1"" is not connected.';
		|ru='Внешняя обработка ""%1"" не подключена.';
		|tr='""%1"" eklentisi bağlı değil.'", Lang));
	
	// %1 - 12
	Strings.Insert("Error_072", NStr("en='Specify a store in line %1.';
		|ru='В строке %1 необходимо заполнить склад.';
		|tr='%1 satırında bir mağaza belirtin.'", Lang));

	// %1 - Sales order
	// %2 - Goods receipt
	Strings.Insert("Error_073", NStr("en='All items in the ""%1"" document(s) are already received using the ""%2"" document(s).';
		|ru='Все товары по документу ""%1"" уже получены на основании документа ""%2"".';
		|tr='""%1"" belgelerindeki tüm öğeler, ""%2"" belgeleri kullanılarak zaten alındı.'", Lang));
	Strings.Insert("Error_074", NStr("en='Currency transfer is available only when amounts are equal.';
		|ru='При перемещении денежных средств в одной валюте сумма отправки и получения должны совпадать.';
		|tr='Para birimi transferi yalnızca tutarlar eşit olduğunda kullanılabilir.'", Lang));

	// %1 - Physical count by location
	Strings.Insert("Error_075", NStr("en='There are ""%1"" documents that are not closed.';
		|ru='Есть незакрытые документы ""%1"".';
		|tr='Kapatılmamış ""%1"" dokümanlar var.'", Lang));
	
	// %1 - 12
	Strings.Insert("Error_077", NStr("en='Basis document is empty in line %1.';
		|ru='Не заполнен документ основания в строке %1';
		|tr='Ana belge %1 satırında boş.'", Lang));
	
	// %1 - 1 %2 - 2
	Strings.Insert("Error_078", NStr("en='Quantity [%1] does not match the quantity [%2] by serial/lot numbers';
		|ru='Количество [%1] по строке не совпадает с количеством [%2] заполненным по серийным номерам. ';
		|tr='Girilen [%1] adet, seri lotuna ait [%2] adedinden farklıdır'",
		Lang));
	
	// %1 - 100.00 
	// %2 - 120.00
	Strings.Insert("Error_079", NStr("en='Payment amount [%1] and return amount [%2] not match';
		|ru='Сумма оплаты [%1] и сумма возврата [%2] не сходятся';
		|tr='Ödeme tutar ([%1]) iade tutarından ([%2]) farklıdır'", Lang));
	
	// %1 - 1 
	// %2 - Goods receipt 
	// %3 - 10 
	// %4 - 8
	Strings.Insert("Error_080", NStr("en='In line %1 quantity by %2 %3 greater than %4';
		|ru='В строке %1 количество %2 %3 больше чем %4';
		|tr='%1 satırında %2 %3 adet %4 adedinden daha büyük'", Lang));
	
	// %1 - 1 
	// %2 - Dress 
	// %3 - Red/38 
	// %4 - 8 
	// %5 - 10
	Strings.Insert("Error_081", NStr("en='In line %1 quantity by %2-%3 %4 less than quantity %5';
		|ru='В строке %1 количество товара %2-%3 %4 меньше чем количество %5';
		|tr='%1 satırda %2-%3 %4 miktarı %5 miktarından daha küçüktür'",
		Lang));
	
	// %1 - 1 
	// %2 - Dress 
	// %3 - Red/38 
	// %4 - 10 
	// %5 - 8
	Strings.Insert("Error_082", NStr("en='In line %1 quantity by %2-%3 %4 less than quantity %5';
		|ru='В строке %1 количество товара %2-%3 %4 меньше чем количество %5';
		|tr='%1 satırda %2-%3 %4 miktarı %5 miktarından daha küçüktür'",
		Lang));
	
	// %1 - 12 
	Strings.Insert("Error_083", NStr("en='Location with number `%1` not found.';
		|ru='Локация с номером %1 не найдена.';
		|tr='`%1` nolu lokasyon bulunamadı'", Lang));
	
	// %1 - 1000
	// %2 - 300
	// %3 - 350
	// %4 - 50
	// %5 - USD
	Strings.Insert("Error_085", NStr("en='Credit limit exceeded. Limit: %1, limit balance: %2, transaction: %3, lack: %4 %5';
		|ru='Превышение лимита взаиморасчетов. Лимит: %1, остаток взаиморасчетов: %2, транзакция: %3, не хватающая сумма: %4 %5';
		|tr='Borç limiti aşıldı. Limit: %1, limit bakiyesi: %2, işlem: %3, yetersiz tutar: %4 %5'", Lang));
	
	// %1 - 10
	// %2 - 20	
	Strings.Insert("Error_086", NStr("en='Amount : %1 not match Payment term amount: %2';
		|ru='Сумма (%1) не сходится с условиями оплата (%2)';
		|tr='%1 tutarı, ödeme toplamı %2 ile tutmuyor'", Lang));

	Strings.Insert("Error_087", NStr("en='Parent can not be empty';
		|ru='Родитель не может быть пустым';
		|tr='Üst öğe boş olamaz'", Lang));
	Strings.Insert("Error_088", NStr("en='Basis unit has to be filled, if item filter used.';
		|ru='Если устанавливается фильтр по номенклатуре, основная единица измерения должны быть заполнена.';
		|tr='Malzemeye göre filtre uygulandığı takdirse, ana birimi doldurmak lazım.'", Lang));

	Strings.Insert("Error_089", NStr("en='Description%1 ""%2"" is already in use.';
		|ru='Наименование(%1) ""%2"" уже используется.';
		|tr='%1 ""%2"" tanımı mevcuttur.'", Lang));
	
	// %1 - Boots
	// %2 - Red XL
	// %3 - ordered
	// %4 - 11
	// %5 - 15
	// %6 - 4
	// %7 - pcs
	Strings.Insert("Error_090", NStr("en='[%1 %2] %3 remaining: %4 %7. Required: %5 %7. Lacking: %6 %7.';
		|ru='[%1 %2] %3 остаток: %4 %7. Требуется: %5 %7. Не хватает: %6 %7.';
		|tr='[%1 %2] %3 kalan: %4 %7. İhtiyaç: %5 %7. Eksik: %6 %7.'", Lang));

	// %1 - Boots
	// %2 - Red XL
	// %3 - 0001
	// %3 - ordered
	// %4 - 11
	// %5 - 15
	// %6 - 4
	// %7 - pcs
	Strings.Insert("Error_090_2", NStr("en='[%1 %2] Serial lot number [%3] %4 remaining: %5 %6. Required: %6 %8. Lacking: %7 %8.';
		|ru='[%1 %2] серийный номер [%3] %4 остаток: %5 %6. Требуется: %6 %8. Недостаток: %7 %8.';
		|tr='[%1 %2] Seri lot numarası [%3] %4 kalan: %5 %6. İhtiyaç duyulan: %6 %8. Eksik: %7 %8.'", Lang));

	Strings.Insert("Error_091", NStr("en='Only Administrator can create users.';
		|ru='Только Администраторы могут создавать пользователей';
		|tr='Sadece sistem yöneticiler kullanıcıları oluşturabilir.'", Lang));

	Strings.Insert("Error_092", NStr("en='Can not use %1 role in SaaS mode';
		|ru='Роль %1 нельзя использовать в Saas режиме';
		|tr='%1 rolü SaaS modunda kullanılamaz'", Lang));
	Strings.Insert("Error_093", NStr("en='Cancel reason has to be filled if string was canceled';
		|ru='Если строка отменена, необходимо указать причину отмены';
		|tr='Satır iptal olduğunda iptal sebebi doldurulmalıdır'", Lang));
	Strings.Insert("Error_094", NStr("en='Can not use confirmation of shipment without goods receipt';
		|ru='Нельзя вводить расходную накладную, без приходной накладной по данному виду отгрузки';
		|tr='Satın alma irsaliyesi olmadan sevk irsaliyesi oluşturulamaz'", Lang));
	
	// %1 - 100.00 
	// %2 - 120.00
	Strings.Insert("Error_095", NStr("en='Payment amount [%1] and sales amount [%2] not match';
		|ru='Сумма оплаты [%1] не равна сумме продажи [%2] ';
		|tr='[%1] ödeme tutarı [%2] satış tutarına eşit değil'", Lang));
	
	// %1 - 1
	// %2 - Boots
	// %3 - Red XL
	Strings.Insert("Error_096", NStr("en='Can not delete linked row [%1] [%2] [%3]';
		|ru='Невозможно удалить залинкованную строку [%1] [%2] [%3]';
		|tr='Bağlantı sağlanmış satır silinemez [%1] [%2] [%3]'", Lang));

	// %1 - 1
	// %2 - Boots
	// %3 - Red XL
	Strings.Insert("Error_097", NStr("en='Wrong linked row [%1] [%2] [%3]';
		|ru='Неверно залинкованна строка  [%1] [%2] [%3]';
		|tr='Yanlış bağlantı sağlanan satır [%1] [%2] [%3]'", Lang));
	
	// %1 - 1
	// %2 - Store
	// %3 - Store 01
	// %4 - Store 02
	Strings.Insert("Error_098", NStr("en='Wrong linked row [%1] for column [%2] used value [%3] wrong value [%4]';
		|ru='Неверно залинкованна строка [%1] для столбца [%2] использованное значение [%3] неправильное значение [%4]';
		|tr='Satır bağlatma hatası [%1] kolon [%2] kullanılan değer [%3] yanlış değer [%4]'", Lang));
	
	// %1 - Partner
	// %2 - Partner 01
	// %3 - Partner 02
	Strings.Insert("Error_099", NStr("en='Wrong linked data [%1] used value [%2] wrong value [%3]';
		|ru='Неверно залинкованны данные [%1] используемое значение [%2] неправильное значение [%3]';
		|tr='Yanlış bağlantı verisi [%1] kullanılan değer [%2] yanlış değer [%3]'", Lang));
	
	// %1 - Value 01
	// %2 - Value 02
	Strings.Insert("Error_100", NStr("en='Wrong linked data, used value [%1] wrong value [%2]';
		|ru='Неверно залинкованны данные, используемое значение [%1] неправильное значение [%2]';
		|tr='Yanlış bağlantı verisi, kullanılan değer [%1] yanlış değer [%2]'", Lang));
	
	Strings.Insert("Error_101", NStr("en='Select any document';
		|ru='Необходимо выбрать документ';
		|tr='Evrakı seçiniz'", Lang));
	Strings.Insert("Error_102", NStr("en='Default file storage volume is not set.';
		|ru='Не указан том хранения файлов.';
		|tr='Varsayılan dosya depolama yeri seçilmedi.'", Lang));
	Strings.Insert("Error_103", NStr("en='%1 is undefined.';
		|ru='%1 неопределен.';
		|tr='%1 tanımlı değil.'", Lang));
	Strings.Insert("Error_104", NStr("en='Document [%1] have negative stock balance';
		|ru='По документу [%1] есть отрицательный остаток на складе';
		|tr='[%1] evrakı eksi stok bakiyesine düştü'", Lang));
	Strings.Insert("Error_105", NStr("en='Document [%1] already have related documents';
		|ru='У документа [%1] уже есть связанные документы';
		|tr='[%1] evrakın bağlı evraklar mevcuttur'", Lang));
	Strings.Insert("Error_106", NStr("en='Can not lock data';
		|ru='Заблокировать данные не получилось';
		|tr='Veri kilitlenemedi'", Lang));
	Strings.Insert("Error_107", NStr("en='You try to call deleted service %1.';
		|ru='Попытка вызвать сервис %1, который помеченн на удаление.';
		|tr='Silmek için işaretlenen %1 servisi çağırıldı.'", Lang));
	Strings.Insert("Error_108", NStr("en='Field is filled, but it has to be empty.';
		|ru='Поле заполнено, но оно должно быть пустым';
		|tr='Alan dolduruldu, fakat alanın boş olması gerekmtektedir.'", Lang));
	Strings.Insert("Error_109", NStr("en='Serial lot number name [ %1 ] is not match template: %2';
		|ru='Наименование серийного номера [ %1 ] не соответствует шаблону: %2';
		|tr='Seri lot numara tanımı [ %1 ] şablona uymamaktadır, şablon: %2'", Lang) + Chars.LF);
	Strings.Insert("Error_110", NStr("en='Current serial lot number already has movements, it can not disable stock detail option';
		|ru='Данный серийный номер уже имеет движения, нельзя отменять признак';
		|tr='Bu seri lot numarasının hareketleti var, bu yüzden stok takip belirtisi değiştirilemez'", Lang) + Chars.LF);
	Strings.Insert("Error_111", NStr("en='Period is empty [%1] : [%2]';
		|ru='Период не заполнен [%1] : [%2]';
		|tr='Dönem boştur [%1] : [%2]'", Lang) + Chars.LF);
	Strings.Insert("Error_112", NStr("en='Not set ledger type by company [%1]';
		|ru='Не указан тип учета у организации [%1]';
		|tr='Şirket ayarlarında defter tipi belirtilmemiş [%1]'", Lang));
	Strings.Insert("Error_113", NStr("en='Serial lot number [ %1 ] has to be unique at the document';
		|ru='Серийный номер [ %1 ] должен быть уникальным в документе';
		|tr='Evrakta [ %1 ] seri lot numarası eşsiz olmalıdır'", Lang) + Chars.LF);
	Strings.Insert("Error_114", NStr("en='""Landed cost"" is a required field.';
		|ru='""Себестоимость"" это обязательное поле для заполнения';
		|tr='""Maliyet tutarı"" zorunlu alan'", Lang) + Chars.LF);
	Strings.Insert("Error_115", NStr("en='Error while test connection';
		|ru='Ошибка при тестировании соединения';
		|tr='Bağlantı test hatası'", Lang) + Chars.LF);
	Strings.Insert("Error_116", NStr("en='Cannot unpost, document is closed by [ %1 ]';
		|ru='Отказ отмены проведения, документ закрыт документом [%1]';
		|tr='Kaydetme iptal edilemedi, evrak [%1] tarafından kapanmıştı'", Lang) + Chars.LF);
	Strings.Insert("Error_117", NStr("en='Sales return when sales by different dates not support';
		|ru='Не поддерживается возврат датой отличной от даты продажи';
		|tr='Başka güne ait iadeler desteklenmemektedir'", Lang) + Chars.LF);
	Strings.Insert("Error_118", NStr("en='Cannot set deletion mark, document is closed by [ %1 ]';
		|ru='Документ не может быть помечен на удаление, так как закрыт документом [%1]';
		|tr='Silmek için işaretleme başarısız, bu evrak [%1] evrakı tarafından kapatılmıştı'", Lang) + Chars.LF);
	Strings.Insert("Error_119", NStr("en='Error Eval code';
		|ru='Ошибка кода Выполнить';
		|tr='EVAL kod hatası'", Lang) + Chars.LF);
	Strings.Insert("Error_120", NStr("en='Consignor batch shortage Item key: %1 Store: %2 Required:%3 Remaining:%4 Lack:%5';
		|ru='Нехватка партии комитента, номенклатура: %1, склад: %2. Требуется:%3 Остаток:%4 Не хватает:%5';
		|tr='Konsinye parti eksiği, Varyant: %1 Depo: %2 Gerekiyor:%3 Kalan:%4 Eksik:%5'", Lang) + Chars.LF);
	Strings.Insert("Error_121", NStr("en='Goods received from consignor cannot be shipped to trade agent';
		|ru='Товары полученные от комитента не могут быть отправлены комиссионеру';
		|tr='Konsinye olarak alınan mallar, konsinye olarak verilemez'", Lang) + Chars.LF);
	Strings.Insert("Error_122", NStr("en='Error. Find recursive basis by RowID: %1. Basis list:';
		|ru='Ошибка. Найдено замкнутый цикл по ID стрки: %1. Список документов основания:';
		|tr='Hata. Satır ID kaynak evraklarında sonsuz döngü bulundu: %1. Kaynak evrak listesi:'", Lang) + Chars.LF);
	Strings.Insert("Error_123", NStr("en='Error. Retail customer is not filled';
		|ru='Ошибка. Не заполнен розничный покупатель';
		|tr='Hata. Perakende müşteri boştur'", Lang) + Chars.LF);
	
	// manufacturing errors
	Strings.Insert("MF_Error_001", NStr("en='Repetitive materials [%1]';
		|ru='Повторяющееся сырье [%1]';
		|tr='Tekrarlanan hammadde [%1]'", Lang));
	Strings.Insert("MF_Error_002", NStr("en='Looped semiproduct [%1]';
		|ru='Рекурсивный полуфабрикат [%1]';
		|tr='İlmik olmuş yarı mamul: [%1]'", Lang));
	Strings.Insert("MF_Error_003", NStr("en='Planning by [%1] [%2] [%3] alredy exists';
		|ru='Планирование  [%1] [%2] [%3] уже существует';
		|tr='[%1] [%2] [%3] planlama mevcuttur'", Lang));
	Strings.Insert("MF_Error_004", NStr("en='Document date [%1] less than Planning date [%2]';
		|ru='Дата документ %1 меньше даты планирования %2';
		|tr='Evrak [%1] tarihi planlama [%2] tarihinden daha küçüktür'", Lang));
	Strings.Insert("MF_Error_005", NStr("en='Document date [%1] less than last Planning correction date [%2]';
		|ru='%1 дата документа меньше даты корректировки планирования %2';
		|tr='Evrak [%1] tarihi son planlama düzeltme [%2] tarihinden daha küçüktür'", Lang));
	Strings.Insert("MF_Error_006", NStr("en='Start date [%1] greater than End date [%2]';
		|ru='Дата начала [%1] больше даты окончания [%2]';
		|tr='[%1] başlangıç tarihi [%2] son tarihinden daha büyüktür'", Lang));
	Strings.Insert("MF_Error_007", NStr("en='Start date [%1] intersect Period [%2]';
		|ru='Дата окончания [%1] пересекается с периодом [%2]';
		|tr='[%1] ilk tarih [%2] dönemi ile çakışıyor'", Lang));
	Strings.Insert("MF_Error_008", NStr("en='End date [%1] intersect Period [%2]';
		|ru='Дата начала %1 пересекается с периодом %2';
		|tr='[%1] son tarih [%2] dönemi ile çakışıyor'", Lang));
	Strings.Insert("MF_Error_009", NStr("en='Planning closing by [%1] [%2] [%3] alredy exists';
		|ru='Документ планирования уже существует: [%1] [%2] [%3]';
		|tr='Üretim planlama mevcuttur [%1] [%2] [%3]'", Lang));
	Strings.Insert("MF_Error_010", NStr("en='Select any production planing';
		|ru='Выбрать любое планирование производства';
		|tr='Herhangi bir üretim planlamayı seçin'", Lang));
	
	// Errors matching attributes of basis and related documents
	Strings.Insert("Error_ChangeAttribute_RelatedDocsExist", NStr("en='Cannot change %1 if related documents exist';
		|ru='Нельзя изменить %1 если есть связанные документы';
		|tr='Bağlı evrak varsa, %1 değiştirilemez'", Lang));
	Strings.Insert("Error_AttributeDontMatchValueFromBasisDoc", NStr("en='%1 must be [%2] (according to %3)';
		|ru='%1 должен быть [%2] (по %3)';
		|tr='%1 olmalı [%2] (buna göre: %3)'", Lang));
	Strings.Insert("Error_AttributeDontMatchValueFromBasisDoc_Row", NStr("en='%1 must be [%2] (according to %3) in row [%4]';
		|ru='%1 должен быть [%2] (по %3) в строке [%4]';
		|tr='%1 olmalı [%2] (buna göre %3) satırda [%4]'", Lang));
	
	// Store does not match company
	Strings.Insert("Error_Store_Company", NStr("en='Store [%1] does not match company [%2]';
		|ru='Склад [%1] не соответствует организации [%2]';
		|tr='[%1] deposu [%2] şirketine uygun değil'", Lang));
	Strings.Insert("Error_Store_Company_Row", NStr("en='Store [%1] in row [%3] does not match company [%2]';
		|ru='Склад [%1] в строке [%3] не соответствует организации [%2]';
		|tr='[%3] satırdaki [%1] depo [%2] şirketine uygun değil'", Lang));
	
#EndRegion

#Region LandedCost

	Strings.Insert("LC_Error_001", NStr("en='Can not receipt Batch key by sales return: %1 , Quantity: %2 , Doc: %3';
		|ru='Не получилось оприходовать ключ партии возврата: %1 , Количество: %2 , Документ: %3';
		|tr='Satış iadenin envanter giriş hatası. İade: %1 , Miktar: %2 , Evrak: %3'", Lang) + Chars.LF);
	Strings.Insert("LC_Error_002", NStr("en='Can not expense Batch key: %1 , Quantity: %2 , Doc: %3';
		|ru='Не получилос списать ключ партии: %1 , Количество: %2 , Документ: %3';
		|tr='Envanter çıkış hatası. Parti anahtarı: %1 , Miktar: %2 , Evrak: %3'", Lang) + Chars.LF);
	Strings.Insert("LC_Error_003", NStr("en='Can not receipt Batch key: %1 , Quantity: %2 , Doc: %3';
		|ru='Не получилось оприходовать ключ партии: %1 , Количество: %2 , Документ: %3';
		|tr='Envanter giriş hatası. Parti anahtarı: %1 , Miktar: %2 , Evrak: %3'", Lang) + Chars.LF);
#EndRegion

#Region InfoMessages
	// %1 - Purchase invoice
	// %2 - Purchase order
	Strings.Insert("InfoMessage_001", NStr("en='The ""%1"" document does not fully match the ""%2"" document because 
		|there is already another ""%1"" document that partially covered this ""%2"" document.';
		|ru='Созданный документ ""%1"" не совпадает с документом ""%2"" в силу того, что ранее
		| уже создан документ ""%1"", который частично закрыл документ ""%2"".';
		|tr='""%1"" belgesi, ""%2"" belgesiyle tam olarak eşleşmiyor çünkü
		|zaten bu ""%2"" belgesini kısmen kapsayan başka bir ""%1"" belgesi var.'",
		Lang));
	// %1 - Boots
	Strings.Insert("InfoMessage_002", NStr("en='Object %1 created.';
		|ru='Объект %1 создан.';
		|tr='%1 nesnesi oluşturuldu.'", Lang));
	Strings.Insert("InfoMessage_003", NStr("en='This is a service form.';
		|ru='Это сервисная форма.';
		|tr='Bu bir hizmet formudur.'", Lang));
	Strings.Insert("InfoMessage_004", NStr("en='Save the object to continue.';
		|ru='Для продолжения необходимо сохранить объект.';
		|tr='Devam etmek için nesneyi kaydedin.'", Lang));
	Strings.Insert("InfoMessage_005", NStr("en='Done';
		|ru='Завершено';
		|tr='Tamamlandı'", Lang));
	
	// %1 - Physical count by location
	Strings.Insert("InfoMessage_006", NStr("en='The ""%1"" document is already created. You can update the quantity.';
		|ru='Документы ""%1"" уже созданы. Возможно использовать только функцию обновления количества.';
		|tr='""%1"" belgesi zaten oluşturulmuş. Miktarı güncelleyebilirsiniz.'", Lang));

	Strings.Insert("InfoMessage_007", NStr("en='#%1 date: %2';
		|ru='#%1 дата: %2';
		|tr='#%1 tarih: %2'", Lang));
	// %1 - 12
	// %2 - 20.02.2020
	Strings.Insert("InfoMessage_008", NStr("en='#%1 date: %2';
		|ru='#%1 дата: %2';
		|tr='#%1 tarih: %2'", Lang));

	Strings.Insert("InfoMessage_009", NStr("en='Total quantity doesnt match. Please count one more time. You have one more try.';
		|ru='Общее количество не сходится. Введите еще раз. Осталась последняя попытка.';
		|tr='Girilen ve sayılan toplam adet tutmadı. Lütfen bir daha sayın. Bir deneme daha var.'", Lang));
	Strings.Insert("InfoMessage_010", NStr("en='Total quantity doesnt match. Location need to be count again (current count is annulated).';
		|ru='Общее количество не совпадает. Локацию необходимо отсканировать заново (текущие данные очищены).';
		|tr='Toplam miktar tutmuyor. Lokasyon tekrar okutulmalı (okutulan veri silinmişti).'", Lang));
	Strings.Insert("InfoMessage_011", NStr("en='Total quantity is ok. Please scan and count next location.';
		|ru='Общее количество правильное. Можно начать работу со следующей локацией.';
		|tr='Mevcut lokasyon ile ilgili girilen ve sayılan adet tuttu. Lütfen bir sonraki lokasyonu okutun.'", Lang));
	
	// %1 - 12
	// %2 - Vasiya Pupkin
	Strings.Insert("InfoMessage_012", NStr("en='Current location #%1 was started by another user. User: %2';
		|ru='Сканирование текущей локации %1 было начато другим пользователем. Пользователь: %2';
		|tr='Bu lokasyon (#%1) başka kullanıcı tarafından başlatıldı. Kullanıcı: %2'", Lang));
	
	// %1 - 12
	Strings.Insert("InfoMessage_013", NStr("en='Current location #%1 was linked to you. Other users will not be able to scan it.';
		|ru='Текущая локация %1 закреплена за вами. Другие пользователи не смогут с ней работать.';
		|tr='#%1 lokasyon size atanmıştır. Diğer kullanıcılar bu lokasyonu okutamazlar.'", Lang));
	
	// %1 - 12
	Strings.Insert("InfoMessage_014", NStr("en='Current location #%1 was scanned and closed before. Please scan next location.';
		|ru='Текущая локация (%1) уже была отсканирована и закрыта. Пожалуйста, отсканируйте следующую локацию .';
		|tr='Bu %1 lokasyon daha önce okutulmuş ve kapatılmıştı. Bir sonraki lokasyon okutunuz.'", Lang));
	
	// %1 - 123456
	Strings.Insert("InfoMessage_015", NStr("en='Serial lot %1 was not found. Create new?';
		|ru='Серийный номер %1 не найдет. Создать новый?';
		|tr='%1 seri numarası bulunamadı. Yeni oluşturmak ister misiniz?'", Lang));

	// %1 - 123456
	// %2 - Some item
	Strings.Insert("InfoMessage_016", NStr("en='Scanned barcode %1 is using for another items %2';
		|ru='Отсканированный штрихкод %1 уже используется для номенклатуры %2';
		|tr='Okutulan %1 barkod, başka malzeme (%2) için tanımlıdır.'", Lang));
	
	// %1 - 123456
	Strings.Insert("InfoMessage_017", NStr("en='Scanned barcode %1 is not using set for serial numbers';
		|ru='Отсканированный штрихкод %1 не используется для серийных номеров';
		|tr='Okutulan %1 barkod seri lot numara seti kullanmıyor'", Lang));
	Strings.Insert("InfoMessage_018", NStr("en='Add or scan serial lot number';
		|ru='Добавьте серию или считайте штрихкод серии';
		|tr='Seri seçin veya barkodu okutun'", Lang));

	Strings.Insert("InfoMessage_019", NStr("en='Data lock reasons:';
		|ru='Причина запрета:';
		|tr='Veri değiştirme kısıtlama sebebi:'", Lang));

	Strings.Insert("InfoMessage_020", NStr("en='Created document: %1';
		|ru='Создан документ: %1';
		|tr='Evrak oluştur: %1'", Lang));
  
  	// %1 - 42
	Strings.Insert("InfoMessage_021", NStr("en='Can not unlock attributes, this is element used %1 times, ex.:';
		|ru='Невозможно разблокировать реквизиты, данный элемент использовался %1 раз, например:';
		|tr='Alan kilidi kaldırılamaz, nesne %1 kez kullanıldı, örneğin:'",
		Lang));
  	// %1 - 
	Strings.Insert("InfoMessage_022", NStr("en='This order is closed by %1';
		|ru='Этот заказ уже закрыт документом %1';
		|tr='Bu sipariş %1 ile kapatılmıştı.'", Lang));
	Strings.Insert("InfoMessage_023", NStr("en='Can not use confirmation of shipment without goods receipt. Use goods receipt mode is enabled.';
		|ru='Нельзя вводить расходную накладную, без приходной накладной по данному виду отгрузки. Включено использование приходной накладной.';
		|tr='Satın alma irsaliyesi olmadan sevk irsaliyesi oluşturulamaz. Satın alma irsaliye devrede.'", Lang));
	Strings.Insert("InfoMessage_024", NStr("en='Will be available after save.';
		|ru='Доступен к изменению после записи объекта.';
		|tr='Kaydettikten sonra ulaşılabilir olacak'", Lang));
	Strings.Insert("InfoMessage_025", NStr("en='Before start to scan - choose location';
		|ru='Перед началом сканирования необходимо выбрать локацию';
		|tr='Barkod okutmadan önce lokasyon seçmek gerekir'", Lang));
	Strings.Insert("InfoMessage_026", NStr("en='Can not add Service item type: %1';
		|ru='Товар с типом сервис не добавлен: %1';
		|tr='Hizmet malzeme tipi eklenemez: %1'", Lang));
	// %1 - 123123123
	// %2 - Item name
	// %3 - Item key
	// %4 - Serial lot number
	Strings.Insert("InfoMessage_027", NStr("en='Barcode [%1] is exists for item: %2 [%3] %4';
		|ru='Штрихкод [%1] существует для номенклатуры: %2 [%3] %4';
		|tr='Barkod [%1] sistemde mevcut, malzeme: %2 [%3] %4'", Lang));
	Strings.Insert("InfoMessage_028", NStr("en='New serial [ %1 ] created for item key [ %2 ]';
		|ru='Новая серия [ %1 ] созданная для серийного номера [ %2 ]';
		|tr='Yeni seri lot numarası [ %1 ] oluşturuldu, malzeme: [ %2 ]'", Lang));
	Strings.Insert("InfoMessage_029", NStr("en='This is unique serial and it can be only one at the document';
		|ru='Это уникальный серийный номер, он должен быть в документе в количестве 1';
		|tr='Bu seri lot numarası eşsizdir ve sadece tek bir defa evrakta kullanılabilir'", Lang));
	Strings.Insert("InfoMessage_030", NStr("en='Scan barcode of Item, not serial lot numbers';
		|ru='Просканируйте штрихкод товара, а не серийного номера';
		|tr='Seri lot barkodu değil, ürün barkodu okutunuz'", Lang));
	Strings.Insert("InfoMessage_031", NStr("en='Do you want to continue job?';
		|ru='Вы действительно хотите продолжить выполнение задания?';
		|tr='Görev devam etmek istediğinizden emin misiniz?'", Lang));
	Strings.Insert("InfoMessage_032", NStr("en='Do you want to pause job?';
		|ru='Вы действительно хотите поставить выполнение задания на паузу?';
		|tr='Görev duraklamak istediğinizden emin misiniz?'", Lang));
	Strings.Insert("InfoMessage_033", NStr("en='Do you want to stop job?';
		|ru='Вы действительно хотите остановить задание?';
		|tr='Görev durdurmak istediğinizden emin misiniz?'", Lang));
	
	Strings.Insert("InfoMessage_Payment", NStr("en='Payment (+)';
		|ru='Оплата (+)';
		|tr='Ödeme (+)'", Lang));
	Strings.Insert("InfoMessage_PaymentReturn", NStr("en='Payment Return'", Lang));
	Strings.Insert("InfoMessage_SessionIsClosed", NStr("en='Session is closed';
		|ru='Смена закрыта';
		|tr='Vardya kapandı'", Lang));
	Strings.Insert("InfoMessage_Sales", NStr("en='Sales';
		|ru='Продажа';
		|tr='Satış'", Lang));
	Strings.Insert("InfoMessage_Returns", NStr("en='Returns';
		|ru='Возвраты';
		|tr='İadeler'", Lang));
	Strings.Insert("InfoMessage_ReturnTitle", NStr("en='Return'", Lang));
	Strings.Insert("InfoMessage_POS_Title", NStr("en='Point of sales'", Lang));
	
#EndRegion

#Region QuestionToUser
	Strings.Insert("QuestionToUser_001", NStr("en='Write the object to continue. Continue?';
		|ru='Для продолжения необходимо сохранить объект. Продолжить?';
		|tr='Devam etmek için nesneyi yazın. Devam edilsin mi?'", Lang));
	Strings.Insert("QuestionToUser_002", NStr("en='Do you want to switch to scan mode?';
		|ru='Переключиться в режим сканирования?';
		|tr='Tarama moduna geçmek istiyor musunuz?'", Lang));
	Strings.Insert("QuestionToUser_003", NStr("en='Filled data on cheque bonds transactions will be deleted. Do you want to update %1?';
		|ru='Заполненные данные по чекам будут очищены. Обновить %1? ';
		|tr='Doldurulmuş çek/senet bilgiler temizlenecek. %1 güncellemek ister misiniz?'", Lang));
	Strings.Insert("QuestionToUser_004", NStr("en='Do you want to change tax rates according to the partner term?';
		|ru='Изменить налоговые ставки в соответствии с соглашением?';
		|tr='Vergileri sözleşmeye göre değiştirmek ister misiniz?'",
		Lang));
	Strings.Insert("QuestionToUser_005", NStr("en='Do you want to update filled stores?';
		|ru='Обновить заполненные склады?';
		|tr='Tüm depoları güncellemek ister misiniz?'", Lang));
	Strings.Insert("QuestionToUser_006", NStr("en='Do you want to update filled currency?';
		|ru='Обновить заполненные цены';
		|tr='Doldurulan para birimini güncellemek istiyor musunuz?'", Lang));
	Strings.Insert("QuestionToUser_007", NStr("en='Transaction table will be cleared. Continue?';
		|ru='Таблица транзакций будет очищена. Продолжить?';
		|tr='İşlemler tablosu temizlenecek. Devam etmek ister misiniz?'", Lang));
	Strings.Insert("QuestionToUser_008", NStr("en='Changing the currency will clear the rows with cash transfer documents. Continue?';
		|ru='При изменении валюты заполненные строки будут отвязаны от документа перемещения денежных средств. Продолжить?';
		|tr='Para birimini değiştirmek, nakit transferi belgelerini içeren satırları temizleyecektir. Devam ediyor muyuz?'", Lang));
	Strings.Insert("QuestionToUser_009", NStr("en='Do you want to replace filled stores with store %1?';
		|ru='Хотите заменить текущие склады на склад: %1?';
		|tr='Dolu depoları %1 deposu ile değiştirmek ister misiniz?'", Lang));
	Strings.Insert("QuestionToUser_011", NStr("en='Do you want to replace filled price types with price type %1?';
		|ru='Хотите заменить текущие типы цен на : %1?';
		|tr='Dolu fiyat tipleri %1 fiyat tipi ile değiştirmek ister misiniz?'",
		Lang));
	Strings.Insert("QuestionToUser_012", NStr("en='Do you want to exit?';
		|ru='Вы действительно хотите выйти?';
		|tr='Çıkmak istediğinizden emin misiniz?'", Lang));
	Strings.Insert("QuestionToUser_013", NStr("en='Do you want to update filled prices?';
		|ru='Обновить заполненные цены?';
		|tr='Doldurulmuş fiyatları güncellemek istiyor musunuz?'", Lang));
	Strings.Insert("QuestionToUser_014", NStr("en='Transaction type is changed. Do you want to update filled data?';
		|ru='Тип операции изменен. Обновить заполненные данные? ';
		|tr='İşlem türü değiştirildi. Doldurulmuş verileri güncellemek istiyor musunuz?'",
		Lang));
	Strings.Insert("QuestionToUser_015", NStr("en='Filled data will be cleared. Continue?';
		|ru='Заполненные данные будут очищены. Продолжить?';
		|tr='Doldurulan veriler silinecektir. Devam edilsin mi?'", Lang));
	Strings.Insert("QuestionToUser_016", NStr("en='Do you want to change or clear the icon?';
		|ru='Заменить или удалить иконку?';
		|tr='Simgeyi değiştirmek mi yoksa temizlemek mi istiyorsunuz?'", Lang));
	Strings.Insert("QuestionToUser_017", NStr("en='How many documents to create?';
		|ru='Сколько немобходимо создать документов?';
		|tr='Kaç tane evrak oluşturulsun?'", Lang));
	Strings.Insert("QuestionToUser_018", NStr("en='Please enter total quantity';
		|ru='Введите пожалуйста общее количество';
		|tr='Toplam lokasyon adedini giriniz'", Lang));
	Strings.Insert("QuestionToUser_019", NStr("en='Do you want to update payment term?';
		|ru='Хотите обновить условия оплаты?';
		|tr='Ödeme şekli güncellemek ister misiniz?'", Lang));
	Strings.Insert("QuestionToUser_020", NStr("en='Do you want to overwrite saved option?';
		|ru='Хотите перезаписать сохраненный вариант?';
		|tr='Daha önce kaydedilmiş seçeneği ezip kaydetmek ister misiniz?'", Lang));
	Strings.Insert("QuestionToUser_021", NStr("en='Do you want to close this form? All changes will be lost.';
		|ru='Вы хотите закрыть текущую форму? Все изменения будут потеряны.';
		|tr='Bu formu kapatmak istediğinizden emin misiniz? Tüm değişiklikler geri alınacaktır.'", Lang));
	Strings.Insert("QuestionToUser_022", NStr("en='Do you want to upload this files';
		|ru='Вы хотите загрузить эти файлы?';
		|tr='Dosya yüklemek ister misiniz?'", Lang) + ": " + Chars.LF + "%1");
	Strings.Insert("QuestionToUser_023", NStr("en='Do you want to fill according to cash transfer order?';
		|ru='Перезаполнить по перемещению денежных средств?';
		|tr='Kas/banka transfer fişine göre doldurulsun mu?'", Lang));
	Strings.Insert("QuestionToUser_024", NStr("en='Change planning period?';
		|ru='Поменять период планирования?';
		|tr='Planlama dönemi değiştirmek ister misiniz?'", Lang));
#EndRegion

#Region SuggestionToUser
	Strings.Insert("SuggestionToUser_1", NStr("en='Select a value';
		|ru='Выберите значение';
		|tr='Bir değer seçin'", Lang));
	Strings.Insert("SuggestionToUser_2", NStr("en='Enter a barcode';
		|ru='Введите штрихкод';
		|tr='Bir barkod giriniz'", Lang));
	Strings.Insert("SuggestionToUser_3", NStr("en='Enter an option name';
		|ru='Наименование параметра ввода';
		|tr='Bir seçenek adı giriniz'", Lang));
	Strings.Insert("SuggestionToUser_4", NStr("en='Enter a new option name';
		|ru='Введите новое наименование параметра';
		|tr='Yeni bir seçenek adı giriniz'", Lang));
#EndRegion

#Region UsersEvent
	Strings.Insert("UsersEvent_001", NStr("en='User not found by UUID %1 and name %2.';
		|ru='Пользователь по UUID %1 и имени %2не найден.';
		|tr='Kullanıcı, %1 UUID ve %2 adı ile bulunamadı.'", Lang));
	Strings.Insert("UsersEvent_002", NStr("en='User found by UUID %1 and name %2.';
		|ru='Пользователь по UUID %1 и имени %2 найден.';
		|tr='Kullanıcı, %1 UUID ve %2 adı tarafından bulundu.'", Lang));
#EndRegion

#Region Items
	
	// Interface
	Strings.Insert("I_1", NStr("en='Enter description';
		|ru='Введите Наименование';
		|tr='Açıklama giriniz'", Lang));
	Strings.Insert("I_2", NStr("en='Click to enter description';
		|ru='Нажмите для заполнения';
		|tr='Açıklama girmek için tıklayın'", Lang));
	Strings.Insert("I_3", NStr("en='Fill out the document';
		|ru='Заполните документ';
		|tr='Belgeyi doldurunuz'", Lang));
	Strings.Insert("I_4", NStr("en='Find %1 rows in table by key %2';
		|ru='Найти %1 строк в таблице по ключу %2';
		|tr='Tabloda %2 anahtara göre %1 bulmak'", Lang));
	Strings.Insert("I_5", NStr("en='Not supported table';
		|ru='Не поддерживаемая таблица';
		|tr='Desteklenmeyen tablo'", Lang));
	Strings.Insert("I_6", NStr("en='Ordered without ISR';
		|ru='Заказано без ЗОТ';
		|tr='Normal sipariş'", Lang));

#EndRegion

#Region Exceptions
	Strings.Insert("Exc_001", NStr("en='Unsupported object type.';
		|ru='Неподдерживаемый тип объекта.';
		|tr='Desteklenmeyen nesne türü.'", Lang));
	Strings.Insert("Exc_002", NStr("en='No conditions';
		|ru='Без условий';
		|tr='Koşul yok'", Lang));
	Strings.Insert("Exc_003", NStr("en='Method is not implemented: %1.';
		|ru='Метод не реализован: %1.';
		|tr='Yöntem uygulanmadı: %1.'", Lang));
	Strings.Insert("Exc_004", NStr("en='Cannot extract currency from the object.';
		|ru='Валюта из объекта не извлечена.';
		|tr='Nesneden para birimi çıkarılamıyor.'", Lang));
	Strings.Insert("Exc_005", NStr("en='Library name is empty.';
		|ru='Наименование библиотеки не заполнено.';
		|tr='Kütüphane adı boş.'", Lang));
	Strings.Insert("Exc_006", NStr("en='Library data does not contain a version.';
		|ru='Данные библиотеки не содержат версии.';
		|tr='Kütüphane veriler sürümü içermiyor.'", Lang));
	Strings.Insert("Exc_007", NStr("en='Not applicable for library version %1.';
		|ru='Не применимо для версии библиотеки: %1.';
		|tr='%1 kütüphane sürümü için geçerli değil.'", Lang));
	Strings.Insert("Exc_008", NStr("en='Unknown row key.';
		|ru='Неизвестный ключ строки.';
		|tr='Bilinmeyen satır anahtarı.'", Lang));
	Strings.Insert("Exc_009", NStr("en='Error: %1';
		|ru='Ошибка: %1';
		|tr='Hata: %1'", Lang));
#EndRegion

#Region Saas
	// %1 - 12
	Strings.Insert("Saas_001", NStr("en='Area %1 not found.';
		|ru='Рабочая область %1 не найдена.';
		|tr='%1 alanı bulunamadı.'", Lang));
	
	// %1 - closed
	Strings.Insert("Saas_002", NStr("en='Area status: %1.';
		|ru='Статус рабочей области: %1.';
		|tr='Alan durumu:%1.'", Lang));
	
	// %1 - en
	Strings.Insert("Saas_003", NStr("en='Localization %1 of the company is not available.';
		|ru='Локализация компании %1 не доступна.';
		|tr='Şirketin %1 yerelleştirmesi mevcut değil. '", Lang));

	Strings.Insert("Saas_004", NStr("en='Area preparation completed';
		|ru='Подготовка области завершена';
		|tr='Bölge hazırlaması tamamlandı.'", Lang));
#EndRegion

#Region FillingFromClassifiers
    // Do not modify "en" strings
	Strings.Insert("Class_001", NStr("en='Purchase price';
		|ru='Цена закупки';
		|tr='Alım fiyatı'", Lang));
	Strings.Insert("Class_002", NStr("en='Sales price';
		|ru='Цена продажи';
		|tr='Satış fiyatı'", Lang));
	Strings.Insert("Class_003", NStr("en='Prime cost';
		|ru='Себестоимость';
		|tr='Birim maliyet fiyatı'", Lang));
	Strings.Insert("Class_004", NStr("en='Service';
		|ru='Сервис';
		|tr='Servis'", Lang));
	Strings.Insert("Class_005", NStr("en='Product';
		|ru='Товар';
		|tr='Malzeme'", Lang));
	Strings.Insert("Class_006", NStr("en='Main store';
		|ru='Главный склад';
		|tr='Ana depo'", Lang));
	Strings.Insert("Class_007", NStr("en='Main manager';
		|ru='Главный менеджер';
		|tr='Ana sorumlu'", Lang));
	Strings.Insert("Class_008", NStr("en='pcs';
		|ru='шт';
		|tr='adet'", Lang));
#EndRegion

#Region Titles
	// %1 - Cheque bond transaction
	Strings.Insert("Title_00100", NStr("en='Select base documents in the ""%1"" document.';
		|ru='Выбор документов-оснований в документе ""%1""';
		|tr='""%1"" belgesindeki ana belgeleri seçin.'", Lang));	// Form PickUpDocuments
#EndRegion

#Region ChoiceListValues
	Strings.Insert("CLV_1", NStr("en='All';
		|ru='Все';
		|tr='Tümü'", Lang));
#EndRegion

#Region SalesOrderStatusReport
	Strings.Insert("SOR_1", NStr("en='Not enough items in free stock';
		|ru='Не достаточно товара на остатках';
		|tr='Serbest stok bakiyesi yetersizdir'", Lang));
#EndRegion

#Region Report
	Strings.Insert("R_001", NStr("en='Item key';
		|ru='Характеристика';
		|tr='Varyant'", Lang) + " = ");
	Strings.Insert("R_002", NStr("en='Property';
		|ru='Свойство';
		|tr='Özellik'", Lang) + " = ");
	Strings.Insert("R_003", NStr("en='Item';
		|ru='Номенклатура';
		|tr='Malzeme'", Lang) + " = ");
	Strings.Insert("R_004", NStr("en='Specification';
		|ru='Спецификация товара';
		|tr='Ürün reçetesi'", Lang) + " = ");
#EndRegion

#Region Defaults
	Strings.Insert("Default_001", NStr("en='pcs';
		|ru='шт';
		|tr='adet'", Lang));
	Strings.Insert("Default_002", NStr("en='Customer standard term';
		|ru='Стандартное соглашение для покупателей';
		|tr='Müşteri standart sözleşmesi'", Lang));
	Strings.Insert("Default_003", NStr("en='Vendor standard term';
		|ru='Стандартное соглашение для поставщиков';
		|tr='Tedarikçi standart sözleşmesi'", Lang));
	Strings.Insert("Default_004", NStr("en='Customer price type';
		|ru='Тип цен покупателя';
		|tr='Müşteri fiyat tipi'", Lang));
	Strings.Insert("Default_005", NStr("en='Vendor price type';
		|ru='Тип цен поставщика';
		|tr='Tedarikçi fiyat tipi'", Lang));
	Strings.Insert("Default_006", NStr("en='Partner term currency type';
		|ru='Валюта соглашения';
		|tr='Cari hesap sözleşme dövizi'", Lang));
	Strings.Insert("Default_007", NStr("en='Legal currency type';
		|ru='Локальныей тип валют';
		|tr='Local döviz tipi'", Lang));
	Strings.Insert("Default_008", NStr("en='American dollar';
		|ru='Доллар США';
		|tr='Amerika doları'", Lang));
	Strings.Insert("Default_009", NStr("en='USD';
		|ru='USD';
		|tr='USD'", Lang));
	Strings.Insert("Default_010", NStr("en='$';
		|ru='$';
		|tr='$'", Lang));
	Strings.Insert("Default_011", NStr("en='My Company';
		|ru='Моя организация';
		|tr='Benim şirketim'", Lang));
	Strings.Insert("Default_012", NStr("en='My Store';
		|ru='Мой склад';
		|tr='Benim depom'", Lang));
#EndRegion

#Region OtherString
	Strings.Insert("Str_Catalog", NStr("en='Catalog';
		|ru='Справочник';
		|tr='Kart listesi'", Lang));
	Strings.Insert("Str_Catalogs", NStr("en='Catalogs';
		|ru='Справочники';
		|tr='Kart listeleri'", Lang));
	Strings.Insert("Str_Document", NStr("en='Document';
		|ru='Документ';
		|tr='Evrak'", Lang));
	Strings.Insert("Str_Documents", NStr("en='Documents';
		|ru='Документы';
		|tr='Evraklar'", Lang));
#EndRegion

#Region Mobile
	// %1 - Some item key
	// %2 - Other item key
	Strings.Insert("Mob_001", NStr("en='Current barcode used in %1
		|But before you scan for %2';
		|ru='Текущий штрихкод использован в %1
		|Но перед этим был просканирован %2'", Lang));
#EndRegion
	Return Strings;
EndFunction
