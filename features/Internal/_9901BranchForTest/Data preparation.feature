#language: en
@tree
@ExportScenarios
Feature: Подготовка тестовых данных


Scenario: Подготовка тестовых данных

	// Catalog.Items

	And I check or create catalog "Items" objects:
		| 'Ref'                                                           | 'DeletionMark' | 'Code' | 'ItemType'                                                          | 'Unit'                                     | 'ItemID' | 'PackageUnit' | 'Description_en' |
		| 'e1cib/data/Catalog.Items?ref=b299cc15319d5da411eda70297fce3e7' | 'False'        | 1      | 'e1cib/data/Catalog.ItemTypes?ref=b299cc15319d5da411eda70297fce3e3' | 'e1cib/data/Catalog.Units?refName=Default' | '123'    | ''            | 'Item1'          |

	// Catalog.ItemTypes

	And I check or create catalog "ItemTypes" objects:
		| 'Ref'                                                               | 'DeletionMark' | 'Parent' | 'IsFolder' | 'Code' | 'Type'                   | 'UseSerialLotNumber' | 'StockBalanceDetail'                | 'EachSerialLotNumberIsUnique' | 'AlwaysAddNewRowAfterScan' | 'Description_en' | 'Description_hash' | 'Description_ru' | 'Description_tr' | 'UniqueID'                          |
		| 'e1cib/data/Catalog.ItemTypes?ref=b299cc15319d5da411eda70297fce3e3' | 'False'        | ''       | 'False'    | 1      | 'Enum.ItemTypes.Product' | 'False'              | 'Enum.StockBalanceDetail.ByItemKey' | 'False'                       | 'False'                    | 'Smartphones'    | ''                 | 'Смартфоны'      | 'Smartphones TR' | '_fc1280bef55949899649d63cd954f729' |

