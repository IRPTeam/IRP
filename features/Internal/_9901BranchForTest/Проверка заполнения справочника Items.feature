#language: ru

@tree
@BranchForTest

Функционал: проверка заполнения справочника Items

Контекст:
		Дано Я открыл новый сеанс TestClient или подключил уже существующий

Сценарий: Подготовка данных

	// Справочник.ItemTypes

	И я проверяю или создаю для справочника "ItemTypes" объекты:
		| 'Ref'                                                               | 'DeletionMark' | 'Parent' | 'IsFolder' | 'Code' | 'Type'                   | 'UseSerialLotNumber' | 'Description_en'             | 'Description_hash' | 'Description_ru' | 'Description_tr' | 'UniqueID'                          |
		| 'e1cib/data/Catalog.ItemTypes?ref=b762b13668d0905011eb76684b9f6878' | 'False'        | ''       | 'False'    | 1      | 'Enum.ItemTypes.Product' | 'False'              | 'Товар без характеристик'    | ''                 | ''               | ''               | '_9809d5c84df64fc48985f8c7ab28fb6b' |
		| 'e1cib/data/Catalog.ItemTypes?ref=b762b13668d0905011eb76684b9f687a' | 'False'        | ''       | 'False'    | 2      | 'Enum.ItemTypes.Service' | 'False'              | 'Услуги'                     | ''                 | ''               | ''               | '_388e5f43acea441bbb8763a12b66ffca' |

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
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=b762b13668d0905011eb76684b9f6872' | 'False'        | ''       | 'False'    | 'ValueStorage:AQEIAAAAAAAAAO+7v3siVSJ9' | 'False'     | 'Размер'         | ''                 | ''               | ''               | '_aa59a52a77bd48d5af340a2ff98411a9' |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=b762b13668d0905011eb76684b9f6877' | 'False'        | ''       | 'False'    | 'ValueStorage:AQEIAAAAAAAAAO+7v3siVSJ9' | 'False'     | 'Цвет'           | ''                 | ''               | ''               | '_453185245f214e42a64fd25b1daf8614' |

	// Справочник.ItemKeys

	И я проверяю или создаю для справочника "ItemKeys" объекты:
		| 'Ref'                                                              | 'DeletionMark' | 'Code' | 'Item'                                                          | 'Unit' | 'Specification' | 'AffectPricingMD5' | 'UniqueMD5'                                       | 'ItemKeyID' | 'Description_en'          | 'Description_hash'        | 'Description_ru'          | 'Description_tr'          | 'Height' | 'Length' | 'Volume' | 'Weight' | 'Width' |
		| 'e1cib/data/Catalog.ItemKeys?ref=b762b13668d0905011eb766bf96b2753' | 'False'        | 4      | 'e1cib/data/Catalog.Items?ref=b762b13668d0905011eb766bf96b2752' | ''     | ''              | ''                 | '21 C3 7C 38 06 DA 54 AB 82 79 2E CD 15 D7 63 D8' | ''          | 'Услуга'                  | 'Услуга'                  | 'Услуга'                  | 'Услуга'                  |          |          |          |          |         |
		| 'e1cib/data/Catalog.ItemKeys?ref=b762b13668d0905011eb766bf96b2751' | 'False'        | 3      | 'e1cib/data/Catalog.Items?ref=b762b13668d0905011eb766bf96b2750' | ''     | ''              | ''                 | '4D CB F1 F2 F1 F2 40 44 01 6B C8 18 1F CA AC 7C' | ''          | 'Товар без характеристик' | 'Товар без характеристик' | 'Товар без характеристик' | 'Товар без характеристик' |          |          |          |          |         |


Сценарий: _1229 проверка заполнения справочника Items (Product)
И я закрываю все окна клиентского приложения
* Открытие формы создания элемента справочника Items
	Дано Я открываю навигационную ссылку "e1cib/list/Catalog.Items"
	И я нажимаю на кнопку с именем 'FormCreate'
* Заполнение реквизитов
	И в поле с именем 'Description_en' я ввожу текст 'Товар'
	И в поле с именем 'ItemID' я ввожу текст '541324'
	И я нажимаю кнопку выбора у поля с именем "ItemType"
	И в таблице "List" я перехожу к строке:
		| 'Код' | 'Description'             |
		| '1'   | 'Товар без характеристик' |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля с именем "Unit"
	И в таблице "List" я перехожу к строке:
		| 'Код' | 'Description' |
		| '1'   | 'шт'          |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю на кнопку с именем 'FormWrite'
	И я нажимаю кнопку выбора у поля с именем "PackageUnit"
	И в таблице "List" я перехожу к строке:
		| 'Код' | 'Description' |
		| '1'   | 'шт'          |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля с именем "Vendor"
	И в таблице "List" я перехожу к строке:
		| 'Код' | 'Description'                |
		| '3'   | 'Поставщик 1 (1 соглашение)' |
	И в таблице "List" я выбираю текущую строку
	И я разворачиваю группу с именем "GroupDimensions"
	И в поле с именем 'Length' я ввожу текст '10,000'
	И в поле с именем 'Width' я ввожу текст '20,000'
	И в поле с именем 'Height' я ввожу текст '30,000'
	И я разворачиваю группу с именем "GroupWeightInformation"
	И в поле с именем 'Weight' я ввожу текст '2,000'
	И я нажимаю на кнопку с именем 'FormWrite'
	И я запоминаю значение поля с именем "Code" как "КодТовара"
* Проверка заполненных полей	
	И элемент формы с именем "ItemType" стал равен 'Товар без характеристик'
	И элемент формы с именем "ItemID" стал равен '541324'			
	И элемент формы с именем "Unit" стал равен 'шт'
	И элемент формы с именем "PackageUnit" стал равен 'шт'
	И элемент формы с именем "Vendor" стал равен 'Поставщик 1 (1 соглашение)'
	И элемент формы с именем "Code" стал равен '$КодТовара$'
	И элемент формы с именем "Description_en" стал равен 'Товар'
	И элемент формы с именем "Length" стал равен '10,000'
	И элемент формы с именем "Width" стал равен '20,000'
	И элемент формы с именем "Height" стал равен '30,000'	
	И элемент формы с именем "Volume" стал равен '6 000,000'
	И элемент формы с именем "Weight" стал равен '2,000'


Сценарий: _1229 проверка заполнения справочника Items (Service)
И я закрываю все окна клиентского приложения
* Открытие формы создания элемента справочника Items
	Дано Я открываю навигационную ссылку "e1cib/list/Catalog.Items"
	И я нажимаю на кнопку с именем 'FormCreate'
* Заполнение реквизитов
	Когда открылось окно 'Item (создание)'
	И в поле с именем 'Description_en' я ввожу текст 'Услуга'
	И в поле с именем 'ItemID' я ввожу текст '435678'
	И я нажимаю кнопку выбора у поля с именем "ItemType"
	И в таблице "List" я перехожу к строке:
		| 'Код' | 'Description' |
		| '2'   | 'Услуги'      |
	И в таблице "List" я выбираю текущую строку
	И я нажимаю кнопку выбора у поля с именем "Unit"
	И в таблице "List" я перехожу к строке:
		| 'Код' | 'Description' |
		| '1'   | 'шт'          |
	И в таблице "List" я выбираю текущую строку	
	И я нажимаю на кнопку с именем 'FormWrite'
	И я запоминаю значение поля с именем "Code" как "КодУслуги"
* Проверка заполненных полей	
	И элемент формы с именем "ItemType" стал равен 'Услуги'
	И элемент формы с именем "ItemID" стал равен '435678'			
	И элемент формы с именем "Unit" стал равен 'шт'
	И элемент формы с именем "Code" стал равен '$КодУслуги$'
	И элемент формы с именем "Description_en" стал равен 'Услуга'