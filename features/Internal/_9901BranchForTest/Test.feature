#language: ru
@tree
@Positive
@BranchForTest

Функционал: тестовые сценарии

Контекст:
		Дано Я открыл новый сеанс TestClient или подключил уже существующий

Сценарий: Подготовка данных

	// ПланВидовХарактеристик.AddAttributeAndProperty

	И я проверяю или создаю для плана видов характеристик "AddAttributeAndProperty" объекты с обмен данными загрузка истина:
		| 'Ref'                                                                                                | 'DeletionMark' | 'Parent' | 'IsFolder' | 'Icon'                                  | 'isIconSet' | 'Description_en' | 'Description_hash' | 'Description_ru' | 'Description_tr' | 'UniqueID'                          |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=b762b13668d0905011eb766bf96b275d' | 'False'        | ''       | 'False'    | 'ValueStorage:AQEIAAAAAAAAAO+7v3siVSJ9' | 'False'     | 'Бренд'          | ''                 | ''               | ''               | '_4355827b63dc41b8b540f65790e07f5d' |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=b762b13668d0905011eb76684b9f6872' | 'False'        | ''       | 'False'    | 'ValueStorage:AQEIAAAAAAAAAO+7v3siVSJ9' | 'False'     | 'Размер'         | ''                 | ''               | ''               | '_aa59a52a77bd48d5af340a2ff98411a9' |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=b762b13668d0905011eb76684b9f6877' | 'False'        | ''       | 'False'    | 'ValueStorage:AQEIAAAAAAAAAO+7v3siVSJ9' | 'False'     | 'Цвет'           | ''                 | ''               | ''               | '_453185245f214e42a64fd25b1daf8614' |

	// Справочник.AddAttributeAndPropertyValues
	
	И я проверяю или создаю для справочника "AddAttributeAndPropertyValues" объекты с обмен данными загрузка истина:
		| 'Ref'                                                                                   | 'DeletionMark' | 'Owner'                                                                                              | 'Code' | 'AdditionalID' | 'Description_en' | 'Description_hash' | 'Description_ru' | 'Description_tr' | 'UniqueID'                          |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=b762b13668d0905011eb766bf96b2760' | 'False'        | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=b762b13668d0905011eb766bf96b275d' | 8      | ''             | 'Бренд 1'        | ''                 | ''               | ''               | '_31bf0db18f0840a5b67fc9b7f6c2df25' |

	// Справочник.ItemTypes

	И я проверяю или создаю для справочника "ItemTypes" объекты с обмен данными загрузка истина:
		| 'Ref'                                                               | 'DeletionMark' | 'Parent' | 'IsFolder' | 'Code' | 'Type'                   | 'UseSerialLotNumber' | 'Description_en'             | 'Description_hash' | 'Description_ru' | 'Description_tr' | 'UniqueID'                          |
		| 'e1cib/data/Catalog.ItemTypes?ref=b762b13668d0905011eb76684b9f6878' | 'False'        | ''       | 'False'    | 1      | 'Enum.ItemTypes.Product' | 'False'              | 'Товар (есть размер и цвет)' | ''                 | ''               | ''               | '_9809d5c84df64fc48985f8c7ab28fb6b' |

	И я перезаполняю для объекта табличную часть "AvailableAttributes":
		| 'Ref'                                                               | 'Attribute'                                                                                          | 'AffectPricing' | 'Required' | 'ShowInHTML' |
		| 'e1cib/data/Catalog.ItemTypes?ref=b762b13668d0905011eb76684b9f6878' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=b762b13668d0905011eb76684b9f6872' | 'True'          | 'True'     | 'False'      |
		| 'e1cib/data/Catalog.ItemTypes?ref=b762b13668d0905011eb76684b9f6878' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=b762b13668d0905011eb76684b9f6877' | 'False'         | 'True'     | 'False'      |

// Справочник.Items

	И я проверяю или создаю для справочника "Items" объекты с обмен данными загрузка истина:
		| 'Ref'                                                           | 'DeletionMark' | 'Code' | 'ItemType'                                                          | 'Unit'                                                          | 'MainPricture'                          | 'Vendor'                                                           | 'ItemID' | 'PackageUnit' | 'Description_en'           | 'Description_hash' | 'Description_ru' | 'Description_tr' | 'Height' | 'Length' | 'Volume' | 'Weight' | 'Width' |
		| 'e1cib/data/Catalog.Items?ref=b762b13668d0905011eb76684b9f687d' | 'False'        | 1      | 'e1cib/data/Catalog.ItemTypes?ref=b762b13668d0905011eb76684b9f6878' | 'e1cib/data/Catalog.Units?ref=b762b13668d0905011eb76684b9f687b' | 'ValueStorage:AQEIAAAAAAAAAO+7v3siVSJ9' | 'e1cib/data/Catalog.Partners?ref=b762b13668d0905011eb7663e35d794d' | '58791'  | ''            | 'Товар с характеристиками' | ''                 | ''               | ''               |          |          |          | 0.21     |         |

	И я перезаполняю для объекта табличную часть "AddAttributes":
		| 'Ref'                                                           | 'Property'                                                                                           | 'Value'                                                                                 |
		| 'e1cib/data/Catalog.Items?ref=b762b13668d0905011eb76684b9f687d' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=b762b13668d0905011eb766bf96b275d' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=b762b13668d0905011eb766bf96b2760' |

	// Справочник.Partners

	И я проверяю или создаю для справочника "Partners" объекты с обмен данными загрузка истина:
		| 'Ref'                                                              | 'DeletionMark' | 'Parent' | 'Code' | 'Customer' | 'Vendor' | 'Employee' | 'Opponent' | 'ManagerSegment' | 'Description_en'             | 'Description_hash' | 'Description_ru' | 'Description_tr' |
		| 'e1cib/data/Catalog.Partners?ref=b762b13668d0905011eb7663e35d794d' | 'False'        | ''       | 3      | 'False'    | 'True'   | 'False'    | 'False'    | ''               | 'Поставщик 1 (1 соглашение)' | ''                 | ''               | ''               |

	// Справочник.Units

	И я проверяю или создаю для справочника "Units" объекты с обмен данными загрузка истина:
		| 'Ref'                                                           | 'DeletionMark' | 'Code' | 'Item' | 'Quantity' | 'BasisUnit' | 'UOM' | 'Description_en' | 'Description_hash' | 'Description_ru' | 'Description_tr' | 'Height' | 'Length' | 'Volume' | 'Weight' | 'Width' |
		| 'e1cib/data/Catalog.Units?ref=b762b13668d0905011eb76684b9f687b' | 'False'        | 1      | ''     | 1          | ''          | ''    | 'шт'             | ''                 | ''               | ''               |          |          |          |          |         |

	Сценарий: Открытие формы списка "Items" 

	Дано Я открываю основную форму списка справочника "Items"
	Если появилось предупреждение тогда
		Тогда я вызываю исключение "Не удалось открыть форму справочника Items"
	И Я закрываю текущее окно

	Сценарий: Открытие формы объекта "Items"

	Дано Я открываю основную форму справочника "Items"
	Если появилось предупреждение тогда
		Тогда я вызываю исключение "Не удалось открыть форму справочника Items"
	И Я закрываю текущее окно

Сценарий: Проверка на добавление Штрихкода (Barcode) (issue 1230)
* Закрыть все окна пользовательского приложения (перед началом тестирования)
	И я закрываю все окна клиентского приложения
* Проверка Открытие формы списка "Barcodes" (дымовой тест)
	Дано Я открываю основную форму списка регистра сведений "Barcodes"
	Если появилось предупреждение тогда
		Тогда я вызываю исключение "Не удалось открыть форму регистра сведений Barcodes"
	И Я закрываю текущее окно
* Проверка Открытие формы объекта "Barcodes" (дымовой тест)
	Дано Я открываю основную форму регистра сведений "Barcodes"
	Если появилось предупреждение тогда
		Тогда я вызываю исключение "Не удалось открыть форму регистра сведений Barcodes"
	И Я закрываю текущее окно
* Закрыть все окна пользовательского приложения
	И я закрываю все окна клиентского приложения
* Открыть форму ввода штрих кода для элемента справочника Items
	И В командном интерфейсе я выбираю 'Inventory' 'Items'
	И в таблице "List" я перехожу к строке
		| 'Code' | 'Description'              | 'Item type'                  | 'Reference'                |
		| '1'    | 'Товар с характеристиками' | 'Товар (есть размер и цвет)' | 'Товар с характеристиками' |
	И в таблице "List" я выбираю текущую строку
	И В текущем окне я нажимаю кнопку командного интерфейса 'Barcodes'
* Создать новый barcode со значениес "0123456789123"
	И я нажимаю на кнопку с именем 'FormCreate'
* Проверить доступность полей для заполнения на открытой форме
	Если элемент формы с именем "Barcode" отсутствует на форме Тогда
		Тогда я вызываю исключение 'Реквизит "Barcode" отсутствует на форме'
	Если элемент формы "Barcode" существует и невидим на форме Тогда
		Тогда я вызываю исключение 'Реквизит "Barcode" не видим на форме'
	Иначе
		И Проверяю шаги на Исключение:
			|'И элемент формы "Barcode" не доступен'|
	Если элемент формы с именем "Presentation" отсутствует на форме Тогда
		Тогда я вызываю исключение 'Реквизит "Presentation" отсутствует на форме'
	Если элемент формы "Presentation" существует и невидим на форме Тогда
		Тогда я вызываю исключение 'Реквизит "Presentation" не видим на форме'
	Иначе
		И Проверяю шаги на Исключение:
			|'И элемент формы "Presentation" не доступен'|
* Указать данные для реквизитов создаваемого штрих кода
	И в поле с именем 'Barcode' я ввожу текст '0123456789123'
	И в поле с именем 'Presentation' я ввожу текст '0123456789123'
* Проверка успешной записи элемента в регистр сведений
// Этот код нужен как при создании, так и при проверке, поэтому, считаю, что его можно было бы венести в ext сценарий, чтобы не дублировать код...
	Дано я нажимаю на кнопку с именем 'FormWriteAndClose'
	Попытка
		Если появилось предупреждение Тогда
			И я закрываю окно предупреждения			
			И Я закрываю окно 'Item barcode (создание) *'
			И я нажимаю на кнопку с именем 'Button1'
			Тогда я вызываю исключение "Не удалось сохранить новый Штрих код (Barcode)"
	Исключение
	И я жду закрытия окна 'Item barcode (создание) *' в течение 20 секунд
* Проверить корректность созданного штрих кода в форме списка (по реквизиту) после его записи в базу данных
	И в таблице "List" я перехожу к строке
		| 'Barcode'       |
		| '0123456789123' |
* Проверить, что создание для этой же номенклатуры абсолютного ДУБЛЯ имеющегося штрих кода приводит к ошибке (через формирование исключения)
	И я нажимаю на кнопку с именем 'FormCreate'
	И в поле с именем 'Barcode' я ввожу текст '0123456789123'
	И в поле с именем 'Presentation' я ввожу текст '0123456789123'
* Проверка успешной записи элемента в регистр сведений
// Этот код нужен как при создании, так и при проверке, поэтому, считаю, что его можно было бы венести в ext сценарий, чтобы не дублировать код...
	Дано я нажимаю на кнопку с именем 'FormWriteAndClose'
	Попытка
		Если появилось предупреждение Тогда
			И я закрываю окно предупреждения			
			И Я закрываю окно 'Item barcode (создание) *'
			И я нажимаю на кнопку с именем 'Button1'
			Тогда я вызываю исключение "Не удалось сохранить новый Штрих код (Barcode)"
	Исключение
	И я жду закрытия окна 'Item barcode (создание) *' в течение 20 секунд
* Проверить, что штрих код можно успешно удалить
	И я нажимаю на кнопку с именем 'FormDelete'
	И я нажимаю на кнопку с именем 'Button0'
* Проверка отсутствия штрих кода, после успешного удаления
	И Проверяю шаги на Исключение:
		|'И в таблице "List" я перехожу к строке'|
			| 'Barcode'       |
			| '0123456789123' |	
* Проверить что после удаления штрих код можно успешно создать и применить в работе, даже если это точный дубль удаленного
	И я нажимаю на кнопку с именем 'FormCreate'
	И в поле с именем 'Barcode' я ввожу текст '0123456789123'
	И в поле с именем 'Presentation' я ввожу текст '0123456789123'
* Проверка успешной записи элемента в регистр сведений
// Этот код нужен как при создании, так и при проверке, поэтому, считаю, что его можно было бы венести в ext сценарий, чтобы не дублировать код...
	Дано я нажимаю на кнопку с именем 'FormWriteAndClose'
	Попытка
		Если появилось предупреждение Тогда
			И я закрываю окно предупреждения			
			И Я закрываю окно 'Item barcode (создание) *'
			И я нажимаю на кнопку с именем 'Button1'
			Тогда я вызываю исключение "Не удалось сохранить новый Штрих код (Barcode)"
	Исключение
	И я жду закрытия окна 'Item barcode (создание) *' в течение 20 секунд
* Закрыть все окна пользовательского приложения (после окончания тестирования)
	И я закрываю все окна клиентского приложения