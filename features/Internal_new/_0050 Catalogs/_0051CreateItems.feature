#language: en
@tree
@Positive
@Test
@Group01

Feature: filling in catalog Items

As an owner
I want to fill out items information
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one
	And I set "True" value to the constant "ShowBetaTesting"
	And I set "True" value to the constant "ShowAlphaTestingSaas"
	And I set "True" value to the constant "UseItemKey"
	And I set "True" value to the constant "UseCompanies"



# All indivisible packages of the same product are wound up using Specification with type Set. Then a separate Item key is created for the product, in which the necessary set is specified.
# and a price is set on it. It's the Set that's stored on the remains. In order to break it up you need to run the Unbandling document
# For the simple accounting of goods in the packages of documents (the remnants are stored pieces) usedItem units of measurement pcs. For each product, a different Unit is specified
# like pcs consisting of 6 pieces, 10 pieces, etc. # In this case, the price of the order gets as the price of a piece. There's pcs going through the registers, too. 

#language: en
@tree

Scenario: Create catalog AddAttributeAndPropertySets objects

	And I check or create catalog "AddAttributeAndPropertySets" objects:
		| 'Ref'                                                                                 | 'DeletionMark' | 'Description_en'                | 'Description_hash' | 'Description_ru' | 'Description_tr' |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=852cc6447117530211e8ee3138740eab' | 'No'           | 'Item key'                      | ''                 | ''               | ''               |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=852cc6447117530211e8ee3138740eac' | 'No'           | 'Items'                         | ''                 | ''               | 'Items'          |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=852cc6447117530211e8ee3138740ead' | 'No'           | 'Item types'                    | ''                 | ''               | ''               |
		

	And I refill object tabular section "Attributes":
		| 'Ref'                                                                                 | 'Attribute'                                                                                          | 'Condition'    | 'IsConditionSet' | 'InterfaceGroup'                                                          | 'Required' | 'ShowInHTML' |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=852cc6447117530211e8ee3138740eab' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=852cc6447117530211e8ee3138740eab' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=852cc6447117530211e8ee3138740eab' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba76300f' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=852cc6447117530211e8ee3138740eab' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba763010' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=852cc6447117530211e8ee3138740eab' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f665492c01f' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=852cc6447117530211e8ee3138740eab' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f77cc8a03c3' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=852cc6447117530211e8ee3138740eab' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f662dd9dbe6' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=852cc6447117530211e8ee3138740eab' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fd51dc32685' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=852cc6447117530211e8ee3138740eab' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fd51dc32684' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=852cc6447117530211e8ee3138740eab' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fd8d0a88a44' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=852cc6447117530211e8ee3138740eab' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fdc5cd11258' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=852cc6447117530211e8ee3138740eab' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fdc64afda99' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=852cc6447117530211e8ee3138740eac' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f662dd9dbe6' | 'ValueStorage' | '0'              | 'e1cib/data/Catalog.InterfaceGroups?ref=86ffd69b4676df1211ea9f6612f95f03' | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=852cc6447117530211e8ee3138740eac' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6647920801' | 'ValueStorage' | '0'              | 'e1cib/data/Catalog.InterfaceGroups?ref=86ffd69b4676df1211ea9f6612f95f02' | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=852cc6447117530211e8ee3138740eac' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f662dd9dbe5' | 'ValueStorage' | '0'              | 'e1cib/data/Catalog.InterfaceGroups?ref=86ffd69b4676df1211ea9f6612f95f01' | 'No'       | 'Yes'        |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=852cc6447117530211e8ee3138740eac' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f664e044467' | 'ValueStorage' | '0'              | 'e1cib/data/Catalog.InterfaceGroups?ref=86ffd69b4676df1211ea9f6612f95f01' | 'No'       | 'Yes'        |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=852cc6447117530211e8ee3138740eac' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fdc6bcf2056' | 'ValueStorage' | '1'              | 'e1cib/data/Catalog.InterfaceGroups?ref=86ffd69b4676df1211ea9f6612f95f02' | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f19' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f1a' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f1c' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f1e' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f1f' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f20' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f21' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f22' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f23' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f24' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f25' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f26' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f27' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f28' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f29' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f2a' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f2b' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f2c' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f2d' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f2e' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f2f' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f69764bf967' | 'ValueStorage' | '0'              | 'e1cib/data/Catalog.InterfaceGroups?ref=86ffd69b4676df1211ea9f69764bf968' | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f30' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f31' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f32' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f34' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f35' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f36' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f37' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f38' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f39' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f3a' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f3b' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f3c' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f3c' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f3c' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fdc5cd11258' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f3d' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f3e' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67a5f4db85' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f3e' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67a5f4db86' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f3e' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67a5f4db87' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86ffd69b4676df1211ea9f6249bb7b8c' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86ffd69b4676df1211ea9f6249bb7b8d' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86ffd69b4676df1211ea9f6249bb7b8e' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86ffd69b4676df1211ea9f6249bb7b8f' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86ffd69b4676df1211ea9f6249bb7b90' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86ffd69b4676df1211ea9f6249bb7b91' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86ffd69b4676df1211ea9f6249bb7b92' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86ffd69b4676df1211ea9f6249bb7b93' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86ffd69b4676df1211ea9f6249bb7b94' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86ffd69b4676df1211ea9f6249bb7b95' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86ffd69b4676df1211ea9f6249bb7b96' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86ffd69b4676df1211ea9f6249bb7b97' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86ffd69b4676df1211ea9f6249bb7b99' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86ffd69b4676df1211ea9f6249bb7b9a' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86ffd69b4676df1211ea9f6249bb7b9b' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | ''                                                                        | 'No'       | 'No'         |

	And I refill object tabular section "Properties":
		| 'Ref'                                                                                 | 'Property'                                                                                           | 'Condition'    | 'IsConditionSet' | 'ShowInHTML' |
		| 'e1cib/data/Catalog.AddAttributeAndPropertySets?ref=86fed69b4676df1211ea6921b09c4f33' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'ValueStorage' | '0'              | 'No'         |

Scenario: Create catalog AddAttributeAndPropertyValues objects

	And I check or create catalog "AddAttributeAndPropertyValues" objects:
		| 'Ref'                                                                                   | 'DeletionMark' | 'Owner'                                                                                              | 'AdditionalID' | 'Description_en' | 'Description_hash' | 'Description_ru' | 'Description_tr' | 'UniqueID'                          |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f66a5a1c97a' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f662dd9dbe5' | ''             | 'York'           | ''                 | ''               | 'York'           | '_61780c9a30cc'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f66a5a1c97b' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f662dd9dbe5' | ''             | 'Gir'            | ''                 | ''               | 'Gir'            | '_2e9e54d76a2e'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f66a5a1c97c' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f662dd9dbe5' | ''             | 'Rose'           | ''                 | ''               | 'Rose'           | '_dacaef8b2afb'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f66acc81347' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f662dd9dbe5' | ''             | 'Montel'         | ''                 | ''               | 'Montel'         | '_e9f9c1e1d609'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f669dff2335' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f662dd9dbe6' | ''             | 'UNIQ'           | ''                 | ''               | 'UNIQ'           | '_f8a82f5be44c'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f669dff2336' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f662dd9dbe6' | ''             | 'PZU'            | ''                 | ''               | 'PZU'            | '_6d39273fe932'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f669dff2337' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f662dd9dbe6' | ''             | 'ODS'            | ''                 | ''               | 'ODS'            | '_a8aa3aef2fa8'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6661aceae2' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | ''             | 'S'              | ''                 | ''               | 'S'              | '_847854424387'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6661aceae3' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | ''             | 'XS'             | ''                 | ''               | 'XS'             | '_2e61bace1e8c'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6661aceae4' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | ''             | 'M'              | ''                 | ''               | 'M'              | '_e4dad4511521'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6668d3d6ee' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | ''             | 'L'              | ''                 | ''               | 'L'              | '_c62381d2b9af'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6668d3d6ef' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | ''             | 'XL'             | ''                 | ''               | 'XL'             | '_c4d1d8f0eec6'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6668d3d6f0' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | ''             | 'XXL'            | ''                 | ''               | 'XXL'            | '_26f2e3b9c227'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f666fff520d' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | ''             | '36'             | ''                 | ''               | '36'             | '_0f51e209d99a'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f666fff520e' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | ''             | '37'             | ''                 | ''               | '37'             | '_de44d415a2d2'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f666fff520f' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | ''             | '38'             | ''                 | ''               | '38'             | '_3da4b5c0a4b9'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f66771ff6dc' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | ''             | '39'             | ''                 | ''               | '39'             | '_3aa8207dccd0'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f66771ff6dd' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | ''             | 'Yellow'         | ''                 | ''               | 'Yellow TR'      | '_d3d694622799'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f66771ff6de' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | ''             | 'Blue'           | ''                 | ''               | 'Blue TR'        | '_808865da130f'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f667f7aca6a' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | ''             | 'Brown'          | ''                 | ''               | 'Brown TR'       | '_a1160bafc19d'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f667f7aca6b' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | ''             | 'White'          | ''                 | ''               | 'White TR'       | '_157586490ba7'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f667f7aca6c' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | ''             | 'Red'            | ''                 | ''               | 'Red TR'         | '_64283f3e07c4'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6686a4e44e' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | ''             | 'Green'          | ''                 | ''               | 'Green TR'       | '_9c6e4bb75ee0'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6686a4e44f' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | ''             | 'Black'          | ''                 | ''               | 'Black TR'       | '_67261ba32cfa'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f668e6488e1' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f664e044467' | ''             | 'Turkey'         | ''                 | ''               | 'Turkey TR'      | '_c0abc47b2113'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f66961f9969' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f664e044467' | ''             | 'Romania'        | ''                 | ''               | 'Romania TR'     | '_4d570251d8dc'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f66961f996a' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f664e044467' | ''             | 'Ukraine'        | ''                 | ''               | 'Ukraine TR'     | '_49e84ca62eff'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f66961f996b' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f664e044467' | ''             | 'Poland'         | ''                 | ''               | 'Poland TR'      | '_14f3f43d4079'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6686a4e450' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f665492c01f' | ''             | '18SD'           | ''                 | ''               | '18SD'           | '_5a298c113210'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f668e6488df' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f665492c01f' | ''             | '19SD'           | ''                 | ''               | '19SD'           | '_a9c60b46822d'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f668e6488e0' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f665492c01f' | ''             | '20SD'           | ''                 | ''               | '20SD'           | '_df99477a6a27'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f67b2708635' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67a5f4db85' | ''             | '790'            | ''                 | ''               | '790'            | '_eab76896e504'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f67b2708636' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67a5f4db86' | ''             | '390'            | ''                 | ''               | '390'            | '_578e36749c7f'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f67b2708638' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67a5f4db87' | ''             | '430'            | ''                 | ''               | '430'            | '_fef9f96236da'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6983653d8d' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f69764bf967' | ''             | 'Region Turkey'  | ''                 | ''               | 'Turkey TR'      | '_e89d01154e40'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6983653d8e' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f69764bf967' | ''             | 'Region Ukraine' | ''                 | ''               | 'Ukraine TR'     | '_4e1d081a3f62'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f77dd02049f' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f77cc8a03c3' | ''             | 'Interner'       | ''                 | ''               | 'Interner TR'    | '_0ea090245868'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f77e3f3ac12' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f77cc8a03c3' | ''             | 'Rent'           | ''                 | ''               | 'Rent TR'        | '_9494a30ddc5b'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9fd539ce1a74' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fd51dc32684' | ''             | ''               | ''                 | ''               | 'Cherry'         | '_3cab4d0ad399'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9fd539ce1a75' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fd51dc32684' | ''             | ''               | ''                 | ''               | 'Mango'          | '_72bfee3ae68f'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9fd544177756' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fd51dc32685' | ''             | ''               | ''                 | ''               | 'Mint'           | '_2faded05183b'                     |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=aa6f120ed92fbced11eae901691bcdd8' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fd51dc32685' | ''             | 'Cherry'         | ''                 | ''               | ''               | '_cc39e21502bc4ee8b0c676069e7a0f3b' |
		| 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=aa6f120ed92fbced11eae901691bcdd5' | 'No'           | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fd8d0a88a44' | ''             | 'fruit'          | ''                 | ''               | 'fruit'          | '_54e3d725a8794f11b2f8bc601cef7c35' |

Scenario: Create catalog ItemKeys objects

	And I check or create catalog "ItemKeys" objects:
		| 'Ref'                                                              | 'DeletionMark' | 'Item'                                                          | 'Unit' | 'Specification'                                                          | 'AffectPricingMD5'                                | 'UniqueMD5'                                       | 'ItemKeyID' |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7dd3ea13cf' | 'No'           | ''                                                              | ''     | ''                                                                       | ''                                                | '50 39 F3 FA 9C D5 D6 E8 20 41 01 5A 4D AA 18 62' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7e1c0b5884' | 'No'           | ''                                                              | ''     | ''                                                                       | ''                                                | '4B BC 85 CE D4 EA 15 1E 51 43 94 22 35 56 A8 D9' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7e8915ed83' | 'No'           | ''                                                              | ''     | ''                                                                       | ''                                                | '3A F8 BC 52 09 47 1E C1 BB 1A 9B E5 6D B3 DC F2' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7ee3c345e1' | 'No'           | ''                                                              | ''     | ''                                                                       | ''                                                | 'B6 79 DF AA 9E 4B 92 E7 D7 C4 97 C4 CF 0F 4D 4C' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7efc0ceca1' | 'No'           | ''                                                              | ''     | ''                                                                       | ''                                                | '9E 24 79 13 5F D5 B6 BF E9 F0 C0 69 F0 81 74 4F' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7f10fd7d4a' | 'No'           | ''                                                              | ''     | ''                                                                       | ''                                                | '36 BF 63 E5 8F 58 0D 24 E6 94 D6 5B C2 C6 CA F5' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7f25d30bf9' | 'No'           | ''                                                              | ''     | ''                                                                       | ''                                                | '1B D4 9A AF 8A 3B 81 B5 06 0F 44 DF 63 22 17 14' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7f37b83157' | 'No'           | ''                                                              | ''     | ''                                                                       | ''                                                | 'D2 6A 70 A0 36 E1 E0 19 35 CC AE B8 57 91 D4 E4' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9facd1d50b9a' | 'No'           | ''                                                              | ''     | ''                                                                       | ''                                                | '36 82 4A A1 43 20 48 0B 5E BB 58 DE 71 6C DC 37' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f672a68bfd5' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66ea4bc26a' | ''     | ''                                                                       | '60 5F F1 8F 7F D7 7D 0E E3 D5 A9 97 81 3F E0 3D' | '60 5F F1 8F 7F D7 7D 0E E3 D5 A9 97 81 3F E0 3D' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f672a68bfd6' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66ea4bc26a' | ''     | ''                                                                       | 'EA 66 43 27 71 F2 CE 84 54 74 13 F5 EE 5F F9 39' | 'EA 66 43 27 71 F2 CE 84 54 74 13 F5 EE 5F F9 39' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f672a68bfd7' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66ea4bc26a' | ''     | ''                                                                       | '11 E9 06 08 00 2E 4C B5 FB D1 84 4C 01 9D 24 24' | '11 E9 06 08 00 2E 4C B5 FB D1 84 4C 01 9D 24 24' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f672a68bfd8' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66ea4bc26a' | ''     | ''                                                                       | 'DB EC 38 CC 4C D4 FB BB 55 5E 8C 22 BD 7A 6E C9' | 'DB EC 38 CC 4C D4 FB BB 55 5E 8C 22 BD 7A 6E C9' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f672a68bfda' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66ea4bc26a' | ''     | ''                                                                       | 'CC 51 AF 67 A4 A5 B1 E9 08 9B 0B C5 1E EF 1B 6F' | 'CC 51 AF 67 A4 A5 B1 E9 08 9B 0B C5 1E EF 1B 6F' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f678e54e214' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66ea4bc26a' | ''     | 'e1cib/data/Catalog.Specifications?ref=86ffd69b4676df1211ea9f6775ad3d07' | ''                                                | '5D 7F 58 B1 3D F3 CF BE 7E E8 25 5D B0 45 5F 13' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f6c5d592971' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66ea4bc26a' | ''     | ''                                                                       | '21 75 EB 16 6A 1B 12 0D EF 23 EB BA 23 52 EB ED' | '21 75 EB 16 6A 1B 12 0D EF 23 EB BA 23 52 EB ED' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7d0bf6c8a7' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66ea4bc26a' | ''     | ''                                                                       | '67 D0 DA FC 71 A1 30 24 8D 5C B3 D0 EA 0B D5 E0' | '67 D0 DA FC 71 A1 30 24 8D 5C B3 D0 EA 0B D5 E0' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f67371f9dd5' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66f09eb6c5' | ''     | ''                                                                       | '48 C3 3F 76 DC 7F C7 DF 90 CD D7 C2 2F 02 11 1C' | '48 C3 3F 76 DC 7F C7 DF 90 CD D7 C2 2F 02 11 1C' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f67371f9dd6' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66f09eb6c5' | ''     | ''                                                                       | '79 FD 1A 9F 3A D9 72 B0 69 DB 44 8E AB D8 96 47' | '79 FD 1A 9F 3A D9 72 B0 69 DB 44 8E AB D8 96 47' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7cb42fc8d7' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66f09eb6c5' | ''     | 'e1cib/data/Catalog.Specifications?ref=86ffd69b4676df1211ea9f7cb42fc8d6' | ''                                                | '16 9E 17 2D 3D BD E4 2C DB 4C 2B 32 41 75 E7 C1' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f673d168c63' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66f09eb6c6' | ''     | ''                                                                       | 'D6 D8 40 7B 33 D7 39 6C 8D AA F1 F5 98 2F B4 57' | 'D6 D8 40 7B 33 D7 39 6C 8D AA F1 F5 98 2F B4 57' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f673d168c64' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66f09eb6c6' | ''     | ''                                                                       | 'E3 5A 14 39 DE 9F 2A B9 1E CC E7 86 69 7A FA 58' | 'E3 5A 14 39 DE 9F 2A B9 1E CC E7 86 69 7A FA 58' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f6745c4ae3b' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66fb552ee5' | ''     | ''                                                                       | '90 BC 20 43 D8 7A 62 A6 E8 59 6B 4F 9E 71 D5 47' | '64 44 37 92 D2 4A 19 01 A2 72 11 89 B4 8B F3 A2' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f6745c4ae3c' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66fb552ee5' | ''     | ''                                                                       | '91 D1 43 64 9D 52 06 F0 78 2D CC BA C4 B7 90 FC' | 'D5 29 E6 43 9D E4 F8 F4 02 02 5D 38 33 D5 1A CD' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f6745c4ae3d' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66fb552ee5' | ''     | ''                                                                       | '40 EC 4F 5B E9 8C A7 72 A6 45 FE F5 14 B6 95 C0' | '4C C1 27 81 94 07 C1 8C CF 87 41 8F 3F 8B 35 F5' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f6745c4ae3e' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66fb552ee5' | ''     | ''                                                                       | '08 6A 16 A8 C1 22 2D 76 6A 83 5D E1 4B 6B 46 2E' | '88 C6 AB 08 8B FB 7D 75 A0 54 65 AB EC 4E 21 0A' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f67971136e8' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66fb552ee5' | ''     | 'e1cib/data/Catalog.Specifications?ref=86ffd69b4676df1211ea9f677fcf8e80' | ''                                                | '75 64 F9 6E 36 79 2B 65 64 9D B1 DA DE 82 A5 6B' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f6752c4ca7e' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66fb552ee6' | ''     | ''                                                                       | '99 4F D4 35 E6 62 8E 1F 3C 0A 15 3B D6 6C 64 FE' | 'A9 18 E3 E2 36 13 3A 41 97 F7 43 AE ED 9C F6 5C' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f6752c4ca7f' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66fb552ee6' | ''     | ''                                                                       | '4B 33 BB 9B B1 A0 50 D5 B5 92 13 1C E2 1D 17 0C' | '94 6C 7B B9 40 D9 AF 25 47 23 BE 8A BB 72 CE 17' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7be037796e' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f67063f374f' | ''     | 'e1cib/data/Catalog.Specifications?ref=86ffd69b4676df1211ea9f7be037796d' | ''                                                | '1A 51 CC 50 D6 E8 55 E2 C4 66 94 9B F9 0F 89 DB' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7cced20356' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f67063f374f' | ''     | 'e1cib/data/Catalog.Specifications?ref=86ffd69b4676df1211ea9f7cced20355' | ''                                                | 'B9 B5 48 A9 EB E6 16 8A 71 21 61 E4 2C EE 9F E1' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9facf041bd0d' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f67063f374f' | ''     | 'e1cib/data/Catalog.Specifications?ref=86ffd69b4676df1211ea9facf041bd0c' | ''                                                | 'BC 52 5A 95 A7 AA 0D B5 26 72 3B 1D 27 0C 23 A0' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7c2a11f827' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f670f95cf7b' | ''     | 'e1cib/data/Catalog.Specifications?ref=86ffd69b4676df1211ea9f7c2a11f826' | ''                                                | 'A3 23 8A 1D AB CC B2 61 E3 70 DB 58 A8 2F 32 24' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=aa6f120ed92fbced11eaeb6e229c8f0a' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f670f95cf7b' | ''     | 'e1cib/data/Catalog.Specifications?ref=aa6f120ed92fbced11eaeb6e229c8f09' | ''                                                | '3E 3C 98 CF 39 14 92 A9 A9 06 7E 0A 8B B0 5F 94' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f77dd0204a0' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f77dd02049e' | ''     | ''                                                                       | ''                                                | 'FC C8 72 43 03 BB 38 55 E6 DC F9 F7 CC 65 85 64' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f77e3f3ac13' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f77dd02049e' | ''     | ''                                                                       | ''                                                | 'A4 BA 31 5D 0D 47 33 D2 68 3B DD 0E 2E F4 3D F9' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7817d19039' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f7817d19038' | ''     | ''                                                                       | ''                                                | 'D8 83 16 9B F0 53 75 99 70 4F 3C F7 2F 6B E5 FD' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f947aa3df53' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f947aa3df52' | ''     | ''                                                                       | ''                                                | '1B 18 E0 46 17 77 8B 66 91 16 C7 CE 50 8D 43 D3' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f947aa3df54' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f947aa3df52' | ''     | ''                                                                       | ''                                                | '58 AD 2A 71 79 DF FE 80 05 A9 CD F1 B5 53 E4 A9' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f9b4495eb26' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f9b4495eb25' | ''     | ''                                                                       | 'BD F5 B6 E4 F5 54 8F D4 1D 79 21 73 1F C0 EB 8A' | 'BD F5 B6 E4 F5 54 8F D4 1D 79 21 73 1F C0 EB 8A' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9fd562c8ab48' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9fd530ded376' | ''     | ''                                                                       | ''                                                | '77 E8 DF 39 7E 75 73 52 1D 58 94 E4 5E 19 67 D7' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9fd584d6e5c8' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9fd530ded376' | ''     | ''                                                                       | ''                                                | '43 C8 4F 8D 1A 5B F2 AA 21 71 6D 47 C2 64 91 ED' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9fd584d6e5c9' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9fd530ded376' | ''     | ''                                                                       | ''                                                | '5D B0 A5 12 FE 03 77 09 92 7D CB 8D 55 41 60 31' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=aa6f120ed92fbced11eaeb6e30902da2' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9fd530ded376' | ''     | 'e1cib/data/Catalog.Specifications?ref=aa6f120ed92fbced11eaeb6e30902da1' | ''                                                | '1B BC 43 C0 66 56 4C 3B 76 90 7E 8F E5 D5 37 6A' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=aa6f120ed92fbced11eae901691bcdd6' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9fd8d73442c1' | ''     | ''                                                                       | ''                                                | '40 1F A5 FE 78 48 62 BE CF 6B E6 79 34 9C A0 A8' | ''          |
		| 'e1cib/data/Catalog.ItemKeys?ref=aa6f120ed92fbced11eaeb6f1310c261' | 'No'           | 'e1cib/data/Catalog.Items?ref=aa6f120ed92fbced11eae901691bcdd7' | ''     | 'e1cib/data/Catalog.Specifications?ref=aa6f120ed92fbced11eaeb6f1310c260' | ''                                                | '02 85 EF 98 37 69 9A C5 A6 48 78 1C BA 49 C3 34' | ''          |

	And I refill object tabular section "AddAttributes":
		| 'Ref'                                                              | 'Property'                                                                                           | 'Value'                                                                                 | 'SearchLiteral' |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7dd3ea13cf' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba76300f' | '101'                                                                                   | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7dd3ea13cf' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba763010' | '12150001908090'                                                                        | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7e1c0b5884' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba76300f' | '101'                                                                                   | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7e1c0b5884' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba763010' | '12150001908091'                                                                        | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7e8915ed83' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba76300f' | '101'                                                                                   | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7e8915ed83' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba763010' | '12150001908092'                                                                        | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7ee3c345e1' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba76300f' | '101'                                                                                   | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7ee3c345e1' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba763010' | '12150001908093'                                                                        | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7efc0ceca1' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba76300f' | '101'                                                                                   | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7efc0ceca1' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba763010' | '12150001908094'                                                                        | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7f10fd7d4a' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba76300f' | '101'                                                                                   | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7f10fd7d4a' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba763010' | '12150001908095'                                                                        | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7f25d30bf9' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba76300f' | '112'                                                                                   | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7f25d30bf9' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba763010' | '121500019080'                                                                          | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7f37b83157' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba76300f' | '114'                                                                                   | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7f37b83157' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba763010' | '1215000190801'                                                                         | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9facd1d50b9a' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba76300f' | ''                                                                                      | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9facd1d50b9a' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba763010' | ''                                                                                      | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f672a68bfd5' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6661aceae2' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f672a68bfd5' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f66771ff6dd' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f672a68bfd6' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6661aceae3' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f672a68bfd6' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f66771ff6de' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f672a68bfd7' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6661aceae4' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f672a68bfd7' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f667f7aca6b' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f672a68bfd8' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6668d3d6ee' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f672a68bfd8' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6686a4e44e' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f672a68bfda' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6668d3d6ef' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f672a68bfda' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6686a4e44e' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f6c5d592971' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6668d3d6f0' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f6c5d592971' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f667f7aca6c' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7d0bf6c8a7' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6661aceae4' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7d0bf6c8a7' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f667f7aca6a' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f67371f9dd5' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f666fff520d' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f67371f9dd5' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f66771ff6dd' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f67371f9dd6' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f666fff520f' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f67371f9dd6' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f66771ff6dd' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f673d168c63' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f666fff520d' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f673d168c63' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f667f7aca6c' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f673d168c64' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f666fff520f' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f673d168c64' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6686a4e44f' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f6745c4ae3b' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f666fff520d' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f6745c4ae3b' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f665492c01f' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6686a4e450' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f6745c4ae3c' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f666fff520e' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f6745c4ae3c' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f665492c01f' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6686a4e450' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f6745c4ae3d' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f666fff520f' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f6745c4ae3d' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f665492c01f' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6686a4e450' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f6745c4ae3e' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f66771ff6dc' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f6745c4ae3e' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f665492c01f' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6686a4e450' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f6752c4ca7e' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f66771ff6dc' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f6752c4ca7e' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f665492c01f' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f668e6488df' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f6752c4ca7f' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f666fff520e' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f6752c4ca7f' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f665492c01f' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f668e6488df' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f77dd0204a0' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f77cc8a03c3' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f77dd02049f' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f77e3f3ac13' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f77cc8a03c3' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f77e3f3ac12' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f947aa3df53' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f662dd9dbe6' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f669dff2337' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f947aa3df54' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f662dd9dbe6' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f669dff2336' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f9b4495eb26' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f6661aceae3' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f9b4495eb26' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f667f7aca6c' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9fd562c8ab48' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fd51dc32685' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=aa6f120ed92fbced11eae901691bcdd8' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9fd562c8ab48' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fd51dc32684' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9fd539ce1a75' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9fd584d6e5c8' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fd51dc32685' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9fd544177756' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9fd584d6e5c8' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fd51dc32684' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9fd539ce1a75' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9fd584d6e5c9' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fd51dc32685' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9fd544177756' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9fd584d6e5c9' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fd51dc32684' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9fd539ce1a74' | ''              |
		| 'e1cib/data/Catalog.ItemKeys?ref=aa6f120ed92fbced11eae901691bcdd6' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fd8d0a88a44' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=aa6f120ed92fbced11eae901691bcdd5' | ''              |

	And I refill object tabular section "SpecificationAffectPricingMD5":
		| 'Ref'                                                              | 'Key'                                  | 'AffectPricingMD5'                                |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f678e54e214' | '4541b7df-82ad-4452-bba5-b916f4418848' | '60 5F F1 8F 7F D7 7D 0E E3 D5 A9 97 81 3F E0 3D' |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f678e54e214' | '28c42085-1e3c-494d-939c-8c30b126936d' | 'EA 66 43 27 71 F2 CE 84 54 74 13 F5 EE 5F F9 39' |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f678e54e214' | '5d826c63-9b35-49d7-a619-f5a94d4d8c1e' | '67 D0 DA FC 71 A1 30 24 8D 5C B3 D0 EA 0B D5 E0' |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f678e54e214' | 'a8f86b5e-347b-48b6-9ee4-0688199552f1' | 'DB EC 38 CC 4C D4 FB BB 55 5E 8C 22 BD 7A 6E C9' |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7cb42fc8d7' | '799e418a-208b-4b95-8107-9c4b68e55175' | '48 C3 3F 76 DC 7F C7 DF 90 CD D7 C2 2F 02 11 1C' |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7cb42fc8d7' | 'ba3c8eca-85e5-4f59-87e7-af4428791bb3' | '79 FD 1A 9F 3A D9 72 B0 69 DB 44 8E AB D8 96 47' |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f67971136e8' | '8f2083c0-7a4e-487c-93c0-cdbe3bf21198' | '90 BC 20 43 D8 7A 62 A6 E8 59 6B 4F 9E 71 D5 47' |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f67971136e8' | '17fb2a47-86ac-4c8e-a139-02d25ac8a247' | '91 D1 43 64 9D 52 06 F0 78 2D CC BA C4 B7 90 FC' |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f67971136e8' | 'cb6688a3-b96e-4d65-bb17-34f9f718e468' | '40 EC 4F 5B E9 8C A7 72 A6 45 FE F5 14 B6 95 C0' |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f67971136e8' | 'b20e1dbd-325b-4e47-afa0-4edce269d834' | '08 6A 16 A8 C1 22 2D 76 6A 83 5D E1 4B 6B 46 2E' |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7be037796e' | '63350b42-caa6-4739-8dc4-620378a7d633' | 'EA 66 43 27 71 F2 CE 84 54 74 13 F5 EE 5F F9 39' |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7be037796e' | 'b7a5a7f8-c52c-4cad-8591-fc5188857849' | 'D6 D8 40 7B 33 D7 39 6C 8D AA F1 F5 98 2F B4 57' |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7cced20356' | 'd9b0abd1-35d8-44b9-848f-ea56db4a5739' | 'EA 66 43 27 71 F2 CE 84 54 74 13 F5 EE 5F F9 39' |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7cced20356' | 'a4f9f902-cdd9-43b1-893f-7365b2468f97' | 'EA 66 43 27 71 F2 CE 84 54 74 13 F5 EE 5F F9 39' |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7cced20356' | 'ffbeda93-4abc-48d2-9124-0e063d5df061' | 'DB EC 38 CC 4C D4 FB BB 55 5E 8C 22 BD 7A 6E C9' |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7cced20356' | 'a21d594c-d53e-4f88-95bb-4517ecb4afb6' | 'D6 D8 40 7B 33 D7 39 6C 8D AA F1 F5 98 2F B4 57' |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9facf041bd0d' | '348fcc5c-7f28-4c3c-9d1e-68371646e3d6' | 'F3 F2 A1 EB 61 B1 4E 27 85 98 23 C4 AA E8 35 A9' |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7c2a11f827' | '74621fc5-231d-4bab-97be-4f51cf76cea8' | 'EA 66 43 27 71 F2 CE 84 54 74 13 F5 EE 5F F9 39' |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7c2a11f827' | '86a95767-2732-485a-a6be-5e2c922822fe' | '11 E9 06 08 00 2E 4C B5 FB D1 84 4C 01 9D 24 24' |
		| 'e1cib/data/Catalog.ItemKeys?ref=86ffd69b4676df1211ea9f7c2a11f827' | '4bb2eec9-0edf-4fc5-b8e7-d3fe2deea3bb' | '48 C3 3F 76 DC 7F C7 DF 90 CD D7 C2 2F 02 11 1C' |
		| 'e1cib/data/Catalog.ItemKeys?ref=aa6f120ed92fbced11eaeb6e229c8f0a' | '95c32ac3-5901-425c-a81b-eca4539cfc79' | 'EA 66 43 27 71 F2 CE 84 54 74 13 F5 EE 5F F9 39' |
		| 'e1cib/data/Catalog.ItemKeys?ref=aa6f120ed92fbced11eaeb6e229c8f0a' | '73d15bce-7d9b-4503-8951-a35a56da5335' | '48 C3 3F 76 DC 7F C7 DF 90 CD D7 C2 2F 02 11 1C' |
		| 'e1cib/data/Catalog.ItemKeys?ref=aa6f120ed92fbced11eaeb6e30902da2' | 'fab41f8d-f777-4ea4-a7a6-30c98b34032a' | ''                                                |
		| 'e1cib/data/Catalog.ItemKeys?ref=aa6f120ed92fbced11eaeb6e30902da2' | '0c0766cd-32d4-43e4-97a4-7e5a620b590d' | ''                                                |
		| 'e1cib/data/Catalog.ItemKeys?ref=aa6f120ed92fbced11eaeb6f1310c261' | '017213e4-bd42-424f-9da0-0c86e4f70d3c' | ''                                                |
		| 'e1cib/data/Catalog.ItemKeys?ref=aa6f120ed92fbced11eaeb6f1310c261' | '0a66354d-5b28-488d-8ead-77856fdf43ab' | ''                                                |

Scenario: Create catalog ItemTypes objects

	And I check or create catalog "ItemTypes" objects:
		| 'Ref'                                                               | 'DeletionMark' | 'Parent'                                                            | 'IsFolder' | 'Type'                   | 'Description_en' | 'Description_hash' | 'Description_ru' | 'Description_tr' | 'UniqueID'                          |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9fddddc748b9' | 'No'           | ''                                                                  | 'Yes'      | ''                       | ''               | ''                 | ''               | 'Accessories TR' | ''                                  |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f66bce7e209' | 'No'           | ''                                                                  | 'No'       | 'Enum.ItemTypes.Product' | 'Сlothes'        | ''                 | ''               | 'Сlothes TR'     | ''                                  |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f66bce7e20a' | 'No'           | ''                                                                  | 'No'       | 'Enum.ItemTypes.Product' | 'Box'            | ''                 | ''               | 'Box TR'         | ''                                  |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f66c8d33418' | 'No'           | ''                                                                  | 'No'       | 'Enum.ItemTypes.Product' | 'Shoes'          | ''                 | ''               | 'Shoes TR'       | ''                                  |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f77cc8a03c4' | 'No'           | ''                                                                  | 'No'       | 'Enum.ItemTypes.Service' | 'Service'        | ''                 | ''               | 'Service TR'     | ''                                  |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f7817d19037' | 'No'           | ''                                                                  | 'No'       | 'Enum.ItemTypes.Product' | 'Equipment'      | ''                 | ''               | ''               | ''                                  |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f947aa3df51' | 'No'           | ''                                                                  | 'No'       | 'Enum.ItemTypes.Product' | 'Bags'           | ''                 | ''               | 'Bags TR'        | ''                                  |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9fd5297cda41' | 'No'           | ''                                                                  | 'No'       | 'Enum.ItemTypes.Product' | 'Сhewing gum'    | ''                 | ''               | 'Сhewing gum'    | '_a55ad99dcf674d9d9c685f859948c2ef' |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9fd8d0a88a45' | 'No'           | ''                                                                  | 'No'       | 'Enum.ItemTypes.Product' | 'Candy'          | ''                 | ''               | 'Candy TR'       | '_f6f51b7d9fe34e19a45259d835a443a0' |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9fdc53fbba07' | 'No'           | ''                                                                  | 'No'       | 'Enum.ItemTypes.Product' | 'Socks'          | ''                 | ''               | 'Warm Socks TR'  | ''                                  |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9fdde422b39d' | 'No'           | 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9fddddc748b9' | 'No'       | 'Enum.ItemTypes.Product' | 'Earrings'       | ''                 | ''               | 'Earrings TR'    | ''                                  |

	And I refill object tabular section "AvailableAttributes":
		| 'Ref'                                                               | 'Attribute'                                                                                          | 'AffectPricing' | 'Required' | 'ShowInHTML' |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f66bce7e209' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'Yes'           | 'No'       | 'Yes'        |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f66bce7e209' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | 'Yes'           | 'No'       | 'Yes'        |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f66bce7e20a' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba76300f' | 'No'            | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f66bce7e20a' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba763010' | 'No'            | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f66c8d33418' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'Yes'           | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f66c8d33418' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f665492c01f' | 'No'            | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f77cc8a03c4' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f77cc8a03c3' | 'No'            | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f947aa3df51' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f662dd9dbe6' | 'No'            | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9fd5297cda41' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fd51dc32685' | 'No'            | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9fd5297cda41' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fd51dc32684' | 'No'            | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9fd8d0a88a45' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fd8d0a88a44' | 'No'            | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9fdc53fbba07' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fdc5cd11258' | 'Yes'           | 'No'       | 'No'         |
		| 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9fdc53fbba07' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fdc64afda99' | 'No'            | 'No'       | 'No'         |

Scenario: Create catalog Units objects

	And I check or create catalog "Units" objects:
		| 'Ref'                                                           | 'DeletionMark' | 'Item'                                                          | 'Quantity' | 'BasisUnit'                                                     | 'UOM' | 'Description_en'         | 'Description_hash' | 'Description_ru' | 'Description_tr'             |
		| 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | 'No'           | ''                                                              | '1'        | ''                                                              | ''    | 'pcs'                    | ''                 | ''               | 'adet'                       |
		| 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62d' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f67063f374e' | '4'        | 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | ''    | 'box (4 pcs)'            | ''                 | ''               | 'box (4 adet)'               |
		| 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63d5a27bf8' | 'No'           | ''                                                              | '8'        | 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | ''    | 'box (8 pcs)'            | ''                 | ''               | 'box (8 adet)'               |
		| 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63d5a27bf9' | 'No'           | ''                                                              | '16'       | 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | ''    | 'box (16 pcs)'           | ''                 | ''               | 'box (16 adet)'              |
		| 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f67655a2946' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66fb552ee6' | '8'        | 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | ''    | 'High shoes box (8 pcs)' | ''                 | ''               | 'High shoes box (8 adet) TR' |
		| 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f67655a2947' | 'No'           | 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66fb552ee5' | '12'       | 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | ''    | 'Boots (12 pcs)'         | ''                 | ''               | 'Boots (12 adet) TR'         |

Scenario: Create catalog Items objects

	And I check or create catalog "Items" objects:
		| 'Ref'                                                           | 'DeletionMark' | 'ItemType'                                                          | 'Unit'                                                          | 'MainPricture' | 'Vendor' | 'ItemID' | 'Description_en'         | 'Description_hash' | 'Description_ru' | 'Description_tr'          |
		| 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66ea4bc26a' | 'No'           | 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f66bce7e209' | 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | 'ValueStorage' | ''       | ''       | 'Dress'                  | ''                 | ''               | 'Dress TR'                |
		| 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66f09eb6c5' | 'No'           | 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f66bce7e209' | 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | 'ValueStorage' | ''       | ''       | 'Trousers'               | ''                 | ''               | 'Trousers TR'             |
		| 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66f09eb6c6' | 'No'           | 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f66bce7e209' | 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | 'ValueStorage' | ''       | ''       | 'Shirt'                  | ''                 | ''               | 'Shirt TR'                |
		| 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66fb552ee5' | 'No'           | 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f66c8d33418' | 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | 'ValueStorage' | ''       | ''       | 'Boots'                  | ''                 | ''               | 'Boots TR'                |
		| 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66fb552ee6' | 'No'           | 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f66c8d33418' | 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | 'ValueStorage' | ''       | ''       | 'High shoes'             | ''                 | ''               | 'High shoes TR'           |
		| 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f67063f374e' | 'Yes'          | 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f66bce7e20a' | 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | 'ValueStorage' | ''       | ''       | 'Box'                    | ''                 | ''               | 'Box TR'                  |
		| 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f67063f374f' | 'No'           | 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f66bce7e209' | 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | 'ValueStorage' | ''       | ''       | 'Bound Dress+Shirt'      | ''                 | ''               | 'Bound Dress+Shirt TR'    |
		| 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f670f95cf7b' | 'No'           | 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f66bce7e209' | 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | 'ValueStorage' | ''       | ''       | 'Bound Dress+Trousers'   | ''                 | ''               | 'Bound Dress+Trousers TR' |
		| 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f77dd02049e' | 'No'           | 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f77cc8a03c4' | 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | 'ValueStorage' | ''       | ''       | 'Service'                | ''                 | ''               | 'Service TR'              |
		| 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f7817d19038' | 'No'           | 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f7817d19037' | 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | 'ValueStorage' | ''       | ''       | 'Router'                 | ''                 | ''               | ''                        |
		| 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f947aa3df52' | 'No'           | 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f947aa3df51' | 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | 'ValueStorage' | ''       | ''       | 'Bag'                    | ''                 | ''               | 'Bag TR'                  |
		| 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f9b4495eb25' | 'No'           | 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9f66bce7e209' | 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | 'ValueStorage' | ''       | ''       | 'Scarf'                  | ''                 | ''               | ''                        |
		| 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9fd530ded376' | 'No'           | 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9fd5297cda41' | 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | 'ValueStorage' | ''       | ''       | 'Сhewing gum'            | ''                 | ''               | 'Сhewing gum TR'          |
		| 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9fd8d73442c1' | 'No'           | 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9fd8d0a88a45' | 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | 'ValueStorage' | ''       | ''       | 'Skittles'               | ''                 | ''               | 'Skittles TR'             |
		| 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9fdd2dcc5654' | 'No'           | 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9fdc53fbba07' | 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | 'ValueStorage' | ''       | ''       | ''                       | ''                 | ''               | 'Socks'                   |
		| 'e1cib/data/Catalog.Items?ref=aa6f120ed92fbced11eae901691bcdd7' | 'No'           | 'e1cib/data/Catalog.ItemTypes?ref=86ffd69b4676df1211ea9fd8d0a88a45' | 'e1cib/data/Catalog.Units?ref=86ffd69b4676df1211ea9f63ccabb62c' | 'ValueStorage' | ''       | ''       | 'Skittles + Сhewing gum' | ''                 | ''               | ''                        |

	And I refill object tabular section "AddAttributes":
		| 'Ref'                                                           | 'Property'                                                                                           | 'Value'                                                                                 |
		| 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66ea4bc26a' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f662dd9dbe6' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f669dff2335' |
		| 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66ea4bc26a' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f662dd9dbe5' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f66a5a1c97c' |
		| 'e1cib/data/Catalog.Items?ref=86ffd69b4676df1211ea9f66ea4bc26a' | 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f664e044467' | 'e1cib/data/Catalog.AddAttributeAndPropertyValues?ref=86ffd69b4676df1211ea9f66961f996b' |

Scenario: Create chart of characteristic types AddAttributeAndProperty objects

	And I check or create chart of characteristic types "AddAttributeAndProperty" objects:
		| 'Ref'                                                                                                | 'DeletionMark' | 'Icon'         | 'isIconSet' | 'Description_en'         | 'Description_hash' | 'Description_ru' | 'Description_tr'            | 'UniqueID'       |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fdc5cd11258' | 'No'           | 'ValueStorage' | 'No'        | 'Color Socks'            | ''                 | ''               | 'Color Socks TR'            | '_0046bfe6d2da'  |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fd8d0a88a44' | 'No'           | 'ValueStorage' | 'No'        | ''                       | ''                 | ''               | 'Taste TR'                  | '_15f03c9acfe2'  |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fdc6bcf2056' | 'No'           | 'ValueStorage' | 'No'        | 'Article Socks'          | ''                 | ''               | 'Article Socks TR'          | '_669faa013dc1'  |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fd51dc32684' | 'No'           | 'ValueStorage' | 'No'        | ''                       | ''                 | ''               | 'Сhewing gum taste'         | '_90b9775b72c1'  |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fd51dc32685' | 'No'           | 'ValueStorage' | 'No'        | ''                       | ''                 | ''               | 'Сhewing gum brand'         | '_9b6397b02f7f'  |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f97c344cc37' | 'No'           | 'ValueStorage' | 'No'        | 'Test'                   | ''                 | ''               | 'Test TR'                   | '_a154'          |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9fdc64afda99' | 'No'           | 'ValueStorage' | 'No'        | 'Brand Socks'            | ''                 | ''               | 'Brand Socks TR'            | '_f6945b713190'  |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f77cc8a03c3' | 'No'           | 'ValueStorage' | 'No'        | 'Service type'           | ''                 | ''               | 'Service type TR'           | '_f9075c2bfa0a'  |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba763010' | 'No'           | 'ValueStorage' | 'No'        | 'barcode'                | ''                 | ''               | 'barcode tr'                | 'barcode'        |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f69764bf967' | 'No'           | 'ValueStorage' | 'No'        | 'Business region'        | ''                 | ''               | 'Business region TR'        | 'BusinessRegion' |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6640e7ca95' | 'No'           | 'ValueStorage' | 'No'        | 'Color'                  | ''                 | ''               | 'Color TR'                  | 'Color1'         |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67a5f4db87' | 'No'           | 'ValueStorage' | 'No'        | 'height'                 | ''                 | ''               | 'height'                    | 'height'         |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67ba76300f' | 'No'           | 'ValueStorage' | 'No'        | 'Inv. number'            | ''                 | ''               | 'Inv. number tr'            | 'invoice'        |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67a5f4db85' | 'No'           | 'ValueStorage' | 'No'        | 'length'                 | ''                 | ''               | 'length'                    | 'length'         |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f663743ae06' | 'No'           | 'ValueStorage' | 'No'        | 'Size'                   | ''                 | ''               | 'Size TR'                   | 'Size1'          |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6627e05132' | 'No'           | 'ValueStorage' | 'No'        | 'Type'                   | ''                 | ''               | 'Type TR'                   | 'V123445'        |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f662dd9dbe5' | 'No'           | 'ValueStorage' | 'Yes'       | 'Brand'                  | ''                 | ''               | 'Brand TR'                  | 'V123446'        |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f662dd9dbe6' | 'No'           | 'ValueStorage' | 'No'        | 'Producer'               | ''                 | ''               | 'Producer TR'               | 'V123447'        |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f6647920801' | 'No'           | 'ValueStorage' | 'No'        | 'Article'                | ''                 | ''               | 'Article TR'                | 'V123448'        |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f664e044467' | 'No'           | 'ValueStorage' | 'No'        | 'Country of consignment' | ''                 | ''               | 'Country of consignment TR' | 'V123449'        |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f665492c01f' | 'No'           | 'ValueStorage' | 'No'        | 'Season'                 | ''                 | ''               | 'Season TR'                 | 'V123450'        |
		| 'e1cib/data/ChartOfCharacteristicTypes.AddAttributeAndProperty?ref=86ffd69b4676df1211ea9f67a5f4db86' | 'No'           | 'ValueStorage' | 'No'        | 'width'                  | ''                 | ''               | 'width'                     | 'width'          |


Scenario: _005110 filling in the "UI groups" catalog 
# Catalog "UI group" is designed to create groups of additional attributes for the items. Also provides for the location of the group on the item's form (right or left)
	* Opening the UI groups creation form 
		Given I open hyperlink "e1cib/list/Catalog.InterfaceGroups"
		And I click the button named "FormCreate"
	* Creating UI groups: Product information, Accounting information
		And I click Open button of the field named "Description_en"
		And I input "Product information" text in the field named "Description_en"
		And I input "Product information TR" text in the field named "Description_tr"
		And I input "Информация о продукте" text in "RU" field
		And I click "Ok" button
		And I change the radio button named "FormPosition" value to "Left"
		And I click "Save" button
		* Check data save
			Then the form attribute named "FormPosition" became equal to "Left"
			Then the form attribute named "Picture" became equal to "Picture"
			Then the form attribute named "Description_en" became equal to "Product information"
		And I click "Save and close" button
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Accounting information" text in the field named "Description_en"
		And I input "Accounting information TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I change the radio button named "FormPosition" value to "Right"
		And I click "Save" button
		* Check data save
			Then the form attribute named "FormPosition" became equal to "Right"
			Then the form attribute named "Picture" became equal to "Picture"
			Then the form attribute named "Description_en" became equal to "Accounting information"
		And I click "Save and close" button
	* Check for added UI groups in the catalog 
		Then I check for the "InterfaceGroups" catalog element with the "Description_en" "Product information"  
		Then I check for the "InterfaceGroups" catalog element with the "Description_tr" "Product information TR"
		Then I check for the "InterfaceGroups" catalog element with the "Description_ru" "Информация о продукте"
		Then I check for the "InterfaceGroups" catalog element with the "Description_en" "Accounting information"  
		Then I check for the "InterfaceGroups" catalog element with the "Description_tr" "Accounting information TR"
	


Scenario: _005111 filling in the "Add attribute and property"
	* Opening the Add attribute and property creation form 
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
		And I click the button named "FormCreate"
		And Delay 5
	* Creating additional attribute Brand
		And I click Choice button of the field named "ValueType"
		And Delay 2
		And I go to line in "" table
				| ''       |
				| 'Additional attribute value' |
		And I click the button named "OK"
		And I click Open button of the field named "Description_en"
		And I input "Brand" text in the field named "Description_en"
		And I input "Brand TR" text in the field named "Description_tr"
		And I input "Бренд" text in the field named "Description_ru"
		And I click "Ok" button
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Brand"
			Then the form attribute named "ValueType" became equal to "Additional attribute value"
			And I wait the field named "UniqueID" will be filled in "3" seconds
		And I click the button named "FormWriteAndClose"
	* Creating additional attribute producer 
		And I click the button named "FormCreate"
		And I click Choice button of the field named "ValueType"
		And Delay 2
		And I go to line in "" table
				| ''       |
				| 'Additional attribute value' |
		And I click the button named "OK"
		And I click Open button of the field named "Description_en"
		And I input "Producer" text in the field named "Description_en"
		And I input "Producer TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Producer"
			Then the form attribute named "ValueType" became equal to "Additional attribute value"
			And I wait the field named "UniqueID" will be filled in "3" seconds
		And I click the button named "FormWriteAndClose"
	* Check for added additional attributes
			And "List" table contains lines
			| 'Description' |
			| 'Brand'       |
			| 'Producer'    |



		
Scenario: _005112 filling in Additional attribute values with type Additional attribute values
# the value of additional attributes (Producer, Color, Size,Season, Country of consignment)
	* Opening the Add attribute and property form
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
	* Adding value Producer
		And I go to line in "List" table
		| 'Description' |
		| 'Producer'      |
		And I select current line in "List" table
		And In this window I click command interface button "Additional attribute values"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "UNIQ" text in the field named "Description_en"
		And I input "UNIQ" text in the field named "Description_tr"
		And I input "UNIQ" text in "RU" field
		And I click "Ok" button
		And I click "Save" button
		* Check data save
			And I wait the field named "UniqueID" will be filled in "3" seconds
			Then the form attribute named "Owner" became equal to "Producer"
			Then the form attribute named "Description_en" became equal to "UNIQ"
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "PZU" text in the field named "Description_en"
		And I input "PZU" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And In this window I click command interface button "Main"
		And I click "Save and close" button
	* Adding value Brand
		And I go to line in "List" table
		| 'Description' |
		| 'Brand'      |
		And I select current line in "List" table
		And In this window I click command interface button "Additional attribute values"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "York" text in the field named "Description_en"
		And I input "York" text in the field named "Description_tr"
		And I input "York" text in "RU" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Gir" text in the field named "Description_en"
		And I input "Gir" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save" button
		* Check data save
			And I wait the field named "UniqueID" will be filled in "3" seconds
			Then the form attribute named "Owner" became equal to "Brand"
			Then the form attribute named "Description_en" became equal to "Gir"
		And I click "Save and close" button
		And Delay 2
		And In this window I click command interface button "Main"
		And I click "Save and close" button
	* Check for added additional attributes values
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertyValues"
		And "List" table contains lines
		| 'Additional attribute' | 'Description' |
		| 'Producer'             | 'UNIQ'        |
		| 'Producer'             | 'PZU'         |
		| 'Brand'                | 'York'        |
		| 'Brand'                | 'Gir'         |




Scenario: _005113 filling in the "Item types" catalog 
	* Opening the form for filling in Item types
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And Delay 2
		And I click the button named "FormCreate"
		And Delay 2
	* Creating item types: TV (Product), Smartphones (Product), Rent (Service)
		And I click Open button of the field named "Description_en"
		And I input "Smartphones" text in the field named "Description_en"
		And I input "Smartphones TR" text in the field named "Description_tr"
		And I input "Смартфоны" text in the field named "Description_ru"
		And I click "Ok" button
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Type" became equal to "Product"
			Then the form attribute named "Description_en" became equal to "Smartphones"
		And I click the button named "FormWriteAndClose"
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "TV set" text in the field named "Description_en"
		And I input "TV set TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Description_en" became equal to "TV set"
			Then the form attribute named "Type" became equal to "Product"
		And I click the button named "FormWriteAndClose"
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Rent (Service)" text in the field named "Description_en"
		And I input "Rent (Service) TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I change "Type" radio button value to "Service"
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Rent (Service)"
			Then the form attribute named "Type" became equal to "Service"
		And I click the button named "FormWriteAndClose"
	* Check for created elements
		Then I check for the "ItemTypes" catalog element with the "Description_en" "Smartphones"  
		Then I check for the "ItemTypes" catalog element with the "Description_tr" "Smartphones TR"
		Then I check for the "ItemTypes" catalog element with the "Description_ru" "Смартфоны"  
	* Create a group of item types
		* Create Item Type group
			And I click the button named "FormCreateFolder"
			And I click Open button of the field named "Description_en"
			And I input "Accessories" text in the field named "Description_en"
			And I input "Accessories TR" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
		* Create item type in group Accessories
			And I click the button named "FormCreate"
			And I click Open button of the field named "Description_en"
			And I input "Earrings" text in the field named "Description_en"
			And I input "Earrings TR" text in the field named "Description_tr"
			And I click "Ok" button
			And I select from "Parent" drop-down list by "Accessories" string
			And I click "Save and close" button
		* Create item type Earrings
			And I go to line in "List" table
				| 'Description' |
				| 'Accessories'            |
			And I move one level down in "List" table
			And "List" table contains lines
				| 'Description'    |
				| 'Accessories' |
				| 'Earrings'    |
			And I close all client application windows
	* Check the items group display in AddAttributeAndPropertySets by item key
			Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
			And I go to line in "List" table
			| 'Predefined data item name' |
			| 'Catalog_ItemKeys'          |
			And I select current line in "List" table
			And "AttributesTree" table contains lines
				| 'Presentation'      |
				| 'Accessories'    |
				| 'Earrings'       |
			And I close all client application windows


Scenario: _005114 filling in the settings for creating ItemKeys for Item type Closets and Shoes
# for clothes specify the color, for shoes - season
# It is indicated through the type of item with duplication in sets
	* Preparation
		When Create catalog ItemTypes objects (Clothes, Shoes)
		* Create Size AddAttributeAndProperty
			Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
			And I click the button named "FormCreate"
			And I click Choice button of the field named "ValueType"
			And Delay 2
			And I go to line in "" table
					| ''       |
					| 'Additional attribute value' |
			And I click the button named "OK"
			And I click Open button of the field named "Description_en"
			And I input "Size" text in the field named "Description_en"
			And I input "Size TR" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
		* Create Color AddAttributeAndProperty
			And I click the button named "FormCreate"
			And I click Choice button of the field named "ValueType"
			And Delay 2
			And I go to line in "" table
					| ''       |
					| 'Additional attribute value' |
			And I click the button named "OK"
			And I click Open button of the field named "Description_en"
			And I input "Color" text in the field named "Description_en"
			And I input "Color TR" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
		* Create Season AddAttributeAndProperty
			And I click the button named "FormCreate"
			And I click Choice button of the field named "ValueType"
			And Delay 2
			And I go to line in "" table
					| ''       |
					| 'Additional attribute value' |
			And I click the button named "OK"
			And I click Open button of the field named "Description_en"
			And I input "Season" text in the field named "Description_en"
			And I input "Season TR" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
	* Opening the form for filling in Item keys settings 
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
	* Item key creation options for Clothes
		And I go to line in "List" table
			| Description      |
			| Clothes |
		And I select current line in "List" table
		And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
		And I click choice button of "Attribute" attribute in "AvailableAttributes" table
		And I go to line in "List" table
			| Description |
			| Size      |
		And I select current line in "List" table
		And I finish line editing in "AvailableAttributes" table
		And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
		And I click choice button of "Attribute" attribute in "AvailableAttributes" table
		And I go to line in "List" table
			| Description |
			| Color      |
		And I select current line in "List" table
		And I finish line editing in "AvailableAttributes" table
		And I click "Save" button
		* Check data save
			Then the form attribute named "Type" became equal to "Product"
			Then the form attribute named "Description_en" became equal to "Clothes"
			And "AvailableAttributes" table became equal
				| 'Attribute' | 'Affect pricing' | 'Show in HTML' | 'Required' |
				| 'Size'      | 'No'             | 'No'           | 'No'       |
				| 'Color'     | 'No'             | 'No'           | 'No'       |
		And I click "Save and close" button
	* Item key creation options for Shoes
		And I go to line in "List" table
			| Description      |
			| Shoes |
		And I select current line in "List" table
		And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
		And I click choice button of "Attribute" attribute in "AvailableAttributes" table
		And I go to line in "List" table
			| Description |
			| Size      |
		And I select current line in "List" table
		And I finish line editing in "AvailableAttributes" table
		And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
		And I click choice button of "Attribute" attribute in "AvailableAttributes" table
		And I go to line in "List" table
			| Description |
			| Season      |
		And I select current line in "List" table
		And I finish line editing in "AvailableAttributes" table
		And I click "Save" button
		* Check data save
			Then the form attribute named "Type" became equal to "Product"
			Then the form attribute named "Description_en" became equal to "Shoes"
			And "AvailableAttributes" table became equal
				| 'Attribute' | 'Affect pricing' | 'Show in HTML' | 'Required' |
				| 'Size'      | 'No'             | 'No'           | 'No'       |
				| 'Season'    | 'No'             | 'No'           | 'No'       |
		And I click "Save and close" button
		And I close current window


Scenario: _005114 adding general additional attributes and properties for catalog Item
# AddAttributeAndPropertySets (Catalog_Items)
	* Preparation
		When Create catalog InterfaceGroups objects (Purchase and production,  Main information)
		* Create property Property 01
			Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
			And I click the button named "FormCreate"
			And I click Choice button of the field named "ValueType"
			And Delay 2
			And I go to line in "" table
					| ''       |
					| 'Additional attribute value' |
			And I click the button named "OK"
			And I click Open button of the field named "Description_en"
			And I input "Property 01" text in the field named "Description_en"
			And I click "Ok" button
			And I click "Save and close" button
	* Opening the form for adding additional attributes for Items
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| 'Predefined data item name' |
			| 'Catalog_Items'      |
		And I select current line in "List" table
	* Adding additional attributes
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| 'Description' |
			| 'Producer'  |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| 'Description' |
			| 'Brand'     |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
	* Distribution of added additional attributes by UI groups
		And I activate "UI group" field in "Attributes" table
		And I go to line in "Attributes" table
			| 'Attribute' |
			| 'Brand'   |
		And I select current line in "Attributes" table
		And I click choice button of "UI group" attribute in "Attributes" table
		And I go to line in "List" table
			| 'Description'      |
			| 'Purchase and production' |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I go to line in "Attributes" table
			| 'Attribute' |
			| 'Producer'     |
		And I select current line in "Attributes" table
		And I click choice button of "UI group" attribute in "Attributes" table
		And I go to line in "List" table
			| 'Description'      |
			| 'Main information' |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I click Open button of the field named "Description_en"
		And I input "Items" text in the field named "Description_en"
		And I input "Items" text in the field named "Description_tr"
		And I input "Номенклатура" text in "RU" field
		And I click "Ok" button
	* Adding additional property
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description' |
			| 'Property 01' |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
	* Check data save
		Then the form attribute named "Description_en" became equal to "Items"
		And "Attributes" table became equal
			| 'UI group'                | 'Attribute' | 'Required' | 'Show in HTML' |
			| 'Main information'        | 'Producer'  | 'No'       | 'No'           |
			| 'Purchase and production' | 'Brand'     | 'No'       | 'No'           |
		And "Properties" table became equal
			| 'Property'    | 'Show in HTML' |
			| 'Property 01' | 'No'           |
		And I click "Save and close" button
	* Check the display additional attributes in Item
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I click the button named "FormCreate"
		And field "Brand" exists
		And field "Producer" exists
		And I close all client application windows
		



Scenario: _005115 filling in the "Items" catalog 
	* Preparation
		When Create catalog ItemTypes objects (Clothes, Shoes)
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Units objects (box (8 pcs))
	* Opening the form for creating Items
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I click the button named "FormCreate"
		And Delay 2
	* Test item creation Bodie
		And I click Open button of the field named "Description_en"
		And I input "Bodie" text in the field named "Description_en"
		And I input "Bodie TR" text in the field named "Description_tr"
		And I input "Боди" text in the field named "Description_ru"
		And I click "Ok" button
		And I click Choice button of the field named "ItemType"
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'       |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I go to line in "List" table
			| 'Description' |
			| 'box (8 pcs)' |
		And I select current line in "List" table
		And I click Select button of "Producer" field
		And I go to line in "List" table
			| 'Description' |
			| 'UNIQ'        |
		And I select current line in "List" table
		And I click Select button of "Brand" field
		And I go to line in "List" table
			| 'Description' |
			| 'Gir'        |
		And I select current line in "List" table
		And I input "AB475590i" text in "Item ID" field
		And I click Select button of "Vendor" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I click the button named "FormWrite"
	* Check data save
		Then the form attribute named "ItemID" became equal to "AB475590i"
		Then the form attribute named "ItemType" became equal to "Clothes"
		Then the form attribute named "Unit" became equal to "box (8 pcs)"
		Then the form attribute named "Vendor" became equal to "Ferron BP"
		Then the form attribute named "Description_en" became equal to "Bodie"
		If "Brand" field is equal to "Gir" Then
		If "Producer" field is equal to "UNIQ" Then
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Test item creation Sneakers
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Sneakers" text in the field named "Description_en"
		And I input "Sneakers TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Choice button of the field named "ItemType"
		And I go to line in "List" table
				| 'Description' |
				| 'Clothes'       |
		And I select current line in "List" table
		And I go to line in "List" table
			| 'Description' |
			| 'box (8 pcs)' |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
	* Check Items save
		And "List" table became equal
		| 'Description' | 'Item type' |
		| 'Bodie'       | 'Clothes'   |
		| 'Sneakers'    | 'Clothes'   |


// доделать после того как будет загрузка планов видов характеристик

Scenario: _005117 filling in Item keys
# Dress, Trousers
	Given I open hyperlink "e1cib/list/Catalog.Items"
	* Filling in Item keys for Dress
		And I go to line in "List" table
		| 'Description'      |
		| 'Dress' |
		And I select current line in "List" table
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item keys (create) *" window closing in 20 seconds
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| 'XS'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| 'M'           |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| 'L'           |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| 'XL'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| 'S'        |
		And I select current line in "List" table
		And I click Select button of "Color" field
		And I select current line in "List" table
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Item key' |
			| 'XS'       |
		And I select current line in "List" table
		And I click Select button of "Color" field
		And I go to line in "List" table
			| 'Description' |
			| 'Blue'        |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "XS (Item key) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| 'M'        |
		And I select current line in "List" table
		And I click Select button of "Color" field
		And I go to line in "List" table
			| 'Description' |
			| 'White'       |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "M (Item key) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| 'L'        |
		And I select current line in "List" table
		And I click Select button of "Color" field
		And I go to line in "List" table
			| 'Description' |
			| 'Green'       |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "L (Item key) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| 'XL'       |
		And I select current line in "List" table
		And I click Select button of "Color" field
		And I go to line in "List" table
			| 'Description' |
			| 'Green'       |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "XL (Item key) *" window closing in 20 seconds
		And In this window I click command interface button "Main"
		And I click "Save and close" button
		And I wait "Dress (Item)" window closing in 20 seconds
	* Filling in Item keys for Trousers
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description' | 'Item type' |
			| 'Trousers'    | 'Clothes'   |
		And I select current line in "List" table
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| '36'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| '38'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| '36'       |
		And I select current line in "List" table
		And I click Select button of "Color" field
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "* (Item key) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| '38'       |
		And I select current line in "List" table
		And I click Select button of "Color" field
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "* (Item key) *" window closing in 20 seconds
		And In this window I click command interface button "Main"
		And I click "Save and close" button
		And I wait "Trousers (Item)" window closing in 20 seconds
		And I go to line in "List" table
			| 'Description' | 'Item type' |
			| 'Shirt'       | 'Clothes'   |
		And I select current line in "List" table
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| '36'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| '38'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| '36'       |
		And I select current line in "List" table
		And I click Select button of "Color" field
		And I go to line in "List" table
			| 'Description' |
			| 'Red'         |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "* (Item key) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| '38'       |
		And I select current line in "List" table
		And I click Select button of "Color" field
		And I go to line in "List" table
			| 'Description' |
			| 'Black'       |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "* (Item key) *" window closing in 20 seconds
		Then "Shirt (Item)" window is opened
		And In this window I click command interface button "Main"
		And I click "Save and close" button
		And Delay 5
		And I go to line in "List" table
			| 'Description' | 'Item type' |
			| 'Boots'       | 'Shoes'     |
		And I select current line in "List" table
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| '36'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| '37'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| '38'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| '39'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| '36'       |
		And I select current line in "List" table
		And I click Select button of "Season" field
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "* (Item key) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| '37'       |
		And I select current line in "List" table
		And I click Select button of "Season" field
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "* (Item key) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| '38'       |
		And I select current line in "List" table
		And I click Select button of "Season" field
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "* (Item key) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| '39'       |
		And I select current line in "List" table
		And I click Select button of "Season" field
		And I click the button named "FormChoose"
		And I click "Save and close" button
		And I wait "* (Item key) *" window closing in 20 seconds
		And In this window I click command interface button "Main"
		And I click "Save and close" button
		And Delay 5
		And I go to line in "List" table
			| 'Description' | 'Item type' |
			| 'High shoes'  | 'Shoes'     |
		And I select current line in "List" table
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| '39'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I select current line in "List" table
		And I click Select button of "Season" field
		And I go to line in "List" table
			| 'Description' |
			| '19SD'        |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "* (Item key) *" window closing in 20 seconds
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| '37'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I select current line in "List" table
		And I click Select button of "Season" field
		And I go to line in "List" table
			| 'Description' |
			| '19SD'        |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "* (Item key) *" window closing in 20 seconds
		And In this window I click command interface button "Main"
		And I click "Save and close" button
		And Delay 5

		

Scenario: _005119 packaging for High shoes
	* Opening the form for creating Item units
		Given I open hyperlink "e1cib/list/Catalog.Units"
	* Create packaging High shoes box (8 pcs)
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "High shoes box (8 pcs)" text in the field named "Description_en"
		And I input "High shoes box (8 adet) TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Select button of "Item" field
		And I go to line in "List" table
			| 'Description' |
			| 'High shoes'  |
		And I select current line in "List" table
		And I click Select button of "Basis unit" field
		And I go to line in "List" table
			| 'Description' |
			| 'pcs'      |
		And I select current line in "List" table
		And I input "8" text in "Quantity" field
		And I click "Save and close" button
	* Create packaging Boots (12 pcs)
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Boots (12 pcs)" text in the field named "Description_en"
		And I input "Boots (12 adet) TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Select button of "Item" field
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'  |
		And I select current line in "List" table
		And I click Select button of "Basis unit" field
		And I go to line in "List" table
			| 'Description' |
			| 'pcs'      |
		And I select current line in "List" table
		And I input "12" text in "Quantity" field
		And I click "Save and close" button
	And I close current window

Scenario: _005120 set Closets/Shoes specification creation
# Set is a dimensional grid, set to the type of item
	* Create a specification for Clothes
		Given I open hyperlink "e1cib/list/Catalog.Specifications"
		And I click the button named "FormCreate"
		And I change "Type" radio button value to "Set"
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'     |
		And I select current line in "List" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		And I select current line in "List" table
		And I activate "Color" field in "FormTable*" table
		And I click choice button of "Color" attribute in "FormTable*" table
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "1,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		And I go to line in "List" table
			| 'Description' |
			| 'XS'          |
		And I select current line in "List" table
		And I activate "Color" field in "FormTable*" table
		And I click choice button of "Color" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Blue'        |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "1,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'M'           |
		And I select current line in "List" table
		And I activate "Color" field in "FormTable*" table
		And I click choice button of "Color" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Brown'       |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "2,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'L'           |
		And I select current line in "List" table
		And I activate "Color" field in "FormTable*" table
		And I click choice button of "Color" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Green'       |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "2,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And I click Open button of the field named "Description_en"
		And I input "A-8" text in the field named "Description_en"
		And I input "A-8" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 10
	* Create a specification for Shoes
		Given I open hyperlink "e1cib/list/Catalog.Specifications"
		And I click the button named "FormCreate"
		And I change "Type" radio button value to "Set"
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| 'Description' |
			| 'Shoes'       |
		And I select current line in "List" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		And I go to line in "List" table
			| Description |
			| 36          |
		And I select current line in "List" table
		And I activate "Season" field in "FormTable*" table
		And I click choice button of "Season" attribute in "FormTable*" table
		And I go to line in "List" table
			| 'Description' |
			| '18SD'        |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "1,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		And I go to line in "List" table
			| 'Description' |
			| '37'          |
		And I select current line in "List" table
		And I activate "Season" field in "FormTable*" table
		And I click choice button of "Season" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description' |
			| '18SD'        |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "1,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		And I go to line in "List" table
			| 'Description' |
			| '38'          |
		And I select current line in "List" table
		And I activate "Season" field in "FormTable*" table
		And I click choice button of "Season" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description' |
			| '18SD'        |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "1,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		And I go to line in "List" table
			| 'Description' |
			| '39'          |
		And I select current line in "List" table
		And I activate "Season" field in "FormTable*" table
		And I click choice button of "Season" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description' |
			| '18SD'        |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "1,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And I click Open button of the field named "Description_en"
		And I input "S-8" text in the field named "Description_en"
		And I input "S-8" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 10

Scenario: _005121 filling item key according to specification for set
	* Opening the Dress element in the Items catalog
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description' | 'Item type' |
			| 'Dress'       | 'Clothes'   |
		And I select current line in "List" table
	* Creating for Dress a new item key for the specification
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		And I change checkbox "Specification"
		And I click Choice button of the field named "Specification"
		And "List" table does not contain lines
			| 'Description' | 'Type' |
			| 'S-8'         | 'Set'  |
		And I go to line in "List" table
			| 'Description' | 'Type' |
			| 'A-8'         | 'Set'  |
		And I select current line in "List" table
		And I click "Save and close" button
		And Delay 5
		And "List" table contains lines
			| 'Item key'   |
			| 'Dress/A-8'  |
		And I close current window
	* Opening the Boots element in the Items catalog
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description' | 'Item type' |
			| 'Boots'       | 'Shoes'   |
		And I select current line in "List" table
	* Creating for Boots a new item key for the specification
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		And I change checkbox "Specification"
		And I click Choice button of the field named "Specification"
		And "List" table does not contain lines
			| 'Description' | 'Type' |
			| 'A-8'         | 'Set'  |
		And I go to line in "List" table
			| 'Description' | 'Type' |
			| 'S-8'         | 'Set'  |
		And I select current line in "List" table
		And I click "Save and close" button
		And Delay 5
		And "List" table contains lines
			| 'Item key'   |
			| 'Boots/S-8'  |
		And I close current window