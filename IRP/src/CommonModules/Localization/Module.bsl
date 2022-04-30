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
	Strings.Insert("Eq_001", NStr("ru='Установлен';
		|en='Installed';
		|tr='Kuruldu'", Lang));
	Strings.Insert("Eq_002", NStr("en='Not installed';
		|ru='Не установлен';
		|tr='Kurulmadı'", Lang));
	Strings.Insert("Eq_003", NStr("ru='Ошибок нет.';
		|en='There are no errors.';
		|tr='Bir hata tespit edilemedi.'", Lang));
	Strings.Insert("Eq_004", NStr("en='Scanner is connected.';
		|ru='Сканер подключен.';
		|tr='Barkod okuyucusu başarılya bağlandı.'", Lang));
	Strings.Insert("Eq_005", NStr("ru='Ошибка. Сканер не подключен.';
		|en='Error. Scanner not connected.';
		|tr='Hata. Barkod okuyucusu bağlanamadı'", Lang));
	Strings.Insert("Eq_006", NStr("en='Installed on current PC.';
		|ru='Установить на текущий компьютер';
		|tr='Bu bilgisayara kurulmuştu.'", Lang));
	Strings.Insert("Eq_007", NStr("ru='Не получилось подключить оборудование %1';
		|en='Can not connect device %1';
		|tr='Cihaz bağlanamadı %1'", Lang));

	Strings.Insert("EqError_001", NStr("ru='Устройство подключено. Устройство должно быть отключено перед началом работы.';
		|en='The device is connected. The device must be disabled before the operation.';
		|tr='Cihaz bağlandı. İşlemden önce cihaz devre dışı bırakılmalı.'", Lang));

	Strings.Insert("EqError_002", NStr("en='The device driver could not be downloaded.
		|Check that the driver is correctly installed and registered in the system.';
		|ru='Драйвер устройства не может быть загружен. 
		|Проверьте, что драйвер правильно установлен и зарегистрирован в системе.';
		|tr='Cihaz sürücüsü yüklenemedi.
		|Sürücünün düzgün kurulduğundan ve sistemde kayıtlı (registered) olduğundan emin olunuz.'",
		Lang));

	Strings.Insert("EqError_003", NStr("ru='Необходимо иметь минимум одну точку в доп. ID.';
		|en='It has to be minimum one dot at Add ID.';
		|tr='Ek ID''de minimum bir nokta olmalıdır.'", Lang));
	Strings.Insert("EqError_004", NStr("en='Before install driver - it has to be loaded.';
		|ru='Перед тем как установить драйвер, он должен быть загружен.';
		|tr='Sürücü yükemeden öncesi indirmek lazım.'", Lang));
	Strings.Insert("EqError_005", NStr("ru='У драйвера оборудования %1 неправильный AddIn ID %2.';
		|en='The equipment driver %1 has incorrect AddIn ID %2.';
		|tr='Donanım %1 sürücüsü yanlış AddIn ID %2 bilgisine sahiptir.'", Lang));
#EndRegion

#Region POS

	Strings.Insert("POS_s1", NStr("en='Amount paid is less than amount of the document';
		|ru='Сумма оплаты меньше суммы документа';
		|tr='Ödeme tutarı satış tutarından daha küçüktür'", Lang));
	Strings.Insert("POS_s2", NStr("ru='Сумма оплат по безналичному расчету больше суммы документа';
		|en='Card fees are more than the amount of the document';
		|tr='Kart ile ödeme tutarı satış tutarından daha büyüktür'", Lang));
	Strings.Insert("POS_s3", NStr("en='There is no need to use cash, as card payments are sufficient to pay';
		|ru='Суммы по безналичному расчету для оплаты достаточно. Нет необходимости дополнительно использовать наличный расчет. ';
		|tr='Nakit tutar girmenize gerek yok, çünkü kart ile alınan ödeme yeterlidir'", Lang));
	Strings.Insert("POS_s4", NStr("ru='Суммы оплат некорректны';
		|en='Amounts of payments are incorrect';
		|tr='Ödeme tutarlarda hata var'", Lang));
	Strings.Insert("POS_s5", NStr("en='Select sales person';
		|ru='Выбрать продавца';
		|tr='Satış elemanı seç'", Lang));
#EndRegion

#Region Service
	
	// %1 - localhost
	// %2 - 8080 
	// %3 - There is no internet connection
	Strings.Insert("S_002", NStr("en='Cannot connect to %1:%2. Details: %3';
		|ru='Не получается подключиться к %1:%2. Подробности: %3.';
		|fr='Impossible de se connecter à %1 : %2. Détails : %3';
		|tr='%1:%2 ile bağlantı kurulamıyor. Ayrıntılar:%3';
		|de='Verbindung mit %1:%2 kann nicht hergestellt werden. Details: %3'", Lang));
	
	// %1 - localhost
	// %2 - 8080
	Strings.Insert("S_003", NStr("fr='Réponse reçue du %1 : %2';
		|en='Received response from %1:%2';
		|ru='Полученный ответ от %1:%2';
		|tr='%1:%2 tarafından yanıt alındı';
		|de='Erhaltene Antwort von %1: %2'", Lang));
	Strings.Insert("S_004", NStr("en='Resource address is empty.';
		|ru='Адрес ресурса не заполнен.';
		|fr='L’adresse de la ressource est vide.';
		|tr='Kaynak adresi boş.';
		|de='Ressourcenadresse ist leer.'", Lang));
	
	// %1 - connection_to_other_system
	Strings.Insert("S_005", NStr("en='Integration setting with name %1 is not found.';
		|ru='Настройки интеграции с наименованием %1 не найдены.';
		|fr='Paramètre d''intégration avec le nom %1 est introuvable.';
		|tr='%1 adıyla entegrasyon ayarı bulunamadı.';
		|de='Die Integrationseinstellung mit dem Namen %1 wurde nicht gefunden.'", Lang));
	Strings.Insert("S_006", NStr("ru='В web клиенте метод не поддерживается.';
		|fr='La méthode n''est pas prise en charge dans le client Web.';
		|en='Method is not supported in Web Client.';
		|tr='Yöntem Web İstemcisinde desteklenmiyor';
		|de='Die Methode ist im Web-Client nicht unterstützt.'", Lang));
	
	// Special offers
	Strings.Insert("S_013", NStr("ru='Неподдерживаемый тип объекта: %1.';
		|en='Unsupported object type: %1.';
		|fr='Type d''objet non pris en charge : %1.';
		|tr='Desteklenmeyen nesne türü: %1.';
		|de='Nicht unterstützter Objekttyp: %1.'", Lang));
	
	// FileTransfer
	Strings.Insert("S_014", NStr("fr='Le nom de fichier est vide.';
		|ru='Имя файла не заполнено';
		|en='File name is empty.';
		|tr='Dosya adı boş.';
		|de='Dateiname ist leer.'", Lang));
	Strings.Insert("S_015", NStr("en='Path for saving is not set.';
		|ru='Путь сохранения не установлен.';
		|fr='Le chemin pour l''enregistrement n''est pas défini.';
		|tr='Kaydetme yolu belirlenmemiş.';
		|de='Der Pfad zum Speichern ist nicht festgelegt.'", Lang));
	
	// Test connection
	// %1 - Method unsupported on web client
	// %2 - 404
	// %3 - Text frim site
	Strings.Insert("S_016", NStr("fr='%1 Code statut : %2 %3';
		|en='%1 Status code: %2 %3';
		|ru='%1 Статус код: %2 %3';
		|tr='%1 Durum kodu: %2 %3';
		|de='%1 Statuscode: %2%3'", Lang));
	
	//	scan barcode
	Strings.Insert("S_018", NStr("fr='Article ajouté.';
		|en='Item added.';
		|ru='Номенклатура добавлена.';
		|tr='Malzeme eklendi.';
		|de='Das Produkt hinzugefügt.'", Lang)); 
	
	// %1 - 123123123123
	Strings.Insert("S_019", NStr("en='Barcode %1 not found.';
		|ru='Штрихкод %1 не найден.';
		|fr='Le code-barres %1 introuvable.';
		|tr='%1 barkodu bulunamadı.';
		|de='Der Barcode %1 nicht gefunden.'", Lang));
	Strings.Insert("S_022", NStr("fr='Les devises dans les documents de base doivent correspondre.';
		|en='Currencies in the base documents must match.';
		|ru='Валюты в документах-основания должны совпадать.';
		|tr='Ana belgelerdeki para birimleri eşleşmelidir.';
		|de='Die Währungen in den Basisdokumenten müssen übereinstimmen.'", Lang));
	Strings.Insert("S_023", NStr("ru='Метод обеспечения';
		|fr='Méthode d''approvisionnement';
		|en='Procurement method';
		|tr='Tedarik şekli';
		|de='Beschaffungsmethode'", Lang));

	Strings.Insert("S_026", NStr("fr='L''icône sélectionnée sera redimensionnée à 16x16 px.';
		|en='Selected icon will be resized to 16x16 px.';
		|ru='Размер выбранной иконки будет изменен до 16x16 px.';
		|tr='Seçilen simge 16x16 piksel olarak yeniden boyutlandırılacaktır.';
		|de='Die Größe des ausgewählten Symbols wird auf 16x16 Pixel geändert.'", Lang));

	// presentation of empty value for query result
	Strings.Insert("S_027", NStr("en='[Not filled]';
		|ru='[не заполнено]';
		|fr='Non rempli';
		|tr='[ Doldurulmamış ]';
		|de='[Nicht ausgefüllt]'", Lang));
	// operation is Success
	Strings.Insert("S_028", NStr("en='Success';
		|ru='Успешно';
		|tr='Başarılı'", Lang));
	Strings.Insert("S_029", NStr("en='Not supporting web client';
		|ru='Не поддерживаемый wreb клиент';
		|tr='Desteklenmeyen web istemci'", Lang));
	Strings.Insert("S_030", NStr("fr='Monnaie';
		|ru='Сдача';
		|en='Cashback';
		|tr='Para üstü';
		|de='Rückgeld'", Lang));
	Strings.Insert("S_031", NStr("ru='или';
		|en='or';
		|tr='veya'", Lang));
	Strings.Insert("S_032", NStr("ru='Добавить код, например: ТекущаяДатаСеанса ()';
		|en='Add code, ex: CurrentSessionDate()';
		|tr='Kod ekle, örneğin: CurrentSessionDate()'", Lang));
#EndRegion

#Region Service
	Strings.Insert("Form_001", NStr("fr='Nouvelle page';
		|ru='Новая страница';
		|en='New page';
		|tr='Yeni sayfa';
		|de='Neue Seite'", Lang));
	Strings.Insert("Form_002", NStr("fr='Supprimer';
		|ru='Пометить на удаление/Снять пометку';
		|en='Delete';
		|tr='Kaldır';
		|de='Löschen'", Lang));
	Strings.Insert("Form_003", NStr("en='Quantity';
		|ru='Количество';
		|fr='Quantité';
		|tr='Miktar';
		|de='Erwartete Anzahl'", Lang));
	Strings.Insert("Form_004", NStr("en='Customers terms';
		|fr='Accords avec les clients';
		|ru='Соглашения с клиентами';
		|tr='Müşteri anlaşmaları';
		|de='Vereinbarungen mit Kunden'", Lang));
	Strings.Insert("Form_005", NStr("fr='Clients';
		|ru='Клиенты';
		|en='Customers';
		|tr='Müşteriler';
		|de='Kunden'", Lang));
	Strings.Insert("Form_006", NStr("en='Vendors';
		|ru='Поставщики';
		|fr='Fournisseurs';
		|tr='Tedarikçiler';
		|de='Lieferanten'", Lang));
	Strings.Insert("Form_007", NStr("ru='Соглашения с поставщиками';
		|fr='Accords avec les fournisseurs';
		|en='Vendors terms';
		|tr='Tedarikçi anlaşması';
		|de='Vereinbarungen mit Lieferanten'", Lang));
	Strings.Insert("Form_008", NStr("fr='Utilisateur';
		|ru='Пользователь';
		|en='User';
		|tr='Kullanıcı';
		|de='Benutzer'", Lang));
	Strings.Insert("Form_009", NStr("en='User group';
		|ru='Группа пользователей';
		|fr='Groupe d''utilisateurs';
		|tr='Kullanıcı grubu';
		|de='Benutzergruppe'", Lang));
	Strings.Insert("Form_013", NStr("en='Date';
		|fr='Date';
		|ru='Дата';
		|tr='Tarih';
		|de='Datum'", Lang));
	Strings.Insert("Form_014", NStr("fr='Numéro';
		|en='Number';
		|ru='Номер';
		|tr='Numara';
		|de='Nummer'", Lang));
	
	// change icon
	Strings.Insert("Form_017", NStr("ru='Изменить';
		|en='Change';
		|fr='Changer';
		|tr='Değiştir';
		|de='Ändern'", Lang));
	
	// clear icon
	Strings.Insert("Form_018", NStr("en='Clear';
		|ru='Очистить';
		|fr='Effacer';
		|tr='Temizle';
		|de='Löschen'", Lang));
	
	// cancel answer on question
	Strings.Insert("Form_019", NStr("ru='Отмена';
		|fr='Annuler';
		|en='Cancel';
		|tr='İptal';
		|de='Abbrechen'", Lang));
	
	// PriceInfo report 
	Strings.Insert("Form_022", NStr("ru='1. По характеристике номенклатуры';
		|fr='1. Par clés d''article';
		|en='1. By item keys';
		|tr='1. Varyantlara göre';
		|de='1. Nach Artikelvarianten'", Lang));
	Strings.Insert("Form_023", NStr("fr='2. Par propriétés';
		|en='2. By properties';
		|ru='2. По свойствам';
		|tr='2. Özelliklere göre';
		|de='2. Nach Eigenschaften'", Lang));
	Strings.Insert("Form_024", NStr("ru='3. По номенклатуре';
		|en='3. By items';
		|fr='3. Par articles';
		|tr='3. Malzemelere göre';
		|de='3. Nach Produkten'", Lang));

	Strings.Insert("Form_025", NStr("fr='Créer à partir du classificateur';
		|en='Create from classifier';
		|ru='Создать по классификатору';
		|tr='Sınıflandırıcıdan oluştur';
		|de='Aus Klassifizierer erstellen'", Lang));

	Strings.Insert("Form_026", NStr("en='Item Bundle';
		|fr='Article de l''offre groupée';
		|ru='Номенклатура набора';
		|tr='Malzeme Paketi';
		|de='Bündelprodukt'", Lang));
	Strings.Insert("Form_027", NStr("fr='Article';
		|ru='Номенклатура';
		|en='Item';
		|tr='Malzeme';
		|de='Produkt'", Lang));
	Strings.Insert("Form_028", NStr("en='Item type';
		|fr='Type d''article';
		|ru='Вид номенклатуры';
		|tr='Malzeme tipi';
		|de='Elementtyp'", Lang));
	Strings.Insert("Form_029", NStr("fr='Attributs externes';
		|ru='Внешние реквизиты';
		|en='External attributes';
		|tr='Dış özellikler';
		|de='Externe Attribute'", Lang));
	Strings.Insert("Form_030", NStr("ru='Измерения';
		|en='Dimensions';
		|tr='Boyutlar'", Lang));
	Strings.Insert("Form_031", NStr("en='Weight information';
		|ru='Информация о весе';
		|tr='Ağırlık bilgisi'", Lang));
	Strings.Insert("Form_032", NStr("ru='Период';
		|en='Period';
		|fr='Période';
		|tr='Dönem';
		|de='Periode'", Lang));
	Strings.Insert("Form_033", NStr("en='Show all';
		|ru='Показать все';
		|tr='Tümü göster'", Lang));
	Strings.Insert("Form_034", NStr("en='Hide all';
		|ru='Скрыть все';
		|tr='Tümü sakla'", Lang));
	Strings.Insert("Form_035", NStr("en='Head';
		|ru='Шапка';
		|tr='Başlık'", Lang));
#EndRegion

#Region ErrorMessages

	// %1 - en
	Strings.Insert("Error_002", NStr("fr='Description %1 est vide';
		|ru='%1 наименование не заполнено';
		|en='%1 description is empty';
		|tr='%1 açıklaması boş';
		|de='%1 Beschreibung ist leer'", Lang));
	Strings.Insert("Error_003", NStr("en='Fill any description.';
		|fr='Complétez une description.';
		|ru='Заполните наименование.';
		|tr='Herhangi bir açıklama girininiz.';
		|de='Füllen Sie eine Beschreibung aus.'", Lang));
	Strings.Insert("Error_004", NStr("en='Metadata is not supported.';
		|ru='Метаданные не поддерживаются.';
		|fr='Les métadonnées ne sont pas prises en charge.';
		|tr='Meta veriler desteklenmiyor.';
		|de='Metadaten sind nicht unterstützt.'", Lang));
	
	// %1 - en
	Strings.Insert("Error_005", NStr("ru='Заполните наименование дополнительного реквизита %1.';
		|fr='Complétez la description de l''attribut supplémentaire %1.';
		|en='Fill the description of an additional attribute %1.';
		|tr='Ek bir %1 özniteliğinin açıklamasını doldurunuz.';
		|de='Füllen Sie eine Beschreibung des Zusatzattributs %1 aus.'", Lang));
	Strings.Insert("Error_008", NStr("ru='Группы создаются администратором.';
		|fr='Les groupes sont créés par un administrateur.';
		|en='Groups are created by an administrator.';
		|tr='Gruplar bir yönetici tarafından oluşturulur.';
		|de='Gruppen sind von einem Administrator erstellt.'", Lang));
	
	// %1 - Number 111 is not unique
	Strings.Insert("Error_009", NStr("ru='Ошибка при записи объекта: [%1].';
		|en='Cannot write the object: [%1].';
		|fr='Impossible d''écrire l''objet : [%1].';
		|tr='Nesne yazılamıyor: [%1].';
		|de='Das Objekt kann nicht geschrieben werden: [%1].'", Lang));
	
	// %1 - Number
	Strings.Insert("Error_010", NStr("en='Field [%1] is empty.';
		|fr='Le champ [%1] est vide.';
		|ru='Поле [%1] не заполнено.';
		|tr='[%1] alanı boş.';
		|de='Feld [%1] ist leer.'", Lang));
	Strings.Insert("Error_011", NStr("en='Add at least one row.';
		|ru='Нужно добавить хоть одну строку.';
		|fr='Ajoutez au moins une ligne.';
		|tr='En az bir satır ekleyin.';
		|de='Fügen Sie mindestens eine Zeile hinzu.'", Lang));
	Strings.Insert("Error_012", NStr("fr='La variable n''est pas nommée conformément aux règles.';
		|ru='Переменная названа не в соответствии с правилами.';
		|en='Variable is not named according to the rules.';
		|tr='Değişken, kurallara göre adlandırılmaz.';
		|de='Die Variable ist nicht gemäß den Regeln benannt.'", Lang));
	Strings.Insert("Error_013", NStr("en='Value is not unique.';
		|fr='La valeur n''est pas unique.';
		|ru='Значение не уникально.';
		|tr='Değer benzersiz değil.';
		|de='Der Wert ist nicht eindeutig.'", Lang));
	Strings.Insert("Error_014", NStr("ru='Пароль и подтверждение пароля не совпадают.';
		|fr='Le mot de passe et la confirmation du mot de passe ne correspondent pas.';
		|en='Password and password confirmation do not match.';
		|tr='Parola ve parola onayı eşleşmiyor.';
		|de='Das Kennwort und die Kennwortbestätigung stimmen nicht überein.'", Lang));

	// %1 - Sales order
	Strings.Insert("Error_016", NStr("ru='В документе ""%1"" не осталось товаров по которым необходимо сделать заказ поставщику.';
		|en='There are no more items that you need to order from suppliers in the ""%1"" document.';
		|fr='Il n''y a plus d''articles dans le document ""%1"" que vous devez commander auprès des fournisseurs.';
		|tr='""%1"" belgesinde tedarikçilerden sipariş etmeniz gereken başka ürün yok.';
		|de='Im Dokument ""%1"" gibt es keine weiteren Waren, die Sie von den Lieferanten bestellen müssen.'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_017", NStr("en='First, create a ""%1"" document or clear the ""%1 before %2"" check box on the ""Other"" tab.';
		|ru='Вначале необходимо создать документ ""%1"" или снять галочку ""%1 перед документом %2"" на вкладке ""Дополнительно"".';
		|fr='Tout d''abord, créez un document ""%1"" ou désactivez la case à cocher ""%1 avant %2"" dans l''onglet ""Autres"".';
		|tr='İlk olarak, bir ""%1"" belgesi oluşturun veya ""Diğer"" sekmesindeki ""%1 %2''den önce"" onay kutusunu temizleyin.';
		|de='Zunächst erstellen Sie ein Dokument ""%1"" oder deaktivieren Sie das Kontrollkästchen ""%1 vor der %2"" auf der Registerkarte ""Sonstiges"".'", Lang));

	// %1 - Shipment confirmation
	// %1 - Sales invoice
	Strings.Insert("Error_018", NStr("en='First, create a ""%1"" document or clear the ""%1 before %2"" check box on the ""Other"" tab.';
		|ru='Вначале необходимо создать документ ""%1"" или снять галочку ""%1 перед документом %2"" на вкладке ""Дополнительно"".';
		|fr='Tout d''abord, créez un document ""%1"" ou désactivez la case à cocher ""%1 avant %2"" dans l''onglet ""Autres"".';
		|tr='İlk olarak, bir ""%1"" belgesi oluşturun veya ""Diğer"" sekmesindeki ""%1 %2''den önce"" onay kutusunu temizleyin.';
		|de='Zunächst erstellen Sie ein Dokument ""%1"" oder deaktivieren Sie das Kontrollkästchen ""%1 vor der %2"" auf der Registerkarte ""Sonstiges"".'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_019", NStr("fr='Il n''y a pas de lignes pour lesquelles vous devez créer un document ""%1"" dans le document ""%2"".';
		|ru='Строки по которым необходимо создать документ ""%1"" отсутствуют в документе ""%2"".';
		|en='There are no lines for which you need to create a ""%1"" document in the ""%2"" document.';
		|tr='""%2"" belgesinde ""%1"" belgesi oluşturmanız gereken satır yok.';
		|de='Das Dokument ""%2"" enthält keine Zeilen, für die Sie ein Dokument ""%1"" erstellen müssen.'", Lang));

	// %1 - 12
	Strings.Insert("Error_020", NStr("ru='Необходимо заполнить документ-основания по строке %1.';
		|fr='Spécifiez un document de base pour la ligne %1.';
		|en='Specify a base document for line %1.';
		|tr='%1 satırı için bir ana belge belirtin.';
		|de='Geben Sie ein Basisdokument für Zeile %1 an.'", Lang));

	// %1 - Purchase invoice
	Strings.Insert("Error_021", NStr("ru='По всем товарам из выбранного документа ""%1"" уже был оформлен возврат.';
		|fr='Il n''y a pas de produits à retourner dans le document ""%1"". Tous les produits ont déjà été retournés.';
		|en='There are no products to return in the ""%1"" document. All products are already returned.';
		|tr='""%1"" belgesinde iade edilecek ürün yok. Tüm ürünler zaten iade edildi.';
		|de='Das Dokument ""%1"" enthält keine Produkte, die zurückgegeben werden müssen. Alle Produkte wurden bereits zurückgegeben.'", Lang));

	// %1 - Internal supply request
	Strings.Insert("Error_023", NStr("ru='В документе ""%1"" не осталось товаров по которым необходимо сделать заказ поставщику.';
		|en='There are no more items that you need to order from suppliers in the ""%1"" document.';
		|fr='Il n''y a plus d''articles dans le document ""%1"" que vous devez commander auprès des fournisseurs.';
		|tr='""%1"" belgesinde tedarikçilerden sipariş etmeniz gereken başka ürün yok.';
		|de='Im Dokument ""%1"" gibt es keine weiteren Waren, die Sie von den Lieferanten bestellen müssen.'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_028", NStr("fr='Activez la case à cocher ""%1 avant %2"" dans l''onglet ""Autres"".';
		|en='Select the ""%1 before %2"" check box on the ""Other"" tab.';
		|ru='Необходимо установить галочку ""%1 перед документом %2"" на вкладке ""Дополнительно"".';
		|tr='""Diğer"" sekmesinde ""%2''den %1 önce"" onay kutusunu seçin.';
		|de='Aktivieren Sie das Kontrollkästchen ""%1 vor der %2"" auf der Registerkarte ""Sonstiges"".'", Lang));
	
	// %1 - Cash account
	// %2 - 12
	// %3 - Cheque bonds
	Strings.Insert("Error_030", NStr("ru='Поле %1 обязателено для заполнения в строке %2 %3.';
		|en='Specify %1 in line %2 of the %3.';
		|fr='Spécifiez %1 dans la ligne %2 de %3.';
		|tr='%3''ün %2 satırında %1 belirtin.';
		|de='Geben Sie ein %1 in der Zeile %2 des Dokuments ""%3"" an.'", Lang));

	Strings.Insert("Error_031", NStr("ru='Заказанные товары у поставщика для обеспечения заказа не были получены.';
		|en='Items were not received from the supplier according to the procurement method.';
		|fr='Les articles n''ont pas été reçus du fournisseur conformément a la méthode d''approvisionnement.';
		|tr='Tedarik yöntemine göre malzemeler tedarikçiden alınmadı.';
		|de='Bestellte Waren, die für den Auftrag erforderlich sind, wurden vom Lieferanten nicht erhalten.'", Lang));
	Strings.Insert("Error_032", NStr("fr='Action non terminée.';
		|en='Action not completed.';
		|ru='Действие не завершено.';
		|tr='Eylem tamamlanmadı.';
		|de='Die Aktion ist nicht abgeschlossen.'", Lang));
	Strings.Insert("Error_033", NStr("fr='Attribut dupliqué.';
		|ru='Реквизит дублируется.';
		|en='Duplicate attribute.';
		|tr='Yinelenen özellik.';
		|de='Doppeltes Attribut.'", Lang));
	// %1 - Google drive
	Strings.Insert("Error_034", NStr("ru='%1 не является томом для хранения изображений.';
		|en='%1 is not a picture storage volume.';
		|fr='%1 n''est pas un volume de stockage des images.';
		|tr='%1 bir resim depolama birimi değil.';
		|de='%1 ist nicht ein Bildspeichervolume.'", Lang));
	Strings.Insert("Error_035", NStr("fr='Impossible de charger plus d''un fichier.';
		|ru='Невозможно загрузить более 1 файла.';
		|en='Cannot upload more than 1 file.';
		|tr='1''den fazla dosya yüklenemez.';
		|de='Nur 1 Datei kann hochgeladen werden.'", Lang));
	Strings.Insert("Error_037", NStr("en='Unsupported type of data composition comparison.';
		|fr='Le type de comparaison de la composition des données n''est pas pris en charge.';
		|ru='Неподдерживаемый тип сравнения состава данных.';
		|tr='Desteklenmeyen veri bileşimi karşılaştırması türü.';
		|de='Nicht unterstützter Datenvergleichstyp.'", Lang));
	Strings.Insert("Error_040", NStr("fr='Les fichiers images uniquement sont pris en charge.';
		|en='Only picture files are supported.';
		|ru='Поддерживается только тип файла - картинка.';
		|tr='Yalnızca resim dosyaları desteklenir.';
		|de='Nur Bilddateien sind unterstützt.'", Lang));
	Strings.Insert("Error_041", NStr("en='Tax table contains more than 1 row [key: %1] [tax: %2].';
		|ru='Таблица налогов содержит больше 1 строки [ключ: %1] [налог: %2].';
		|fr='La table d''impôts/taxes contient plus d''une ligne [clé : %1] [impôt/taxe : %2].';
		|tr='Vergi tablosu 1''den fazla satır içeriyor [anahtar: %1] [vergi: %2].';
		|de='Die Steuertabelle enthält mehr als 1 Zeile [Schlüssel: %1] [Steuer: %2].'", Lang));
	// %1 - Name
	Strings.Insert("Error_042", NStr("ru='Не найден налог по наименованию колонки: %1.';
		|fr='Impossible de trouver un impôt ou une taxe par le nom de colonne : %1.';
		|en='Cannot find a tax by column name: %1.';
		|tr='Sütun adına göre bir vergi bulunamıyor: %1.';
		|de='Eine Steuer kann nach dem Spaltennamen %1 nicht gefunden werden.'", Lang));
	Strings.Insert("Error_043", NStr("fr='Type de document non pris en charge.';
		|ru='Неподдерживаемый тип документа.';
		|en='Unsupported document type.';
		|tr='Desteklenmeyen belge türü.';
		|de='Nicht unterstützter Dokumenttyp.'", Lang));
	Strings.Insert("Error_044", NStr("ru='Недопустимая операция.';
		|fr='L''opération n''est pas prise en charge.';
		|en='Operation is not supported.';
		|tr='İşlem desteklenmiyor.';
		|de='Der Vorgang ist nicht unterstützt.'", Lang));
	Strings.Insert("Error_045", NStr("en='Document is empty.';
		|fr='Le document est vide.';
		|ru='Документ не заполнен.';
		|tr='Belge boş.';
		|de='Das Dokument ist leer.'", Lang));
	// %1 - Currency
	Strings.Insert("Error_047", NStr("fr='""%1"" est un champ obligatoire.';
		|ru='Поле ""%1"" обязательное для заполнения.';
		|en='""%1"" is a required field.';
		|tr='""%1"" zorunlu bir alandır.';
		|de='""%1"" ist ein erforderliches Feld.'", Lang));
	Strings.Insert("Error_049", NStr("ru='Том хранения файлов по умолчанию не заполнен.';
		|fr='Le volume de stockage des images par défaut n''est pas défini.';
		|en='Default picture storage volume is not set.';
		|tr='Varsayılan resim saklama hacmi ayarlanmamıştır.';
		|de='Das Standardbildspeichervolume ist nicht festgelegt.'", Lang));
	Strings.Insert("Error_050", NStr("ru='Обмен валюты возможен только между счетами одного типа (между двумя кассами или между двумя банковскими счетами).';
		|fr='Le change de devises est disponible uniquement pour les comptes du même type (caisses ou comptes bancaires).';
		|en='Currency exchange is available only for the same-type accounts (cash accounts or bank accounts).';
		|tr='Döviz değişimi yalnızca aynı türdeki hesaplar için (kasa hesapları veya banka hesapları) kullanılabilir.';
		|de='Der Währungsumtausch ist nur für die Konten mit demselben Typ verfügbar (Kassenkonten oder Bankkonten).'",
		Lang));
	// %1 - Bank payment
	Strings.Insert("Error_051", NStr("en='There are no lines for which you can create a ""%1"" document, or all ""%1"" documents are already created.';
		|fr='Il n''y a pas de lignes pour lesquelles vous pouvez créer un document ""%1"", ou tous les documents ""%1"" ont déjà été créés.';
		|ru='Отсутствуют строки по которым необходимо создать ""%1"" или же все документы ""%1"" уже были созданы ранее.';
		|tr='Kendisi için bir ""%1"" belgesi oluşturabileceğiniz satır yok veya tüm ""%1"" belgeleri zaten oluşturulmuş.';
		|de='Es gibt keine Zeilen, für die Sie ein Dokument ""%1"" erstellen können, oder alle Dokumente ""%1"" wurden bereits erstellt.'",
		Lang));
	// %1 - Main store
	// %2 - Use shipment confirmation
	// %3 - Shipment confirmations
	Strings.Insert("Error_052", NStr("fr='Impossible de désactiver la case à cocher ""%2"". 
		|Les documents ""%3"" de l''entrepôt %1 ont déjà été créés.';
		|en='Cannot clear the ""%2"" check box. 
		|Documents ""%3"" from store %1 were already created.';
		|ru='Снять галочку ""%2"" невозможно. 
		|Ранее со склада %1 уже были созданы документы ""%3"".';
		|tr='""%2"" onay kutusu temizlenemiyor.
		|%1 mağazasından ""%3"" belgeleri zaten oluşturulmuş.';
		|de='Das Kontrollkästchen ""%2"" kann nicht deaktiviert werden. 
		|Dokumente ""%3"" für Lager %1 wurden bereits zuvor erstellt.'", Lang));
	
	// %1 - Main store
	// %2 - Use goods receipt
	// %3 - Goods receipts
	Strings.Insert("Error_053", NStr("ru='Невозможно снять галочку ""%2"". Ранее со склада %1 уже были созданы документы ""%3"".';
		|en='Cannot clear the ""%2"" check box. Documents ""%3"" from store %1 were already created.';
		|fr='Impossible de désactiver la case à cocher ""%2"". Les documents ""%3"" de l''entrepôt %1 ont déjà été créés.';
		|tr='""%2"" onay kutusu temizlenemiyor. %1 mağazasından ""%3"" belgeleri zaten oluşturulmuş.';
		|de='Das Kontrollkästchen ""%2"" kann nicht deaktiviert werden. Dokumente ""%3"" für Lager %1 wurden bereits zuvor erstellt.'", Lang));
	
	// %1 - sales order
	Strings.Insert("Error_054", NStr("fr='Impossible de continuer. Le statut du document ""%1"" est erroné.';
		|ru='Невозможно продолжить. Статус документа ""%1"" для продолжения неверный.';
		|en='Cannot continue. The ""%1""document has an incorrect status.';
		|tr='Devam edilemez. ""%1"" belgesinin durumu yanlış.';
		|de='Der Vorgang kann nicht fortgesetzt werden. Das Dokument ""%1"" hat einen falschen Status.'", Lang));

	Strings.Insert("Error_055", NStr("fr='Il n''y a pas de lignes avec une méthode d''approvisionnement correcte.';
		|en='There are no lines with a correct procurement method.';
		|ru='Отсутствуют строки с нужным способом обеспечения.';
		|tr='Doğru tedarik yöntemine sahip hatlar yoktur.';
		|de='Es gibt keine Zeilen mit einer richtigen Beschaffungsmethode.'", Lang));

	// %1 - sales order
	// %2 - purchase order
	Strings.Insert("Error_056", NStr("fr='Tous les articles dans le document ""%1"" ont déjà été commandés au moyen du document ou des documents ""%2"".';
		|ru='Все товары в документе ""%1"" уже заказаны документом ""%2"".';
		|en='All items in the ""%1"" document are already ordered using the ""%2"" document(s).';
		|tr='""%1"" belgesindeki tüm öğeler ""%2"" belgeleri kullanılarak zaten sıralanmıştır.';
		|de='Alle Produkte im Dokument ""%1"" sind bereits mithilfe von Dokument(en) ""%2"" bestellt.'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_057", NStr("ru='Для выбранного документа ""%1"" не нужно создавать документ ""%2"".';
		|fr='Vous n''avez pas besoin de créer un document ""%1"" pour le(s) document(s) ""%2"" sélectionné(s).';
		|en='You do not need to create a ""%1"" document for the selected ""%2"" document(s).';
		|tr='Seçili ""%2"" dokümanlar için ""%1"" doküman oluşturmanıza gerek yoktur.';
		|de='Es ist nicht erforderlich, ein Dokument ""%1"" für die ausgewählten Dokumente ""%2"" zu erstellen.'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_058", NStr("fr='Le montant total du document(s) ""%2"" a déjà été payé sur la base du document(s) ""%1"".';
		|ru='Вся сумма по документу ""%2"" уже была выдана по документу ""%1"".';
		|en='The total amount of the ""%2"" document(s) is already paid on the basis of the ""%1"" document(s).';
		|tr='""%2"" belgelerinin toplam tutarı, ""%1"" belgeleri temelinde zaten ödendi.';
		|de='Der Gesamtbetrag des Dokuments ""%2"" ist bereits mithilfe von Dokument ""%1"" bezahlt.'",
		Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_059", NStr("ru='В списке выбранных документов ""%2"" есть те по которым уже был создан документ ""%1""
		| и те по которым документ ""%1"" создавать не нужно.';
		|fr='Dans les documents sélectionnés, il y a les document(s) ""%2"" avec les documents ""%1"" existants,
		| aussi que ceux qui n''ont pas besoin de document ""%1"".';
		|en='In the selected documents, there are ""%2"" document(s) with existing ""%1"" document(s)
		| and those that do not require a ""%1"" document.';
		|tr='Seçilen belgelerde, mevcut ""%1"" belgelerine sahip ""%2"" belgeler var
		|  ve ""%1"" belgesi gerektirmeyenler.';
		|de='Die ausgewählten Dokumente enthalten Dokumente ""%2"" mit vorhandenen Dokumenten ""%1""
		| und diejenige, für die das Dokument ""%1"" nicht erforderlich ist.'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_060", NStr("fr='Le montant total du document(s) ""%2"" a déjà été reçu sur la base du document(s) ""%1"".';
		|en='The total amount of the ""%2"" document(s) is already received on the basis of the ""%1"" document(s).';
		|ru='Вся сумма по документу ""%2"" уже была получена по документу ""%1"".';
		|tr='""%2"" belgelerinin toplam miktarı, ""%1"" belgeleri temelinde zaten alındı.';
		|de='Der Gesamtbetrag des Dokuments ""%2"" ist bereits mithilfe von Dokument ""%1"" erhalten.'",
		Lang));
	
	// %1 - Main store
	// %2 - Shipment confirmation
	// %3 - Sales order
	Strings.Insert("Error_064", NStr("ru='Для склада %1 нет необходимости создавать документ ""%2"". Товар будет отгружен по документу ""%3"".';
		|fr='Vous n''avez pas besoin de créer un document ""%2"" pour l''entrepôt(s) %1. L''article sera expédié au moyen du document ""%3"".';
		|en='You do not need to create a ""%2"" document for store(s) %1. The item will be shipped using the ""%3"" document.';
		|tr='%1 mağazaları için ""%2"" belgesi oluşturmanıza gerek yok. Ürün, ""%3"" belgesi kullanılarak gönderilecek.';
		|de='Es ist nicht erforderlich, ein Dokument ""%2"" für Lager %1 zu erstellen. Das Produkt wird mithilfe von Dokument ""%3"" versendet.'",
		Lang));

	Strings.Insert("Error_065", NStr("fr='La clé d''article n''est pas unique.';
		|ru='Характеристика не уникальна.';
		|en='Item key is not unique.';
		|tr='Varyant benzersiz değil.';
		|de='Artikelvariante ist nicht eindeutig.'", Lang));
	Strings.Insert("Error_066", NStr("fr='La spécification n''est pas unique.';
		|ru='Спецификация товара не уникальна.';
		|en='Specification is not unique.';
		|tr='Spesifikasyon benzersiz değil.';
		|de='Spezifikation ist nicht eindeutig.'", Lang));
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
	Strings.Insert("Error_068", NStr("fr='Ligne nº [%1] [%2 %3] %4 restants : %5 %8. Nécessaires : %6 %8. Manquants : %7 %8.';
		|ru='Строка № [%1] [%2%3] %4 остаток: %5%8 Требуется: %6%8 Разница: %7%8.';
		|en='Line No. [%1] [%2 %3] %4 remaining: %5 %8. Required: %6 %8. Lacking: %7 %8.';
		|tr='Satır No. [%1] [%2 %3] %4aldı: %5 %8. Gerekli: %6 %8. Eksik: %7 %8.';
		|de='Zeile Nr. [%1] [%2 %3] %4 Restmenge: %5%8. Erforderlich: %6%8. Es fehlt: %7%8.'", Lang));

	// %1 - some extention name
	Strings.Insert("Error_071", NStr("ru='Внешняя обработка ""%1"" не подключена.';
		|fr='Plug-in ""%1"" n''est pas connecté.';
		|en='Plugin ""%1"" is not connected.';
		|tr='""%1"" eklentisi bağlı değil.';
		|de='Plug-In ""%1"" ist nicht verbunden.'", Lang));
	
	// %1 - 12
	Strings.Insert("Error_072", NStr("fr='Spécifiez un entrepôt dans la ligne %1.';
		|ru='В строке %1 необходимо заполнить склад.';
		|en='Specify a store in line %1.';
		|tr='%1 satırında bir mağaza belirtin.';
		|de='Geben Sie ein Lager in der Zeile %1 an.'", Lang));

	// %1 - Sales order
	// %2 - Goods receipt
	Strings.Insert("Error_073", NStr("fr='Tous les articles dans le(s) document(s) ""%1"" ont déjà été reçus au moyen du document ou des documents ""%2"".';
		|ru='Все товары по документу ""%1"" уже получены на основании документа ""%2"".';
		|en='All items in the ""%1"" document(s) are already received using the ""%2"" document(s).';
		|tr='""%1"" belgelerindeki tüm öğeler, ""%2"" belgeleri kullanılarak zaten alındı.';
		|de='Alle Produkte im Dokument ""%1"" sind bereits mithilfe von Dokument(en) ""%2"" erhalten.'", Lang));
	Strings.Insert("Error_074", NStr("ru='При перемещении денежных средств в одной валюте сумма отправки и получения должны совпадать.';
		|en='Currency transfer is available only when amounts are equal.';
		|fr='Le transfert d''argent dans la même devise est disponible uniquement quand les montants sont égaux.';
		|tr='Para birimi transferi yalnızca tutarlar eşit olduğunda kullanılabilir.';
		|de='Der Währungstransfer ist verfügbar, nur wenn Beträge gleich sind.'", Lang));

	// %1 - Physical count by location
	Strings.Insert("Error_075", NStr("ru='Есть незакрытые документы ""%1"".';
		|fr='Il y a des documents ""%1"" non fermés.';
		|en='There are ""%1"" documents that are not closed.';
		|tr='Kapatılmamış ""%1"" dokümanlar var.';
		|de='Es gibt Dokumente ""%1"", die nicht geschlossen sind.'", Lang));
	
	// %1 - 12
	Strings.Insert("Error_077", NStr("ru='Не заполнен документ основания в строке %1';
		|en='Basis document is empty in line %1.';
		|tr='Ana belge %1 satırında boş.'", Lang));
	
	// %1 - 1 %2 - 2
	Strings.Insert("Error_078", NStr("en='Quantity [%1] does not match the quantity [%2] by serial/lot numbers';
		|ru='Количество [%1] по строке не совпадает с количеством [%2] заполненным по серийным номерам. ';
		|tr='Girilen [%1] adet, seri lotuna ait [%2] adedinden farklıdır'",
		Lang));
	
	// %1 - 100.00 
	// %2 - 120.00
	Strings.Insert("Error_079", NStr("ru='Сумма оплаты [%1] и сумма возврата [%2] не сходятся';
		|en='Payment amount [%1] and return amount [%2] not match';
		|tr='Ödeme tutar ([%1]) iade tutarından ([%2]) farklıdır'", Lang));
	
	// %1 - 1 
	// %2 - Goods receipt 
	// %3 - 10 
	// %4 - 8
	Strings.Insert("Error_080", NStr("ru='В строке %1 количество %2 %3 больше чем %4';
		|en='In line %1 quantity by %2 %3 greater than %4';
		|tr='%1 satırında %2 %3 adet %4 adedinden daha büyük'", Lang));
	
	// %1 - 1 
	// %2 - Dress 
	// %3 - Red/38 
	// %4 - 8 
	// %5 - 10
	Strings.Insert("Error_081", NStr("en='In line %1 quantity by %2-%3 %4 less than quantity by goods receipt %5';
		|ru='В строке %1 количество %2-%3 %4 меньше чем количество в приходном ордере %5';
		|tr='%1 satırında %2-%3 %4 adedi %5 alım irsaliyesindeki adetten daha küçük'",
		Lang));
	
	// %1 - 1 
	// %2 - Dress 
	// %3 - Red/38 
	// %4 - 10 
	// %5 - 8
	Strings.Insert("Error_082", NStr("en='In line %1 quantity by %2-%3 %4 less than quantity by goods receipt %5';
		|ru='В строке %1 количество %2-%3 %4 меньше чем количество в приходном ордере %5';
		|tr='%1 satırında %2-%3 %4 adedi %5 alım irsaliyesindeki adetten daha küçük'",
		Lang));
	
	// %1 - 12 
	Strings.Insert("Error_083", NStr("ru='Локация с номером %1 не найдена.';
		|en='Location with number `%1` not found.';
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

	Strings.Insert("Error_091", NStr("ru='Только Администраторы могут создавать пользователей';
		|en='Only Administrator can create users.';
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
	Strings.Insert("Error_095", NStr("ru='Сумма оплаты [%1] не равна сумме продажи [%2] ';
		|en='Payment amount [%1] and sales amount [%2] not match';
		|tr='[%1] ödeme tutarı [%2] satış tutarına eşit değil'", Lang));
	
	// %1 - 1
	// %2 - Boots
	// %3 - Red XL
	Strings.Insert("Error_096", NStr("ru='Невозможно удалить залинкованную строку [%1] [%2] [%3]';
		|en='Can not delete linked row [%1] [%2] [%3]';
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
	Strings.Insert("Error_098", NStr("ru='Неверно залинкованна строка [%1] для столбца [%2] использованное значение [%3] неправильное значение [%4]';
		|en='Wrong linked row [%1] for column [%2] used value [%3] wrong value [%4]';
		|tr='Satır bağlatma hatası [%1] kolon [%2] kullanılan değer [%3] yanlış değer [%4]'", Lang));
	
	// %1 - Partner
	// %2 - Partner 01
	// %3 - Partner 02
	Strings.Insert("Error_099", NStr("ru='Неверно залинкованны данные [%1] используемое значение [%2] неправильное значение [%3]';
		|en='Wrong linked data [%1] used value [%2] wrong value [%3]';
		|tr='Yanlış bağlantı verisi [%1] kullanılan değer [%2] yanlış değer [%3]'", Lang));
	
	// %1 - Value 01
	// %2 - Value 02
	Strings.Insert("Error_100", NStr("ru='Неверно залинкованны данные, используемое значение [%1] неправильное значение [%2]';
		|en='Wrong linked data, used value [%1] wrong value [%2]';
		|tr='Yanlış bağlantı verisi, kullanılan değer [%1] yanlış değer [%2]'", Lang));
	
	Strings.Insert("Error_101", NStr("ru='Необходимо выбрать документ';
		|en='Select any document';
		|tr='Evrakı seçiniz'", Lang));
	Strings.Insert("Error_102", NStr("en='Default file storage volume is not set.';
		|ru='Не указан том хранения файлов.';
		|tr='Varsayılan dosya depolama yeri seçilmedi.'", Lang));
	Strings.Insert("Error_103", NStr("en='%1 is undefined.';
		|ru='%1 неопределен.';
		|tr='%1 tanımlı değil.'", Lang));
	Strings.Insert("Error_104", NStr("ru='По документу [%1] есть отрицательный остаток на складе';
		|en='Document [%1] have negative stock balance';
		|tr='[%1] evrakı eksi stok bakiyesine düştü'", Lang));
	Strings.Insert("Error_105", NStr("ru='У документа [%1] уже есть связанные документы';
		|en='Document [%1] already have related documents';
		|tr='[%1] evrakın bağlı evraklar mevcuttur'", Lang));
	Strings.Insert("Error_106", NStr("ru='Заблокировать данные не получилось';
		|en='Can not lock data';
		|tr='Veri kilitlenemedi'", Lang));
	Strings.Insert("Error_107", NStr("ru='Попытка вызвать сервис %1, который помеченн на удаление.';
		|en='You try to call deleted service %1.';
		|tr='Silmek için işaretlenen %1 servisi çağırıldı.'", Lang));
#EndRegion

#Region InfoMessages
	// %1 - Purchase invoice
	// %2 - Purchase order
	Strings.Insert("InfoMessage_001", NStr("ru='Созданный документ ""%1"" не совпадает с документом ""%2"" в силу того, что ранее
		| уже создан документ ""%1"", который частично закрыл документ ""%2"".';
		|fr='Les documents ""%1"" et ""%2"" ne correspondent pas complétement, 
		|parce qu''il y a un autre document ""%1"" qui couvre partiellement le document ""%2"".';
		|en='The ""%1"" document does not fully match the ""%2"" document because 
		|there is already another ""%1"" document that partially covered this ""%2"" document.';
		|tr='""%1"" belgesi, ""%2"" belgesiyle tam olarak eşleşmiyor çünkü
		|zaten bu ""%2"" belgesini kısmen kapsayan başka bir ""%1"" belgesi var.';
		|de='Das Dokument ""%1"" stimmt mit dem Dokument ""%2"" nicht vollständig überein. 
		|Es gibt ein anderes Dokument ""%1"", das das Dokument ""%2"" teilweise abgedeckt hat.'",
		Lang));
	// %1 - Boots
	Strings.Insert("InfoMessage_002", NStr("fr='Objet %1 créé.';
		|ru='Объект %1 создан.';
		|en='Object %1 created.';
		|tr='%1 nesnesi oluşturuldu.';
		|de='Objekt %1 erstellt.'", Lang));
	Strings.Insert("InfoMessage_003", NStr("ru='Это сервисная форма.';
		|fr='Il s''agit d''une forme service.';
		|en='This is a service form.';
		|tr='Bu bir hizmet formudur.';
		|de='Das ist ein Dienstformular.'", Lang));
	Strings.Insert("InfoMessage_004", NStr("fr='Enregistrez l''objet pour continuer.';
		|ru='Для продолжения необходимо сохранить объект.';
		|en='Save the object to continue.';
		|tr='Devam etmek için nesneyi kaydedin.';
		|de='Speichern Sie das Objekt, um fortzufahren.'", Lang));
	Strings.Insert("InfoMessage_005", NStr("en='Done';
		|fr='Terminé';
		|ru='Завершено';
		|tr='Tamamlandı';
		|de='Fertig'", Lang));
	
	// %1 - Physical count by location
	Strings.Insert("InfoMessage_006", NStr("ru='Документы ""%1"" уже созданы. Возможно использовать только функцию обновления количества.';
		|en='The ""%1"" document is already created. You can update the quantity.';
		|fr='Le document ""%1"" a déjà été créé. Vous pouvez mettre à jour la quantité.';
		|tr='""%1"" belgesi zaten oluşturulmuş. Miktarı güncelleyebilirsiniz.';
		|de='Das Dokument ""%1"" wurde bereits erstellt. Sie können die Anzahl aktualisieren.'", Lang));

	Strings.Insert("InfoMessage_007", NStr("fr='nº %1 date : %2';
		|ru='#%1 дата: %2';
		|en='#%1 date: %2';
		|tr='#%1 tarih: %2';
		|de='Nr. %1 Datum: %2'", Lang));
	// %1 - 12
	// %2 - 20.02.2020
	Strings.Insert("InfoMessage_008", NStr("fr='nº %1 date : %2';
		|ru='#%1 дата: %2';
		|en='#%1 date: %2';
		|tr='#%1 tarih: %2';
		|de='Nr. %1 Datum: %2'", Lang));

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
	Strings.Insert("InfoMessage_013", NStr("ru='Текущая локация %1 закреплена за вами. Другие пользователи не смогут с ней работать.';
		|en='Current location #%1 was linked to you. Other users will not be able to scan it.';
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

	Strings.Insert("InfoMessage_019", NStr("ru='Причина запрета:';
		|en='Data lock reasons:';
		|tr='Veri değiştirme kısıtlama sebebi:'", Lang));

	Strings.Insert("InfoMessage_020", NStr("ru='Создан документ: %1';
		|en='Created document: %1';
		|tr='Evrak oluştur: %1'", Lang));
  
  	// %1 - 42
	Strings.Insert("InfoMessage_021", NStr("ru='Невозможно разблокировать реквизиты, данный элемент использовался %1 раз, например:';
		|en='Can not unlock attributes, this is element used %1 times, ex.:';
		|tr='Alan kilidi kaldırılamaz, nesne %1 kez kullanıldı, örneğin:'",
		Lang));
  	// %1 - 
	Strings.Insert("InfoMessage_022", NStr("en='This order is closed by %1';
		|ru='Этот заказ уже закрыт документом %1';
		|tr='Bu sipariş %1 ile kapatılmıştı.'", Lang));
	Strings.Insert("InfoMessage_023", NStr("ru='Нельзя вводить расходную накладную, без приходной накладной по данному виду отгрузки. Включено использование приходной накладной.';
		|en='Can not use confirmation of shipment without goods receipt. Use goods receipt mode is enabled.';
		|tr='Satın alma irsaliyesi olmadan sevk irsaliyesi oluşturulamaz. Satın alma irsaliye devrede.'", Lang));
	Strings.Insert("InfoMessage_024", NStr("ru='Доступен к изменению после записи объекта.';
		|en='Will be available after save.';
		|tr='Kaydettikten sonra ulaşılabilir olacak'", Lang));
#EndRegion

#Region QuestionToUser
	Strings.Insert("QuestionToUser_001", NStr("en='Write the object to continue. Continue?';
		|ru='Для продолжения необходимо сохранить объект. Продолжить?';
		|fr='Écrivez l''objet pour continuer. Voulez-vous continuer ?';
		|tr='Devam etmek için nesneyi yazın. Devam edilsin mi?';
		|de='Schreiben Sie das Objekt, um fortzufahren. Fortfahren?'", Lang));
	Strings.Insert("QuestionToUser_002", NStr("fr='Voulez-vous passer en mode de numérisation ?';
		|en='Do you want to switch to scan mode?';
		|ru='Переключиться в режим сканирования?';
		|tr='Tarama moduna geçmek istiyor musunuz?';
		|de='Möchten Sie zum Scanmodus wechseln?'", Lang));
	Strings.Insert("QuestionToUser_003", NStr("en='Filled data on cheque bonds transactions will be deleted. Do you want to update %1?';
		|fr='Les données complétées sur les transactions relatives aux chèques et obligations seront effacées. Voulez-vous mettre à jour %1 ?';
		|ru='Заполненные данные по чекам будут очищены. Обновить %1? ';
		|tr='Doldurulmuş çek/senet bilgiler temizlenecek. %1 güncellemek ister misiniz?';
		|de='Angegebene Daten über Schecks und Anleihen werden gelöscht. Möchten Sie %1 aktualisieren?'", Lang));
	Strings.Insert("QuestionToUser_004", NStr("ru='Изменить налоговые ставки в соответствии с соглашением?';
		|fr='Voulez-vous modifier les taux d''imposition conformément à l''accord ?';
		|en='Do you want to change tax rates according to the partner term?';
		|tr='Vergileri sözleşmeye göre değiştirmek ister misiniz?';
		|de='Möchten Sie die Steuersätze gemäß der Vereinbarung verändern?'",
		Lang));
	Strings.Insert("QuestionToUser_005", NStr("fr='Voulez-vous mettre à jour les entrepôts complétés ?';
		|en='Do you want to update filled stores?';
		|ru='Обновить заполненные склады?';
		|tr='Tüm depoları güncellemek ister misiniz?';
		|de='Möchten Sie die angegebenen Lager aktualisieren?'", Lang));
	Strings.Insert("QuestionToUser_006", NStr("ru='Обновить заполненные цены';
		|fr='Voulez-vous mettre à jour la devise complétée ?';
		|en='Do you want to update filled currency?';
		|tr='Doldurulan para birimini güncellemek istiyor musunuz?';
		|de='Möchten Sie die angegebene Währung aktualisieren?'", Lang));
	Strings.Insert("QuestionToUser_007", NStr("en='Transaction table will be cleared. Continue?';
		|ru='Таблица транзакций будет очищена. Продолжить?';
		|fr='La table des transactions sera effacée. Voulez-vous continuer ?';
		|tr='İşlemler tablosu temizlenecek. Devam etmek ister misiniz?';
		|de='Die Transaktionstabelle wird geleert. Fortfahren?'", Lang));
	Strings.Insert("QuestionToUser_008", NStr("en='Changing the currency will clear the rows with cash transfer documents. Continue?';
		|ru='При изменении валюты заполненные строки будут отвязаны от документа перемещения денежных средств. Продолжить?';
		|fr='Si vous changez la devise, les lignes avec les documents de transfert d''argent seront effacées. Voulez-vous continuer ?';
		|tr='Para birimini değiştirmek, nakit transferi belgelerini içeren satırları temizleyecektir. Devam ediyor muyuz?';
		|de='Wenn Sie die Währung ändern, die Zeilen mit den Überweisungsdokumenten werden geleert. Fortfahren?'", Lang));
	Strings.Insert("QuestionToUser_009", NStr("ru='Хотите заменить текущие склады на склад: %1?';
		|en='Do you want to replace filled stores with store %1?';
		|tr='Dolu depoları %1 deposu ile değiştirmek ister misiniz?'", Lang));
	Strings.Insert("QuestionToUser_011", NStr("en='Do you want to replace filled price types with price type %1?';
		|ru='Хотите заменить текущие типы цен на : %1?';
		|tr='Dolu fiyat tipleri %1 fiyat tipi ile değiştirmek ister misiniz?'",
		Lang));
	Strings.Insert("QuestionToUser_012", NStr("fr='Voulez-vous vraiment quitter ?';
		|ru='Вы действительно хотите выйти?';
		|en='Do you want to exit?';
		|tr='Çıkmak istediğinizden emin misiniz?';
		|de='Möchten Sie den Vorgang beenden?'", Lang));
	Strings.Insert("QuestionToUser_013", NStr("en='Do you want to update filled prices?';
		|fr='Voulez-vous mettre à jour les prix complétés ?';
		|ru='Обновить заполненные цены?';
		|tr='Doldurulmuş fiyatları güncellemek istiyor musunuz?';
		|de='Möchten Sie die angegebenen Preise aktualisieren?'", Lang));
	Strings.Insert("QuestionToUser_014", NStr("en='Transaction type is changed. Do you want to update filled data?';
		|fr='Le type de transaction a été changé. Voulez-vous mettre à jour les données complétées ?';
		|ru='Тип операции изменен. Обновить заполненные данные? ';
		|tr='İşlem türü değiştirildi. Doldurulmuş verileri güncellemek istiyor musunuz?';
		|de='Der Transaktionstyp wurde geändert. Möchten Sie angegebene Daten aktualisieren?'",
		Lang));
	Strings.Insert("QuestionToUser_015", NStr("ru='Заполненные данные будут очищены. Продолжить?';
		|en='Filled data will be cleared. Continue?';
		|fr='Les données complétées seront effacées. Voulez-vous continuer ?';
		|tr='Doldurulan veriler silinecektir. Devam edilsin mi?';
		|de='Angegebene Daten werden geleert. Fortfahren?'", Lang));
	Strings.Insert("QuestionToUser_016", NStr("fr='Voulez-vous changer ou effacer l''icône ?';
		|en='Do you want to change or clear the icon?';
		|ru='Заменить или удалить иконку?';
		|tr='Simgeyi değiştirmek mi yoksa temizlemek mi istiyorsunuz?';
		|de='Möchten Sie das Symbol verändern oder löschen?'", Lang));
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
	Strings.Insert("QuestionToUser_021", NStr("ru='Вы хотите закрыть текущую форму? Все изменения будут потеряны.';
		|en='Do you want to close this form? All changes will be lost.';
		|tr='Bu formu kapatmak istediğinizden emin misiniz? Tüm değişiklikler geri alınacaktır.'", Lang));
	Strings.Insert("QuestionToUser_022", NStr("en='Do you want to upload this files';
		|ru='Вы хотите загрузить эти файлы?';
		|tr='Dosya yüklemek ister misiniz?'", Lang) + ": " + Chars.LF + "%1");
	Strings.Insert("QuestionToUser_023", NStr("ru='Перезаполнить по перемещению денежных средств?';
		|en='Do you want to fill according to cash transfer order?';
		|tr='Kas/banka transfer fişine göre doldurulsun mu?'", Lang));
#EndRegion

#Region SuggestionToUser
	Strings.Insert("SuggestionToUser_1", NStr("en='Select a value';
		|ru='Выберите значение';
		|fr='Sélectionner une valeur';
		|tr='Bir değer seçin';
		|de='Wählen Sie einen Wert aus'", Lang));
	Strings.Insert("SuggestionToUser_2", NStr("ru='Введите штрихкод';
		|en='Enter a barcode';
		|fr='Entrez un code-barres';
		|tr='Bir barkod giriniz';
		|de='Geben Sie einen Barcode ein'", Lang));
	Strings.Insert("SuggestionToUser_3", NStr("fr='Entrez le nom d''une option';
		|en='Enter an option name';
		|ru='Наименование параметра ввода';
		|tr='Bir seçenek adı giriniz';
		|de='Geben Sie einen Optionsnamen ein'", Lang));
	Strings.Insert("SuggestionToUser_4", NStr("en='Enter a new option name';
		|ru='Введите новое наименование параметра';
		|fr='Entrez un nouveau nom de l''option';
		|tr='Yeni bir seçenek adı giriniz';
		|de='Geben Sie einen neuen Optionsnamen ein'", Lang));
#EndRegion

#Region UsersEvent
	Strings.Insert("UsersEvent_001", NStr("fr='L''utilisateur portant l''UUID %1 et le nom %2 est introuvable.';
		|ru='Пользователь по UUID %1 и имени %2не найден.';
		|en='User not found by UUID %1 and name %2.';
		|tr='Kullanıcı, %1 UUID ve %2 adı ile bulunamadı.';
		|de='Benutzer wurde nach UUID %1 und Namen %2 nicht gefunden.'", Lang));
	Strings.Insert("UsersEvent_002", NStr("ru='Пользователь по UUID %1 и имени %2 найден.';
		|en='User found by UUID %1 and name %2.';
		|fr='L''utilisateur portant l''UUID %1 et le nom %2 est trouvé.';
		|tr='Kullanıcı, %1 UUID ve %2 adı tarafından bulundu.';
		|de='Der Benutzer wurde nach UUID %1 und Namen %2 gefunden.'", Lang));
#EndRegion

#Region Items
	
	// Interface
	Strings.Insert("I_1", NStr("fr='Entrez une description';
		|en='Enter description';
		|ru='Введите Наименование';
		|tr='Açıklama giriniz';
		|de='Geben Sie eine Beschreibung an'", Lang));
	Strings.Insert("I_2", NStr("fr='Cliquez pour entrer la description';
		|ru='Нажмите для заполнения';
		|en='Click to enter description';
		|tr='Açıklama girmek için tıklayın';
		|de='Geben Sie eine Beschreibung ein'", Lang));
	Strings.Insert("I_3", NStr("en='Fill out the document';
		|ru='Заполните документ';
		|fr='Remplissez le document';
		|tr='Belgeyi doldurunuz';
		|de='Füllen Sie das Dokument aus'", Lang));
	Strings.Insert("I_4", NStr("en='Find %1 rows in table by key %2';
		|ru='Найти %1 строк в таблице по ключу %2';
		|tr='Tabloda %2 anahtara göre %1 bulmak'", Lang));
	Strings.Insert("I_5", NStr("en='Not supported table';
		|ru='Не поддерживаемая таблица';
		|tr='Desteklenmeyen tablo'", Lang));
	Strings.Insert("I_6", NStr("ru='Заказано без ЗОТ';
		|en='Ordered without ISR';
		|tr='Normal sipariş'", Lang));

#EndRegion

#Region Exceptions
	Strings.Insert("Exc_001", NStr("ru='Неподдерживаемый тип объекта.';
		|fr='Type d''objet non pris en charge.';
		|en='Unsupported object type.';
		|tr='Desteklenmeyen nesne türü.';
		|de='Nicht unterstützter Objekttyp.'", Lang));
	Strings.Insert("Exc_002", NStr("ru='Без условий';
		|fr='Pas de conditions';
		|en='No conditions';
		|tr='Koşul yok';
		|de='Keine Bedingungen'", Lang));
	Strings.Insert("Exc_003", NStr("en='Method is not implemented: %1.';
		|fr='La méthode n’a pas été implémentée : %1.';
		|ru='Метод не реализован: %1.';
		|tr='Yöntem uygulanmadı: %1.';
		|de='Die Methode ist nicht implementiert: %1.'", Lang));
	Strings.Insert("Exc_004", NStr("en='Cannot extract currency from the object.';
		|ru='Валюта из объекта не извлечена.';
		|fr='Impossible d''extraire la devise de l''objet.';
		|tr='Nesneden para birimi çıkarılamıyor.';
		|de='Die Währung kann aus dem Objekt nicht extrahiert werden.'", Lang));
	Strings.Insert("Exc_005", NStr("en='Library name is empty.';
		|fr='Le nom de bibliothéque est vide.';
		|ru='Наименование библиотеки не заполнено.';
		|tr='Kütüphane adı boş.';
		|de='Der Bibliothekname ist leer.'", Lang));
	Strings.Insert("Exc_006", NStr("fr='Les données de bibliothèque n''ont pas de version.';
		|ru='Данные библиотеки не содержат версии.';
		|en='Library data does not contain a version.';
		|tr='Kütüphane veriler sürümü içermiyor.';
		|de='Bibliotheksdaten enthalten keine Version.'", Lang));
	Strings.Insert("Exc_007", NStr("en='Not applicable for library version %1.';
		|ru='Не применимо для версии библиотеки: %1.';
		|fr='Non applicable pour la version de bibliothéque %1.';
		|tr='%1 kütüphane sürümü için geçerli değil.';
		|de='Nicht anwendbar für die Bibliotheksversion %1.'", Lang));
	Strings.Insert("Exc_008", NStr("ru='Неизвестный ключ строки.';
		|fr='Clé de ligne inconnue.';
		|en='Unknown row key.';
		|tr='Bilinmeyen satır anahtarı.';
		|de='Unbekannter Zeilenschlüssel.'", Lang));
	Strings.Insert("Exc_009", NStr("ru='Ошибка: %1';
		|fr='Erreur : %1';
		|en='Error: %1';
		|tr='Hata: %1';
		|de='Fehler: %1'", Lang));
#EndRegion

#Region Saas
	// %1 - 12
	Strings.Insert("Saas_001", NStr("ru='Рабочая область %1 не найдена.';
		|en='Area %1 not found.';
		|fr='La zone %1 est introuvable.';
		|tr='%1 alanı bulunamadı.';
		|de='Bereich %1 ist nicht gefunden.'", Lang));
	
	// %1 - closed
	Strings.Insert("Saas_002", NStr("fr='Statut de la zone : %1.';
		|en='Area status: %1.';
		|ru='Статус рабочей области: %1.';
		|tr='Alan durumu:%1.';
		|de='Bereichsstatus: %1.'", Lang));
	
	// %1 - en
	Strings.Insert("Saas_003", NStr("ru='Локализация компании %1 не доступна.';
		|fr='La localisation %1 de l''entreprise n''est pas disponible.';
		|en='Localization %1 of the company is not available.';
		|tr='Şirketin %1 yerelleştirmesi mevcut değil. ';
		|de='Lokalisierung %1 der Organisation ist nicht verfügbar.'", Lang));

	Strings.Insert("Saas_004", NStr("en='Area preparation completed';
		|ru='Подготовка области завершена';
		|tr='Bölge hazırlaması tamamlandı.'", Lang));
#EndRegion

#Region FillingFromClassifiers
    // Do not modify "en" strings
	Strings.Insert("Class_001", NStr("en='Purchase price';
		|ru='Цена закупки';
		|fr='Prix d''achat';
		|tr='Alım fiyatı';
		|de='Einkaufspreis'", Lang));
	Strings.Insert("Class_002", NStr("en='Sales price';
		|fr='Prix de vente';
		|ru='Цена продажи';
		|tr='Satış fiyatı';
		|de='Verkaufspreis'", Lang));
	Strings.Insert("Class_003", NStr("ru='Себестоимость';
		|en='Prime cost';
		|fr='Prix coûtant';
		|tr='Birim maliyet fiyatı';
		|de='Selbstkosten'", Lang));
	Strings.Insert("Class_004", NStr("fr='Service';
		|ru='Сервис';
		|en='Service';
		|tr='Servis';
		|de='Dienst'", Lang));
	Strings.Insert("Class_005", NStr("en='Product';
		|ru='Товар';
		|fr='Produit';
		|tr='Malzeme';
		|de='Ware'", Lang));
	Strings.Insert("Class_006", NStr("en='Main store';
		|ru='Главный склад';
		|fr='Entrepôt principal';
		|tr='Ana depo';
		|de='Hauptlager'", Lang));
	Strings.Insert("Class_007", NStr("ru='Главный менеджер';
		|en='Main manager';
		|fr='Responsable principal';
		|tr='Ana sorumlu';
		|de='Hauptmanager'", Lang));
	Strings.Insert("Class_008", NStr("en='pcs';
		|ru='шт';
		|fr='pcs';
		|tr='adet';
		|de='Stck.'", Lang));
#EndRegion

#Region PredefinedObjectDescriptions
	PredefinedDescriptions(Strings, Lang);
#EndRegion

#Region Titles
	// %1 - Cheque bond transaction
	Strings.Insert("Title_00100", NStr("ru='Выбор документов-оснований в документе ""%1""';
		|en='Select base documents in the ""%1"" document.';
		|fr='Sélectionnez les documents de base dans le document ""%1"".';
		|tr='""%1"" belgesindeki ana belgeleri seçin.';
		|de='Wählen Sie Basisdokumente im Dokument ""%1"" aus.'", Lang));	// Form PickUpDocuments
#EndRegion

#Region ChoiceListValues
	Strings.Insert("CLV_1", NStr("fr='Tout';
		|ru='Все';
		|en='All';
		|tr='Tümü';
		|de='Alle'", Lang));
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
	Strings.Insert("R_002", NStr("ru='Свойство';
		|en='Property';
		|tr='Özellik'", Lang) + " = ");
	Strings.Insert("R_003", NStr("fr='Article';
		|ru='Номенклатура';
		|en='Item';
		|tr='Malzeme';
		|de='Produkt'", Lang) + " = ");
	Strings.Insert("R_004", NStr("ru='Спецификация товара';
		|en='Specification';
		|tr='Ürün reçetesi'", Lang) + " = ");
#EndRegion

	Return Strings;
EndFunction

// Predefined descriptions.
// 
// Parameters:
//  Strings - Structure - Strings
//  CodeLanguage - String - Code language
Procedure PredefinedDescriptions(Strings, CodeLanguage)
	Strings.Insert("Description_A001", NStr("en='Catalog Partner terms';
		|ru='Справочник Соглашения';
		|fr='Catalogue Accords';
		|tr='Sözleşmeler';
		|de='Katalog Vereinbarungen'", CodeLanguage));
	Strings.Insert("Description_A003", NStr("ru='Справочник Подразделения';
		|en='Catalog Business units';
		|fr='Catalogue Divisions';
		|tr='K Departmanlar';
		|de='Katalog Abteilungen'", CodeLanguage));
	Strings.Insert("Description_A004", NStr("en='Catalog Cash accounts';
		|fr='Catalogue Caisses et comptes bancaires';
		|ru='Справочник Кассы\банковские счета';
		|tr='K Kasa/Banka';
		|de='Katalog Kassenkonten'", CodeLanguage));
	Strings.Insert("Description_A005", NStr("ru='Справочник Банковские чеки';
		|en='Catalog Cheque bonds';
		|fr='Catalogue Chèques et obligations';
		|tr='K Çek/Senetler';
		|de='Katalog Bankschecks und Anleihen'", CodeLanguage));
	Strings.Insert("Description_A006", NStr("en='Catalog Companies';
		|fr='Catalogue Entreprises';
		|ru='Справочник Организации';
		|tr='K Şirketler';
		|de='Katalog Organisationen'", CodeLanguage));
	Strings.Insert("Description_A007", NStr("en='Catalog Company types';
		|ru='Справочник Типы организаций';
		|fr='Catalogue Types des entreprises';
		|tr='K Şirket tipleri';
		|de='Katalog Organisationsarten'", CodeLanguage));
	Strings.Insert("Description_A008", NStr("en='Catalog Countries';
		|fr='Catalogue Pays';
		|ru='Справочник Страны';
		|tr='K Ülkeler';
		|de='Katalog Länder'", CodeLanguage));
	Strings.Insert("Description_A009", NStr("fr='Catalogue Devises';
		|en='Catalog Currencies';
		|ru='Справочник Валюты';
		|tr='K Dövizler';
		|de='Katalog Währungen'", CodeLanguage));
	Strings.Insert("Description_A010", NStr("en='Catalog Expense and revenue types';
		|fr='Catalogue Catégories des dépenses et recettes';
		|ru='Справочник Статьи доходов и расходов';
		|tr='K Gider ve gelir tipleri';
		|de='Katalog Spesen- und Einnahmearten'", CodeLanguage));
	Strings.Insert("Description_A011", NStr("en='Catalog Item keys';
		|ru='Справочник Характеристика номенклатуры';
		|fr='Catalogue Clés des articles';
		|tr='K Varyantlar';
		|de='Dokument Artikelvarianten'", CodeLanguage));
	Strings.Insert("Description_A012", NStr("fr='Catalogue Articles';
		|en='Catalog Items';
		|ru='Справочник Номенклатура';
		|tr='K Malzemeler';
		|de='Katalog Produkte'", CodeLanguage));
	Strings.Insert("Description_A013", NStr("fr='Catalogue Types des articles';
		|en='Catalog Item types';
		|ru='Справочник Виды номенклатуры';
		|tr='K Malzeme tipleri';
		|de='Katalog Produkttypen'", CodeLanguage));
	Strings.Insert("Description_A014", NStr("ru='Справочник Партнеры';
		|en='Catalog Partners';
		|fr='Catalogue Partenaires';
		|tr='K Cari hesaplar';
		|de='Katalog Geschäftspartner'", CodeLanguage));
	Strings.Insert("Description_A015", NStr("fr='Catalogue Clés des prix';
		|ru='Справочник Ключи аналитики ценообразования';
		|en='Catalog Price keys';
		|tr='K Fiyat anahtarları';
		|de='Katalog Preisschlüssel'", CodeLanguage));
	Strings.Insert("Description_A016", NStr("fr='Catalogue Types des prix';
		|en='Catalog Price types';
		|ru='Справочник Виды цен';
		|tr='K Fiyat tipleri';
		|de='Katalog Preistypen'", CodeLanguage));
	Strings.Insert("Description_A017", NStr("ru='Справочник Серии номенклатуры';
		|en='Catalog Serial lot numbers';
		|fr='Catalogue Numéros de série/lot';
		|tr='K Seri lot numaraları';
		|de='Katalog Serien- und Chargennummern'", CodeLanguage));
	Strings.Insert("Description_A018", NStr("ru='Справочник Спецификации товаров';
		|en='Catalog Specifications';
		|fr='Catalogue Spécifications';
		|tr='K Reçeteler';
		|de='Katalog Spezifikationen'", CodeLanguage));
	Strings.Insert("Description_A019", NStr("en='Catalog Stores';
		|ru='Справочник Склады';
		|fr='Catalogue Entrepôts';
		|tr='K Depolar';
		|de='Katalog Lager'", CodeLanguage));
	Strings.Insert("Description_A020", NStr("fr='Catalogue Impôts/Taxes';
		|en='Catalog Taxes';
		|ru='Справочник Налоги';
		|tr='K Vergiler';
		|de='Katalog Steuern'", CodeLanguage));
	Strings.Insert("Description_A021", NStr("ru='Справочник Единицы измерения номенклатуры';
		|en='Catalog Units';
		|fr='Catalogue Unités';
		|tr='K Birimler';
		|de='Katalog Maßeinheiten'", CodeLanguage));
	Strings.Insert("Description_A022", NStr("ru='Справочник Пользователи';
		|fr='Catalogue Utilisateurs';
		|en='Catalog Users';
		|tr='K Kullanıcılar';
		|de='Katalog Benutzer'", CodeLanguage));
	Strings.Insert("Description_A023", NStr("en='Document Bank payment';
		|fr='Document Paiement bancaire';
		|ru='Документ Платежное поручение исходящие';
		|tr='D Banka ödeme fişi';
		|de='Dokument Ausgangszahlung'", CodeLanguage));
	Strings.Insert("Description_A024", NStr("fr='Document Rentrée de fonds sur compte bancaire';
		|en='Document Bank receipt';
		|ru='Документ Платежное поручение входящее';
		|tr='D Banka tahsilat fişi';
		|de='Dokument Eingangszahlung'", CodeLanguage));
	Strings.Insert("Description_A025", NStr("ru='Документ Комплектация набора';
		|fr='Document Création de l''offre groupée';
		|en='Document Bundling';
		|tr='D Takım oluşturma fişi';
		|de='Dokument Bündelung'", CodeLanguage));
	Strings.Insert("Description_A026", NStr("en='Document Cash expense';
		|ru='Документ Прочие наличные расходы';
		|fr='Document Dépense en espèces';
		|tr='D Nakit gider fişi';
		|de='Dokument Barausgabe'", CodeLanguage));
	Strings.Insert("Description_A027", NStr("fr='Document Décaissement';
		|en='Document Cash payment';
		|ru='Документ Расходный кассовый ордер';
		|tr='D Kasa ödeme fişi';
		|de='Dokument Ausgabebeleg'", CodeLanguage));
	Strings.Insert("Description_A028", NStr("ru='Документ Приходный кассовый ордер';
		|fr='Document Encaissement';
		|en='Document Cash receipt';
		|tr='D Kasa tahsilat fişi';
		|de='Dokument Einnahmebeleg'", CodeLanguage));
	Strings.Insert("Description_A029", NStr("ru='Документ Прочие наличные доходы';
		|fr='Document Revenu en espèces';
		|en='Document Cash revenue';
		|tr='D Nakit gelir fişi';
		|de='Dokument Bareinnahme'", CodeLanguage));
	Strings.Insert("Description_A030", NStr("fr='Document Demande de transfert d''argent';
		|ru='Документ Заявка на перемещение денежных средств';
		|en='Document Cash transfer order';
		|tr='D Finansal transfer siparişi';
		|de='Dokument Umbuchungsauftrag'", CodeLanguage));
	Strings.Insert("Description_A031", NStr("ru='Документ Операция по чекам и долговым обязательствам';
		|fr='Document Transaction relative au chèque ou à l''obligation';
		|en='Document Cheque bond transaction';
		|tr='D Çek/Senet bordrosu';
		|de='Dokument Scheck- und Anleihetransaktion'", CodeLanguage));
	Strings.Insert("Description_A032", NStr("en='Document Goods receipt';
		|fr='Document Bon de réception';
		|ru='Документ Приходная товарная накладная';
		|tr='D Satın alma irsaliyesi';
		|de='Dokument Wareneingang'", CodeLanguage));
	Strings.Insert("Description_A033", NStr("fr='Document Demande de l''entrée d''argent';
		|en='Document Incoming payment order';
		|ru='Документ Заявка на поступление денежных средств';
		|tr='D Tahsilat siparişi';
		|de='Dokument Antrag auf Geldeingang'", CodeLanguage));
	Strings.Insert("Description_A034", NStr("en='Document Inventory transfer';
		|fr='Document Transfert de stock';
		|ru='Документ Перемещение товаров';
		|tr='D Depo transfer fişi';
		|de='Dokument Lagerumbuchung'", CodeLanguage));
	Strings.Insert("Description_A035", NStr("ru='Документ Заказ на перемещение товаров';
		|en='Document Inventory transfer order';
		|fr='Document Ordre de transfert de stock';
		|tr='D Depo transfer siparişi';
		|de='Dokument Lagerumbuchungsauftrag'", CodeLanguage));
	Strings.Insert("Description_A036", NStr("fr='Document Rapprochement des factures';
		|ru='Документ Сопоставление документа-основания взаиморасчетов с платежами';
		|en='Document Invoice match';
		|tr='D Fatura kapatma fişi';
		|de='Dokument Rechnungsabgleich'", CodeLanguage));
	Strings.Insert("Description_A037", NStr("ru='Документ Штрихкодирование';
		|en='Document Labeling';
		|fr='Document Étiquetage';
		|tr='D Seri lot tanımlama fişi';
		|de='Dokument Kennzeichnung'", CodeLanguage));
	Strings.Insert("Description_A038", NStr("ru='Документ Ввод начальных остатков';
		|en='Document Opening entry';
		|fr='Document Écriture d''entrée';
		|tr='D Açılış kayıt fişi';
		|de='Dokument Anfangsbestand'", CodeLanguage));
	Strings.Insert("Description_A039", NStr("fr='Document Demande de la sortie d''argent';
		|en='Document Outgoing payment order';
		|ru='Документ Заявка на расходование денежных средств';
		|tr='D Ödeme siparişi';
		|de='Dokument Antrag auf Geldausgang'", CodeLanguage));
	Strings.Insert("Description_A040", NStr("en='Document Physical count by location';
		|fr='Document Comptage physique dans l''entrepôt';
		|ru='Документ Пересчет товаров';
		|tr='D Lokasyon sayım fişi';
		|de='Dokument Inventurliste'", CodeLanguage));
	Strings.Insert("Description_A041", NStr("en='Document Physical inventory';
		|fr='Document Inventaire physique';
		|ru='Документ Инвентаризация товаров';
		|tr='D Sayım fişi';
		|de='Dokument Inventur'", CodeLanguage));
	Strings.Insert("Description_A042", NStr("ru='Документ Установка цен номенклатуры';
		|en='Document Price list';
		|fr='Document Liste des prix';
		|tr='D Fiyat listesi';
		|de='Dokument Preiskalkulation'", CodeLanguage));
	Strings.Insert("Description_A043", NStr("ru='Документ Поступление товаров и услуг';
		|en='Document Purchase invoice';
		|fr='Document Facture d''achat';
		|tr='D Satın alma faturası';
		|de='Dokument Einkaufsrechnung'", CodeLanguage));
	Strings.Insert("Description_A044", NStr("ru='Документ Заказ поставщику';
		|en='Document Purchase order';
		|fr='Document Bon de commande';
		|tr='D Satın alma siparişi';
		|de='Dokument Bestellung'", CodeLanguage));
	Strings.Insert("Description_A045", NStr("en='Document Purchase return';
		|fr='Document Retour d''achat';
		|ru='Документ Возврат поставщику';
		|tr='D Alım iadesi';
		|de='Dokument Lieferantenretoure'", CodeLanguage));
	Strings.Insert("Description_A046", NStr("fr='Document Commande fournisseur de retour';
		|ru='Документ Заказ на возврат поставщику';
		|en='Document Purchase return order';
		|tr='D Alım iade siparişi';
		|de='Dokument Lieferantenretourenauftrag'", CodeLanguage));
	Strings.Insert("Description_A047", NStr("fr='Document Relevé de rapprochement';
		|ru='Документ Сверка взаиморасчетов';
		|en='Document Reconciliation statement';
		|tr='D Cari hesap mutabakat fişi';
		|de='Dokument Offene Posten'", CodeLanguage));
	Strings.Insert("Description_A048", NStr("fr='Document Facture de vente';
		|ru='Документ Реализация товаров и услуг';
		|en='Document Sales invoice';
		|tr='D Satış faturası';
		|de='Dokument Rechnung'", CodeLanguage));
	Strings.Insert("Description_A049", NStr("ru='Документ Заказ покупателя';
		|en='Document Sales order';
		|fr='Document Commande client';
		|tr='D Satış siparişi';
		|de='Dokument Auftrag'", CodeLanguage));
	Strings.Insert("Description_A050", NStr("en='Document Sales return';
		|fr='Document Retour de vente';
		|ru='Документ Возврат товаров от покупателя';
		|tr='D Satış iadesi';
		|de='Dokument Kundenretoure'", CodeLanguage));
	Strings.Insert("Description_A051", NStr("en='Document Sales return order';
		|fr='Document Commande client de retour';
		|ru='Документ Заказ на возврат покупателя';
		|tr='D Satış iade siparişi';
		|de='Dokument Kundenretourenauftrag'", CodeLanguage));
	Strings.Insert("Description_A052", NStr("fr='Document Bon de livraison';
		|ru='Документ Расходная товарная накладная';
		|en='Document Shipment confirmation';
		|tr='D Sevk irsaliyesi';
		|de='Dokument Lieferschein'", CodeLanguage));
	Strings.Insert("Description_A053", NStr("ru='Документ Оприходование товаров';
		|fr='Document Ajustement positif de stock';
		|en='Document Stock adjustment as surplus';
		|tr='D Stok sayım girişi';
		|de='Dokument Aktivierung von Warenüberschüssen'", CodeLanguage));
	Strings.Insert("Description_A054", NStr("ru='Документ Списание товаров';
		|en='Document Stock adjustment as write off';
		|fr='Document Ajustement négatif de stock';
		|tr='D Stok sayım çıkışı';
		|de='Dokument Warenabschreibung'", CodeLanguage));
	Strings.Insert("Description_A056", NStr("fr='Document Suppression de l''offre groupée';
		|ru='Документ Разукомлектация набора';
		|en='Document Unbundling';
		|tr='D Ürün takımı bozma fişi';
		|de='Dokument Entbündelung'", CodeLanguage));
	Strings.Insert("Description_A057", NStr("fr='Défini par l’utilisateur';
		|en='User defined';
		|ru='Произвольный';
		|tr='Kullanıcı tanımlı';
		|de='Benutzerdefiniert'", CodeLanguage));
	Strings.Insert("Description_A058", NStr("ru='Входящие банковские чеки';
		|en='Cheque bond incoming';
		|fr='Chèques/obligations reçus';
		|tr='Gelen çek/senet';
		|de='Eingangsschecks/Anleihen'", CodeLanguage));
	Strings.Insert("Description_A059", NStr("fr='Chèques/obligations émis';
		|en='Cheque bond outgoing';
		|ru='Исходящие банковские чеки';
		|tr='Çıkan çek/senet';
		|de='Ausgangsschecks/Anleihen'", CodeLanguage));
	Strings.Insert("Description_A060", NStr("ru='Документ Списание задолженности';
		|fr='Document Avoir et note de débit';
		|en='Document Credit debit note';
		|tr='D Borç alacak dekontu';
		|de='Dokument Gut- und Lastschrift'", CodeLanguage));
	Strings.Insert("Description_A061", NStr("fr='Devise de règlement';
		|ru='Валюта транзакции';
		|en='Settlement currency';
		|tr='Cari hesap dövizi';
		|de='Abrechnungswährung'", CodeLanguage));
	Strings.Insert("Description_A062", NStr("en='Credit note';
		|fr='Avoir';
		|ru='Кредит-нота';
		|tr='Alacak dekontu';
		|de='Gutschrift'", CodeLanguage));
	Strings.Insert("Description_A063", NStr("ru='Дебет-нота';
		|fr='Note de débit';
		|en='Debit note';
		|tr='Borç dekontu';
		|de='Lastschrift'", CodeLanguage));

EndProcedure