#language: ru

@tree
@BranchForTest

Функционал: Проверка на добавление штрихкода по номенклатуре

Переменные:
СсылкаНаНоменклатуру = 'e1cib/data/Catalog.Items?ref=a7fc005056a42cfb11ecb01cd39196de'

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

Сценарий: Подготовка данных

	// Справочник.Items

	И я проверяю или создаю для справочника "Items" объекты:
		| 'Ref'                    | 'DeletionMark' | 'Code' | 'ItemType'                                                          | 'Unit'                                                          | 'MainPricture'                          | 'Vendor'                                                           | 'ItemID' | 'PackageUnit'                                                   | 'Description_en' | 'Description_hash' | 'Description_ru' | 'Description_tr' | 'Height' | 'Length' | 'Volume' | 'Weight' | 'Width' |
		| '$СсылкаНаНоменклатуру$' | 'False'        | 1      | 'e1cib/data/Catalog.ItemTypes?ref=b762b13668d0905011eb76684b9f6878' | 'e1cib/data/Catalog.Units?ref=b762b13668d0905011eb76684b9f687b' | 'ValueStorage:AQEIAAAAAAAAAO+7v3siVSJ9' | 'e1cib/data/Catalog.Partners?ref=b762b13668d0905011eb7663e35d794d' | '541324' | 'e1cib/data/Catalog.Units?ref=b762b13668d0905011eb76684b9f687b' | 'Товар'          | ''                 | ''               | ''               | 30       | 10       | 6000     | 2        | 20      |

	// Справочник.ItemTypes

	И я проверяю или создаю для справочника "ItemTypes" объекты:
		| 'Ref'                                                               | 'DeletionMark' | 'Parent' | 'IsFolder' | 'Code' | 'Type'                   | 'UseSerialLotNumber' | 'Description_en'          | 'Description_hash' | 'Description_ru' | 'Description_tr' | 'UniqueID'                          |
		| 'e1cib/data/Catalog.ItemTypes?ref=b762b13668d0905011eb76684b9f6878' | 'False'        | ''       | 'False'    | 1      | 'Enum.ItemTypes.Product' | 'False'              | 'Товар без характеристик' | ''                 | ''               | ''               | '_9809d5c84df64fc48985f8c7ab28fb6b' |

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



Сценарий: _1230 Проверка на добавление штрихкода по номенклатуре
И я закрываю все окна клиентского приложения
Дано Я открываю навигационную ссылку '$СсылкаНаНоменклатуру$'
И В текущем окне я нажимаю кнопку командного интерфейса 'Barcodes'
И я нажимаю на кнопку с именем 'FormCreate'
И я запоминаю строку "12345678" в переменную "Штрихкод"
И в поле с именем 'Barcode' я ввожу текст '$Штрихкод$'
И я нажимаю на кнопку с именем 'FormWriteAndClose'
И я жду закрытия окна 'Item barcode (создание) *' в течение 20 секунд


Сценарий: _1230 Проверка на добавление дубликата штрихкода по номенклатуре 
И я закрываю все окна клиентского приложения
Дано Я открываю навигационную ссылку '$СсылкаНаНоменклатуру$'
И В текущем окне я нажимаю кнопку командного интерфейса 'Barcodes'
И я нажимаю на кнопку с именем 'FormCreate'
И я запоминаю строку "123456789" в переменную "Штрихкод"
И в поле с именем 'Barcode' я ввожу текст '$Штрихкод$'
И я нажимаю на кнопку с именем 'FormWriteAndClose'
И я жду закрытия окна 'Item barcode (создание) *' в течение 20 секунд
И я нажимаю на кнопку с именем 'FormCopy'
И в поле с именем 'Barcode' я ввожу текст '$Штрихкод$'
И я нажимаю на кнопку с именем 'FormWriteAndClose'
Тогда открылось окно '1С:Предприятие'