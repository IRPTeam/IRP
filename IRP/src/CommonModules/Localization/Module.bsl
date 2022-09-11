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
//  * Default_003 - String - Vendor stabdard term
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
Function Strings(Lang) Export

	Strings = New Structure();

#Region Equipment
	Strings.Insert("Eq_001", NStr("tr='Kuruldu';
		|en='Installed';
		|ru='Установлен'", Lang));
	Strings.Insert("Eq_002", NStr("tr='Kurulmadı';
		|en='Not installed';
		|ru='Не установлен'", Lang));
	Strings.Insert("Eq_003", NStr("tr='Bir hata tespit edilemedi.';
		|en='There are no errors.';
		|ru='Ошибок нет.'", Lang));
	Strings.Insert("Eq_004", NStr("tr='Barkod okuyucusu başarılya bağlandı.';
		|en='Scanner is connected.';
		|ru='Сканер подключен.'", Lang));
	Strings.Insert("Eq_005", NStr("tr='Hata. Barkod okuyucusu bağlanamadı';
		|en='Error. Scanner not connected.';
		|ru='Ошибка. Сканер не подключен.'", Lang));
	Strings.Insert("Eq_006", NStr("tr='Bu bilgisayara kurulmuştu.';
		|en='Installed on current PC.';
		|ru='Установить на текущий компьютер'", Lang));
	Strings.Insert("Eq_007", NStr("tr='Cihaz bağlanamadı %1';
		|en='Can not connect device %1';
		|ru='Не получилось подключить оборудование %1'", Lang));

	Strings.Insert("EqError_001", NStr("tr='Cihaz bağlandı. İşlemden önce cihaz devre dışı bırakılmalı.';
		|en='The device is connected. The device must be disabled before the operation.';
		|ru='Устройство подключено. Устройство должно быть отключено перед началом работы.'", Lang));

	Strings.Insert("EqError_002", NStr("tr='Cihaz sürücüsü yüklenemedi.
		|Sürücünün düzgün kurulduğundan ve sistemde kayıtlı (registered) olduğundan emin olunuz.';
		|en='The device driver could not be downloaded.
		|Check that the driver is correctly installed and registered in the system.';
		|ru='Драйвер устройства не может быть загружен. 
		|Проверьте, что драйвер правильно установлен и зарегистрирован в системе.'",
		Lang));

	Strings.Insert("EqError_003", NStr("tr='Ek ID''de minimum bir nokta olmalıdır.';
		|en='It has to be minimum one dot at Add ID.';
		|ru='Необходимо иметь минимум одну точку в доп. ID.'", Lang));
	Strings.Insert("EqError_004", NStr("tr='Sürücü yükemeden öncesi indirmek lazım.';
		|en='Before install driver - it has to be loaded.';
		|ru='Перед тем как установить драйвер, он должен быть загружен.'", Lang));
	Strings.Insert("EqError_005", NStr("tr='Donanım %1 sürücüsü yanlış AddIn ID %2 bilgisine sahiptir.';
		|en='The equipment driver %1 has incorrect AddIn ID %2.';
		|ru='У драйвера оборудования %1 неправильный AddIn ID %2.'", Lang));
#EndRegion

#Region POS

	Strings.Insert("POS_s1", NStr("tr='Ödeme tutarı satış tutarından daha küçüktür';
		|en='Amount paid is less than amount of the document';
		|ru='Сумма оплаты меньше суммы документа'", Lang));
	Strings.Insert("POS_s2", NStr("tr='Kart ile ödeme tutarı satış tutarından daha büyüktür';
		|en='Card fees are more than the amount of the document';
		|ru='Сумма оплат по безналичному расчету больше суммы документа'", Lang));
	Strings.Insert("POS_s3", NStr("tr='Nakit tutar girmenize gerek yok, çünkü kart ile alınan ödeme yeterlidir';
		|en='There is no need to use cash, as card payments are sufficient to pay';
		|ru='Суммы по безналичному расчету для оплаты достаточно. Нет необходимости дополнительно использовать наличный расчет. '", Lang));
	Strings.Insert("POS_s4", NStr("tr='Ödeme tutarlarda hata var';
		|en='Amounts of payments are incorrect';
		|ru='Суммы оплат некорректны'", Lang));
	Strings.Insert("POS_s5", NStr("tr='Satış elemanı seç';
		|en='Select sales person';
		|ru='Выбрать продавца'", Lang));
#EndRegion

#Region Service
	
	// %1 - localhost
	// %2 - 8080 
	// %3 - There is no internet connection
	Strings.Insert("S_002", NStr("tr='%1:%2 ile bağlantı kurulamıyor. Ayrıntılar:%3';
		|en='Cannot connect to %1:%2. Details: %3';
		|ru='Не получается подключиться к %1:%2. Подробности: %3.'", Lang));
	
	// %1 - localhost
	// %2 - 8080
	Strings.Insert("S_003", NStr("tr='%1:%2 tarafından yanıt alındı';
		|en='Received response from %1:%2';
		|ru='Полученный ответ от %1:%2'", Lang));
	Strings.Insert("S_004", NStr("tr='Kaynak adresi boş.';
		|en='Resource address is empty.';
		|ru='Адрес ресурса не заполнен.'", Lang));
	
	// %1 - connection_to_other_system
	Strings.Insert("S_005", NStr("tr='%1 adıyla entegrasyon ayarı bulunamadı.';
		|en='Integration setting with name %1 is not found.';
		|ru='Настройки интеграции с наименованием %1 не найдены.'", Lang));
	Strings.Insert("S_006", NStr("tr='Yöntem Web İstemcisinde desteklenmiyor';
		|en='Method is not supported in Web Client.';
		|ru='В web клиенте метод не поддерживается.'", Lang));
	
	// Special offers
	Strings.Insert("S_013", NStr("tr='Desteklenmeyen nesne türü: %1.';
		|en='Unsupported object type: %1.';
		|ru='Неподдерживаемый тип объекта: %1.'", Lang));
	
	// FileTransfer
	Strings.Insert("S_014", NStr("tr='Dosya adı boş.';
		|en='File name is empty.';
		|ru='Имя файла не заполнено'", Lang));
	Strings.Insert("S_015", NStr("tr='Kaydetme yolu belirlenmemiş.';
		|en='Path for saving is not set.';
		|ru='Путь сохранения не установлен.'", Lang));
	
	// Test connection
	// %1 - Method unsupported on web client
	// %2 - 404
	// %3 - Text frim site
	Strings.Insert("S_016", NStr("tr='%1 Durum kodu: %2 %3';
		|en='%1 Status code: %2 %3';
		|ru='%1 Статус код: %2 %3'", Lang));
	
	//	scan barcode
	Strings.Insert("S_018", NStr("tr='Malzeme eklendi.';
		|en='Item added.';
		|ru='Номенклатура добавлена.'", Lang)); 
	
	// %1 - 123123123123
	Strings.Insert("S_019", NStr("tr='%1 barkodu bulunamadı.';
		|en='Barcode %1 not found.';
		|ru='Штрихкод %1 не найден.'", Lang));
	Strings.Insert("S_022", NStr("tr='Ana belgelerdeki para birimleri eşleşmelidir.';
		|en='Currencies in the base documents must match.';
		|ru='Валюты в документах-основания должны совпадать.'", Lang));
	Strings.Insert("S_023", NStr("tr='Tedarik şekli';
		|en='Procurement method';
		|ru='Метод обеспечения'", Lang));

	Strings.Insert("S_026", NStr("tr='Seçilen simge 16x16 piksel olarak yeniden boyutlandırılacaktır.';
		|en='Selected icon will be resized to 16x16 px.';
		|ru='Размер выбранной иконки будет изменен до 16x16 px.'", Lang));

	// presentation of empty value for query result
	Strings.Insert("S_027", NStr("tr='[ Doldurulmamış ]';
		|en='[Not filled]';
		|ru='[не заполнено]'", Lang));
	// operation is Success
	Strings.Insert("S_028", NStr("tr='Başarılı';
		|en='Success';
		|ru='Успешно'", Lang));
	Strings.Insert("S_029", NStr("tr='Desteklenmeyen web istemci';
		|en='Not supporting web client';
		|ru='Не поддерживаемый wreb клиент'", Lang));
	Strings.Insert("S_030", NStr("tr='Para üstü';
		|en='Cashback';
		|ru='Сдача'", Lang));
	Strings.Insert("S_031", NStr("tr='veya';
		|en='or';
		|ru='или'", Lang));
	Strings.Insert("S_032", NStr("tr='Kod ekle, örneğin: CurrentSessionDate()';
		|en='Add code, ex: CurrentSessionDate()';
		|ru='Добавить код, например: ТекущаяДатаСеанса ()'", Lang));
#EndRegion

#Region Service
	Strings.Insert("Form_001", NStr("tr='Yeni sayfa';
		|en='New page';
		|ru='Новая страница'", Lang));
	Strings.Insert("Form_002", NStr("tr='Kaldır';
		|en='Delete';
		|ru='Пометить на удаление/Снять пометку'", Lang));
	Strings.Insert("Form_003", NStr("tr='Miktar';
		|en='Quantity';
		|ru='Количество'", Lang));
	Strings.Insert("Form_004", NStr("tr='Müşteri anlaşmaları';
		|en='Customers terms';
		|ru='Соглашения с клиентами'", Lang));
	Strings.Insert("Form_005", NStr("tr='Müşteriler';
		|en='Customers';
		|ru='Клиенты'", Lang));
	Strings.Insert("Form_006", NStr("tr='Tedarikçiler';
		|en='Vendors';
		|ru='Поставщики'", Lang));
	Strings.Insert("Form_007", NStr("tr='Tedarikçi anlaşması';
		|en='Vendors terms';
		|ru='Соглашения с поставщиками'", Lang));
	Strings.Insert("Form_008", NStr("tr='Kullanıcı';
		|en='User';
		|ru='Пользователь'", Lang));
	Strings.Insert("Form_009", NStr("tr='Kullanıcı grubu';
		|en='User group';
		|ru='Группа пользователей'", Lang));
	Strings.Insert("Form_013", NStr("tr='Tarih';
		|en='Date';
		|ru='Дата'", Lang));
	Strings.Insert("Form_014", NStr("tr='Numara';
		|en='Number';
		|ru='Номер'", Lang));
	
	// change icon
	Strings.Insert("Form_017", NStr("tr='Değiştir';
		|en='Change';
		|ru='Изменить'", Lang));
	
	// clear icon
	Strings.Insert("Form_018", NStr("tr='Temizle';
		|en='Clear';
		|ru='Очистить'", Lang));
	
	// cancel answer on question
	Strings.Insert("Form_019", NStr("tr='İptal';
		|en='Cancel';
		|ru='Отмена'", Lang));
	
	// PriceInfo report 
	Strings.Insert("Form_022", NStr("tr='1. Varyantlara göre';
		|en='1. By item keys';
		|ru='1. По характеристике номенклатуры'", Lang));
	Strings.Insert("Form_023", NStr("tr='2. Özelliklere göre';
		|en='2. By properties';
		|ru='2. По свойствам'", Lang));
	Strings.Insert("Form_024", NStr("tr='3. Malzemelere göre';
		|en='3. By items';
		|ru='3. По номенклатуре'", Lang));

	Strings.Insert("Form_025", NStr("tr='Sınıflandırıcıdan oluştur';
		|en='Create from classifier';
		|ru='Создать по классификатору'", Lang));

	Strings.Insert("Form_026", NStr("tr='Malzeme Paketi';
		|en='Item Bundle';
		|ru='Номенклатура набора'", Lang));
	Strings.Insert("Form_027", NStr("tr='Malzeme';
		|en='Item';
		|ru='Номенклатура'", Lang));
	Strings.Insert("Form_028", NStr("tr='Malzeme tipi';
		|en='Item type';
		|ru='Вид номенклатуры'", Lang));
	Strings.Insert("Form_029", NStr("tr='Dış özellikler';
		|en='External attributes';
		|ru='Внешние реквизиты'", Lang));
	Strings.Insert("Form_030", NStr("tr='Boyutlar';
		|en='Dimensions';
		|ru='Измерения'", Lang));
	Strings.Insert("Form_031", NStr("tr='Ağırlık bilgisi';
		|en='Weight information';
		|ru='Информация о весе'", Lang));
	Strings.Insert("Form_032", NStr("tr='Dönem';
		|en='Period';
		|ru='Период'", Lang));
	Strings.Insert("Form_033", NStr("tr='Tümü göster';
		|en='Show all';
		|ru='Показать все'", Lang));
	Strings.Insert("Form_034", NStr("tr='Tümü sakla';
		|en='Hide all';
		|ru='Скрыть все'", Lang));
	Strings.Insert("Form_035", NStr("tr='Başlık';
		|en='Head';
		|ru='Шапка'", Lang));
#EndRegion

#Region ErrorMessages

	// %1 - en
	Strings.Insert("Error_002", NStr("tr='%1 açıklaması boş';
		|en='%1 description is empty';
		|ru='%1 наименование не заполнено'", Lang));
	Strings.Insert("Error_003", NStr("tr='Herhangi bir açıklama girininiz.';
		|en='Fill any description.';
		|ru='Заполните наименование.'", Lang));
	Strings.Insert("Error_004", NStr("tr='Meta veriler desteklenmiyor.';
		|en='Metadata is not supported.';
		|ru='Метаданные не поддерживаются.'", Lang));
	
	// %1 - en
	Strings.Insert("Error_005", NStr("tr='Ek bir %1 özniteliğinin açıklamasını doldurunuz.';
		|en='Fill the description of an additional attribute %1.';
		|ru='Заполните наименование дополнительного реквизита %1.'", Lang));
	Strings.Insert("Error_008", NStr("tr='Gruplar bir yönetici tarafından oluşturulur.';
		|en='Groups are created by an administrator.';
		|ru='Группы создаются администратором.'", Lang));
	
	// %1 - Number 111 is not unique
	Strings.Insert("Error_009", NStr("tr='Nesne yazılamıyor: [%1].';
		|en='Cannot write the object: [%1].';
		|ru='Ошибка при записи объекта: [%1].'", Lang));
	
	// %1 - Number
	Strings.Insert("Error_010", NStr("tr='[%1] alanı boş.';
		|en='Field [%1] is empty.';
		|ru='Поле [%1] не заполнено.'", Lang));
	Strings.Insert("Error_011", NStr("tr='En az bir satır ekleyin.';
		|en='Add at least one row.';
		|ru='Нужно добавить хоть одну строку.'", Lang));
	Strings.Insert("Error_012", NStr("tr='Değişken, kurallara göre adlandırılmaz.';
		|en='Variable is not named according to the rules.';
		|ru='Переменная названа не в соответствии с правилами.'", Lang));
	Strings.Insert("Error_013", NStr("tr='Değer benzersiz değil.';
		|en='Value is not unique.';
		|ru='Значение не уникально.'", Lang));
	Strings.Insert("Error_014", NStr("tr='Parola ve parola onayı eşleşmiyor.';
		|en='Password and password confirmation do not match.';
		|ru='Пароль и подтверждение пароля не совпадают.'", Lang));

	// %1 - Sales order
	Strings.Insert("Error_016", NStr("tr='""%1"" belgesinde tedarikçilerden sipariş etmeniz gereken başka ürün yok.';
		|en='There are no more items that you need to order from suppliers in the ""%1"" document.';
		|ru='В документе ""%1"" не осталось товаров по которым необходимо сделать заказ поставщику.'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_017", NStr("tr='İlk olarak, bir ""%1"" belgesi oluşturun veya ""Diğer"" sekmesindeki ""%1 %2''den önce"" onay kutusunu temizleyin.';
		|en='First, create a ""%1"" document or clear the ""%1 before %2"" check box on the ""Other"" tab.';
		|ru='Вначале необходимо создать документ ""%1"" или снять галочку ""%1 перед документом %2"" на вкладке ""Дополнительно"".'", Lang));

	// %1 - Shipment confirmation
	// %1 - Sales invoice
	Strings.Insert("Error_018", NStr("tr='İlk olarak, bir ""%1"" belgesi oluşturun veya ""Diğer"" sekmesindeki ""%1 %2''den önce"" onay kutusunu temizleyin.';
		|en='First, create a ""%1"" document or clear the ""%1 before %2"" check box on the ""Other"" tab.';
		|ru='Вначале необходимо создать документ ""%1"" или снять галочку ""%1 перед документом %2"" на вкладке ""Дополнительно"".'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_019", NStr("tr='""%2"" belgesinde ""%1"" belgesi oluşturmanız gereken satır yok.';
		|en='There are no lines for which you need to create a ""%1"" document in the ""%2"" document.';
		|ru='Строки по которым необходимо создать документ ""%1"" отсутствуют в документе ""%2"".'", Lang));

	// %1 - 12
	Strings.Insert("Error_020", NStr("tr='%1 satırı için bir ana belge belirtin.';
		|en='Specify a base document for line %1.';
		|ru='Необходимо заполнить документ-основания по строке %1.'", Lang));

	// %1 - Purchase invoice
	Strings.Insert("Error_021", NStr("tr='""%1"" belgesinde iade edilecek ürün yok. Tüm ürünler zaten iade edildi.';
		|en='There are no products to return in the ""%1"" document. All products are already returned.';
		|ru='По всем товарам из выбранного документа ""%1"" уже был оформлен возврат.'", Lang));

	// %1 - Internal supply request
	Strings.Insert("Error_023", NStr("tr='""%1"" belgesinde tedarikçilerden sipariş etmeniz gereken başka ürün yok.';
		|en='There are no more items that you need to order from suppliers in the ""%1"" document.';
		|ru='В документе ""%1"" не осталось товаров по которым необходимо сделать заказ поставщику.'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_028", NStr("tr='""Diğer"" sekmesinde ""%2''den %1 önce"" onay kutusunu seçin.';
		|en='Select the ""%1 before %2"" check box on the ""Other"" tab.';
		|ru='Необходимо установить галочку ""%1 перед документом %2"" на вкладке ""Дополнительно"".'", Lang));
	
	// %1 - Cash account
	// %2 - 12
	// %3 - Cheque bonds
	Strings.Insert("Error_030", NStr("tr='%3''ün %2 satırında %1 belirtin.';
		|en='Specify %1 in line %2 of the %3.';
		|ru='Поле %1 обязателено для заполнения в строке %2 %3.'", Lang));

	Strings.Insert("Error_031", NStr("tr='Tedarik yöntemine göre malzemeler tedarikçiden alınmadı.';
		|en='Items were not received from the supplier according to the procurement method.';
		|ru='Заказанные товары у поставщика для обеспечения заказа не были получены.'", Lang));
	Strings.Insert("Error_032", NStr("tr='Eylem tamamlanmadı.';
		|en='Action not completed.';
		|ru='Действие не завершено.'", Lang));
	Strings.Insert("Error_033", NStr("tr='Yinelenen özellik.';
		|en='Duplicate attribute.';
		|ru='Реквизит дублируется.'", Lang));
	// %1 - Google drive
	Strings.Insert("Error_034", NStr("tr='%1 bir resim depolama birimi değil.';
		|en='%1 is not a picture storage volume.';
		|ru='%1 не является томом для хранения изображений.'", Lang));
	Strings.Insert("Error_035", NStr("tr='1''den fazla dosya yüklenemez.';
		|en='Cannot upload more than 1 file.';
		|ru='Невозможно загрузить более 1 файла.'", Lang));
	Strings.Insert("Error_037", NStr("tr='Desteklenmeyen veri bileşimi karşılaştırması türü.';
		|en='Unsupported type of data composition comparison.';
		|ru='Неподдерживаемый тип сравнения состава данных.'", Lang));
	Strings.Insert("Error_040", NStr("tr='Yalnızca resim dosyaları desteklenir.';
		|en='Only picture files are supported.';
		|ru='Поддерживается только тип файла - картинка.'", Lang));
	Strings.Insert("Error_041", NStr("tr='Vergi tablosu 1''den fazla satır içeriyor [anahtar: %1] [vergi: %2].';
		|en='Tax table contains more than 1 row [key: %1] [tax: %2].';
		|ru='Таблица налогов содержит больше 1 строки [ключ: %1] [налог: %2].'", Lang));
	// %1 - Name
	Strings.Insert("Error_042", NStr("tr='Sütun adına göre bir vergi bulunamıyor: %1.';
		|en='Cannot find a tax by column name: %1.';
		|ru='Не найден налог по наименованию колонки: %1.'", Lang));
	Strings.Insert("Error_043", NStr("tr='Desteklenmeyen belge türü.';
		|en='Unsupported document type.';
		|ru='Неподдерживаемый тип документа.'", Lang));
	Strings.Insert("Error_044", NStr("tr='İşlem desteklenmiyor.';
		|en='Operation is not supported.';
		|ru='Недопустимая операция.'", Lang));
	Strings.Insert("Error_045", NStr("tr='Belge boş.';
		|en='Document is empty.';
		|ru='Документ не заполнен.'", Lang));
	// %1 - Currency
	Strings.Insert("Error_047", NStr("tr='""%1"" zorunlu bir alandır.';
		|en='""%1"" is a required field.';
		|ru='Поле ""%1"" обязательное для заполнения.'", Lang));
	Strings.Insert("Error_049", NStr("tr='Varsayılan resim saklama hacmi ayarlanmamıştır.';
		|en='Default picture storage volume is not set.';
		|ru='Том хранения файлов по умолчанию не заполнен.'", Lang));
	Strings.Insert("Error_050", NStr("tr='Döviz değişimi yalnızca aynı türdeki hesaplar için (kasa hesapları veya banka hesapları) kullanılabilir.';
		|en='Currency exchange is available only for the same-type accounts (cash accounts or bank accounts).';
		|ru='Обмен валюты возможен только между счетами одного типа (между двумя кассами или между двумя банковскими счетами).'",
		Lang));
	// %1 - Bank payment
	Strings.Insert("Error_051", NStr("tr='Kendisi için bir ""%1"" belgesi oluşturabileceğiniz satır yok veya tüm ""%1"" belgeleri zaten oluşturulmuş.';
		|en='There are no lines for which you can create a ""%1"" document, or all ""%1"" documents are already created.';
		|ru='Отсутствуют строки по которым необходимо создать ""%1"" или же все документы ""%1"" уже были созданы ранее.'",
		Lang));
	// %1 - Main store
	// %2 - Use shipment confirmation
	// %3 - Shipment confirmations
	Strings.Insert("Error_052", NStr("tr='""%2"" onay kutusu temizlenemiyor.
		|%1 mağazasından ""%3"" belgeleri zaten oluşturulmuş.';
		|en='Cannot clear the ""%2"" check box. 
		|Documents ""%3"" from store %1 were already created.';
		|ru='Снять галочку ""%2"" невозможно. 
		|Ранее со склада %1 уже были созданы документы ""%3"".'", Lang));
	
	// %1 - Main store
	// %2 - Use goods receipt
	// %3 - Goods receipts
	Strings.Insert("Error_053", NStr("tr='""%2"" onay kutusu temizlenemiyor. %1 mağazasından ""%3"" belgeleri zaten oluşturulmuş.';
		|en='Cannot clear the ""%2"" check box. Documents ""%3"" from store %1 were already created.';
		|ru='Невозможно снять галочку ""%2"". Ранее со склада %1 уже были созданы документы ""%3"".'", Lang));
	
	// %1 - sales order
	Strings.Insert("Error_054", NStr("tr='Devam edilemez. ""%1"" belgesinin durumu yanlış.';
		|en='Cannot continue. The ""%1""document has an incorrect status.';
		|ru='Невозможно продолжить. Статус документа ""%1"" для продолжения неверный.'", Lang));

	Strings.Insert("Error_055", NStr("tr='Doğru tedarik yöntemine sahip hatlar yoktur.';
		|en='There are no lines with a correct procurement method.';
		|ru='Отсутствуют строки с нужным способом обеспечения.'", Lang));

	// %1 - sales order
	// %2 - purchase order
	Strings.Insert("Error_056", NStr("tr='""%1"" belgesindeki tüm öğeler ""%2"" belgeleri kullanılarak zaten sıralanmıştır.';
		|en='All items in the ""%1"" document are already ordered using the ""%2"" document(s).';
		|ru='Все товары в документе ""%1"" уже заказаны документом ""%2"".'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_057", NStr("tr='Seçili ""%2"" dokümanlar için ""%1"" doküman oluşturmanıza gerek yoktur.';
		|en='You do not need to create a ""%1"" document for the selected ""%2"" document(s).';
		|ru='Для выбранного документа ""%1"" не нужно создавать документ ""%2"".'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_058", NStr("tr='""%2"" belgelerinin toplam tutarı, ""%1"" belgeleri temelinde zaten ödendi.';
		|en='The total amount of the ""%2"" document(s) is already paid on the basis of the ""%1"" document(s).';
		|ru='Вся сумма по документу ""%2"" уже была выдана по документу ""%1"".'",
		Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_059", NStr("tr='Seçilen belgelerde, mevcut ""%1"" belgelerine sahip ""%2"" belgeler var
		|  ve ""%1"" belgesi gerektirmeyenler.';
		|en='In the selected documents, there are ""%2"" document(s) with existing ""%1"" document(s)
		| and those that do not require a ""%1"" document.';
		|ru='В списке выбранных документов ""%2"" есть те по которым уже был создан документ ""%1""
		| и те по которым документ ""%1"" создавать не нужно.'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_060", NStr("tr='""%2"" belgelerinin toplam miktarı, ""%1"" belgeleri temelinde zaten alındı.';
		|en='The total amount of the ""%2"" document(s) is already received on the basis of the ""%1"" document(s).';
		|ru='Вся сумма по документу ""%2"" уже была получена по документу ""%1"".'",
		Lang));
	
	// %1 - Main store
	// %2 - Shipment confirmation
	// %3 - Sales order
	Strings.Insert("Error_064", NStr("tr='%1 mağazaları için ""%2"" belgesi oluşturmanıza gerek yok. Ürün, ""%3"" belgesi kullanılarak gönderilecek.';
		|en='You do not need to create a ""%2"" document for store(s) %1. The item will be shipped using the ""%3"" document.';
		|ru='Для склада %1 нет необходимости создавать документ ""%2"". Товар будет отгружен по документу ""%3"".'",
		Lang));

	Strings.Insert("Error_065", NStr("tr='Varyant benzersiz değil.';
		|en='Item key is not unique.';
		|ru='Характеристика не уникальна.'", Lang));
	Strings.Insert("Error_066", NStr("tr='Spesifikasyon benzersiz değil.';
		|en='Specification is not unique.';
		|ru='Спецификация товара не уникальна.'", Lang));
	Strings.Insert("Error_067", NStr("tr='Kullanıcı ve Grup tabloları doldur';
		|en='Fill Users or Group tables.';
		|ru='Для таблиц пользователей или групп пользователей'", Lang));

	// %1 - 12
	// %2 - Boots
	// %3 - Red XL
	// %4 - ordered
	// %5 - 11
	// %6 - 15
	// %7 - 4
	// %8 - pcs
	Strings.Insert("Error_068", NStr("tr='Satır No. [%1] [%2 %3] %4aldı: %5 %8. Gerekli: %6 %8. Eksik: %7 %8.';
		|en='Line No. [%1] [%2 %3] %4 remaining: %5 %8. Required: %6 %8. Lacking: %7 %8.';
		|ru='Строка № [%1] [%2%3] %4 остаток: %5%8 Требуется: %6%8 Разница: %7%8.'", Lang));

	// %1 - 12
	// %2 - Boots
	// %3 - Red XL
	// %4 - 00001
	// %5 - ordered
	// %6 - 11
	// %7 - 15
	// %8 - 4
	// %9 - pcs
	Strings.Insert("Error_068_2", NStr("tr='Satır numarası [%1] [%2 %3] Seri lot numarası [%4] %5 kalan: %6 %9. İhtiyaç duyulan: %7 %9. Eksik: %8 %9.';
		|en='Line No. [%1] [%2 %3] Serial lot number [%4] %5 remaining: %6 %9. Required: %7 %9. Lacking: %8 %9.';
		|ru='Номер строки [%1] [%2 %3] Серийный номер [%4] %5 остаток: %6 %9. Требуется: %7 %9. Недостача: %8 %9.'", Lang));



	// %1 - some extention name
	Strings.Insert("Error_071", NStr("tr='""%1"" eklentisi bağlı değil.';
		|en='Plugin ""%1"" is not connected.';
		|ru='Внешняя обработка ""%1"" не подключена.'", Lang));
	
	// %1 - 12
	Strings.Insert("Error_072", NStr("tr='%1 satırında bir mağaza belirtin.';
		|en='Specify a store in line %1.';
		|ru='В строке %1 необходимо заполнить склад.'", Lang));

	// %1 - Sales order
	// %2 - Goods receipt
	Strings.Insert("Error_073", NStr("tr='""%1"" belgelerindeki tüm öğeler, ""%2"" belgeleri kullanılarak zaten alındı.';
		|en='All items in the ""%1"" document(s) are already received using the ""%2"" document(s).';
		|ru='Все товары по документу ""%1"" уже получены на основании документа ""%2"".'", Lang));
	Strings.Insert("Error_074", NStr("tr='Para birimi transferi yalnızca tutarlar eşit olduğunda kullanılabilir.';
		|en='Currency transfer is available only when amounts are equal.';
		|ru='При перемещении денежных средств в одной валюте сумма отправки и получения должны совпадать.'", Lang));

	// %1 - Physical count by location
	Strings.Insert("Error_075", NStr("tr='Kapatılmamış ""%1"" dokümanlar var.';
		|en='There are ""%1"" documents that are not closed.';
		|ru='Есть незакрытые документы ""%1"".'", Lang));
	
	// %1 - 12
	Strings.Insert("Error_077", NStr("tr='Ana belge %1 satırında boş.';
		|en='Basis document is empty in line %1.';
		|ru='Не заполнен документ основания в строке %1'", Lang));
	
	// %1 - 1 %2 - 2
	Strings.Insert("Error_078", NStr("tr='Girilen [%1] adet, seri lotuna ait [%2] adedinden farklıdır';
		|en='Quantity [%1] does not match the quantity [%2] by serial/lot numbers';
		|ru='Количество [%1] по строке не совпадает с количеством [%2] заполненным по серийным номерам. '",
		Lang));
	
	// %1 - 100.00 
	// %2 - 120.00
	Strings.Insert("Error_079", NStr("tr='Ödeme tutar ([%1]) iade tutarından ([%2]) farklıdır';
		|en='Payment amount [%1] and return amount [%2] not match';
		|ru='Сумма оплаты [%1] и сумма возврата [%2] не сходятся'", Lang));
	
	// %1 - 1 
	// %2 - Goods receipt 
	// %3 - 10 
	// %4 - 8
	Strings.Insert("Error_080", NStr("tr='%1 satırında %2 %3 adet %4 adedinden daha büyük';
		|en='In line %1 quantity by %2 %3 greater than %4';
		|ru='В строке %1 количество %2 %3 больше чем %4'", Lang));
	
	// %1 - 1 
	// %2 - Dress 
	// %3 - Red/38 
	// %4 - 8 
	// %5 - 10
	Strings.Insert("Error_081", NStr("tr='%1 satırında %2-%3 %4 adedi %5 alım irsaliyesindeki adetten daha küçük';
		|en='In line %1 quantity by %2-%3 %4 less than quantity by goods receipt %5';
		|ru='В строке %1 количество %2-%3 %4 меньше чем количество в приходном ордере %5'",
		Lang));
	
	// %1 - 1 
	// %2 - Dress 
	// %3 - Red/38 
	// %4 - 10 
	// %5 - 8
	Strings.Insert("Error_082", NStr("tr='%1 satırında %2-%3 %4 adedi %5 alım irsaliyesindeki adetten daha küçük';
		|en='In line %1 quantity by %2-%3 %4 less than quantity by goods receipt %5';
		|ru='В строке %1 количество %2-%3 %4 меньше чем количество в приходном ордере %5'",
		Lang));
	
	// %1 - 12 
	Strings.Insert("Error_083", NStr("tr='`%1` nolu lokasyon bulunamadı';
		|en='Location with number `%1` not found.';
		|ru='Локация с номером %1 не найдена.'", Lang));
	
	// %1 - 1000
	// %2 - 300
	// %3 - 350
	// %4 - 50
	// %5 - USD
	Strings.Insert("Error_085", NStr("tr='Borç limiti aşıldı. Limit: %1, limit bakiyesi: %2, işlem: %3, yetersiz tutar: %4 %5';
		|en='Credit limit exceeded. Limit: %1, limit balance: %2, transaction: %3, lack: %4 %5';
		|ru='Превышение лимита взаиморасчетов. Лимит: %1, остаток взаиморасчетов: %2, транзакция: %3, не хватающая сумма: %4 %5'", Lang));
	
	// %1 - 10
	// %2 - 20	
	Strings.Insert("Error_086", NStr("tr='%1 tutarı, ödeme toplamı %2 ile tutmuyor';
		|en='Amount : %1 not match Payment term amount: %2';
		|ru='Сумма (%1) не сходится с условиями оплата (%2)'", Lang));

	Strings.Insert("Error_087", NStr("tr='Üst öğe boş olamaz';
		|en='Parent can not be empty';
		|ru='Родитель не может быть пустым'", Lang));
	Strings.Insert("Error_088", NStr("tr='Malzemeye göre filtre uygulandığı takdirse, ana birimi doldurmak lazım.';
		|en='Basis unit has to be filled, if item filter used.';
		|ru='Если устанавливается фильтр по номенклатуре, основная единица измерения должны быть заполнена.'", Lang));

	Strings.Insert("Error_089", NStr("tr='%1 ""%2"" tanımı mevcuttur.';
		|en='Description%1 ""%2"" is already in use.';
		|ru='Наименование(%1) ""%2"" уже используется.'", Lang));
	
	// %1 - Boots
	// %2 - Red XL
	// %3 - ordered
	// %4 - 11
	// %5 - 15
	// %6 - 4
	// %7 - pcs
	Strings.Insert("Error_090", NStr("tr='[%1 %2] %3 kalan: %4 %7. İhtiyaç: %5 %7. Eksik: %6 %7.';
		|en='[%1 %2] %3 remaining: %4 %7. Required: %5 %7. Lacking: %6 %7.';
		|ru='[%1 %2] %3 остаток: %4 %7. Требуется: %5 %7. Не хватает: %6 %7.'", Lang));

	// %1 - Boots
	// %2 - Red XL
	// %3 - 0001
	// %3 - ordered
	// %4 - 11
	// %5 - 15
	// %6 - 4
	// %7 - pcs
	Strings.Insert("Error_090_2", NStr("tr='[%1 %2] Seri lot numarası [%3] %4 kalan: %5 %6. İhtiyaç duyulan: %6 %8. Eksik: %7 %8.';
		|en='[%1 %2] Serial lot number [%3] %4 remaining: %5 %6. Required: %6 %8. Lacking: %7 %8.';
		|ru='[%1 %2] серийный номер [%3] %4 остаток: %5 %6. Требуется: %6 %8. Недостаток: %7 %8.'", Lang));

	Strings.Insert("Error_091", NStr("tr='Sadece sistem yöneticiler kullanıcıları oluşturabilir.';
		|en='Only Administrator can create users.';
		|ru='Только Администраторы могут создавать пользователей'", Lang));

	Strings.Insert("Error_092", NStr("tr='%1 rolü SaaS modunda kullanılamaz';
		|en='Can not use %1 role in SaaS mode';
		|ru='Роль %1 нельзя использовать в Saas режиме'", Lang));
	Strings.Insert("Error_093", NStr("tr='Satır iptal olduğunda iptal sebebi doldurulmalıdır';
		|en='Cancel reason has to be filled if string was canceled';
		|ru='Если строка отменена, необходимо указать причину отмены'", Lang));
	Strings.Insert("Error_094", NStr("tr='Satın alma irsaliyesi olmadan sevk irsaliyesi oluşturulamaz';
		|en='Can not use confirmation of shipment without goods receipt';
		|ru='Нельзя вводить расходную накладную, без приходной накладной по данному виду отгрузки'", Lang));
	
	// %1 - 100.00 
	// %2 - 120.00
	Strings.Insert("Error_095", NStr("tr='[%1] ödeme tutarı [%2] satış tutarına eşit değil';
		|en='Payment amount [%1] and sales amount [%2] not match';
		|ru='Сумма оплаты [%1] не равна сумме продажи [%2] '", Lang));
	
	// %1 - 1
	// %2 - Boots
	// %3 - Red XL
	Strings.Insert("Error_096", NStr("tr='Bağlantı sağlanmış satır silinemez [%1] [%2] [%3]';
		|en='Can not delete linked row [%1] [%2] [%3]';
		|ru='Невозможно удалить залинкованную строку [%1] [%2] [%3]'", Lang));

	// %1 - 1
	// %2 - Boots
	// %3 - Red XL
	Strings.Insert("Error_097", NStr("tr='Yanlış bağlantı sağlanan satır [%1] [%2] [%3]';
		|en='Wrong linked row [%1] [%2] [%3]';
		|ru='Неверно залинкованна строка  [%1] [%2] [%3]'", Lang));
	
	// %1 - 1
	// %2 - Store
	// %3 - Store 01
	// %4 - Store 02
	Strings.Insert("Error_098", NStr("tr='Satır bağlatma hatası [%1] kolon [%2] kullanılan değer [%3] yanlış değer [%4]';
		|en='Wrong linked row [%1] for column [%2] used value [%3] wrong value [%4]';
		|ru='Неверно залинкованна строка [%1] для столбца [%2] использованное значение [%3] неправильное значение [%4]'", Lang));
	
	// %1 - Partner
	// %2 - Partner 01
	// %3 - Partner 02
	Strings.Insert("Error_099", NStr("tr='Yanlış bağlantı verisi [%1] kullanılan değer [%2] yanlış değer [%3]';
		|en='Wrong linked data [%1] used value [%2] wrong value [%3]';
		|ru='Неверно залинкованны данные [%1] используемое значение [%2] неправильное значение [%3]'", Lang));
	
	// %1 - Value 01
	// %2 - Value 02
	Strings.Insert("Error_100", NStr("tr='Yanlış bağlantı verisi, kullanılan değer [%1] yanlış değer [%2]';
		|en='Wrong linked data, used value [%1] wrong value [%2]';
		|ru='Неверно залинкованны данные, используемое значение [%1] неправильное значение [%2]'", Lang));
	
	Strings.Insert("Error_101", NStr("tr='Evrakı seçiniz';
		|en='Select any document';
		|ru='Необходимо выбрать документ'", Lang));
	Strings.Insert("Error_102", NStr("tr='Varsayılan dosya depolama yeri seçilmedi.';
		|en='Default file storage volume is not set.';
		|ru='Не указан том хранения файлов.'", Lang));
	Strings.Insert("Error_103", NStr("tr='%1 tanımlı değil.';
		|en='%1 is undefined.';
		|ru='%1 неопределен.'", Lang));
	Strings.Insert("Error_104", NStr("tr='[%1] evrakı eksi stok bakiyesine düştü';
		|en='Document [%1] have negative stock balance';
		|ru='По документу [%1] есть отрицательный остаток на складе'", Lang));
	Strings.Insert("Error_105", NStr("tr='[%1] evrakın bağlı evraklar mevcuttur';
		|en='Document [%1] already have related documents';
		|ru='У документа [%1] уже есть связанные документы'", Lang));
	Strings.Insert("Error_106", NStr("tr='Veri kilitlenemedi';
		|en='Can not lock data';
		|ru='Заблокировать данные не получилось'", Lang));
	Strings.Insert("Error_107", NStr("tr='Silmek için işaretlenen %1 servisi çağırıldı.';
		|en='You try to call deleted service %1.';
		|ru='Попытка вызвать сервис %1, который помеченн на удаление.'", Lang));
	Strings.Insert("Error_108", NStr("tr='Alan dolduruldu, fakat alanın boş olması gerekmtektedir.';
		|en='Field is filled, but it has to be empty.';
		|ru='Поле заполнено, но оно должно быть пустым'", Lang));
	Strings.Insert("Error_109", NStr("tr='Seri lot numara tanımı [ %1 ] şablona uymamaktadır, şablon: %2';
		|en='Serial lot number name [ %1 ] is not match template: %2';
		|ru='Наименование серийного номера [ %1 ] не соответствует шаблону: %2'", Lang) + Chars.LF);
	Strings.Insert("Error_110", NStr("tr='Bu seri lot numarasının hareketleti var, bu yüzden stok takip belirtisi değiştirilemez';
		|en='Current serial lot number already has movements, it can not disable stock detail option';
		|ru='Данный серийный номер уже имеет движения, нельзя отменять признак'", Lang) + Chars.LF);
	Strings.Insert("Error_111", NStr("tr='Dönem boştur [%1] : [%2]';
		|en='Period is empty [%1] : [%2]';
		|ru='Период не заполнен [%1] : [%2]'", Lang) + Chars.LF);
	Strings.Insert("Error_112", NStr("tr='Şirket ayarlarında defter tipi belirtilmemiş [%1]';
		|en='Not set ledger type by company [%1]';
		|ru='Не указан тип учета у организации [%1]'", Lang));
	Strings.Insert("Error_113", NStr("tr='Evrakta [ %1 ] seri lot numarası eşsiz olmalıdır';
		|en='Serial lot number [ %1 ] has to be unique at the document';
		|ru='Серийный номер [ %1 ] должен быть уникальным в документе'", Lang) + Chars.LF);
	Strings.Insert("Error_114", NStr("tr='""Maliyet tutarı"" zorunlu alan';
		|en='""Landed cost"" is a required field.';
		|ru='""Себестоимость"" это обязательное поле для заполнения'", Lang) + Chars.LF);
	Strings.Insert("Error_115", NStr("tr='Bağlantı test hatası';
		|en='Error while test connection';
		|ru='Ошибка при тестировании соединения'", Lang) + Chars.LF);
	Strings.Insert("Error_116", NStr("tr='Kaydetme iptal edilemedi, evrak [%1] tarafından kapanmıştı';
		|en='Cannot unpost, document is closed by [ %1 ]';
		|ru='Отказ отмены проведения, документ закрыт документом [%1]'", Lang) + Chars.LF);
	Strings.Insert("Error_117", NStr("tr='Başka güne ait iadeler desteklenmemektedir';
		|en='Sales return when sales by different dates not support';
		|ru='Не поддерживается возврат датой отличной от даты продажи'", Lang) + Chars.LF);
	Strings.Insert("Error_118", NStr("tr='Silmek için işaretlenemedi, evrak [%1] tarafından kapanmıştı';
		|en='Cannot set deletion makr, document is closed by [ %1 ]';
		|ru='Отказ пометки на удаление, документ закрыт документом [%1]'", Lang) + Chars.LF);
	Strings.Insert("Error_119", NStr("tr='EVAL kod hatası';
		|en='Error Eval code';
		|ru='Ошибка кода Выполнить'", Lang) + Chars.LF);
#EndRegion

#Region InfoMessages
	// %1 - Purchase invoice
	// %2 - Purchase order
	Strings.Insert("InfoMessage_001", NStr("tr='""%1"" belgesi, ""%2"" belgesiyle tam olarak eşleşmiyor çünkü
		|zaten bu ""%2"" belgesini kısmen kapsayan başka bir ""%1"" belgesi var.';
		|en='The ""%1"" document does not fully match the ""%2"" document because 
		|there is already another ""%1"" document that partially covered this ""%2"" document.';
		|ru='Созданный документ ""%1"" не совпадает с документом ""%2"" в силу того, что ранее
		| уже создан документ ""%1"", который частично закрыл документ ""%2"".'",
		Lang));
	// %1 - Boots
	Strings.Insert("InfoMessage_002", NStr("tr='%1 nesnesi oluşturuldu.';
		|en='Object %1 created.';
		|ru='Объект %1 создан.'", Lang));
	Strings.Insert("InfoMessage_003", NStr("tr='Bu bir hizmet formudur.';
		|en='This is a service form.';
		|ru='Это сервисная форма.'", Lang));
	Strings.Insert("InfoMessage_004", NStr("tr='Devam etmek için nesneyi kaydedin.';
		|en='Save the object to continue.';
		|ru='Для продолжения необходимо сохранить объект.'", Lang));
	Strings.Insert("InfoMessage_005", NStr("tr='Tamamlandı';
		|en='Done';
		|ru='Завершено'", Lang));
	
	// %1 - Physical count by location
	Strings.Insert("InfoMessage_006", NStr("tr='""%1"" belgesi zaten oluşturulmuş. Miktarı güncelleyebilirsiniz.';
		|en='The ""%1"" document is already created. You can update the quantity.';
		|ru='Документы ""%1"" уже созданы. Возможно использовать только функцию обновления количества.'", Lang));

	Strings.Insert("InfoMessage_007", NStr("tr='#%1 tarih: %2';
		|en='#%1 date: %2';
		|ru='#%1 дата: %2'", Lang));
	// %1 - 12
	// %2 - 20.02.2020
	Strings.Insert("InfoMessage_008", NStr("tr='#%1 tarih: %2';
		|en='#%1 date: %2';
		|ru='#%1 дата: %2'", Lang));

	Strings.Insert("InfoMessage_009", NStr("tr='Girilen ve sayılan toplam adet tutmadı. Lütfen bir daha sayın. Bir deneme daha var.';
		|en='Total quantity doesnt match. Please count one more time. You have one more try.';
		|ru='Общее количество не сходится. Введите еще раз. Осталась последняя попытка.'", Lang));
	Strings.Insert("InfoMessage_010", NStr("tr='Toplam miktar tutmuyor. Lokasyon tekrar okutulmalı (okutulan veri silinmişti).';
		|en='Total quantity doesnt match. Location need to be count again (current count is annulated).';
		|ru='Общее количество не совпадает. Локацию необходимо отсканировать заново (текущие данные очищены).'", Lang));
	Strings.Insert("InfoMessage_011", NStr("tr='Mevcut lokasyon ile ilgili girilen ve sayılan adet tuttu. Lütfen bir sonraki lokasyonu okutun.';
		|en='Total quantity is ok. Please scan and count next location.';
		|ru='Общее количество правильное. Можно начать работу со следующей локацией.'", Lang));
	
	// %1 - 12
	// %2 - Vasiya Pupkin
	Strings.Insert("InfoMessage_012", NStr("tr='Bu lokasyon (#%1) başka kullanıcı tarafından başlatıldı. Kullanıcı: %2';
		|en='Current location #%1 was started by another user. User: %2';
		|ru='Сканирование текущей локации %1 было начато другим пользователем. Пользователь: %2'", Lang));
	
	// %1 - 12
	Strings.Insert("InfoMessage_013", NStr("tr='#%1 lokasyon size atanmıştır. Diğer kullanıcılar bu lokasyonu okutamazlar.';
		|en='Current location #%1 was linked to you. Other users will not be able to scan it.';
		|ru='Текущая локация %1 закреплена за вами. Другие пользователи не смогут с ней работать.'", Lang));
	
	// %1 - 12
	Strings.Insert("InfoMessage_014", NStr("tr='Bu %1 lokasyon daha önce okutulmuş ve kapatılmıştı. Bir sonraki lokasyon okutunuz.';
		|en='Current location #%1 was scanned and closed before. Please scan next location.';
		|ru='Текущая локация (%1) уже была отсканирована и закрыта. Пожалуйста, отсканируйте следующую локацию .'", Lang));
	
	// %1 - 123456
	Strings.Insert("InfoMessage_015", NStr("tr='%1 seri numarası bulunamadı. Yeni oluşturmak ister misiniz?';
		|en='Serial lot %1 was not found. Create new?';
		|ru='Серийный номер %1 не найдет. Создать новый?'", Lang));

	// %1 - 123456
	// %2 - Some item
	Strings.Insert("InfoMessage_016", NStr("tr='Okutulan %1 barkod, başka malzeme (%2) için tanımlıdır.';
		|en='Scanned barcode %1 is using for another items %2';
		|ru='Отсканированный штрихкод %1 уже используется для номенклатуры %2'", Lang));
	
	// %1 - 123456
	Strings.Insert("InfoMessage_017", NStr("tr='Okutulan %1 barkod seri lot numara seti kullanmıyor';
		|en='Scanned barcode %1 is not using set for serial numbers';
		|ru='Отсканированный штрихкод %1 не используется для серийных номеров'", Lang));
	Strings.Insert("InfoMessage_018", NStr("tr='Seri seçin veya barkodu okutun';
		|en='Add or scan serial lot number';
		|ru='Добавьте серию или считайте штрихкод серии'", Lang));

	Strings.Insert("InfoMessage_019", NStr("tr='Veri değiştirme kısıtlama sebebi:';
		|en='Data lock reasons:';
		|ru='Причина запрета:'", Lang));

	Strings.Insert("InfoMessage_020", NStr("tr='Evrak oluştur: %1';
		|en='Created document: %1';
		|ru='Создан документ: %1'", Lang));
  
  	// %1 - 42
	Strings.Insert("InfoMessage_021", NStr("tr='Alan kilidi kaldırılamaz, nesne %1 kez kullanıldı, örneğin:';
		|en='Can not unlock attributes, this is element used %1 times, ex.:';
		|ru='Невозможно разблокировать реквизиты, данный элемент использовался %1 раз, например:'",
		Lang));
  	// %1 - 
	Strings.Insert("InfoMessage_022", NStr("tr='Bu sipariş %1 ile kapatılmıştı.';
		|en='This order is closed by %1';
		|ru='Этот заказ уже закрыт документом %1'", Lang));
	Strings.Insert("InfoMessage_023", NStr("tr='Satın alma irsaliyesi olmadan sevk irsaliyesi oluşturulamaz. Satın alma irsaliye devrede.';
		|en='Can not use confirmation of shipment without goods receipt. Use goods receipt mode is enabled.';
		|ru='Нельзя вводить расходную накладную, без приходной накладной по данному виду отгрузки. Включено использование приходной накладной.'", Lang));
	Strings.Insert("InfoMessage_024", NStr("tr='Kaydettikten sonra ulaşılabilir olacak';
		|en='Will be available after save.';
		|ru='Доступен к изменению после записи объекта.'", Lang));
	Strings.Insert("InfoMessage_025", NStr("tr='Barkod okutmadan önce lokasyon seçmek gerekir';
		|en='Before start to scan - choose location';
		|ru='Перед началом сканирования необходимо выбрать локацию'", Lang));
	Strings.Insert("InfoMessage_026", NStr("tr='Hizmet malzeme tipi eklenemez: %1';
		|en='Can not add Service item type: %1';
		|ru='Товар с типом сервис не добавлен: %1'", Lang));
	// %1 - 123123123
	// %2 - Item name
	// %3 - Item key
	// %4 - Serial lot number
	Strings.Insert("InfoMessage_027", NStr("tr='Barkod [%1] sistemde mevcut, malzeme: %2 [%3] %4';
		|en='Barcode [%1] is exists for item: %2 [%3] %4';
		|ru='Штрихкод [%1] существует для номенклатуры: %2 [%3] %4'", Lang));
	Strings.Insert("InfoMessage_028", NStr("tr='Yeni seri lot numarası [ %1 ] oluşturuldu, malzeme: [ %2 ]';
		|en='New serial [ %1 ] created for item key [ %2 ]';
		|ru='Новая серия [ %1 ] созданная для серийного номера [ %2 ]'", Lang));
	Strings.Insert("InfoMessage_029", NStr("tr='Bu seri lot numarası eşsizdir ve sadece tek bir defa evrakta kullanılabilir';
		|en='This is unique serial and it can be only one at the document';
		|ru='Это уникальный серийный номер, он должен быть в документе в количестве 1'", Lang));
	Strings.Insert("InfoMessage_030", NStr("tr='Seri lot barkodu değil, ürün barkodu okutunuz';
		|en='Scan barcode of Item, not serial lot numbers';
		|ru='Просканируйте штрихкод товара, а не серийного номера'", Lang));
	Strings.Insert("InfoMessage_031", NStr("tr='Görev devam etmek istediğinizden emin misiniz?';
		|en='Do you want to continue job?';
		|ru='Вы действительно хотите продолжить выполнение задания?'", Lang));
	Strings.Insert("InfoMessage_032", NStr("tr='Görev duraklamak istediğinizden emin misiniz?';
		|en='Do you want to pause job?';
		|ru='Вы действительно хотите поставить выполнение задания на паузу?'", Lang));
	Strings.Insert("InfoMessage_033", NStr("tr='Görev durdurmak istediğinizden emin misiniz?';
		|en='Do you want to stop job?';
		|ru='Вы действительно хотите остановить задание?'", Lang));
#EndRegion

#Region QuestionToUser
	Strings.Insert("QuestionToUser_001", NStr("tr='Devam etmek için nesneyi yazın. Devam edilsin mi?';
		|en='Write the object to continue. Continue?';
		|ru='Для продолжения необходимо сохранить объект. Продолжить?'", Lang));
	Strings.Insert("QuestionToUser_002", NStr("tr='Tarama moduna geçmek istiyor musunuz?';
		|en='Do you want to switch to scan mode?';
		|ru='Переключиться в режим сканирования?'", Lang));
	Strings.Insert("QuestionToUser_003", NStr("tr='Doldurulmuş çek/senet bilgiler temizlenecek. %1 güncellemek ister misiniz?';
		|en='Filled data on cheque bonds transactions will be deleted. Do you want to update %1?';
		|ru='Заполненные данные по чекам будут очищены. Обновить %1? '", Lang));
	Strings.Insert("QuestionToUser_004", NStr("tr='Vergileri sözleşmeye göre değiştirmek ister misiniz?';
		|en='Do you want to change tax rates according to the partner term?';
		|ru='Изменить налоговые ставки в соответствии с соглашением?'",
		Lang));
	Strings.Insert("QuestionToUser_005", NStr("tr='Tüm depoları güncellemek ister misiniz?';
		|en='Do you want to update filled stores?';
		|ru='Обновить заполненные склады?'", Lang));
	Strings.Insert("QuestionToUser_006", NStr("tr='Doldurulan para birimini güncellemek istiyor musunuz?';
		|en='Do you want to update filled currency?';
		|ru='Обновить заполненные цены'", Lang));
	Strings.Insert("QuestionToUser_007", NStr("tr='İşlemler tablosu temizlenecek. Devam etmek ister misiniz?';
		|en='Transaction table will be cleared. Continue?';
		|ru='Таблица транзакций будет очищена. Продолжить?'", Lang));
	Strings.Insert("QuestionToUser_008", NStr("tr='Para birimini değiştirmek, nakit transferi belgelerini içeren satırları temizleyecektir. Devam ediyor muyuz?';
		|en='Changing the currency will clear the rows with cash transfer documents. Continue?';
		|ru='При изменении валюты заполненные строки будут отвязаны от документа перемещения денежных средств. Продолжить?'", Lang));
	Strings.Insert("QuestionToUser_009", NStr("tr='Dolu depoları %1 deposu ile değiştirmek ister misiniz?';
		|en='Do you want to replace filled stores with store %1?';
		|ru='Хотите заменить текущие склады на склад: %1?'", Lang));
	Strings.Insert("QuestionToUser_011", NStr("tr='Dolu fiyat tipleri %1 fiyat tipi ile değiştirmek ister misiniz?';
		|en='Do you want to replace filled price types with price type %1?';
		|ru='Хотите заменить текущие типы цен на : %1?'",
		Lang));
	Strings.Insert("QuestionToUser_012", NStr("tr='Çıkmak istediğinizden emin misiniz?';
		|en='Do you want to exit?';
		|ru='Вы действительно хотите выйти?'", Lang));
	Strings.Insert("QuestionToUser_013", NStr("tr='Doldurulmuş fiyatları güncellemek istiyor musunuz?';
		|en='Do you want to update filled prices?';
		|ru='Обновить заполненные цены?'", Lang));
	Strings.Insert("QuestionToUser_014", NStr("tr='İşlem türü değiştirildi. Doldurulmuş verileri güncellemek istiyor musunuz?';
		|en='Transaction type is changed. Do you want to update filled data?';
		|ru='Тип операции изменен. Обновить заполненные данные? '",
		Lang));
	Strings.Insert("QuestionToUser_015", NStr("tr='Doldurulan veriler silinecektir. Devam edilsin mi?';
		|en='Filled data will be cleared. Continue?';
		|ru='Заполненные данные будут очищены. Продолжить?'", Lang));
	Strings.Insert("QuestionToUser_016", NStr("tr='Simgeyi değiştirmek mi yoksa temizlemek mi istiyorsunuz?';
		|en='Do you want to change or clear the icon?';
		|ru='Заменить или удалить иконку?'", Lang));
	Strings.Insert("QuestionToUser_017", NStr("tr='Kaç tane evrak oluşturulsun?';
		|en='How many documents to create?';
		|ru='Сколько немобходимо создать документов?'", Lang));
	Strings.Insert("QuestionToUser_018", NStr("tr='Toplam lokasyon adedini giriniz';
		|en='Please enter total quantity';
		|ru='Введите пожалуйста общее количество'", Lang));
	Strings.Insert("QuestionToUser_019", NStr("tr='Ödeme şekli güncellemek ister misiniz?';
		|en='Do you want to update payment term?';
		|ru='Хотите обновить условия оплаты?'", Lang));
	Strings.Insert("QuestionToUser_020", NStr("tr='Daha önce kaydedilmiş seçeneği ezip kaydetmek ister misiniz?';
		|en='Do you want to overwrite saved option?';
		|ru='Хотите перезаписать сохраненный вариант?'", Lang));
	Strings.Insert("QuestionToUser_021", NStr("tr='Bu formu kapatmak istediğinizden emin misiniz? Tüm değişiklikler geri alınacaktır.';
		|en='Do you want to close this form? All changes will be lost.';
		|ru='Вы хотите закрыть текущую форму? Все изменения будут потеряны.'", Lang));
	Strings.Insert("QuestionToUser_022", NStr("tr='Dosya yüklemek ister misiniz?';
		|en='Do you want to upload this files';
		|ru='Вы хотите загрузить эти файлы?'", Lang) + ": " + Chars.LF + "%1");
	Strings.Insert("QuestionToUser_023", NStr("tr='Kas/banka transfer fişine göre doldurulsun mu?';
		|en='Do you want to fill according to cash transfer order?';
		|ru='Перезаполнить по перемещению денежных средств?'", Lang));
#EndRegion

#Region SuggestionToUser
	Strings.Insert("SuggestionToUser_1", NStr("tr='Bir değer seçin';
		|en='Select a value';
		|ru='Выберите значение'", Lang));
	Strings.Insert("SuggestionToUser_2", NStr("tr='Bir barkod giriniz';
		|en='Enter a barcode';
		|ru='Введите штрихкод'", Lang));
	Strings.Insert("SuggestionToUser_3", NStr("tr='Bir seçenek adı giriniz';
		|en='Enter an option name';
		|ru='Наименование параметра ввода'", Lang));
	Strings.Insert("SuggestionToUser_4", NStr("tr='Yeni bir seçenek adı giriniz';
		|en='Enter a new option name';
		|ru='Введите новое наименование параметра'", Lang));
#EndRegion

#Region UsersEvent
	Strings.Insert("UsersEvent_001", NStr("tr='Kullanıcı, %1 UUID ve %2 adı ile bulunamadı.';
		|en='User not found by UUID %1 and name %2.';
		|ru='Пользователь по UUID %1 и имени %2не найден.'", Lang));
	Strings.Insert("UsersEvent_002", NStr("tr='Kullanıcı, %1 UUID ve %2 adı tarafından bulundu.';
		|en='User found by UUID %1 and name %2.';
		|ru='Пользователь по UUID %1 и имени %2 найден.'", Lang));
#EndRegion

#Region Items
	
	// Interface
	Strings.Insert("I_1", NStr("tr='Açıklama giriniz';
		|en='Enter description';
		|ru='Введите Наименование'", Lang));
	Strings.Insert("I_2", NStr("tr='Açıklama girmek için tıklayın';
		|en='Click to enter description';
		|ru='Нажмите для заполнения'", Lang));
	Strings.Insert("I_3", NStr("tr='Belgeyi doldurunuz';
		|en='Fill out the document';
		|ru='Заполните документ'", Lang));
	Strings.Insert("I_4", NStr("tr='Tabloda %2 anahtara göre %1 bulmak';
		|en='Find %1 rows in table by key %2';
		|ru='Найти %1 строк в таблице по ключу %2'", Lang));
	Strings.Insert("I_5", NStr("tr='Desteklenmeyen tablo';
		|en='Not supported table';
		|ru='Не поддерживаемая таблица'", Lang));
	Strings.Insert("I_6", NStr("tr='Normal sipariş';
		|en='Ordered without ISR';
		|ru='Заказано без ЗОТ'", Lang));

#EndRegion

#Region Exceptions
	Strings.Insert("Exc_001", NStr("tr='Desteklenmeyen nesne türü.';
		|en='Unsupported object type.';
		|ru='Неподдерживаемый тип объекта.'", Lang));
	Strings.Insert("Exc_002", NStr("tr='Koşul yok';
		|en='No conditions';
		|ru='Без условий'", Lang));
	Strings.Insert("Exc_003", NStr("tr='Yöntem uygulanmadı: %1.';
		|en='Method is not implemented: %1.';
		|ru='Метод не реализован: %1.'", Lang));
	Strings.Insert("Exc_004", NStr("tr='Nesneden para birimi çıkarılamıyor.';
		|en='Cannot extract currency from the object.';
		|ru='Валюта из объекта не извлечена.'", Lang));
	Strings.Insert("Exc_005", NStr("tr='Kütüphane adı boş.';
		|en='Library name is empty.';
		|ru='Наименование библиотеки не заполнено.'", Lang));
	Strings.Insert("Exc_006", NStr("tr='Kütüphane veriler sürümü içermiyor.';
		|en='Library data does not contain a version.';
		|ru='Данные библиотеки не содержат версии.'", Lang));
	Strings.Insert("Exc_007", NStr("tr='%1 kütüphane sürümü için geçerli değil.';
		|en='Not applicable for library version %1.';
		|ru='Не применимо для версии библиотеки: %1.'", Lang));
	Strings.Insert("Exc_008", NStr("tr='Bilinmeyen satır anahtarı.';
		|en='Unknown row key.';
		|ru='Неизвестный ключ строки.'", Lang));
	Strings.Insert("Exc_009", NStr("tr='Hata: %1';
		|en='Error: %1';
		|ru='Ошибка: %1'", Lang));
#EndRegion

#Region Saas
	// %1 - 12
	Strings.Insert("Saas_001", NStr("tr='%1 alanı bulunamadı.';
		|en='Area %1 not found.';
		|ru='Рабочая область %1 не найдена.'", Lang));
	
	// %1 - closed
	Strings.Insert("Saas_002", NStr("tr='Alan durumu:%1.';
		|en='Area status: %1.';
		|ru='Статус рабочей области: %1.'", Lang));
	
	// %1 - en
	Strings.Insert("Saas_003", NStr("tr='Şirketin %1 yerelleştirmesi mevcut değil. ';
		|en='Localization %1 of the company is not available.';
		|ru='Локализация компании %1 не доступна.'", Lang));

	Strings.Insert("Saas_004", NStr("tr='Bölge hazırlaması tamamlandı.';
		|en='Area preparation completed';
		|ru='Подготовка области завершена'", Lang));
#EndRegion

#Region FillingFromClassifiers
    // Do not modify "en" strings
	Strings.Insert("Class_001", NStr("tr='Alım fiyatı';
		|en='Purchase price';
		|ru='Цена закупки'", Lang));
	Strings.Insert("Class_002", NStr("tr='Satış fiyatı';
		|en='Sales price';
		|ru='Цена продажи'", Lang));
	Strings.Insert("Class_003", NStr("tr='Birim maliyet fiyatı';
		|en='Prime cost';
		|ru='Себестоимость'", Lang));
	Strings.Insert("Class_004", NStr("tr='Servis';
		|en='Service';
		|ru='Сервис'", Lang));
	Strings.Insert("Class_005", NStr("tr='Malzeme';
		|en='Product';
		|ru='Товар'", Lang));
	Strings.Insert("Class_006", NStr("tr='Ana depo';
		|en='Main store';
		|ru='Главный склад'", Lang));
	Strings.Insert("Class_007", NStr("tr='Ana sorumlu';
		|en='Main manager';
		|ru='Главный менеджер'", Lang));
	Strings.Insert("Class_008", NStr("tr='adet';
		|en='pcs';
		|ru='шт'", Lang));
#EndRegion

#Region Titles
	// %1 - Cheque bond transaction
	Strings.Insert("Title_00100", NStr("tr='""%1"" belgesindeki ana belgeleri seçin.';
		|en='Select base documents in the ""%1"" document.';
		|ru='Выбор документов-оснований в документе ""%1""'", Lang));	// Form PickUpDocuments
#EndRegion

#Region ChoiceListValues
	Strings.Insert("CLV_1", NStr("tr='Tümü';
		|en='All';
		|ru='Все'", Lang));
#EndRegion

#Region SalesOrderStatusReport
	Strings.Insert("SOR_1", NStr("tr='Serbest stok bakiyesi yetersizdir';
		|en='Not enough items in free stock';
		|ru='Не достаточно товара на остатках'", Lang));
#EndRegion

#Region Report
	Strings.Insert("R_001", NStr("tr='Varyant';
		|en='Item key';
		|ru='Характеристика'", Lang) + " = ");
	Strings.Insert("R_002", NStr("tr='Özellik';
		|en='Property';
		|ru='Свойство'", Lang) + " = ");
	Strings.Insert("R_003", NStr("tr='Malzeme';
		|en='Item';
		|ru='Номенклатура'", Lang) + " = ");
	Strings.Insert("R_004", NStr("tr='Ürün reçetesi';
		|en='Specification';
		|ru='Спецификация товара'", Lang) + " = ");
#EndRegion

#Region Defaults
	Strings.Insert("Default_001", NStr("tr='adet';
		|en='pcs';
		|ru='шт'", Lang));
	Strings.Insert("Default_002", NStr("tr='Müşteri standart sözleşmesi';
		|en='Customer standard term';
		|ru='Стандартное соглашение для покупателей'", Lang));
	Strings.Insert("Default_003", NStr("tr='Standart tedarikçi sözleşmesi';
		|en='Vendor stabdard term';
		|ru='Стандартное соглашение для поставщиков'", Lang));
	Strings.Insert("Default_004", NStr("tr='Müşteri fiyat tipi';
		|en='Customer price type';
		|ru='Тип цен покупателя'", Lang));
	Strings.Insert("Default_005", NStr("tr='Tedarikçi fiyat tipi';
		|en='Vendor price type';
		|ru='Тип цен поставщика'", Lang));
	Strings.Insert("Default_006", NStr("tr='Cari hesap sözleşme dövizi';
		|en='Partner term currency type';
		|ru='Валюта соглашения'", Lang));
	Strings.Insert("Default_007", NStr("tr='Local döviz tipi';
		|en='Legal currency type';
		|ru='Локальныей тип валют'", Lang));
	Strings.Insert("Default_008", NStr("tr='Amerika doları';
		|en='American dollar';
		|ru='Доллар США'", Lang));
	Strings.Insert("Default_009", NStr("tr='USD';
		|en='USD';
		|ru='USD'", Lang));
	Strings.Insert("Default_010", NStr("tr='$';
		|en='$';
		|ru='$'", Lang));
	Strings.Insert("Default_011", NStr("tr='Benim şirketim';
		|en='My Company';
		|ru='Моя организация'", Lang));
	Strings.Insert("Default_012", NStr("tr='Benim depom';
		|en='My Store';
		|ru='Мой склад'", Lang));
#EndRegion

	Return Strings;
EndFunction
