#language: en
@tree
@IgnoreOnCIMainBuild
@ExportScenarios

Feature: export scenarios (multi currency landed cost)

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: Create information register CurrencyRates records (MC)

	And I check or create information register "CurrencyRates" records:
		| 'Period'               | 'CurrencyFrom'                                                        | 'CurrencyTo'                                                          | 'Source'                                                                       | 'Multiplicity'  | 'Rate'   |
		| '01.02.2025 00:00:00'  | 'e1cib/data/Catalog.Currencies?ref=86ffd69b4676df1211ea9f63629ef589'  | 'e1cib/data/Catalog.Currencies?ref=86ffd69b4676df1211ea9f63629ef588'  | 'e1cib/data/Catalog.IntegrationSettings?ref=86ffd69b4676df1211ea9f6381ded747'  | '1'             | '40'     |
		| '01.02.2025 00:00:00'  | 'e1cib/data/Catalog.Currencies?ref=86ffd69b4676df1211ea9f63629ef588'  | 'e1cib/data/Catalog.Currencies?ref=86ffd69b4676df1211ea9f63629ef589'  | 'e1cib/data/Catalog.IntegrationSettings?ref=86ffd69b4676df1211ea9f6381ded747'  | '1'             | '0,025'  |

Scenario: Create catalog Items objects (MC)

	And I check or create for catalog "Items" objects with Data Exchange Load parameter set to true:
		| 'Ref'                                                            | 'DeletionMark'  | 'Code'  | 'ItemType'                                                           | 'Unit'                                                           | 'MainPricture'  | 'Vendor'  | 'ItemID'  | 'Description_en'  | 'Description_hash'  | 'Description_ru'  | 'Description_tr'  | 'Length'  | 'Width'  | 'Height'  | 'Volume'  | 'Weight'  |
		| 'e1cib/data/Catalog.Items?ref=aabbccdd4676df1211ea9f67cc000001'  | 'No'            | '0'     | 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f66bce7e209'  | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'  | 'ValueStorage'  | ''        | ''        | 'MC Item A'       | ''                  | ''                | 'MC Item A'       | '0'       | '0'      | '0'       | '0'       | '0'       |
		| 'e1cib/data/Catalog.Items?ref=aabbccdd4676df1211ea9f67cc000002'  | 'No'            | '0'     | 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f66bce7e209'  | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'  | 'ValueStorage'  | ''        | ''        | 'MC Item B'       | ''                  | ''                | 'MC Item B'       | '0'       | '0'      | '0'       | '0'       | '0'       |
		| 'e1cib/data/Catalog.Items?ref=aabbccdd4676df1211ea9f67cc000003'  | 'No'            | '0'     | 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f66bce7e209'  | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'  | 'ValueStorage'  | ''        | ''        | 'MC Item C'       | ''                  | ''                | 'MC Item C'       | '0'       | '0'      | '0'       | '0'       | '0'       |
		| 'e1cib/data/Catalog.Items?ref=aabbccdd4676df1211ea9f67cc000004'  | 'No'            | '0'     | 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f77cc8a03c4'  | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'  | 'ValueStorage'  | ''        | ''        | 'MC Work'         | ''                  | ''                | 'MC Work'         | '0'       | '0'      | '0'       | '0'       | '0'       |

Scenario: Create catalog ItemKeys objects (MC)

	And I check or create for catalog "ItemKeys" objects with Data Exchange Load parameter set to true:
		| 'Ref'                                                               | 'DeletionMark'  | 'Code'  | 'Item'                                                           | 'Unit'  | 'Specification'  | 'AffectPricingMD5'                                 | 'UniqueMD5'                                        | 'ItemKeyID'  | 'Description_en'  | 'Description_hash'  | 'Description_ru'  | 'Description_tr'  | 'Height'  | 'Length'  | 'Volume'  | 'Weight'  | 'Width'  |
		| 'e1cib/data/Catalog.ItemKeys?ref=aabbccdd4676df1211ea9f67cd000001'  | 'False'         | '0'     | 'e1cib/data/Catalog.Items?ref=aabbccdd4676df1211ea9f67cc000001'  | ''      | ''               | 'AA 01 F1 8F 7F D7 7D 0E E3 D5 A9 97 81 3F E0 01'  | 'AA 01 F1 8F 7F D7 7D 0E E3 D5 A9 97 81 3F E0 01'  | ''           | 'MC Item A'       | ''                  | ''                | 'MC Item A'       | '0'       | '0'       | '0'       | '0'       | '0'      |
		| 'e1cib/data/Catalog.ItemKeys?ref=aabbccdd4676df1211ea9f67cd000002'  | 'False'         | '0'     | 'e1cib/data/Catalog.Items?ref=aabbccdd4676df1211ea9f67cc000002'  | ''      | ''               | 'AA 02 F1 8F 7F D7 7D 0E E3 D5 A9 97 81 3F E0 02'  | 'AA 02 F1 8F 7F D7 7D 0E E3 D5 A9 97 81 3F E0 02'  | ''           | 'MC Item B'       | ''                  | ''                | 'MC Item B'       | '0'       | '0'       | '0'       | '0'       | '0'      |
		| 'e1cib/data/Catalog.ItemKeys?ref=aabbccdd4676df1211ea9f67cd000003'  | 'False'         | '0'     | 'e1cib/data/Catalog.Items?ref=aabbccdd4676df1211ea9f67cc000003'  | ''      | ''               | 'AA 03 F1 8F 7F D7 7D 0E E3 D5 A9 97 81 3F E0 03'  | 'AA 03 F1 8F 7F D7 7D 0E E3 D5 A9 97 81 3F E0 03'  | ''           | 'MC Item C'       | ''                  | ''                | 'MC Item C'       | '0'       | '0'       | '0'       | '0'       | '0'      |
		| 'e1cib/data/Catalog.ItemKeys?ref=aabbccdd4676df1211ea9f67cd000004'  | 'False'         | '0'     | 'e1cib/data/Catalog.Items?ref=aabbccdd4676df1211ea9f67cc000004'  | ''      | ''               | 'AA 04 F1 8F 7F D7 7D 0E E3 D5 A9 97 81 3F E0 04'  | 'AA 04 F1 8F 7F D7 7D 0E E3 D5 A9 97 81 3F E0 04'  | ''           | 'MC Work'         | ''                  | ''                | 'MC Work'         | '0'       | '0'       | '0'       | '0'       | '0'      |
