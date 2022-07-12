#language: ru
@tree
@Positive
@BranchForTest

Функционал: тестовые сценарии

Контекст:
		Дано Я открыл новый сеанс TestClient или подключил уже существующий

Сценарий: Подготовка данных

	// Справочник.AddAttributeAndPropertyValues

	И я проверяю или создаю для справочника "AddAttributeAndPropertyValues" объекты:
		| 'Ref'                                                                                   | 'DeletionMark' | 'Owner'                                                                                              | 'Code' | 'AdditionalID' | 'Description_en' | 'Description_hash' | 'Description_ru' | 'Description_tr' | 'UniqueID'                          |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=b762b13668d0905011eb766bf96b2760' | 'False'        | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=b762b13668d0905011eb766bf96b275d' | 8      | ''             | 'Бренд 1'        | ''                 | ''               | ''               | '_31bf0db18f0840a5b67fc9b7f6c2df25' |

	// Справочник.Items

	И я проверяю или создаю для справочника "Items" объекты:
		| 'Ref'                                                           | 'DeletionMark' | 'Code' | 'ItemType'                                                          | 'Unit'                                                          | 'MainPricture'                          | 'Vendor'                                                           | 'ItemID' | 'PackageUnit' | 'Description_en'           | 'Description_hash' | 'Description_ru' | 'Description_tr' | 'Height' | 'Length' | 'Volume' | 'Weight' | 'Width' |
		| 'e1cib/data/Catalog.Items?ref=b762b13668d0905011eb76684b9f687d' | 'False'        | 1      | 'e1cib/data/Catalog.ItemTypes?ref=b762b13668d0905011eb76684b9f6878' | 'e1cib/data/Catalog.Units?ref=b762b13668d0905011eb76684b9f687b' | 'ValueStorage:AQEIAAAAAAAAAO+7v3siVSJ9' | 'e1cib/data/Catalog.Partners?ref=b762b13668d0905011eb7663e35d794d' | '58791'  | ''            | 'Товар с характеристиками' | ''                 | ''               | ''               |          |          |          | 0.21     |         |

	И я перезаполняю для объекта табличную часть "AddAttributes":
		| 'Ref'                                                           | 'Property'                                                                                           | 'Value'                                                                                 |
		| 'e1cib/data/Catalog.Items?ref=b762b13668d0905011eb76684b9f687d' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=b762b13668d0905011eb766bf96b275d' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=b762b13668d0905011eb766bf96b2760' |

	// Справочник.ItemTypes

	И я проверяю или создаю для справочника "ItemTypes" объекты:
		| 'Ref'                                                               | 'DeletionMark' | 'Parent' | 'IsFolder' | 'Code' | 'Type'                   | 'UseSerialLotNumber' | 'Description_en'             | 'Description_hash' | 'Description_ru' | 'Description_tr' | 'UniqueID'                          |
		| 'e1cib/data/Catalog.ItemTypes?ref=b762b13668d0905011eb76684b9f6878' | 'False'        | ''       | 'False'    | 1      | 'Enum.ItemTypes.Product' | 'False'              | 'Товар (есть размер и цвет)' | ''                 | ''               | ''               | '_9809d5c84df64fc48985f8c7ab28fb6b' |

	И я перезаполняю для объекта табличную часть "AvailableAttributes":
		| 'Ref'                                                               | 'Attribute'                                                                                          | 'AffectPricing' | 'Required' | 'ShowInHTML' |
		| 'e1cib/data/Catalog.ItemTypes?ref=b762b13668d0905011eb76684b9f6878' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=b762b13668d0905011eb76684b9f6872' | 'True'          | 'True'     | 'False'      |
		| 'e1cib/data/Catalog.ItemTypes?ref=b762b13668d0905011eb76684b9f6878' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=b762b13668d0905011eb76684b9f6877' | 'False'         | 'True'     | 'False'      |

	// Справочник.Partners

	И я проверяю или создаю для справочника "Partners" объекты:
		| 'Ref'                                                              | 'DeletionMark' | 'Parent' | 'Code' | 'Customer' | 'Vendor' | 'Employee' | 'Opponent' | 'ManagerSegment' | 'Description_en'             | 'Description_hash' | 'Description_ru' | 'Description_tr' |
		| 'e1cib/data/Catalog.Partners?ref=b762b13668d0905011eb7663e35d794d' | 'False'        | ''       | 3      | 'False'    | 'True'   | 'False'    | 'False'    | ''               | 'Поставщик 1 (1 соглашение)' | ''                 | ''               | ''               |

	// Справочник.Units

	И я проверяю или создаю для справочника "Units" объекты:
		| 'Ref'                                                           | 'DeletionMark' | 'Code' | 'Item' | 'Quantity' | 'BasisUnit' | 'UOM' | 'Description_en' | 'Description_hash' | 'Description_ru' | 'Description_tr' | 'Height' | 'Length' | 'Volume' | 'Weight' | 'Width' |
		| 'e1cib/data/Catalog.Units?ref=b762b13668d0905011eb76684b9f687b' | 'False'        | 1      | ''     | 1          | ''          | ''    | 'шт'             | ''                 | ''               | ''               |          |          |          |          |         |

	// ПланВидовХарактеристик.AddAttributeAndProperty

	И я проверяю или создаю для плана видов характеристик "AddAttributeAndProperty" объекты:
		| 'Ref'                                                                                                | 'DeletionMark' | 'Parent' | 'IsFolder' | 'Icon'                                  | 'isIconSet' | 'Description_en' | 'Description_hash' | 'Description_ru' | 'Description_tr' | 'UniqueID'                          |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=b762b13668d0905011eb766bf96b275d' | 'False'        | ''       | 'False'    | 'ValueStorage:AQEIAAAAAAAAAO+7v3siVSJ9' | 'False'     | 'Бренд'          | ''                 | ''               | ''               | '_4355827b63dc41b8b540f65790e07f5d' |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=b762b13668d0905011eb76684b9f6872' | 'False'        | ''       | 'False'    | 'ValueStorage:AQEIAAAAAAAAAO+7v3siVSJ9' | 'False'     | 'Размер'         | ''                 | ''               | ''               | '_aa59a52a77bd48d5af340a2ff98411a9' |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=b762b13668d0905011eb76684b9f6877' | 'False'        | ''       | 'False'    | 'ValueStorage:AQEIAAAAAAAAAO+7v3siVSJ9' | 'False'     | 'Цвет'           | ''                 | ''               | ''               | '_453185245f214e42a64fd25b1daf8614' |
	
	Сценарий: _1228 Открытие формы списка "Items" 

		Дано Я открываю основную форму списка справочника "Items"
		Если появилось предупреждение тогда
			Тогда я вызываю исключение "Не удалось открыть форму справочника Items"
		И Я закрываю текущее окно

	Сценарий: _1228 Открытие формы объекта "Items"

		Дано Я открываю основную форму справочника "Items"
		Если появилось предупреждение тогда
			Тогда я вызываю исключение "Не удалось открыть форму справочника Items"
		И Я закрываю текущее окно

	Сценарий: _1229 Заполнение справочника Items
	
		Дано Я открываю навигационную ссылку "e1cib/list/Catalog.Items"
		Тогда таблица "List" стала равной:
			| 'Code' | 'Description'              | 'Item type'                  | 'Reference'                |
			| '1'    | 'Товар с характеристиками' | 'Товар (есть размер и цвет)' | 'Товар с характеристиками' |
		И я нажимаю на кнопку "Создать"
		Тогда открылась форма "Item (Создание)"
		И в поле "ENG" я ввожу текст "Item0"
		И я нажимаю кнопку выбора у поля "Item type"
		Тогда открылось окно "Item types"
		И в таблице "List" я перехожу к строке:
			| 'Код' | 'Ссылка'                     | 'Description'                |
			| '1'   | 'Товар (есть размер и цвет)' | 'Товар (есть размер и цвет)' |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю кнопку выбора у поля "Unit"
		Тогда открылось окно "Item units"
		И в таблице "List" я перехожу к строке:
			| 'Код' | 'Description' |
			| '1'   | 'шт' 			|
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку "Записать"
		И я закрываю текущее окно
		Тогда таблица "List" содержит строки:
			| 'Code' | 'Description'              | 'Item type'                  | 
			| '1'    | 'Товар с характеристиками' | 'Товар (есть размер и цвет)' | 
			| '2'    | 'Item0'                    | 'Товар (есть размер и цвет)' | 
		
	Сценарий: _1230 Добавление штрих-кода (Barcodes) по номенклатуре

		И я закрываю все окна клиентского приложения
		И Я открываю навигационную ссылку "e1cib/data/Catalog.Items?ref=b762b13668d0905011eb76684b9f687d"
		И В текущем окне я нажимаю кнопку командного интерфейса "Barcodes"
		Тогда открылось окно "Товар с характеристиками (Item)"
		И я нажимаю на кнопку "Создать"
		Тогда открылось окно "Item barcode (создание)"
		И в поле "Barcode" я ввожу текст "0001"
		* Создание тестового серийного номера
			И я нажимаю на кнопку создать поля "Item serial/lot number"
			Тогда открылось окно "Item serial/lot number (создание)"
			И я нажимаю кнопку выбора у поля "Owner"
			Когда открылось окно 'Выбор типа данных'
			И в таблице "TypeTree" я перехожу к строке:
				| 'Колонка1'  |
				| 'Item'      |
			И в таблице "TypeTree" я выбираю текущую строку
			Тогда открылось окно "Items"
			И в таблице "List" я перехожу к строке:
				| 'Код'  |
				| '1'    |
			И в таблице "List" я выбираю текущую строку
			Тогда открылось окно "Item serial/lot number (создание)*"
			И в поле "Serial number" я ввожу текст "1111"
			И я нажимаю на кнопку "Записать и закрыть"
		И я нажимаю кнопку выбора у поля "Unit"
		Тогда открылось окно "Item units"
		И в таблице "List" я перехожу к строке:
			| 'Код' | 'Ссылка' | 'Description' |
			| '1'   | 'шт'     | 'шт'          |
		И в таблице "List" я выбираю текущую строку
		И я нажимаю на кнопку "Записать и закрыть"
		* Проверка 
			Тогда открылось окно "Товар с характеристиками (Item)"
			Тогда таблица "List" содержит строки:
				| 'Barcode' | 'Item serial/lot number' | 'Unit' |
				| '0001'    | '1111'                   | 'шт'   |