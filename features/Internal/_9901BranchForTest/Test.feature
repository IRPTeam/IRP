#language: ru
@tree
@Positive
@BranchForTest

Функционал: заполнение справочника "Items"

Как Администратор системы я хочу
заполнить элементы справочника "Items",
чтобы появилась возможность создания продаж новых товаров и услуг 

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
		| 'Ref'                                                               | 'DeletionMark' | 'Parent' | 'IsFolder' | 'Code' | 'Type'                   | 'UseSerialLotNumber' | 'Description_en'             | 'Description_hash' | 'Description_ru'           | 'Description_tr' | 'UniqueID'                          |
		| 'e1cib/data/Catalog.ItemTypes?ref=b762b13668d0905011eb76684b9f6878' | 'False'        | ''       | 'False'    | 1      | 'Enum.ItemTypes.Product' | 'False'              | 'Товар (есть размер и цвет)' | ''                 | ''                         | ''               | '_9809d5c84df64fc48985f8c7ab28fb6b' |
		| 'e1cib/data/Catalog.ItemTypes?ref=9f0ae52ac96e608b11eccf699d9ed953' | 'False'        | ''       | 'False'    | 2      | 'Enum.ItemTypes.Service' | 'False'              | 'Услуга без характеристик'   | ''                 | 'Услуга без характеристик' | ''               | '_adbba5e3f8bd4c00b75ce864677accf1' |

	И я перезаполняю для объекта табличную часть "AvailableAttributes":
		| 'Ref'                                                               | 'Attribute'                                                                                          | 'AffectPricing' | 'Required' | 'ShowInHTML' |
		| 'e1cib/data/Catalog.ItemTypes?ref=b762b13668d0905011eb76684b9f6878' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=b762b13668d0905011eb76684b9f6872' | 'True'          | 'True'     | 'False'      |
		| 'e1cib/data/Catalog.ItemTypes?ref=b762b13668d0905011eb76684b9f6878' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=b762b13668d0905011eb76684b9f6877' | 'False'         | 'True'     | 'False'      |

	// Справочник.SerialLotNumbers
	
	И я проверяю или создаю для справочника "SerialLotNumbers" объекты:
		| 'Ref'                                                                      | 'DeletionMark' | 'Code' | 'Description' | 'SerialLotNumberOwner'                                          | 'Inactive' |
		| 'e1cib/data/Catalog.SerialLotNumbers?ref=9f0ae52ac96e608b11eccfbb175413bc' | 'False'        | 1      | '12345'       | 'e1cib/data/Catalog.Items?ref=b762b13668d0905011eb76684b9f687d' | 'False'    |
	
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

Сценарий: заполнение товара в справочнике "Items"
* Открытие формы создания номенклатуры 
	Дано я закрываю все окна клиентского приложения
	И В командном интерфейсе я выбираю 'Sales - A/R' 'Items'
	Тогда открылось окно 'Items'
	И я нажимаю на кнопку с именем 'FormCreate'
	Тогда открылось окно 'Item (create)'
* Заполнение реквизитов товара
	И в поле с именем 'Description_en' я ввожу текст 'Product 01'
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	Тогда открылось окно 'Edit descriptions'
	И в поле с именем 'Description_ru' я ввожу текст 'Товар 01'
	И я нажимаю на кнопку с именем 'FormOk'
	Тогда открылось окно 'Item (create) *'	
	И в поле с именем 'ItemID' я ввожу текст '01'
	И я нажимаю кнопку выбора у поля с именем "ItemType"
	Тогда открылось окно 'Item types'
	И в таблице "List" я перехожу к строке:
		| 'Description'                |
		| 'Товар (есть размер и цвет)' |
	И в таблице "List" я выбираю текущую строку
	Тогда открылось окно 'Item (create) *'
	И я нажимаю кнопку выбора у поля с именем "Unit"
	Тогда открылось окно 'Item units'
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'шт'          |
	И в таблице "List" я выбираю текущую строку
	Тогда открылось окно 'Item (create) *'
	И я нажимаю кнопку выбора у поля с именем "Vendor"
	Тогда открылось окно 'Partners'
	И в таблице "List" я перехожу к строке:
		| 'Description'                |
		| 'Поставщик 1 (1 соглашение)' |
	И в таблице "List" я выбираю текущую строку
	Тогда открылось окно 'Item (create) *'
	И я разворачиваю группу с именем "GroupDimensions"
	И я перехожу к закладке с именем "GroupDimensions"
	И в поле с именем 'Length' я ввожу текст '1,000'
	И в поле с именем 'Width' я ввожу текст '2,000'
	И в поле с именем 'Height' я ввожу текст '3,000'
	И в поле с именем 'Volume' я ввожу текст '4,000'
	И я разворачиваю группу с именем "GroupWeightInformation"
	И я перехожу к закладке с именем "GroupWeightInformation"
	И в поле с именем 'Weight' я ввожу текст '5,000'
* Сохранение элемента, заполнение PackageUnit и сохранение кода нового элемента в переменную
	И я нажимаю на кнопку с именем 'FormWrite'
	И я нажимаю кнопку выбора у поля с именем "PackageUnit"
	Тогда открылось окно 'Item units'
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'шт'          |
	И в таблице "List" я выбираю текущую строку
	И я запоминаю значение поля "Code" как "Code"
	И я нажимаю на кнопку с именем 'FormWriteAndClose'
	И я жду закрытия окна 'Product * (Item)' в течение 20 секунд
* Проверка значений полей у сохраненного элемента
	Когда открылось окно 'Items'
	И в таблице "List" я перехожу к строке:
		| 'Code'   |
		| '$Code$' |
	И в таблице "List" я выбираю текущую строку
	И элемент формы с именем "Code" стал равен '$Code$'
	И элемент формы с именем "Description_en" стал равен 'Product 01'
	И элемент формы с именем "ItemID" стал равен '01'
	И элемент формы с именем "ItemType" стал равен 'Товар (есть размер и цвет)'
	И элемент формы с именем "Unit" стал равен 'шт'
	И элемент формы с именем "PackageUnit" стал равен 'шт'
	И элемент формы с именем "Vendor" стал равен 'Поставщик 1 (1 соглашение)'
	И элемент формы с именем "Length" стал равен '1'
	И элемент формы с именем "Width" стал равен '2'
	И элемент формы с именем "Height" стал равен '3'
	И элемент формы с именем "Volume" стал равен '4'
	И элемент формы с именем "Weight" стал равен '5'
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	Тогда открылось окно 'Edit descriptions'
	И элемент формы с именем "Description_en" стал равен 'Product 01'
	И элемент формы с именем "Description_ru" стал равен 'Товар 01'
	И я закрываю все окна клиентского приложения

Сценарий: заполнение услуги в справочнике "Items"
* Открытие формы создания номенклатуры 
	Дано я закрываю все окна клиентского приложения
	И В командном интерфейсе я выбираю 'Sales - A/R' 'Items'
	Тогда открылось окно 'Items'
	И я нажимаю на кнопку с именем 'FormCreate'
	Тогда открылось окно 'Item (create)'
* Заполнение реквизитов услуги
	И в поле с именем 'Description_en' я ввожу текст 'Service 01'
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	Тогда открылось окно 'Edit descriptions'
	И в поле с именем 'Description_ru' я ввожу текст 'Услуга 01'
	И я нажимаю на кнопку с именем 'FormOk'
	Тогда открылось окно 'Item (create) *'	
	И в поле с именем 'ItemID' я ввожу текст '02'
	И я нажимаю кнопку выбора у поля с именем "ItemType"
	Тогда открылось окно 'Item types'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Услуга без характеристик' |
	И в таблице "List" я выбираю текущую строку
	Тогда открылось окно 'Item (create) *'
	И я нажимаю кнопку выбора у поля с именем "Unit"
	Тогда открылось окно 'Item units'
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'шт'          |
	И в таблице "List" я выбираю текущую строку
	Тогда открылось окно 'Item (create) *'
	И я нажимаю кнопку выбора у поля с именем "Vendor"
	Тогда открылось окно 'Partners'
	И в таблице "List" я перехожу к строке:
		| 'Description'                |
		| 'Поставщик 1 (1 соглашение)' |
	И в таблице "List" я выбираю текущую строку
	Тогда открылось окно 'Item (create) *'
* Сохранение элемента и сохранение кода нового элемента в переменную
	И я нажимаю на кнопку с именем 'FormWrite'
	И я запоминаю значение поля "Code" как "Code"
	И я нажимаю на кнопку с именем 'FormWriteAndClose'
	И я жду закрытия окна 'Product * (Item)' в течение 20 секунд
* Проверка значений полей у сохраненного элемента
	Когда открылось окно 'Items'
	И в таблице "List" я перехожу к строке:
		| 'Code'   |
		| '$Code$' |
	И в таблице "List" я выбираю текущую строку
	И элемент формы с именем "Code" стал равен '$Code$'
	И элемент формы с именем "Description_en" стал равен 'Service 01'
	И элемент формы с именем "ItemID" стал равен '02'
	И элемент формы с именем "ItemType" стал равен 'Услуга без характеристик'
	И элемент формы с именем "Unit" стал равен 'шт'
	И элемент формы с именем "Vendor" стал равен 'Поставщик 1 (1 соглашение)'
	И я нажимаю на кнопку открытия поля с именем "Description_en"
	Тогда открылось окно 'Edit descriptions'
	И элемент формы с именем "Description_en" стал равен 'Service 01'
	И элемент формы с именем "Description_ru" стал равен 'Услуга 01'
	И я закрываю все окна клиентского приложения

Сценарий: добавление штрих-кода по номенклатуре
* Удаление штрих-кода из базы, если он уже существует
	И я выполняю код встроенного языка на сервере без контекста
	"""bsl
	НаборЗаписей = РегистрыСведений.Barcodes.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Barcode.Установить("1234567890");
	НаборЗаписей.Записать();
	"""
* Открытие элемента номенклатуры	
	И я закрываю все окна клиентского приложения
	И В командном интерфейсе я выбираю 'Sales - A/R' 'Items'
	Тогда открылось окно 'Items'
	И в таблице "List" я перехожу к строке:
		| 'Description'              |
		| 'Товар с характеристиками' |
	И в таблице "List" я выбираю текущую строку
	Тогда открылось окно 'Товар с характеристиками (Item)'
* Добавление штрих-кода
	И В текущем окне я нажимаю кнопку командного интерфейса 'Barcodes'
	И я нажимаю на кнопку с именем 'FormCreate'
	Тогда открылось окно 'Item barcode (create)'
	// Barcode.
	И в поле с именем 'Barcode' я ввожу текст '1234567890'
	// Item serial/lot number.
	И я нажимаю кнопку выбора у поля с именем "SerialLotNumber"
	Тогда открылось окно 'Item serial/lot numbers'
	И в таблице "List" я перехожу к строке:
		| 'Serial number' |
		| '12345'         |
	И в таблице "List" я выбираю текущую строку
	Тогда открылось окно 'Item barcode (create) *'
	// Unit.
	И я нажимаю кнопку выбора у поля с именем "Unit"
	Тогда открылось окно 'Item units'
	И в таблице "List" я перехожу к строке:
		| 'Description' |
		| 'шт'          |
	И в таблице "List" я выбираю текущую строку
	Тогда открылось окно 'Item barcode (create) *'
	// Presentation.
	И в поле с именем 'Presentation' я ввожу текст 'Тестовый штрих-код'
	// Запись.
	И я нажимаю на кнопку с именем 'FormWriteAndClose'
	И я жду закрытия окна 'Item barcode (create) *' в течение 20 секунд
* Проверка записи штрих-кода
	Тогда таблица "List" содержит строки:
		| 'Barcode'    | 'Item serial/lot number' | 'Unit' |
		| '1234567890' | '12345'                  | 'шт'   |
	И я закрываю все окна клиентского приложения
		
Сценарий: проверка невозможности создания дубля штрих-кода
* Загрузка первичного штрихкода
	Дано я закрываю все окна клиентского приложения
	И я запоминаю значение выражения '"1234567890"' в переменную "Barcode" 
	И я проверяю или создаю для регистра сведений "Barcodes" записи:
		| 'Barcode'   | 'ItemKey' | 'SerialLotNumber' | 'Unit' | 'Presentation' |
		| '$Barcode$' | ''        | ''                | ''     | ''             |
* Проверка невозможности создания дубля
	И я открываю навигационную ссылку "e1cib/list/InformationRegister.Barcodes"
	И я запоминаю количество строк таблицы "List" как "LinesCount"
	И я нажимаю на кнопку с именем 'FormCreate'
	Тогда открылось окно 'Item barcode (create)'
	И в поле с именем 'Barcode' я ввожу текст '$Barcode$'
	И я нажимаю на кнопку с именем 'FormWriteAndClose'
	Тогда появилось предупреждение, содержащее текст "Record with these key fields exists!*" по шаблону
	И я закрываю все окна клиентского приложения
	И я открываю навигационную ссылку "e1cib/list/InformationRegister.Barcodes"
	И количество строк таблицы "List" равно переменной "LinesCount"
	И я закрываю все окна клиентского приложения
