#language: en
@tree
@IgnoreOnCIMainBuild
@ExportScenarios

Feature: offset mechanism check helpers (library)

// Assert subscenarios for "_1007 advances closing mechanism" (features/Internal/_1001 Advance).
// They are called as one-line steps from inside "Check the steps for Exception" XFAIL wrappers,
// because a step with an inline table cannot be nested into the wrapper directly.
// Each helper relies on the $$NumberClosing*2022$$ variables saved by the _1007 scenarios.

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: Check the January 2022 advance is not offset again by the overlapping closing
	// Correct behavior: the second closing (period 01.01.2022-28.02.2022, overlaps January)
	// must not create one more offset for Sales invoice 61 which is already closed by the January closing.
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2021B_CustomersTransactions"
	And "List" table does not contain lines
		| 'Recorder'                                    | 'Customers advances closing'                                                        |
		| 'Sales invoice 61 dated 15.01.2022 12:00:00'  | 'Customers advance closing $$NumberClosingFeb2022$$ dated 28.02.2022 12:00:00'      |
	And I close all client application windows

Scenario: Check Sales invoice 62 is offset by its order advance
	// Correct behavior: the invoice issued by Sales order 61 is closed by the advance
	// tied to that order (Bank receipt 63), so the advance expense row carries Order = Sales order 61.
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2020B_AdvancesFromCustomers"
	And "List" table contains lines
		| 'Recorder'                                    | 'Multi currency movement type' | 'Order'                                    | 'Amount'    | 'Customers advances closing'                                                        |
		| 'Sales invoice 62 dated 10.03.2022 12:00:00'  | 'Local currency'               | 'Sales order 61 dated 01.03.2022 12:00:00' | '1 000,00'  | 'Customers advance closing $$NumberClosingMar2022$$ dated 31.03.2022 12:00:00'      |
	And I close all client application windows

Scenario: Check Sales invoice 63 is offset by the free advance
	// Correct behavior: the free advance (Bank receipt 62) is not burned on the order invoice,
	// so it remains available and closes Sales invoice 63 in the same March closing.
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2021B_CustomersTransactions"
	And "List" table contains lines
		| 'Recorder'                                    | 'Multi currency movement type' | 'Basis'                                       | 'Amount'    | 'Customers advances closing'                                                        |
		| 'Sales invoice 63 dated 11.03.2022 12:00:00'  | 'Local currency'               | 'Sales invoice 63 dated 11.03.2022 12:00:00'  | '1 000,00'  | 'Customers advance closing $$NumberClosingMar2022$$ dated 31.03.2022 12:00:00'      |
	And I close all client application windows
